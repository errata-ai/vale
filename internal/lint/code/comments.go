package code

import (
	"context"
	"fmt"
	"strings"

	sitter "github.com/smacker/go-tree-sitter"
	"github.com/smacker/go-tree-sitter/golang"
	"github.com/smacker/go-tree-sitter/python"
	"github.com/smacker/go-tree-sitter/rust"
)

// Language represents a supported programming language.
//
// NOTE: What about haskell, less, perl, php, powershell, r, sass, swift?
type Language struct {
	Delimiters []string
	Sitter     *sitter.Language
	Query      string
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
		return &Language{
			Delimiters: []string{"//", "/*", "*/"},
			Sitter:     golang.GetLanguage(),
			Query:      "(comment)+ @comment",
		}, nil
	case ".rs":
		return &Language{
			Delimiters: []string{"///", "//"},
			Sitter:     rust.GetLanguage(),
			Query:      "(line_comment)+ @comment",
		}, nil
	case ".py":
		return &Language{
			Delimiters: []string{"#"},
			Sitter:     python.GetLanguage(),
			Query:      `(comment) @comment`,
		}, nil
	default:
		return nil, fmt.Errorf("unsupported extension: '%s'", ext)
	}
}

func getComments(source []byte, lang *Language) ([]Comment, error) {
	var comments []Comment

	parser := sitter.NewParser()
	parser.SetLanguage(lang.Sitter)

	tree, err := parser.ParseCtx(context.Background(), nil, source)
	if err != nil {
		return comments, err
	}
	n := tree.RootNode()

	q, err := sitter.NewQuery([]byte(lang.Query), lang.Sitter)
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

		for _, c := range m.Captures {
			text := c.Node.Content(source)

			for _, d := range lang.Delimiters {
				text = strings.Trim(text, d)
			}

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
