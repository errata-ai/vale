package check

import (
	"strings"

	"github.com/errata-ai/vale/v2/config"
	"github.com/errata-ai/vale/v2/core"
	"github.com/jdkato/regexp"
	"github.com/mitchellh/mapstructure"
)

// Repetition looks for repeated uses of Tokens.
type Repetition struct {
	Definition `mapstructure:",squash"`
	Max        int
	// `ignorecase` (`bool`): Makes all matches case-insensitive.
	Ignorecase bool
	// `alpha` (`bool`): Limits all matches to alphanumeric tokens.
	Alpha bool
	// `tokens` (`array`): A list of tokens to be transformed into a
	// non-capturing group.
	Tokens []string

	pattern *regexp.Regexp
}

// NewRepetition ...
func NewRepetition(cfg *config.Config, generic baseCheck) (Repetition, error) {
	rule := Repetition{}
	path := generic["path"].(string)

	err := mapstructure.Decode(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	regex := ""
	if rule.Ignorecase {
		regex += ignoreCase
	}

	regex += `(` + strings.Join(rule.Tokens, "|") + `)`
	re, err := regexp.Compile(regex)
	if err != nil {
		return rule, core.NewE201FromPosition(err.Error(), path, 1)
	}

	rule.pattern = re
	return rule, nil
}

// Run ...
func (o Repetition) Run(txt string, f *core.File) []core.Alert {
	var curr, prev string
	var hit bool
	var ploc []int
	var count int

	alerts := []core.Alert{}
	for _, loc := range o.pattern.FindAllStringIndex(txt, -1) {
		curr = strings.TrimSpace(txt[loc[0]:loc[1]])
		if o.Ignorecase {
			hit = strings.ToLower(curr) == strings.ToLower(prev) && curr != ""
		} else {
			hit = curr == prev && curr != ""
		}

		hit = hit && (!o.Alpha || core.IsLetter(curr))
		if hit {
			count++
		}

		if hit && count > o.Max {
			if !strings.Contains(txt[ploc[0]:loc[1]], "\n") {
				floc := []int{ploc[0], loc[1]}
				a := makeAlert(o.Definition, floc, txt)
				a.Message, a.Description = formatMessages(o.Message,
					o.Description, curr)
				alerts = append(alerts, a)
				count = 0
			}
		}
		ploc = loc
		prev = curr
	}

	return alerts
}

// Fields ...
func (o Repetition) Fields() Definition {
	return o.Definition
}

// Pattern ...
func (o Repetition) Pattern() string {
	return o.pattern.String()
}
