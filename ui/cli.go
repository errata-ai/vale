package ui

import (
	"fmt"
	"os"
	"regexp"
	"strings"

	"github.com/fatih/color"
	"github.com/jdkato/vale/lint"
	"github.com/jdkato/vale/util"
	"github.com/olekukonko/tablewriter"
)

const (
	errorColor      color.Attribute = color.FgRed
	warningColor                    = color.FgYellow
	suggestionColor                 = color.FgBlue
	underlineColor                  = color.Underline
)

// PrintLineAlerts prints Alerts in <path>:<line>:<col>:<check>:<message> format.
func PrintLineAlerts(linted []lint.File) bool {
	var base string

	alertCount := 0
	spaces := regexp.MustCompile(" +")
	for _, f := range linted {
		// If vale is run from a parent directory of f, we use a shorter file
		// path -- e.g., if run from the directory 'vale', we use
		// 'testdata/test.cc: ...' instead of
		// /Users/.../.../.../vale/testdata/test.cc: ...'.
		if strings.Contains(f.Path, util.ExeDir) {
			base = strings.Split(f.Path, util.ExeDir)[1]
		} else {
			base = f.Path
		}

		for _, a := range f.SortedAlerts() {
			a.Message = strings.Replace(a.Message, "\n", "", -1)
			a.Message = spaces.ReplaceAllString(a.Message, " ")
			fmt.Print(fmt.Sprintf("%s:%d:%d:%s:%s\n",
				base, a.Line, a.Span[0], a.Check, a.Message))
			alertCount++
		}
	}
	return alertCount != 0
}

// PrintVerboseAlerts prints Alerts in verbose format.
func PrintVerboseAlerts(linted []lint.File) bool {
	var errors, warnings, suggestions int
	var symbol string

	for _, f := range linted {
		e, w, s := printVerboseAlert(f)
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
	fmt.Printf("%s %s, %s and %s in %d %s.\n", symbol,
		colorize(etotal, errorColor), colorize(wtotal, warningColor),
		colorize(stotal, suggestionColor), n, pluralize("file", n))

	return (errors + warnings + suggestions) != 0
}

func printVerboseAlert(f lint.File) (int, int, int) {
	var loc, level string
	var errors, warnings, notifications int

	spaces := regexp.MustCompile(" +")
	alerts := f.SortedAlerts()
	if len(alerts) == 0 {
		return 0, 0, 0
	}

	table := tablewriter.NewWriter(os.Stdout)
	table.SetCenterSeparator("")
	table.SetColumnSeparator("")
	table.SetRowSeparator("")
	table.SetAutoWrapText(!util.CLConfig.Wrap)

	fmt.Printf("\n %s", colorize(f.Path, underlineColor))
	for _, a := range alerts {
		a.Message = strings.Replace(a.Message, "\n", "", -1)
		a.Message = spaces.ReplaceAllString(a.Message, " ")
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

func pluralize(s string, n int) string {
	if n != 1 {
		return s + "s"
	}
	return s
}
