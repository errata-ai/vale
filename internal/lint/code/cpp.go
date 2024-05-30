package code

import (
	"regexp"

	"github.com/smacker/go-tree-sitter/cpp"
)

func Cpp() *Language {
	return &Language{
		Delims:  regexp.MustCompile(`//|/\*!?|\*/`),
		Parser:  cpp.GetLanguage(),
		Queries: []string{`(comment)+ @comment`},
		Padding: cStyle,
	}
}
