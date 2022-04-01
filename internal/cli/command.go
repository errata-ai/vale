package cli

import (
	"errors"
	"fmt"
	"io/ioutil"
	"path/filepath"

	"github.com/errata-ai/vale/v2/internal/check"
	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/lint"
	"github.com/errata-ai/vale/v2/internal/nlp"
	"github.com/jdkato/prose/tag"
	"github.com/pterm/pterm"
)

// TaggedWord is a word with an NLP context.
type TaggedWord struct {
	Token tag.Token
	Line  int
	Span  []int
}

// CompiledRule is a rule's compiled regex.
type CompiledRule struct {
	Pattern string
}

var commandInfo = map[string]string{
	"ls-config":  "Print the current configuration to stdout and exit.",
	"ls-metrics": "Print the given file's internal metrics.",
	"sync":       "Update external configuration sources.",
}

// Actions are the available CLI commands.
var Actions = map[string]func(args []string, cfg *core.Config) error{
	"ls-config":  printConfig,
	"ls-metrics": printMetrics,
	"dc":         printConfig,
	"tag":        runTag,
	"compile":    compileRule,
	"run":        runRule,
	"sync":       sync,
}

func sync(args []string, cfg *core.Config) error {
	pkgs, err := core.GetPackages(cfg.Flags.Path)
	if err != nil {
		return err
	}

	p, err := pterm.DefaultProgressbar.WithTotal(
		len(pkgs)).WithTitle("Downloading packages").Start()

	if err != nil {
		return err
	}

	for idx, pkg := range pkgs {
		if err = readPkg(pkg, cfg.StylesPath, idx); err != nil {
			return err
		}
		name := fileNameWithoutExt(pkg)

		pterm.Success.Println("Downloaded package '" + name + "'")
		p.Increment()
	}

	return nil
}

func printConfig(args []string, cfg *core.Config) error {
	fmt.Println(cfg.String())
	return nil
}

func printMetrics(args []string, cfg *core.Config) error {
	if len(args) != 1 {
		return core.NewE100("ls-metrics", errors.New("one argument expected"))
	} else if !core.FileExists(args[0]) {
		return errors.New("file not found")
	}

	linter, err := lint.NewLinter(cfg)
	if err != nil {
		return err
	}

	linted, err := linter.Lint(args, "*")
	if err != nil {
		return err
	}

	computed, _ := linted[0].ComputeMetrics()
	return printJSON(computed)
}

func runTag(args []string, cfg *core.Config) error {
	if len(args) != 3 {
		return core.NewE100("tag", errors.New("three arguments expected"))
	}

	text, err := ioutil.ReadFile(args[0])
	if err != nil {
		return err
	}

	out := core.TextToContext(
		string(text), &nlp.NLPInfo{Lang: args[1], Endpoint: args[2]})

	return printJSON(out)
}

func compileRule(args []string, cfg *core.Config) error {
	if len(args) != 1 {
		return core.NewE100("compile", errors.New("one argument expected"))
	}

	path := args[0]
	name := filepath.Base(path)

	mgr, err := check.NewManager(cfg)
	if err != nil {
		return err
	}

	err = mgr.AddRuleFromFile(name, path)
	if err != nil {
		return err
	}

	rule := CompiledRule{Pattern: mgr.Rules()[name].Pattern()}
	return printJSON(rule)
}

func runRule(args []string, cfg *core.Config) error {
	if len(args) != 2 {
		return core.NewE100("run", errors.New("two arguments expected"))
	}

	cfg.MinAlertLevel = 0
	cfg.GBaseStyles = []string{"Test"}
	cfg.Flags.InExt = ".txt" // default value

	linter, err := lint.NewLinter(cfg)
	if err != nil {
		return err
	}

	err = linter.Manager.AddRuleFromFile("Test.Rule", args[0])
	if err != nil {
		return err
	}

	linted, err := linter.Lint([]string{args[1]}, "*")
	if err != nil {
		return err
	}

	PrintJSONAlerts(linted)
	return nil
}
