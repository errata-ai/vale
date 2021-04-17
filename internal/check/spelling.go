package check

import (
	"path/filepath"
	"reflect"
	"strings"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
	"github.com/errata-ai/vale/v2/pkg/spell"
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
	// `custom` (`bool`): Turn off the default filters for acronyms,
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

	// `dicpath` overrides the environments `DICPATH` setting.
	Dicpath string

	// Custom dictionaries will be loaded on top of the built-in one.
	Append bool

	// A slice of Hunspell-compatible dictionaries to load.
	Dictionaries []string

	exceptRe *regexp.Regexp
	gs       *spell.Checker
}

func addFilters(s *Spelling, generic baseCheck, cfg *core.Config) error {
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

func addExceptions(s *Spelling, generic baseCheck, cfg *core.Config) error {
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

// NewSpelling creates a new `spelling`-based rule.
func NewSpelling(cfg *core.Config, generic baseCheck) (Spelling, error) {
	var model *spell.Checker

	rule := Spelling{}
	path := generic["path"].(string)
	name := generic["name"].(string)

	addFilters(&rule, generic, cfg)
	addExceptions(&rule, generic, cfg)

	err := mapstructure.WeakDecode(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	model, err = makeSpeller(&rule, cfg)
	if err != nil {
		return rule, core.NewE201FromPosition(err.Error(), path, 1)
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
		exists := model.AddWordListFile(vocab)
		if exists != nil {
			vocab, _ = filepath.Abs(ignore)
			exists = model.AddWordListFile(vocab)
			// TODO: check error?
		}
	}

	if !rule.Custom {
		rule.Filters = append(rule.Filters, defaultFilters...)
	}
	rule.gs = model

	return rule, nil
}

// Run performs spell-checking on the provided text.
func (s Spelling) Run(blk nlp.Block, f *core.File) []core.Alert {
	alerts := []core.Alert{}

	txt := blk.Text
	// This ensures that we respect `.aff` entries like `ICONV ’ '`,
	// allowing us to avoid false positives.
	//
	// See https://github.com/errata-ai/vale/v2/issues/148.
	txt = s.gs.Convert(txt)

OUTER:
	for _, word := range nlp.WordTokenizer.Tokenize(txt) {
		for _, filter := range s.Filters {
			if filter.MatchString(word) {
				continue OUTER
			}
		}

		if !s.gs.Spell(word) && !isMatch(s.exceptRe, word) {
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

// Fields provides access to the internal rule definition.
func (s Spelling) Fields() Definition {
	return s.Definition
}

// Pattern is the internal regex pattern used by this rule.
func (s Spelling) Pattern() string {
	return ""
}

func makeSpeller(s *Spelling, cfg *core.Config) (*spell.Checker, error) {
	var options []spell.CheckerOption

	affloc := core.FindAsset(cfg, s.Aff)
	dicloc := core.FindAsset(cfg, s.Dic)

	options = append(options, spell.WithDefault(s.Append))
	if s.Dicpath != "" {
		p, err := filepath.Abs(s.Dicpath)
		if err != nil {
			return nil, err
		}
		options = append(options, spell.WithPath(p))
	}

	if core.FileExists(affloc) && core.FileExists(dicloc) {
		return spell.NewChecker(spell.UsingDictionaryByPath(dicloc, affloc))
	} else if len(s.Dictionaries) > 0 {
		for _, name := range s.Dictionaries {
			options = append(options, spell.UsingDictionary(name))
		}
		return spell.NewChecker(options...)
	}

	return spell.NewChecker()
}
