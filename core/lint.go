package core

import (
	"bufio"
	"bytes"
	"errors"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
	"sync"

	"github.com/ValeLint/vale/util"
	"github.com/gobwas/glob"
	"github.com/jdkato/prose/tokenize"
)

// Lint src according to its format.
func (l *Linter) Lint(src string, pat string) ([]File, error) {
	var linted []File

	done := make(chan File)
	defer close(done)
	glob, gerr := glob.Compile(pat)
	if gerr != nil {
		glob = nil
	}
	filesChan, errc := l.lintFiles(done, src, glob)
	for f := range filesChan {
		linted = append(linted, f)
	}
	if err := <-errc; err != nil {
		return nil, err
	}

	if util.CLConfig.Sorted {
		sort.Sort(ByName(linted))
	}
	return linted, nil
}

func (l *Linter) lintFiles(done <-chan File, root string, glob glob.Glob) (<-chan File, <-chan error) {
	filesChan := make(chan File)
	errc := make(chan error, 1)
	go func() {
		var wg sync.WaitGroup
		err := filepath.Walk(root, func(fp string, fi os.FileInfo, err error) error {
			if err != nil || fi.IsDir() {
				return nil
			} else if glob == nil || !glob.Match(fp) {
				// The file doesn't match or the user provided a malformed glob
				// pattern.
				return nil
			}
			wg.Add(1)
			go func() {
				select {
				case filesChan <- l.lintFile(fp):
				case <-done:
				}
				wg.Done()
			}()
			// Abort the walk if done is closed.
			select {
			case <-done:
				return errors.New("walk canceled")
			default:
				return nil
			}
		})
		// Walk has returned, so all calls to wg.Add are done.  Start a
		// goroutine to close c once all the sends are done.
		go func() {
			wg.Wait()
			close(filesChan)
		}()
		errc <- err
	}()
	return filesChan, errc
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
	for sec, styles := range util.Config.SBaseStyles {
		pat, err := glob.Compile(sec)
		if util.CheckError(err, sec) && pat.Match(src) {
			baseStyles = styles
			break
		}
	}

	checks := make(map[string]bool)
	for sec, smap := range util.Config.SChecks {
		pat, err := glob.Compile(sec)
		if util.CheckError(err, sec) && pat.Match(src) {
			checks = smap
			break
		}
	}

	scanner := bufio.NewScanner(f)
	scanner.Split(tokenize.SplitLines)
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
			cmd := util.Which([]string{"rst2html", "rst2html.py"})
			runtime := util.Which([]string{"python", "py", "python.exe"})
			if cmd != "" && runtime != "" {
				file.lintRST(runtime, cmd)
			}
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
	text := util.PrepText(txt)
	senScope := "sentence" + f.RealExt
	parScope := "paragraph" + f.RealExt
	txtScope := "text" + f.RealExt
	hasCtx := ctx != ""
	for _, p := range strings.SplitAfter(text, "\n\n") {
		for _, s := range sentenceTokenizer.RawTokenize(p) {
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
	bullet := regexp.MustCompile(`^(?:[*-]\s\w|\d[).]\s\w)`)
	lines := 1
	for f.Scanner.Scan() {
		line = f.Scanner.Text() + "\n"
		if !bullet.MatchString(line) && line != "\n" {
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
