package core

import (
	"fmt"
	"testing"
)

type globTest struct {
	query string
	match bool
}

var globTests = []struct {
	pattern string
	tests   []globTest
}{
	{`docs/**`, []globTest{
		{`docs/a.md`, true}, {`docs/info/b.py`, true}, {`info/c.cc`, false}},
	},
	{`!docs/**`, []globTest{
		{`docs/a.md`, false}, {`docs/info/b.py`, false}, {`info/c.cc`, true}},
	},
	{`!*.min.js`, []globTest{
		{`a/b/c/foo.py`, true}, {`a/b/c/foo.min.js`, false}},
	},
	{`docs/*.md`, []globTest{
		{`docs/a.md`, true}, {`docs/info/b.md`, true}, {`docs/c.cc`, false}},
	},
}

func TestGlob(t *testing.T) {
	for _, tt := range globTests {
		g := NewGlob(tt.pattern, false)
		for _, tc := range tt.tests {
			test := fmt.Sprintf("%s -> %s", tt.pattern, tc.query)
			if tc.match != g.Match(tc.query) {
				t.Errorf(test)
			}
		}
	}
}

func TestSelectors(t *testing.T) {
	s1 := Selector{Value: "text.comment.line.py"}
	s2 := Selector{Value: "text.comment"}
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
