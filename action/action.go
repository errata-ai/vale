package action

import (
	"fmt"
	"io/ioutil"
	"path/filepath"
	"strings"

	"github.com/errata-ai/vale/check"
	"github.com/errata-ai/vale/core"
	"github.com/errata-ai/vale/lint"
	"github.com/errata-ai/vale/ui"
	"github.com/jdkato/prose/v2"
)

// TagSentence assigns part-of-speech tags to the given sentence.
func TagSentence(config *core.Config, text string) error {
	doc, err := prose.NewDocument(text, prose.WithExtraction(false))
	if core.CheckError(err, true) {
		observed := []string{}
		for _, tok := range doc.Tokens() {
			observed = append(observed, (tok.Text + "/" + tok.Tag))
		}
		fmt.Println(strings.Join(observed, " "))
	}
	return nil
}

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

		mgr := check.Manager{
			AllChecks: make(map[string]check.Check),
			Config:    config,
			Scopes:    make(map[string]struct{}),
		}

		if core.CheckError(mgr.Compile(fName, path), true) {
			for _, v := range mgr.AllChecks {
				fmt.Print(v.Pattern)
			}
		}
	}
	return nil
}

// TestRule returns the linting results for a single rule
func TestRule(args []string) error {
	if len(args) == 2 && core.FileExists(args[0]) && core.FileExists(args[1]) {
		rule, _ := ioutil.ReadFile(args[0])

		// Create a pre-filled configuration:
		config := core.NewConfig()
		config.MinAlertLevel = 0
		config.GBaseStyles = append(config.GBaseStyles, "Test")
		config.InExt = ".txt" // default value

		// Create our check manager:
		mgr := check.Manager{
			AllChecks: make(map[string]check.Check),
			Config:    config,
			Scopes:    make(map[string]struct{}),
		}

		mgr.AddCheck(rule, "Test.Rule")
		linter := lint.Linter{CheckManager: &mgr}

		linted, err := linter.Lint([]string{args[1]}, "*")
		_ = ui.PrintJSONAlerts(linted)

		return err
	} else if len(args) != 2 {
		fmt.Println("missing argument")
	}

	fmt.Println("invalid arguments")
	return nil
}
