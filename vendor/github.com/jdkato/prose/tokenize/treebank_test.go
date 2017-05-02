package tokenize

import (
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
)

var testdata = filepath.Join("..", "testdata")

func TestTreebankWordTokenizer(t *testing.T) {
	input, output := getWordData("treebank_words.json")
	word := NewTreebankWordTokenizer()
	for i, s := range input {
		assert.Equal(t, output[i], word.Tokenize(s))
	}
}

func BenchmarkTreebankWordTokenizer(b *testing.B) {
	word := NewTreebankWordTokenizer()
	for n := 0; n < b.N; n++ {
		for _, s := range getWordBenchData() {
			word.Tokenize(s)
		}
	}
}
