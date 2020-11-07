package ui

import (
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
	"text/tabwriter"
	"text/template"

	"github.com/errata-ai/vale/v2/core"
	"github.com/logrusorgru/aurora/v3"
)

// ProcessedFile represents a file that Vale has linted.
//
// This is exposed to `--output=<...>`  templates.
type ProcessedFile struct {
	core.Alert
	Path string
	Name string
}

var replacer = strings.NewReplacer("<align>", "\t")
var funcs = template.FuncMap{
	"red": func(s string) string {
		return fmt.Sprintf("%s", aurora.Red(s))
	},
	"yellow": func(s string) string {
		return fmt.Sprintf("%s", aurora.Yellow(s))
	},
	"blue": func(s string) string {
		return fmt.Sprintf("%s", aurora.Blue(s))
	},
	"underline": func(s string) string {
		return fmt.Sprintf("%s", aurora.Underline(s))
	},
	"add": func(i, j int) int {
		return i + j
	},
}

// PrintCustomAlerts formats the given alerts using a user-defined template.
func PrintCustomAlerts(linted []*core.File, path string) (bool, error) {
	var alertCount int

	b, err := ioutil.ReadFile(path)
	if err != nil {
		return false, core.NewE100("template", err)
	}
	text := replacer.Replace(string(b))

	t, err := template.New(filepath.Base(path)).Funcs(funcs).Parse(text)
	if err != nil {
		return false, core.NewE100("template", err)
	}

	formatted := []ProcessedFile{}
	for _, f := range linted {
		for _, a := range f.SortedAlerts() {
			if a.Severity == "error" {
				alertCount++
			}
			formatted = append(formatted, ProcessedFile{
				Path:  f.Path,
				Name:  filepath.Base(f.Path),
				Alert: a,
			})
		}
	}

	w := tabwriter.NewWriter(os.Stdout, 0, 8, 1, '\t', tabwriter.AlignRight)
	err = t.Execute(w, formatted)
	w.Flush()

	return alertCount != 0, err
}
