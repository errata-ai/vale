package summarize

import (
	"encoding/json"
	"fmt"
	"path/filepath"
	"testing"

	"github.com/jdkato/prose/internal/util"
	"github.com/stretchr/testify/assert"
)

var testdata = filepath.Join("..", "testdata")

func check(expected, observed float64) bool {
	return fmt.Sprintf("%0.2f", expected) == fmt.Sprintf("%0.2f", observed)
}

func TestReadability(t *testing.T) {
	tests := make([]testCase, 0)
	cases := util.ReadDataFile(filepath.Join(testdata, "summarize.json"))

	util.CheckError(json.Unmarshal(cases, &tests))
	for _, test := range tests {
		d := NewDocument(test.Text)
		a := d.Assess()

		assert.True(t, check(test.AutomatedReadability, a.AutomatedReadability))
		assert.True(t, check(test.ColemanLiau, a.ColemanLiau))
		assert.True(t, check(test.FleschKincaid, a.FleschKincaid))
		assert.True(t, check(test.GunningFog, a.GunningFog))
		assert.True(t, check(test.SMOG, a.SMOG))
		assert.True(t, check(test.MeanGrade, a.MeanGradeLevel))
		assert.True(t, check(test.StdDevGrade, a.StdDevGradeLevel))
		assert.True(t, check(test.DaleChall, a.DaleChall))
		assert.True(t, check(test.ReadingEase, a.ReadingEase))
	}
}

func BenchmarkReadability(b *testing.B) {
	in := util.ReadDataFile(filepath.Join(testdata, "sherlock.txt"))

	d := NewDocument(string(in))
	for n := 0; n < b.N; n++ {
		d.Assess()
	}
}
