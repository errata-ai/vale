package cli

import (
	"fmt"

	"github.com/errata-ai/vale/v2/internal/core"
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
			formatted[f.Path] = append(formatted[f.Path], a)
		}
	}
	fmt.Println(getJSON(formatted))
	return alertCount != 0
}
