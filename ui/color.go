package ui

import (
	"fmt"
	"os"
	"regexp"
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

const (
	// CONTEXT prints an alert with its surrounding text.
	CONTEXT = iota

	// VERBOSE prints an alert with its Message, Level, and Check.
	VERBOSE
)

var spaces = regexp.MustCompile(" +")

// PrintVerboseAlerts prints Alerts in verbose format.
func PrintVerboseAlerts(linted []*core.File, option int) bool {
	var errors, warnings, suggestions int
	var e, w, s int
	var symbol string

	for _, f := range linted {
		if option == VERBOSE {
			e, w, s = printVerboseAlert(f)
		} else {
			e, w, s = printContextAlert(f)
		}
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

	return errors != 0
}

func printContextAlert(f *core.File) (int, int, int) {
	var errors, warnings, notifications int

	alerts := f.SortedAlerts()
	if len(alerts) == 0 {
		return 0, 0, 0
	}

	fmt.Printf("\n%s\n", colorize(f.Path, underlineColor))
	for _, a := range alerts {
		if a.Severity == "suggestion" {
			notifications++
		} else if a.Severity == "warning" {
			warnings++
		} else {
			errors++
		}
		output := colorizeSubString(a.Context, a.Match, color.FgRed)
		line := colorize(fmt.Sprintf("%d", a.Line), color.FgGreen)
		fmt.Print(fmt.Sprintf("%s:%s", line, output))
	}
	fmt.Print("\n")

	return errors, warnings, notifications
}

func printVerboseAlert(f *core.File) (int, int, int) {
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
	table.SetAutoWrapText(!core.CLConfig.Wrap)

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

func colorizeSubString(src, sub string, textColor color.Attribute) string {
	idx := strings.Index(src, sub)
	if idx < 0 {
		return src
	}
	return src[:idx] + colorize(sub, textColor) + src[idx+len(sub):]
}
