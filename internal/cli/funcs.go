package cli

import (
	"fmt"
	"os"

	"github.com/Masterminds/sprig/v3"
	"github.com/logrusorgru/aurora/v3"
	"github.com/olekukonko/tablewriter"
)

var funcs = sprig.TxtFuncMap()

func init() {
	funcs["red"] = func(s string) string {
		return fmt.Sprintf("%s", aurora.Red(s))
	}
	funcs["blue"] = func(s string) string {
		return fmt.Sprintf("%s", aurora.Blue(s))
	}
	funcs["yellow"] = func(s string) string {
		return fmt.Sprintf("%s", aurora.Yellow(s))
	}
	funcs["underline"] = func(s string) string {
		return fmt.Sprintf("%s", aurora.Underline(s))
	}
	funcs["newTable"] = func(wrap bool) *tablewriter.Table {
		table := tablewriter.NewWriter(os.Stdout)
		table.SetCenterSeparator("")
		table.SetColumnSeparator("")
		table.SetRowSeparator("")
		table.SetAutoWrapText(wrap)
		return table
	}
	funcs["addRow"] = func(t *tablewriter.Table, r []string) *tablewriter.Table {
		t.Append(r)
		return t
	}
	funcs["renderTable"] = func(t *tablewriter.Table) *tablewriter.Table {
		t.Render()
		t.ClearRows()
		return t
	}
}
