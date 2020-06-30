package prose

import (
	"regexp"
	"strings"
	"unicode"
	"unicode/utf8"
)

// iterTokenizer splits a sentence into words.
type iterTokenizer struct {
}

// newIterTokenizer is a iterTokenizer constructor.
func newIterTokenizer() *iterTokenizer {
	return new(iterTokenizer)
}

func addToken(s string, toks []*Token) []*Token {
	if strings.TrimSpace(s) != "" {
		toks = append(toks, &Token{Text: s})
	}
	return toks
}

func isSpecial(token string) bool {
	_, found := emoticons[token]
	return found || internalRE.MatchString(token)
}

func doSplit(token string) []*Token {
	tokens := []*Token{}
	suffs := []*Token{}

	last := 0
	for token != "" && utf8.RuneCountInString(token) != last {
		if isSpecial(token) {
			// We've found a special case (e.g., an emoticon) -- so, we add it as a token without
			// any further processing.
			tokens = addToken(token, tokens)
			break
		}
		last = utf8.RuneCountInString(token)
		lower := strings.ToLower(token)
		if hasAnyPrefix(token, prefixes) {
			// Remove prefixes -- e.g., $100 -> [$, 100].
			tokens = addToken(string(token[0]), tokens)
			token = token[1:]
		} else if idx := hasAnyIndex(lower, []string{"'ll", "'s", "'re", "'m"}); idx > -1 {
			// Handle "they'll", "I'll", etc.
			//
			// they'll -> [they, 'll].
			tokens = addToken(token[:idx], tokens)
			token = token[idx:]
		} else if idx := hasAnyIndex(lower, []string{"n't"}); idx > -1 {
			// Handle "Don't", "won't", etc.
			//
			// don't -> [do, n't].
			tokens = addToken(token[:idx], tokens)
			token = token[idx:]
		} else if hasAnySuffix(token, suffixes) {
			// Remove suffixes -- e.g., Well) -> [Well, )].
			suffs = append([]*Token{
				{Text: string(token[len(token)-1])}},
				suffs...)
			token = token[:len(token)-1]
		} else {
			tokens = addToken(token, tokens)
		}
	}

	return append(tokens, suffs...)
}

// tokenize splits a sentence into a slice of words.
func (t *iterTokenizer) tokenize(text string) []*Token {
	tokens := []*Token{}

	clean, white := sanitizer.Replace(text), false
	length := len(clean)

	start, index := 0, 0
	cache := map[string][]*Token{}
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
					toks := doSplit(span)
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
		tokens = append(tokens, doSplit(clean[start:index])...)
	}

	return tokens
}

var internalRE = regexp.MustCompile(`^(?:[A-Za-z]\.){2,}$|^[A-Z][a-z]{1,2}\.$`)
var sanitizer = strings.NewReplacer(
	"\u201c", `"`,
	"\u201d", `"`,
	"\u2018", "'",
	"\u2019", "'",
	"&rsquo;", "'")
var suffixes = []string{",", ")", `"`, "]", "!", ";", ".", "?", ":", "'"}
var prefixes = []string{"$", "(", `"`, "["}
var emoticons = map[string]int{
	"(-8":         1,
	"(-;":         1,
	"(-_-)":       1,
	"(._.)":       1,
	"(:":          1,
	"(=":          1,
	"(o:":         1,
	"(¬_¬)":       1,
	"(ಠ_ಠ)":       1,
	"(╯°□°）╯︵┻━┻": 1,
	"-__-":        1,
	"8-)":         1,
	"8-D":         1,
	"8D":          1,
	":(":          1,
	":((":         1,
	":(((":        1,
	":()":         1,
	":)))":        1,
	":-)":         1,
	":-))":        1,
	":-)))":       1,
	":-*":         1,
	":-/":         1,
	":-X":         1,
	":-]":         1,
	":-o":         1,
	":-p":         1,
	":-x":         1,
	":-|":         1,
	":-}":         1,
	":0":          1,
	":3":          1,
	":P":          1,
	":]":          1,
	":`(":         1,
	":`)":         1,
	":`-(":        1,
	":o":          1,
	":o)":         1,
	"=(":          1,
	"=)":          1,
	"=D":          1,
	"=|":          1,
	"@_@":         1,
	"O.o":         1,
	"O_o":         1,
	"V_V":         1,
	"XDD":         1,
	"[-:":         1,
	"^___^":       1,
	"o_0":         1,
	"o_O":         1,
	"o_o":         1,
	"v_v":         1,
	"xD":          1,
	"xDD":         1,
	"¯\\(ツ)/¯":    1,
}
