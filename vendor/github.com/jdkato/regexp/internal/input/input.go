package input

import (
	"bytes"
	"io"
	"github.com/jdkato/regexp/syntax"
	"strings"
	"unicode/utf8"
)

type Prefixer interface {
	Prefix() string
	PrefixBytes() []byte
}

const EndOfText rune = -1
const StartOfText rune = -2

// Input abstracts different representations of the input text. It provides
// one-character lookahead.
type Input interface {
	// Step returns the rune starting at pos and its width. Unless
	// CanCheckPrefix is true, Step should always be called with
	// with the current position in the string, which is the sum
	// of the previous pos Step was called with, and the width
	// returned by that call.
	Step(pos int) (r rune, width int)

	// CanCheckInput reports whether we can look ahead without losing info.
	CanCheckPrefix() bool

	// HasPrefix reports whether the input has the prefix reported
	// by the Prefixer.
	HasPrefix(p Prefixer) bool

	// Index returns the index of the first occurence of the
	// prefix following pos, or -1 if it can't be found.
	Index(p Prefixer, pos int) int

	// Context returns the EmptyOp flags satisfied by the context at pos.
	Context(pos int) syntax.EmptyOp
}

type Rinput interface {
	Input

	Rstep(pos int) (r rune, width int)
}

// InputString scans a string.
type InputString struct {
	str string
}

// Reset resets the InputString with the given string.
func (i *InputString) Reset(str string) {
	i.str = str
}

func (i *InputString) Step(pos int) (rune, int) {
	if pos < 0 {
		return StartOfText, 0
	}
	if pos < len(i.str) {
		c := i.str[pos]
		if c < utf8.RuneSelf {
			return rune(c), 1
		}
		return utf8.DecodeRuneInString(i.str[pos:])
	}
	return EndOfText, 0
}

func (i *InputString) Rstep(pos int) (rune, int) {
	if pos > len(i.str) {
		return StartOfText, 0
	}
	if pos >= 0 {
		c := i.str[pos-1]
		if c < utf8.RuneSelf {
			return rune(c), 1
		}
		return utf8.DecodeLastRuneInString(i.str[:pos])
	}
	return EndOfText, 0
}

func (i *InputString) CanCheckPrefix() bool {
	return true
}

func (i *InputString) HasPrefix(p Prefixer) bool {
	return strings.HasPrefix(i.str, p.Prefix())
}

func (i *InputString) Index(p Prefixer, pos int) int {
	return strings.Index(i.str[pos:], p.Prefix())
}

func (i *InputString) Context(pos int) syntax.EmptyOp {
	r1, r2 := EndOfText, EndOfText
	if pos > 0 && pos <= len(i.str) {
		r1, _ = utf8.DecodeLastRuneInString(i.str[:pos])
	}
	if pos < len(i.str) {
		r2, _ = utf8.DecodeRuneInString(i.str[pos:])
	}
	return syntax.EmptyOpContext(r1, r2)
}

// InputBytes scans a byte slice.
type InputBytes struct {
	str []byte
}

// Reset resets the InputBytes with the given byte slice.
func (i *InputBytes) Reset(str []byte) {
	i.str = str
}

func (i *InputBytes) Step(pos int) (rune, int) {
	if pos < 0 {
		return StartOfText, 0
	}
	if pos < len(i.str) {
		c := i.str[pos]
		if c < utf8.RuneSelf {
			return rune(c), 1
		}
		return utf8.DecodeRune(i.str[pos:])
	}
	return EndOfText, 0
}

func (i *InputBytes) Rstep(pos int) (rune, int) {
	if pos > len(i.str) {
		return StartOfText, 0
	}
	if pos >= 0 {
		c := i.str[pos-1]
		if c < utf8.RuneSelf {
			return rune(c), 1
		}
		return utf8.DecodeLastRune(i.str[:pos]) // This doesn't include pos char?
	}
	return EndOfText, 0
}


func (i *InputBytes) CanCheckPrefix() bool {
	return true
}

func (i *InputBytes) HasPrefix(p Prefixer) bool {
	return bytes.HasPrefix(i.str, p.PrefixBytes())
}

func (i *InputBytes) Index(p Prefixer, pos int) int {
	if pos > len(i.str) {
		panic("pos > len i.str")
	}
	if i.str == nil {
		panic("i.str nil")
	}
	if p == nil {
		panic("p is nil")
	}
	return bytes.Index(i.str[pos:], p.PrefixBytes())
}

func (i *InputBytes) Context(pos int) syntax.EmptyOp {
	r1, r2 := EndOfText, EndOfText
	if pos > 0 && pos <= len(i.str) {
		r1, _ = utf8.DecodeLastRune(i.str[:pos])
	}
	if pos < len(i.str) {
		r2, _ = utf8.DecodeRune(i.str[pos:])
	}
	return syntax.EmptyOpContext(r1, r2)
}

// InputReader scans a RuneReader.
type InputReader struct {
	r     io.RuneReader
	atEOT bool
	pos   int
}

// Reset resets the InputReader with the given RuneReader.
func (i *InputReader) Reset(r io.RuneReader) {
	i.r = r
	i.atEOT = false
	i.pos = 0
}

func (i *InputReader) Step(pos int) (rune, int) {
	if !i.atEOT && pos != i.pos {
		return EndOfText, 0

	}
	r, w, err := i.r.ReadRune()
	if err != nil {
		i.atEOT = true
		return EndOfText, 0
	}
	i.pos += w
	return r, w
}

func (i *InputReader) CanCheckPrefix() bool {
	return false
}

func (i *InputReader) HasPrefix(p Prefixer) bool {
	return false
}

func (i *InputReader) Index(p Prefixer, pos int) int {
	return -1
}

func (i *InputReader) Context(pos int) syntax.EmptyOp {
	return 0
}
