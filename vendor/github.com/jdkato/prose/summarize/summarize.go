/*
Package summarize implements utilities for computing readability scores, usage statistics, and TL;DR summaries of text.
*/
package summarize

import (
	"sort"
	"strings"
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
	Text      string // the actual text
	Length    int    // the number of words
	Words     []Word // the words in this sentence
	Paragraph int
}

// A RankedParagraph is a paragraph ranked by its number of keywords.
type RankedParagraph struct {
	Sentences []Sentence
	Position  int // the zero-based position within a Document
	Rank      int
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
type Document struct {
	Content         string         // Actual text
	NumCharacters   float64        // Number of Characters
	NumComplexWords float64        // PolysylWords without common suffixes
	NumParagraphs   float64        // Number of paragraphs
	NumPolysylWords float64        // Number of words with > 2 syllables
	NumSentences    float64        // Number of sentences
	NumSyllables    float64        // Number of syllables
	NumWords        float64        // Number of words
	NumLongWords    float64        // Number of long words
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
	LIX                  float64

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
	for i, paragraph := range strings.Split(d.Content, "\n\n") {
		for _, s := range d.SentenceTokenizer.Tokenize(paragraph) {
			wordCount := d.NumWords
			d.NumSentences++
			words := []Word{}
			for _, word := range d.WordTokenizer.Tokenize(s) {
				word = strings.TrimSpace(word)
				if len(word) == 0 {
					continue
				}
				d.NumCharacters += countChars(word)
				if _, found := d.WordFrequency[word]; found {
					d.WordFrequency[word]++
				} else {
					d.WordFrequency[word] = 1
				}
				if len(word) > 6 {
					d.NumLongWords++
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
				Text:      strings.TrimSpace(s),
				Length:    int(d.NumWords - wordCount),
				Words:     words,
				Paragraph: i})
		}
		d.NumParagraphs++
	}
}

// Assess returns an Assessment for the Document d.
func (d *Document) Assess() *Assessment {
	a := Assessment{
		FleschKincaid: d.FleschKincaid(), ReadingEase: d.FleschReadingEase(),
		GunningFog: d.GunningFog(), SMOG: d.SMOG(), DaleChall: d.DaleChall(),
		AutomatedReadability: d.AutomatedReadability(), ColemanLiau: d.ColemanLiau(),
		LIX: d.LIX()}

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

// Summary returns a Document's n highest ranked paragraphs according to
// keyword frequency.
func (d *Document) Summary(n int) []RankedParagraph {
	rankings := []RankedParagraph{}
	scores := d.Keywords()
	for i := 0; i < int(d.NumParagraphs); i++ {
		p := RankedParagraph{Position: i}
		rank := 0
		size := 0
		for _, s := range d.Sentences {
			if s.Paragraph == i {
				size += s.Length
				for _, w := range s.Words {
					if score, found := scores[w.Text]; found {
						rank += score
					}
				}
				p.Sentences = append(p.Sentences, s)
			}
		}
		// Favor longer paragraphs, as they tend to be more informational.
		p.Rank = (rank * size)
		rankings = append(rankings, p)
	}

	// Sort by raking:
	sort.Sort(byRank(rankings))

	// Take the top-n paragraphs:
	size := len(rankings)
	if size > n {
		rankings = rankings[size-n:]
	}

	// Sort by chronological position:
	sort.Sort(byIndex(rankings))
	return rankings
}

type byRank []RankedParagraph

func (s byRank) Len() int           { return len(s) }
func (s byRank) Swap(i, j int)      { s[i], s[j] = s[j], s[i] }
func (s byRank) Less(i, j int) bool { return s[i].Rank < s[j].Rank }

type byIndex []RankedParagraph

func (s byIndex) Len() int           { return len(s) }
func (s byIndex) Swap(i, j int)      { s[i], s[j] = s[j], s[i] }
func (s byIndex) Less(i, j int) bool { return s[i].Position < s[j].Position }

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
