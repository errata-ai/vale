package ui

import "strings"

func pluralize(s string, n int) string {
	if n != 1 {
		return s + "s"
	}
	return s
}

func fixOutputSpacing(msg string) string {
	msg = strings.Replace(msg, "\n", " ", -1)
	msg = spaces.ReplaceAllString(msg, " ")
	return msg
}
