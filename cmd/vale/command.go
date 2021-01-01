package main

import (
	"fmt"
	"os"

	"github.com/errata-ai/vale/v2/internal/core"
)

var commands = []string{
	"dc",
	"ls-config",
}

func doCommand(name string) error {
	switch name {
	case "ls-config", "dc":
		return printConfig()
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
