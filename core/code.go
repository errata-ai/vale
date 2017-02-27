package core

import (
	"bytes"
	"fmt"
	"regexp"

	"github.com/ValeLint/vale/util"
)

// lintCode lints source code -- whether it be a markup codeblock, a complete
// file, or some other portion of text.
func (f *File) lintCode(prev int, bail *regexp.Regexp) int {
	var line, match, txt string
	var lnLength, padding int
	var block bytes.Buffer

	lines := prev
	comments := util.CommentsByNormedExt[f.NormedExt]
	if len(comments) == 0 {
		return lines
	}

	scope := "%s" + f.RealExt
	inline := regexp.MustCompile(comments["inline"])
	blockStart := regexp.MustCompile(comments["blockStart"])
	blockEnd := regexp.MustCompile(comments["blockEnd"])
	ignore := false
	inBlock := false

	for f.Scanner.Scan() {
		line = f.Scanner.Text() + "\n"
		lnLength = len(line)
		lines++
		if bail.MatchString(line) {
			// We've encountered the end of a specified block (e.g., ``` for Markdown).
			return lines
		} else if inBlock {
			// We're in a block comment.
			if match = blockEnd.FindString(line); len(match) > 0 {
				// We've found the end of the block.
				block.WriteString(line)
				txt = block.String()
				b := NewBlock(txt, txt, fmt.Sprintf(scope, "text.comment.block"))
				f.lintText(b, lines+1, 0)
				block.Reset()
				inBlock = false
			} else {
				block.WriteString(line)
			}
		} else if match = inline.FindString(line); len(match) > 0 {
			// We've found an inline comment. We need padding here in order to
			// calculate the column span because, for example, a line like
			// 'print("foo") # ...' will be condensed to '# ...'.
			padding = lnLength - len(match)
			b := NewBlock(match, match, fmt.Sprintf(scope, "text.comment.line"))
			f.lintText(b, lines, padding-1)
		} else if match = blockStart.FindString(line); len(match) > 0 && !ignore {
			// We've found the start of a block comment.
			block.WriteString(line)
			inBlock = true
		} else if match = blockEnd.FindString(line); len(match) > 0 {
			ignore = !ignore
		}
	}
	return lines
}

// lintCodeblock is a wrapper around lintCode that creates a file representing
// the block.
func (f *File) lintCodeblock(syn string, prev int, bail *regexp.Regexp) ([]Alert, int) {
	ext := util.ExtFromSyntax(syn)
	file := File{Path: ext, NormedExt: ext, Scanner: f.Scanner, Checks: f.Checks,
		BaseStyles: f.BaseStyles, RealExt: f.RealExt}
	lines := file.lintCode(prev, bail)
	return file.Alerts, lines
}
