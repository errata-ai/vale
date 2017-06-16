package summarize

import "github.com/montanaflynn/stats"

// WordDensity returns a map of each word and its density.
func (d *Document) WordDensity() map[string]float64 {
	density := make(map[string]float64)
	for word, freq := range d.WordFrequency {
		val, _ := stats.Round(float64(freq)/d.NumWords, 3)
		density[word] = val
	}
	return density
}

// MeanWordLength returns the mean number of characters per word.
func (d *Document) MeanWordLength() float64 {
	val, _ := stats.Round(d.NumCharacters/d.NumWords, 3)
	return val
}
