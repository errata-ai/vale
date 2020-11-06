package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"

	"github.com/errata-ai/vale/v2/config"
	"github.com/errata-ai/vale/v2/core"
	"github.com/errata-ai/vale/v2/lint"
	"github.com/errata-ai/vale/v2/source"
	"github.com/errata-ai/vale/v2/ui"
	"github.com/urfave/cli"
)

// version is set during the release build process.
var version = "master"

func validateFlags(config *config.Config) error {
	if config.Path != "" && !core.FileExists(config.Path) {
		return core.NewE100(
			"--config",
			fmt.Errorf("path '%s' does not exist", config.Path))
	}
	return nil
}

func stat() bool {
	stat, err := os.Stdin.Stat()
	if err != nil || (stat.Mode()&os.ModeCharDevice) != 0 {
		return false
	}
	return true
}

func looksLikeStdin(s string) bool {
	return !(core.FileExists(s) || core.IsDir(s)) && s != ""
}

func main() {
	var glob string
	var hasErrors bool

	config, err := config.New()
	if err != nil {
		ui.ShowError(err, config.Output, os.Stderr)
	}

	app := cli.NewApp()
	app.Name = "vale"
	app.Usage = "A command-line linter for prose."
	app.Version = version
	app.Flags = []cli.Flag{
		cli.StringFlag{
			Name:        "sources",
			Destination: &config.Sources,
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
				err := source.From("ini", config)
				fmt.Println(config.String())
				return err
			},
		},
	}

	app.Action = func(c *cli.Context) error {
		var linted []*core.File
		var err error

		if err = validateFlags(config); err != nil {
			return err
		} else if err = source.From("ini", config); err != nil {
			return err
		}

		linter, err := lint.NewLinter(config)
		if err != nil {
			return err
		}

		if c.NArg() > 0 || stat() {
			if c.NArg() > 0 {
				if looksLikeStdin(c.Args()[0]) {
					linted, err = linter.LintString(c.Args()[0])
				} else {
					linted, err = linter.Lint(c.Args(), glob)
				}
			} else {
				stdin, _ := ioutil.ReadAll(os.Stdin)
				linted, err = linter.LintString(string(stdin))
			}
		} else {
			return cli.ShowAppHelp(c)
		}

		if err != nil {
			return err
		}

		hasErrors, err = ui.PrintAlerts(linted, config)
		return err
	}

	// TODO: Remove this.
	//
	// See ui/line.go.
	core.ExeDir, _ = filepath.Abs(filepath.Dir(os.Args[0]))

	if err = app.Run(os.Args); err != nil {
		ui.ShowError(err, config.Output, os.Stderr)
		os.Exit(2)
	} else if hasErrors && !config.NoExit {
		os.Exit(1)
	}

	os.Exit(0)
}
