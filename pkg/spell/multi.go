package spell

import (
	"io"
)

// Dictionary represents a Hunspell-compatible dictionary.
type Dictionary struct {
	Dic io.Reader
	Aff io.Reader
}

// MultiSpell is a spell-checker based on multiple dictionaries.
type MultiSpell struct {
	checkers []*GoSpell
}

// NewMultiSpellReader creates a spell checker from multiple
// Hunspell-compatible dictionaries.
func NewMultiSpellReader(dics []Dictionary) (*MultiSpell, error) {
	checker := MultiSpell{}
	for _, entry := range dics {
		s, err := NewGoSpellReader(entry.Aff, entry.Dic)
		if err != nil {
			return &checker, err
		}
		checker.checkers = append(checker.checkers, s)
	}
	return &checker, nil
}

// Spell checks to see if a given word is in the internal dictionaries.
func (m *MultiSpell) Spell(word string) bool {
	for _, checker := range m.checkers {
		if checker.Spell(word) {
			return true
		}
	}
	return false
}

// Convert performs character substitutions (ICONV).
func (m *MultiSpell) Convert(s string) string {
	for _, checker := range m.checkers {
		s = checker.InputConversion([]byte(s))
	}
	return s
}

// AddWordListFile reads in a word list file
func (m *MultiSpell) AddWordListFile(name string) error {
	for _, checker := range m.checkers {
		_, err := checker.AddWordListFile(name)
		if err != nil {
			return err
		}
	}
	return nil
}
