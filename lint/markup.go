package lint

import (
	"bytes"
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"

	"github.com/errata-ai/vale/v2/core"
	"github.com/gobwas/glob"
	"github.com/jdkato/regexp"
	"github.com/yuin/goldmark"
	"github.com/yuin/goldmark/extension"
	grh "github.com/yuin/goldmark/renderer/html"
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

// AsciiDoc configuration.
var adocArgs = []string{
	"-s",
	"-a",
	"notitle!",
	"--quiet",
	"--safe-mode",
	"secure",
	"-",
}

// XML configuration.
var xsltArgs = []string{
	"--stringparam",
	"use.extensions",
	"0",
	"--stringparam",
	"generate.toc",
	"nop",
}

// Markdown configuration.
var goldMd = goldmark.New(
	goldmark.WithExtensions(
		extension.GFM,
	),
	goldmark.WithRendererOptions(
		grh.WithUnsafe(),
	),
)
var reFrontMatter = regexp.MustCompile(
	`^(?s)(?:---|\+\+\+)\n(.+?)\n(?:---|\+\+\+)`)

// Convert extended info strings -- e.g., ```callout{'title': 'NOTE'} -- that
// might confuse Blackfriday into normal "```".
var reExInfo = regexp.MustCompile("`{3,}" + `.+`)

// HTML configuration.
var heading = regexp.MustCompile(`^h\d$`)

func (l Linter) lintHTML(f *core.File) {
	l.lintHTMLTokens(f, []byte(f.Content), 0)
}

func (l Linter) prep(content, block, inline, ext string) (string, error) {
	s := reFrontMatter.ReplaceAllString(content, block)
	s = reExInfo.ReplaceAllString(s, "```")

	for syntax, regexes := range l.Manager.Config.TokenIgnores {
		sec, err := glob.Compile(syntax)
		if err != nil {
			return s, err
		} else if sec.Match(ext) {
			for _, r := range regexes {
				pat, err := regexp.Compile(r)
				if err == nil {
					s = pat.ReplaceAllString(s, inline)
				}
			}
		}
	}

	for syntax, regexes := range l.Manager.Config.BlockIgnores {
		sec, err := glob.Compile(syntax)
		if err != nil {
			return s, err
		} else if sec.Match(ext) {
			for _, r := range regexes {
				pat, err := regexp.Compile(r)
				if err == nil {
					if ext == ".rst" {
						// HACK: We need to add padding for the literal block.
						for _, c := range pat.FindAllStringSubmatch(s, -1) {
							new := fmt.Sprintf(block, core.Indent(c[0], "    "))
							s = strings.Replace(s, c[0], new, 1)
						}
					} else {
						s = pat.ReplaceAllString(s, block)
					}
				}
			}
		}
	}

	return s, nil
}

func (l Linter) lintMarkdown(f *core.File) error {
	var buf bytes.Buffer

	s, err := l.prep(f.Content, "\n```\n$1\n```\n", "`$1`", ".md")
	if err != nil {
		return core.NewE100(f.Path, err)
	}

	if err := goldMd.Convert([]byte(s), &buf); err != nil {
		return core.NewE100(f.Path, err)
	}

	// NOTE: This is required to avoid finding matches info strings. For
	// example, if we're looking for 'json' we many incorrectly report the
	// location as being in an infostring like '```json'.
	//
	// See https://github.com/errata-ai/vale/v2/issues/248.
	body := reExInfo.ReplaceAllStringFunc(f.Content, func(m string) string {
		parts := strings.Split(m, "`")

		// This ensure that we respect the number of openning backticks, which
		// could be more than 3.
		//
		// See https://github.com/errata-ai/vale/v2/issues/271.
		tags := strings.Repeat("`", len(parts)-1)
		span := strings.Repeat("*", len(parts[len(parts)-1]))

		return tags + span
	})

	f.Content = body
	l.lintHTMLTokens(f, buf.Bytes(), 0)

	return nil
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

func (l Linter) lintADoc(file *core.File) error {
	var out bytes.Buffer

	asciidoctor := core.Which([]string{"asciidoctor"})
	if asciidoctor == "" {
		return core.NewE100("lintAdoc", errors.New("asciidoctor not found"))
	}

	cmd := exec.Command(asciidoctor, adocArgs...)
	s, err := l.prep(file.Content, "\n----\n$1\n----\n", "`$1`", ".adoc")
	if err != nil {
		return core.NewE100(file.Path, err)
	}

	cmd.Stdin = strings.NewReader(s)
	cmd.Stdout = &out

	if err := cmd.Run(); err != nil {
		return core.NewE100(file.Path, err)
	}

	// NOTE: Asciidoctor converts "'" to "’".
	//
	// See #206.
	var sanitizer = strings.NewReplacer(
		"\u2018", "&apos;",
		"\u2019", "&apos;",
		"&#8217;", "&apos;",
		"&rsquo;", "&apos;")
	input := sanitizer.Replace(out.String())

	l.lintHTMLTokens(file, []byte(input), 0)
	return nil
}

func (l Linter) lintXML(file *core.File) error {
	var out bytes.Buffer

	xsltproc := core.Which([]string{"xsltproc", "xsltproc.exe"})
	if xsltproc == "" {
		return core.NewE100("lintXML", errors.New("xsltproc not found"))
	} else if file.Transform == "" {
		return core.NewE100(
			"lintXML",
			errors.New("no XSLT transform provided"))
	}

	xsltArgs = append(xsltArgs, []string{file.Transform, "-"}...)

	cmd := exec.Command(xsltproc, xsltArgs...)
	cmd.Stdin = strings.NewReader(file.Content)
	cmd.Stdout = &out

	if err := cmd.Run(); err != nil {
		return core.NewE100(file.Path, err)
	}

	l.lintHTMLTokens(file, out.Bytes(), 0)
	return nil
}

func (l Linter) lintDITA(file *core.File) error {
	var out bytes.Buffer

	dita := core.Which([]string{"dita", "dita.bat"})
	if dita == "" {
		return core.NewE100("lintDITA", errors.New("dita not found"))
	}

	tempDir, err := ioutil.TempDir("", "dita-")
	defer os.RemoveAll(tempDir)

	if err != nil {
		return core.NewE201FromPosition(err.Error(), file.Path, 1)
	}

	// FIXME: The `dita` command is *slow* (~4s per file)!
	cmd := exec.Command(dita, []string{
		"-i",
		file.Path,
		"-f",
		"html5",
		"-o",
		tempDir,
		"--nav-toc=none",
		"--outer.control=fail"}...)
	cmd.Stderr = &out

	if err := cmd.Run(); err != nil {
		return core.NewE100(file.Path, errors.New(out.String()))
	}

	basename := filepath.Base(file.Path)
	data, err := ioutil.ReadFile(filepath.Join(
		tempDir,
		strings.TrimSuffix(basename, filepath.Ext(basename))+".html"))

	if err != nil {
		return core.NewE201FromPosition(err.Error(), file.Path, 1)
	}

	// NOTE: We have to remove the `<head>` tag to avoid
	// introducing new content into the HTML.
	head1 := bytes.Index(data, []byte("<head>"))
	head2 := bytes.Index(data, []byte("</head>"))
	l.lintHTMLTokens(
		file, append(data[:head1], data[head2:]...), 0)

	return nil
}
