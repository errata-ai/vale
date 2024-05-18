package code

import (
	"fmt"
	"regexp"

	sitter "github.com/smacker/go-tree-sitter"
)

// Language represents a supported programming language.
//
// NOTE: What about haskell, less, perl, php, powershell, r, sass, swift?
type Language struct {
	Delims  *regexp.Regexp
	Parser  *sitter.Language
	Queries []string
}

func getLanguageFromExt(ext string) (*Language, error) {
	switch ext {
	case ".go":
		return Go(), nil
	case ".rs":
		return Rust(), nil
	case ".py":
		return Python(), nil
	default:
		return nil, fmt.Errorf("unsupported extension: '%s'", ext)
	}
}
