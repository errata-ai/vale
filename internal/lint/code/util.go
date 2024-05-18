package code

import (
	"encoding/json"
	"strings"
)

func toJSON(comments []Comment) string {
	j, _ := json.MarshalIndent(comments, "", "    ")
	return string(j)
}

func cStyle(s string) int {
	padding := 0

	if strings.HasPrefix(s, "//") || strings.HasPrefix(s, "/*") {
		padding = 2
		for i, r := range s {
			if i < 2 {
				continue
			}

			if r == ' ' {
				padding++
			} else {
				break
			}
		}
	}

	return padding
}
