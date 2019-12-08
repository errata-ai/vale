// An example plugin showing how to arbitrarily extend Vale via Golang.
//
// See https://errata-ai.github.io/vale/plugins/ for more information.

package main

import (
	"strings"

	"github.com/errata-ai/vale/core"
)

// Example extends Vale by implementing a custom rule.
//
// The name of this function (i.e., "Example") *must* match the name of its
// file (i.e., "Example.go").
func Example() core.Plugin {
	return core.Plugin{
		// Scope determines where this rule applies.
		//
		// See https://errata-ai.github.io/vale/formats/.
		Scope: "heading",
		// Level specifies the importance of this rule.
		//
		// See https://errata-ai.github.io/vale/styles/#extension-points.
		Level: "warning",
		// Rule is the entry point to your custom rule.
		//
		// You need to return a slice of Alerts specifying the rule's location
		// (`span`), and message (`Message`).
		//
		// `text` will be the content of the scope specified above.
		Rule: func(text string, file *core.File) []core.Alert {
			alerts := []core.Alert{}
			if strings.ToLower(text) == text {
				alerts = append(alerts,
					core.Alert{
						// The location of our alert relative to `text`.
						Span:    []int{0, len(text)},
						Message: "Capitalize your headings!"})
			}
			return alerts
		},
	}
}
