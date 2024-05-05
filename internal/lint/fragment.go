package lint

import (
	"fmt"

	"github.com/errata-ai/vale/v3/internal/core"
	"github.com/errata-ai/vale/v3/internal/lint/code"
)

func adjustAlerts(last int, ctx code.Comment, alerts []core.Alert) []core.Alert {
	for i := range alerts {
		if i >= last {
			alerts[i].Line += ctx.Line - 1
			alerts[i].Span = []int{alerts[i].Span[0] + ctx.Offset, alerts[i].Span[1] + ctx.Offset}
		}
	}
	return alerts
}

func (l *Linter) lintFragments(f *core.File) error {
	var err error

	// We want to set up our processing servers as if we were dealing with
	// a directory since we likely have many fragments to convert.
	l.HasDir = true

	last := 0
	// coalesce(getComments(f.Content, f.RealExt))
	for _, comment := range []code.Comment{} {
		f.SetText(comment.Text)

		switch f.NormedExt {
		case ".md":
			err = l.lintMarkdown(f)
		case ".rst":
			err = l.lintRST(f)
		case ".adoc":
			err = l.lintADoc(f)
		case ".org":
			err = l.lintOrg(f)
		default:
			return fmt.Errorf("unsupported markup format '%s'", f.NormedExt)
		}

		size := len(f.Alerts)
		if size != last {
			f.Alerts = adjustAlerts(last, comment, f.Alerts)
		}
		last = size
	}

	return err
}
