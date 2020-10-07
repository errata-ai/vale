package ui

import (
	"encoding/json"
	"regexp"
	"strings"

	"github.com/errata-ai/vale/config"
	"github.com/errata-ai/vale/core"
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

func getJSON(data interface{}) string {
	b, err := json.MarshalIndent(data, "", "  ")
	if err != nil {
		return err.Error()
	}
	return string(b)
}

// PrintAlerts prints the given alerts in the user-specified format.
func PrintAlerts(linted []*core.File, config *config.Config) bool {
	switch config.Output {
	case "JSON":
		return PrintJSONAlerts(linted)
	case "line":
		return PrintLineAlerts(linted, config.Relative)
	default:
		return PrintVerboseAlerts(linted, config.Wrap)
	}
}
