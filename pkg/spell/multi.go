package spell

import (
	"bytes"
	"os"
	"path/filepath"
)

var defaultOpts = Options{
	path: os.Getenv("DICPATH"),
	load: false,
}

// Options controls the checker-creation process:
type Options struct {
	path  string
	names []string
	dics  []dictionary
	load  bool
}

// A CheckerOption is a setting that changes the checker-creation process.
type CheckerOption func(opts *Options)

// WithPath specifies the location of Hunspell-compatible dictionaries.
func WithPath(path string) CheckerOption {
	return func(opts *Options) {
		opts.path = path
	}
}

// WithDefault specifies if Vale's default dictionary should be loaded.
func WithDefault(load bool) CheckerOption {
	return func(opts *Options) {
		opts.load = load
	}
}

// UsingDictionary loads the given Hunspell-compatible dictionary.
func UsingDictionary(name string) CheckerOption {
	return func(opts *Options) {
		opts.names = append(opts.names, name)
	}
}

// UsingDictionaryByPath loads the given Hunspell-compatible dictionary using
// the given local paths.
func UsingDictionaryByPath(dic, aff string) CheckerOption {
	return func(opts *Options) {
		opts.dics = append(opts.dics, dictionary{dic, aff})
	}
}

// Checker is a spell-checker based on multiple dictionaries.
type Checker struct {
	options  Options
	checkers []*goSpell
}

// NewChecker creates a spell checker from multiple
// Hunspell-compatible dictionaries.
func NewChecker(options ...CheckerOption) (*Checker, error) {
	base := defaultOpts
	for _, applyOpt := range options {
		applyOpt(&base)
	}

	checker := Checker{options: base}
	for _, name := range base.names {
		if err := checker.loadDic(name); err != nil {
			return &checker, err
		}
	}

	for _, entry := range base.dics {
		c, err := newGoSpell(entry.aff, entry.dic)
		if err != nil {
			return &checker, err
		}
		checker.checkers = append(checker.checkers, c)
	}

	if len(checker.checkers) == 0 || base.load {
		// use default dictionary ...
		aff, err := Asset("pkg/spell/data/en_US-web.aff")
		if err != nil {
			return &checker, err
		}

		dic, err := Asset("pkg/spell/data/en_US-web.dic")
		if err != nil {
			return &checker, err
		}

		c, err := newGoSpellReader(bytes.NewReader(aff), bytes.NewReader(dic))
		if err != nil {
			return &checker, err
		}

		checker.checkers = append(checker.checkers, c)
	}

	return &checker, nil
}

// Spell checks to see if a given word is in the internal dictionaries.
func (m *Checker) Spell(word string) bool {
	for _, checker := range m.checkers {
		if checker.spell(word) {
			return true
		}
	}
	return false
}

// Convert performs character substitutions (ICONV).
func (m *Checker) Convert(s string) string {
	for _, checker := range m.checkers {
		s = checker.inputConversion([]byte(s))
	}
	return s
}

// AddWordListFile reads in a word list file
func (m *Checker) AddWordListFile(name string) error {
	for _, checker := range m.checkers {
		_, err := checker.addWordListFile(name)
		if err != nil {
			return err
		}
	}
	return nil
}

func (m *Checker) loadDic(name string) error {
	dic, err := os.Open(filepath.Join(m.options.path, name+".dic"))
	if err != nil {
		return err
	}

	aff, err := os.Open(filepath.Join(m.options.path, name+".aff"))
	if err != nil {
		return err
	}

	s, err := newGoSpellReader(aff, dic)
	if err != nil {
		return err
	}
	m.checkers = append(m.checkers, s)

	return nil
}
