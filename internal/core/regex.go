package core

import "github.com/dlclark/regexp2"

// FindAllString is a re-implementation of regexp function.
func FindAllString(re *regexp2.Regexp, s string) []*regexp2.Match {
	var matches []*regexp2.Match

	m, _ := re.FindStringMatch(s)
	for m != nil {
		matches = append(matches, m)
		m, _ = re.FindNextMatch(m)
	}

	return matches
}

// Compile builds the given regex with hard-coded flags.
func Compile(re string) (*regexp2.Regexp, error) {
	return regexp2.Compile(re, regexp2.Multiline)
}
