package check

import (
	"testing"

	"github.com/vale-cli/vale/v3/internal/core"
	"github.com/vale-cli/vale/v3/internal/nlp"
)

func makeConditional(t *testing.T, cfg *core.Config, def baseCheck) Conditional {
	t.Helper()
	rule, err := NewConditional(cfg, def, "")
	if err != nil {
		t.Fatal(err)
	}
	return rule
}

// With `in`, the consequent is looked for in another View scope's values.
func TestConditionalAcrossScopes(t *testing.T) {
	cfg, err := core.NewConfig(&core.CLIFlags{})
	if err != nil {
		t.Fatal(err)
	}
	cfg.Views["COMMIT_EDITMSG"] = &core.View{Scopes: []core.Scope{{Name: "subject"}, {Name: "trailer"}}}

	rule := makeConditional(t, cfg, baseCheck{
		"scope":  "subject",
		"first":  `^\w+(?:\([^)]*\))?!:`,
		"second": `^BREAKING CHANGE: `,
		"in":     "trailer",
	})

	cases := []struct {
		name    string
		trailer []string
		want    int
	}{
		{"footer present", []string{"BREAKING CHANGE: the flag is gone"}, 0},
		{"footer absent", []string{"Signed-off-by: J <j@x.y>"}, 1},
		{"scope unfilled", []string{""}, 1},
		{"scope missing", nil, 1},
	}

	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			f := &core.File{Scoped: map[string][]string{}}
			if c.trailer != nil {
				f.Scoped["trailer"] = c.trailer
			}

			alerts, rerr := rule.Run(nlp.NewBlock("", "feat!: drop the flag", "text.subject"), f, cfg)
			if rerr != nil {
				t.Fatal(rerr)
			}
			if len(alerts) != c.want {
				t.Errorf("got %d alerts, want %d", len(alerts), c.want)
			}
		})
	}
}

// An `in` that no View defines is an error at load, so a typo is loud.
func TestConditionalInUnknownScope(t *testing.T) {
	cfg, err := core.NewConfig(&core.CLIFlags{})
	if err != nil {
		t.Fatal(err)
	}

	_, err = NewConditional(cfg, baseCheck{
		"first": "a", "second": "b", "in": "nope",
	}, "")
	if err == nil {
		t.Fatal("expected an error for an unknown scope")
	}
}

// Without `in`, the rule reads only its own block, as before.
func TestConditionalSameBlock(t *testing.T) {
	cfg, err := core.NewConfig(&core.CLIFlags{})
	if err != nil {
		t.Fatal(err)
	}
	rule := makeConditional(t, cfg, baseCheck{"first": `\bSection\b`, "second": "Summary:"})

	f := &core.File{}
	alerts, err := rule.Run(nlp.NewBlock("", "Section one. Summary: fine.", "text"), f, cfg)
	if err != nil {
		t.Fatal(err)
	}
	if len(alerts) != 0 {
		t.Errorf("got %d alerts, want 0", len(alerts))
	}

	alerts, err = rule.Run(nlp.NewBlock("", "Section one.", "text"), f, cfg)
	if err != nil {
		t.Fatal(err)
	}
	if len(alerts) != 1 {
		t.Errorf("got %d alerts, want 1", len(alerts))
	}
}
