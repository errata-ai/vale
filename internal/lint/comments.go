package lint

import (
	"bufio"
	"bytes"
	"regexp"
	"strings"

	"github.com/errata-ai/vale/v2/internal/core"
)

const (
	Inline int = iota
	BlockStart
	BlockEnd
)

// Comment represents an in-code comment (line or block).
type Comment struct {
	Text   string
	Line   int
	Offset int
	Scope  string
}

type Pattern struct {
	Regex  *regexp.Regexp
	Offset int
}

var patterns = map[string]map[string][]Pattern{
	".c": {
		"inline": []Pattern{
			{Regex: regexp.MustCompile(`(?s)/\*(.+)\*/`), Offset: 2},
			{Regex: regexp.MustCompile(`(?s)/{2}(.+)`), Offset: 2},
		},
		"blockStart": []Pattern{
			{Regex: regexp.MustCompile(`(?ms)/\*(.+)`), Offset: 0},
		},
		"blockEnd": []Pattern{
			{Regex: regexp.MustCompile(`(.*\*/)`), Offset: 0},
		},
	},
	".rs": {
		"inline": []Pattern{
			{Regex: regexp.MustCompile(`(?s)/{3}!(.+)`), Offset: 4},
			{Regex: regexp.MustCompile(`(?s)/{3}(.+)`), Offset: 3},
			{Regex: regexp.MustCompile(`(?s)/{2}(.+)`), Offset: 2},
		},
		"blockStart": []Pattern{},
		"blockEnd":   []Pattern{},
	},
	".py": {
		"inline": []Pattern{
			{Regex: regexp.MustCompile(`(?s)#(.+)`), Offset: 1},
			{Regex: regexp.MustCompile(`"""(.+)"""`), Offset: 3},
			{Regex: regexp.MustCompile(`'''(.+)'''`), Offset: 2},
		},
		"blockStart": []Pattern{
			{Regex: regexp.MustCompile(`(?ms)^(?:\s{4,})?r?["']{3}(.+)$`), Offset: 0},
		},
		"blockEnd": []Pattern{
			{Regex: regexp.MustCompile(`(.*["']{3})`), Offset: 0},
		},
	},
	".rb": {
		"inline": []Pattern{
			{Regex: regexp.MustCompile(`(?s)#(.+)`), Offset: 0},
		},
		"blockStart": []Pattern{
			{Regex: regexp.MustCompile(`(?ms)^=begin(.+)`), Offset: 0},
		},
		"blockEnd": []Pattern{
			{Regex: regexp.MustCompile(`(^=end)`), Offset: 0},
		},
	},
}

func toMarkup(comments []Comment) string {
	var markup bytes.Buffer

	for _, comment := range comments {
		markup.WriteString(strings.TrimLeft(comment.Text, " "))
	}

	return markup.String()
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

func doMatch(p []Pattern, line string) (string, int) {
	for _, r := range p {
		if m := getSubMatch(r.Regex, line); m != "" {
			return m, r.Offset
		}
	}
	return "", 0
}

func getPatterns(ext string) map[string][]Pattern {
	for r, f := range core.FormatByExtension {
		m, _ := regexp.MatchString(r, ext)
		if m {
			return patterns[f[0]]
		}
	}
	return map[string][]Pattern{}
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
			if match, _ := doMatch(byLang["blockEnd"], line); len(match) > 0 {
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
		} else if match, _ := doMatch(byLang["inline"], line); len(match) > 0 {
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
		} else if match, _ := doMatch(byLang["blockStart"], line); len(match) > 0 && !ignore {
			// We've found the start of a block comment.
			block.WriteString(match)
			start = lines
			inBlock = true
		} else if match, _ := doMatch(byLang["blockEnd"], line); len(match) > 0 {
			ignore = !ignore
		}
	}

	return comments
}
