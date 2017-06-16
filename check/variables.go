package check

import (
	"strings"

	"github.com/jdkato/prose/transform"
)

func lower(s string) bool { return s == strings.ToLower(s) }
func upper(s string) bool { return s == strings.ToUpper(s) }

func title(s string, tc *transform.TitleConverter) bool {
	count := 0.0
	words := 0.0
	expected := strings.Fields(tc.Title(s))
	for i, word := range strings.Fields(s) {
		if word == expected[i] {
			count++
		}
		words++
	}
	return (count / words) > 0.80
}

func sentence(s string) bool {
	count := 0.0
	words := 0.0
	for i, w := range strings.Fields(s) {
		if i > 0 && w == strings.Title(strings.ToLower(w)) {
			count++
		}
		words++
	}
	return (count / words) < 0.4
}

var varToFunc = map[string]func(string) bool{
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
