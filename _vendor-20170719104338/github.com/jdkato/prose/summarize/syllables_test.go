package summarize

import (
	"bufio"
	"encoding/json"
	"os"
	"path/filepath"
	"testing"

	"github.com/jdkato/prose/internal/util"
	"github.com/jdkato/syllables"
	"github.com/montanaflynn/stats"
	"github.com/stretchr/testify/assert"
)

func TestSyllables(t *testing.T) {
	cases := util.ReadDataFile(filepath.Join(testdata, "syllables.json"))
	tests := make(map[string]int)
	util.CheckError(json.Unmarshal(cases, &tests))

	for word, count := range tests {
		assert.Equal(t, count, Syllables(word), word)
	}

	total := 9462.0
	right := 0.0
	p := filepath.Join(testdata, "1-syllable-words.txt")
	right += testNSyllables(t, p, 1)

	p = filepath.Join(testdata, "2-syllable-words.txt")
	right += testNSyllables(t, p, 2)

	p = filepath.Join(testdata, "3-syllable-words.txt")
	right += testNSyllables(t, p, 3)

	p = filepath.Join(testdata, "4-syllable-words.txt")
	right += testNSyllables(t, p, 4)

	p = filepath.Join(testdata, "5-syllable-words.txt")
	right += testNSyllables(t, p, 5)

	p = filepath.Join(testdata, "6-syllable-words.txt")
	right += testNSyllables(t, p, 6)

	p = filepath.Join(testdata, "7-syllable-words.txt")
	right += testNSyllables(t, p, 7)

	ratio, _ := stats.Round(right/total, 2)
	assert.True(t, ratio >= 0.93, "Less than 93% accurate on NSyllables!")
}

func testNSyllables(t *testing.T, fpath string, n int) float64 {
	file, err := os.Open(fpath)
	util.CheckError(err)

	right := 0.0
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		word := scanner.Text()
		if n == Syllables(word) {
			right++
		}
	}

	util.CheckError(scanner.Err())
	util.CheckError(file.Close())

	return right
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
