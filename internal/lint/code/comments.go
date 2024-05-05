package code

import (
	"context"
	"fmt"
	"regexp"
	"strings"

	sitter "github.com/smacker/go-tree-sitter"
)

// Language represents a supported programming language.
//
// NOTE: What about haskell, less, perl, php, powershell, r, sass, swift?
type Language struct {
	Delims *regexp.Regexp
	Parser *sitter.Language
	Query  string
}

// Comment represents an in-code comment (line or block).
type Comment struct {
	Text   string
	Line   int
	Offset int
	Scope  string
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

func getComments(source []byte, lang *Language) ([]Comment, error) {
	var comments []Comment

	parser := sitter.NewParser()
	parser.SetLanguage(lang.Parser)

	tree, err := parser.ParseCtx(context.Background(), nil, source)
	if err != nil {
		return comments, err
	}
	n := tree.RootNode()

	q, err := sitter.NewQuery([]byte(lang.Query), lang.Parser)
	if err != nil {
		return comments, err
	}

	qc := sitter.NewQueryCursor()
	qc.Exec(q, n)

	for {
		m, ok := qc.NextMatch()
		if !ok {
			break
		}

		m = qc.FilterPredicates(m, source)
		for _, c := range m.Captures {
			text := lang.Delims.ReplaceAllString(c.Node.Content(source), "")

			scope := "text.comment.line"
			if strings.Count(text, "\n") > 1 {
				scope = "text.comment.block"
			}

			comments = append(comments, Comment{
				Line:   int(c.Node.StartPoint().Row) + 1,
				Offset: int(c.Node.StartPoint().Column),
				Scope:  scope,
				Text:   text,
			})
		}
	}

	return comments, nil
}
