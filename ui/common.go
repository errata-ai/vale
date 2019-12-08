package ui

import (
	"regexp"
	"strings"
)

var spaces = regexp.MustCompile(" +")

func fixOutputSpacing(msg string) string {
	msg = strings.Replace(msg, "\n", " ", -1)
	msg = spaces.ReplaceAllString(msg, " ")
	return msg
}

func pluralize(s string, n int) string {
	if n != 1 {
		return s + "s"
	}
	return s
}
