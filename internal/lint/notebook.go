package lint

import (
	"github.com/vale-cli/vale/v3/internal/core"
)

// lintNotebook lints a Jupyter notebook cell by cell: a Markdown cell as
// Markdown, and a code cell as the kernel's language, so that its comments
// are the prose. Raw cells and outputs are neither.
//
// A View on the file takes precedence, in lintFile, for anyone who wants a
// different reading.
func (l *Linter) lintNotebook(f *core.File) error {
	cells, err := core.ParseNotebook(f)
	if err != nil {
		return core.NewE100(f.Path, err)
	}

	wholeFile, realExt, normedExt := f.Content, f.RealExt, f.NormedExt
	last := 0

	for _, cell := range cells {
		switch {
		case cell.Type == "markdown":
			f.SetText(cell.Value.Text)
			f.NormedExt = ".md"
			err = l.lintMarkdown(f)
		case cell.Type == "code" && cell.Lang != "":
			f.SetText(cell.Value.Text)
			err = l.lintAsCode(f, cell.Lang)
		default:
			continue
		}
		if err != nil {
			break
		}

		if size := len(f.Alerts); size != last {
			f.Alerts = placeAlerts(f.Alerts, last, cell.Value, f.Content)
			last = size
		}
	}

	f.SetText(wholeFile)
	f.RealExt, f.NormedExt = realExt, normedExt
	return err
}
