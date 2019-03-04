/* An example plugin showing how to arbitrarily extend Vale via Golang.

See https://errata-ai.github.io/vale/plugins/ for more information.
*/
package main

import (
	"strings"

	"github.com/errata-ai/vale/core"
)

// Scope determines where this rule applies.
//
// See https://errata-ai.github.io/vale/formats/.
var Scope = "heading"

// Level specifies the importance of this rule.
//
// See https://errata-ai.github.io/vale/styles/#extension-points.
var Level = "warning"

// Rule is the entry point to your custom rule.
//
// You need to return a slice of Alerts specifying the rule's name
// (`Check`), level (`Severity`), location (`span`), and message
// (`Message`).
func Rule(text string, file *core.File) []core.Alert {
	alerts := []core.Alert{}
	if strings.ToLower(text) == text {
		alerts = append(alerts,
			core.Alert{
				Check: "plugins.Example",
				Severity: Level,
				Span: []int{0, len(text)},
				Message: "Capitalize your headings!"})
	}
	return alerts
}
