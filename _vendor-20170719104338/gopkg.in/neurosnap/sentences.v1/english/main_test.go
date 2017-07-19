package english

import (
	"testing"
)

var tokenizer, _ = NewSentenceTokenizer(nil)

func TestEnglishSmartQuotes(t *testing.T) {
	t.Log("Tokenizer should break sentences that end in smart quotes ...")

	actualText := "Here is a quote, ”a smart one.” Will this break properly?"
	actual := tokenizer.Tokenize(actualText)

	expected := []string{
		"Here is a quote, ”a smart one.”",
		" Will this break properly?",
	}

	if len(actual) != len(expected) {
		t.Fatalf("Actual: %d, Expected: %d", len(actual), len(expected))
	}

	for index, sent := range actual {
		if sent.Text != expected[index] {
			t.Fatalf("Actual: %s\nExpected: %s", sent.Text, expected[index])
		}
	}
}

func TestEnglishCustomAbbrev(t *testing.T) {
	t.Log("Tokenizer should detect custom abbreviations and not always sentence break on them.")

	actualText := "One custom abbreviation is F.B.I.  The abbreviation, F.B.I. should properly break."
	actual := tokenizer.Tokenize(actualText)

	expected := []string{
		"One custom abbreviation is F.B.I.",
		"  The abbreviation, F.B.I. should properly break.",
	}

	if len(actual) != len(expected) {
		t.Fatalf("Actual: %d, Expected: %d", len(actual), len(expected))
	}

	for index, sent := range actual {
		if sent.Text != expected[index] {
			t.Fatalf("Actual: %s\nExpected: %s", sent.Text, expected[index])
		}
	}

	actualText = "An abbreviation near the end of a G.D. sentence.  J.G. Wentworth was cool."
	actual = tokenizer.Tokenize(actualText)

	expected = []string{
		"An abbreviation near the end of a G.D. sentence.",
		"  J.G. Wentworth was cool.",
	}

	if len(actual) != len(expected) {
		t.Fatalf("Actual: %d, Expected: %d", len(actual), len(expected))
	}

	for index, sent := range actual {
		if sent.Text != expected[index] {
			t.Fatalf("Actual: %s\nExpected: %s", sent.Text, expected[index])
		}
	}
}

func TestEnglishSupervisedAbbrev(t *testing.T) {
	t.Log("Tokenizer should detect list of supervised abbreviations.")

	actualText := "I am a Sgt. in the army.  I am a No. 1 student.  The Gov. of Michigan is a dick."
	actual := tokenizer.Tokenize(actualText)

	expected := []string{
		"I am a Sgt. in the army.",
		"  I am a No. 1 student.",
		"  The Gov. of Michigan is a dick.",
	}

	if len(actual) != len(expected) {
		t.Fatalf("Actual: %d, Expected: %d", len(actual), len(expected))
	}

	for index, sent := range actual {
		if sent.Text != expected[index] {
			t.Fatalf("Actual: %s\nExpected: %s", sent.Text, expected[index])
		}
	}
}

func TestEnglishSemicolon(t *testing.T) {
	t.Log("Tokenizer should parse sentences with semicolons")

	actualText := "I am here; you are over there.  Will the tokenizer output two complete sentences?"
	actual := tokenizer.Tokenize(actualText)

	expected := []string{
		"I am here; you are over there.",
		"  Will the tokenizer output two complete sentences?",
	}

	if len(actual) != len(expected) {
		t.Fatalf("Actual: %d, Expected: %d", len(actual), len(expected))
	}

	for index, sent := range actual {
		if sent.Text != expected[index] {
			t.Fatalf("Actual: %s\nExpected: %s", sent.Text, expected[index])
		}
	}
}
