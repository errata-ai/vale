package check

import (
	"strings"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
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

// NewRepetition creates a new `repetition`-based rule.
func NewRepetition(cfg *core.Config, generic baseCheck) (Repetition, error) {
	rule := Repetition{}
	path := generic["path"].(string)

	err := mapstructure.WeakDecode(generic, &rule)
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

// Run executes the the `repetition`-based rule.
//
// The rule looks for repeated matches of its regex -- such as "this this".
func (o Repetition) Run(blk nlp.Block, f *core.File) []core.Alert {
	var curr, prev string
	var hit bool
	var ploc []int
	var count int

	txt := blk.Text
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

// Fields provides access to the internal rule definition.
func (o Repetition) Fields() Definition {
	return o.Definition
}

// Pattern is the internal regex pattern used by this rule.
func (o Repetition) Pattern() string {
	return o.pattern.String()
}
