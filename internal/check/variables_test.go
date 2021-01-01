package check

import (
	"fmt"
	"strings"
	"testing"

	"github.com/jdkato/regexp"
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
		{heading: "Client's key share and finish", match: true},
		{heading: "Client’s key share and finish", match: true},
		{
			heading:    "Find the thief: Introduction",
			match:      true,
			indicators: []string{":"},
		},
		{
			heading: "Find the thief: Introduction",
			match:   false,
		},
		{
			heading:    "Creating a connection to Event Store",
			match:      true,
			exceptions: []string{"Event Store"},
		},
		{
			heading:    "Using errata-ai/vale",
			match:      true,
			exceptions: []string{"errata-ai/vale"},
		},
	}

	for _, h := range headings {
		var r *regexp.Regexp
		if len(h.exceptions) > 0 {
			regex := makeRegexp(
				"",
				false,
				func() bool { return true },
				func() string { return "" },
				true)
			regex = fmt.Sprintf(regex, strings.Join(h.exceptions, "|"))
			r = regexp.MustCompile(regex)
		}

		s := sentence(h.heading, h.exceptions, h.indicators, r)
		if s != h.match {
			t.Errorf("expected = %v, got = %v (%s)", h.match, s, h.heading)
		}
	}
}
