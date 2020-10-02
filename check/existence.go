package check

import (
	"fmt"
	"strings"

	"github.com/errata-ai/vale/config"
	"github.com/errata-ai/vale/core"
	"github.com/jdkato/regexp"
	"github.com/mitchellh/mapstructure"
)

// Existence checks for the present of Tokens.
type Existence struct {
	Definition `mapstructure:",squash"`
	// `append` (`bool`): Adds `raw` to the end of `tokens`, assuming both are
	// defined.
	Append bool
	// `ignorecase` (`bool`): Makes all matches case-insensitive.
	Ignorecase bool
	// `nonword` (`bool`): Removes the default word boundaries (`\b`).
	Nonword bool
	// `raw` (`array`): A list of tokens to be concatenated into a pattern.
	Raw []string
	// `tokens` (`array`): A list of tokens to be transformed into a
	// non-capturing group.
	Tokens []string

	pattern *regexp.Regexp
}

// NewExistence ...
func NewExistence(cfg *config.Config, generic baseCheck) (Existence, error) {
	rule := Existence{}
	path := generic["path"].(string)

	err := mapstructure.Decode(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	regex := makeRegexp(
		cfg.WordTemplate,
		rule.Ignorecase,
		func() bool { return !rule.Nonword && len(rule.Tokens) > 0 },
		func() string { return strings.Join(rule.Raw, "") },
		rule.Append)

	regex = fmt.Sprintf(regex, strings.Join(rule.Tokens, "|"))

	re, err := regexp.Compile(regex)
	if err != nil {
		return rule, core.NewE201FromPosition(err.Error(), path, 1)
	}

	rule.pattern = re
	return rule, nil
}

// Run ...
func (e Existence) Run(txt string, f *core.File) []core.Alert {
	alerts := []core.Alert{}
	locs := e.pattern.FindAllStringIndex(txt, -1)
	for _, loc := range locs {
		alerts = append(alerts, makeAlert(e.Definition, loc, txt))
	}
	return alerts
}

// Fields ...
func (e Existence) Fields() Definition {
	return e.Definition
}

// Pattern ...
func (e Existence) Pattern() string {
	return e.pattern.String()
}
