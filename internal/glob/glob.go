// Package glob implements pure-Go globbing utilities.
package glob

import (
	"path/filepath"
	"strings"

	"github.com/bmatcuk/doublestar/v4"
	"github.com/gobwas/glob"
)

type Glob struct {
	Pattern string
	Negated bool
}

// Match returns whether or not the Glob g matches the string query.
func (g Glob) Match(query string) bool {
	q := filepath.ToSlash(query)

	if strings.Contains(g.Pattern, "**") {
		matched, _ := doublestar.Match(g.Pattern, q)
		return matched != g.Negated
	}

	p := glob.MustCompile(g.Pattern)
	return p.Match(q) != g.Negated
}

// MatchAny returns whether or not the Glob g matches any of the strings in
// query.
func (g Glob) MatchAny(query []string) bool {
	for _, q := range query {
		if g.Match(q) {
			return true
		}
	}
	return false
}

// NewGlob creates a Glob from the string pat.
func NewGlob(pat string) (Glob, error) {
	negate := false
	if strings.HasPrefix(pat, "!") {
		pat = strings.TrimLeft(pat, "!")
		negate = true
	}
	_, err := doublestar.PathMatch(pat, "")
	if err != nil {
		return Glob{}, err
	}
	return Glob{Pattern: pat, Negated: negate}, nil
}

// Compile is a wrapper around NewGlobal for backwards compatibility.
func Compile(pat string) (Glob, error) {
	return NewGlob(pat)
}
