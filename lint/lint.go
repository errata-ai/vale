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
	"os/exec"
	"path/filepath"
	"sort"
	"strings"

	"github.com/errata-ai/vale/check"
	"github.com/errata-ai/vale/core"
	"github.com/remeh/sizedwaitgroup"
)

// A Linter lints a File.
type Linter struct {
	CheckManager *check.Manager // loaded checks
}

// NewLinter initializes a Linter.
func NewLinter(cfg *core.Config) *Linter {
	return &Linter{
		CheckManager: check.NewManager(cfg),
	}
}

// A Block represents a section of text.
type Block struct {
	Context string        // parent content - e.g., sentence -> paragraph
	Text    string        // text content
	Raw     string        // text content without any processing
	Scope   core.Selector // section selector
}

// NewBlock makes a new Block with prepared text and a Selector.
func NewBlock(ctx, txt, raw, sel string) Block {
	if ctx == "" {
		ctx = txt
	}
	return Block{
		Context: ctx, Text: txt, Raw: raw, Scope: core.Selector{Value: sel}}
}

// LintString src according to its format.
func (l *Linter) LintString(src string) ([]*core.File, error) {
	return []*core.File{l.lintFile(src)}, nil
}

// SetupContent handles any necessary building, compiling, or pre-processing.
func (l *Linter) SetupContent() error {
	if l.CheckManager.Config.SphinxAuto != "" {
		parts := strings.Split(l.CheckManager.Config.SphinxAuto, " ")
		return exec.Command(parts[0], parts[1:]...).Run()
	}
	return nil
}

// Lint src according to its format.
func (l *Linter) Lint(input []string, pat string) ([]*core.File, error) {
	var linted []*core.File

	done := make(chan core.File)
	defer close(done)

	if err := l.SetupContent(); err != nil {
		return linted, err
	}

	for _, src := range input {
		if !(core.IsDir(src) || core.FileExists(src)) {
			continue
		}

		filesChan, errc := l.lintFiles(
			done, src, core.NewGlob(pat, l.CheckManager.Config.Debug))

		for f := range filesChan {
			if l.CheckManager.Config.Normalize {
				f.Path = filepath.ToSlash(f.Path)
			}
			linted = append(linted, f)
		}
		if err := <-errc; err != nil {
			return nil, err
		}
	}

	if l.CheckManager.Config.Sorted {
		sort.Sort(core.ByName(linted))
	}

	return linted, nil
}

// lintFiles walks the `root` directory, creating a new goroutine to lint any
// file that matches the given glob pattern.
func (l *Linter) lintFiles(done <-chan core.File, root string, glob core.Glob) (<-chan *core.File, <-chan error) {
	filesChan := make(chan *core.File)
	errc := make(chan error, 1)
	nonGlobal := len(l.CheckManager.Config.GBaseStyles) == 0 && len(l.CheckManager.Config.GChecks) == 0
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
				for _, pat := range l.CheckManager.Config.SecToPat {
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
		errc <- err
	}()
	return filesChan, errc
}

// lintFile creates a new `File` from the path `src` and selects a linter based
// on its format.
//
// TODO: remove dependencies on `asciidoctor` and `rst2html`.
func (l *Linter) lintFile(src string) *core.File {
	file := core.NewFile(src, l.CheckManager.Config)
	if len(file.Checks) == 0 && len(file.BaseStyles) == 0 {
		if len(l.CheckManager.Config.GBaseStyles) == 0 && len(l.CheckManager.Config.GChecks) == 0 {
			// There's nothing to do; bail early.
			return file
		}
	}

	if file.Command != "" {
		// We've been given a custom command to execute.
		parts := strings.Split(file.Command, " ")
		exe := core.Which([]string{parts[0]})
		if exe != "" {
			l.lintCustom(file, exe, parts[1:])
		} else {
			fmt.Printf("%s not found!\n", parts[0])
		}
	} else if file.Format == "markup" && !l.CheckManager.Config.Simple {
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
			runtime := core.Which([]string{"python", "py", "python.exe", "python3", "python3.exe", "py3"})
			if cmd != "" && runtime != "" {
				l.lintRST(file, runtime, cmd)
			} else {
				fmt.Println(fmt.Sprintf("can't run rst2html: (%s, %s)!", runtime, cmd))
			}
		case ".xml":
			cmd := core.Which([]string{"xsltproc", "xsltproc.exe"})
			if cmd != "" && file.Transform != "" {
				l.lintXML(file, cmd)
			} else if file.Transform != "" {
				fmt.Println("xsltproc not found!")
			} else {
				fmt.Println("No XSLT transform provided!")
			}
		case ".dita":
			cmd := core.Which([]string{"dita", "dita.bat"})
			if cmd != "" {
				l.lintDITA(file, cmd)
			} else {
				fmt.Println("dita-ot not found!")
			}
		case ".html":
			l.lintHTML(file)
		}
	} else if file.Format == "code" && !l.CheckManager.Config.Simple {
		l.lintCode(file)
	} else {
		l.lintLines(file)
	}

	return file
}

func (l *Linter) lintProse(f *core.File, ctx, txt, raw string, lnTotal, lnLength int) {
	var b Block

	text := core.PrepText(txt)
	rawText := core.PrepText(raw)

	_, hasP := l.CheckManager.Scopes["paragraph"]
	_, hasS := l.CheckManager.Scopes["sentence"]

	if hasP || hasS {
		senScope := "sentence" + f.RealExt
		hasCtx := ctx != ""
		for _, p := range strings.SplitAfter(text, "\n\n") {
			for _, s := range core.SentenceTokenizer.Tokenize(p) {
				sent := strings.TrimSpace(s)
				if hasCtx {
					b = NewBlock(ctx, sent, "", senScope)
				} else {
					b = NewBlock(p, sent, "", senScope)
				}
				l.lintText(f, b, lnTotal, lnLength)
			}
			l.lintText(
				f,
				NewBlock(ctx, p, "", "paragraph"+f.RealExt),
				lnTotal,
				lnLength)
		}
	}

	l.lintText(
		f,
		NewBlock(ctx, text, rawText, "text"+f.RealExt),
		lnTotal,
		lnLength)
}

func (l *Linter) lintLines(f *core.File) {
	var line string
	lines := 1
	for f.Scanner.Scan() {
		line = core.PrepText(f.Scanner.Text() + "\n")
		l.lintText(f, NewBlock("", line, "", "text"+f.RealExt), lines+1, 0)
		lines++
	}
}

func (l *Linter) lintText(f *core.File, blk Block, lines int, pad int) {
	var txt string

	f.ChkToCtx = make(map[string]string)
	hasCode := core.StringInSlice(f.NormedExt, []string{".md", ".adoc", ".rst"})

	for name, chk := range l.CheckManager.AllChecks {
		if chk.Code && hasCode && !l.CheckManager.Config.Simple {
			txt = blk.Raw
		} else {
			txt = blk.Text
		}

		if !l.shouldRun(name, f, chk, blk) {
			continue
		}

		for _, a := range chk.Rule(txt, f) {
			// HACK: Workaround for LT-based rules.
			//
			// See `rule/grammar.go`.
			if name == "LanguageTool.Grammar" && !l.shouldRun(a.Check, f, chk, blk) {
				continue
			}
			core.FormatAlert(&a, chk.Level, chk.Limit, name)
			f.AddAlert(a, blk.Context, txt, lines, pad)
		}
	}
}

func (l *Linter) shouldRun(name string, f *core.File, chk check.Check, blk Block) bool {
	min := l.CheckManager.Config.MinAlertLevel
	run := false

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
	} else if chk.Level < min || !blk.Scope.Contains(chk.Scope) {
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
	if val, ok := l.CheckManager.Config.GChecks[name]; ok && !run {
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
