package prose

import (
	"github.com/jdkato/prose/tag"
	"github.com/jdkato/prose/tokenize"
)

// TextToWords converts a string to a slice of strings representing words.
func TextToWords(text string) []string {
	words := []string{}
	sentTokenizer := tokenize.NewPunktSentenceTokenizer()
	wordTokenizer := tokenize.NewTreebankWordTokenizer()

	for _, s := range sentTokenizer.Tokenize(text) {
		words = append(words, wordTokenizer.Tokenize(s)...)
	}

	return words
}

// TagText converts a string to a slice of tagged Tokens.
func TagText(text string) []tag.Token {
	words := TextToWords(text)
	tagger := tag.NewPerceptronTagger()
	return tagger.Tag(words)
}
