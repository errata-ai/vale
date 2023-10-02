// Package glob implements pure-Go globbing utilities.
package glob

import (
	"path/filepath"
	"strings"

	"github.com/bmatcuk/doublestar/v4"
)

// Glob represents a glob pattern passed via `--glob`.
type Glob struct {
	Pattern string
	Negated bool
}

// Match returns whether or not the Glob g matches the string query.
func (g Glob) Match(query string) bool {
	matched, _ := doublestar.Match(g.Pattern, filepath.ToSlash(query))
	return matched != g.Negated
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
