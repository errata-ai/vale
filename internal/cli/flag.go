package cli

import (
	"fmt"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/pterm/pterm"
	"github.com/spf13/pflag"
)

// Flags are the user-defined CLI flags.
var Flags core.CLIFlags

var shortcodes = map[string]string{
	"sources":       "s",
	"glob":          "g",
	"config":        "c",
	"minAlertLevel": "m",
	"output":        "o",
	"ext":           "e",
	"no-wrap":       "w",
	"no-exit":       "x",
	"ignore-syntax": "n",
	"version":       "v",
	"help":          "h",
}

func init() {
	pflag.StringVarP(&Flags.Sources, "sources", "s", "", "A config files to load")

	pflag.StringVarP(&Flags.Glob, "glob", "g", "*",
		fmt.Sprintf(`A glob pattern (e.g., %s)`, pterm.Gray(`--glob='*.{md,txt}.'`)))

	pflag.StringVarP(&Flags.Path, "config", "c", "",
		fmt.Sprintf(`A file path (e.g., %s).`, pterm.Gray(`--config='some/file/path/.vale.ini'`)))

	pflag.StringVarP(&Flags.AlertLevel, "minAlertLevel", "m", "",
		fmt.Sprintf(`The lowest alert level to display (e.g., %s).`, pterm.Gray(`--minAlertLevel=error`)))

	pflag.StringVarP(&Flags.Output, "output", "o", "CLI", `An output style ("line", "JSON", or a template file).`)

	pflag.StringVarP(&Flags.InExt, "ext", "e", ".txt",
		fmt.Sprintf(`An extension to associate with stdin (e.g., %s).`, pterm.Gray(`--ext=.md`)))

	pflag.BoolVarP(&Flags.Wrap, "no-wrap", "w", false, "Don't wrap CLI output.")
	pflag.BoolVarP(&Flags.NoExit, "no-exit", "x", false, "Don't return a nonzero exit code on errors.")
	pflag.BoolVarP(&Flags.Simple, "ignore-syntax", "n", false, "Lint all files line-by-line.")
	pflag.BoolVarP(&Flags.Version, "version", "v", false, "Print the current version.")
	pflag.BoolVarP(&Flags.Help, "help", "h", false, "Print this help message.")

	pflag.BoolVar(&Flags.Local, "mode-compat", false, "prioritize local Vale configurations")
	pflag.BoolVar(&Flags.Sorted, "sort", false, "sort files by their name in output")
	pflag.BoolVar(&Flags.Normalize, "normalize", false, "replace each path separator with a slash ('/')")
	pflag.BoolVar(&Flags.Relative, "relative", false, "return relative paths")
}
