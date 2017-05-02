// Copyright 2013 Matthew Honnibal

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

package tag

import (
	"encoding/json"
	"regexp"
	"strconv"
	"strings"

	"github.com/jdkato/prose/internal/model"
	"github.com/jdkato/prose/internal/util"
)

var none = regexp.MustCompile(`^(?:0|\*[\w?]\*|\*\-\d{1,3}|\*[A-Z]+\*\-\d{1,3}|\*)$`)
var keep = regexp.MustCompile(`^\-[A-Z]{3}\-$`)

// PerceptronTagger is a port of Textblob's "fast and accurate" POS tagger.
// See https://github.com/sloria/textblob-aptagger for details.
type PerceptronTagger struct {
	model *averagedPerceptron
}

// NewPerceptronTagger creates a new PerceptronTagger and load its
// averagedPerceptron model.
func NewPerceptronTagger() *PerceptronTagger {
	var pt PerceptronTagger
	pt.model = newAveragedPerceptron()
	return &pt
}

// Tag takes a slice of words and returns a slice of tagged tokens.
func (pt PerceptronTagger) Tag(words []string) []Token {
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
		} else if tag, found = pt.model.tagMap[word]; !found {
			tag = pt.model.predict(featurize(i, word, context, p1, p2))
		}
		tokens = append(tokens, Token{Tag: tag, Text: word})
		p2 = p1
		p1 = tag
	}

	return tokens
}

type averagedPerceptron struct {
	classes   []string
	instances int
	stamps    map[string]int
	tagMap    map[string]string
	totals    map[string]int
	weights   map[string]map[string]float64
}

func newAveragedPerceptron() *averagedPerceptron {
	var ap averagedPerceptron
	var err error

	ap.totals = make(map[string]int)
	ap.stamps = make(map[string]int)

	err = json.Unmarshal(model.GetAsset("classes.json"), &ap.classes)
	util.CheckError(err)
	err = json.Unmarshal(model.GetAsset("tags.json"), &ap.tagMap)
	util.CheckError(err)
	err = json.Unmarshal(model.GetAsset("weights.json"), &ap.weights)
	util.CheckError(err)

	return &ap
}

func (ap averagedPerceptron) predict(features map[string]float64) string {
	var weights map[string]float64
	var found bool

	scores := make(map[string]float64)
	for feat, value := range features {
		if weights, found = ap.weights[feat]; !found || value == 0 {
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
