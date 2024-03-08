package lint

import (
	"bufio"
	"bytes"
	"errors"
	"regexp"
	"strings"

	"github.com/alecthomas/chroma/v2"
	"github.com/alecthomas/chroma/v2/lexers"

	"github.com/errata-ai/vale/v3/internal/core"
)

// Comment represents an in-code comment (line or block).
type Comment struct {
	Text   string
	Line   int
	Offset int
	Scope  string
}

// NOTE: This is different from `internal/core/format.go` because we need to
// handle each comment type separately in order to strip the prefixes
// (e.g., "//" or "/*") from the matched text.
//
// It's also important to note that this is certainly the *wrong* way to do
// this. We should handle code the same way we do markup -- by offloading the
// parsing duties to dedicated libraries.
//
// In practice, the best option is probably to use `tree-sitter` (see the
// relevant branch). However, the dependency is requires `CGO_ENABLED` and
// nearly triples the size of the compiled binary. So ... we'll see.
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
	".jl": {
		"inline": []*regexp.Regexp{
			regexp.MustCompile(`(?s)#(.+)`),
		},
		"blockStart": []*regexp.Regexp{
			regexp.MustCompile(`(?ms)^(^#=)`),
			regexp.MustCompile(`(?ms)^(?:@doc )?(?:raw)?["']{3}(.+)`),
		},
		"blockEnd": []*regexp.Regexp{
			regexp.MustCompile(`(^=#)`),
			regexp.MustCompile(`(.*["']{3})`),
		},
	},
	".ps1": {
		"inline": []*regexp.Regexp{
			regexp.MustCompile(`(?s)#(.+)`),
		},
		"blockStart": []*regexp.Regexp{
			regexp.MustCompile(`(?ms)^(?:<#)(.+)`),
		},
		"blockEnd": []*regexp.Regexp{
			regexp.MustCompile(`(.*#>)`),
		},
	},
}

func trimLeading(lang, line string) string {
	if core.StringInSlice(lang, []string{".jl"}) {
		return line
	}
	return strings.TrimLeft(line, " ")
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
				block.WriteString(trimLeading(ext, line))
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

func getCommentsLexer(content, ext string) ([]Comment, error) {
	var comments []Comment

	lexer := lexers.Match("temp" + ext)
	if lexer == nil {
		return comments, errors.New("no lexer found for " + ext)
	}

	it, err := lexer.Tokenise(nil, content)
	if err != nil {
		return comments, err
	}

	for _, token := range it.Tokens() {
		if len(token.Value) == 0 {
			continue
		}
		switch token.Type {
		case chroma.CommentMultiline, chroma.LiteralStringDoc, chroma.LiteralStringDouble, chroma.LiteralStringHeredoc:
			comments = append(comments, Comment{
				Text:   token.String(),
				Line:   0,
				Offset: 0,
				Scope:  "text.comment.block",
			})
		case chroma.CommentSingle:
			comments = append(comments, Comment{
				Text:   token.Value,
				Line:   0,
				Offset: 0,
				Scope:  "text.comment.line",
			})
		}
	}

	return comments, nil
}
