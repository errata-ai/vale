package check

import (
	"fmt"
	"strings"

	"github.com/errata-ai/regexp2"
	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
	"github.com/jdkato/prose/tag"
	"github.com/mitchellh/mapstructure"
)

// NLPToken represents a token of text with NLP-related attributes.
type NLPToken struct {
	Pattern string
	Negate  bool
	Tag     string
	Skip    int

	re       *regexp2.Regexp
	optional bool
}

// Sequence looks for a user-defined sequence of tokens.
type Sequence struct {
	Definition `mapstructure:",squash"`
	Ignorecase bool
	Tokens     []NLPToken

	needsTagging bool
	history      []int
}

// NewSequence creates a new rule from the provided `baseCheck`.
func NewSequence(cfg *core.Config, generic baseCheck) (Sequence, error) {
	rule := Sequence{}
	path := generic["path"].(string)

	makeTokens(&rule, generic, cfg)

	err := mapstructure.WeakDecode(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	for i, token := range rule.Tokens {
		if !rule.needsTagging && token.Tag != "" {
			rule.needsTagging = true
		}

		if token.Pattern != "" {
			regex := makeRegexp(
				cfg.WordTemplate,
				rule.Ignorecase,
				func() bool { return false },
				func() string { return "" },
				false)
			regex = fmt.Sprintf(regex, token.Pattern)

			re, err := regexp2.CompileStd(regex)
			if err != nil {
				return rule, core.NewE201FromPosition(err.Error(), path, 1)
			}
			rule.Tokens[i].re = re
		}

	}

	rule.Definition.Scope = []string{"summary"}
	return rule, nil
}

// Fields provides access to the rule definition.
func (s Sequence) Fields() Definition {
	return s.Definition
}

// Pattern is the internal regex pattern used by this rule.
func (s Sequence) Pattern() string {
	return ""
}

func makeTokens(s *Sequence, generic baseCheck, cfg *core.Config) error {
	for _, token := range generic["tokens"].([]interface{}) {
		tok := NLPToken{}
		mapstructure.WeakDecode(token, &tok)
		s.Tokens = append(s.Tokens, tok)

		tok.optional = true
		for i := tok.Skip; i > 0; i-- {
			s.Tokens = append(s.Tokens, tok)
		}
	}
	delete(generic, "tokens")
	return nil
}

func tokensMatch(token NLPToken, word tag.Token) bool {
	failedTag, err := regexp2.MatchString(token.Tag, word.Tag)
	if err != nil {
		// FIXME: return the error instead ...
		panic(err)
	}

	failedTag = !failedTag
	failedTok := (token.re != nil && token.re.MatchStringStd(word.Text) == token.Negate)

	if (token.Pattern == "" && failedTag) ||
		(token.Tag == "" && failedTok) ||
		(token.Tag != "" && token.Pattern != "") && (failedTag || failedTok) {
		return false
	}

	return true
}

func sequenceMatches(idx int, chk Sequence, target string, words []tag.Token) ([]string, int) {
	toks := chk.Tokens
	text := []string{}

	sizeT := len(toks)
	sizeW := len(words)
	index := 0

	for jdx, tok := range words {
		if tok.Text == target && !core.IntInSlice(jdx, chk.history) {
			index = jdx
			// We've found our context.
			//
			// The *first* token with a `pattern` becomes the anchor of our
			// search. From there, we must check both its left- and right-hand
			// sides to ensure the sequence matches.
			if idx > 0 {
				// Check the left-end of the sequence:
				//
				// If the anchor is the first token, then there's no left-hand
				// side to check -- hence, `idx > 0`.
				for i := 1; idx-i >= 0; i++ {
					word := words[jdx-i]
					text = append([]string{word.Text}, text...)

					mat := tokensMatch(toks[idx-i], word)
					opt := toks[idx-i].optional
					if !mat && !opt {
						return []string{}, index
					} else if mat && opt {
						break
					}
				}
			}
			if idx < sizeT {
				// Check the right-end of the sequence
				//
				// If the anchor is the last token, then there's no right-hand
				// side to check.
				for i := 0; idx+i < sizeT; i++ {
					if jdx+i >= sizeW {
						return []string{}, index
					}
					word := words[jdx+i]
					text = append(text, word.Text)

					mat := tokensMatch(toks[idx+i], word)
					opt := toks[idx+i].optional
					if !mat && !opt {
						return []string{}, index
					} else if mat && opt {
						break
					}
				}
			}
			break
		}
	}

	return text, index
}

func stepsToString(steps []string) string {
	s := ""
	for _, step := range steps {
		if strings.HasPrefix(step, "'") {
			s += step
		} else {
			s += " " + step
		}
	}
	return strings.Trim(s, " ")
}

// Run looks for the user-defined sequence of tokens.
func (s Sequence) Run(blk nlp.Block, f *core.File) []core.Alert {
	var alerts []core.Alert
	var offset []string

	// NOTE: This *requires* that ALL sequence rules be summary-scoped --
	// otherwise, we would be calculating POS tags for *every* rule
	// invocation.
	words := nlp.TextToTokens(blk.Text, &f.NLP)

	txt := blk.Text
	for idx, tok := range s.Tokens {
		if !tok.Negate && tok.Pattern != "" {
			for _, loc := range tok.re.FindAllStringIndex(txt, -1) {
				target := re2Loc(txt, loc)
				// These are all possible violations in `txt`:
				steps, index := sequenceMatches(idx, s, target, words)
				s.history = append(s.history, index)

				if len(steps) > 0 {
					seq := stepsToString(steps)
					idx := strings.Index(txt, seq)

					a := core.Alert{
						Check: s.Name, Severity: s.Level, Link: s.Link,
						Span: []int{idx, idx + len(seq)}, Hide: false,
						Match: seq, Action: s.Action}

					a.Message, a.Description = formatMessages(s.Message,
						s.Description, steps...)
					a.Offset = offset

					alerts = append(alerts, a)
					offset = []string{}
				} else {
					offset = append(offset, target)
				}
			}
			break
		}
	}

	return alerts
}
