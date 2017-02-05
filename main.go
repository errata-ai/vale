package main

import (
	"os"
	"path/filepath"

	"github.com/jdkato/txtlint/lint"
	"github.com/jdkato/txtlint/ui"
	"github.com/jdkato/txtlint/util"
	"github.com/urfave/cli"
)

// Version is set during the release build process.
var Version string

// Commit is set during the release build process.
var Commit string

func main() {
	app := cli.NewApp()
	app.Name = "txtlint"
	app.Usage = "A command-line linter for prose."
	app.Version = Version
	app.Flags = []cli.Flag{
		cli.StringFlag{
			Name:        "glob",
			Value:       "*",
			Usage:       `a glob pattern (e.g., --glob="*.{md,txt}")`,
			Destination: &util.CLConfig.Glob,
		},
		cli.StringFlag{
			Name:        "output",
			Value:       "line",
			Usage:       `output style ("line" or "CLI")`,
			Destination: &util.CLConfig.Output,
		},
		cli.BoolFlag{
			Name:        "wrap",
			Usage:       "wrap CLI output",
			Destination: &util.CLConfig.Wrap,
		},
	}

	app.Action = func(c *cli.Context) error {
		var linted []lint.File
		var err error

		if c.NArg() > 0 {
			l := new(lint.Linter)
			linted, err = l.Lint(c.Args()[0])
			if util.CLConfig.Output == "line" {
				ui.PrintLineAlerts(linted)
			} else {
				ui.PrintVerboseAlerts(linted)
			}
		} else {
			cli.ShowAppHelp(c)
		}

		return err
	}

	util.ExeDir, _ = filepath.Abs(filepath.Dir(os.Args[0]))
	if app.Run(os.Args) != nil {
		os.Exit(1)
	} else {
		os.Exit(0)
	}
}
