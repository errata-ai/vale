package cli

import (
	"io/ioutil"
	"os"
	"path/filepath"
	"text/template"

	"github.com/errata-ai/vale/v2/internal/core"
)

// ProcessedFile represents a file that Vale has linted.
type ProcessedFile struct {
	Alerts []core.Alert
	Path   string
}

// Data holds the information exposed to UI templates.
type Data struct {
	Files       []ProcessedFile
	LintedTotal int
}

// PrintCustomAlerts formats the given alerts using a user-defined template.
func PrintCustomAlerts(linted []*core.File, path string) (bool, error) {
	var alertCount int

	b, err := ioutil.ReadFile(path)
	if err != nil {
		return false, core.NewE100("template", err)
	}
	text := string(b)

	t, err := template.New(filepath.Base(path)).Funcs(funcs).Parse(text)
	if err != nil {
		return false, core.NewE100("template", err)
	}

	formatted := []ProcessedFile{}
	for _, f := range linted {
		if len(f.Alerts) == 0 {
			continue
		}
		for _, a := range f.SortedAlerts() {
			if a.Severity == "error" {
				alertCount++
				break
			}
		}
		formatted = append(formatted, ProcessedFile{
			Path:   f.Path,
			Alerts: f.Alerts,
		})
	}

	return alertCount != 0, t.Execute(os.Stdout, Data{
		Files:       formatted,
		LintedTotal: len(linted),
	})
}
