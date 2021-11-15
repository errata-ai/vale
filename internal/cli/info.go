package cli

import (
	"flag"
	"fmt"
	"os"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/olekukonko/tablewriter"
	"github.com/pterm/pterm"
)

var exampleConfig = `StylesPath = a/path/to/your/styles
	MinAlertLevel = suggestion

	[*]
	BasedOnStyles = Vale`

var intro = fmt.Sprintf(`vale - A command-line linter for prose.

%s:	%s
	%s
	%s

Vale is a syntax-aware linter for prose built with speed and extensibility in
mind. It supports Markdown, AsciiDoc, reStructuredText, HTML, and more.

It's designed to enforce custom rulesets (referred to as "styles"). See
%s for examples of what's possible.

To get started, you'll need a configuration file (%s):

%s:

	%s

See %s for more setup information.`,
	pterm.Bold.Sprintf("Usage"),

	pterm.Gray("vale [options] [input...]"),
	pterm.Gray("vale myfile.md myfile1.md mydir1"),
	pterm.Gray("vale --output=JSON [input...]"),

	pterm.Underscore.Sprintf("https://github.com/errata-ai/styles"),

	pterm.Gray(".vale.ini"),
	pterm.Bold.Sprintf("Example"),
	pterm.Gray(exampleConfig),

	pterm.Underscore.Sprintf("https://docs.errata.ai/vale/about"))

var info = fmt.Sprintf(`%s

(Or use %s for a listing of all CLI options.)`,
	intro,
	pterm.Gray("vale --help"))

var hidden = []string{
	"mode-compat",
	"mode-rev-compat",
	"normalize",
	"relative",
	"sort",
	"sources",
}

// PrintIntro shows basic usage / gettting started info.
func PrintIntro() {
	fmt.Println(info)
	os.Exit(0)
}

func init() {
	flag.Usage = func() {
		fmt.Println(intro)

		table := tablewriter.NewWriter(os.Stdout)
		table.SetCenterSeparator("")
		table.SetColumnSeparator("")
		table.SetRowSeparator("")
		table.SetAutoWrapText(false)

		fmt.Println(pterm.Bold.Sprintf("\nFlags:"))
		flag.VisitAll(func(f *flag.Flag) {
			if !core.StringInSlice(f.Name, hidden) {
				table.Append([]string{"--" + f.Name, f.Usage})
			}
		})

		table.Render()
		table.ClearRows()

		fmt.Println(pterm.Bold.Sprintf("Commands:"))
		for cmd, use := range commandInfo {
			table.Append([]string{cmd, use})
		}
		table.Render()

		os.Exit(0)
	}
}
