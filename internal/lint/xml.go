package lint

import (
	"bytes"
	"errors"
	"os/exec"
	"strings"

	"github.com/errata-ai/vale/v2/internal/core"
)

// XML configuration.
var xsltArgs = []string{
	"--stringparam",
	"use.extensions",
	"0",
	"--stringparam",
	"generate.toc",
	"nop",
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

	return l.lintHTMLTokens(file, out.Bytes(), 0)
}
