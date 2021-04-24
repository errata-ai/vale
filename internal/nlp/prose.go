package nlp

import (
	"strings"

	"github.com/jdkato/prose/tag"
	"github.com/jdkato/prose/tokenize"
)

// TaggedWord is a word with an NLP context.
type TaggedWord struct {
	Token tag.Token
	Line  int
	Span  []int
}

// WordTokenizer splits text into words.
var WordTokenizer = tokenize.NewRegexpTokenizer(
	`[\p{L}[\p{N}]+(?:\.\w{2,4}\b)|(?:[A-Z]\.){2,}|[\p{L}[\p{N}]+['-][\p{L}\p{N}]+|[\p{L}[\p{N}@]+`, false, true)

// SentenceTokenizer splits text into sentences.
var SentenceTokenizer = tokenize.NewPunktSentenceTokenizer()

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
func TextToTokens(text string, nlp *NLPInfo) []tag.Token {
	// Determine if (and how) we need to do POS tagging.
	if nlp == nil || nlp.Endpoint == "" {
		// Fall back to our internal library (English-only).
		return doTag(textToWords(text, true))
	}
	result, err := pos(text, nlp.Lang, nlp.Endpoint)
	if err != nil {
		panic(err)
	}
	return result.Tokens
}
