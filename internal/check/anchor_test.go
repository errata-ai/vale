package check

import (
	"testing"
	"unicode/utf8"

	"github.com/vale-cli/vale/v3/internal/core"
	"github.com/vale-cli/vale/v3/internal/nlp"
)

// runeSpanToBytes underpins every anchored alert; an off-by-one here
// mislocates findings rather than failing loudly.
func TestRuneSpanToBytes(t *testing.T) {
	cases := []struct {
		name     string
		s        string
		from, to int
		want     string
		ok       bool
	}{
		{"ascii start", "hello world", 0, 5, "hello", true},
		{"ascii middle", "hello world", 6, 11, "world", true},
		{"ascii to end", "hello", 0, 5, "hello", true},
		{"empty span", "hello", 2, 2, "", true},
		{"multibyte before", "héllo wörld", 6, 11, "wörld", true},
		{"multibyte inside", "héllo", 0, 5, "héllo", true},
		{"emoji", "a 🎉 b", 2, 3, "🎉", true},
		{"cjk", "漢字テスト", 0, 2, "漢字", true},
		{"whole string", "naïve", 0, 5, "naïve", true},
		{"negative", "abc", -1, 2, "", false},
		{"reversed", "abc", 2, 1, "", false},
	}

	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			lo, hi, ok := runeSpanToBytes(c.s, c.from, c.to)
			if ok != c.ok {
				t.Fatalf("ok = %v, want %v", ok, c.ok)
			}
			if !ok {
				return
			}
			if got := c.s[lo:hi]; got != c.want {
				t.Errorf("s[%d:%d] = %q, want %q", lo, hi, got, c.want)
			}
		})
	}
}

// The conversion must agree with the rune slicing it replaces, for every span
// of a multi-byte string.
func TestRuneSpanToBytesMatchesRuneSlicing(t *testing.T) {
	for _, s := range []string{
		"hello world",
		"héllo wörld",
		"漢字テストです",
		"a 🎉 b 😀 c",
		"naïve café résumé",
		"",
	} {
		runes := []rune(s)
		for from := 0; from <= len(runes); from++ {
			for to := from; to <= len(runes); to++ {
				lo, hi, ok := runeSpanToBytes(s, from, to)
				if !ok {
					t.Fatalf("%q [%d:%d]: not ok", s, from, to)
				}
				want := string(runes[from:to])
				if got := s[lo:hi]; got != want {
					t.Errorf("%q [%d:%d] = %q, want %q", s, from, to, got, want)
				}
			}
		}
	}
}

// re2LocReference is the straightforward implementation of re2Loc: convert the
// whole string and slice it. re2Loc avoids that allocation, so it has to agree
// with this on every span, including the out-of-bounds ones.
func re2LocReference(s string, loc []int) (string, bool) {
	converted := []rune(s)

	size := len(converted)
	if loc[0] < 0 || loc[1] > size || loc[0] > loc[1] {
		return "", false
	}

	return string(converted[loc[0]:loc[1]]), true
}

func TestRe2LocMatchesReference(t *testing.T) {
	inputs := []string{
		"",
		"hello",
		"héllo wörld",
		"日本語のテキスト",
		"emoji 👍🏽 here",
		"mixed ascii ünd 日本 and 🎉 too",
	}

	for _, s := range inputs {
		n := utf8.RuneCountInString(s)
		// Deliberately overshoot the rune count so the out-of-bounds paths are
		// covered as well as the valid ones.
		for from := -2; from <= n+2; from++ {
			for to := -2; to <= n+2; to++ {
				loc := []int{from, to}

				want, wantOK := re2LocReference(s, loc)
				got, err := re2Loc(s, loc)

				if wantOK != (err == nil) {
					t.Fatalf("re2Loc(%q, %v): ok = %v, want %v (err: %v)",
						s, loc, err == nil, wantOK, err)
				}
				if wantOK && got != want {
					t.Fatalf("re2Loc(%q, %v) = %q, want %q", s, loc, got, want)
				}
			}
		}
	}
}

// A block whose text inline markup rewrote has no offset of its own, and its
// alerts used to fall back to a text search that placed them on the wrong line
// -- or dropped them. Its runs place them exactly. See #502.
func TestAnchorFromRuns(t *testing.T) {
	// "  <p>ab <b>cd</b> e</p>" read as "ab cd e".
	blk := nlp.Block{
		Context: "  <p>ab <b>cd</b> e</p>",
		Text:    "ab cd e",
		Offset:  -1,
		Runs: []nlp.Run{
			{At: 0, Src: 5, N: 3},  // "ab "
			{At: 3, Src: 11, N: 2}, // "cd"
			{At: 5, Src: 17, N: 2}, // " e"
		},
	}

	tests := []struct {
		name     string
		span     []int
		want     []int
		anchored bool
	}{
		// "ab cd" reaches from the first byte to the last, `<b>` included.
		{"across the markup", []int{0, 5}, []int{5, 13}, true},
		{"before it", []int{0, 2}, []int{5, 7}, true},
		{"after it", []int{3, 5}, []int{11, 13}, true},
		{"past the last run", []int{0, 30}, nil, false},
		// An empty match sits before the byte it names.
		{"empty at the start", []int{0, 0}, []int{5, 5}, true},
		{"empty before the markup", []int{3, 3}, []int{11, 11}, true},
		{"empty at the end", []int{7, 7}, []int{19, 19}, true},
		{"empty past the end", []int{8, 8}, nil, false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			a := core.Alert{Span: tt.span}

			anchor(&a, blk)

			if a.HasByteOffsets != tt.anchored {
				t.Fatalf("HasByteOffsets = %v, want %v", a.HasByteOffsets, tt.anchored)
			}
			if !tt.anchored {
				return
			}
			if a.Span[0] != tt.want[0] || a.Span[1] != tt.want[1] {
				t.Errorf("Span = %v, want %v", a.Span, tt.want)
			}
		})
	}
}
