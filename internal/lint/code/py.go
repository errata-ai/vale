package code

import (
	"regexp"

	"github.com/smacker/go-tree-sitter/python"
)

func Python() *Language {
	return &Language{
		Delims: regexp.MustCompile(`#\s?`),
		Parser: python.GetLanguage(),
		Query:  `(comment)+ @comment`,
	}
}
