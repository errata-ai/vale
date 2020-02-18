/*
Package transform implements functions to manipulate UTF-8 encoded strings.
*/
package transform

import (
	"regexp"
	"strings"
	"unicode"
)

var spaces = regexp.MustCompile(" +")

func removeCase(s string, sep string, t func(rune) rune) string {
	out := ""
	old := ' '
	for i, c := range s {
		alpha := unicode.IsLetter(c) || unicode.IsNumber(c)
		mat := (i > 1 && unicode.IsLower(old) && unicode.IsUpper(c))
		if mat || !alpha || (unicode.IsSpace(c) && c != ' ') {
			out += " "
		}
		if alpha || c == ' ' {
			out += string(t(c))
		}
		old = c
	}
	return spaces.ReplaceAllString(strings.TrimSpace(out), sep)
}

// Simple returns a space-separated, lower-cased copy of the string s.
func Simple(s string) string {
	return removeCase(s, " ", unicode.ToLower)
}

// Dash returns a dash-separated, lower-cased copy of the string s.
func Dash(s string) string {
	return removeCase(s, "-", unicode.ToLower)
}

// Snake returns a underscore-separated, lower-cased copy of the string s.
func Snake(s string) string {
	return removeCase(s, "_", unicode.ToLower)
}

// Dot returns a period-separated, lower-cased copy of the string s.
func Dot(s string) string {
	return removeCase(s, ".", unicode.ToLower)
}

// Constant returns a underscore-separated, upper-cased copy of the string s.
func Constant(s string) string {
	return removeCase(s, "_", unicode.ToUpper)
}

// Pascal returns a Pascal-cased copy of the string s.
func Pascal(s string) string {
	out := ""
	wasSpace := false
	for i, c := range removeCase(s, " ", unicode.ToLower) {
		if i == 0 || wasSpace {
			c = unicode.ToUpper(c)
		}
		wasSpace = c == ' '
		if !wasSpace {
			out += string(c)
		}
	}
	return out
}

// Camel returns a Camel-cased copy of the string s.
func Camel(s string) string {
	first := ' '
	for _, c := range s {
		if unicode.IsLetter(c) || unicode.IsNumber(c) {
			first = c
			break
		}
	}
	body := Pascal(s)
	if len(body) > 1 {
		return strings.TrimSpace(string(unicode.ToLower(first)) + body[1:])
	}
	return s
}
