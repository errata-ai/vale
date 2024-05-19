package code

import (
	"bytes"
	"strings"

	sitter "github.com/smacker/go-tree-sitter"
)

type QueryEngine struct {
	tree *sitter.Tree
	lang *Language
}

func NewQueryEngine(tree *sitter.Tree, lang *Language) *QueryEngine {
	return &QueryEngine{
		tree: tree,
		lang: lang,
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
			rText := c.Node.Content(source)
			cText := qe.lang.Delims.ReplaceAllString(rText, "")

			scope := "text.comment.line"
			if strings.Count(cText, "\n") > 1 {
				scope = "text.comment.block"

				buf := bytes.Buffer{}
				for _, line := range strings.Split(cText, "\n") {
					buf.WriteString(strings.TrimLeft(line, " "))
					buf.WriteString("\n")
				}

				cText = buf.String()
			}

			comments = append(comments, Comment{
				Line:   int(c.Node.StartPoint().Row) + 1,
				Offset: int(c.Node.StartPoint().Column),
				Scope:  scope,
				Text:   cText,
				Source: rText,
			})
		}
	}

	return comments
}
