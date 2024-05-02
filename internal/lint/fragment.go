package lint

import (
	"bytes"
	"fmt"
	"strings"

	"github.com/errata-ai/vale/v3/internal/core"
	"github.com/errata-ai/vale/v3/internal/lint/code"
)

func shouldMerge(curr, prev code.Comment) bool {
	return true
}

func coalesce(comments []code.Comment) []code.Comment {
	var joined []code.Comment

	buf := bytes.Buffer{}
	for i, comment := range comments {
		offset := comment.Offset
		if i > 0 {
			offset += comments[i-1].Offset
		}

		if comment.Scope == "text.comment.block" { //nolint:gocritic
			joined = append(joined, comment)
		} else if i == 0 || shouldMerge(comment, comments[i-1]) {
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

	for i, comment := range joined {
		joined[i].Text = strings.TrimLeft(comment.Text, " ")
	}

	return joined
}

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
