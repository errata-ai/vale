package ui

import (
	"sort"

	"github.com/errata-ai/vale/v2/config"
	"github.com/errata-ai/vale/v2/core"
)

// PrintAlerts prints the given alerts in the user-specified format.
func PrintAlerts(linted []*core.File, config *config.Config) (bool, error) {
	if config.Sorted {
		sort.Sort(core.ByName(linted))
	}
	switch config.Output {
	case "JSON":
		return PrintJSONAlerts(linted), nil
	case "line":
		return PrintLineAlerts(linted, config.Relative), nil
	case "CLI":
		return PrintVerboseAlerts(linted, config.Wrap), nil
	default:
		return PrintCustomAlerts(linted, config.Output)
	}
}
