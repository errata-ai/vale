package cli

import (
	"errors"
	"flag"
	"fmt"
	"os"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/lint"
)

var commandInfo = map[string]string{
	"ls-config":  "Print the current configuration to stdout and exit.",
	"ls-metrics": "Print the given file's internal metrics.",
}

// Actions are the available CLI commands.
var Actions = map[string]func(args []string, cfg *core.Config) error{
	"ls-config":  printConfig,
	"ls-metrics": printMetrics,
	"dc":         printConfig,
	"help":       printUsage,
}

func printConfig(args []string, cfg *core.Config) error {
	cfg, err := core.NewConfig(&Flags)
	if err != nil {
		ShowError(err, Flags.Output, os.Stderr)
		return nil
	}

	err = core.From("ini", cfg)
	if err != nil {
		ShowError(err, Flags.Output, os.Stderr)
		return nil
	}

	fmt.Println(cfg.String())
	return err
}

func printUsage(args []string, cfg *core.Config) error {
	flag.Usage()
	return nil
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

	return printJSON(linted[0].ComputeMetrics())
}
