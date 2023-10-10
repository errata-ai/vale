package check

import (
	"unicode/utf8"

	"github.com/errata-ai/regexp2"
	"github.com/jdkato/twine/strcase"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
)

// Capitalization checks the case of a string.
type Capitalization struct {
	Definition `mapstructure:",squash"`
	// `match` (`string`): $title, $sentence, $lower, $upper, or a pattern.
	Match string
	Check func(s string, re *regexp2.Regexp) bool
	// `style` (`string`): AP or Chicago; only applies when match is set to
	// $title.
	Style string
	// `exceptions` (`array`): An array of strings to be ignored.
	Exceptions []string
	// `indicators` (`array`): An array of suffixes that indicate the next
	// token should be ignored.
	Indicators []string

	// `threshold` (`float`): The minimum proportion of words that must be
	// (un)capitalized for a sentence to be considered correct.
	Threshold float64

	exceptRe *regexp2.Regexp
}

// NewCapitalization creates a new `capitalization`-based rule.
func NewCapitalization(cfg *core.Config, generic baseCheck, path string) (Capitalization, error) {
	rule := Capitalization{}

	err := decodeRule(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	err = checkScopes(rule.Scope, path)
	if err != nil {
		return rule, err
	}

	re, err := updateExceptions(rule.Exceptions, cfg.AcceptedTokens)
	if err != nil {
		return rule, core.NewE201FromPosition(err.Error(), path, 1)
	}
	rule.exceptRe = re

	// NOTE: This is OK since setting `Threshold` to 0 would mean that the rule
	// would never trigger.
	if rule.Threshold == 0 {
		rule.Threshold = 0.8
	}

	if rule.Match == "$title" {
		var tc *strcase.TitleConverter
		if rule.Style == "Chicago" {
			tc = strcase.NewTitleConverter(strcase.ChicagoStyle)
		} else {
			tc = strcase.NewTitleConverter(strcase.APStyle)
		}
		rule.Check = func(s string, re *regexp2.Regexp) bool {
			return title(s, re, tc, rule.Threshold)
		}
	} else if rule.Match == "$sentence" {
		rule.Check = func(s string, re *regexp2.Regexp) bool {
			return sentence(s, rule.Indicators, re, rule.Threshold)
		}
	} else if f, ok := varToFunc[rule.Match]; ok {
		rule.Check = f
	} else {
		re2, errc := regexp2.CompileStd(rule.Match)
		if errc != nil {
			return rule, core.NewE201FromPosition(errc.Error(), path, 1)
		}
		rule.Check = func(s string, r *regexp2.Regexp) bool {
			return re2.MatchStringStd(s) || isMatch(r, s)
		}
	}

	return rule, nil
}

// Run checks the capitalization style of the provided text.
func (o Capitalization) Run(blk nlp.Block, _ *core.File) ([]core.Alert, error) {
	alerts := []core.Alert{}

	txt := blk.Text
	if !o.Check(txt, o.exceptRe) {
		pos := []int{0, utf8.RuneCountInString(txt)}
		a, err := makeAlert(o.Definition, pos, txt)
		if err != nil {
			return alerts, err
		}
		alerts = append(alerts, a)
	}

	return alerts, nil
}

// Fields provides access to the internal rule definition.
func (o Capitalization) Fields() Definition {
	return o.Definition
}

// Pattern is the internal regex pattern used by this rule.
func (o Capitalization) Pattern() string {
	return ""
}
