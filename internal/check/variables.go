package check

import (
	"strings"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/jdkato/prose/transform"
	"github.com/jdkato/regexp"
)

func isMatch(r *regexp.Regexp, s string) bool {
	// TODO: `r.String() != ""`?
	//
	// Should we ensure that empty regexes == `nil`?
	return r != nil && r.String() != "" && r.MatchString(s)
}

func makeExceptions(ignore []string) *regexp.Regexp {
	s := ""
	if len(ignore) > 0 {
		s = `\b(?:` + strings.Join(ignore, "|") + `)\b|`
	}
	return regexp.MustCompile(s + `[\p{N}\p{L}*]+[^\s]*`)
}

func lower(s string, ignore []string, re *regexp.Regexp) bool {
	return s == strings.ToLower(s) || core.StringInSlice(s, ignore)
}

func upper(s string, ignore []string, re *regexp.Regexp) bool {
	return s == strings.ToUpper(s) || core.StringInSlice(s, ignore)
}

func title(s string, ignore []string, except *regexp.Regexp, tc *transform.TitleConverter) bool {
	count := 0.0
	words := 0.0

	re := makeExceptions(ignore)
	expected := re.FindAllString(tc.Title(s), -1)

	extent := len(expected)
	for i, word := range re.FindAllString(s, -1) {
		if i >= extent {
			// TODO: Look into this more.
			//
			// The problem is that `prose/transform` uses a different split
			// regex than `makeExceptions`, and we can't change the latter due
			// to https://github.com/errata-ai/vale/pull/253.
			//
			// In theory, this works because the only we'd find ourselves in
			// this situation is if the would-be entry at `expected[i]` is
			// listed as an exception, but it doesn't feel like a great
			// solution.
			count++
		} else if word == expected[i] || isMatch(except, word) {
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

func sentence(s string, ignore []string, indicators []string, except *regexp.Regexp) bool {
	count := 0.0
	words := 0.0

	re := makeExceptions(ignore)

	tokens := re.FindAllString(strings.TrimRight(s, "?!.:"), -1)
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

		if w == strings.ToUpper(w) || hasAnySuffix(prev, indicators) || isMatch(except, w) {
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

var varToFunc = map[string]func(string, []string, *regexp.Regexp) bool{
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
