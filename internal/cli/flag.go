package cli

import (
	"flag"

	"github.com/errata-ai/vale/v2/internal/core"
)

// Flags are the user-defined CLI flags.
var Flags core.CLIFlags

func init() {
	flag.StringVar(&Flags.Sources, "sources", "", "config files to load")
	flag.StringVar(&Flags.Glob, "glob", "*",
		`A glob pattern (e.g., --glob='*.{md,txt}).'`)
	flag.StringVar(&Flags.Path, "config", "",
		`A file path (e.g., --config='some/file/path/.vale.ini').`)
	flag.StringVar(&Flags.AlertLevel, "minAlertLevel", "",
		`Lowest alert level to display (e.g., --minAlertLevel=error).`)
	flag.StringVar(&Flags.Output, "output", "CLI",
		`Output style ("line", "JSON", or a template file).`)
	flag.StringVar(&Flags.InExt, "ext", ".txt",
		`Extension to associate with stdin (e.g., --ext=.md).`)

	flag.BoolVar(&Flags.Wrap, "no-wrap", false, "Don't wrap CLI output.")
	flag.BoolVar(&Flags.NoExit, "no-exit", false,
		"Don't return a nonzero exit code on errors.")
	flag.BoolVar(&Flags.Local, "mode-compat", false,
		"prioritize local Vale configurations")
	flag.BoolVar(&Flags.Sorted, "sort", false,
		"sort files by their name in output")
	flag.BoolVar(&Flags.Normalize, "normalize", false,
		"replace each path separator with a slash ('/')")
	flag.BoolVar(&Flags.Simple, "ignore-syntax", false,
		"Lint all files line-by-line.")
	flag.BoolVar(&Flags.Relative, "relative", false, "return relative paths")
}
