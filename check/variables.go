package check

import (
	"strings"

	"github.com/jdkato/prose/transform"
)

// TODO: maybe use some string similarity metric for title case?
func title(s string) bool { return s == transform.Title(s) }
func lower(s string) bool { return s == strings.ToLower(s) }
func upper(s string) bool { return s == strings.ToUpper(s) }
func sentence(s string) bool {
	count := 0.0
	words := 0.0
	for i, w := range strings.Fields(s) {
		if i > 0 && w == strings.Title(w) {
			count++
		}
		words++
	}
	return (count / words) < 0.4
}

var varToFunc = map[string]func(string) bool{
	"$title":    title,
	"$lower":    lower,
	"$upper":    upper,
	"$sentence": sentence,
}
