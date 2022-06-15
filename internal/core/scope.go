package core

import "strings"

// A Selector represents a named section of text.
type Selector struct {
	Value []string // e.g., text.comment.line.py
}

// Sections splits a Selector into its parts -- e.g., text.comment.line.py ->
// []string{"text", "comment", "line", "py"}.
func (s Selector) Sections() []string {
	parts := []string{}
	for _, m := range s.Value {
		parts = append(parts, strings.Split(m, ".")...)
	}
	return parts
}

// Contains determines if all if sel's sections are in s.
func (s Selector) Contains(sel Selector) bool {
	return AllStringsInSlice(sel.Sections(), s.Sections())
}

// ContainsString determines if all if sel's sections are in s.
func (s Selector) ContainsString(scope []string) bool {
	for _, option := range scope {
		sel := Selector{Value: []string{option}}
		if s.Contains(sel) {
			return true
		}
	}
	return false
}

// Equal determines if sel == s.
func (s Selector) Equal(sel Selector) bool {
	if len(s.Value) == len(sel.Value) {
		for i, v := range s.Value {
			if sel.Value[i] != v {
				return false
			}
		}
		return true
	}
	return false
}

// Has determines if s has a part equal to scope.
func (s Selector) Has(scope string) bool {
	return StringInSlice(scope, s.Sections())
}
