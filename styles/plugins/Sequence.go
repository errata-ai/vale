// A Vale plugin for checking a sequence of words.
//
// See https://errata-ai.github.io/vale/plugins/ for more information.

package main

import (
	"regexp"
	"strings"

	"github.com/errata-ai/vale/core"
)

var pat = regexp.MustCompile(`dialog \w+`)

// Sequence extends Vale by implementing a custom rule.
func Sequence() core.Plugin {
	return core.Plugin{
		// Scope determines where this rule applies.
		//
		// See https://errata-ai.github.io/vale/formats/.
		Scope: "text",
		// Level specifies the importance of this rule.
		//
		// See https://errata-ai.github.io/vale/styles/#extension-points.
		Level: "error",
		// Rule is the entry point to your custom rule.
		//
		// You need to return a slice of Alerts specifying the rule's location
		// (`span`), and message (`Message`).
		//
		// `text` will be the content of the scope specified above.
		Rule: func(text string, file *core.File) []core.Alert {
			alerts := []core.Alert{}
			for _, loc := range pat.FindAllStringIndex(text, -1) {
				match := text[loc[0]:loc[1]]
				words := strings.Split(match, " ")
				if words[1] != "box" {
					alerts = append(alerts,
						core.Alert{
							// The location of our alert relative to `text`.
							Span:    loc,
							Message: "Don't use the word 'dialog'!"})
				}
			}
			return alerts
		},
	}
}
