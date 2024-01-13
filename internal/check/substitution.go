package check

import (
	"fmt"
	"sort"
	"strings"

	"github.com/errata-ai/regexp2"
	"golang.org/x/exp/maps"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
)

// Substitution switches the values of Swap for its keys.
type Substitution struct {
	Definition `mapstructure:",squash"`
	Exceptions []string
	repl       []string
	POS        string
	Swap       map[string]string
	exceptRe   *regexp2.Regexp
	pattern    *regexp2.Regexp
	Ignorecase bool
	Nonword    bool
	Vocab      bool
}

// NewSubstitution creates a new `substitution`-based rule.
func NewSubstitution(cfg *core.Config, generic baseCheck, path string) (Substitution, error) {
	rule := Substitution{Vocab: true}

	err := decodeRule(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	err = checkScopes(rule.Scope, path)
	if err != nil {
		return rule, err
	}
	tokens := ""

	re, err := updateExceptions(rule.Exceptions, cfg.AcceptedTokens, rule.Vocab)
	if err != nil {
		return rule, core.NewE201FromPosition(err.Error(), path, 1)
	}
	rule.exceptRe = re

	regex := makeRegexp(
		cfg.WordTemplate,
		rule.Ignorecase,
		func() bool { return !rule.Nonword },
		func() string { return "" }, true)

	terms := maps.Keys(rule.Swap)
	sort.Slice(terms, func(p, q int) bool {
		return len(terms[p]) > len(terms[q])
	})

	replacements := []string{}
	for _, regexstr := range terms {
		replacement := rule.Swap[regexstr]

		opens := strings.Count(regexstr, "(")
		if opens != strings.Count(regexstr, "(?") &&
			opens != strings.Count(regexstr, `\(`) {
			// We rely on manually-added capture groups to associate a match
			// with its replacement -- e.g.,
			//
			//    `(foo)|(bar)`, [replacement1, replacement2]
			//
			// where the first capture group ("foo") corresponds to the first
			// element of the replacements slice ("replacement1"). This means
			// that we can only accept non-capture groups from the user (the
			// indexing would be mixed up otherwise).
			//
			// TODO: Should we change this? Perhaps by creating a map of regex
			// to replacements?
			return rule, core.NewE201FromTarget(
				"capture group not supported; use '(?:' instead of '('", regexstr, path)
		}
		tokens += `(` + regexstr + `)|`
		replacements = append(replacements, replacement)
	}
	regex = fmt.Sprintf(regex, strings.TrimRight(tokens, "|"))

	re, err = regexp2.CompileStd(regex)
	if err != nil {
		return rule, core.NewE201FromPosition(err.Error(), path, 1)
	}

	rule.pattern = re
	rule.repl = replacements
	return rule, nil
}

// Run executes the the `substitution`-based rule.
//
// The rule looks for one pattern and then suggests a replacement.
func (s Substitution) Run(blk nlp.Block, _ *core.File) ([]core.Alert, error) {
	var alerts []core.Alert

	txt := blk.Text
	// Leave early if we can to avoid calling `FindAllStringSubmatchIndex`
	// unnecessarily.
	if !s.pattern.MatchStringStd(txt) {
		return alerts, nil
	}

	for _, submat := range s.pattern.FindAllStringSubmatchIndex(txt, -1) {
		for idx, mat := range submat {
			if mat != -1 && idx > 0 && idx%2 == 0 {
				loc := []int{mat, submat[idx+1]}

				converted, err := re2Loc(txt, loc)
				if err != nil {
					return alerts, err
				}

				// Based on the current capture group (`idx`), we can determine
				// the associated replacement string by using the `repl` slice:
				expected := s.repl[(idx/2)-1]
				observed := strings.TrimSpace(converted)

				same := matchToken(expected, observed, s.Ignorecase)
				if !same && !isMatch(s.exceptRe, observed) {
					action := s.Fields().Action
					if action.Name == "replace" && len(action.Params) == 0 {
						action.Params = strings.Split(expected, "|")

						// TODO: Is this a breaking change?
						/*if observed == core.CapFirst(observed) {
							cased := []string{}
							for _, param := range action.Params {
								cased = append(cased, core.CapFirst(param))
							}
							action.Params = cased
						}*/

						expected = core.ToSentence(action.Params, "or")

						// NOTE: For backwards-compatibility, we need to ensure
						// that we don't double quote.
						s.Message = convertMessage(s.Message)
					}

					a, aerr := makeAlert(s.Definition, loc, txt)
					if aerr != nil {
						return alerts, aerr
					}

					a.Message, a.Description = formatMessages(s.Message,
						s.Description, expected, observed)
					a.Action = action

					alerts = append(alerts, a)
				}
			}
		}
	}

	return alerts, nil
}

// Fields provides access to the internal rule definition.
func (s Substitution) Fields() Definition {
	return s.Definition
}

// Pattern is the internal regex pattern used by this rule.
func (s Substitution) Pattern() string {
	return s.pattern.String()
}

func convertMessage(s string) string {
	for _, spec := range []string{"'%s'", "\"%s\""} {
		if strings.Count(s, spec) == 2 {
			s = strings.Replace(s, spec, "%s", 1)
		}
	}
	return s
}
