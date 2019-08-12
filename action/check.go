package action

import (
	"fmt"

	"github.com/errata-ai/vale/check"
	"github.com/errata-ai/vale/core"
)

// ListConfig prints Vale's active configuration.
func ListConfig(config *core.Config, path string) error {
	fmt.Println(core.DumpConfig(config))
	return nil
}

// GetTemplate prints tamplate for the given extension point.
func GetTemplate(name string) error {
	template := check.GetTemplate(name)
	if template != "" {
		fmt.Println(template)
	} else {
		fmt.Printf(
			"'%s' not in %v!\n", name, check.GetExtenionPoints())
	}
	return nil
}
