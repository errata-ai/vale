package nlp

import (
	"testing"
	"unicode/utf8"
)

// A block's index must agree with the walk it replaces, invalid bytes and
// spans past the end included.
func TestByteSpanMatchesWalk(t *testing.T) {
	inputs := []string{
		"",
		"hello",
		"héllo wörld",
		"日本語のテキスト",
		"emoji 👍🏽 here",
		"mixed ascii ünd 日本 and 🎉 too",
		"bad \xff byte",
		"\x80 leading continuation",
		"trailing \xe6\x97",
	}

	for _, s := range inputs {
		b := NewBlock("", s, "text")
		n := utf8.RuneCountInString(s)
		for from := -1; from <= n+2; from++ {
			for to := -1; to <= n+2; to++ {
				wlo, whi, wok := RuneSpanToBytes(s, from, to)
				lo, hi, ok := b.ByteSpan(from, to)
				if ok != wok || lo != wlo || hi != whi {
					t.Fatalf("%q (%d, %d): index = (%d, %d, %v), walk = (%d, %d, %v)",
						s, from, to, lo, hi, ok, wlo, whi, wok)
				}
			}
		}
	}
}

// A block built by hand, or whose text was replaced after it was built, has no
// index to trust and falls back to the walk.
func TestByteSpanWithoutIndex(t *testing.T) {
	b := Block{Text: "héllo"}
	if lo, hi, ok := b.ByteSpan(1, 2); !ok || lo != 1 || hi != 3 {
		t.Fatalf("bare block: got (%d, %d, %v), want (1, 3, true)", lo, hi, ok)
	}

	b = NewBlock("", "héllo", "text")
	b.Text = "hello"
	if lo, hi, ok := b.ByteSpan(1, 2); !ok || lo != 1 || hi != 2 {
		t.Fatalf("replaced text: got (%d, %d, %v), want (1, 2, true)", lo, hi, ok)
	}
}

// Copies of a block share one index; the pieces segmentation makes get their
// own, for their own text.
func TestByteSpanOnSegments(t *testing.T) {
	info := Info{Lang: "en", Segmentation: true}
	blk := NewBlock("", "Ünder one. Över two.", "text")

	blks, err := info.Compute(&blk, false)
	if err != nil {
		t.Fatal(err)
	}
	if len(blks) < 2 {
		t.Fatalf("got %d blocks, want at least 2", len(blks))
	}
	for _, b := range blks {
		lo, hi, ok := b.ByteSpan(0, 1)
		if !ok || lo != 0 || hi != utf8.RuneLen([]rune(b.Text)[0]) {
			t.Fatalf("%q: got (%d, %d, %v)", b.Text, lo, hi, ok)
		}
	}
}
