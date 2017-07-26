// TODO(matloob): DELETE ME!

package dfa

import (
	"testing"

	"github.com/jdkato/regexp/internal/input"
	"github.com/jdkato/regexp/syntax"
)

func matchDFA(regexp string, input string) (int, int, bool, error) {
	return matchDFA2(regexp, input, false)
}

func matchDFA2(regexp string, inputstr string, longest bool) (int, int, bool, error) {
	re, err := syntax.Parse(regexp, syntax.Perl)
	if err != nil {
		return 0, 0, false, err
	}
	prog, err := syntax.Compile(re)
	if err != nil {
		return 0, 0, false, err
	}

	kind := firstMatch
	if longest {
		kind = longestMatch
	}

	d := newDFA(prog, kind, 0)

	revprog, err := syntax.CompileReversed(re)
	if err != nil {
		panic("failed to compile reverse prog")
	}

	reversed := newDFA(revprog, longestMatch, 0)

	var i input.InputString
	i.Reset(inputstr)
	j, k, b, err := search(d, reversed, &i, 0)
	return j, k, b, err
}

func TestDFA(t *testing.T) {
	// These are all anchored matches.
	testCases := []struct {
		re    string
		in    string
		wantS int
		wantE int
		want  bool
	}{

		{"abc", "abc", 0, 3, true},
		{"abc", "ab", -1, -1, false},
		{".*(a|z)bc", "eedbcxcee", -1, -1, false},
		{"^abc", "xxxabcxxx", -1, -1, false},

		{"ab*", "xxxabbxxx", 3, 6, true},
		{"abc", "xxxabcxxx", 3, 6, true},

		{"(>[^\n]+)?\n", ">One Homo sapiens alu\nGGCCGGGCGCG", 0, 22, true},
		{"abc", "abcxxxabc", 0, 3, true},
		{"^abcde", "abcde", 0, 5, true},
		{"^", "abcde", 0, 0, true},
		{"abcde$", "abcde", 0, 5, true},
		{"$", "abcde", 5, 5, true},
		{"agggtaa[cgt]|[acg]ttaccct", "agggtaag", 0, 8, true},
		{"[cgt]gggtaaa|tttaccc[acg]", "xtttacccce", 1, 9, true},
		{"[日本語]+", "日本語日本語", 0, len("日本語日本語"), true},
		{"a.", "paranormal", 1, 3, true},
		{`\B`, "x", -1, -1, false},
	}
	for _, tc := range testCases {
		i, j, got, err := matchDFA(tc.re, tc.in)
		if err != nil {
			t.Error(err)
		}
		if got != tc.want || i != tc.wantS || j != tc.wantE {
			t.Errorf("matchDFA(%q, %q): got (%v, %v, %v), want (%v, %v, %v)", tc.re, tc.in, i, j, got, tc.wantS, tc.wantE, tc.want)
		}
	}

}
func TestDFA3(t *testing.T) {
	// These are all anchored matches.
	testCases := []struct {
		re    string
		in    string
		wantS int
		wantE int
		want  bool
	}{
		{`\B`, "a0b", 1, 1, true},
		//		{"\\B", "x", -1, -1, false},
		//		{"\\B", "xx yy", 1,1,true},
		//		{`(?:A|(?:A|a))`, "B", -1, -1, true},
		//		{`(?:A|(?:A|a))`, "B", -1, -1, true},
	}
	for _, tc := range testCases {
		i, j, got, err := matchDFA(tc.re, tc.in)
		if err != nil {
			t.Error(err)
			continue
		}
		if got != tc.want || i != tc.wantS || j != tc.wantE {
			t.Errorf("matchDFA(%q, %q): got (%v, %v, %v), want (%v, %v, %v)", tc.re, tc.in, i, j, got, tc.wantS, tc.wantE, tc.want)
		}
	}
}
