// Package chunk implements functions for finding useful chunks in text previously tagged from parts of speech.
//
package chunk

import (
	"regexp"

	"github.com/jdkato/prose/tag"
)

// quadString creates a string containing all of the tags, each padded to 4 characters wide.
func quadsString(tagged []tag.Token) string {
	tagQuads := ""
	for _, tok := range tagged {
		padding := ""
		tag := tok.Tag
		switch len(tag) {
		case 0:
			padding = "____" // should not exist
		case 1:
			padding = "___"
		case 2:
			padding = "__"
		case 3:
			padding = "_"
		case 4: // no padding required
		default:
			tag = tag[:4] // longer than 4 ... truncate!
		}
		tagQuads += tag + padding
	}
	return tagQuads
}

// TreebankNamedEntities matches proper names, including prior adjectives, possibly including numbers, and
// possibly including a linkage by preposition or subordinating conjunctions (for example "Bank of England").
var TreebankNamedEntities = regexp.MustCompile(
	`((JJ._)*(CD__)*(NNP.)+(CD__|NNP.)*)+` + // at least one proper noun, maybe preceded by an adjective and/or number
		`((IN__)*(JJ._)*(CD__)*(NNP.)+(CD__|NNP.)*)*`) // then zero or more subordinated noun phrases

// Locate the chunks of interest according to the regexp.
func Locate(tagged []tag.Token, rx *regexp.Regexp) [][]int {
	rx.Longest() // make sure we find the longest possible sequences
	rs := rx.FindAllStringIndex(quadsString(tagged), -1)
	for i, ii := range rs {
		for j := range ii {
			rs[i][j] /= 4 // quadsString makes every offset 4x what it should be
		}
	}
	return rs
}
