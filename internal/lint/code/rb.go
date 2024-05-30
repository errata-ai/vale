package code

import (
	"regexp"

	"github.com/smacker/go-tree-sitter/ruby"
)

func Ruby() *Language {
	return &Language{
		Delims:  regexp.MustCompile(`#|=begin|=end`),
		Parser:  ruby.GetLanguage(),
		Queries: []string{`(comment)+ @comment`},
		Padding: func(s string) int {
			return computePadding(s, []string{"#", `=begin`, `=end`})
		},
	}
}
