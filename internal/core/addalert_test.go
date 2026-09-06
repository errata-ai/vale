package core

import (
	"testing"

	"github.com/vale-cli/vale/v3/internal/nlp"
)

// AddAlert must not panic on an alert with a negative Span -- spelling can
// produce one when the matched token isn't found verbatim in the block. See
// #808 (panic: slice bounds out of range [-1:]).
func TestAddAlertNegativeSpan(t *testing.T) {
	f := &File{
		ChkToCtx: map[string]string{},
		history:  map[string]int{},
		limits:   map[string]int{},
	}
	// count("word") > 1 and ctx < 1000 -> the disambiguation branch that
	// previously sliced ctx[0:Span[0]] with a negative index.
	blk := nlp.NewBlock("word and word", "word and word", "text.md")
	a := Alert{Check: "X", Match: "word", Span: []int{-1, 3}}

	defer func() {
		if r := recover(); r != nil {
			t.Fatalf("AddAlert panicked on a negative span: %v", r)
		}
	}()
	f.AddAlert(a, blk, 1, 0, false)
}

// An anchored empty match is a location, not a measurement: it keeps its
// column rather than falling back to the start of its block.
func TestAddAlertEmptyMatchKeepsColumn(t *testing.T) {
	f := &File{
		ChkToCtx: map[string]string{},
		history:  map[string]int{},
		limits:   map[string]int{},
	}
	f.SetText("# Title\n\nAdd a thing\n")

	blk := nlp.NewLinedBlock(f.Content, "Add a thing", "text.md", 2)
	a := Alert{Check: "X", Match: "", Span: []int{14, 14}, HasByteOffsets: true}

	f.AddAlert(a, blk, 3, 0, false)

	if len(f.Alerts) != 1 {
		t.Fatalf("got %d alerts, want 1", len(f.Alerts))
	}
	got := f.Alerts[0]
	if got.Line != 3 || got.Span[0] != 6 || got.Span[1] != 6 {
		t.Errorf("placed at %d:%v, want 3:[6 6]", got.Line, got.Span)
	}
}

// A measurement still lands at the start of its block.
func TestAddAlertMeasurementStartsBlock(t *testing.T) {
	f := &File{
		ChkToCtx: map[string]string{},
		history:  map[string]int{},
		limits:   map[string]int{},
	}
	f.SetText("# Title\n\nAdd a thing\n")

	blk := nlp.NewLinedBlock(f.Content, "Add a thing", "text.md", 2)
	a := Alert{Check: "X", Match: "", Span: []int{1, 1}}

	f.AddAlert(a, blk, 3, 0, false)

	if len(f.Alerts) != 1 {
		t.Fatalf("got %d alerts, want 1", len(f.Alerts))
	}
	got := f.Alerts[0]
	if got.Line != 3 || got.Span[0] != 1 || got.Span[1] != 1 {
		t.Errorf("placed at %d:%v, want 3:[1 1]", got.Line, got.Span)
	}
}
