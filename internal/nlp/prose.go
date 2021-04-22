package nlp

import (
	"github.com/jdkato/prose/tokenize"
)

// WordTokenizer splits text into words.
var WordTokenizer = tokenize.NewRegexpTokenizer(
	`[\p{L}[\p{N}]+(?:\.\w{2,4}\b)|(?:[A-Z]\.){2,}|[\p{L}[\p{N}]+['-][\p{L}\p{N}]+|[\p{L}[\p{N}@]+`, false, true)

// SentenceTokenizer splits text into sentences.
var SentenceTokenizer = tokenize.NewPunktSentenceTokenizer()
