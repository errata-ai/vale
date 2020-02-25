package check

import (
	"strings"

	"github.com/errata-ai/vale/core"
	"github.com/jdkato/prose/transform"
)

func lower(s string, ignore []string) bool {
	return s == strings.ToLower(s) || core.StringInSlice(s, ignore)
}

func upper(s string, ignore []string) bool {
	return s == strings.ToUpper(s) || core.StringInSlice(s, ignore)
}

func title(s string, ignore []string, tc *transform.TitleConverter) bool {
	count := 0.0
	words := 0.0
	expected := strings.Fields(tc.Title(s))
	for i, word := range strings.Fields(s) {
		if word == expected[i] || core.StringInSlice(word, ignore) {
			count++
		} else if word == strings.ToUpper(word) {
			count++
		}
		words++
	}
	return (count / words) > 0.8
}

func hasAnySuffix(s string, suffixes []string) bool {
	for _, sf := range suffixes {
		if strings.HasSuffix(s, sf) {
			return true
		}
	}
	return false
}

func sentence(s string, exceptions []string, indicators []string) bool {
	count := 0.0
	words := 0.0

	tokens := strings.Fields(strings.TrimRight(s, "?!.:"))
	for i, w := range tokens {
		prev := ""
		if i-1 >= 0 {
			prev = tokens[i-1]
		}

		if strings.Contains(w, "-") {
			// NOTE: This is necessary for works like `Top-level`.
			w = strings.Split(w, "-")[0]
		} else if strings.Contains(w, "'") {
			// NOTE: This is necessary for works like `Client's`.
			w = strings.Split(w, "'")[0]
		} else if strings.Contains(w, "’") {
			// NOTE: This is necessary for works like `Client's`.
			w = strings.Split(w, "’")[0]
		}

		if core.StringInSlice(w, exceptions) || w == strings.ToUpper(w) || hasAnySuffix(prev, indicators) {
			count++
		} else if i == 0 && w != strings.Title(strings.ToLower(w)) {
			return false
		} else if i == 0 || w == strings.ToLower(w) {
			count++
		}
		words++
	}

	return (count / words) > 0.8
}

var varToFunc = map[string]func(string, []string) bool{
	"$lower": lower,
	"$upper": upper,
}

var readabilityMetrics = []string{
	"Gunning Fog",
	"Coleman-Liau",
	"Flesch-Kincaid",
	"SMOG",
	"Automated Readability",
}
