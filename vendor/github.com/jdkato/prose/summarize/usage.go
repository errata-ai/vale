package summarize

import (
	"strings"

	"github.com/montanaflynn/stats"
)

// WordDensity returns a map of each word and its density.
func (d *Document) WordDensity() map[string]float64 {
	density := make(map[string]float64)
	for word, freq := range d.WordFrequency {
		val, _ := stats.Round(float64(freq)/d.NumWords, 3)
		density[word] = val
	}
	return density
}

// Keywords returns a Document's words in the form
//
//    map[word]count
//
// omitting stop words and normalizing case.
func (d *Document) Keywords() map[string]int {
	scores := map[string]int{}
	for word, freq := range d.WordFrequency {
		normalized := strings.ToLower(word)
		if _, found := stopWords[normalized]; found {
			continue
		}
		if _, found := scores[normalized]; found {
			scores[normalized] += freq
		} else {
			scores[normalized] = freq
		}
	}
	return scores
}

// MeanWordLength returns the mean number of characters per word.
func (d *Document) MeanWordLength() float64 {
	val, _ := stats.Round(d.NumCharacters/d.NumWords, 3)
	return val
}
