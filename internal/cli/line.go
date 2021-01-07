package cli

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/errata-ai/vale/v2/internal/core"
)

// PrintLineAlerts prints Alerts in <path>:<line>:<col>:<check>:<message> format.
func PrintLineAlerts(linted []*core.File, relative bool) bool {
	var base string

	exeDir, _ := filepath.Abs(filepath.Dir(os.Args[0]))

	alertCount := 0
	for _, f := range linted {
		// If vale is run from a parent directory of f, we use a shorter file
		// path -- e.g., if run from the directory 'vale', we use
		// 'testdata/test.cc: ...' instead of
		// /Users/.../.../.../vale/testdata/test.cc: ...'.
		if relative && strings.Contains(f.Path, exeDir) {
			// FIXME: This doesn't work as intended, but our tests rely on its
			// output -- so, we hide it behind a flag for now.
			base = strings.Split(f.Path, exeDir)[1]
		} else {
			base = f.Path
		}

		for _, a := range f.SortedAlerts() {
			if a.Severity == "error" {
				alertCount++
			}
			fmt.Print(fmt.Sprintf("%s:%d:%d:%s:%s\n",
				base, a.Line, a.Span[0], a.Check, a.Message))
		}
	}
	return alertCount != 0
}
