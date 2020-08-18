package main

import (
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"

	"github.com/errata-ai/vale/action"
	"github.com/errata-ai/vale/core"
	"github.com/errata-ai/vale/lint"
	"github.com/errata-ai/vale/ui"
	"github.com/urfave/cli"
)

// version is set during the release build process.
var version = "master"

func main() {
	var glob string

	config := core.NewConfig()
	app := cli.NewApp()
	app.Name = "vale"
	app.Usage = "A command-line linter for prose."
	app.Version = version
	app.Flags = []cli.Flag{
		cli.StringFlag{
			Name:        "addons",
			Destination: &config.AddOnsPath,
			Hidden:      true,
		},
		cli.StringFlag{
			Name:        "sources",
			Destination: &config.Sources,
			Hidden:      true,
		},
		cli.StringFlag{
			Name:        "token",
			Destination: &config.AuthToken,
			Hidden:      true,
		},
		cli.StringFlag{
			Name:        "glob",
			Value:       "*",
			Usage:       `a glob pattern (e.g., --glob='*.{md,txt}')`,
			Destination: &glob,
		},
		cli.StringFlag{
			Name:        "config",
			Usage:       `a file path (e.g., --config='some/file/path/.vale.ini')`,
			Destination: &config.Path,
		},
		cli.StringFlag{
			Name:        "minAlertLevel",
			Usage:       `The lowest alert level to display`,
			Destination: &config.AlertLevel,
		},
		cli.StringFlag{
			Name:        "output",
			Value:       "CLI",
			Usage:       `output style ("line" or "JSON")`,
			Destination: &config.Output,
		},
		cli.StringFlag{
			Name:        "ext",
			Value:       ".txt",
			Usage:       `extension to associate with stdin`,
			Destination: &config.InExt,
		},
		cli.BoolFlag{
			Name:        "mode-compat",
			Usage:       `Respect local Vale configurations`,
			Destination: &config.Local,
			Hidden:      true,
		},
		cli.BoolFlag{
			Name:        "mode-rev-compat",
			Usage:       `Treat --config as local`,
			Destination: &config.Remote,
			Hidden:      true,
		},
		cli.BoolFlag{
			Name:        "no-wrap",
			Usage:       "don't wrap CLI output",
			Destination: &config.Wrap,
		},
		cli.BoolFlag{
			Name:        "no-exit",
			Usage:       "don't return a nonzero exit code on lint errors",
			Destination: &config.NoExit,
		},
		cli.BoolFlag{
			Name:        "sort",
			Usage:       "sort files by their name in output",
			Destination: &config.Sorted,
		},
		cli.BoolFlag{
			Name:        "debug",
			Usage:       "print debugging information to stdout",
			Destination: &config.Debug,
		},
		cli.BoolFlag{
			Name:        "normalize",
			Usage:       "replace each path separator with a slash ('/')",
			Destination: &config.Normalize,
		},
		cli.BoolFlag{
			Name:        "ignore-syntax",
			Usage:       "lint all files line-by-line",
			Destination: &config.Simple,
		},
		cli.BoolFlag{
			Name:        "relative",
			Usage:       "return relative paths",
			Destination: &config.Relative,
		},
	}

	app.Commands = []cli.Command{
		{
			Name:    "ls-config",
			Aliases: []string{"dc"},
			Usage:   "List the current configuration options",
			Action: func(c *cli.Context) error {
				_ = config.Load()
				return action.ListConfig(config)
			},
		},
		{
			Name:  "new-rule",
			Usage: "Generates a template for the given extension point",
			Action: func(c *cli.Context) error {
				return action.GetTemplate(c.Args().First())
			},
		},
		{
			Name:  "compile",
			Usage: "Return a compiled regex for a given rule",
			Action: func(c *cli.Context) error {
				_ = config.Load()
				return action.CompileRule(config, c.Args().First())
			},
			Hidden: true,
		},
		{
			Name:  "test",
			Usage: "Return linting results for a single rule",
			Action: func(c *cli.Context) error {
				return action.TestRule(c.Args())
			},
			Hidden: true,
		},
		{
			Name:  "tag",
			Usage: "Assign part-of-speech tags to the given sentence",
			Action: func(c *cli.Context) error {
				_ = config.Load()
				return action.TagSentence(config, c.Args().First())
			},
		},
	}

	app.Action = func(c *cli.Context) error {
		var linted []*core.File
		var err error
		var hasAlerts bool

		err = config.Load()
		if err != nil && config.Output == "CLI" {
			fmt.Printf(".vale.ini: '%s'\n", err)
			return nil
		} else if c.NArg() > 0 || core.Stat() {
			linter := lint.NewLinter(config)
			if c.NArg() > 0 {
				if core.LooksLikeStdin(c.Args()[0]) {
					linted, err = linter.LintString(c.Args()[0])
				} else {
					linted, err = linter.Lint(c.Args(), glob)
				}
			} else {
				stdin, _ := ioutil.ReadAll(os.Stdin)
				linted, err = linter.LintString(string(stdin))
			}

			// How should we style the output?
			if config.Output == "line" {
				hasAlerts = ui.PrintLineAlerts(linted, config.Relative)
			} else if config.Output == "JSON" {
				hasAlerts = ui.PrintJSONAlerts(linted)
			} else {
				hasAlerts = ui.PrintVerboseAlerts(linted, config.Wrap)
			}

			// Should return a nonzero vale on errors?
			if err == nil && hasAlerts && !config.NoExit {
				err = errors.New("")
			}
			return err
		} else {
			cli.ShowAppHelp(c)
			return nil
		}
	}

	core.ExeDir, _ = filepath.Abs(filepath.Dir(os.Args[0]))
	if app.Run(os.Args) != nil {
		os.Exit(1)
	} else {
		os.Exit(0)
	}
}
