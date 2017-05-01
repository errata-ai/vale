package lint

import (
	"bytes"
	"os/exec"
	"strings"
	"unicode"
	"unicode/utf8"

	"github.com/ValeLint/vale/core"
	"github.com/russross/blackfriday"
	"golang.org/x/net/html"
	"matloob.io/regexp"
)

// reStructuredText configuration.
//
// reCodeBlock is used to convert Sphinx-style code directives to the regular
// `::` for rst2html.
var reCodeBlock = regexp.MustCompile(`.. (?:raw|code(?:-block)?):: (\w+)`)
var rstArgs = []string{
	"--quiet",
	"--halt=5",
	"--report=5",
	"--link-stylesheet",
	"--no-file-insertion",
	"--no-toc-backlinks",
	"--no-footnote-backlinks",
	"--no-section-numbering",
}

// AsciiDoc configuration.
var adocArgs = []string{
	"-s",
	"--quiet",
	"--safe-mode",
	"secure",
	"-",
}

// Blackfriday configuration.
var commonHTMLFlags = 0 | blackfriday.HTML_USE_XHTML
var commonExtensions = 0 |
	blackfriday.EXTENSION_NO_INTRA_EMPHASIS |
	blackfriday.EXTENSION_TABLES |
	blackfriday.EXTENSION_FENCED_CODE
var renderer = blackfriday.HtmlRenderer(commonHTMLFlags, "", "")
var options = blackfriday.Options{Extensions: commonExtensions}

// HTML configuration.
var heading = regexp.MustCompile(`^h\d$`)

// skipTags are tags that we don't want to lint.
var skipTags = []string{"script", "style", "pre", "figure", "code", "tt"}
var inlineTags = []string{
	"b", "big", "i", "small", "abbr", "acronym", "cite", "dfn", "em", "kbd",
	"strong", "a", "br", "img", "span", "sub", "sup"}
var tagToScope = map[string]string{
	"th": "text.table.heading",
	"tr": "text.table.cell",
	"li": "text.list",
}

func (l Linter) lintHTMLTokens(f *core.File, ctx string, fsrc []byte, offset int) {
	var txt string
	var tokt html.TokenType
	var tok html.Token
	var inBlock, inline bool

	lines := len(f.Lines) + offset
	buf := bytes.NewBufferString("")
	queue := []string{}

	tokens := html.NewTokenizer(bytes.NewReader(fsrc))
	for {
		tokt = tokens.Next()
		tok = tokens.Token()
		txt = html.UnescapeString(strings.TrimSpace(tok.Data))

		if tokt == html.ErrorToken {
			break
		} else if tokt == html.StartTagToken && core.StringInSlice(txt, skipTags) {
			inBlock = true
		} else if inBlock && core.StringInSlice(txt, skipTags) {
			inBlock = false
		} else if tokt == html.StartTagToken {
			inline = core.StringInSlice(txt, inlineTags)
		} else if tokt == html.CommentToken {
			f.UpdateComments(txt)
		} else if tokt == html.TextToken {
			queue = append(queue, txt)
			if !inBlock {
				first, _ := utf8.DecodeRuneInString(txt)
				// Only add a space for non-punctuation. NOTE: we may want to
				// use JaroWinkler here (instead of later), but we'll need to
				// store position information to avoid duplicating work.
				if inline && !unicode.IsPunct(first) {
					txt = " " + txt
				}
				buf.WriteString(txt)
			}
		}

		if tokt == html.EndTagToken && !core.StringInSlice(txt, inlineTags) {
			content := buf.String()
			if content != "" {
				l.lintScope(f, ctx, content, txt, lines)
			}
			for _, s := range queue {
				ctx = updateCtx(ctx, s, html.TextToken)
			}
			queue = []string{}
			buf.Reset()
		}

		ctx = clearElements(ctx, tok)
	}
}

func (l Linter) lintScope(f *core.File, ctx, txt, tag string, lines int) {
	if heading.MatchString(tag) {
		l.lintText(f, NewBlock(ctx, txt, "text.heading"+f.RealExt), lines, 0)
	} else if scope, match := tagToScope[tag]; match {
		l.lintText(f, NewBlock(ctx, txt, scope+f.RealExt), lines, 0)
	} else {
		l.lintProse(f, ctx, txt, lines, 0)
	}
}

func clearElements(ctx string, tok html.Token) string {
	if tok.Data == "img" || tok.Data == "a" {
		for _, a := range tok.Attr {
			if a.Key == "alt" || a.Key == "href" {
				ctx = updateCtx(ctx, a.Val, html.TextToken)
			}
		}
	}
	return ctx
}

func updateCtx(ctx string, txt string, tokt html.TokenType) string {
	var found bool
	if (tokt == html.TextToken || tokt == html.CommentToken) && txt != "" {
		for _, s := range strings.Split(txt, "\n") {
			ctx, found = core.Substitute(ctx, s)
			if !found {
				for _, w := range strings.Fields(s) {
					ctx, _ = core.Substitute(ctx, w)
				}
			}
		}
	}
	return ctx
}

func (l Linter) lintHTML(f *core.File) {
	l.lintHTMLTokens(f, f.Content, []byte(f.Content), 0)
}

func (l Linter) lintMarkdown(f *core.File) {
	html := blackfriday.MarkdownOptions([]byte(f.Content), renderer, options)
	l.lintHTMLTokens(f, f.Content, html, 0)
}

func (l Linter) lintRST(f *core.File, python string, rst2html string) {
	var out bytes.Buffer
	cmd := exec.Command(python, append([]string{rst2html}, rstArgs...)...)
	cmd.Stdin = strings.NewReader(reCodeBlock.ReplaceAllString(f.Content, "::"))
	cmd.Stdout = &out
	if core.CheckError(cmd.Run()) {
		l.lintHTMLTokens(f, f.Content, out.Bytes(), 0)
	}
}

func (l Linter) lintADoc(f *core.File, asciidoctor string) {
	var out bytes.Buffer
	cmd := exec.Command(asciidoctor, adocArgs...)
	cmd.Stdin = strings.NewReader(f.Content)
	cmd.Stdout = &out
	if core.CheckError(cmd.Run()) {
		l.lintHTMLTokens(f, f.Content, out.Bytes(), 0)
	}
}
