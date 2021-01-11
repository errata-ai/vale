package spell

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"os"
	"strings"

	"github.com/jdkato/regexp"
)

// goSpell is main struct
type goSpell struct {
	Config dictConfig
	Dict   map[string]struct{} // likely will contain some value later

	ireplacer *strings.Replacer // input conversion
	compounds []*regexp.Regexp
	splitter  *splitter
}

type dictionary struct {
	dic string
	aff string
}

// inputConversion does any character substitution before checking
//  This is based on the ICONV stanza
func (s *goSpell) inputConversion(raw []byte) string {
	sraw := string(raw)
	if s.ireplacer == nil {
		return sraw
	}
	return s.ireplacer.Replace(sraw)
}

// split a text into Words
func (s *goSpell) split(text string) []string {
	return s.splitter.split(text)
}

// addWordRaw adds a single word to the internal dictionary without modifications
// returns true if added
// return false is already exists
func (s *goSpell) addWordRaw(word string) bool {
	_, ok := s.Dict[word]
	if ok {
		// already exists
		return false
	}
	s.Dict[word] = struct{}{}
	return true
}

// addWordListFile reads in a word list file
func (s *goSpell) addWordListFile(name string) ([]string, error) {
	fd, err := os.Open(name)
	if err != nil {
		return nil, err
	}
	defer fd.Close()
	return s.addWordList(fd)
}

// addWordList adds basic word lists, just one word per line
//  Assumed to be in UTF-8
// TODO: hunspell compatible with "*" prefix for forbidden words
// and affix support
// returns list of duplicated words and/or error
func (s *goSpell) addWordList(r io.Reader) ([]string, error) {
	var duplicates []string
	scanner := bufio.NewScanner(r)
	for scanner.Scan() {
		word := strings.TrimSpace(scanner.Text())
		if len(word) == 0 || word == "#" {
			continue
		}
		if !s.addWordRaw(word) {
			duplicates = append(duplicates, word)
		}
	}
	if err := scanner.Err(); err != nil {
		return duplicates, err
	}
	return duplicates, nil
}

// spell checks to see if a given word is in the internal dictionaries
// TODO: add multiple dictionaries
func (s *goSpell) spell(word string) bool {
	_, ok := s.Dict[word]
	if ok {
		return true
	}
	_, ok = s.Dict[strings.ToLower(word)]
	if ok {
		return true
	}

	if isNumber(word) {
		return true
	}
	if isNumberHex(word) {
		return true
	}

	if isNumberBinary(word) {
		return true
	}

	if isHash(word) {
		return true
	}

	// check compounds
	for _, pat := range s.compounds {
		if pat.MatchString(word) {
			return true
		}
	}

	// Maybe a word with units? e.g. 100GB
	units := isNumberUnits(word)
	if units != "" {
		// dictionary appears to have list of units
		if _, ok = s.Dict[units]; ok {
			return true
		}
	}

	// if camelCase and each word e.g. "camel" "Case" is know
	// then the word is considered known
	if chunks := splitCamelCase(word); len(chunks) > 0 {
		if false {
			for _, chunk := range chunks {
				if _, ok = s.Dict[chunk]; !ok {
					return false
				}
			}
		}
		return true
	}

	return false
}

// newGoSpellReader creates a speller from io.Readers for
// Hunspell files
func newGoSpellReader(aff, dic io.Reader) (*goSpell, error) {
	affix, err := newDictConfig(aff)
	if err != nil {
		return nil, err
	}

	scanner := bufio.NewScanner(dic)
	// get first line
	if !scanner.Scan() {
		return nil, scanner.Err()
	}

	/* TODO:

	line := scanner.Text()
	i, err := strconv.ParseInt(line, 10, 64)
	if err != nil {
		return nil, err
	}

	gs := GoSpell{
		Dict:      make(map[string]struct{}, i*5),
		compounds: make([]*regexp.Regexp, 0, len(affix.CompoundRule)),
		splitter:  NewSplitter(affix.WordChars),
	}*/

	gs := goSpell{
		Dict:      make(map[string]struct{}),
		compounds: make([]*regexp.Regexp, 0, len(affix.CompoundRule)),
		splitter:  newSplitter(affix.WordChars),
	}

	words := []string{}
	for scanner.Scan() {
		line := scanner.Text()
		words, err = affix.expand(line, words)
		if err != nil {
			return nil, fmt.Errorf("Unable to process %q: %s", line, err)
		}

		if len(words) == 0 {
			continue
		}

		for _, word := range words {
			gs.Dict[word] = struct{}{}
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, err
	}

	for _, compoundRule := range affix.CompoundRule {
		pattern := "^"
		for _, key := range compoundRule {
			switch key {
			case '(', ')', '+', '?', '*':
				pattern = pattern + string(key)
			default:
				groups := affix.compoundMap[key]
				pattern = pattern + "(" + strings.Join(groups, "|") + ")"
			}
		}
		pattern = pattern + "$"
		pat, err := regexp.Compile(pattern)
		if err != nil {
			log.Printf("REGEXP FAIL= %q %s", pattern, err)
		} else {
			gs.compounds = append(gs.compounds, pat)
		}

	}

	if len(affix.IconvReplacements) > 0 {
		gs.ireplacer = strings.NewReplacer(affix.IconvReplacements...)
	}
	return &gs, nil
}

// newGoSpell from AFF and DIC Hunspell filenames
func newGoSpell(affFile, dicFile string) (*goSpell, error) {
	aff, err := os.Open(affFile)
	if err != nil {
		return nil, fmt.Errorf("Unable to open aff: %s", err)
	}
	defer aff.Close()
	dic, err := os.Open(dicFile)
	if err != nil {
		return nil, fmt.Errorf("Unable to open dic: %s", err)
	}
	defer dic.Close()
	h, err := newGoSpellReader(aff, dic)
	return h, err
}
