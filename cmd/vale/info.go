package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/olekukonko/tablewriter"
	"github.com/pterm/pterm"
	"github.com/spf13/pflag"

	"github.com/errata-ai/vale/v3/internal/core"
)

var exampleConfig = `MinAlertLevel = suggestion

	[*]
	BasedOnStyles = Vale`

var intro = fmt.Sprintf(`vale - A command-line linter for prose.

%s:	%s
	%s
	%s

Vale is a syntax-aware linter for prose built with speed and extensibility in
mind. It supports Markdown, AsciiDoc, reStructuredText, HTML, and more.

To get started, you'll need a configuration file (%s):

%s:

	%s

See %s for more setup information.`,
	pterm.Bold.Sprintf("Usage"),

	toCodeStyle("vale [options] [input...]"),
	toCodeStyle("vale myfile.md myfile1.md mydir1"),
	toCodeStyle("vale --output=JSON [input...]"),

	toCodeStyle(".vale.ini"),
	pterm.Bold.Sprintf("Example"),
	toCodeStyle(exampleConfig),

	pterm.Underscore.Sprintf("https://vale.sh"))

var info = fmt.Sprintf(`%s

(Or use %s for a listing of all CLI options.)`,
	intro,
	toCodeStyle("vale --help"))

var hidden = []string{
	"mode-compat",
	"mode-rev-compat",
	"normalize",
	"relative",
	"sort",
	"sources",
	"built",
	"minAlertLevel",

	// API stuff
	"tag",
	"compile",
	"run",
	"fix",
	"verify",
	"transform",
	"ls-path",
	"host-install",
	"host-uninstall",
}

// PrintIntro shows basic usage / getting started info.
func PrintIntro() {
	fmt.Println(info)
	os.Exit(0)
}

func toFlag(name string) string {
	if code, ok := shortcodes[name]; ok {
		return fmt.Sprintf("%s, %s", toCodeStyle("-"+code), toCodeStyle("--"+name))
	}
	return toCodeStyle("--" + name)
}

func init() {
	pflag.Usage = func() {
		fmt.Println(intro)

		table := tablewriter.NewWriter(os.Stdout)
		table.SetCenterSeparator("")
		table.SetColumnSeparator("")
		table.SetRowSeparator("")
		table.SetAutoWrapText(false)

		fmt.Println(pterm.Bold.Sprintf("\nFlags:"))
		pflag.VisitAll(func(f *pflag.Flag) {
			if !core.StringInSlice(f.Name, hidden) {
				table.Append([]string{toFlag(f.Name), f.Usage})
			}
		})

		table.Render()
		table.ClearRows()

		fmt.Println(pterm.Bold.Sprintf("Commands:"))
		for _, info := range commandInfo {
			cmd, use, _ := strings.Cut(info, " ")
			use = strings.Trim(use, " ")
			if !core.StringInSlice(cmd, hidden) {
				table.Append([]string{toCodeStyle(cmd), use})
			}
		}
		table.Render()

		os.Exit(0)
	}
}
