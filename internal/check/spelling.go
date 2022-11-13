package check

import (
	"errors"
	"os"
	"path/filepath"
	"reflect"
	"strings"

	"github.com/errata-ai/regexp2"
	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
	"github.com/errata-ai/vale/v2/pkg/spell"
	"github.com/jdkato/regexp"
	"github.com/mitchellh/mapstructure"
)

var defaultFilters = []*regexp.Regexp{
	regexp.MustCompile(`[A-Z]{1}[a-z]+[A-Z]+\w+`),
	regexp.MustCompile(`[A-Z]+$`),
	regexp.MustCompile(`[^a-zA-Z_']`),
}

// Spelling checks text against a Hunspell dictionary.
type Spelling struct {
	Definition   `mapstructure:",squash"`
	Filters      []*regexp.Regexp
	Ignore       []string
	Exceptions   []string
	Dictionaries []string
	Aff          string
	Dic          string
	Dicpath      string
	Threshold    int
	exceptRe     *regexp2.Regexp
	gs           *spell.Checker
	Custom       bool
	Append       bool
}

func addFilters(s *Spelling, generic baseCheck, cfg *core.Config) error {
	if generic["filters"] != nil {
		// We pre-compile user-provided filters for efficiency.
		//
		// NOTE: This makes a big difference: ~50s -> ~13s.
		for _, filter := range generic["filters"].([]interface{}) {
			if pat, e := regexp.Compile(filter.(string)); e != nil {
				return e
			} else {
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
		s.exceptRe = regexp2.MustCompileStd(
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

	err := addFilters(&rule, generic, cfg)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	err = addExceptions(&rule, generic, cfg)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	err = mapstructure.WeakDecode(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	model, err = makeSpeller(&rule, cfg)
	if err != nil {
		return rule, core.NewE201FromPosition(err.Error(), path, 1)
	}

	for _, ignore := range rule.Ignore {
		if name == "Vale.Spelling" {
			for _, v := range cfg.Vocab {
				vocab := filepath.Join(
					cfg.StylesPath,
					"Vocab",
					v,
					ignore)
				_ = model.AddWordListFile(vocab)
			}
		} else {
			vocab := filepath.Join(cfg.StylesPath, ignore)
			if err = model.AddWordListFile(vocab); err != nil {
				vocab, _ = filepath.Abs(ignore)
				if err = model.AddWordListFile(vocab); err != nil {
					return rule, err
				}
			}
		}
	}

	if !rule.Custom {
		rule.Filters = append(rule.Filters, defaultFilters...)
	}
	rule.gs = model

	return rule, nil
}

// Run performs spell-checking on the provided text.
func (s Spelling) Run(blk nlp.Block, f *core.File) ([]core.Alert, error) {
	var alerts []core.Alert

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

	return alerts, nil
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
	var found bool

	affloc := core.FindAsset(cfg, s.Aff)
	dicloc := core.FindAsset(cfg, s.Dic)

	options = append(options, spell.WithDefault(s.Append))
	if s.Dicpath != "" {
		cwd, _ := os.Getwd()

		// There are a few cases we need to consider:
		paths := []string{
			// 1. An absolute path (similar to $DICPATH)
			s.Dicpath,
			// 2. Relative to StylesPath
			filepath.Join(cfg.StylesPath, s.Dicpath),
			// 3. Relative to config file
			filepath.Join(cfg.Root, s.Dicpath),
			// 4. Relative to cwd
			filepath.Join(cwd, s.Dicpath),
		}

		for _, p := range paths {
			if core.IsDir(p) {
				options = append(options, spell.WithPath(p))
				found = true
				break
			}
		}

		if !found {
			return nil, errors.New("unable to resolve dicpath")
		}
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
