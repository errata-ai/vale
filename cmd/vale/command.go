package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/errata-ai/vale/v2/internal/core"
)

var commands = []string{
	"dc",
	"ls-config",
	"help",
}

var commandInfo = map[string]string{
	"ls-config": "Print the current configuration to stdout and exit.",
}

func doCommand(name string) error {
	switch name {
	case "ls-config", "dc":
		return printConfig()
	case "help":
		flag.Usage()
		return nil
	}
	return nil
}

func printConfig() error {
	cfg, err := core.NewConfig(&flags)
	if err != nil {
		ShowError(err, flags.Output, os.Stderr)
	}

	err = core.From("ini", cfg)
	if err != nil {
		ShowError(err, flags.Output, os.Stderr)
	}

	fmt.Println(cfg.String())
	return err
}
