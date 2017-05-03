package check

import (
	"strings"

	"github.com/jdkato/prose/transform"
	"github.com/xrash/smetrics"
)

func lower(s string) bool { return s == strings.ToLower(s) }
func upper(s string) bool { return s == strings.ToUpper(s) }

func title(s string) bool {
	return smetrics.Jaro(s, transform.Title(s)) > 0.97
}

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
