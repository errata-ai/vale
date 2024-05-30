package code

import (
	"fmt"
	"regexp"

	sitter "github.com/smacker/go-tree-sitter"
)

type padding func(string) int

// Language represents a supported programming language.
//
// NOTE: What about haskell, less, perl, php, powershell, r, sass, swift?
type Language struct {
	Delims  *regexp.Regexp
	Parser  *sitter.Language
	Queries []string
	Padding padding
}

// GetLanguageFromExt returns a Language based on the given file extension.
func GetLanguageFromExt(ext string) (*Language, error) {
	switch ext {
	case ".go":
		return Go(), nil
	case ".rs":
		return Rust(), nil
	case ".py":
		return Python(), nil
	case ".rb":
		return Ruby(), nil
	default:
		return nil, fmt.Errorf("unsupported extension: '%s'", ext)
	}
}
