package tokenize

import (
	"encoding/json"
	"path/filepath"
	"testing"

	"github.com/jdkato/prose/internal/util"
	"github.com/stretchr/testify/assert"
)

func getWordData(file string) ([]string, [][]string) {
	in := util.ReadDataFile(filepath.Join(testdata, "treebank_sents.json"))
	out := util.ReadDataFile(filepath.Join(testdata, file))

	input := []string{}
	output := [][]string{}

	util.CheckError(json.Unmarshal(in, &input))
	util.CheckError(json.Unmarshal(out, &output))

	return input, output
}

func getWordBenchData() []string {
	in := util.ReadDataFile(filepath.Join(testdata, "treebank_sents.json"))
	input := []string{}
	util.CheckError(json.Unmarshal(in, &input))
	return input
}

func TestWordPunctTokenizer(t *testing.T) {
	input, output := getWordData("word_punct.json")
	wordTokenizer := NewWordPunctTokenizer()
	for i, s := range input {
		assert.Equal(t, output[i], wordTokenizer.Tokenize(s))
	}
}

func TestNewRegexpTokenizer(t *testing.T) {
	input, _ := getWordData("word_punct.json")
	expected := NewWordPunctTokenizer()
	observed := NewRegexpTokenizer(`\w+|[^\w\s]+`, false, false)
	for _, s := range input {
		assert.Equal(t, expected.Tokenize(s), observed.Tokenize(s))
	}
}

func BenchmarkWordPunctTokenizer(b *testing.B) {
	word := NewWordPunctTokenizer()
	for n := 0; n < b.N; n++ {
		for _, s := range getWordBenchData() {
			word.Tokenize(s)
		}
	}
}
