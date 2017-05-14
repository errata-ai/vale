/*
Package lint implements Vale's syntax-aware linting functionality.

The package is split into core linting logic (this file), source code
(code.go), and markup (markup.go). The general flow is as follows:

    Lint (files and directories)     LintString (stdin)
                \                   /
                 lintFiles         /
                         \        /
                          +      +
    +-------------------+ lintFile ------+|lintMarkdown|lintADoc|lintRST
    |                    /    |    \       |            |       /
    |                   /     |     \      |           /       /
    |                  /      |      \     |          +--------
    |                 /       |       \    |         /
    |                +        +        +   +        +
    |               lintCode  lintLines  lintHTML
    |               |         |              |
    |               |         |              +
    |                \        |         lintProse
    |                 \       |        /
    |                  +      +       +
    |                      lintText
    |   <= add Alerts{}       |
    +-------------------------+
*/
package lint

import (
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"github.com/ValeLint/vale/check"
	"github.com/ValeLint/vale/core"
	"github.com/remeh/sizedwaitgroup"
)

// A Linter lints a File.
type Linter struct{}

// A Block represents a section of text.
type Block struct {
	Context string        // parent content (if any) - e.g., sentence -> paragraph
	Text    string        // text content
	Scope   core.Selector // section selector
}

// NewBlock makes a new Block with prepared text and a Selector.
func NewBlock(ctx string, txt string, sel string) Block {
	if ctx == "" {
		ctx = txt
	}
	return Block{Context: ctx, Text: txt, Scope: core.Selector{Value: sel}}
}

// LintString src according to its format.
func (l Linter) LintString(src string) ([]*core.File, error) {
	return []*core.File{l.lintFile(src)}, nil
}

// Lint src according to its format.
func (l Linter) Lint(src string, pat string) ([]*core.File, error) {
	var linted []*core.File

	done := make(chan core.File)
	defer close(done)

	filesChan, errc := l.lintFiles(done, src, core.NewGlob(pat))
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

// lintFiles walks the `root` directory, creating a new goroutine to lint any
// file that matches the given glob pattern.
func (l Linter) lintFiles(done <-chan core.File, root string, glob core.Glob) (<-chan *core.File, <-chan error) {
	filesChan := make(chan *core.File)
	errc := make(chan error, 1)
	ignore := []string{".", "_"}
	go func() {
		wg := sizedwaitgroup.New(5)
		err := filepath.Walk(root, func(fp string, fi os.FileInfo, err error) error {
			if err != nil || fi.IsDir() {
				return nil
			} else if !glob.Match(fp) || core.HasAnyPrefix(fi.Name(), ignore) {
				return nil
			}
			wg.Add()
			go func(fp string) {
				select {
				case filesChan <- l.lintFile(fp):
				case <-done:
				}
				wg.Done()
			}(fp)
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

// lintFile creates a new `File` from the path `src` and selects a linter based
// on its format.
//
// TODO: remove dependencies on `asciidoctor` and `rst2html`.
func (l Linter) lintFile(src string) *core.File {
	file := core.NewFile(src)
	if file.Format == "markup" && !core.CLConfig.Simple {
		switch file.NormedExt {
		case ".adoc":
			cmd := core.Which([]string{"asciidoctor"})
			if cmd != "" {
				l.lintADoc(file, cmd)
			} else {
				fmt.Println("asciidoctor not found!")
			}
		case ".md":
			l.lintMarkdown(file)
		case ".rst":
			cmd := core.Which([]string{"rst2html", "rst2html.py"})
			runtime := core.Which([]string{"python", "py", "python.exe"})
			if cmd != "" && runtime != "" {
				l.lintRST(file, runtime, cmd)
			} else {
				fmt.Println(fmt.Sprintf("can't run rst2html: (%s, %s)!", runtime, cmd))
			}
		case ".html":
			l.lintHTML(file)
		}
	} else if file.Format == "code" && !core.CLConfig.Simple {
		l.lintCode(file)
	} else {
		l.lintLines(file)
	}
	return file
}

func (l Linter) lintProse(f *core.File, ctx string, txt string, lnTotal int, lnLength int) {
	var b Block
	text := core.PrepText(txt)
	senScope := "sentence" + f.RealExt
	parScope := "paragraph" + f.RealExt
	txtScope := "text" + f.RealExt
	hasCtx := ctx != ""
	for _, p := range strings.SplitAfter(text, "\n\n") {
		for _, s := range core.SentenceTokenizer.Tokenize(p) {
			sent := strings.TrimSpace(s.Text)
			if hasCtx {
				b = NewBlock(ctx, sent, senScope)
			} else {
				b = NewBlock(p, sent, senScope)
			}
			l.lintText(f, b, lnTotal, lnLength)
		}
		l.lintText(f, NewBlock(ctx, p, parScope), lnTotal, lnLength)
	}
	l.lintText(f, NewBlock(ctx, text, txtScope), lnTotal, lnLength)
}

func (l Linter) lintLines(f *core.File) {
	var line string
	lines := 1
	for f.Scanner.Scan() {
		line = core.PrepText(f.Scanner.Text() + "\n")
		l.lintText(f, NewBlock("", line, "text"+f.RealExt), lines+1, 0)
		lines++
	}
}

func (l Linter) lintText(f *core.File, blk Block, lines int, pad int) {
	var style string
	var run bool

	ctx := blk.Context
	txt := core.PrepText(blk.Text)
	min := core.Config.MinAlertLevel
	f.ChkToCtx = make(map[string]string)
	for name, chk := range check.AllChecks {
		style = strings.Split(name, ".")[0]
		run = false

		// It has been disabled via an in-text comment.
		if f.QueryComments(name) {
			continue
		}

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
