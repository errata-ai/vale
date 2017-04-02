package tokenize

import (
	"regexp"
	"strings"
)

// TreebankWordTokenizer is a port if NLTK's Treebank tokenizer.
// See https://github.com/nltk/nltk/blob/develop/nltk/tokenize/treebank.py.
type TreebankWordTokenizer struct {
}

// NewTreebankWordTokenizer creates a new TreebankWordTokenizer.
func NewTreebankWordTokenizer() *TreebankWordTokenizer {
	return new(TreebankWordTokenizer)
}

var startingQuotes = map[string]*regexp.Regexp{
	"``":     regexp.MustCompile(`^\"`),
	" $1 ":   regexp.MustCompile("(``)"),
	"$1 `` ": regexp.MustCompile(`'([ (\[{<])"`),
}
var punctuation = map[string]*regexp.Regexp{
	" $1$2":    regexp.MustCompile(`([:,])([^\d])`),
	" ... ":    regexp.MustCompile(`\.\.\.`),
	"$1 $2$3 ": regexp.MustCompile(`([^\.])(\.)([\]\)}>"\']*)\s*$`),
	"$1 ' ":    regexp.MustCompile(`([^'])' `),
}
var punctuation2 = []*regexp.Regexp{
	regexp.MustCompile(`([:,])$`),
	regexp.MustCompile(`([;@#$%&?!])`),
}
var brackets = map[string]*regexp.Regexp{
	" $1 ": regexp.MustCompile(`[\]\[\(\)\{\}\<\>]`),
	" -- ": regexp.MustCompile(`--`),
}
var endingQuotes = map[string]*regexp.Regexp{
	" '' ": regexp.MustCompile(`"`),
}
var endingQuotes2 = []*regexp.Regexp{
	regexp.MustCompile(`'(\S)(\'\')'`),
	regexp.MustCompile(`([^' ])('[sS]|'[mM]|'[dD]|') `),
	regexp.MustCompile(`([^' ])('ll|'LL|'re|'RE|'ve|'VE|n't|N'T) `),
}
var contractions = []*regexp.Regexp{
	regexp.MustCompile(`(?i)\b(can)(not)\b`),
	regexp.MustCompile(`(?i)\b(d)('ye)\b`),
	regexp.MustCompile(`(?i)\b(gim)(me)\b`),
	regexp.MustCompile(`(?i)\b(gon)(na)\b`),
	regexp.MustCompile(`(?i)\b(got)(ta)\b`),
	regexp.MustCompile(`(?i)\b(lem)(me)\b`),
	regexp.MustCompile(`(?i)\b(mor)('n)\b`),
	regexp.MustCompile(`(?i)\b(wan)(na) `),
	regexp.MustCompile(`(?i) ('t)(is)\b`),
	regexp.MustCompile(`(?i) ('t)(was)\b`),
}

// Tokenize splits text into words.
func (t TreebankWordTokenizer) Tokenize(text string) []string {
	for substitution, r := range startingQuotes {
		text = r.ReplaceAllString(text, substitution)
	}

	for substitution, r := range punctuation {
		text = r.ReplaceAllString(text, substitution)
	}

	for _, r := range punctuation2 {
		text = r.ReplaceAllString(text, " $1 ")
	}

	for substitution, r := range brackets {
		text = r.ReplaceAllString(text, substitution)
	}

	text = " " + text + " "

	for substitution, r := range endingQuotes {
		text = r.ReplaceAllString(text, substitution)
	}

	for _, r := range endingQuotes2 {
		text = r.ReplaceAllString(text, "$1 $2 ")
	}

	for _, r := range contractions {
		text = r.ReplaceAllString(text, " $1 $2 ")
	}

	return strings.Split(strings.TrimSpace(text), " ")
}
