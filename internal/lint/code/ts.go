package code

import (
	"regexp"

	"github.com/smacker/go-tree-sitter/typescript/typescript"
)

func TypeScript() *Language {
	return &Language{
		Delims:  regexp.MustCompile(`//|/\*|\*/`),
		Parser:  typescript.GetLanguage(),
		Queries: []string{`(comment)+ @comment`},
		Padding: cStyle,
	}
}
