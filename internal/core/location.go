package core

import (
	"strings"
	"sync"
	"unicode/utf8"

	"github.com/jdkato/regexp"
)

// This is used to store patterns as we compute them in `initialPosition`.
var cache = sync.Map{}

// initialPosition calculates the position of a match (given by the location in
// the reference document, `loc`) in the source document (`ctx`).
func initialPosition(ctx, txt string, a Alert) (int, string) {
	var idx int
	var pat *regexp.Regexp

	if a.Match == "" {
		// We have nothing to look for -- assume the rule applies to the entire
		// document (e.g., readability).
		return 1, ""
	}

	offset := strings.Index(ctx, txt)
	if offset >= 0 {
		ctx, _ = Substitute(ctx, ctx[:offset], '@')
	}

	sub := strings.ToValidUTF8(a.Match, "")
	if p, ok := cache.Load(sub); ok {
		pat = p.(*regexp.Regexp)
	} else {
		pat = regexp.MustCompile(`(?:^|\b|_)` + regexp.QuoteMeta(sub) + `(?:_|\b|$)`)
		cache.Store(sub, pat)
	}

	fsi := pat.FindStringIndex(ctx)
	if fsi == nil {
		idx = strings.Index(ctx, sub)
		if idx < 0 {
			// This should only happen if we're in a scope that contains inline
			// markup (e.g., a sentence with code spans).
			return guessLocation(ctx, txt, sub)
		}
	} else {
		idx = fsi[0]
	}

	if strings.HasPrefix(ctx[idx:], "_") {
		idx++ // We don't want to include the underscore boundary.
	}

	return utf8.RuneCountInString(ctx[:idx]) + 1, sub
}

func guessLocation(ctx, sub, match string) (int, string) {
	target := ""
	for _, s := range SentenceTokenizer.Tokenize(sub) {
		if s == match || strings.Index(s, match) > 0 {
			target = s
		}
	}

	if target == "" {
		return -1, sub
	}

	tokens := WordTokenizer.Tokenize(target)
	for _, text := range strings.Split(ctx, "\n") {
		if allStringsInString(tokens, text) {
			return strings.Index(ctx, text) + 1, text
		}
	}

	return -1, sub
}

func allStringsInString(subs []string, s string) bool {
	for _, sub := range subs {
		if strings.Index(s, sub) < 0 {
			return false
		}
	}
	return true
}
