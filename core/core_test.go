package core

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestSelectors(t *testing.T) {
	s1 := Selector{Value: "text.comment.line.py"}
	s2 := Selector{Value: "text.comment"}
	s3 := Selector{Value: "text.comment.line.rb"}

	assert.Equal(t, []string{"text", "comment", "line", "py"}, s1.Sections())

	assert.False(t, s2.Has("py"))
	for _, part := range s1.Sections() {
		assert.True(t, s1.Has(part))
	}

	assert.True(t, s3.Contains(s3))
	assert.True(t, s1.Contains(s2))
	assert.False(t, s1.Contains(s3))

	assert.True(t, s2.Equal(s2))
	assert.False(t, s2.Equal(s1))
}
