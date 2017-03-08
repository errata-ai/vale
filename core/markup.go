package core

import (
	"bytes"
	"io/ioutil"
	"os/exec"
	"regexp"
	"strings"

	"github.com/ValeLint/vale/util"
	"github.com/russross/blackfriday"
	"golang.org/x/net/html"
)

// reCodeBlock is used to convert Sphinx-style code directives to the regular
// `::` for rst2html.
var reCodeBlock = regexp.MustCompile(`.. code(?:-block)?:: (\w+)`)

// Blackfriday configuration.
var commonHTMLFlags = 0 | blackfriday.HTML_USE_XHTML
var commonExtensions = 0 |
	blackfriday.EXTENSION_NO_INTRA_EMPHASIS |
	blackfriday.EXTENSION_TABLES |
	blackfriday.EXTENSION_FENCED_CODE
var renderer = blackfriday.HtmlRenderer(commonHTMLFlags, "", "")
var options = blackfriday.Options{Extensions: commonExtensions}

func lintHTMLTokens(f *File, rawBytes []byte, fBytes []byte) {
	var txt string
	var tokt html.TokenType
	var tok html.Token
	var inBlock, shouldSkip, isHeading bool

	ctx := util.PrepText(string(rawBytes))
	heading := regexp.MustCompile(`^h\d$`)
	skip := []string{"script", "style", "pre", "code", "tt"}
	lines := strings.Count(ctx, "\n") + 1

	tokens := html.NewTokenizer(bytes.NewReader(fBytes))
	for {
		tokt = tokens.Next()
		tok = tokens.Token()
		txt = util.PrepText(html.UnescapeString(strings.TrimSpace(tok.Data)))
		shouldSkip = util.StringInSlice(txt, skip)
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
			f.lintText(NewBlock(ctx, txt, "heading"+f.RealExt), lines, 0)
		} else if tokt == html.TextToken && !inBlock && txt != "" {
			f.lintProse(ctx, txt, lines, 0)
		}
		ctx = updateCtx(ctx, txt, tokt, tok)
	}
}

func updateCtx(ctx string, txt string, tokt html.TokenType, tok html.Token) string {
	if tok.Data == "img" || tok.Data == "a" {
		for _, a := range tok.Attr {
			if a.Key == "alt" || a.Key == "href" {
				ctx = util.Substitute(ctx, a.Val, "*")
			}
		}
	} else if tokt == html.TextToken {
		for _, s := range strings.Split(txt, "\n") {
			ctx = util.Substitute(ctx, s, "*")
		}
	}
	return ctx
}

func (f *File) lintHTML() {
	b, err := ioutil.ReadFile(f.Path)
	if !util.CheckError(err, f.Path) {
		return
	}
	lintHTMLTokens(f, b, b)
}

func (f *File) lintMarkdown() {
	b, err := ioutil.ReadFile(f.Path)
	if !util.CheckError(err, f.Path) {
		return
	}
	lintHTMLTokens(f, b, blackfriday.MarkdownOptions(b, renderer, options))
}

func (f *File) lintRST(python string, rst2html string) {
	var out bytes.Buffer
	b, err := ioutil.ReadFile(f.Path)
	if !util.CheckError(err, f.Path) {
		return
	}
	cmd := exec.Command(
		python, rst2html, "--quiet", "--halt=5", "--link-stylesheet")
	cmd.Stdin = bytes.NewReader(reCodeBlock.ReplaceAll(b, []byte("::")))
	cmd.Stdout = &out
	if util.CheckError(cmd.Run(), f.Path) {
		lintHTMLTokens(f, b, out.Bytes())
	}
}

func (f *File) lintADoc() {
	var paragraph bytes.Buffer
	var line, syntax string
	var isMarkup, inList bool
	var mat []string

	literal := regexp.MustCompile(`^\.\.\.\.`)
	listing := regexp.MustCompile(`^----`)
	code := regexp.MustCompile(`^\[\w+,\s*(\w+)\]`)
	indentStart := regexp.MustCompile("^ +[^.]+")
	list := regexp.MustCompile(`^\s*(\*+|\.|\-)\s.+`)
	prose := regexp.MustCompile("^([a-zA-Z()`]|" + `\*\*\w+)`)
	markup := []string{
		":", "[", "ifdef", "endif", "=====", "____", "+", "image:"}
	heading := regexp.MustCompile(`^=+\s*\w*`)
	hSetext := regexp.MustCompile(`^(?:=|-){6,}\s*$`)
	inBlock := 0
	lines := 1
	prev := ""

	log := util.NewLogger()
	for f.Scanner.Scan() {
		line = f.Scanner.Text() + "\n"
		log.Info(line)
		isMarkup = util.HasAnyPrefix(line, markup) || strings.Contains(line, "::")
		if inBlock == 0 {
			if mat = code.FindStringSubmatch(line); len(mat) > 0 {
				log.Info("^ Code start")
				inBlock = 1
				syntax = mat[1]
			} else if literal.MatchString(line) {
				log.Info("^ Literal start")
				inBlock = 2
			} else if listing.MatchString(line) {
				log.Info("^ Listing start")
				inBlock = 3
			} else if list.MatchString(line) && !inList {
				log.Info("^ List start; linting line...")
				f.lintText(NewBlock("", line, "text"+f.RealExt), lines+1, 0)
				inList = true
			} else if inList && line == "\n" {
				log.Info("^ List end")
				inList = false
			} else if indentStart.MatchString(line) && !inList {
				log.Info("^ Indent start")
				inBlock = 4
			} else if heading.MatchString(line) {
				log.Info("^ Linting heading")
				f.lintText(NewBlock("", line, "text.heading"+f.RealExt), lines, 0)
			} else if prose.MatchString(line) && !isMarkup && !inList {
				log.Info("^ Paragraph start")
				paragraph.WriteString(line)
				inBlock = 5
			} else if line != "\n" && !isMarkup {
				log.Info("^ Linting single line")
				f.lintText(NewBlock("", line, "text"+f.RealExt), lines+1, 0)
			}
		} else if syntax != "" && listing.MatchString(line) && inBlock == 1 {
			log.Info("^ Listing with syntax; trying to lint...")
			linted, lns := f.lintCodeblock(syntax, lines, listing)
			f.Alerts = append(f.Alerts, linted...)
			if lines != lns {
				log.Info("^ Listing end (from lintCode)")
				syntax = ""
				lines = lns
				inBlock = 0
			}
		} else if inBlock == 2 && literal.MatchString(line) {
			log.Info("^ Literal end")
			inBlock = 0
		} else if inBlock == 3 && listing.MatchString(line) {
			log.Info("^ Listing end")
			inBlock = 0
		} else if inBlock == 4 && !strings.HasPrefix(line, " ") {
			log.Info("^ Block end")
			inBlock = 0
		} else if inBlock == 5 && !prose.MatchString(line) {
			if hSetext.MatchString(line) {
				f.lintText(NewBlock("", prev, "text.heading"+f.RealExt), lines, 0)
				log.Info("^ Not a paragraph; linting setext heading")
				paragraph.Reset()
			} else {
				log.Info("^ Linting paragraph")
				f.lintProse("", paragraph.String(), lines, 0)
				paragraph.Reset()
			}
			inBlock = 0
		} else if inBlock == 5 {
			log.Info("^ Adding to paragraph")
			paragraph.WriteString(line)
		}
		lines++
		prev = line
	}
	if inBlock == 5 {
		log.Info("^ Linting paragraph")
		f.lintProse("", paragraph.String(), lines, 0)
	}
}
