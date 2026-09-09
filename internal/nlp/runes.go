package nlp

import (
	"sync"
	"unicode/utf8"
)

// A runeIndex converts rune positions in a block's text to byte offsets.
//
// regexp2 reports positions in runes and everything downstream addresses
// bytes. Walking the text from the start for every match is quadratic on a
// block with many of them; the index makes a conversion constant time. It is
// built on first use, once, because rules run over a block concurrently.
type runeIndex struct {
	text string
	once sync.Once

	// ascii means a rune's offset is its position, and starts is not needed.
	ascii bool

	// starts is the byte offset of each rune, then of the end of the text.
	starts []int
}

func (ix *runeIndex) build() {
	runes := 0
	ix.ascii = true
	for i := 0; i < len(ix.text); i++ {
		if ix.text[i] >= utf8.RuneSelf {
			ix.ascii = false
		}
		runes++
	}
	if ix.ascii {
		return
	}

	// Decoded the way RuneSpanToBytes decodes, so an invalid byte counts as
	// one rune in both.
	starts := make([]int, 0, runes+1)
	for i := 0; i < len(ix.text); {
		starts = append(starts, i)
		if ix.text[i] < utf8.RuneSelf {
			i++
		} else {
			_, size := utf8.DecodeRuneInString(ix.text[i:])
			i += size
		}
	}
	starts = append(starts, len(ix.text))
	ix.starts = starts
}

func (ix *runeIndex) span(from, to int) (int, int, bool) {
	ix.once.Do(ix.build)

	if from < 0 || to < from {
		return 0, 0, false
	}
	if ix.ascii {
		if to > len(ix.text) {
			return 0, 0, false
		}
		return from, to, true
	}
	if to >= len(ix.starts) {
		return 0, 0, false
	}
	return ix.starts[from], ix.starts[to], true
}

// ByteSpan converts a rune span within Text to byte offsets, reporting false
// when the span falls outside it.
func (b Block) ByteSpan(from, to int) (int, int, bool) {
	if b.runes == nil || b.runes.text != b.Text {
		// A block built by hand, or whose text changed after: walk it.
		return RuneSpanToBytes(b.Text, from, to)
	}
	return b.runes.span(from, to)
}

// RuneSpanToBytes converts a rune-indexed span into byte offsets by walking
// s. A block's ByteSpan does the same without the walk.
func RuneSpanToBytes(s string, from, to int) (int, int, bool) {
	if from < 0 || to < from {
		return 0, 0, false
	}

	var (
		runes  int
		lo, hi = -1, -1
		i      int
	)
	for i = 0; i < len(s); {
		if runes == from && lo < 0 {
			lo = i
		}
		if runes == to {
			hi = i
			break
		}

		if s[i] < utf8.RuneSelf {
			i++
		} else {
			_, size := utf8.DecodeRuneInString(s[i:])
			i += size
		}
		runes++
	}

	// A span reaching the end of the string ends past the final rune.
	if runes == from && lo < 0 {
		lo = i
	}
	if runes == to && hi < 0 {
		hi = i
	}

	if lo < 0 || hi < 0 || hi < lo {
		return 0, 0, false
	}
	return lo, hi, true
}
