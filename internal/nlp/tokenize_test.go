package nlp

import (
	"testing"
)

type Word2Tok struct {
	Input  string
	Output []string
}

var cases = []Word2Tok{
	{
		Input:  "Don't copy this sentence.",
		Output: []string{"Don't", "copy", "this", "sentence"},
	},
	{
		Input:  "no 'automatic' before it.",
		Output: []string{"no", "automatic", "before", "it"},
	},
	{
		Input:  "I matter-of-factly said no.",
		Output: []string{"I", "matter-of-factly", "said", "no"},
	},
}

func TestToks(t *testing.T) {
	for _, c := range cases {
		observed := WordTokenizer.Tokenize(c.Input)
		expected := c.Output
		if len(expected) != len(observed) {
			t.Errorf("expected = %v, got = %v", expected, observed)
		}
		for i, s := range expected {
			if observed[i] != s {
				t.Errorf("expected = %v, got = %v", s, observed[i])
			}
		}
	}
}
