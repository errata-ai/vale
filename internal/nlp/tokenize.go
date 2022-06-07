package nlp

import (
	"regexp"
	"strings"
	"unicode"
	"unicode/utf8"
)

type TokenTester func(string) bool

type Tokenizer interface {
	Tokenize(string) []string
}

// iterTokenizer splits a sentence into words.
type iterTokenizer struct {
	specialRE      *regexp.Regexp
	sanitizer      *strings.Replacer
	contractions   []string
	splitCases     []string
	suffixes       []string
	prefixes       []string
	emoticons      map[string]int
	isUnsplittable TokenTester
}

type TokenizerOptFunc func(*iterTokenizer)

// UsingIsUnsplittable gives a function that tests whether a token is splittable or not.
func UsingIsUnsplittable(x TokenTester) TokenizerOptFunc {
	return func(tokenizer *iterTokenizer) {
		tokenizer.isUnsplittable = x
	}
}

// UsingSpecialRE sets the provided special regex for unsplittable tokens.
func UsingSpecialRE(x *regexp.Regexp) TokenizerOptFunc {
	return func(tokenizer *iterTokenizer) {
		tokenizer.specialRE = x
	}
}

// UsingSanitizer sets the provided sanitizer.
func UsingSanitizer(x *strings.Replacer) TokenizerOptFunc {
	return func(tokenizer *iterTokenizer) {
		tokenizer.sanitizer = x
	}
}

// UsingSuffixes sets the provided suffixes.
func UsingSuffixes(x []string) TokenizerOptFunc {
	return func(tokenizer *iterTokenizer) {
		tokenizer.suffixes = x
	}
}

// UsingPrefixes sets the provided prefixes.
func UsingPrefixes(x []string) TokenizerOptFunc {
	return func(tokenizer *iterTokenizer) {
		tokenizer.prefixes = x
	}
}

// UsingEmoticons sets the provided map of emoticons.
func UsingEmoticons(x map[string]int) TokenizerOptFunc {
	return func(tokenizer *iterTokenizer) {
		tokenizer.emoticons = x
	}
}

// UsingContractions sets the provided contractions.
func UsingContractions(x []string) TokenizerOptFunc {
	return func(tokenizer *iterTokenizer) {
		tokenizer.contractions = x
	}
}

// UsingSplitCases sets the provided splitCases.
func UsingSplitCases(x []string) TokenizerOptFunc {
	return func(tokenizer *iterTokenizer) {
		tokenizer.splitCases = x
	}
}

// NewIterTokenizer creates a new iterTokenizer.
func NewIterTokenizer(opts ...TokenizerOptFunc) *iterTokenizer {
	tok := new(iterTokenizer)

	// Set default parameters
	tok.emoticons = emoticons
	tok.isUnsplittable = func(_ string) bool { return false }
	tok.prefixes = prefixes
	tok.sanitizer = sanitizer
	tok.specialRE = internalRE
	tok.suffixes = suffixes

	// Apply options if provided
	for _, applyOpt := range opts {
		applyOpt(tok)
	}

	return tok
}

func addToken(s string, toks []string) []string {
	if !allNonLetter(s) {
		toks = append(toks, s)
	}
	return toks
}

func (t *iterTokenizer) isSpecial(token string) bool {
	_, found := t.emoticons[token]
	return found || t.specialRE.MatchString(token) || t.isUnsplittable(token)
}

func (t *iterTokenizer) doSplit(token string) []string {
	var tokens []string

	last := 0
	for token != "" && utf8.RuneCountInString(token) != last {
		if t.isSpecial(token) {
			// We've found a special case (e.g., an emoticon) -- so, we add it as a token without
			// any further processing.
			tokens = addToken(token, tokens)
			break
		}
		last = utf8.RuneCountInString(token)
		lower := strings.ToLower(token)
		if hasAnyPrefix(token, t.prefixes) {
			// Remove prefixes -- e.g., $100 -> [$, 100].
			token = token[1:]
		} else if idx := hasAnyIndex(lower, t.splitCases); idx > -1 {
			// Handle "they'll", "I'll", "Don't", "won't", amount($).
			//
			// they'll -> [they, 'll].
			// don't -> [do, n't].
			// amount($) -> [amount, (, $, )].
			tokens = addToken(token[:idx], tokens)
			token = token[idx:]
		} else if hasAnySuffix(token, t.suffixes) {
			// Remove suffixes -- e.g., Well) -> [Well, )].
			token = token[:len(token)-1]
		} else {
			tokens = addToken(token, tokens)
		}
	}

	return tokens
}

// Tokenize splits a sentence into a slice of words.
func (t *iterTokenizer) Tokenize(text string) []string {
	var tokens []string

	clean, white := t.sanitizer.Replace(text), false
	length := len(clean)

	start, index := 0, 0
	cache := map[string][]string{}
	for index <= length {
		uc, size := utf8.DecodeRuneInString(clean[index:])
		if size == 0 {
			break
		} else if index == 0 {
			white = unicode.IsSpace(uc)
		}
		if unicode.IsSpace(uc) != white {
			if start < index {
				span := clean[start:index]
				if toks, found := cache[span]; found {
					tokens = append(tokens, toks...)
				} else {
					toks := t.doSplit(span)
					cache[span] = toks
					tokens = append(tokens, toks...)
				}
			}
			if uc == ' ' {
				start = index + 1
			} else {
				start = index
			}
			white = !white
		}
		index += size
	}

	if start < index {
		tokens = append(tokens, t.doSplit(clean[start:index])...)
	}

	return tokens
}
