package tokenize

import (
	"encoding/json"
	"path/filepath"
	"testing"

	"github.com/jdkato/prose/internal/util"
)

var tokenizer = NewPunktSentenceTokenizer()

func BenchmarkPunkt(b *testing.B) {
	tests := make([]goldenRule, 0)
	cases := util.ReadDataFile(filepath.Join(testdata, "golden_rules_en.json"))

	util.CheckError(json.Unmarshal(cases, &tests))
	for n := 0; n < b.N; n++ {
		for _, test := range tests {
			tokenizer.Tokenize(test.Input)
		}
	}
}

func TestEnglishSmartQuotes(t *testing.T) {
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
		if sent != expected[index] {
			t.Fatalf("Actual: %s\nExpected: %s", sent, expected[index])
		}
	}
}

func TestEnglishCustomAbbrev(t *testing.T) {
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
		if sent != expected[index] {
			t.Fatalf("Actual: %s\nExpected: %s", sent, expected[index])
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
		if sent != expected[index] {
			t.Fatalf("Actual: %s\nExpected: %s", sent, expected[index])
		}
	}
}

func TestEnglishSupervisedAbbrev(t *testing.T) {
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
		if sent != expected[index] {
			t.Fatalf("Actual: %s\nExpected: %s", sent, expected[index])
		}
	}
}

func TestEnglishSemicolon(t *testing.T) {
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
		if sent != expected[index] {
			t.Fatalf("Actual: %s\nExpected: %s", sent, expected[index])
		}
	}
}

func compareSentences(t *testing.T, actualText string, expected []string, test string) bool {
	actual := tokenizer.Tokenize(actualText)

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

// Based on https://github.com/diasks2/pragmatic_segmenter#the-golden-rules.
func TestGoldenRules(t *testing.T) {
	var actualText string
	var expected []string

	test := "1. Simple period to end sentence"
	actualText = "Hello World. My name is Jonas."
	expected = []string{
		"Hello World.",
		" My name is Jonas.",
	}
	compareSentences(t, actualText, expected, test)

	test = "2. Question mark to end sentence"
	actualText = "What is your name? My name is Jonas."
	expected = []string{
		"What is your name?",
		" My name is Jonas.",
	}
	compareSentences(t, actualText, expected, test)

	test = "3. Exclamation point to end sentence"
	actualText = "There it is! I found it."
	expected = []string{
		"There it is!",
		" I found it.",
	}
	compareSentences(t, actualText, expected, test)

	test = "4. One letter upper case abbreviations"
	actualText = "My name is Jonas E. Smith."
	expected = []string{
		"My name is Jonas E. Smith.",
	}
	compareSentences(t, actualText, expected, test)

	test = "5. One letter lower case abbreviations"
	actualText = "Please turn to p. 55."
	expected = []string{
		"Please turn to p. 55.",
	}
	compareSentences(t, actualText, expected, test)

	test = "6. Two letter lower case abbreviations in the middle of a sentence"
	actualText = "Were Jane and co. at the party?"
	expected = []string{
		"Were Jane and co. at the party?",
	}
	compareSentences(t, actualText, expected, test)

	test = "7. Two letter upper case abbreviations in the middle of a sentence"
	actualText = "They closed the deal with Pitt, Briggs & Co. at noon."
	expected = []string{
		"They closed the deal with Pitt, Briggs & Co. at noon.",
	}
	compareSentences(t, actualText, expected, test)

	test = "8. Two letter lower case abbreviations at the end of a sentence"
	actualText = "Let's ask Jane and co. They should know."
	expected = []string{
		"Let's ask Jane and co.",
		" They should know.",
	}
	compareSentences(t, actualText, expected, test)

	test = "9. Two letter upper case abbreviations at the end of a sentence"
	actualText = "They closed the deal with Pitt, Briggs & Co. It closed yesterday."
	expected = []string{
		"They closed the deal with Pitt, Briggs & Co.",
		" It closed yesterday.",
	}
	compareSentences(t, actualText, expected, test)

	test = "10. Two letter (prepositive) abbreviations"
	actualText = "I can see Mt. Fuji from here."
	expected = []string{
		"I can see Mt. Fuji from here.",
	}
	compareSentences(t, actualText, expected, test)

	test = "11. Two letter (prepositive & postpositive) abbreviations"
	actualText = "St. Michael's Church is on 5th st. near the light."
	expected = []string{
		"St. Michael's Church is on 5th st. near the light.",
	}
	compareSentences(t, actualText, expected, test)

	test = "12. Possesive two letter abbreviations"
	actualText = "That is JFK Jr.'s book."
	expected = []string{
		"That is JFK Jr.'s book.",
	}
	compareSentences(t, actualText, expected, test)

	test = "13. Multi-period abbreviations in the middle of a sentence"
	actualText = "I visited the U.S.A. last year."
	expected = []string{
		"I visited the U.S.A. last year.",
	}
	compareSentences(t, actualText, expected, test)

	/* FIXME
	test = "14. Multi-period abbreviations at the end of a sentence"
	actualText = "I live in the E.U. How about you?"
	expected = []string{
		"I live in the E.U.",
		"How about you?",
	}
	compareSentences(t, actualText, expected, test)*/

	/* FIXME
	test = "15. U.S. as sentence boundary"
	actualText = "I live in the U.S. How about you?"
	expected = []string{
		"I live in the U.S.",
		"How about you?",
	}
	compareSentences(t, actualText, expected, test) */

	test = "16. U.S. as non sentence boundary with next word capitalized"
	actualText = "I work for the U.S. Government in Virginia."
	expected = []string{
		"I work for the U.S. Government in Virginia.",
	}
	compareSentences(t, actualText, expected, test)

	test = "17. U.S. as non sentence boundary"
	actualText = "I have lived in the U.S. for 20 years."
	expected = []string{
		"I have lived in the U.S. for 20 years.",
	}
	compareSentences(t, actualText, expected, test)

	/* FIXME
	test = "18. A.M. / P.M. as non sentence boundary and sentence boundary"
	actualText = "At 5 a.m. Mr. Smith went to the bank. He left the bank at 6 P.M. Mr. Smith then went to the store."
	expected = []string{
		"At 5 a.m. Mr. Smith went to the bank.",
		"He left the bank at 6 P.M.",
		"Mr. Smith then went to the store.",
	}
	compareSentences(t, actualText, expected, test) */

	test = "19. Number as non sentence boundary"
	actualText = "She has $100.00 in her bag."
	expected = []string{
		"She has $100.00 in her bag.",
	}
	compareSentences(t, actualText, expected, test)

	test = "20. Number as sentence boundary"
	actualText = "She has $100.00. It is in her bag."
	expected = []string{
		"She has $100.00.",
		" It is in her bag.",
	}
	compareSentences(t, actualText, expected, test)

	test = "21. Parenthetical inside sentence"
	actualText = "He teaches science (He previously worked for 5 years as an engineer.) at the local University."
	expected = []string{
		"He teaches science (He previously worked for 5 years as an engineer.) at the local University.",
	}
	compareSentences(t, actualText, expected, test)

	test = "22. Email addresses"
	actualText = "Her email is Jane.Doe@example.com. I sent her an email."
	expected = []string{
		"Her email is Jane.Doe@example.com.",
		" I sent her an email.",
	}
	compareSentences(t, actualText, expected, test)

	test = "23. Web addresses"
	actualText = "The site is: https://www.example.50.com/new-site/awesome_content.html. Please check it out."
	expected = []string{
		"The site is: https://www.example.50.com/new-site/awesome_content.html.",
		" Please check it out.",
	}
	compareSentences(t, actualText, expected, test)

	test = "24. Single quotations inside sentence"
	actualText = "She turned to him, 'This is great.' she said."
	expected = []string{
		"She turned to him, 'This is great.' she said.",
	}
	compareSentences(t, actualText, expected, test)

	test = "25. Double quotations inside sentence"
	actualText = "She turned to him, \"This is great.\" she said."
	expected = []string{
		"She turned to him, \"This is great.\" she said.",
	}
	compareSentences(t, actualText, expected, test)

	test = "26. Double quotations at the end of a sentence"
	actualText = "She turned to him, \"This is great.\" She held the book out to show him."
	expected = []string{
		"She turned to him, \"This is great.\"",
		" She held the book out to show him.",
	}
	compareSentences(t, actualText, expected, test)

	test = "27. Double punctuation (exclamation point)"
	actualText = "Hello!! Long time no see."
	expected = []string{
		"Hello!!",
		" Long time no see.",
	}
	compareSentences(t, actualText, expected, test)

	test = "28. Double punctuation (question mark)"
	actualText = "Hello?? Who is there?"
	expected = []string{
		"Hello??",
		" Who is there?",
	}
	compareSentences(t, actualText, expected, test)

	test = "29. Double punctuation (exclamation point / question mark)"
	actualText = "Hello!? Is that you?"
	expected = []string{
		"Hello!?",
		" Is that you?",
	}
	compareSentences(t, actualText, expected, test)

	test = "30. Double punctuation (question mark / exclamation point)"
	actualText = "Hello?! Is that you?"
	expected = []string{
		"Hello?!",
		" Is that you?",
	}
	compareSentences(t, actualText, expected, test)

	test = "40. Errant newlines in the middle of sentences (PDF)"
	actualText = "This is a sentence\ncut off in the middle because pdf."
	expected = []string{
		"This is a sentence\ncut off in the middle because pdf.",
	}
	compareSentences(t, actualText, expected, test)

	test = "41. Errant newlines in the middle of sentences"
	actualText = "It was a cold \nnight in the city."
	expected = []string{
		"It was a cold \nnight in the city.",
	}
	compareSentences(t, actualText, expected, test)

	/* FIXME
	test = "43. Geo Coordinates"
	actualText = "You can find it at N°. 1026.253.553. That is where the treasure is."
	expected = []string{
		"You can find it at N°. 1026.253.553.",
		"That is where the treasure is.",
	}
	compareSentences(t, actualText, expected, test) */

	test = "44. Named entities with an exclamation point"
	actualText = "She works at Yahoo! in the accounting department."
	expected = []string{
		"She works at Yahoo! in the accounting department.",
	}
	compareSentences(t, actualText, expected, test)

	test = "45. I as a sentence boundary and I as an abbreviation"
	actualText = "We make a good team, you and I. Did you see Albert I. Jones yesterday?"
	expected = []string{
		"We make a good team, you and I.",
		" Did you see Albert I. Jones yesterday?",
	}
	compareSentences(t, actualText, expected, test)

	test = "46. Ellipsis at end of quotation"
	actualText = "Thoreau argues that by simplifying one’s life, “the laws of the universe will appear less complex. . . .”"
	expected = []string{
		"Thoreau argues that by simplifying one’s life, “the laws of the universe will appear less complex. . . .”",
	}
	compareSentences(t, actualText, expected, test)

	test = "47. Ellipsis with square brackets"
	actualText = "\"Bohr [...] used the analogy of parallel stairways [...]\" (Smith 55)."
	expected = []string{
		"\"Bohr [...] used the analogy of parallel stairways [...]\" (Smith 55).",
	}
	compareSentences(t, actualText, expected, test)

	test = "48. Ellipsis as sentence boundary (standard ellipsis rules)"
	actualText = "If words are left off at the end of a sentence, and that is all that is omitted, indicate the omission with ellipsis marks (preceded and followed by a space) and then indicate the end of the sentence with a period . . . . Next sentence."
	expected = []string{
		"If words are left off at the end of a sentence, and that is all that is omitted, indicate the omission with ellipsis marks (preceded and followed by a space) and then indicate the end of the sentence with a period . . . .",
		" Next sentence.",
	}
	compareSentences(t, actualText, expected, test)

	test = "49. Ellipsis as sentence boundary (non-standard ellipsis rules)"
	actualText = "I never meant that.... She left the store."
	expected = []string{
		"I never meant that....",
		" She left the store.",
	}
	compareSentences(t, actualText, expected, test)

	test = "50. Ellipsis as non sentence boundary"
	actualText = "I wasn’t really ... well, what I mean...see . . . what I'm saying, the thing is . . . I didn’t mean it."
	expected = []string{
		"I wasn’t really ... well, what I mean...see . . . what I'm saying, the thing is . . . I didn’t mean it.",
	}
	compareSentences(t, actualText, expected, test)

	test = "51. 4-dot ellipsis"
	actualText = "One further habit which was somewhat weakened . . . was that of combining words into self-interpreting compounds. . . . The practice was not abandoned. . . ."
	expected = []string{
		"One further habit which was somewhat weakened . . . was that of combining words into self-interpreting compounds. . . .",
		" The practice was not abandoned. . . .",
	}
	compareSentences(t, actualText, expected, test)
}
