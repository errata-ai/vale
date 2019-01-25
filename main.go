package main

import (
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"

	"github.com/errata-ai/vale/check"
	"github.com/errata-ai/vale/core"
	"github.com/errata-ai/vale/lint"
	"github.com/errata-ai/vale/ui"
	"github.com/urfave/cli"
)

// version is set during the release build process.
var version = "master"

func main() {
	var glob string
	var path string

	config := core.NewConfig()
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
			Name:        "config",
			Usage:       `a file path (e.g., --config='some/file/path')`,
			Destination: &path,
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
			Aliases: []string{"dc", "dump-config", "ls"},
			Usage:   "Prints configuration options to stdout and exits",
			Action: func(c *cli.Context) error {
				config, _ = core.LoadConfig(config, path)
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

		config, err = core.LoadConfig(config, path)
		if err != nil && config.Output == "CLI" {
			fmt.Println("WARNING: Missing or invalid config file.\n\n" +
				"See https://github.com/errata-ai/vale#usage for " +
				"information about creating a config file.")
			return nil
		} else if c.NArg() > 0 || core.Stat() {
			linter := lint.Linter{
				Config: config, CheckManager: check.NewManager(config)}

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
