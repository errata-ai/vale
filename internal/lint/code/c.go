package code

import (
	"regexp"

	"github.com/smacker/go-tree-sitter/c"
)

func C() *Language {
	return &Language{
		Delims:  regexp.MustCompile(`//|/\*|\*/`),
		Parser:  c.GetLanguage(),
		Queries: []string{`(comment)+ @comment`},
		Padding: cStyle,
	}
}
