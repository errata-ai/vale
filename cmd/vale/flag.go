package main

import (
	"flag"

	"github.com/errata-ai/vale/v2/internal/core"
)

var flags core.CLIFlags

func init() {
	flag.StringVar(&flags.Sources, "sources", "", "config files to load")
	flag.StringVar(&flags.Glob, "glob", "*",
		`a glob pattern (e.g., --glob='*.{md,txt}'`)
	flag.StringVar(&flags.Path, "config", "",
		`a file path (e.g., --config='some/file/path/.vale.ini')`)
	flag.StringVar(&flags.AlertLevel, "minAlertLevel", "",
		`The lowest alert level to display`)
	flag.StringVar(&flags.Output, "output", "CLI",
		`output style ("line", "JSON", or a template file)`)
	flag.StringVar(&flags.InExt, "ext", ".txt",
		`extension to associate with stdin`)

	flag.BoolVar(&flags.Wrap, "no-wrap", false, "don't wrap CLI output")
	flag.BoolVar(&flags.NoExit, "no-exit", false,
		"don't return a nonzero exit code on lint errors")
	flag.BoolVar(&flags.Local, "mode-compat", false,
		"prioritize local Vale configurations")
	flag.BoolVar(&flags.Sorted, "sort", false,
		"sort files by their name in output")
	flag.BoolVar(&flags.Normalize, "normalize", false,
		"replace each path separator with a slash ('/')")
	flag.BoolVar(&flags.Simple, "ignore-syntax", false,
		"lint all files line-by-line")
	flag.BoolVar(&flags.Relative, "relative", false, "return relative paths")
}
