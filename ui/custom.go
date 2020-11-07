package ui

import (
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"text/template"

	"github.com/Masterminds/sprig/v3"
	"github.com/errata-ai/vale/v2/core"
	"github.com/logrusorgru/aurora/v3"
	"github.com/olekukonko/tablewriter"
)

// ProcessedFile represents a file that Vale has linted.
type ProcessedFile struct {
	Alerts []core.Alert
	Path   string
}

// Data holds the information exposed to UI templates.
type Data struct {
	Files []ProcessedFile
}

var funcs = sprig.TxtFuncMap()

func init() {
	funcs["red"] = func(s string) string {
		return fmt.Sprintf("%s", aurora.Red(s))
	}
	funcs["blue"] = func(s string) string {
		return fmt.Sprintf("%s", aurora.Blue(s))
	}
	funcs["yellow"] = func(s string) string {
		return fmt.Sprintf("%s", aurora.Yellow(s))
	}
	funcs["underline"] = func(s string) string {
		return fmt.Sprintf("%s", aurora.Underline(s))
	}
	funcs["newTable"] = func(wrap bool) *tablewriter.Table {
		table := tablewriter.NewWriter(os.Stdout)
		table.SetCenterSeparator("")
		table.SetColumnSeparator("")
		table.SetRowSeparator("")
		table.SetAutoWrapText(wrap)
		return table
	}
	funcs["addRow"] = func(t *tablewriter.Table, r []string) *tablewriter.Table {
		t.Append(r)
		return t
	}
	funcs["renderTable"] = func(t *tablewriter.Table) *tablewriter.Table {
		t.Render()
		t.ClearRows()
		return t
	}
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
		Files: formatted,
	})
}
