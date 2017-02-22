package main

import (
	"errors"
	"os"
	"path/filepath"

	"github.com/jdkato/vale/lint"
	"github.com/jdkato/vale/util"
	"github.com/urfave/cli"
)

// Version is set during the release build process.
var Version string

// Commit is set during the release build process.
var Commit string

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
			Destination: &util.CLConfig.Output,
		},
		cli.BoolFlag{
			Name:        "no-wrap",
			Usage:       "don't wrap CLI output",
			Destination: &util.CLConfig.Wrap,
		},
		cli.BoolFlag{
			Name:        "debug",
			Usage:       "print dubugging info to stdout",
			Destination: &util.CLConfig.Debug,
		},
		cli.BoolFlag{
			Name:        "no-exit",
			Usage:       "don't return a nonzero exit code on lint errors",
			Destination: &util.CLConfig.NoExit,
		},
	}

	app.Action = func(c *cli.Context) error {
		var linted []lint.File
		var err error
		var hasAlerts bool

		if c.NArg() > 0 {
			l := new(lint.Linter)
			linted, err = l.Lint(c.Args()[0], glob)
			if util.CLConfig.Output == "line" {
				hasAlerts = printLineAlerts(linted)
			} else if util.CLConfig.Output == "JSON" {
				hasAlerts = printJSONAlerts(linted)
			} else {
				hasAlerts = printVerboseAlerts(linted)
			}
			if err == nil && hasAlerts && !util.CLConfig.NoExit {
				err = errors.New("")
			}
			return err
		}
		cli.ShowAppHelp(c)
		return nil
	}

	util.ExeDir, _ = filepath.Abs(filepath.Dir(os.Args[0]))
	if app.Run(os.Args) != nil {
		os.Exit(1)
	} else {
		os.Exit(0)
	}
}
