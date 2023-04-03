package check

import (
	"github.com/errata-ai/regexp2"
	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
)

// Conditional ensures that the present of First ensures the present of Second.
type Conditional struct {
	Definition `mapstructure:",squash"`
	Exceptions []string
	patterns   []*regexp2.Regexp
	First      string
	Second     string
	exceptRe   *regexp2.Regexp
	Ignorecase bool
}

// NewConditional creates a new `conditional`-based rule.
func NewConditional(cfg *core.Config, generic baseCheck, path string) (Conditional, error) {
	var expression []*regexp2.Regexp
	rule := Conditional{}

	err := decodeRule(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	re, err := updateExceptions(rule.Exceptions, cfg.AcceptedTokens)
	if err != nil {
		return rule, core.NewE201FromPosition(err.Error(), path, 1)
	}
	rule.exceptRe = re

	re, err = regexp2.CompileStd(rule.Second)
	if err != nil {
		return rule, core.NewE201FromPosition(err.Error(), path, 1)
	}
	expression = append(expression, re)

	re, err = regexp2.CompileStd(rule.First)
	if err != nil {
		return rule, core.NewE201FromPosition(err.Error(), path, 1)
	}
	expression = append(expression, re)

	// TODO: How do we support multiple patterns?
	rule.patterns = expression
	return rule, nil
}

// Run evaluates the given conditional statement.
func (c Conditional) Run(blk nlp.Block, f *core.File) ([]core.Alert, error) {
	alerts := []core.Alert{}

	txt := blk.Text
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
			for _, m := range mat[1:] {
				if len(m) > 0 {
					f.Sequences = append(f.Sequences, m)
				}
			}
		}
	}

	// Now we look for the antecedent.
	locs := c.patterns[1].FindAllStringIndex(txt, -1)
	for _, loc := range locs {
		s := re2Loc(txt, loc)
		if !core.StringInSlice(s, f.Sequences) && !isMatch(c.exceptRe, s) {
			// If we've found one (e.g., "WHO") and we haven't marked it as
			// being defined previously, send an Alert.
			alerts = append(alerts, makeAlert(c.Definition, loc, txt))
		}
	}

	return alerts, nil
}

// Fields provides access to the internal rule definition.
func (c Conditional) Fields() Definition {
	return c.Definition
}

// Pattern is the internal regex pattern used by this rule.
func (c Conditional) Pattern() string {
	return ""
}
