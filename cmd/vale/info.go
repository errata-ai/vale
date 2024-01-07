package main

import (
	"fmt"
	"os"
	"path"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/olekukonko/tablewriter"
	"github.com/pterm/pterm"
	"github.com/spf13/pflag"
)

func globalConfig() string {
	configDir, _ := os.UserConfigDir()
	return pterm.Gray(path.Join(configDir, "vale", ".vale.ini"))
}

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

Global config expected in %s.

See %s for more setup information.`,
	pterm.Bold.Sprintf("Usage"),

	pterm.Gray("vale [options] [input...]"),
	pterm.Gray("vale myfile.md myfile1.md mydir1"),
	pterm.Gray("vale --output=JSON [input...]"),

	pterm.Gray(".vale.ini"),
	pterm.Bold.Sprintf("Example"),
	pterm.Gray(exampleConfig),

	globalConfig(),

	pterm.Underscore.Sprintf("https://vale.sh"))

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
	"built",
	"minAlertLevel",

	// API stuff
	"tag",
	"compile",
	"run",
	"fix",
	"verify",
}

// PrintIntro shows basic usage / getting started info.
func PrintIntro() {
	fmt.Println(info)
	os.Exit(0)
}

func toFlag(name string) string {
	if code, ok := shortcodes[name]; ok {
		return fmt.Sprintf("%s, %s", pterm.Gray("-"+code), pterm.Gray("--"+name))
	}
	return pterm.Gray("--" + name)
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
		for cmd, use := range commandInfo {
			if !core.StringInSlice(cmd, hidden) {
				table.Append([]string{pterm.Gray(cmd), use})
			}
		}
		table.Render()

		os.Exit(0)
	}
}
