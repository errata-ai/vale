package check

import (
	"fmt"
	"strings"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
	"github.com/jdkato/prose/transform"
	"github.com/jdkato/regexp"
	"github.com/mitchellh/mapstructure"
)

// Capitalization checks the case of a string.
type Capitalization struct {
	Definition `mapstructure:",squash"`
	// `match` (`string`): $title, $sentence, $lower, $upper, or a pattern.
	Match string
	Check func(s string, ignore []string, re *regexp.Regexp) bool
	// `style` (`string`): AP or Chicago; only applies when match is set to
	// $title.
	Style string
	// `exceptions` (`array`): An array of strings to be ignored.
	Exceptions []string
	// `indicators` (`array`): An array of suffixes that indicate the next
	// token should be ignored.
	Indicators []string

	exceptRe *regexp.Regexp
}

// NewCapitalization creates a new `capitalization`-based rule.
func NewCapitalization(cfg *core.Config, generic baseCheck) (Capitalization, error) {
	rule := Capitalization{}
	path := generic["path"].(string)

	err := mapstructure.WeakDecode(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	regex := makeRegexp(
		"",
		false,
		func() bool { return true },
		func() string { return "" },
		true)

	rule.Exceptions = updateExceptions(rule.Exceptions, cfg.AcceptedTokens)

	regex = fmt.Sprintf(regex, strings.Join(rule.Exceptions, "|"))
	if len(rule.Exceptions) > 0 {
		rule.exceptRe = regexp.MustCompile(regex)
	}

	if rule.Match == "$title" {
		var tc *transform.TitleConverter
		if rule.Style == "Chicago" {
			tc = transform.NewTitleConverter(transform.ChicagoStyle)
		} else {
			tc = transform.NewTitleConverter(transform.APStyle)
		}
		rule.Check = func(s string, ignore []string, re *regexp.Regexp) bool {
			return title(s, ignore, re, tc)
		}
	} else if rule.Match == "$sentence" {
		rule.Check = func(s string, ignore []string, re *regexp.Regexp) bool {
			return sentence(s, ignore, rule.Indicators, re)
		}
	} else if f, ok := varToFunc[rule.Match]; ok {
		rule.Check = f
	} else {
		re, err := regexp.Compile(rule.Match)
		if err != nil {
			return rule, core.NewE201FromPosition(err.Error(), path, 1)
		}
		rule.Check = func(s string, ignore []string, r *regexp.Regexp) bool {
			return re.MatchString(s) || core.StringInSlice(s, ignore)
		}
	}

	return rule, nil
}

// Run checks the capitalization style of the provided text.
func (o Capitalization) Run(blk nlp.Block, f *core.File) []core.Alert {
	alerts := []core.Alert{}

	txt := blk.Text
	if !o.Check(txt, o.Exceptions, o.exceptRe) {
		alerts = append(alerts, makeAlert(o.Definition, []int{0, len(txt)}, txt))
	}

	return alerts
}

// Fields provides access to the internal rule definition.
func (o Capitalization) Fields() Definition {
	return o.Definition
}

// Pattern is the internal regex pattern used by this rule.
func (o Capitalization) Pattern() string {
	return ""
}
