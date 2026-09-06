package lint

import (
	"fmt"
	"strings"

	"github.com/vale-cli/vale/v3/internal/core"
	"github.com/vale-cli/vale/v3/internal/glob"
)

// hasView reports whether a `textfsm` or `dasel` view applies to the file.
// Either reads the whole file itself, so the file's own format does not
// matter; a tree-sitter view is reached through the code path instead.
func (l *Linter) hasView(f *core.File) bool {
	for syntax, view := range l.Manager.Config.Views {
		if view.Engine == "tree-sitter" {
			continue
		}
		if sec, err := glob.Compile(syntax); err == nil && sec.Match(f.Path) {
			return true
		}
	}
	return false
}

func (l *Linter) lintData(f *core.File) error {
	for syntax, view := range l.Manager.Config.Views {
		sec, err := glob.Compile(syntax)
		if err != nil {
			return err
		} else if sec.Match(f.Path) {
			found, berr := view.Apply(f)
			if berr != nil {
				return core.NewE201FromTarget(
					fmt.Sprintf("%s: %s", f.Path, berr),
					fmt.Sprintf("[%s] View", syntax),
					l.Manager.Config.RootINI,
				)
			}
			return l.lintScopedValues(f, found)
		}
	}
	return nil
}

func (l *Linter) lintScopedValues(f *core.File, values []core.ScopedValues) error {
	var err error
	wholeFile := f.Content
	srcLines := strings.Split(wholeFile, "\n")
	last := 0

	f.Scoped = make(map[string][]string, len(values))
	for _, match := range values {
		for _, sv := range match.Values {
			f.Scoped[match.Scope] = append(f.Scoped[match.Scope], sv.Text)
		}
	}

	for _, match := range values {
		f.SetMetaScope(match.Scope)

		seen := make(map[string]int)
		for _, sv := range match.Values {
			v := sv.Text

			line := ""
			i := sv.Line
			padding := sv.Column - 1
			fromParse := i > 0 && sv.Column > 0

			if fromParse {
				if i-1 < len(srcLines) {
					line = srcLines[i-1]
				}
			} else {
				var found int
				found, line = findLineBySubstring(wholeFile, v, seen)
				if found < 0 {
					return core.NewE100(f.Path, fmt.Errorf("'%s' not found", v))
				}
				i = found
				seen[line] = i
				padding = strings.Index(line, v)
				if strings.Count(v, "\n") > 0 {
					firstLine := strings.SplitN(v, "\n", 2)[0]
					padding = strings.Index(line, firstLine)
					if padding < 0 {
						// block scalar case - use indentation of matched line
						i--
						padding = strings.Index(line, strings.TrimSpace(line))
					}
				}
			}

			if strings.Contains(line, "\\n") && !sv.Joined {
				f.SetText(strings.ReplaceAll(v, "\n", " "))
			} else {
				f.SetText(v)
			}
			if sv.Joined {
				// One element per source line: an alert's line within the
				// value is its offset from the first, and there is no
				// escaped newline to widen its column by.
				line = ""
			}
			f.SetNormedExt(match.Format)

			switch {
			case v == "":
				// An empty value has nothing to parse, and parsing it yields no
				// block at all; a rule that requires text needs one to run on.
				err = l.lintLines(f)
			case match.Format == "md":
				err = l.lintMarkdown(f)
			case match.Format == "rst":
				err = l.lintRST(f)
			case match.Format == "html":
				err = l.lintHTML(f)
			case match.Format == "org":
				err = l.lintOrg(f)
			case match.Format == "adoc":
				err = l.lintADoc(f)
			default:
				err = l.lintLines(f)
			}
			if err != nil {
				return err
			}

			size := len(f.Alerts)
			if size != last {
				f.Alerts = adjustPos(f.Alerts, last, i, padding, v, line)
			}
			last = size
		}
	}

	// The values were linted in the file's place; put the file back, so the
	// `raw` scope that runs next reads the document and not the last value.
	f.SetText(wholeFile)
	return err
}
