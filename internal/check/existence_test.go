package check

import (
	"testing"

	"github.com/vale-cli/vale/v3/internal/core"
	"github.com/vale-cli/vale/v3/internal/nlp"
)

func makeExistence(tokens []string) (*Existence, error) {
	def := baseCheck{"tokens": tokens}

	cfg, err := core.NewConfig(&core.CLIFlags{})
	if err != nil {
		return nil, err
	}

	rule, err := NewExistence(cfg, def, "")
	if err != nil {
		return nil, err
	}

	return &rule, nil
}

func TestExistence(t *testing.T) {
	rule, err := makeExistence([]string{"test"})
	if err != nil {
		t.Fatal(err)
	}

	cfg, err := core.NewConfig(&core.CLIFlags{})
	if err != nil {
		t.Fatal(err)
	}

	file, err := core.NewFile("", cfg)
	if err != nil {
		t.Fatal(err)
	}

	alerts, _ := rule.Run(nlp.NewBlock("", "This is a test.", ""), file, cfg)
	if len(alerts) != 1 {
		t.Errorf("expected one alert, not %v", alerts)
	}
}

func FuzzExistenceInit(f *testing.F) {
	f.Add("hello")
	f.Fuzz(func(_ *testing.T, s string) {
		_, _ = makeExistence([]string{s})
	})
}

func FuzzExistence(f *testing.F) {
	rule, err := makeExistence([]string{"test"})
	if err != nil {
		f.Fatal(err)
	}

	cfg, err := core.NewConfig(&core.CLIFlags{})
	if err != nil {
		f.Fatal(err)
	}

	file, err := core.NewFile("", cfg)
	if err != nil {
		f.Fatal(err)
	}

	f.Add("hello")
	f.Fuzz(func(_ *testing.T, s string) {
		_, _ = rule.Run(nlp.NewBlock("", s, ""), file, cfg)
	})
}

// A raw pattern is joined into a printf template; a `%` in it must survive.
func TestExistenceRawPercent(t *testing.T) {
	cfg, err := core.NewConfig(&core.CLIFlags{})
	if err != nil {
		t.Fatal(err)
	}

	file, err := core.NewFile("", cfg)
	if err != nil {
		t.Fatal(err)
	}

	cases := []struct {
		raw  string
		want int
	}{
		{"%", 2},
		{"50%", 1},
		{"%s", 1},
		{"%[sd]", 1},
	}

	for _, c := range cases {
		t.Run(c.raw, func(t *testing.T) {
			def := baseCheck{"raw": []string{c.raw}, "nonword": true}
			rule, rerr := NewExistence(cfg, def, "")
			if rerr != nil {
				t.Fatal(rerr)
			}

			blk := nlp.NewBlock("", "Save %s files. A 50% discount.", "")
			alerts, aerr := rule.Run(blk, file, cfg)
			if aerr != nil {
				t.Fatal(aerr)
			}
			if len(alerts) != c.want {
				t.Errorf("%q: got %d alerts, want %d", c.raw, len(alerts), c.want)
			}
		})
	}
}
