// +build !closed

package rule

import (
	"github.com/errata-ai/vale/core"
)

// CheckWithLT interfaces with a running instace of LanguageTool.
func CheckWithLT(text, path string, f *core.File, debug bool) []core.Alert {
	return []core.Alert{}
}
