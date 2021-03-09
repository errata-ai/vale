package core

import (
	"testing"
)

func TestSelectors(t *testing.T) {
	s1 := Selector{Value: []string{"text.comment.line.py"}}
	s2 := Selector{Value: []string{"text.comment"}}
	// s3 := Selector{Value: "text.comment.line.rb"}

	sec := []string{"text", "comment", "line", "py"}
	if !AllStringsInSlice(sec, s1.Sections()) {
		t.Errorf("expected = %v, got = %v", sec, s1.Sections())
	}

	if s2.Has("py") {
		t.Errorf("expected `false`, got `true`")
	}

	for _, part := range s1.Sections() {
		if !s1.Has(part) {
			t.Errorf("expected `true`, got `false`")
		}
	}
}
