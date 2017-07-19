package tokenize

import (
	"encoding/json"
	"fmt"
	"path/filepath"
	"testing"

	"github.com/jdkato/prose/internal/util"
)

type goldenRule struct {
	Name   string
	Input  string
	Output []string
}

func TestPragmaticRulesEn(t *testing.T) { testLang("en", t) }
func TestPragmaticRulesFr(t *testing.T) { testLang("fr", t) }
func TestPragmaticRulesEs(t *testing.T) { testLang("es", t) }

func BenchmarkPragmaticRulesEn(b *testing.B) { benchmarkLang("en", b) }

func benchmarkLang(lang string, b *testing.B) {
	tests := make([]goldenRule, 0)
	f := fmt.Sprintf("golden_rules_%s.json", lang)
	cases := util.ReadDataFile(filepath.Join(testdata, f))

	tok, err := NewPragmaticSegmenter(lang)
	util.CheckError(err)

	util.CheckError(json.Unmarshal(cases, &tests))
	for n := 0; n < b.N; n++ {
		for _, test := range tests {
			tok.Tokenize(test.Input)
		}
	}
}

func testLang(lang string, t *testing.T) {
	tests := make([]goldenRule, 0)
	f := fmt.Sprintf("golden_rules_%s.json", lang)
	cases := util.ReadDataFile(filepath.Join(testdata, f))

	tok, err := NewPragmaticSegmenter(lang)
	util.CheckError(err)

	util.CheckError(json.Unmarshal(cases, &tests))
	for _, test := range tests {
		compare(t, test.Name, test.Input, test.Output, tok)
	}
}

func compare(t *testing.T, test, actualText string, expected []string, tok *PragmaticSegmenter) bool {
	actual := tok.Tokenize(actualText)
	if len(actual) != len(expected) {
		t.Log(test)
		t.Logf("Actual: %v\n", actual)
		t.Errorf("Actual: %d, Expected: %d\n", len(actual), len(expected))
		t.Log("===")
		return false
	}
	for index, sent := range actual {
		if sent != expected[index] {
			t.Log(test)
			t.Errorf("Actual: [%s] Expected: [%s]\n", sent, expected[index])
			t.Log("===")
			return false
		}
	}
	return true
}
