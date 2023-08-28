package check

import (
	"strings"

	"github.com/errata-ai/regexp2"
	"github.com/jdkato/titlecase"
)

func isMatch(r *regexp2.Regexp, s string) bool {
	// TODO: `r.String() != ""`?
	//
	// Should we ensure that empty regexes == `nil`?
	if r == nil || r.String() == "" {
		return false
	}
	match, err := r.MatchString(s)
	if err != nil {
		return false
	}
	return match
}

func lower(s string, re *regexp2.Regexp) bool {
	return s == strings.ToLower(s) || isMatch(re, s)
}

func upper(s string, re *regexp2.Regexp) bool {
	return s == strings.ToUpper(s) || isMatch(re, s)
}

func title(s string, except *regexp2.Regexp, tc *titlecase.TitleConverter, threshold float64) bool {
	count := 0.0
	words := 0.0

	ps := `[\p{N}\p{L}*]+[^\s]*`
	if except != nil && except.String() != "" {
		ps = except.String() + "|" + ps
	}
	re := regexp2.MustCompileStd(ps)

	expected := re.FindAllString(tc.Title(s), -1)

	extent := len(expected)
	for i, word := range re.FindAllString(s, -1) {
		if i >= extent { //nolint:gocritic
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

	return (count / words) >= threshold
}

func hasAnySuffix(s string, suffixes []string) bool {
	for _, sf := range suffixes {
		if strings.HasSuffix(s, sf) {
			return true
		}
	}
	return false
}

func sentence(s string, indicators []string, except *regexp2.Regexp, threshold float64) bool {
	count := 0.0
	words := 0.0

	ps := `[\p{N}\p{L}*]+[^\s]*`
	if except != nil {
		ps = except.String() + "|" + ps
	}
	re := regexp2.MustCompileStd(ps)

	tokens := re.FindAllString(strings.TrimRight(s, "?!.:"), -1)
	for i, w := range tokens {
		prev := ""
		if i-1 >= 0 {
			prev = tokens[i-1]
		}
		t := w

		if strings.Contains(w, "-") { //nolint:gocritic
			// NOTE: This is necessary for words like `Top-level`.
			w = strings.Split(w, "-")[0]
		} else if strings.Contains(w, "'") {
			// NOTE: This is necessary for words like `Client's`.
			w = strings.Split(w, "'")[0]
		} else if strings.Contains(w, "’") {
			// NOTE: This is necessary for words like `Client's`.
			w = strings.Split(w, "’")[0]
		}

		if w == strings.ToUpper(w) || hasAnySuffix(prev, indicators) || isMatch(except, t) { //nolint:gocritic
			count++
		} else if i == 0 && w != strings.Title(strings.ToLower(w)) { //nolint:staticcheck
			return false
		} else if i == 0 || w == strings.ToLower(w) {
			count++
		}
		words++
	}

	return (count / words) >= threshold
}

var varToFunc = map[string]func(string, *regexp2.Regexp) bool{
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
