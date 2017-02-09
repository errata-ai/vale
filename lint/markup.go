package lint

import (
	"bytes"
	"io/ioutil"
	"regexp"
	"strings"

	"github.com/jdkato/txtlint/util"
	"golang.org/x/net/html"
)

func (f *File) lintHTML() {
	var txt string
	var tokt html.TokenType
	var inBlock, shouldSkip, isHeading bool

	heading := regexp.MustCompile(`^h\d$`)
	b, err := ioutil.ReadFile(f.Path)
	if !util.CheckError(err, f.Path) {
		return
	}

	skip := []string{"script", "style"}
	ctx := util.PrepText(string(b))
	lines := strings.Count(ctx, "\n") + 1
	tokens := html.NewTokenizer(strings.NewReader(ctx))

	for {
		tokt = tokens.Next()
		txt = strings.TrimSpace(tokens.Token().Data)
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
		if tokt == html.TextToken {
			ctx = strings.Replace(ctx, txt, strings.Repeat("*", len(txt)), 1)
		}
	}
}

func (f *File) lintMarkdown() {
	var paragraph bytes.Buffer
	var line string
	var isMarkup bool
	var mat []string

	fencedStart := regexp.MustCompile("^```" + `(\w+)?`)
	fencedEnd := regexp.MustCompile("```")
	indentStart := regexp.MustCompile("^( ){4,}")
	prose := regexp.MustCompile("^([a-zA-Z_()`]|" + `\*\*\w+)`)
	table := regexp.MustCompile(`^(\|.*\|)`)
	HTMLStart := regexp.MustCompile(`^<[^/]+>`)
	HTMLEnd := regexp.MustCompile(`^</.+>`)
	hATX := regexp.MustCompile(`^#+\s.+`)
	hSetext := regexp.MustCompile(`(?:=+\s*$|-+\s*$)`)
	inTable := false
	inBlock := 0
	lines := 1
	prev := ""

	log := util.NewLogger()
	for f.Scanner.Scan() {
		line = f.Scanner.Text() + "\n"
		log.Info(line)
		isMarkup = strings.HasPrefix(line, " ") || strings.HasPrefix(line, "<")
		if inBlock == 0 {
			if mat = fencedStart.FindStringSubmatch(line); len(mat) > 0 {
				log.Info("^ Fenced start")
				inBlock = 1
				if mat[1] != "" {
					log.Info("^ Found syntax; trying to lint")
					linted, lns := f.lintCodeblock(mat[1], lines, fencedEnd)
					f.Alerts = append(f.Alerts, linted...)
					if lines == lns {
						log.Info("^ Unknown syntax")
						inBlock = 1
					} else {
						log.Info("^ Known syntax; linted block")
						lines = lns
						inBlock = 0
					}
				}
			} else if indentStart.MatchString(line) {
				log.Info("^ Indented start")
				inBlock = 2
			} else if HTMLStart.MatchString(line) {
				log.Info("^ HTML start")
				inBlock = 4
			} else if !inTable && (table.MatchString(line) || strings.Count(line, "|") > 1) {
				log.Info("^ Table start")
				inTable = true
			} else if inTable && line == "\n" && (table.MatchString(prev) || strings.Count(prev, "|") > 1) {
				log.Info("^ Table end")
				inTable = false
			} else if hATX.MatchString(line) {
				log.Info("^ Linting ATX heading")
				f.lintText(NewBlock("", line, "text.heading"+f.RealExt), lines+1, 0)
			} else if prose.MatchString(line) && !inTable {
				log.Info("^ Paragraph start")
				paragraph.WriteString(line)
				inBlock = 3
			} else if line != "\n" && !isMarkup {
				log.Info("^ Linting single line")
				f.lintText(NewBlock("", line, "text"+f.RealExt), lines+1, 0)
			}
		} else if inBlock == 1 && fencedEnd.MatchString(line) {
			log.Info("^ Fenced end")
			inBlock = 0
		} else if inBlock == 4 && HTMLEnd.MatchString(line) {
			log.Info("^ HTML end")
			inBlock = 0
		} else if inBlock > 1 && inBlock != 4 && line == "\n" {
			log.Info("^ Block end")
			if inBlock == 3 {
				log.Info("^ Linting paragraph")
				f.lintProse("", paragraph.String(), lines, 0)
				paragraph.Reset()
			}
			inBlock = 0
		} else if inBlock == 3 {
			if hSetext.MatchString(line) {
				log.Info("^ Not a paragraph; linting setext heading")
				f.lintText(NewBlock("", prev, "heading"+f.RealExt), lines, 0)
				inBlock = 0
			} else {
				log.Info("^ Adding to paragraph")
				paragraph.WriteString(line)
			}
		}
		lines++
		prev = line
	}
	if inBlock == 3 {
		log.Info("^ Linting paragraph")
		f.lintProse("", paragraph.String(), lines, 0)
	}
}

func (f *File) lintADoc() {
	var paragraph bytes.Buffer
	var line, syntax string
	var isMarkup, inList bool
	var mat []string

	literal := regexp.MustCompile(`^\.\.\.\.`)
	listing := regexp.MustCompile(`^----`)
	code := regexp.MustCompile(`^\[\w+,(\w+)\]`)
	indentStart := regexp.MustCompile("^ +[^.]+")
	list := regexp.MustCompile(`^\s*(\*+|\.|\-)\s.+`)
	prose := regexp.MustCompile("^([a-zA-Z()`]|" + `\*\*\w+)`)
	markup := []string{":", "[", "ifdef", "endif", "=====", "____", "+", "image:"}
	inBlock := 0
	lines := 1

	for f.Scanner.Scan() {
		line = f.Scanner.Text() + "\n"
		isMarkup = util.HasAnyPrefix(line, markup) || strings.Contains(line, "::")
		if inBlock == 0 {
			if mat = code.FindStringSubmatch(line); len(mat) > 0 {
				inBlock = 1
				syntax = mat[1]
			} else if literal.MatchString(line) {
				inBlock = 2
			} else if listing.MatchString(line) {
				inBlock = 3
			} else if list.MatchString(line) && !inList {
				f.lintText(NewBlock("", line, "text"+f.RealExt), lines+1, 0)
				inList = true
			} else if inList && line == "\n" {
				inList = false
			} else if indentStart.MatchString(line) && !inList {
				inBlock = 4
			} else if prose.MatchString(line) && !isMarkup && !inList {
				paragraph.WriteString(line)
				inBlock = 5
			} else if line != "\n" && !isMarkup {
				f.lintText(NewBlock("", line, "text"+f.RealExt), lines+1, 0)
			}
		} else if syntax != "" && listing.MatchString(line) && inBlock == 1 {
			// A syntax has been set (e.g., [source,ruby]), so we can try to lint the
			// listing block.
			linted, lns := f.lintCodeblock(syntax, lines, listing)
			f.Alerts = append(f.Alerts, linted...)
			if lines != lns {
				syntax = ""
				lines = lns
				inBlock = 0
			}
		} else if inBlock == 2 && literal.MatchString(line) {
			inBlock = 0
		} else if inBlock == 3 && listing.MatchString(line) {
			inBlock = 0
		} else if inBlock == 4 && !strings.HasPrefix(line, " ") {
			inBlock = 0
		} else if inBlock == 5 && !prose.MatchString(line) {
			f.lintProse("", paragraph.String(), lines, 0)
			paragraph.Reset()
			inBlock = 0
		} else if inBlock == 5 {
			paragraph.WriteString(line)
		}
		lines++
	}
	if inBlock == 5 {
		f.lintProse("", paragraph.String(), lines, 0)
	}
}

func (f *File) lintRST() {
	var paragraph bytes.Buffer
	var line, syntax string
	var isMarkup bool
	var mat []string

	codeStart := regexp.MustCompile(`.. code(?:-block)?:: (\w+)`)
	indentStart := regexp.MustCompile(`^::\n$`)
	indentEnd := regexp.MustCompile(`^\n$`)
	highlight := regexp.MustCompile(`.. highlight:: (\w+)`)
	prose := regexp.MustCompile("^([a-zA-Z0-9_():`]|" + `\*\*)`)
	table := regexp.MustCompile(`^(=+\s+=+\n$|\+-.+-\+)`)
	hSetext := regexp.MustCompile(`(?:=|-|~|#)+\s*$`)
	inBlock := 0
	inTable := false
	lines := 1
	blankLines := 0

	prev := ""
	log := util.NewLogger()
	for f.Scanner.Scan() {
		line = f.Scanner.Text() + "\n"
		log.Info(line)
		isMarkup = strings.HasPrefix(line, " ") || strings.HasPrefix(line, "..")
		if inBlock == 0 {
			if mat = codeStart.FindStringSubmatch(line); len(mat) > 0 {
				log.Info("^ code block")
				inBlock = 1
				syntax = mat[1]
				blankLines = 1
			} else if indentStart.MatchString(line) {
				log.Info("^ indented block")
				inBlock = 2
				blankLines = 0
			} else if mat = highlight.FindStringSubmatch(line); len(mat) > 0 {
				if mat[1] != "none" {
					syntax = mat[1]
				} else {
					syntax = ""
				}
				log.Info("^ setting highlight to", syntax)
			} else if !inTable && table.MatchString(line) {
				log.Info("^ Table start")
				inTable = true
			} else if inTable && line == "\n" && table.MatchString(prev) {
				log.Info("^ Table end")
				inTable = false
			} else if prose.MatchString(line) && !inTable {
				log.Info("^ Paragraph start")
				inBlock = 3
				paragraph.WriteString(line)
			} else if line != "\n" && !isMarkup {
				log.Info("^ Linting single line")
				f.lintText(NewBlock("", line, "text"+f.RealExt), lines+1, 0)
			}
		} else if syntax != "" && line == "\n" && inBlock > 0 && inBlock < 3 {
			log.Info("^ Linting code")
			linted, lns := f.lintCodeblock(syntax, lines, indentEnd)
			f.Alerts = append(f.Alerts, linted...)
			if inBlock == 1 {
				syntax = ""
			}
			if lines != lns {
				log.Info("^ code end")
				lines = lns
				inBlock = 0
			}
		} else if inBlock > 0 && inBlock < 3 && line == "\n" && blankLines > 0 {
			log.Info("^ Block end")
			inBlock = 0
		} else if inBlock == 3 && line == "\n" {
			log.Info("^ Linting paragraph")
			f.lintProse("", paragraph.String(), lines, 0)
			paragraph.Reset()
			inBlock = 0
		} else if line == "\n" {
			blankLines++
		} else if inBlock == 3 {
			if hSetext.MatchString(line) {
				f.lintText(NewBlock("", prev, "heading"+f.RealExt), lines, 0)
				inBlock = 0
				log.Info("^ Not a paragraph; linting setext heading")
			} else {
				log.Info("^ Adding to paragraph")
				paragraph.WriteString(line)
			}
		}
		lines++
		prev = line
	}
	if inBlock == 3 {
		log.Info("^ Linting paragraph")
		f.lintProse("", paragraph.String(), lines, 0)
	}
}
