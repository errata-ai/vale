package cli

import (
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"

	"github.com/errata-ai/vale/v2/internal/check"
	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/lint"
	"github.com/errata-ai/vale/v2/internal/nlp"
	"github.com/jdkato/prose/tag"
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
}

// Actions are the available CLI commands.
var Actions = map[string]func(args []string, cfg *core.Config) error{
	"ls-config":  printConfig,
	"ls-metrics": printMetrics,
	"dc":         printConfig,
	"tag":        runTag,
	"compile":    compileRule,
	"run":        runRule,
}

func printConfig(args []string, cfg *core.Config) error {
	err := core.From("ini", cfg)
	if err != nil {
		ShowError(err, Flags.Output, os.Stderr)
		return nil
	}
	fmt.Println(cfg.String())
	return err
}

func printMetrics(args []string, cfg *core.Config) error {
	if len(args) != 1 {
		return core.NewE100("ls-metrics", errors.New("one argument expected"))
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
