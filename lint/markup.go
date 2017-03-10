package lint

import (
	"bytes"
	"io/ioutil"
	"os/exec"
	"regexp"
	"strings"

	"github.com/ValeLint/vale/core"
	"github.com/russross/blackfriday"
	"golang.org/x/net/html"
)

// reCodeBlock is used to convert Sphinx-style code directives to the regular
// `::` for rst2html.
var reCodeBlock = regexp.MustCompile(`.. (?:raw|code(?:-block)?):: (\w+)`)

// Blackfriday configuration.
var commonHTMLFlags = 0 | blackfriday.HTML_USE_XHTML
var commonExtensions = 0 |
	blackfriday.EXTENSION_NO_INTRA_EMPHASIS |
	blackfriday.EXTENSION_TABLES |
	blackfriday.EXTENSION_FENCED_CODE
var renderer = blackfriday.HtmlRenderer(commonHTMLFlags, "", "")
var options = blackfriday.Options{Extensions: commonExtensions}

func (l Linter) lintHTMLTokens(f *core.File, rawBytes []byte, fBytes []byte) {
	var txt string
	var tokt html.TokenType
	var tok html.Token
	var inBlock, shouldSkip, isHeading bool

	ctx := core.PrepText(string(rawBytes))
	heading := regexp.MustCompile(`^h\d$`)
	skip := []string{"script", "style", "pre", "code", "tt"}
	lines := strings.Count(ctx, "\n") + 1

	tokens := html.NewTokenizer(bytes.NewReader(fBytes))
	for {
		tokt = tokens.Next()
		tok = tokens.Token()
		txt = core.PrepText(html.UnescapeString(strings.TrimSpace(tok.Data)))
		shouldSkip = core.StringInSlice(txt, skip)
		if tokt == html.ErrorToken {
			break
		} else if tokt == html.StartTagToken && shouldSkip {
			inBlock = true
		} else if shouldSkip && inBlock {
			inBlock = false
		} else if tokt == html.StartTagToken && heading.MatchString(txt) {
			isHeading = true
		} else if tokt == html.EndTagToken && isHeading {
			isHeading = false
		} else if tokt == html.TextToken && isHeading && !inBlock && txt != "" {
			l.lintText(f, NewBlock(ctx, txt, "heading"+f.RealExt), lines, 0)
		} else if tokt == html.TextToken && !inBlock && txt != "" {
			l.lintProse(f, ctx, txt, lines, 0)
		}
		ctx = updateCtx(ctx, txt, tokt, tok)
	}
}

func updateCtx(ctx string, txt string, tokt html.TokenType, tok html.Token) string {
	if tok.Data == "img" || tok.Data == "a" {
		for _, a := range tok.Attr {
			if a.Key == "alt" || a.Key == "href" {
				ctx = core.Substitute(ctx, a.Val, "*")
			}
		}
	} else if tokt == html.TextToken {
		for _, s := range strings.Split(txt, "\n") {
			ctx = core.Substitute(ctx, s, "*")
		}
	}
	return ctx
}

func (l Linter) lintHTML(f *core.File) {
	b, err := ioutil.ReadFile(f.Path)
	if !core.CheckError(err, f.Path) {
		return
	}
	l.lintHTMLTokens(f, b, b)
}

func (l Linter) lintMarkdown(f *core.File) {
	b, err := ioutil.ReadFile(f.Path)
	if !core.CheckError(err, f.Path) {
		return
	}
	l.lintHTMLTokens(f, b, blackfriday.MarkdownOptions(b, renderer, options))
}

func (l Linter) lintRST(f *core.File, python string, rst2html string) {
	var out bytes.Buffer
	b, err := ioutil.ReadFile(f.Path)
	if !core.CheckError(err, f.Path) {
		return
	}
	cmd := exec.Command(
		python, rst2html, "--quiet", "--halt=5", "--link-stylesheet")
	cmd.Stdin = bytes.NewReader(reCodeBlock.ReplaceAll(b, []byte("::")))
	cmd.Stdout = &out
	if core.CheckError(cmd.Run(), f.Path) {
		l.lintHTMLTokens(f, b, out.Bytes())
	}
}

func (l Linter) lintADoc(f *core.File, asciidoctor string) {
	var out bytes.Buffer
	b, err := ioutil.ReadFile(f.Path)
	if !core.CheckError(err, f.Path) {
		return
	}
	cmd := exec.Command(asciidoctor, "--no-header-footer", "--safe", "-")
	cmd.Stdin = bytes.NewReader(b)
	cmd.Stdout = &out
	if core.CheckError(cmd.Run(), f.Path) {
		l.lintHTMLTokens(f, b, out.Bytes())
	}
}
