package lint

import (
	"bytes"
	"errors"
	"os/exec"
	"strings"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/jdkato/regexp"
)

// AsciiDoc configuration.

// Convert listing blocks of the form `[source,.+]` to `[source]`
var reSource = regexp.MustCompile(`\[source,.+\]`)
var adocArgs = []string{
	"-s",
	"-a",
	"notitle!",
	"-a",
	"attribute-missing=drop",
	"--quiet",
	"--safe-mode",
	"secure",
	"-",
}

func (l Linter) lintADoc(f *core.File) error {
	var out bytes.Buffer

	asciidoctor := core.Which([]string{"asciidoctor"})
	if asciidoctor == "" {
		return core.NewE100("lintAdoc", errors.New("asciidoctor not found"))
	}

	cmd := exec.Command(asciidoctor, adocArgs...)
	s, err := l.prep(f.Content, "\n----\n$1\n----\n", "`$1`", ".adoc")
	if err != nil {
		return core.NewE100(f.Path, err)
	}

	cmd.Stdin = strings.NewReader(s)
	cmd.Stdout = &out

	if err := cmd.Run(); err != nil {
		return core.NewE100(f.Path, err)
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

	// NOTE: This is required to avoid finding matches in block attributes.
	//
	// See https://github.com/errata-ai/vale/issues/296.
	f.Content = reSource.ReplaceAllString(f.Content, "[source]")

	return l.lintHTMLTokens(f, []byte(input), 0)
}
