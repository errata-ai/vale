package ui

import (
	"encoding/json"
	"fmt"

	"github.com/ValeLint/vale/core"
)

// PrintJSONAlerts prints Alerts in map[file.path][]Alert form.
func PrintJSONAlerts(linted []*core.File) bool {
	alertCount := 0
	formatted := map[string][]core.Alert{}
	for _, f := range linted {
		for _, a := range f.SortedAlerts() {
			if a.Severity == "error" {
				alertCount++
			}
			a.Message = fixOutputSpacing(a.Message)
			formatted[f.Path] = append(formatted[f.Path], a)
		}
	}
	b, err := json.MarshalIndent(formatted, "", "  ")
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println(string(b))
	}
	return alertCount != 0
}
