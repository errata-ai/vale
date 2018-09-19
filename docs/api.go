package main

import (
	"fmt"
	"go/ast"
	"go/build"
	"go/parser"
	"go/token"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/olekukonko/tablewriter"
)

var path = filepath.Join(build.Default.GOPATH, "src/github.com/errata-ai/vale/check/defintions.go")
var extensionPoints = []string{
	"capitalization",
	"conditional",
	"consistency",
	"existence",
	"occurrence",
	"repetition",
	"substitution",
	"readability",
	"spelling",
}
var out = "content/api/%s/keys.md"
var pat = regexp.MustCompile(`(.*) \((.*)\): (.*)`)

func isExtension(decl string) string {
	for _, point := range extensionPoints {
		if strings.HasPrefix(decl, strings.Title(point)) {
			return point
		}
	}
	return ""
}

func extract(comments []*ast.CommentGroup) []string {
	doc := []string{}
	for _, comment := range comments {
		row := comment.Text()
		if isExtension(row) != "" {
			return doc
		}
		doc = append(doc, row)
	}
	return doc
}

func main() {
	fset := token.NewFileSet()

	file, e := parser.ParseFile(fset, path, nil, parser.ParseComments)
	if e != nil {
		fmt.Println(e.Error())
	}

	extracted := map[string][]string{}
	for idx, comment := range file.Comments {
		point := isExtension(comment.Text())
		if point != "" {
			extracted[point] = extract(file.Comments[idx+1:])
		}
	}

	for key, values := range extracted {
		fi, err := os.Create(fmt.Sprintf(out, key))
		if err != nil {
			fmt.Println(err)
		}

		table := tablewriter.NewWriter(fi)
		table.SetHeader([]string{"Name", "Type", "Description"})
		table.SetBorders(tablewriter.Border{Left: true, Top: false, Right: true, Bottom: false})
		table.SetCenterSeparator("|")
		table.SetAutoWrapText(false)

		for _, row := range values {
			table.Append(pat.FindStringSubmatch(row)[1:])
		}

		table.Render()
		fi.Close()
	}
}
