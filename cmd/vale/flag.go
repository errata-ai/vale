package main

import (
	"fmt"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/pterm/pterm"
	"github.com/spf13/pflag"
)

// Flags are the user-defined CLI flags.
var Flags core.CLIFlags

var shortcodes = map[string]string{
	"version": "v",
	"help":    "h",
}

func init() {
	pflag.StringVar(&Flags.Sources, "sources", "", "A config files to load")
	pflag.StringVar(&Flags.Filter, "filter", "", "An expression to filter rules by.")

	pflag.StringVar(&Flags.Glob, "glob", "*",
		fmt.Sprintf(`A glob pattern (%s)`, pterm.Gray(`--glob='*.{md,txt}.'`)))

	pflag.StringVar(&Flags.Path, "config", "",
		fmt.Sprintf(`A file path (%s).`, pterm.Gray(`--config='some/file/path/.vale.ini'`)))

	pflag.StringVar(&Flags.AlertLevel, "minAlertLevel", "",
		fmt.Sprintf(`The minimum level to display (%s).`, pterm.Gray(`--minAlertLevel=error`)))

	pflag.StringVar(&Flags.Output, "output", "CLI", `An output style ("line", "JSON", or a template file).`)

	pflag.StringVar(&Flags.InExt, "ext", ".txt",
		fmt.Sprintf(`An extension to associate with stdin (%s).`, pterm.Gray(`--ext=.md`)))

	pflag.BoolVar(&Flags.Wrap, "no-wrap", false, "Don't wrap CLI output.")
	pflag.BoolVar(&Flags.NoExit, "no-exit", false, "Don't return a nonzero exit code on errors.")
	pflag.BoolVar(&Flags.Simple, "ignore-syntax", false, "Lint all files line-by-line.")
	pflag.BoolVarP(&Flags.Version, "version", "v", false, "Print the current version.")
	pflag.BoolVarP(&Flags.Help, "help", "h", false, "Print this help message.")

	pflag.BoolVar(&Flags.Local, "mode-compat", false, "prioritize local Vale configurations")
	pflag.BoolVar(&Flags.Sorted, "sort", false, "sort files by their name in output")
	pflag.BoolVar(&Flags.Normalize, "normalize", false, "replace each path separator with a slash ('/')")
	pflag.BoolVar(&Flags.Relative, "relative", false, "return relative paths")
}
