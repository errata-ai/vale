// An example plugin showing how to arbitrarily extend Vale via Golang.
//
// See https://errata-ai.github.io/vale/plugins/ for more information.

package main

import (
	"strings"

	"github.com/errata-ai/vale/core"
)

// Plugin extends Vale by implementing a custom rule.
func Plugin() core.Plugin {
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
		// You need to return a slice of Alerts specifying the rule's name
		// (`Check`), location (`span`), and message (`Message`).
		//
		// `text` will be the content of the scope specified above.
		Rule: func(text string, file *core.File) []core.Alert {
			alerts := []core.Alert{}
			if strings.ToLower(text) == text {
				alerts = append(alerts,
					core.Alert{
						// The name of our plugin. All plugins should specify
						// the "plugin" base style.
						Check: "plugins.Example",
						// The location of our alert relative to `text`.
						Span:    []int{0, len(text)},
						Message: "Capitalize your headings!"})
			}
			return alerts
		},
	}
}
