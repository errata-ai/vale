package tokenize

// WordTokenizer is the interface implemented by an object that takes a string
// and returns a slice of strings representing words.
//
// Implementations include:
// * TreebankWordTokenizer
type WordTokenizer interface {
	Tokenize(text string) []string
}

// SentenceTokenizer is the interface implemented by an object that takes a
// string and returns a slice of representing sentences.
//
// Implementations include:
// * PunktSentenceTokenizer
type SentenceTokenizer interface {
	Tokenize(text string) []string
}

// IsPunct determines if a character is a punctuation symbol.
func IsPunct(c byte) bool {
	for _, r := range []byte("!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~") {
		if c == r {
			return true
		}
	}
	return false
}

// IsSpace determines if a character is a whitespace character.
func IsSpace(c byte) bool {
	for _, r := range []byte("\t\n\r\f\v") {
		if c == r {
			return true
		}
	}
	return false
}

// IsLetter determines if a character is letter.
func IsLetter(c byte) bool {
	return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')
}

// IsAlnum determines if a character is a letter or a digit.
func IsAlnum(c byte) bool {
	return (c >= '0' && c <= '9') || IsLetter(c)
}
