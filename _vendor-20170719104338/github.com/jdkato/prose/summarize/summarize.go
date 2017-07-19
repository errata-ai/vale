/*
Package summarize implements functions for analyzing readability and usage statistics of text.
*/
package summarize

import (
	"unicode"

	"github.com/jdkato/prose/internal/util"
	"github.com/jdkato/prose/tokenize"
	"github.com/montanaflynn/stats"
)

// A Word represents a single word in a Document.
type Word struct {
	Text      string // the actual text
	Syllables int    // the number of syllables
}

// A Sentence represents a single sentence in a Document.
type Sentence struct {
	Text   string // the actual text
	Length int    // the number of words
	Words  []Word // the words in this sentence
}

// A Document represents a collection of text to be analyzed.
//
// A Document's calculations depend on its word and sentence tokenizers. You
// can use the defaults by invoking NewDocument, choose another implemention
// from the tokenize package, or use your own (as long as it implements the
// ProseTokenizer interface). For example,
//
//    d := Document{Content: ..., WordTokenizer: ..., SentenceTokenizer: ...}
//    d.Initialize()
//
// TODO: There should be a way to efficiently add or remove text from a the
// content of a Document (e.g., we should be able to build it incrementally).
// Perhaps we should look into using a rope as our underlying data structure?
type Document struct {
	Content         string         // Actual text
	NumCharacters   float64        // Number of Characters
	NumComplexWords float64        // PolysylWords without common suffixes
	NumPolysylWords float64        // Number of words with > 2 syllables
	NumSentences    float64        // Number of sentences
	NumSyllables    float64        // Number of syllables
	NumWords        float64        // Number of words
	Sentences       []Sentence     // the Document's sentences
	WordFrequency   map[string]int // [word]frequency

	SentenceTokenizer tokenize.ProseTokenizer
	WordTokenizer     tokenize.ProseTokenizer
}

// An Assessment provides comprehensive access to a Document's metrics.
type Assessment struct {
	// assessments returning an estimated grade level
	AutomatedReadability float64
	ColemanLiau          float64
	FleschKincaid        float64
	GunningFog           float64
	SMOG                 float64

	// mean & standard deviation of the above estimated grade levels
	MeanGradeLevel   float64
	StdDevGradeLevel float64

	// assessments returning non-grade numerical scores
	DaleChall   float64
	ReadingEase float64
}

// NewDocument is a Document constructor that takes a string as an argument. It
// then calculates the data necessary for computing readability and usage
// statistics.
//
// This is a convenience wrapper around the Document initialization process
// that defaults to using a WordBoundaryTokenizer and a PunktSentenceTokenizer
// as its word and sentence tokenizers, respectively.
func NewDocument(text string) *Document {
	wTok := tokenize.NewWordBoundaryTokenizer()
	sTok := tokenize.NewPunktSentenceTokenizer()
	doc := Document{Content: text, WordTokenizer: wTok, SentenceTokenizer: sTok}
	doc.Initialize()
	return &doc
}

// Initialize calculates the data necessary for computing readability and usage
// statistics.
func (d *Document) Initialize() {
	d.WordFrequency = make(map[string]int)
	for _, s := range d.SentenceTokenizer.Tokenize(d.Content) {
		wordCount := d.NumWords
		d.NumSentences++
		words := []Word{}
		for _, word := range d.WordTokenizer.Tokenize(s) {
			d.NumCharacters += countChars(word)
			if _, found := d.WordFrequency[word]; found {
				d.WordFrequency[word]++
			} else {
				d.WordFrequency[word] = 1
			}
			syllables := Syllables(word)
			words = append(words, Word{Text: word, Syllables: syllables})
			d.NumSyllables += float64(syllables)
			if syllables > 2 {
				d.NumPolysylWords++
			}
			if isComplex(word, syllables) {
				d.NumComplexWords++
			}
			d.NumWords++
		}
		d.Sentences = append(d.Sentences, Sentence{
			Text: s, Length: int(d.NumWords - wordCount), Words: words})
	}
}

// Assess returns an Assessment for the Document d.
func (d *Document) Assess() *Assessment {
	a := Assessment{
		FleschKincaid: d.FleschKincaid(), ReadingEase: d.FleschReadingEase(),
		GunningFog: d.GunningFog(), SMOG: d.SMOG(), DaleChall: d.DaleChall(),
		AutomatedReadability: d.AutomatedReadability(), ColemanLiau: d.ColemanLiau()}

	gradeScores := []float64{
		a.FleschKincaid, a.AutomatedReadability, a.GunningFog, a.SMOG,
		a.ColemanLiau}

	mean, merr := stats.Mean(gradeScores)
	stdDev, serr := stats.StandardDeviation(gradeScores)
	if merr != nil || serr != nil {
		a.MeanGradeLevel = 0.0
		a.StdDevGradeLevel = 0.0
	} else {
		a.MeanGradeLevel = mean
		a.StdDevGradeLevel = stdDev
	}

	return &a
}

func isComplex(word string, syllables int) bool {
	if util.HasAnySuffix(word, []string{"es", "ed", "ing"}) {
		syllables--
	}
	return syllables > 2
}

func countChars(word string) float64 {
	count := 0
	for _, c := range word {
		if unicode.IsLetter(c) || unicode.IsNumber(c) {
			count++
		}
	}
	return float64(count)
}
