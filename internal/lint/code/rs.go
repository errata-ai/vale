package code

import (
	"regexp"

	"github.com/smacker/go-tree-sitter/rust"
)

func Rust() *Language {
	return &Language{
		Delims: regexp.MustCompile(`/{2,3}\s?`),
		Parser: rust.GetLanguage(),
		Query:  `(line_comment)+ @comment`,
	}
}
