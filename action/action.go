package action

import (
	"errors"
	"fmt"
	"path/filepath"
	"strings"

	"github.com/errata-ai/vale/check"
	"github.com/errata-ai/vale/config"
	"github.com/errata-ai/vale/core"
	"github.com/errata-ai/vale/lint"
	"github.com/errata-ai/vale/source"
	"github.com/errata-ai/vale/ui"
)

// TagSentence assigns part-of-speech tags to the given sentence.
func TagSentence(text string) error {
	observed := []string{}
	for _, tok := range core.TextToTokens(text, true) {
		observed = append(observed, (tok.Text + "/" + tok.Tag))
	}
	fmt.Println(strings.Join(observed, " "))
	return nil
}

// ListConfig prints Vale's active configuration.
func ListConfig(config *config.Config) error {
	err := source.From("ini", config)
	fmt.Println(config.String())
	return err
}

// GetTemplate prints template for the given extension point.
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
func CompileRule(config *config.Config, path string) error {
	if path == "" {
		fmt.Println("invalid rule path")
	} else {
		fName := filepath.Base(path)

		// Create our check manager:
		mgr, err := check.NewManager(config)
		if err != nil {
			return err
		}

		err = mgr.AddRuleFromFile(fName, path)
		if err != nil {
			return err
		}

		for _, v := range mgr.Rules() {
			fmt.Print(v.Pattern())
		}
	}
	return nil
}

// TestRule returns the linting results for a single rule
func TestRule(args []string) error {
	if len(args) == 2 && core.FileExists(args[0]) && core.FileExists(args[1]) {
		// Create a pre-filled configuration:
		cfg, err := config.New()
		if err != nil {
			return err
		}

		cfg.MinAlertLevel = 0
		cfg.GBaseStyles = []string{"Test"}
		cfg.InExt = ".txt" // default value

		// Create our check manager:
		mgr, err := check.NewManager(cfg)
		if err != nil {
			return err
		}

		err = mgr.AddRuleFromFile("Test.Rule", args[0])
		if err != nil {
			return err
		}
		linter := lint.Linter{Manager: mgr}

		linted, err := linter.Lint([]string{args[1]}, "*")
		if err != nil {
			return err
		}

		_ = ui.PrintJSONAlerts(linted)
		return err
	} else if len(args) != 2 {
		return errors.New("missing argument")
	}
	return errors.New("invalid arguments")
}
