// Package glob implements pure-Go globbing utilities.
package glob

import (
	"strings"

	"github.com/gobwas/glob"
)

// Glob represents a glob pattern passed via `--glob`.
type Glob struct {
	Negated bool
	Pattern glob.Glob
}

// Match returns whether or not the Glob g matches the string query.
func (g Glob) Match(query string) bool {
	return g.Pattern.Match(query) != g.Negated
}

// NewGlob creates a Glob from the string pat.
func NewGlob(pat string) (Glob, error) {
	negate := false
	if strings.HasPrefix(pat, "!") {
		pat = strings.TrimLeft(pat, "!")
		negate = true
	}
	g, err := glob.Compile(pat)
	if err != nil {
		return Glob{}, err
	}
	return Glob{Pattern: g, Negated: negate}, nil
}
