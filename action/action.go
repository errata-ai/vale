package action

import (
	"fmt"
	"path/filepath"

	"github.com/errata-ai/vale/check"
	"github.com/errata-ai/vale/core"
)

// ListConfig prints Vale's active configuration.
func ListConfig(config *core.Config) error {
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

// CompileRule returns a compiled rule.
func CompileRule(config *core.Config, path string) error {
	if path == "" {
		fmt.Println("invalid rule path")
	} else {
		fName := filepath.Base(path)

		mgr := check.Manager{AllChecks: make(map[string]check.Check), Config: config}
		if core.CheckError(mgr.Compile(fName, path), true) {
			for _, v := range mgr.AllChecks {
				fmt.Print(v.Pattern)
			}
		}
	}
	return nil
}
