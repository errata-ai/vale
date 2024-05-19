package code

import (
	"regexp"

	"github.com/smacker/go-tree-sitter/rust"
)

func Rust() *Language {
	return &Language{
		Delims:  regexp.MustCompile(`/{2,3}`),
		Parser:  rust.GetLanguage(),
		Queries: []string{`(line_comment)+ @comment`},
	}
}
