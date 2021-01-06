package main

import (
	"flag"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/mholt/archiver/v3"
)

var flags core.CLIFlags
var zip archiver.Unarchiver

func init() {
	flag.StringVar(&flags.Sources, "sources", "", "config files to load")
	flag.StringVar(&flags.Glob, "glob", "*",
		`A glob pattern (e.g., --glob='*.{md,txt}).'`)
	flag.StringVar(&flags.Path, "config", "",
		`A file path (e.g., --config='some/file/path/.vale.ini').`)
	flag.StringVar(&flags.AlertLevel, "minAlertLevel", "",
		`Lowest alert level to display (e.g., --minAlertLevel=error).`)
	flag.StringVar(&flags.Output, "output", "CLI",
		`Output style ("line", "JSON", or a template file).`)
	flag.StringVar(&flags.InExt, "ext", ".txt",
		`Extension to associate with stdin (e.g., --ext=.md).`)

	flag.BoolVar(&flags.Wrap, "no-wrap", false, "Don't wrap CLI output.")
	flag.BoolVar(&flags.NoExit, "no-exit", false,
		"Don't return a nonzero exit code on errors.")
	flag.BoolVar(&flags.Sorted, "sort", false,
		"sort files by their name in output")
	flag.BoolVar(&flags.Normalize, "normalize", false,
		"replace each path separator with a slash ('/')")
	flag.BoolVar(&flags.Simple, "ignore-syntax", false,
		"Lint all files line-by-line.")
	flag.BoolVar(&flags.Relative, "relative", false, "return relative paths")
}
