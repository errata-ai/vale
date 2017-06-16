package summarize

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

var dmap = map[string]float64{
	"and": 0.047, "source": 0.023, "rules": 0.023, "comments": 0.023, "natural": 0.023,
	"markup": 0.023, "customization": 0.023, "language": 0.023, "Vale": 0.047,
	"code": 0.023, "it": 0.023, "text": 0.023, "possible": 0.023, "reStructuredText": 0.023,
	"all": 0.023, "make": 0.023, "supports": 0.023, "plain": 0.023, "a": 0.047,
	"one": 0.023, "strives": 0.023, "doesn't": 0.023, "size": 0.023, "fits": 0.023,
	"of": 0.023, "attempt": 0.023, "AsciiDoc": 0.023, "offer": 0.023, "HTML": 0.023,
	"Markdown": 0.023, "collection": 0.023, "as": 0.047, "that": 0.023, "linter": 0.023,
	"easy": 0.023, "to": 0.047, "instead": 0.023, "is": 0.023}

func TestUsage(t *testing.T) {
	text := "Vale is a natural language linter that supports plain text, markup (Markdown, reStructuredText, AsciiDoc, and HTML), and source code comments. Vale doesn't attempt to offer a one-size-fits-all collection of rules—instead, it strives to make customization as easy as possible."
	d := NewDocument(text)
	assert.Equal(t, dmap, d.WordDensity())
	assert.Equal(t, 5.163, d.MeanWordLength())
}
