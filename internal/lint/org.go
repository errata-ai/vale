package lint

import (
	"fmt"
	"strings"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/jdkato/regexp"
	"github.com/niklasfasching/go-org/org"
)

var orgConverter = org.New()
var orgWriter = org.NewHTMLWriter()

var reAttribute = regexp.MustCompile(`(#(?:\+| )[^\s]+:.+)`)
var reProps = regexp.MustCompile(`(:PROPERTIES:\n.+\n:END:)`)

func (l Linter) lintOrg(f *core.File) error {
	s := reAttribute.ReplaceAllString(f.Content, "\n=$1=\n")
	s = reProps.ReplaceAllString(s, "\n#+BEGIN_EXAMPLE\n$1\n#+END_EXAMPLE\n")

	doc := orgConverter.Parse(strings.NewReader(s), f.Path)
	// We don't want to introduce any *new* content into our HTML,
	// so we clear the outline.
	doc.Outline.Children = nil

	html, err := doc.Write(orgWriter)
	if err != nil {
		return err
	}

	fmt.Println(html)
	return l.lintHTMLTokens(f, []byte(html), 0)
}
