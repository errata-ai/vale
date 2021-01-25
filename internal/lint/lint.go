package lint

import (
	"errors"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"

	"github.com/errata-ai/vale/v2/internal/check"
	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/pkg/glob"
	"github.com/karrick/godirwalk"
	"github.com/remeh/sizedwaitgroup"
)

// A Linter lints a File.
type Linter struct {
	Manager *check.Manager

	seen map[string]bool
	glob *glob.Glob

	client *http.Client
	pids   []int
	temps  []*os.File

	nonGlobal bool
}

type lintResult struct {
	file *core.File
	err  error
}

// NewLinter initializes a Linter.
func NewLinter(cfg *core.Config) (*Linter, error) {
	mgr, err := check.NewManager(cfg)

	globalStyles := len(cfg.GBaseStyles)
	globalChecks := len(cfg.GChecks)

	return &Linter{
		Manager: mgr,

		client:    http.DefaultClient,
		nonGlobal: globalStyles+globalChecks == 0}, err
}

// LintString src according to its format.
func (l *Linter) LintString(src string) ([]*core.File, error) {
	linted := l.lintFile(src)
	return []*core.File{linted.file}, linted.err
}

// Lint src according to its format.
func (l *Linter) Lint(input []string, pat string) ([]*core.File, error) {
	var linted []*core.File

	done := make(chan core.File)
	defer close(done)

	gp, err := glob.NewGlob(pat)
	if err != nil {
		return linted, err
	}

	if err := l.setup(); err != nil {
		return linted, err
	}

	l.glob = &gp
	for _, src := range input {
		filesChan, errChan := l.lintFiles(done, src)

		for result := range filesChan {
			if result.err != nil {
				l.teardown()
				return linted, result.err
			} else if l.Manager.Config.Flags.Normalize {
				result.file.Path = filepath.ToSlash(result.file.Path)
			}
			linted = append(linted, result.file)
		}

		if err := <-errChan; err != nil {
			l.teardown()
			return linted, err
		}
	}

	l.teardown()
	return linted, nil
}

// lintFiles walks the `root` directory, creating a new goroutine to lint any
// file that matches the given glob pattern.
func (l *Linter) lintFiles(done <-chan core.File, root string) (<-chan lintResult, <-chan error) {
	filesChan := make(chan lintResult)
	errChan := make(chan error, 1)

	go func() {
		wg := sizedwaitgroup.New(5)

		err := godirwalk.Walk(root, &godirwalk.Options{
			Callback: func(fp string, de *godirwalk.Dirent) error {
				if de.IsDir() && core.ShouldIgnoreDirectory(fp) {
					return godirwalk.SkipThis
				} else if de.IsDir() || l.skip(fp) {
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
			},
			Unsorted:            true,
			AllowNonDirectory:   true,
			FollowSymbolicLinks: true,
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

	if file.Format == "markup" && !l.Manager.Config.Flags.Simple {
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
			err = l.lintHTML(file)
		}
	} else if file.Format == "code" && !l.Manager.Config.Flags.Simple {
		l.lintCode(file)
	} else {
		l.lintLines(file)
	}

	return lintResult{file, err}
}

func (l *Linter) lintProse(f *core.File, parent core.Block, lines int) {
	var b core.Block

	// FIXME: This is required for paragraphs that lack a newline delimiter:
	//
	// p1
	// p2
	//
	// See fixtures/i18n for an example.
	needsLookup := strings.Count(parent.Text, "\n") > 0

	text := core.Sanitize(parent.Text)
	if l.Manager.HasScope("paragraph") || l.Manager.HasScope("sentence") {
		for _, p := range strings.SplitAfter(text, "\n\n") {
			for _, s := range core.SentenceTokenizer.Tokenize(p) {
				b = core.NewLinedBlock(
					parent.Context,
					strings.TrimSpace(s),
					"sentence"+f.RealExt,
					parent.Line)
				l.lintBlock(f, b, lines, 0, needsLookup)
			}
			b = core.NewLinedBlock(
				parent.Context,
				p,
				"paragraph"+f.RealExt,
				parent.Line)
			l.lintBlock(f, b, lines, 0, needsLookup)
		}
	}

	b = core.NewLinedBlock(parent.Context, text, "text"+f.RealExt, parent.Line)
	l.lintBlock(f, b, lines, 0, needsLookup)
}

func (l *Linter) lintLines(f *core.File) {
	block := core.NewBlock("", f.Content, "text"+f.RealExt)
	l.lintBlock(f, block, len(f.Lines), 0, true)
}

func (l *Linter) lintBlock(f *core.File, blk core.Block, lines, pad int, lookup bool) {
	var wg sync.WaitGroup

	f.ChkToCtx = make(map[string]string)

	results := make(chan core.Alert)
	for name, chk := range l.Manager.Rules() {
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
		}(blk.Text, name, f, chk)
	}

	go func() {
		wg.Wait()
		close(results)
	}()

	for a := range results {
		f.AddAlert(a, blk, lines, pad, lookup)
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

// setup handles any necessary building, compiling, or pre-processing.
func (l *Linter) setup() error {
	if l.Manager.Config.SphinxAuto != "" {
		parts := strings.Split(l.Manager.Config.SphinxAuto, " ")
		return exec.Command(parts[0], parts[1:]...).Run()
	}
	return nil
}

func (l *Linter) teardown() error {
	for _, pid := range l.pids {
		if p, err := os.FindProcess(pid); err == nil {
			if p.Kill() != nil {
				return err
			}
		}
	}

	for _, f := range l.temps {
		if err := os.Remove(f.Name()); err != nil {
			return err
		}
	}

	return nil
}

func (l *Linter) match(s string) bool {
	if l.glob == nil {
		return true
	}
	return l.glob.Match(s)
}

func (l *Linter) skip(fp string) bool {
	var ext string

	old := filepath.Ext(fp)
	if normed, found := l.Manager.Config.Formats[strings.Trim(old, ".")]; found {
		ext = "." + normed
		fp = fp[0:len(fp)-len(old)] + ext
	}

	fp = filepath.ToSlash(fp)
	if !l.match(fp) {
		return true
	} else if l.nonGlobal {
		for _, pat := range l.Manager.Config.SecToPat {
			if pat.Match(fp) {
				return false
			}
		}
		return true
	}

	return false
}
