package main

import (
	"fmt"
	"os"

	"github.com/logrusorgru/aurora/v3"
)

var exampleConfig = `StylesPath = a/path/to/your/styles
	MinAlertLevel = suggestion

	[*]
	BasedOnStyles = Vale`

var info = fmt.Sprintf(`vale - A command-line linter for prose [%s]

Usage:	%s
	%s
	%s

Vale is a syntax-aware linter for prose built with speed and extensibility in
mind. It supports Markdown, AsciiDoc, reStructuredText, HTML, and more.

It's designed to enforce custom rulesets (referred to as "styles"). See
%s for examples of what's possible.

To get started, you'll need a configuration file (%s):

Example:

	%s

See %s for more setup information or %s for a listing of CLI options.`,
	aurora.Faint(version),

	// Examples
	aurora.Faint("vale [options] [input...]"),
	aurora.Faint("vale myfile.md myfile1.md mydir1"),
	aurora.Faint("vale --output=JSON [input...]"),

	aurora.Underline("https://github.com/errata-ai/styles"),

	aurora.Faint(".vale.ini"),
	aurora.Faint(exampleConfig),

	aurora.Underline("https://docs.errata.ai/vale/about"),
	aurora.Faint("vale --help"))

func printIntro() {
	fmt.Println(info)
	os.Exit(0)
}
