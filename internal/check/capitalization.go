package check

import (
	"unicode/utf8"

	"github.com/errata-ai/regexp2"
	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
	"github.com/jdkato/titlecase"
	"github.com/mitchellh/mapstructure"
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

	exceptRe *regexp2.Regexp
}

// NewCapitalization creates a new `capitalization`-based rule.
func NewCapitalization(cfg *core.Config, generic baseCheck) (Capitalization, error) {
	rule := Capitalization{}
	path := generic["path"].(string)

	err := mapstructure.WeakDecode(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	re, err := updateExceptions(rule.Exceptions, cfg.AcceptedTokens)
	if err != nil {
		return rule, core.NewE201FromPosition(err.Error(), path, 1)
	}
	rule.exceptRe = re

	if rule.Match == "$title" {
		var tc *titlecase.TitleConverter
		if rule.Style == "Chicago" {
			tc = titlecase.NewTitleConverter(titlecase.ChicagoStyle)
		} else {
			tc = titlecase.NewTitleConverter(titlecase.APStyle)
		}
		rule.Check = func(s string, re *regexp2.Regexp) bool {
			return title(s, re, tc)
		}
	} else if rule.Match == "$sentence" {
		rule.Check = func(s string, re *regexp2.Regexp) bool {
			return sentence(s, rule.Indicators, re)
		}
	} else if f, ok := varToFunc[rule.Match]; ok {
		rule.Check = f
	} else {
		re, err := regexp2.CompileStd(rule.Match)
		if err != nil {
			return rule, core.NewE201FromPosition(err.Error(), path, 1)
		}
		rule.Check = func(s string, r *regexp2.Regexp) bool {
			return re.MatchStringStd(s) || isMatch(r, s)
		}
	}

	return rule, nil
}

// Run checks the capitalization style of the provided text.
func (o Capitalization) Run(blk nlp.Block, f *core.File) ([]core.Alert, error) {
	alerts := []core.Alert{}

	txt := blk.Text
	if !o.Check(txt, o.exceptRe) {
		pos := []int{0, utf8.RuneCountInString(txt)}
		alerts = append(alerts, makeAlert(o.Definition, pos, txt))
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
