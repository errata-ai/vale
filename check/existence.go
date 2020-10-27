package check

import (
	"fmt"
	"strings"

	"github.com/errata-ai/vale/v2/config"
	"github.com/errata-ai/vale/v2/core"
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
	IgnoreCase bool
	// `nonword` (`bool`): Removes the default word boundaries (`\b`).
	Nonword bool
	// `raw` (`array`): A list of tokens to be concatenated into a pattern.
	Raw []string
	// `tokens` (`array`): A list of tokens to be transformed into a
	// non-capturing group.
	Tokens []string
	// A list of tokens that should negate a potential match.
	Exceptions []string

	pattern       *regexp.Regexp
	exceptRe      *regexp.Regexp
	hasExceptions bool
}

// NewExistence creates a new `Rule` that extends `Existence`.
func NewExistence(cfg *config.Config, generic baseCheck) (Existence, error) {
	rule := Existence{}

	path := ""
	if p, ok := generic["path"].(string); !ok {
		path = p
	}

	err := mapstructure.Decode(generic, &rule)
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

	re, err := regexp.Compile(regex)
	if err != nil {
		return rule, core.NewE201FromPosition(err.Error(), path, 1)
	}
	rule.pattern = re

	for term := range cfg.AcceptedTokens {
		rule.Exceptions = append(rule.Exceptions, term)
	}

	rule.hasExceptions = len(rule.Exceptions) > 0
	if rule.hasExceptions {
		re, err = regexp.Compile(strings.Join(rule.Exceptions, "|"))
		if err != nil {
			return rule, core.NewE201FromPosition(err.Error(), path, 1)
		}
		rule.exceptRe = re
	}

	return rule, nil
}

// Run executes the the existence-based rule.
//
// This is simplest of the available extension points: it looks for any matches
// of its internal `pattern` (calculated from `NewExistence`) against the
// provided text.
func (e Existence) Run(text string, file *core.File) []core.Alert {
	alerts := []core.Alert{}

	locs := e.pattern.FindAllStringIndex(text, -1)
	for _, loc := range locs {
		match := text[loc[0]:loc[1]]
		if !e.hasExceptions || !e.exceptRe.MatchString(match) {
			alerts = append(alerts, makeAlert(e.Definition, loc, text))
		}
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
