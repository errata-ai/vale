package main

import (
	"encoding/json"
	"fmt"
	"os"
	"regexp"
	"strings"

	"github.com/ValeLint/vale/core"
	"github.com/ValeLint/vale/util"
	"github.com/fatih/color"
	"github.com/olekukonko/tablewriter"
)

const (
	errorColor      color.Attribute = color.FgRed
	warningColor                    = color.FgYellow
	suggestionColor                 = color.FgBlue
	underlineColor                  = color.Underline
)

var spaces = regexp.MustCompile(" +")

// printLineAlerts prints Alerts in <path>:<line>:<col>:<check>:<message> format.
func printLineAlerts(linted []core.File) bool {
	var base string

	alertCount := 0
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
			if a.Severity == "error" {
				alertCount++
			}
			a.Message = fixOutputSpacing(a.Message)
			fmt.Print(fmt.Sprintf("%s:%d:%d:%s:%s\n",
				base, a.Line, a.Span[0], a.Check, a.Message))
		}
	}
	return alertCount != 0
}

// printJSONAlerts prints Alerts in map[file.path][]Alert form.
func printJSONAlerts(linted []core.File) bool {
	alertCount := 0
	formatted := map[string][]core.Alert{}
	for _, f := range linted {
		for _, a := range f.SortedAlerts() {
			if a.Severity == "error" {
				alertCount++
			}
			a.Message = fixOutputSpacing(a.Message)
			formatted[f.Path] = append(formatted[f.Path], a)
		}
	}
	b, err := json.MarshalIndent(formatted, "", "  ")
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println(string(b))
	}
	return alertCount != 0
}

// printVerboseAlerts prints Alerts in verbose format.
func printVerboseAlerts(linted []core.File) bool {
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

	return errors != 0
}

func printVerboseAlert(f core.File) (int, int, int) {
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
	table.SetAutoWrapText(!util.CLConfig.Wrap)

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

func pluralize(s string, n int) string {
	if n != 1 {
		return s + "s"
	}
	return s
}

func fixOutputSpacing(msg string) string {
	msg = strings.Replace(msg, "\n", " ", -1)
	msg = spaces.ReplaceAllString(msg, " ")
	return msg
}
