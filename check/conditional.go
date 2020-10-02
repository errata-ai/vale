package check

import (
	"strings"

	"github.com/errata-ai/vale/config"
	"github.com/errata-ai/vale/core"
	"github.com/jdkato/regexp"
	"github.com/mitchellh/mapstructure"
)

// Conditional ensures that the present of First ensures the present of Second.
type Conditional struct {
	Definition `mapstructure:",squash"`
	// `ignorecase` (`bool`): Makes all matches case-insensitive.
	Ignorecase bool
	// `first` (`string`): The antecedent of the statement.
	First string
	// `second` (`string`): The consequent of the statement.
	Second string
	// `exceptions` (`array`): An array of strings to be ignored.
	Exceptions []string

	exceptRe *regexp.Regexp
	patterns []*regexp.Regexp
}

// NewConditional ...
func NewConditional(cfg *config.Config, generic baseCheck) (Conditional, error) {
	var re *regexp.Regexp
	var expression []*regexp.Regexp

	rule := Conditional{}
	path := generic["path"].(string)

	err := mapstructure.Decode(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	for term := range cfg.AcceptedTokens {
		rule.Exceptions = append(rule.Exceptions, term)
	}
	rule.exceptRe = regexp.MustCompile(strings.Join(rule.Exceptions, "|"))

	re, err = regexp.Compile(rule.Second)
	if err != nil {
		return rule, core.NewE201FromPosition(err.Error(), path, 1)
	}
	expression = append(expression, re)

	re, err = regexp.Compile(rule.First)
	if err != nil {
		return rule, core.NewE201FromPosition(err.Error(), path, 1)
	}
	expression = append(expression, re)

	// TODO: How do we support multiple patterns?
	rule.patterns = expression
	return rule, nil
}

// Run ...
func (c Conditional) Run(txt string, f *core.File) []core.Alert {
	alerts := []core.Alert{}

	// We first look for the consequent of the conditional statement.
	// For example, if we're ensuring that abbreviations have been defined
	// parenthetically, we'd have something like:
	//
	//     "WHO" [antecedent], "World Health Organization (WHO)" [consequent]
	//
	// In other words: if "WHO" exists, it must also have a definition -- which
	// we're currently looking for.
	matches := c.patterns[0].FindAllStringSubmatch(txt, -1)
	for _, mat := range matches {
		if len(mat) > 1 {
			// If we find one, we store it in a slice associated with this
			// particular file.
			f.Sequences = append(f.Sequences, mat[1])
		}
	}

	// Now we look for the antecedent.
	locs := c.patterns[1].FindAllStringIndex(txt, -1)
	for _, loc := range locs {
		s := txt[loc[0]:loc[1]]
		if !core.StringInSlice(s, f.Sequences) && !isMatch(c.exceptRe, s) {
			// If we've found one (e.g., "WHO") and we haven't marked it as
			// being defined previously, send an Alert.
			alerts = append(alerts, makeAlert(c.Definition, loc, txt))
		}
	}

	return alerts
}

// Fields ...
func (c Conditional) Fields() Definition {
	return c.Definition
}

// Pattern ...
func (c Conditional) Pattern() string {
	return ""
}
