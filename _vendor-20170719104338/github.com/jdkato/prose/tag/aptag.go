// Copyright 2013 Matthew Honnibal
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

package tag

import (
	"regexp"
	"strconv"
	"strings"

	"github.com/jdkato/prose/internal/model"
	"github.com/jdkato/prose/internal/util"
	"github.com/montanaflynn/stats"
	"github.com/shogo82148/go-shuffle"
)

var none = regexp.MustCompile(`^(?:0|\*[\w?]\*|\*\-\d{1,3}|\*[A-Z]+\*\-\d{1,3}|\*)$`)
var keep = regexp.MustCompile(`^\-[A-Z]{3}\-$`)

// PerceptronTagger is a port of Textblob's "fast and accurate" POS tagger.
// See https://github.com/sloria/textblob-aptagger for details.
type PerceptronTagger struct {
	tagMap map[string]string
	Model  *AveragedPerceptron
}

// NewPerceptronTagger creates a new PerceptronTagger and load its
// AveragedPerceptron model.
func NewPerceptronTagger() *PerceptronTagger {
	var pt PerceptronTagger
	pt.Model = NewAveragedPerceptron()
	return &pt
}

// Tag takes a slice of words and returns a slice of tagged tokens.
func (pt *PerceptronTagger) Tag(words []string) []Token {
	var tokens []Token
	var clean []string
	var tag string
	var found bool

	p1, p2 := "-START-", "-START2-"
	context := []string{p1, p2}
	for _, w := range words {
		if w == "" {
			continue
		}
		context = append(context, normalize(w))
		clean = append(clean, w)
	}
	context = append(context, []string{"-END-", "-END2-"}...)
	for i, word := range clean {
		if none.MatchString(word) {
			tag = "-NONE-"
		} else if keep.MatchString(word) {
			tag = word
		} else if tag, found = pt.Model.TagMap[word]; !found {
			tag = pt.Model.predict(featurize(i, word, context, p1, p2))
		}
		tokens = append(tokens, Token{Tag: tag, Text: word})
		p2 = p1
		p1 = tag
	}

	return tokens
}

// Train an Averaged Perceptron model based on sentences.
func (pt *PerceptronTagger) Train(sentences TupleSlice, iterations int) {
	var guess string
	var found bool

	pt.makeTagMap(sentences)
	for i := 0; i < iterations; i++ {
		for _, tuple := range sentences {
			words, tags := tuple[0], tuple[1]
			p1, p2 := "-START-", "-START2-"
			context := []string{p1, p2}
			for _, w := range words {
				if w == "" {
					continue
				}
				context = append(context, normalize(w))
			}
			context = append(context, []string{"-END-", "-END2-"}...)
			for i, word := range words {
				if guess, found = pt.tagMap[word]; !found {
					feats := featurize(i, word, context, p1, p2)
					guess = pt.Model.predict(feats)
					pt.Model.update(tags[i], guess, feats)
				}
				p2 = p1
				p1 = guess
			}
		}
		shuffle.Shuffle(sentences)
	}
	pt.Model.averageWeights()
}

func (pt *PerceptronTagger) makeTagMap(sentences TupleSlice) {
	counts := make(map[string]map[string]int)
	for _, tuple := range sentences {
		words, tags := tuple[0], tuple[1]
		for i, word := range words {
			tag := tags[i]
			if counts[word] == nil {
				counts[word] = make(map[string]int)
			}
			counts[word][tag]++
			pt.Model.addClass(tag)
		}
	}
	for word, tagFreqs := range counts {
		tag, mode := maxValue(tagFreqs)
		n := float64(sumValues(tagFreqs))
		// Don't add rare words to the tag dictionary.
		// Only add quite unambiguous words.
		if n >= 20 && (float64(mode)/n) >= 0.97 {
			pt.tagMap[word] = tag
		}
	}
}

// AveragedPerceptron is a Averaged Perceptron classifier.
type AveragedPerceptron struct {
	Classes   []string
	Instances float64
	Stamps    map[string]float64
	TagMap    map[string]string
	Totals    map[string]float64
	Weights   map[string]map[string]float64
}

// NewAveragedPerceptron creates a new AveragedPerceptron model.
func NewAveragedPerceptron() *AveragedPerceptron {
	var ap AveragedPerceptron

	ap.Totals = make(map[string]float64)
	ap.Stamps = make(map[string]float64)

	dec := model.GetAsset("classes.gob")
	util.CheckError(dec.Decode(&ap.Classes))

	dec = model.GetAsset("tags.gob")
	util.CheckError(dec.Decode(&ap.TagMap))

	dec = model.GetAsset("weights.gob")
	util.CheckError(dec.Decode(&ap.Weights))
	return &ap
}

func (ap *AveragedPerceptron) predict(features map[string]float64) string {
	var weights map[string]float64
	var found bool

	scores := make(map[string]float64)
	for feat, value := range features {
		if weights, found = ap.Weights[feat]; !found || value == 0 {
			continue
		}
		for label, weight := range weights {
			if _, ok := scores[label]; ok {
				scores[label] += value * weight
			} else {
				scores[label] = value * weight
			}
		}
	}
	return max(scores)
}

func (ap *AveragedPerceptron) update(truth, guess string, feats map[string]float64) {
	ap.Instances++
	if truth == guess {
		return
	}
	for f := range feats {
		weights := make(map[string]float64)
		if val, ok := ap.Weights[f]; ok {
			weights = val
		} else {
			ap.Weights[f] = weights
		}
		ap.updateFeat(truth, f, get(truth, weights), 1.0)
		ap.updateFeat(guess, f, get(guess, weights), -1.0)
	}
}

func (ap *AveragedPerceptron) updateFeat(c, f string, v, w float64) {
	key := f + "-" + c
	ap.Totals[key] = (ap.Instances - ap.Stamps[key]) * w
	ap.Stamps[key] = ap.Instances
	ap.Weights[f][c] = w + v
}

func (ap *AveragedPerceptron) addClass(class string) {
	if !util.StringInSlice(class, ap.Classes) {
		ap.Classes = append(ap.Classes, class)
	}
}

func (ap *AveragedPerceptron) averageWeights() {
	for feat, weights := range ap.Weights {
		newWeights := make(map[string]float64)
		for class, weight := range weights {
			key := feat + "-" + class
			total := ap.Totals[key]
			total += (ap.Instances - ap.Stamps[key]) * weight
			averaged, _ := stats.Round(total/ap.Instances, 3)
			if averaged != 0.0 {
				newWeights[class] = averaged
			}
		}
		ap.Weights[feat] = newWeights
	}
}

func max(scores map[string]float64) string {
	var class string
	max := 0.0
	for label, value := range scores {
		if value > max {
			max = value
			class = label
		}
	}
	return class
}

func featurize(i int, w string, ctx []string, p1 string, p2 string) map[string]float64 {
	feats := make(map[string]float64)
	suf := util.Min(len(w), 3)
	i = util.Min(len(ctx)-2, i+2)
	iminus := util.Min(len(ctx[i-1]), 3)
	iplus := util.Min(len(ctx[i+1]), 3)
	feats = add([]string{"bias"}, feats)
	feats = add([]string{"i suffix", w[len(w)-suf:]}, feats)
	feats = add([]string{"i pref1", string(w[0])}, feats)
	feats = add([]string{"i-1 tag", p1}, feats)
	feats = add([]string{"i-2 tag", p2}, feats)
	feats = add([]string{"i tag+i-2 tag", p1, p2}, feats)
	feats = add([]string{"i word", ctx[i]}, feats)
	feats = add([]string{"i-1 tag+i word", p1, ctx[i]}, feats)
	feats = add([]string{"i-1 word", ctx[i-1]}, feats)
	feats = add([]string{"i-1 suffix", ctx[i-1][len(ctx[i-1])-iminus:]}, feats)
	feats = add([]string{"i-2 word", ctx[i-2]}, feats)
	feats = add([]string{"i+1 word", ctx[i+1]}, feats)
	feats = add([]string{"i+1 suffix", ctx[i+1][len(ctx[i+1])-iplus:]}, feats)
	feats = add([]string{"i+2 word", ctx[i+2]}, feats)
	return feats
}

func add(args []string, features map[string]float64) map[string]float64 {
	key := strings.Join(args, " ")
	if _, ok := features[key]; ok {
		features[key]++
	} else {
		features[key] = 1
	}
	return features
}

func normalize(word string) string {
	if word == "" {
		return word
	}
	first := string(word[0])
	if strings.Contains(word, "-") && first != "-" {
		return "!HYPHEN"
	} else if _, err := strconv.Atoi(word); err == nil && len(word) == 4 {
		return "!YEAR"
	} else if _, err := strconv.Atoi(first); err == nil {
		return "!DIGITS"
	}
	return strings.ToLower(word)
}

func sumValues(m map[string]int) int {
	sum := 0
	for _, v := range m {
		sum += v
	}
	return sum
}

func maxValue(m map[string]int) (string, int) {
	maxValue := 0
	key := ""
	for k, v := range m {
		if v >= maxValue {
			maxValue = v
			key = k
		}
	}
	return key, maxValue
}

func get(k string, m map[string]float64) float64 {
	if v, ok := m[k]; ok {
		return v
	}
	return 0.0
}
