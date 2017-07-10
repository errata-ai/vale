package summarize

import (
	"encoding/json"
	"path/filepath"
	"testing"

	"github.com/jdkato/prose/internal/util"
	"github.com/stretchr/testify/assert"
)

type testCase struct {
	Text       string
	Sentences  float64
	Words      float64
	PolyWords  float64
	Characters float64

	AutomatedReadability float64
	ColemanLiau          float64
	FleschKincaid        float64
	GunningFog           float64
	SMOG                 float64

	MeanGrade   float64
	StdDevGrade float64

	DaleChall   float64
	ReadingEase float64
}

func TestSummarize(t *testing.T) {
	tests := make([]testCase, 0)
	cases := util.ReadDataFile(filepath.Join(testdata, "summarize.json"))

	util.CheckError(json.Unmarshal(cases, &tests))
	for _, test := range tests {
		d := NewDocument(test.Text)
		assert.Equal(t, test.Sentences, d.NumSentences)
		assert.Equal(t, test.Words, d.NumWords)
		assert.Equal(t, test.Characters, d.NumCharacters)
	}
}
