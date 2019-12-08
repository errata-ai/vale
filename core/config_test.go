package core

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"
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
			assert.Equal(t, tc.match, g.Match(tc.query), test)
		}
	}
}
