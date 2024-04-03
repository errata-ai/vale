package nlp

import (
	"strings"
	"unicode"
	"unicode/utf8"
)

// StrLen returns the number of runes in a string.
func StrLen(s string) int {
	return utf8.RuneCountInString(s)
}

func hasAnyPrefix(s string, prefixes []string) bool {
	n := len(s)
	for _, prefix := range prefixes {
		if n > len(prefix) && strings.HasPrefix(s, prefix) {
			return true
		}
	}
	return false
}

func hasAnySuffix(s string, suffixes []string) bool {
	n := len(s)
	for _, suffix := range suffixes {
		if n > len(suffix) && strings.HasSuffix(s, suffix) {
			return true
		}
	}
	return false
}

func hasAnyIndex(s string, suffixes []string) int {
	n := len(s)
	for _, suffix := range suffixes {
		idx := strings.Index(s, suffix)
		if idx >= 0 && n > len(suffix) {
			return idx
		}
	}
	return -1
}

func allNonLetter(s string) bool {
	for _, r := range s {
		if unicode.IsLetter(r) {
			return false
		}
	}
	return true
}
