package cli

import (
	"sort"

	"github.com/errata-ai/vale/v2/internal/core"
)

// PrintAlerts prints the given alerts in the user-specified format.
func PrintAlerts(linted []*core.File, config *core.Config) (bool, error) {
	if config.Flags.Sorted {
		sort.Sort(core.ByName(linted))
	}
	switch config.Flags.Output {
	case "JSON":
		return PrintJSONAlerts(linted), nil
	case "line":
		return PrintLineAlerts(linted, config.Flags.Relative), nil
	case "CLI":
		return PrintVerboseAlerts(linted, config.Flags.Wrap), nil
	default:
		return PrintCustomAlerts(linted, config.Flags.Output)
	}
}
