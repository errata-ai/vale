package check

import (
	"bytes"
	"path/filepath"
	"reflect"
	"strings"

	"github.com/errata-ai/vale/v2/config"
	"github.com/errata-ai/vale/v2/core"
	"github.com/errata-ai/vale/v2/data"
	"github.com/errata-ai/vale/v2/source"
	"github.com/errata-ai/vale/v2/spell"
	"github.com/jdkato/regexp"
	"github.com/mitchellh/mapstructure"
)

var defaultFilters = []*regexp.Regexp{
	regexp.MustCompile(`(?:\w+)?\.\w{1,4}\b`),
	regexp.MustCompile(`\b(?:[a-zA-Z]\.){2,}`),
	regexp.MustCompile(`0[xX][0-9a-fA-F]+`),
	regexp.MustCompile(`\w+-\w+`),
	regexp.MustCompile(`[A-Z]{1}[a-z]+[A-Z]+\w+`),
	regexp.MustCompile(`[0-9]`),
	regexp.MustCompile(`[A-Z]+$`),
	regexp.MustCompile(`\W`),
	regexp.MustCompile(`\w{3,}\.\w{3,}`),
	regexp.MustCompile(`@.*\b`),
}

// Spelling checks text against a Hunspell dictionary.
type Spelling struct {
	Definition `mapstructure:",squash"`
	// `aff` (`string`): The fully-qualified path to a Hunspell-compatible
	// `.aff` file.
	Aff string
	// `custom` (`bool`): Turn off the s.ult filters for acronyms,
	// abbreviations, and numbers.
	Custom bool
	// `dic` (`string`): The fully-qualified path to a Hunspell-compatible
	// `.dic` file.
	Dic string
	// `filters` (`array`): An array of patterns to ignore during spell
	// checking.
	Filters []*regexp.Regexp
	// `ignore` (`array`): An array of relative paths (from `StylesPath`) to
	// files consisting of one word per line to ignore.
	Ignore     []string
	Exceptions []string
	Threshold  int

	exceptRe *regexp.Regexp
	gs       *spell.GoSpell
}

func addFilters(s *Spelling, generic baseCheck, cfg *config.Config) error {
	if generic["filters"] != nil {
		// We pre-compile user-provided filters for efficiency.
		//
		// NOTE: This makes a big difference: ~50s -> ~13s.
		for _, filter := range generic["filters"].([]interface{}) {
			if pat, e := regexp.Compile(filter.(string)); e == nil {
				// TODO: Should we report malformed patterns?
				s.Filters = append(s.Filters, pat)
			}
		}
		delete(generic, "filters")
	}
	return nil
}

func addExceptions(s *Spelling, generic baseCheck, cfg *config.Config) error {
	if generic["ignore"] != nil {
		// Backwards compatibility: we need to be able to accept a single
		// or an array.
		if reflect.TypeOf(generic["ignore"]).String() == "string" {
			s.Ignore = append(s.Ignore, generic["ignore"].(string))
		} else {
			for _, ignore := range generic["ignore"].([]interface{}) {
				s.Ignore = append(s.Ignore, ignore.(string))
			}
		}
		delete(generic, "ignore")
	}

	for term := range cfg.AcceptedTokens {
		s.Exceptions = append(s.Exceptions, term)
		s.exceptRe = regexp.MustCompile(
			ignoreCase + strings.Join(s.Exceptions, "|"))
	}

	return nil
}

// NewSpelling ...
func NewSpelling(cfg *config.Config, generic baseCheck) (Spelling, error) {
	var model *spell.GoSpell

	rule := Spelling{}
	path := generic["path"].(string)
	name := generic["name"].(string)

	addFilters(&rule, generic, cfg)
	addExceptions(&rule, generic, cfg)

	err := mapstructure.Decode(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	affloc := source.FindAsset(cfg, rule.Aff)
	dicloc := source.FindAsset(cfg, rule.Dic)
	if core.FileExists(affloc) && core.FileExists(dicloc) {
		model, err = spell.NewGoSpell(affloc, dicloc)
	} else {
		// Fall back to the defaults:
		aff, _ := data.Asset("data/en_US-web.aff")
		dic, _ := data.Asset("data/en_US-web.dic")
		model, err = spell.NewGoSpellReader(
			bytes.NewReader(aff), bytes.NewReader(dic))
	}

	for _, ignore := range rule.Ignore {
		vocab := filepath.Join(cfg.StylesPath, ignore)
		if name == "Vale.Spelling" && cfg.Project != "" {
			// Special case: Project support
			vocab = filepath.Join(
				cfg.StylesPath,
				"Vocab",
				cfg.Project,
				ignore)
		}
		_, exists := model.AddWordListFile(vocab)
		if exists != nil {
			vocab, _ = filepath.Abs(ignore)
			_, exists = model.AddWordListFile(vocab)
			// TODO: check error?
		}
	}

	if !rule.Custom {
		rule.Filters = append(rule.Filters, defaultFilters...)
	}
	rule.gs = model

	return rule, nil
}

// Run ...
func (s Spelling) Run(txt string, f *core.File) []core.Alert {
	alerts := []core.Alert{}

	// This ensures that we respect `.aff` entries like `ICONV ’ '`,
	// allowing us to avoid false positives.
	//
	// See https://github.com/errata-ai/vale/v2/issues/148.
	txt = s.gs.InputConversion([]byte(txt))

OUTER:
	for _, word := range core.WordTokenizer.Tokenize(txt) {
		for _, filter := range s.Filters {
			if filter.MatchString(word) {
				continue OUTER
			}
		}

		known := s.gs.Spell(word) || s.gs.Spell(strings.ToLower(word))
		if !known && !isMatch(s.exceptRe, word) {
			offset := strings.Index(txt, word)
			loc := []int{offset, offset + len(word)}

			a := core.Alert{Check: s.Name, Severity: s.Level, Span: loc,
				Link: s.Link, Match: word, Action: s.Action}

			a.Message, a.Description = formatMessages(s.Message,
				s.Description, word)

			alerts = append(alerts, a)
		}
	}

	return alerts
}

// Fields ...
func (s Spelling) Fields() Definition {
	return s.Definition
}

// Pattern ...
func (s Spelling) Pattern() string {
	return ""
}
