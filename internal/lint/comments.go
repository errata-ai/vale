package lint

import (
	"bufio"
	"bytes"
	"regexp"
	"strings"

	"github.com/errata-ai/vale/v3/internal/core"
)

// Comment represents an in-code comment (line or block).
type Comment struct {
	Text   string
	Line   int
	Offset int
	Scope  string
}

var patterns = map[string]map[string][]*regexp.Regexp{
	".c": {
		"inline": []*regexp.Regexp{
			regexp.MustCompile(`(?s)/\*(.+)\*/`),
			regexp.MustCompile(`(?s)/{2}(.+)`),
		},
		"blockStart": []*regexp.Regexp{
			regexp.MustCompile(`(?ms)/\*(.+)`),
		},
		"blockEnd": []*regexp.Regexp{
			regexp.MustCompile(`(.*\*/)`),
		},
	},
	".clj": {
		"inline": []*regexp.Regexp{
			regexp.MustCompile(`(?s);+(.+)`),
		},
		"blockStart": []*regexp.Regexp{},
		"blockEnd":   []*regexp.Regexp{},
	},
	".css": {
		"inline": []*regexp.Regexp{
			regexp.MustCompile(`(?s)/\*(.+)\*/`),
		},
		"blockStart": []*regexp.Regexp{
			regexp.MustCompile(`(?ms)/\*(.+)`),
		},
		"blockEnd": []*regexp.Regexp{
			regexp.MustCompile(`(.*\*/)`),
		},
	},
	".rs": {
		"inline": []*regexp.Regexp{
			regexp.MustCompile(`(?s)/{3}!(.+)`),
			regexp.MustCompile(`(?s)/{3}(.+)`),
			regexp.MustCompile(`(?s)/{2}(.+)`),
		},
		"blockStart": []*regexp.Regexp{},
		"blockEnd":   []*regexp.Regexp{},
	},
	".r": {
		"inline": []*regexp.Regexp{
			regexp.MustCompile(`(?s)#(.+)`),
		},
		"blockStart": []*regexp.Regexp{},
		"blockEnd":   []*regexp.Regexp{},
	},
	".php": {
		"inline": []*regexp.Regexp{
			regexp.MustCompile(`(?s)/\*(.+)\*/`),
			regexp.MustCompile(`(?s)#(.+)`),
			regexp.MustCompile(`(?s)/{2}(.+)`),
		},
		"blockStart": []*regexp.Regexp{
			regexp.MustCompile(`(?ms)/\*(.+)`),
		},
		"blockEnd": []*regexp.Regexp{
			regexp.MustCompile(`(.*\*/)`),
		},
	},
	".py": {
		"inline": []*regexp.Regexp{
			regexp.MustCompile(`(?s)#(.+)`),
			regexp.MustCompile(`"""(.+)"""`),
			regexp.MustCompile(`'''(.+)'''`),
		},
		"blockStart": []*regexp.Regexp{
			regexp.MustCompile(`(?ms)^(?:\s{4,})?r?["']{3}(.+)$`),
		},
		"blockEnd": []*regexp.Regexp{
			regexp.MustCompile(`(.*["']{3})`),
		},
	},
	".rb": {
		"inline": []*regexp.Regexp{
			regexp.MustCompile(`(?s)#(.+)`),
		},
		"blockStart": []*regexp.Regexp{
			regexp.MustCompile(`(?ms)^=begin(.+)`),
		},
		"blockEnd": []*regexp.Regexp{
			regexp.MustCompile(`(^=end)`),
		},
	},
	".lua": {
		"inline": []*regexp.Regexp{
			regexp.MustCompile(`(?s)-- (.+)`),
		},
		"blockStart": []*regexp.Regexp{
			regexp.MustCompile(`(?ms)^-{2,3}\[\[(.*)`),
		},
		"blockEnd": []*regexp.Regexp{
			regexp.MustCompile(`(.*\]\])`),
		},
	},
	".hs": {
		"inline": []*regexp.Regexp{
			regexp.MustCompile(`(?s)-- (.+)`),
		},
		"blockStart": []*regexp.Regexp{
			regexp.MustCompile(`(?ms)^\{-.(.*)`),
		},
		"blockEnd": []*regexp.Regexp{
			regexp.MustCompile(`(.*-\})`),
		},
	},
}

func getSubMatch(r *regexp.Regexp, s string) string {
	matches := r.FindStringSubmatch(s)
	for i, m := range matches {
		if i > 0 && m != "" {
			return m
		}
	}
	return ""
}

func padding(line string) int {
	return len(line) - len(strings.TrimLeft(line, " "))
}

func doMatch(p []*regexp.Regexp, line string) string {
	for _, r := range p {
		if m := getSubMatch(r, line); m != "" {
			return m
		}
	}
	return ""
}

func getPatterns(ext string) map[string][]*regexp.Regexp {
	for r, f := range core.FormatByExtension {
		m, _ := regexp.MatchString(r, ext)
		if m {
			return patterns[f[0]]
		}
	}
	return map[string][]*regexp.Regexp{}
}

func getComments(content, ext string) []Comment {
	var comments []Comment
	var lines, start int
	var inBlock, ignore bool
	var block bytes.Buffer

	scanner := bufio.NewScanner(strings.NewReader(content))

	byLang := getPatterns(ext)
	if len(byLang) == 0 {
		return comments
	}

	scanner.Split(core.SplitLines)
	for scanner.Scan() {
		line := scanner.Text() + "\n"

		lines++
		if inBlock {
			// We're in a block comment.
			if match := doMatch(byLang["blockEnd"], line); len(match) > 0 {
				// We've found the end of the block.

				comments = append(comments, Comment{
					Text:   block.String(),
					Line:   start,
					Offset: padding(line),
					Scope:  "text.comment.block",
				})

				block.Reset()
				inBlock = false
			} else {
				block.WriteString(strings.TrimLeft(line, " "))
			}
		} else if match := doMatch(byLang["inline"], line); len(match) > 0 {
			// We've found an inline comment.
			//
			// We need padding here in order to calculate the column
			// span because, for example, a line like  'print("foo") # ...'
			// will be condensed to '# ...'.
			comments = append(comments, Comment{
				Text:   match,
				Line:   lines,
				Offset: strings.Index(line, match),
				Scope:  "text.comment.line",
			})
		} else if match = doMatch(byLang["blockStart"], line); len(match) > 0 && !ignore {
			// We've found the start of a block comment.
			block.WriteString(match)
			start = lines
			inBlock = true
		} else if match = doMatch(byLang["blockEnd"], line); len(match) > 0 {
			ignore = !ignore
		}
	}

	return comments
}
