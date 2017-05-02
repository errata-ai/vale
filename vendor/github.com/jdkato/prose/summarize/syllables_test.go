package summarize

import (
	"bufio"
	"encoding/json"
	"os"
	"path/filepath"
	"testing"

	"github.com/jdkato/prose/internal/util"
	"github.com/jdkato/syllables"
	"github.com/stretchr/testify/assert"
)

func TestSyllables(t *testing.T) {
	cases := util.ReadDataFile(filepath.Join(testdata, "syllables.json"))
	tests := make(map[string]int)
	util.CheckError(json.Unmarshal(cases, &tests))

	for word, count := range tests {
		assert.Equal(t, count, Syllables(word), word)
	}

	// p := filepath.Join(testdata, "1-syllable-words.txt")
	// testNSyllables(t, p, 1)
}

func testNSyllables(t *testing.T, fpath string, n int) {
	file, err := os.Open(fpath)
	util.CheckError(err)

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		word := scanner.Text()
		assert.Equal(t, n, Syllables(word), word)
	}

	util.CheckError(scanner.Err())
	util.CheckError(file.Close())
}

func BenchmarkSyllables(b *testing.B) {
	cases := util.ReadDataFile(filepath.Join(testdata, "syllables.json"))
	tests := make(map[string]int)
	util.CheckError(json.Unmarshal(cases, &tests))

	for n := 0; n < b.N; n++ {
		for word := range tests {
			Syllables(word)
		}
	}
}

func BenchmarkSyllablesIn(b *testing.B) {
	cases := util.ReadDataFile(filepath.Join(testdata, "syllables.json"))
	tests := make(map[string]int)
	util.CheckError(json.Unmarshal(cases, &tests))

	for n := 0; n < b.N; n++ {
		for word := range tests {
			syllables.In(word)
		}
	}
}
