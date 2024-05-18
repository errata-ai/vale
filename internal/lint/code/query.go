package code

import (
	"regexp"
	"strings"

	sitter "github.com/smacker/go-tree-sitter"
)

type QueryEngine struct {
	tree *sitter.Tree
	// NOTE: Should we strip the delimiters using `#strip!`?
	delims *regexp.Regexp
}

func NewQueryEngine(tree *sitter.Tree, delims *regexp.Regexp) *QueryEngine {
	return &QueryEngine{
		tree:   tree,
		delims: delims,
	}
}

func (qe *QueryEngine) run(q *sitter.Query, source []byte) []Comment {
	var comments []Comment

	qc := sitter.NewQueryCursor()
	qc.Exec(q, qe.tree.RootNode())

	for {
		m, ok := qc.NextMatch()
		if !ok {
			break
		}

		m = qc.FilterPredicates(m, source)
		for _, c := range m.Captures {
			text := qe.delims.ReplaceAllString(c.Node.Content(source), "")

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

	return comments
}
