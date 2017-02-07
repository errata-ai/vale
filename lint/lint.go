package lint

import (
	"bufio"
	"bytes"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/gobwas/glob"
	"github.com/jdkato/txtlint/util"
)

// Lint src according to its format.
func (l *Linter) Lint(src string) ([]File, error) {
	var linted []File

	glob := glob.MustCompile(util.CLConfig.Glob)
	err := filepath.Walk(src,
		func(fp string, fi os.FileInfo, err error) error {
			if err != nil || fi.IsDir() {
				return err
			} else if glob.Match(fp) {
				linted = append(linted, l.lintFile(fp))
			}
			return nil
		},
	)
	return linted, err
}

func (l *Linter) lintFile(src string) File {
	var file File

	f, err := os.Open(src)
	if !util.CheckError(err, src) {
		return file
	}
	defer util.CheckAndClose(f)

	ext, format := util.FormatFromExt(src)
	baseStyles := util.Config.GBaseStyles
	for pat, styles := range util.Config.SBaseStyles {
		if pat.Match(src) {
			baseStyles = styles
			break
		}
	}

	checks := make(map[string]bool)
	for pat, smap := range util.Config.SChecks {
		if pat.Match(src) {
			checks = smap
			break
		}
	}

	scanner := bufio.NewScanner(f)
	scanner.Split(util.ScanLines)
	file = File{
		Path: src, NormedExt: ext, Format: format, RealExt: filepath.Ext(src),
		BaseStyles: baseStyles, Checks: checks, Scanner: scanner,
	}

	if format == "text" {
		file.lintPlainText()
	} else if format == "markup" {
		switch ext {
		case ".adoc":
			file.lintADoc()
		case ".md":
			file.lintMarkdown()
		case ".rst":
			file.lintRST()
		case ".html":
			file.lintHTML()
		case ".tex":
			file.lintLines()
		}
	} else if format == "code" {
		file.lintCode(0, regexp.MustCompile(`$^`))
	}

	return file
}

func (f *File) lintProse(ctx string, txt string, lnTotal int, lnLength int) {
	var b Block
	if STokenizer == nil {
		return
	}
	text := util.PrepText(txt)
	senScope := "sentence" + f.RealExt
	parScope := "paragraph" + f.RealExt
	txtScope := "text" + f.RealExt
	hasCtx := ctx != ""
	paragraphs := strings.SplitAfter(text, "\n\n")
	for _, p := range paragraphs {
		sentences := STokenizer.Tokenize(p)
		for _, s := range sentences {
			if hasCtx {
				b = NewBlock(ctx, s.Text, senScope)
			} else {
				b = NewBlock(p, s.Text, senScope)
			}
			f.lintText(b, lnTotal, lnLength)
		}
		f.lintText(NewBlock(ctx, p, parScope), lnTotal, lnLength)
	}
	f.lintText(NewBlock(ctx, text, txtScope), lnTotal, lnLength)
}

func (f *File) lintPlainText() {
	var paragraph bytes.Buffer
	var line string

	inBlock := 0
	prose := regexp.MustCompile("^([a-zA-Z_()`])")
	lines := 1
	for f.Scanner.Scan() {
		line = f.Scanner.Text() + "\n"
		if prose.MatchString(line) {
			paragraph.WriteString(line)
			inBlock = 1
		} else if line == "\n" && inBlock == 1 {
			f.lintProse("", paragraph.String(), lines, 0)
			inBlock = 0
			paragraph.Reset()
		} else if line != "\n" {
			f.lintText(NewBlock("", line, "text"+f.RealExt), lines+1, 0)
		}
		lines++
	}
	if inBlock == 1 {
		f.lintProse("", paragraph.String(), lines, 0)
	}
}

func (f *File) lintLines() {
	var line string
	lines := 1
	for f.Scanner.Scan() {
		line = f.Scanner.Text() + "\n"
		f.lintText(NewBlock("", line, "text"+f.RealExt), lines+1, 0)
		lines++
	}
}

func (f *File) lintText(blk Block, lines int, pad int) {
	var style string
	var run bool

	ctx := blk.Context
	txt := blk.Text
	min := util.Config.MinAlertLevel
	for name, chk := range AllChecks {
		style = strings.Split(name, ".")[0]
		run = false

		if chk.level < min || !blk.Scope.Contains(chk.scope) {
			continue
		}

		// Has the check been disabled for this extension?
		if val, ok := f.Checks[name]; ok && !run {
			if !val {
				continue
			}
			run = true
		}

		// Has the check been disabled for all extensions?
		if val, ok := util.Config.GChecks[name]; ok && !run {
			if !val && !run {
				continue
			} else if val && !run {
				run = true
			}
		}

		if !run && !util.StringInSlice(style, f.BaseStyles) {
			continue
		}

		for _, a := range chk.rule(txt, f) {
			a.Line, a.Span = util.FindLoc(lines, ctx, txt, f.NormedExt, a.Span, pad)
			f.Alerts = append(f.Alerts, a)
		}
	}
}
