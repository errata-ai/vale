package transform

import (
	"encoding/json"
	"path/filepath"
	"testing"

	"github.com/jdkato/prose/internal/util"
	"github.com/stretchr/testify/assert"
)

var testdata = filepath.Join("..", "testdata")

type testCase struct {
	Input  string
	Expect string
}

func TestTitle(t *testing.T) {
	tests := make([]testCase, 0)
	cases := util.ReadDataFile(filepath.Join(testdata, "title.json"))

	util.CheckError(json.Unmarshal(cases, &tests))
	for _, test := range tests {
		assert.Equal(t, test.Expect, Title(test.Input))
	}
}

func BenchmarkTitle(b *testing.B) {
	tests := make([]testCase, 0)
	cases := util.ReadDataFile(filepath.Join(testdata, "title.json"))

	util.CheckError(json.Unmarshal(cases, &tests))
	for n := 0; n < b.N; n++ {
		for _, test := range tests {
			_ = Title(test.Input)
		}
	}
}
