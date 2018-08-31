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
		}
		words++
	}
	return (count / words) > 0.8
}

func sentence(s string, ignore []string) bool {
	count := 0.0
	words := 0.0
	for i, w := range strings.Fields(s) {
		if core.StringInSlice(w, ignore) {
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
	"$lower":    lower,
	"$upper":    upper,
	"$sentence": sentence,
}

var readabilityMetrics = []string{
	"Gunning Fog",
	"Coleman-Liau",
	"Flesch-Kincaid",
	"SMOG",
	"Automated Readability",
}
