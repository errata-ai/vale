package tag

import (
	"fmt"
	"math/rand"
	"testing"
	"time"

	"github.com/jdkato/prose/internal/util"
	"github.com/stretchr/testify/assert"
)

var wsj = "Pierre|NNP Vinken|NNP ,|, 61|CD years|NNS old|JJ ,|, will|MD " +
	"join|VB the|DT board|NN as|IN a|DT nonexecutive|JJ director|NN " +
	"Nov.|NNP 29|CD .|.\nMr.|NNP Vinken|NNP is|VBZ chairman|NN of|IN " +
	"Elsevier|NNP N.V.|NNP ,|, the|DT Dutch|NNP publishing|VBG " +
	"group|NN .|. Rudolph|NNP Agnew|NNP ,|, 55|CD years|NNS old|JJ " +
	"and|CC former|JJ chairman|NN of|IN Consolidated|NNP Gold|NNP " +
	"Fields|NNP PLC|NNP ,|, was|VBD named|VBN a|DT nonexecutive|JJ " +
	"director|NN of|IN this|DT British|JJ industrial|JJ conglomerate|NN " +
	".|.\nA|DT form|NN of|IN asbestos|NN once|RB used|VBN to|TO make|VB " +
	"Kent|NNP cigarette|NN filters|NNS has|VBZ caused|VBN a|DT high|JJ " +
	"percentage|NN of|IN cancer|NN deaths|NNS among|IN a|DT group|NN " +
	"of|IN workers|NNS exposed|VBN to|TO it|PRP more|RBR than|IN " +
	"30|CD years|NNS ago|IN ,|, researchers|NNS reported|VBD .|."

func ExampleReadTagged() {
	tagged := "Pierre|NNP Vinken|NNP ,|, 61|CD years|NNS"
	fmt.Println(ReadTagged(tagged, "|"))
	// Output: [[[Pierre Vinken , 61 years] [NNP NNP , CD NNS]]]
}

func TestTrain(t *testing.T) {
	tagger := NewPerceptronTagger()
	sentences := ReadTagged(wsj, "|")
	iter := random(5, 20)
	tagger.Train(sentences, iter)

	tagSet := []string{}
	nrWords := 0
	for _, tuple := range sentences {
		nrWords += len(tuple[0])
		for _, tag := range tuple[1] {
			if !util.StringInSlice(tag, tagSet) {
				tagSet = append(tagSet, tag)
			}
		}
	}

	assert.Equal(t, nrWords*iter, int(tagger.model.instances))
	for _, tag := range tagSet {
		assert.True(t, util.StringInSlice(tag, tagger.model.classes))
	}
}

func random(min, max int) int {
	rand.Seed(time.Now().Unix())
	return rand.Intn(max-min) + min
}
