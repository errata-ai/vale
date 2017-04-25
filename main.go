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
			Usage:       `output style ("line" or "JSON")`,
			Destination: &core.CLConfig.Output,
		},
		cli.StringFlag{
			Name:        "ext",
			Value:       ".txt",
			Usage:       `extension to associate with stdin`,
			Destination: &core.CLConfig.InExt,
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
		cli.BoolFlag{
			Name:        "ignore-syntax",
			Usage:       "lint all files line-by-line",
			Destination: &core.CLConfig.Simple,
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
		{
			Name:  "new",
			Usage: "Generates a template for the given extension point",
			Action: func(c *cli.Context) error {
				name := c.Args().First()
				template := check.GetTemplate(name)
				if template != "" {
					fmt.Println(template)
				} else {
					fmt.Println(fmt.Sprintf("'%s' is not a check!", name))
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
			check.Load() // we have input, so let's load our configuration.
			if c.NArg() > 0 {
				src = c.Args()[0]
			} else {
				stdin, _ := ioutil.ReadAll(os.Stdin)
				src = string(stdin)
			}

			l := new(lint.Linter)
			// Do we a directory/file or a string?
			if core.IsDir(src) || core.FileExists(src) {
				linted, err = l.Lint(src, glob)
			} else {
				linted, err = l.LintString(src)
			}

			// How should we style the output?
			if core.CLConfig.Output == "line" {
				hasAlerts = ui.PrintLineAlerts(linted)
			} else if core.CLConfig.Output == "JSON" {
				hasAlerts = ui.PrintJSONAlerts(linted)
			} else {
				hasAlerts = ui.PrintVerboseAlerts(linted)
			}

			// Should return a nonzero vale on errors?
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
