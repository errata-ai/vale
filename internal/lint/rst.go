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

var shebang = regexp.MustCompile(`(?m)^#!(.+)$`)

var rstDomain = "localhost:7069"
var rstURL = "http://" + rstDomain

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
var rstRunning = false
var rstServer = `#!/usr/bin/env python
import sys

try:
    import locale

    locale.setlocale(locale.LC_ALL, "")
except:
    pass

if sys.version_info[0] < 3:
    reload(sys)
    sys.setdefaultencoding("utf-8")

try:
    from http.server import HTTPServer, BaseHTTPRequestHandler
except ImportError:
    from BaseHTTPServer import HTTPServer, BaseHTTPRequestHandler

from docutils import nodes
from docutils.core import publish_parts
from docutils.parsers.rst.states import Body

GITHUB_DISPLAY = True


def unknown_directive(self, type_name):
    lineno = self.state_machine.abs_line_number()
    (
        indented,
        indent,
        offset,
        blank_finish,
    ) = self.state_machine.get_first_known_indented(0, strip_indent=False)
    text = "\n".join(indented)
    if GITHUB_DISPLAY:
        cls = ["unknown_directive"]
        result = [nodes.literal_block(text, text, classes=cls)]
        return result, blank_finish
    else:
        return [nodes.comment(text, text)], blank_finish


class S(BaseHTTPRequestHandler):
    def _set_headers(self):
        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()

    def do_POST(self):
        """"""
        self._set_headers()

        Body.unknown_directive = unknown_directive

        content_length = int(self.headers["Content-Length"])
        post_data = self.rfile.read(content_length)

        overrides = {
            "leave-comments": True,
            "file_insertion_enabled": False,
            "footnote_backlinks": False,
            "toc_backlinks": False,
            "sectnum_xform": False,
            "report_level": 5,
            "halt_level": 5,
        }

        html = publish_parts(
            post_data, settings_overrides=overrides, writer_name="html"
        )["html_body"]

        self.wfile.write(html.encode("utf-8"))


def run(server_class=HTTPServer, handler_class=S, addr="localhost", port=8000):
    server_address = (addr, port)
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()


if __name__ == "__main__":
    run(addr="127.0.0.1", port=7069)`

func (l *Linter) lintSphinx(f *core.File) error {
	file := filepath.Base(f.Path)

	built := strings.Replace(file, filepath.Ext(file), ".html", 1)
	built = filepath.Join(l.Manager.Config.SphinxBuild, "html", built)

	html, err := ioutil.ReadFile(built)
	if err != nil {
		return core.NewE100(f.Path, err)
	}

	return l.lintHTMLTokens(f, html, 0)
}

func (l *Linter) lintRST(f *core.File) error {
	var html string

	rst2html := core.Which([]string{
		"rst2html", "rst2html.py", "rst2html-3", "rst2html-3.py"})
	python := core.Which([]string{
		"python", "py", "python.exe", "python3", "python3.exe", "py3"})

	if rst2html == "" || python == "" {
		return core.NewE100("lintRST", errors.New("rst2html not found"))
	} else if l.Manager.Config.SphinxBuild != "" {
		return l.lintSphinx(f)
	}

	s, err := l.prep(f.Content, "\n::\n\n%s\n", "``$1``", ".rst")
	if err != nil {
		return err
	}

	s = reSphinx.ReplaceAllString(s, ".. code::")
	s = reCodeBlock.ReplaceAllString(s, "::")

	if err := l.startRstServer(rst2html, python); err != nil {
		html, err = callRst(f, s, rst2html, python)
	} else {
		html, err = l.post(f, s, rstURL)
	}

	return l.lintHTMLTokens(f, []byte(html), 0)
}

func callRst(f *core.File, text, lib, exe string) (string, error) {
	var out bytes.Buffer
	var cmd *exec.Cmd

	if runtime.GOOS == "windows" {
		// rst2html is executable by default on Windows.
		cmd = exec.Command(exe, append([]string{lib}, rstArgs...)...)
	} else {
		cmd = exec.Command(lib, rstArgs...)
	}

	cmd.Stdin = strings.NewReader(text)
	cmd.Stdout = &out

	if err := cmd.Run(); err != nil {
		return "", core.NewE100("callRst", err)
	}

	html := out.String()
	html = strings.Replace(html, "\r", "", -1)

	bodyStart := strings.Index(html, "<body>\n")
	if bodyStart < 0 {
		bodyStart = -7
	}
	bodyEnd := strings.Index(html, "\n</body>")
	if bodyEnd < 0 || bodyEnd >= len(html) {
		bodyEnd = len(html) - 1
		if bodyEnd < 0 {
			bodyEnd = 0
		}
	}

	return html[bodyStart+7 : bodyEnd], nil
}

func (l *Linter) startRstServer(lib, exe string) error {
	if rstRunning {
		return nil
	}

	python, err := findPython(lib)
	if err != nil {
		return err
	} else if python == "" {
		return errors.New("shebang parsing failed")
	}

	tmpfile, _ := ioutil.TempFile("", "server.*.py")
	if _, err := tmpfile.WriteString(rstServer); err != nil {
		return err
	}

	if err := tmpfile.Close(); err != nil {
		return err
	}

	cmd := exec.Command(python, tmpfile.Name())
	if err := cmd.Start(); err != nil {
		return err
	}

	ping(rstDomain)

	l.pids = append(l.pids, cmd.Process.Pid)
	l.temps = append(l.temps, tmpfile)

	rstRunning = true
	return nil
}

func findPython(exe string) (string, error) {
	bin, err := ioutil.ReadFile(exe)
	if err != nil {
		return "", err
	}

	m := shebang.FindStringSubmatch(string(bin))
	if len(m) > 1 {
		return m[1], nil
	}

	return "", nil
}
