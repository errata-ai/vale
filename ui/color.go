package ui

import (
	"fmt"
	"os"
	"strings"

	"github.com/ValeLint/vale/core"
	"github.com/fatih/color"
	"github.com/olekukonko/tablewriter"
)

const (
	errorColor      color.Attribute = color.FgRed
	warningColor                    = color.FgYellow
	suggestionColor                 = color.FgBlue
	underlineColor                  = color.Underline
)

// PrintVerboseAlerts prints Alerts in verbose format.
func PrintVerboseAlerts(linted []*core.File, wrap bool) bool {
	var errors, warnings, suggestions int
	var e, w, s int
	var symbol string

	for _, f := range linted {
		e, w, s = printVerboseAlert(f, wrap)
		errors += e
		warnings += w
		suggestions += s
	}

	etotal := fmt.Sprintf("%d %s", errors, pluralize("error", errors))
	wtotal := fmt.Sprintf("%d %s", warnings, pluralize("warning", warnings))
	stotal := fmt.Sprintf("%d %s", suggestions, pluralize("suggestion", suggestions))

	if errors > 0 || warnings > 0 {
		symbol = "\u2716"
	} else {
		symbol = "\u2714"
	}

	n := len(linted)
	if n == 1 && strings.HasPrefix(linted[0].Path, "stdin") {
		fmt.Printf("%s %s, %s and %s in %s.\n", symbol,
			colorize(etotal, errorColor), colorize(wtotal, warningColor),
			colorize(stotal, suggestionColor), "stdin")
	} else {
		fmt.Printf("%s %s, %s and %s in %d %s.\n", symbol,
			colorize(etotal, errorColor), colorize(wtotal, warningColor),
			colorize(stotal, suggestionColor), n, pluralize("file", n))
	}

	return errors != 0
}

// printVerboseAlert includes an alert's line, column, level, and message.
func printVerboseAlert(f *core.File, wrap bool) (int, int, int) {
	var loc, level string
	var errors, warnings, notifications int

	alerts := f.SortedAlerts()
	if len(alerts) == 0 {
		return 0, 0, 0
	}

	table := tablewriter.NewWriter(os.Stdout)
	table.SetCenterSeparator("")
	table.SetColumnSeparator("")
	table.SetRowSeparator("")
	table.SetAutoWrapText(!wrap)

	fmt.Printf("\n %s", colorize(f.Path, underlineColor))
	for _, a := range alerts {
		a.Message = fixOutputSpacing(a.Message)
		if a.Severity == "suggestion" {
			level = colorize(a.Severity, suggestionColor)
			notifications++
		} else if a.Severity == "warning" {
			level = colorize(a.Severity, warningColor)
			warnings++
		} else {
			level = colorize(a.Severity, errorColor)
			errors++
		}
		loc = fmt.Sprintf("%d:%d", a.Line, a.Span[0])
		table.Append([]string{loc, level, a.Message, a.Check})
	}
	table.Render()
	return errors, warnings, notifications
}

func colorize(message string, textColor color.Attribute) string {
	colorPrinter := color.New(textColor)
	f := colorPrinter.SprintFunc()
	return f(message)
}
