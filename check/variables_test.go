package check

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

type changeCase struct {
	match      bool
	heading    string
	exceptions []string
	indicators []string
}

func TestSentence(t *testing.T) {
	headings := []changeCase{
		{heading: "Top-level entities", match: true},
		{heading: "Non-member Predicates", match: false},
		{heading: "Non-member predicates", match: true},
		{
			heading:    "Find the thief: Introduction",
			match:      true,
			indicators: []string{":"},
		},
		{
			heading: "Find the thief: Introduction",
			match:   false,
		},
	}

	for _, h := range headings {
		assert.Equal(t, sentence(
			h.heading, h.exceptions, h.indicators), h.match)
	}
}
