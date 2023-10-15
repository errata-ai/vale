package spell

import (
	"regexp"
	"strings"
	"unicode"
)

// number form, may include dots, commas and dashes
var numberRegexp = regexp.MustCompile("^([0-9]+[.,-]?)+$")

// number form with units, e.g. 123ms, 12in  1ft
var numberUnitsRegexp = regexp.MustCompile("^[0-9]+[a-zA-Z]+$")

// 0x12FF or 0x1B or x12FF
// does anyone use 0XFF ??
var numberHexRegexp = regexp.MustCompile("^0?[x][0-9A-Fa-f]+$")

var numberBinaryRegexp = regexp.MustCompile("^0[b][01]+$")

var shaHashRegexp = regexp.MustCompile("^[0-9a-z]{40}$")

// splitter splits a text into words
// Highly likely this implementation will change so we are encapsulating.
type splitter struct {
	fn func(c rune) bool
}

// newSplitter creates a new splitter.  The input is a string in
// UTF-8 encoding.  Each rune in the string will be considered to be a
// valid word character.  Runes that are NOT here are deemed a word
// boundary Current implementation uses
// https://golang.org/pkg/strings/#FieldsFunc
func newSplitter(chars string) *splitter {
	s := splitter{}
	s.fn = (func(c rune) bool {
		// break if it's not a letter, and not another special character
		return !unicode.IsLetter(c) && !strings.ContainsRune(chars, c)
	})
	return &s
}

func isNumber(s string) bool {
	return numberRegexp.MatchString(s)
}

func isNumberBinary(s string) bool {
	return numberBinaryRegexp.MatchString(s)
}

// is word in the form of a "number with units", e.g. "101ms", "3ft",
// "5GB" if true, return the units, if not return empty string This is
// highly English based and not sure how applicable it is to other
// languages.
func isNumberUnits(s string) string {
	// regexp.FindAllStringSubmatch is too confusing
	if !numberUnitsRegexp.MatchString(s) {
		return ""
	}
	// Starts with a number
	for idx, ch := range s {
		if ch >= '0' && ch <= '9' {
			continue
		}
		return s[idx:]
	}
	panic("assertion failed")
}

func isNumberHex(s string) bool {
	return numberHexRegexp.MatchString(s)
}

func isHash(s string) bool {
	return shaHashRegexp.MatchString(s)
}
