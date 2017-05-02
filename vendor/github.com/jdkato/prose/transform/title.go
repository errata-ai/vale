package transform

import (
	"regexp"
	"strings"
	"unicode"
	"unicode/utf8"

	"github.com/jdkato/prose/internal/util"
)

var splitRE = regexp.MustCompile(`[\w\p{L}]+[^\s-/]*`)

// smallWords is a slice of words that should not be capitalized.
var smallWords = []string{
	"a", "an", "and", "as", "at", "but", "by", "en", "for", "if", "in", "nor",
	"of", "on", "or", "per", "the", "to", "vs", "vs.", "via", "v", "v."}

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

// Title returns a copy of the string s in title case format.
//
// NOTE: Specical capitlization cases (e.g., "iPhone") and all uppercase
// strings are not currently handled correctly.
//
// TODO: Support AP, APA, MLA, and Chicago variations.
func Title(s string) string {
	idx, pos := 0, 0
	t := sanitizer.Replace(s)
	end := len(t)
	return splitRE.ReplaceAllStringFunc(s, func(m string) string {
		sm := strings.ToLower(m)
		pos = strings.Index(t[idx:], m) + idx
		prev := charAt(t, pos-1)
		ext := len(m)
		idx = pos + ext
		if pos > 0 && (pos+ext) < end && util.StringInSlice(sm, smallWords) &&
			(prev == ' ' || prev == '-' || prev == '/') &&
			charAt(t, pos-2) != ':' && charAt(t, pos-2) != '-' &&
			(charAt(t, pos+ext) != '-' || charAt(t, pos-1) == '-') {
			return sm
		}
		return toTitle(m, prev)
	})
}
