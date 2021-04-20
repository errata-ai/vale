package nlp

import (
	"strings"

	"github.com/jdkato/prose/tokenize"
)

// WordTokenizer splits text into words.
var WordTokenizer = tokenize.NewRegexpTokenizer(
	`[\p{L}[\p{N}]+(?:\.\w{2,4}\b)|(?:[A-Z]\.){2,}|[\p{L}[\p{N}]+['-][\p{L}\p{N}]+|[\p{L}[\p{N}@]+`, false, true)

// SentenceTokenizer splits text into sentences.
var SentenceTokenizer = tokenize.NewPunktSentenceTokenizer()

func prose(nlp *NLPInfo, blk *Block) ([]Block, error) {
	blks := []Block{}

	ctx := blk.Context
	idx := blk.Line
	ext := nlp.Scope

	if nlp.Splitting || nlp.Segmentation {
		for _, p := range strings.SplitAfter(blk.Text, "\n\n") {
			blks = append(blks, NewLinedBlock(ctx, p, "paragraph"+ext, idx, false))
			if nlp.Segmentation {
				for _, s := range SentenceTokenizer.Tokenize(p) {
					blks = append(blks, NewLinedBlock(ctx, s, "sentence"+ext, idx, false))
				}
			}
		}
	}
	blks = append(blks, NewLinedBlock(ctx, blk.Text, "text"+ext, idx, false))

	return blks, nil
}
