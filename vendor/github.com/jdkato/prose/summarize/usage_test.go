package summarize

import (
	"encoding/json"
	"fmt"
	"path/filepath"
	"testing"

	"github.com/jdkato/prose/internal/util"
)

func TestUsage(t *testing.T) {
	tests := make([]testCase, 0)
	cases := util.ReadDataFile(filepath.Join(testdata, "summarize.json"))

	util.CheckError(json.Unmarshal(cases, &tests))
	for i, test := range tests {
		d := NewDocument(test.Text)
		fmt.Printf("Case: %d\n", i)
		// fmt.Printf("Density: %v\n", d.WordDensity())
		fmt.Printf("Length: %v\n", d.MeanWordLength())
	}
}
