package code

import (
	"context"
	"sort"

	sitter "github.com/smacker/go-tree-sitter"
)

// Comment represents an in-code comment (line or block).
type Comment struct {
	Text   string
	Line   int
	Offset int
	Scope  string
}

func getComments(source []byte, lang *Language) ([]Comment, error) {
	var comments []Comment

	parser := sitter.NewParser()
	parser.SetLanguage(lang.Parser)

	tree, err := parser.ParseCtx(context.Background(), nil, source)
	if err != nil {
		return comments, err
	}
	engine := NewQueryEngine(tree, lang.Delims)

	for _, query := range lang.Queries {
		q, qErr := sitter.NewQuery([]byte(query), lang.Parser)
		if qErr != nil {
			return comments, err
		}
		comments = append(comments, engine.run(q, source)...)
	}

	if len(lang.Queries) > 1 {
		sort.Slice(comments, func(p, q int) bool {
			return comments[p].Line < comments[q].Line
		})
	}

	return comments, nil
}
