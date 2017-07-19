package sentences

import (
	"reflect"
	"testing"
)

func TestWordTokenizer(t *testing.T) {
	t.Log("Starting word tokenizer suite of tests ...")

	punctStrings := NewPunctStrings()
	wordTokenizer := NewWordTokenizer(punctStrings)

	tokenizeTest(t, wordTokenizer, "This is a test sentence", []string{
		"This",
		"is",
		"a",
		"test",
		"sentence",
	})

	tokenizeTestOnlyPunct(t, wordTokenizer, "This is a test sentence?", []string{
		"sentence?",
	})
}

func tokenizeTest(t *testing.T, wordTokenizer WordTokenizer, actualText string, expected []string) {
	actualTokens := wordTokenizer.Tokenize(actualText, false)
	compareTokens(t, actualTokens, expected)
}

func tokenizeTestOnlyPunct(t *testing.T, wordTokenizer WordTokenizer, actualText string, expected []string) {
	actualTokens := wordTokenizer.Tokenize(actualText, true)
	compareTokens(t, actualTokens, expected)
}

func compareTokens(t *testing.T, actualTokens []*Token, expected []string) {
	actual := make([]string, 0, len(actualTokens))
	for _, token := range actualTokens {
		actual = append(actual, token.Tok)
	}

	if !reflect.DeepEqual(actual, expected) {
		t.Logf("%v", actualTokens)
		t.Logf("Actual: %#v", actual)
		t.Logf("Expected: %#v", expected)
		t.Fatalf("Actual tokens do not match expected tokens")
	}
}
