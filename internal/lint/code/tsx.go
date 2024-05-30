package code

import (
	"regexp"

	"github.com/smacker/go-tree-sitter/typescript/tsx"
)

func Tsx() *Language {
	return &Language{
		Delims:  regexp.MustCompile(`//|/\*|\*/`),
		Parser:  tsx.GetLanguage(),
		Queries: []string{`(comment)+ @comment`},
		Padding: cStyle,
	}
}
