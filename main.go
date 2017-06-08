package main

import (
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"

	"github.com/ValeLint/vale/check"
	"github.com/ValeLint/vale/core"
	"github.com/ValeLint/vale/lint"
	"github.com/ValeLint/vale/ui"
	"github.com/urfave/cli"
)

// version is set during the release build process.
var version = "master"

func main() {
	var glob string

	config := core.LoadConfig()
	app := cli.NewApp()
	app.Name = "vale"
	app.Usage = "A command-line linter for prose."
	app.Version = version
	app.Flags = []cli.Flag{
		cli.StringFlag{
			Name:        "glob",
			Value:       "*",
			Usage:       `a glob pattern (e.g., --glob='*.{md,txt}')`,
			Destination: &glob,
		},
		cli.StringFlag{
			Name:        "output",
			Value:       "CLI",
			Usage:       `output style ("line", "JSON", or "context")`,
			Destination: &config.Output,
		},
		cli.StringFlag{
			Name:        "ext",
			Value:       ".txt",
			Usage:       `extension to associate with stdin`,
			Destination: &config.InExt,
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
			Name:        "ignore-syntax",
			Usage:       "lint all files line-by-line",
			Destination: &config.Simple,
		},
	}
	app.Commands = []cli.Command{
		{
			Name:    "dump-config",
			Aliases: []string{"dc"},
			Usage:   "Dumps configuration options to stdout and exits",
			Action: func(c *cli.Context) error {
				fmt.Println(core.DumpConfig(config))
				return nil
			},
		},
		{
			Name:  "new",
			Usage: "Generates a template for the given extension point",
			Action: func(c *cli.Context) error {
				name := c.Args().First()
				template := check.GetTemplate(name)
				if template != "" {
					fmt.Println(template)
				} else {
					fmt.Printf(
						"'%s' not in %v!\n", name, check.GetExtenionPoints())
				}
				return nil
			},
		},
	}

	app.Action = func(c *cli.Context) error {
		var linted []*core.File
		var err error
		var hasAlerts bool
		var src string

		if c.NArg() > 0 || core.Stat() {
			mgr := check.NewManager(config)
			if c.NArg() > 0 {
				src = c.Args()[0]
			} else {
				stdin, _ := ioutil.ReadAll(os.Stdin)
				src = string(stdin)
			}

			linter := lint.Linter{Config: config, CheckManager: mgr}
			// Do we a directory/file or a string?
			if core.IsDir(src) || core.FileExists(src) {
				linted, err = linter.Lint(src, glob)
			} else {
				linted, err = linter.LintString(src)
			}

			// How should we style the output?
			if config.Output == "line" {
				hasAlerts = ui.PrintLineAlerts(linted)
			} else if config.Output == "JSON" {
				hasAlerts = ui.PrintJSONAlerts(linted)
			} else if config.Output == "context" {
				hasAlerts = ui.PrintVerboseAlerts(
					linted, ui.CONTEXT, config.Wrap)
			} else {
				hasAlerts = ui.PrintVerboseAlerts(
					linted, ui.VERBOSE, config.Wrap)
			}

			// Should return a nonzero vale on errors?
			if err == nil && hasAlerts && !config.NoExit {
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
