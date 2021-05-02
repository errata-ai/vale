package cli

import (
	"flag"
	"fmt"
	"os"

	"github.com/errata-ai/vale/v2/internal/core"
)

var commandInfo = map[string]string{
	"ls-config": "Print the current configuration to stdout and exit.",
}

// Actions are the available CLI commands.
var Actions = map[string]func(args []string, cfg *core.Config) error{
	"ls-config": printConfig,
	"dc":        printConfig,
	"help":      printUsage,
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
