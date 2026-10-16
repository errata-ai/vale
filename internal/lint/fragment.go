package lint

import (
	"strings"

	"github.com/vale-cli/vale/v3/internal/core"
	"github.com/vale-cli/vale/v3/internal/lint/code"
)

func findLine(s string, line int) string {
	lines := strings.Split(s, "\n")
	if line > len(lines) {
		return ""
	}
	return lines[line-1]
}

func leadingSpaces(line string, offset int) int {
	spaces := 0
	for _, r := range line {
		if r == ' ' {
			spaces++
		} else {
			break
		}
	}
	return spaces - offset
}

func adjustAlerts(alerts []core.Alert, last int, comment code.Comment, lang *code.Language) []core.Alert {
	for i := range alerts {
		if i >= last {
			line := findLine(comment.Source, alerts[i].Line)

			padding := commentPadding(comment, alerts[i].Line, line, lang)

			alerts[i].Line += comment.Line - 1
			alerts[i].Span = []int{
				alerts[i].Span[0] + comment.Offset + padding,
				alerts[i].Span[1] + comment.Offset + padding,
			}
		}
	}
	return alerts
}

// commentPadding returns how far to move an alert to get from a column in the
// extracted comment back to a column in the source.
//
// A dedented comment recorded exactly what it took off each line, so it is
// asked rather than measured. Measuring the source line only agrees with the
// dedent when everything removed was whitespace, which is why a language whose
// decoration is not whitespace -- JSDoc's ` *` -- reported columns that were
// short by the width of the decoration.
//
// The caller adds comment.Offset separately, and a comment that starts in from
// the margin has that same indentation counted in what the dedent removed, so
// it comes back off here. This is what leadingSpaces does for the measured
// path.
func commentPadding(comment code.Comment, line int, source string, lang *code.Language) int {
	if n, ok := comment.StripAt(line); ok {
		// Strip describes the dedent only. The opening delimiter -- `"""`,
		// `/**` -- was removed before that by Delims, and it is still on the
		// line the alert is measured against, so it is added here. On any line
		// but the first there is no delimiter and this contributes nothing.
		if p := lang.Padding(source); line == 1 && p > 0 {
			// The delimiter line: Padding counts the marker and the spaces
			// after it, and those spaces are also what the dedent took off,
			// so adding the strip would count them twice.
			return p
		}
		return lang.Padding(source) + max(n-comment.Offset, 0)
	}

	padding := lang.Padding(source)
	if strings.HasPrefix(source, " ") {
		padding += leadingSpaces(source, comment.Offset)
	}

	return padding
}

func (l *Linter) lintFragments(f *core.File) error {
	lang, err := l.languageFor(f)
	if err != nil {
		return err
	}

	if found := updateQueries(f, l.Manager.Config); len(found) > 0 {
		lang.Queries = found
	}

	comments, err := code.GetComments([]byte(f.Content), lang)
	if err != nil {
		return err
	}

	wholeFile := f.Content
	converted := l.rstBatch(f, comments, strings.TrimPrefix(f.NormedExt, "."))

	last := 0
	for i, comment := range comments {
		// QDoc reads `/*! ... */` only; a `//` line comment or a plain
		// `/* ... */` block is code, not documentation.
		if f.NormedExt == ".qdoc" && !strings.HasPrefix(comment.Source, "/*!") {
			continue
		}

		f.SetMetaScope(comment.Scope)
		if l.skipsComment(comment.Scope) {
			continue
		}

		// The file's own mapping, unless the query named a markup of its own.
		format := comment.Format
		if format == "" {
			format = strings.TrimPrefix(f.NormedExt, ".")
		}
		err = l.lintComment(f, comment, format, converted[i])
		if err != nil {
			return err
		}
		f.Alerts = dropMasked(f.Alerts, last, comment)

		size := len(f.Alerts)
		if size != last {
			f.Alerts = adjustAlerts(f.Alerts, last, comment, lang)
		}
		last = size
	}

	// Each comment was linted in the file's place; put the file back, so the
	// `raw` scope that runs next reads the source and not the last comment.
	f.RestoreText(wholeFile)
	if err != nil {
		return err
	}
	return l.lintSummary(f)
}
