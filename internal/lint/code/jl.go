package code

import (
	"regexp"

	"github.com/jdkato/go-tree-sitter-julia/julia"
)

func Julia() *Language {
	return &Language{
		Delims:  regexp.MustCompile(`#|#=|=#`),
		Parser:  julia.GetLanguage(),
		Queries: []string{`(comment)+ @comment`},
		Padding: func(s string) int {
			return computePadding(s, []string{"#", `#=`, `=#`})
		},
	}
}
