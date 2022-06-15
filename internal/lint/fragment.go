package lint

import (
	"bytes"

	"github.com/errata-ai/vale/v2/internal/core"
)

func coalesce(comments []Comment) []Comment {
	var joined []Comment

	buf := bytes.Buffer{}
	for i, comment := range comments {
		if comment.Scope == "text.comment.block" {
			joined = append(joined, comment)
		} else if i == 0 || comments[i-1].Line != comment.Line-1 {
			if buf.Len() > 0 {
				// We have comments to merge ...
				last := joined[len(joined)-1]
				last.Text += buf.String()
				joined[len(joined)-1] = last
				buf.Reset()
			}
			joined = append(joined, comment)
		} else {
			buf.WriteString(comment.Text)
		}
	}

	if buf.Len() > 0 {
		last := joined[len(joined)-1]
		last.Text += buf.String()
		joined[len(joined)-1] = last
		buf.Reset()
	}

	return joined
}

func adjustAlerts(last int, ctx Comment, alerts []core.Alert) []core.Alert {
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
	for _, comment := range coalesce(getComments(f.Content, f.RealExt)) {
		f.SetText(comment.Text)

		switch f.NormedExt {
		case "md":
			err = l.lintMarkdown(f)
		case "rst":
			err = l.lintRST(f)
		case "adoc":
			err = l.lintADoc(f)
		}

		size := len(f.Alerts)
		if size != last {
			f.Alerts = adjustAlerts(last, comment, f.Alerts)
		}
		last = size
	}

	return err
}
