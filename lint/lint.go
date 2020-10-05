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
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strings"
	"sync"

	"github.com/errata-ai/vale/check"
	"github.com/errata-ai/vale/config"
	"github.com/errata-ai/vale/core"
	"github.com/remeh/sizedwaitgroup"
)

// A Linter lints a File.
type Linter struct {
	Manager *check.Manager
}

type lintResult struct {
	file *core.File
	err  error
}

// NewLinter initializes a Linter.
func NewLinter(cfg *config.Config) (*Linter, error) {
	mgr, err := check.NewManager(cfg)
	return &Linter{Manager: mgr}, err
}

// LintString src according to its format.
func (l *Linter) LintString(src string) ([]*core.File, error) {
	linted := l.lintFile(src)
	return []*core.File{linted.file}, linted.err
}

// setupContent handles any necessary building, compiling, or pre-processing.
func (l *Linter) setupContent() error {
	if l.Manager.Config.SphinxAuto != "" {
		parts := strings.Split(l.Manager.Config.SphinxAuto, " ")
		return exec.Command(parts[0], parts[1:]...).Run()
	}
	return nil
}

// Lint src according to its format.
func (l *Linter) Lint(input []string, pat string) ([]*core.File, error) {
	var linted []*core.File

	done := make(chan core.File)
	defer close(done)

	if err := l.setupContent(); err != nil {
		return linted, err
	}

	for _, src := range input {
		if !(core.IsDir(src) || core.FileExists(src)) {
			continue
		}

		gp, err := core.NewGlob(pat)
		if err != nil {
			return linted, err
		}

		filesChan, errChan := l.lintFiles(done, src, gp)
		for result := range filesChan {
			if result.err != nil {
				return linted, result.err
			} else if l.Manager.Config.Normalize {
				result.file.Path = filepath.ToSlash(result.file.Path)
			}
			linted = append(linted, result.file)
		}

		if err := <-errChan; err != nil {
			return linted, err
		}
	}

	if l.Manager.Config.Sorted {
		sort.Sort(core.ByName(linted))
	}

	return linted, nil
}

// lintFiles walks the `root` directory, creating a new goroutine to lint any
// file that matches the given glob pattern.
func (l *Linter) lintFiles(done <-chan core.File, root string, glob core.Glob) (<-chan lintResult, <-chan error) {
	filesChan := make(chan lintResult)
	errChan := make(chan error, 1)
	nonGlobal := len(l.Manager.Config.GBaseStyles) == 0 && len(l.Manager.Config.GChecks) == 0

	seen := make(map[string]bool)
	go func() {
		wg := sizedwaitgroup.New(5)
		err := filepath.Walk(root, func(fp string, fi os.FileInfo, err error) error {
			ext := filepath.Ext(fp)
			if err != nil || fi.IsDir() {
				return nil
			} else if skip, found := seen[ext]; found && skip {
				return nil
			} else if !glob.Match(fp) {
				seen[ext] = true
				return nil
			} else if nonGlobal {
				found := false
				for _, pat := range l.Manager.Config.SecToPat {
					if pat.Match(fp) {
						found = true
					}
				}
				if !found {
					seen[ext] = true
					return nil
				}
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
		errChan <- err
	}()

	return filesChan, errChan
}

// lintFile creates a new `File` from the path `src` and selects a linter based
// on its format.
func (l *Linter) lintFile(src string) lintResult {
	var err error

	file, err := core.NewFile(src, l.Manager.Config)
	if err != nil {
		return lintResult{err: err}
	} else if len(file.Checks) == 0 && len(file.BaseStyles) == 0 {
		if len(l.Manager.Config.GBaseStyles) == 0 && len(l.Manager.Config.GChecks) == 0 {
			// There's nothing to do; bail early.
			return lintResult{file: file}
		}
	}

	if file.Format == "markup" && !l.Manager.Config.Simple {
		switch file.NormedExt {
		case ".adoc":
			err = l.lintADoc(file)
		case ".md":
			err = l.lintMarkdown(file)
		case ".rst":
			err = l.lintRST(file)
		case ".xml":
			err = l.lintXML(file)
		case ".dita":
			err = l.lintDITA(file)
		case ".html":
			l.lintHTML(file)
		}
	} else if file.Format == "code" && !l.Manager.Config.Simple {
		l.lintCode(file)
	} else {
		l.lintLines(file)
	}

	return lintResult{file, err}
}

func (l *Linter) lintProse(f *core.File, ctx, txt, raw string, lnTotal, lnLength int) {
	var b core.Block

	text := core.PrepText(txt)
	rawText := core.PrepText(raw)

	if l.Manager.HasScope("paragraph") || l.Manager.HasScope("sentence") {
		senScope := "sentence" + f.RealExt
		hasCtx := ctx != ""
		for _, p := range strings.SplitAfter(text, "\n\n") {
			for _, s := range core.SentenceTokenizer.Tokenize(p) {
				sent := strings.TrimSpace(s)
				if hasCtx {
					b = core.NewBlock(ctx, sent, "", senScope)
				} else {
					b = core.NewBlock(p, sent, "", senScope)
				}
				l.lintText(f, b, lnTotal, lnLength)
			}
			l.lintText(
				f,
				core.NewBlock(ctx, p, "", "paragraph"+f.RealExt),
				lnTotal,
				lnLength)
		}
	}

	l.lintText(
		f,
		core.NewBlock(ctx, text, rawText, "text"+f.RealExt),
		lnTotal,
		lnLength)
}

func (l *Linter) lintLines(f *core.File) {
	var line string
	lines := 1
	for f.Scanner.Scan() {
		line = core.PrepText(f.Scanner.Text() + "\n")
		l.lintText(f, core.NewBlock("", line, "", "text"+f.RealExt), lines+1, 0)
		lines++
	}
}

func (l *Linter) lintText(f *core.File, blk core.Block, lines int, pad int) {
	var txt string
	var wg sync.WaitGroup

	f.ChkToCtx = make(map[string]string)
	hasCode := core.StringInSlice(f.NormedExt, []string{".md", ".adoc", ".rst"})

	results := make(chan core.Alert)
	for name, chk := range l.Manager.Rules() {
		if chk.Fields().Code && hasCode && !l.Manager.Config.Simple {
			txt = blk.Raw
		} else {
			txt = blk.Text
		}

		if !l.shouldRun(name, f, chk, blk) {
			continue
		}

		wg.Add(1)
		go func(txt, name string, f *core.File, chk check.Rule) {
			info := chk.Fields()
			for _, a := range chk.Run(txt, f) {
				core.FormatAlert(&a, info.Limit, info.Level, name)
				results <- a
			}
			wg.Done()
		}(txt, name, f, chk)
	}

	go func() {
		wg.Wait()
		close(results)
	}()

	for a := range results {
		f.AddAlert(a, blk, lines, pad)
	}
}

func (l *Linter) shouldRun(name string, f *core.File, chk check.Rule, blk core.Block) bool {
	min := l.Manager.Config.MinAlertLevel
	run := false

	details := chk.Fields()
	if strings.Count(name, ".") > 1 {
		// NOTE: This fixes the loading issue with consistency checks.
		//
		// See #129.
		list := strings.Split(name, ".")
		name = strings.Join([]string{list[0], list[1]}, ".")
	}

	// It has been disabled via an in-text comment.
	if f.QueryComments(name) {
		return false
	} else if core.LevelToInt[details.Level] < min {
		return false
	} else if !blk.Scope.ContainsString(details.Scope) {
		return false
	}

	// Has the check been disabled for this extension?
	if val, ok := f.Checks[name]; ok && !run {
		if !val {
			return false
		}
		run = true
	}

	// Has the check been disabled for all extensions?
	if val, ok := l.Manager.Config.GChecks[name]; ok && !run {
		if !val {
			return false
		}
		run = true
	}

	style := strings.Split(name, ".")[0]
	if !run && !core.StringInSlice(style, f.BaseStyles) {
		return false
	}

	return true
}
