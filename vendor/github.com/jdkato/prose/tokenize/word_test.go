package tokenize

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

var sentToWords = map[string][]string{
	"They'll save and invest more.":                                 []string{"They", "'ll", "save", "and", "invest", "more", "."},
	"hi, my name can't hello,":                                      []string{"hi", ",", "my", "name", "ca", "n't", "hello", ","},
	"How's it going?":                                               []string{"How", "'s", "it", "going", "?"},
	"abbreviations like M.D. and initials containing periods, they": []string{"abbreviations", "like", "M.D.", "and", "initials", "containing", "periods", ",", "they"},
}

func TestTreebankWordTokenizer(t *testing.T) {
	tokenizer := new(TreebankWordTokenizer)
	for sent, words := range sentToWords {
		assert.Equal(t, words, tokenizer.Tokenize(sent))
	}
}
