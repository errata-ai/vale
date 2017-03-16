package lint

import (
	"bufio"
	"bytes"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
	"sync"

	"github.com/ValeLint/vale/check"
	"github.com/ValeLint/vale/core"
	"github.com/gobwas/glob"
	"github.com/jdkato/prose/tokenize"
	jww "github.com/spf13/jwalterweatherman"
)

// A Linter lints a File.
type Linter struct{}

// A Block represents a section of text.
type Block struct {
	Context string        // parent content (if any) - e.g., paragraph -> sentence
	Text    string        // text content
	Scope   core.Selector // section selector
}

// NewBlock makes a new Block with prepared text and a Selector.
func NewBlock(ctx string, txt string, sel string) Block {
	txt = core.PrepText(txt)
	if ctx == "" {
		ctx = txt
	} else {
		ctx = core.PrepText(ctx)
	}
	return Block{Context: ctx, Text: txt, Scope: core.Selector{Value: sel}}
}

// Lint src according to its format.
func (l Linter) Lint(src string, pat string) ([]core.File, error) {
	var linted []core.File
	var negate bool

	done := make(chan core.File)
	defer close(done)
	if strings.HasPrefix(pat, "!") {
		pat = strings.TrimLeft(pat, "!")
		negate = true
	}
	g, gerr := glob.Compile(pat)
	if !core.CheckError(gerr, "can't compile glob!") {
		return linted, gerr
	}
	glob := core.Glob{Pattern: g, Negated: negate}
	filesChan, errc := l.lintFiles(done, src, glob)
	for f := range filesChan {
		linted = append(linted, f)
	}
	if err := <-errc; err != nil {
		return nil, err
	}

	if core.CLConfig.Sorted {
		sort.Sort(core.ByName(linted))
	}
	return linted, nil
}

func (l Linter) lintFiles(done <-chan core.File, root string, glob core.Glob) (<-chan core.File, <-chan error) {
	filesChan := make(chan core.File)
	errc := make(chan error, 1)
	go func() {
		var wg sync.WaitGroup
		err := filepath.Walk(root, func(fp string, fi os.FileInfo, err error) error {
			if err != nil || fi.IsDir() {
				return nil
			} else if glob.Pattern.Match(fp) == glob.Negated {
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

func (l Linter) lintFile(src string) core.File {
	var file core.File

	f, err := os.Open(src)
	if !core.CheckError(err, src) {
		return file
	}
	defer core.CheckAndClose(f)

	ext, format := core.FormatFromExt(src)
	baseStyles := core.Config.GBaseStyles
	for sec, styles := range core.Config.SBaseStyles {
		pat, err := glob.Compile(sec)
		if core.CheckError(err, "can't compile glob!") && pat.Match(src) {
			baseStyles = styles
			break
		}
	}

	checks := make(map[string]bool)
	for sec, smap := range core.Config.SChecks {
		pat, err := glob.Compile(sec)
		if core.CheckError(err, "can't compile glob!") && pat.Match(src) {
			checks = smap
			break
		}
	}

	scanner := bufio.NewScanner(f)
	scanner.Split(tokenize.SplitLines)
	file = core.File{
		Path: src, NormedExt: ext, Format: format, RealExt: filepath.Ext(src),
		BaseStyles: baseStyles, Checks: checks, Scanner: scanner,
	}

	l.lintFormat(&file)
	return file
}

func (l Linter) lintFormat(file *core.File) {
	if file.Format == "text" {
		l.lintPlainText(file)
	} else if file.Format == "markup" {
		switch file.NormedExt {
		case ".adoc":
			cmd := core.Which([]string{"asciidoctor", "asciidoc"})
			if cmd != "" {
				l.lintADoc(file, cmd)
			} else {
				jww.ERROR.Println("asciidoctor not found!")
			}
		case ".md":
			l.lintMarkdown(file)
		case ".rst":
			cmd := core.Which([]string{"rst2html", "rst2html.py"})
			runtime := core.Which([]string{"python", "py", "python.exe"})
			if cmd != "" && runtime != "" {
				l.lintRST(file, runtime, cmd)
			} else {
				jww.ERROR.Println(fmt.Sprintf(
					"can't run rst2html: (%s, %s)!", runtime, cmd))
			}
		case ".html":
			l.lintHTML(file)
		case ".tex":
			cmd := core.Which([]string{"pandoc"})
			if cmd != "" {
				l.lintLaTeX(file, cmd)
			} else {
				jww.ERROR.Println("pandoc not found!")
			}
		}
	} else if file.Format == "code" {
		l.lintCode(file)
	} else {
		l.lintLines(file)
	}
}

func (l Linter) lintProse(f *core.File, ctx string, txt string, lnTotal int, lnLength int) {
	var b Block
	text := core.PrepText(txt)
	senScope := "sentence" + f.RealExt
	parScope := "paragraph" + f.RealExt
	txtScope := "text" + f.RealExt
	hasCtx := ctx != ""
	for _, p := range strings.SplitAfter(text, "\n\n") {
		for _, s := range core.SentenceTokenizer.RawTokenize(p) {
			if hasCtx {
				b = NewBlock(ctx, s.Text, senScope)
			} else {
				b = NewBlock(p, s.Text, senScope)
			}
			l.lintText(f, b, lnTotal, lnLength)
		}
		l.lintText(f, NewBlock(ctx, p, parScope), lnTotal, lnLength)
	}
	l.lintText(f, NewBlock(ctx, text, txtScope), lnTotal, lnLength)
}

func (l Linter) lintPlainText(f *core.File) {
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
			l.lintProse(f, "", paragraph.String(), lines, 0)
			inBlock = 0
			paragraph.Reset()
		} else if line != "\n" {
			l.lintText(f, NewBlock("", line, "text"+f.RealExt), lines+1, 0)
		}
		lines++
	}
	if inBlock == 1 {
		l.lintProse(f, "", paragraph.String(), lines, 0)
	}
}

func (l Linter) lintLines(f *core.File) {
	var line string
	lines := 1
	for f.Scanner.Scan() {
		line = f.Scanner.Text() + "\n"
		l.lintText(f, NewBlock("", line, "text"+f.RealExt), lines+1, 0)
		lines++
	}
}

func (l Linter) lintText(f *core.File, blk Block, lines int, pad int) {
	var style string
	var run bool

	ctx := blk.Context
	txt := blk.Text
	min := core.Config.MinAlertLevel
	f.ChkToCtx = make(map[string]string)
	for name, chk := range check.AllChecks {
		style = strings.Split(name, ".")[0]
		run = false

		if chk.Level < min || !blk.Scope.Contains(chk.Scope) {
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
		if val, ok := core.Config.GChecks[name]; ok && !run {
			if !val {
				continue
			}
			run = true
		}

		if !run && !core.StringInSlice(style, f.BaseStyles) {
			continue
		}

		for _, a := range chk.Rule(txt, f) {
			f.AddAlert(a, ctx, txt, lines, pad)
		}
	}
}
