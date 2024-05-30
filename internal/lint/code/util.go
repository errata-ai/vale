package code

import (
	"encoding/json"
	"strings"
	"unicode/utf8"
)

func toJSON(comments []Comment) string {
	j, _ := json.MarshalIndent(comments, "", "    ")
	return string(j)
}

func cStyle(s string) int {
	return computePadding(s, []string{"/*", "//"})
}

func computePadding(s string, makers []string) int {
	padding := 0

	for _, m := range makers {
		if strings.HasPrefix(s, m) {
			l := utf8.RuneCountInString(m)

			padding = l
			for i, r := range s {
				if i < l {
					continue
				}

				if r == ' ' {
					padding++
				} else {
					break
				}
			}
		}
	}

	return padding
}
