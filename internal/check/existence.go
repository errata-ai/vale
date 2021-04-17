package check

import (
	"fmt"
	"strings"

	"github.com/dlclark/regexp2"
	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
	"github.com/mitchellh/mapstructure"
)

// Existence checks for the present of Tokens.
type Existence struct {
	Definition `mapstructure:",squash"`
	// `append` (`bool`): Adds `raw` to the end of `tokens`, assuming both are
	// defined.
	Append bool
	// `ignorecase` (`bool`): Makes all matches case-insensitive.
	IgnoreCase bool
	// `nonword` (`bool`): Removes the default word boundaries (`\b`).
	Nonword bool
	// `raw` (`array`): A list of tokens to be concatenated into a pattern.
	Raw []string
	// `tokens` (`array`): A list of tokens to be transformed into a
	// non-capturing group.
	Tokens []string

	pattern *regexp2.Regexp
}

// NewExistence creates a new `Rule` that extends `Existence`.
func NewExistence(cfg *core.Config, generic baseCheck) (Existence, error) {
	rule := Existence{}

	path := ""
	if p, ok := generic["path"].(string); !ok {
		path = p
	}

	err := mapstructure.WeakDecode(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	regex := makeRegexp(
		cfg.WordTemplate,
		rule.IgnoreCase,
		func() bool { return !rule.Nonword && len(rule.Tokens) > 0 },
		func() string { return strings.Join(rule.Raw, "") },
		rule.Append)
	regex = fmt.Sprintf(regex, strings.Join(rule.Tokens, "|"))

	re, err := core.Compile(regex)
	if err != nil {
		return rule, core.NewE201FromPosition(err.Error(), path, 1)
	}
	rule.pattern = re

	return rule, nil
}

// Run executes the the `existence`-based rule.
//
// This is simplest of the available extension points: it looks for any matches
// of its internal `pattern` (calculated from `NewExistence`) against the
// provided text.
func (e Existence) Run(blk nlp.Block, file *core.File) []core.Alert {
	alerts := []core.Alert{}

	for _, m := range core.FindAllString(e.pattern, blk.Text) {
		loc := []int{m.Index, m.Index + m.Length}

		a := core.Alert{Check: e.Name, Severity: e.Level, Span: loc,
			Link: e.Link, Match: m.String(), Action: e.Action}

		a.Message, a.Description = formatMessages(e.Message,
			e.Description, m.String())

		alerts = append(alerts, a)
	}

	return alerts
}

// Fields provides access to the internal rule definition.
func (e Existence) Fields() Definition {
	return e.Definition
}

// Pattern is the internal regex pattern used by this rule.
func (e Existence) Pattern() string {
	return e.pattern.String()
}
