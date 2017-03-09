package main

import (
	"errors"
	"fmt"
	"os"
	"path/filepath"

	"github.com/ValeLint/vale/core"
	"github.com/ValeLint/vale/lint"
	"github.com/ValeLint/vale/ui"
	"github.com/urfave/cli"
)

// Version is set during the release build process.
var Version string

func main() {
	var glob string
	app := cli.NewApp()
	app.Name = "vale"
	app.Usage = "A command-line linter for prose."
	app.Version = Version
	app.Flags = []cli.Flag{
		cli.StringFlag{
			Name:        "glob",
			Value:       "*",
			Usage:       `a glob pattern (e.g., --glob="*.{md,txt}")`,
			Destination: &glob,
		},
		cli.StringFlag{
			Name:        "output",
			Value:       "CLI",
			Usage:       `output style ("line" or "JSON")`,
			Destination: &core.CLConfig.Output,
		},
		cli.BoolFlag{
			Name:        "no-wrap",
			Usage:       "don't wrap CLI output",
			Destination: &core.CLConfig.Wrap,
		},
		cli.BoolFlag{
			Name:        "no-exit",
			Usage:       "don't return a nonzero exit code on lint errors",
			Destination: &core.CLConfig.NoExit,
		},
		cli.BoolFlag{
			Name:        "sort",
			Usage:       "sort files by their name in output",
			Destination: &core.CLConfig.Sorted,
		},
	}
	app.Commands = []cli.Command{
		{
			Name:    "dump-config",
			Aliases: []string{"dc"},
			Usage:   "Dumps configuration options to stdout and exits",
			Action: func(c *cli.Context) error {
				fmt.Println(core.DumpConfig())
				return nil
			},
		},
	}

	app.Action = func(c *cli.Context) error {
		var linted []core.File
		var g core.Glob
		var err error
		var hasAlerts bool

		if c.NArg() > 0 {
			l := new(lint.Linter)
			linted, err = l.Lint(c.Args()[0], glob)
			if core.CLConfig.Output == "line" {
				hasAlerts = ui.PrintLineAlerts(linted)
			} else if core.CLConfig.Output == "JSON" {
				hasAlerts = ui.PrintJSONAlerts(linted)
			} else {
				hasAlerts = ui.PrintVerboseAlerts(linted)
			}
			if err == nil && hasAlerts && !core.CLConfig.NoExit {
				err = errors.New("")
			}
			return err
		}
		cli.ShowAppHelp(c)
		return nil
	}

	core.ExeDir, _ = filepath.Abs(filepath.Dir(os.Args[0]))
	if app.Run(os.Args) != nil {
		os.Exit(1)
	} else {
		os.Exit(0)
	}
}
