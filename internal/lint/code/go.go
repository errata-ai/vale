package code

import (
	"regexp"

	"github.com/smacker/go-tree-sitter/golang"
)

func Go() *Language {
	return &Language{
		Delims:  regexp.MustCompile(`// ?|/\* ?| ?\*/`),
		Parser:  golang.GetLanguage(),
		Queries: []string{`(comment)+ @comment`},
		Padding: cStyle,
	}
}
