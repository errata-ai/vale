package check

import (
	"strings"
	"unicode"
	"unicode/utf8"

	"github.com/jdkato/prose/transform"
)

func title(s string) bool { return s == transform.Title(s) }
func lower(s string) bool { return s == strings.ToLower(s) }
func upper(s string) bool { return s == strings.ToUpper(s) }
func sentence(s string) bool {
	first, n := utf8.DecodeRuneInString(s)
	return s == string(unicode.ToTitle(first))+strings.ToLower(s[n:])
}

var varToFunc = map[string]func(string) bool{
	"$title":    title,
	"$lower":    lower,
	"$upper":    upper,
	"$sentence": sentence,
}
