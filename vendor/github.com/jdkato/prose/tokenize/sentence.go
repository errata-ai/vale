package tokenize

import (
	"gopkg.in/neurosnap/sentences.v1"
	"gopkg.in/neurosnap/sentences.v1/english"
)

// PunktSentenceTokenizer is a port if NLTK's Punkt tokenizer.
// See https://github.com/neurosnap/sentences.
type PunktSentenceTokenizer struct {
	tokenizer *sentences.DefaultSentenceTokenizer
}

// NewPunktSentenceTokenizer creates a new PunktSentenceTokenizer and loads
// its English model.
func NewPunktSentenceTokenizer() *PunktSentenceTokenizer {
	var pt PunktSentenceTokenizer
	var err error

	pt.tokenizer, err = english.NewSentenceTokenizer(nil)
	if err != nil {
		panic(err)
	}

	return &pt
}

// Tokenize splits text into sentences.
func (p PunktSentenceTokenizer) Tokenize(text string) []string {
	sents := []string{}
	for _, s := range p.tokenizer.Tokenize(text) {
		sents = append(sents, s.Text)
	}
	return sents
}

// RawTokenize splits text into a slice of sentence tokens.
func (p PunktSentenceTokenizer) RawTokenize(text string) []*sentences.Sentence {
	return p.tokenizer.Tokenize(text)
}
