package lint

import (
	"bytes"
	"errors"
	"io/ioutil"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/jdkato/regexp"
)

// reStructuredText configuration.
//
// reCodeBlock is used to convert Sphinx-style code directives to the regular
// `::` for rst2html.
var reCodeBlock = regexp.MustCompile(`.. (?:raw|code(?:-block)?):: (\w+)`)

// HACK: We replace custom Sphinx directives with `.. code::`.
//
// This isn't ideal, but it appears to be necessary.
//
// See https://github.com/errata-ai/vale/v2/issues/119.
var reSphinx = regexp.MustCompile(`.. glossary::`)
var rstArgs = []string{
	"--quiet",
	"--halt=5",
	"--report=5",
	"--link-stylesheet",
	"--no-file-insertion",
	"--no-toc-backlinks",
	"--no-footnote-backlinks",
	"--no-section-numbering",
}

func (l Linter) lintSphinx(f *core.File) error {
	file := filepath.Base(f.Path)

	built := strings.Replace(file, filepath.Ext(file), ".html", 1)
	built = filepath.Join(l.Manager.Config.SphinxBuild, "html", built)

	html, err := ioutil.ReadFile(built)
	if err != nil {
		return core.NewE100(f.Path, err)
	}

	l.lintHTMLTokens(f, html, 0)
	return nil
}

func (l Linter) lintRST(file *core.File) error {
	rst2html := core.Which([]string{"rst2html", "rst2html.py"})
	python := core.Which([]string{
		"python", "py", "python.exe", "python3", "python3.exe", "py3"})

	if rst2html == "" || python == "" {
		return core.NewE100("lintRST", errors.New("rst2html not found"))
	} else if l.Manager.Config.SphinxBuild != "" {
		return l.lintSphinx(file)
	}

	var out bytes.Buffer
	var cmd *exec.Cmd

	if runtime.GOOS == "windows" {
		// rst2html is executable by default on Windows.
		cmd = exec.Command(python, append([]string{rst2html}, rstArgs...)...)
	} else {
		cmd = exec.Command(rst2html, rstArgs...)
	}

	s, err := l.prep(file.Content, "\n::\n\n%s\n", "``$1``", ".rst")
	if err != nil {
		return core.NewE100(file.Path, err)
	}
	s = reSphinx.ReplaceAllString(s, ".. code::")

	cmd.Stdin = strings.NewReader(reCodeBlock.ReplaceAllString(s, "::"))
	cmd.Stdout = &out

	if err := cmd.Run(); err != nil {
		return core.NewE201FromPosition(err.Error(), file.Path, 1)
	}

	html := bytes.Replace(out.Bytes(), []byte("\r"), []byte(""), -1)
	bodyStart := bytes.Index(html, []byte("<body>\n"))
	if bodyStart < 0 {
		bodyStart = -7
	}
	bodyEnd := bytes.Index(html, []byte("\n</body>"))
	if bodyEnd < 0 || bodyEnd >= len(html) {
		bodyEnd = len(html) - 1
		if bodyEnd < 0 {
			bodyEnd = 0
		}
	}
	l.lintHTMLTokens(file, html[bodyStart+7:bodyEnd], 0)

	return nil
}
