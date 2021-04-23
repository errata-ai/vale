// The MIT License (MIT)

// Copyright (c) 2016 Write.as

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

package core

import (
	"regexp"
)

var (
	listLeadersReg = regexp.MustCompile(`(?m)^([\s\t]*)([\*\-\+]|\d\.)\s+`)

	headerReg = regexp.MustCompile(`\n={2,}`)
	strikeReg = regexp.MustCompile(`~~`)
	codeReg   = regexp.MustCompile("`{3}" + `.*\n`)

	htmlReg         = regexp.MustCompile("<(.*?)>")
	emphReg         = regexp.MustCompile(`\*\*([^*]+)\*\*`)
	emphReg2        = regexp.MustCompile(`\*([^*]+)\*`)
	emphReg3        = regexp.MustCompile(`__([^_]+)__`)
	emphReg4        = regexp.MustCompile(`_([^_]+)_`)
	setextHeaderReg = regexp.MustCompile(`^[=\-]{2,}\s*$`)
	footnotesReg    = regexp.MustCompile(`\[\^.+?\](\: .*?$)?`)
	footnotes2Reg   = regexp.MustCompile(`\s{0,2}\[.*?\]: .*?$`)
	imagesReg       = regexp.MustCompile(`\!\[(.*?)\]\s?[\[\(].*?[\]\)]`)
	linksReg        = regexp.MustCompile(`\[(.*?)\][\[\(].*?[\]\)]`)
	blockquoteReg   = regexp.MustCompile(`>\s*`)
	refLinkReg      = regexp.MustCompile(`^\s{1,2}\[(.*?)\]: (\S+)( ".*?")?\s*$`)
	atxHeaderReg    = regexp.MustCompile(`(?m)^\#{1,6}\s*([^#]+)\s*(\#{1,6})?$`)
	atxHeaderReg2   = regexp.MustCompile(`([\*_]{1,3})(\S.*?\S)?P1`)
	atxHeaderReg3   = regexp.MustCompile("(?m)(`{3,})" + `(.*?)?P1`)
	atxHeaderReg4   = regexp.MustCompile(`^-{3,}\s*$`)
	atxHeaderReg5   = regexp.MustCompile("`(.+?)`")
	atxHeaderReg6   = regexp.MustCompile(`\n{2,}`)
)

// stripMarkdown returns the given string sans any Markdown.
// Where necessary, elements are replaced with their best textual forms, so
// for example, hyperlinks are stripped of their URL and become only the link
// text, and images lose their URL and become only the alt text.
func stripMarkdown(s string) string {
	res := s
	res = listLeadersReg.ReplaceAllString(res, "$1")

	res = headerReg.ReplaceAllString(res, "\n")
	res = strikeReg.ReplaceAllString(res, "")
	res = codeReg.ReplaceAllString(res, "")

	res = emphReg.ReplaceAllString(res, "$1")
	res = emphReg2.ReplaceAllString(res, "$1")
	res = emphReg3.ReplaceAllString(res, "$1")
	res = emphReg4.ReplaceAllString(res, "$1")
	res = htmlReg.ReplaceAllString(res, "$1")
	res = setextHeaderReg.ReplaceAllString(res, "")
	res = footnotesReg.ReplaceAllString(res, "")
	res = footnotes2Reg.ReplaceAllString(res, "")
	res = imagesReg.ReplaceAllString(res, "$1")
	res = linksReg.ReplaceAllString(res, "$1")
	res = blockquoteReg.ReplaceAllString(res, "  ")
	res = refLinkReg.ReplaceAllString(res, "")
	res = atxHeaderReg.ReplaceAllString(res, "$1")
	res = atxHeaderReg2.ReplaceAllString(res, "$2")
	res = atxHeaderReg3.ReplaceAllString(res, "$2")
	res = atxHeaderReg4.ReplaceAllString(res, "")
	res = atxHeaderReg5.ReplaceAllString(res, "$1")
	res = atxHeaderReg6.ReplaceAllString(res, "\n\n")
	return res
}
