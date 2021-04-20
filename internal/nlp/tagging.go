package nlp

import (
	"strings"

	"github.com/jdkato/prose/tag"
	"github.com/jdkato/prose/tokenize"
)

// tagger tags a sentence.
//
// We wait to initialize it until we need it since it's slow (~1s) and we may
// not need it.
var tagger *tag.PerceptronTagger

// doTag assigns part-of-speech tags to `words`.
func doTag(words []string) []tag.Token {
	if tagger == nil {
		tagger = tag.NewPerceptronTagger()
	}
	return tagger.Tag(words)
}

// textToWords convert raw text into a slice of words.
func textToWords(text string, nlp bool) []string {
	// TODO: Replace with iterTokenizer?
	tok := tokenize.NewTreebankWordTokenizer()

	words := []string{}
	for _, s := range SentenceTokenizer.Tokenize(text) {
		if nlp {
			words = append(words, tok.Tokenize(s)...)
		} else {
			words = append(words, strings.Fields(s)...)
		}
	}

	return words
}

// TextToTokens converts a string to a slice of tokens.
func TextToTokens(text string, needsTagging bool) []tag.Token {
	return doTag(textToWords(text, true))
}
