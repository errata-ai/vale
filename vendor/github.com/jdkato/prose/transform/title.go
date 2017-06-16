package transform

import (
	"regexp"
	"strings"
	"unicode"
	"unicode/utf8"

	"github.com/jdkato/prose/internal/util"
)

// An IgnoreFunc is a TitleConverter callback that decides whether or not the
// the string word should be capitalized. firstOrLast indicates whether or not
// word is the first or last word in the given string.
type IgnoreFunc func(word string, firstOrLast bool) bool

// A TitleConverter converts a string to title case according to its style.
type TitleConverter struct {
	ignore IgnoreFunc
}

var (
	// APStyle states to:
	// 1. Capitalize the principal words, including prepositions and
	//    conjunctions of four or more letters.
	// 2. Capitalize an article – the, a, an – or words of fewer than four
	//    letters if it is the first or last word in a title.
	APStyle IgnoreFunc = optionsAP

	// ChicagoStyle states to lowercase articles (a, an, the), coordinating
	// conjunctions (and, but, or, for, nor), and prepositions, regardless of
	// length, unless they are the first or last word of the title.
	ChicagoStyle IgnoreFunc = optionsChicago
)

// NewTitleConverter returns a new TitleConverter set to enforce the specified
// style.
func NewTitleConverter(style IgnoreFunc) *TitleConverter {
	return &TitleConverter{ignore: style}
}

// Title returns a copy of the string s in title case format.
func (tc *TitleConverter) Title(s string) string {
	idx, pos := 0, 0
	t := sanitizer.Replace(s)
	end := len(t)
	return splitRE.ReplaceAllStringFunc(s, func(m string) string {
		sm := strings.ToLower(m)
		pos = strings.Index(t[idx:], m) + idx
		prev := charAt(t, pos-1)
		ext := len(m)
		idx = pos + ext
		// pos > 0 && (pos+ext) < end && util.StringInSlice(sm, smallWords)
		if tc.ignore(sm, pos == 0 || idx == end) &&
			(prev == ' ' || prev == '-' || prev == '/') &&
			charAt(t, pos-2) != ':' && charAt(t, pos-2) != '-' &&
			(charAt(t, pos+ext) != '-' || charAt(t, pos-1) == '-') {
			return sm
		}
		return toTitle(m, prev)
	})
}

func optionsAP(word string, bounding bool) bool {
	return !bounding && util.StringInSlice(word, smallWords)
}

func optionsChicago(word string, bounding bool) bool {
	return !bounding && (util.StringInSlice(word, smallWords) || util.StringInSlice(word, prepositions))
}

var smallWords = []string{
	"a", "an", "and", "as", "at", "but", "by", "en", "for", "if", "in", "nor",
	"of", "on", "or", "per", "the", "to", "vs", "vs.", "via", "v", "v."}

var prepositions = []string{
	"with", "from", "into", "during", "including", "until", "against", "among",
	"throughout", "despite", "towards", "upon", "concerning", "about", "over",
	"through", "before", "between", "after", "since", "without", "under",
	"within", "along", "following", "across", "beyond", "around", "down",
	"near", "above"}

var splitRE = regexp.MustCompile(`[\p{N}\p{L}]+[^\s-/]*`)

// sanitizer replaces a set of Unicode characters with ASCII equivalents.
var sanitizer = strings.NewReplacer(
	"\u201c", `"`,
	"\u201d", `"`,
	"\u2018", "'",
	"\u2019", "'",
	"\u2013", "-",
	"\u2014", "-",
	"\u2026", "...")

// charAt returns the ith character of s, if it exists. Otherwise, it returns
// the first character.
func charAt(s string, i int) byte {
	if i >= 0 && i < len(s) {
		return s[i]
	}
	return s[0]
}

// toTitle returns a copy of the string m with its first Unicode letter mapped
// to its title case.
func toTitle(m string, prev byte) string {
	r, size := utf8.DecodeRuneInString(m)
	return string(unicode.ToTitle(r)) + m[size:]
}
