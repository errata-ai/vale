package check

import (
	"testing"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
)

func TestExistence(t *testing.T) {
	def := baseCheck{"tokens": []string{"test"}}

	cfg, err := core.NewConfig(&core.CLIFlags{})
	if err != nil {
		t.Fatal(err)
	}

	rule, err := NewExistence(cfg, def)
	if err != nil {
		t.Fatal(err)
	}

	file, err := core.NewFile("", cfg)
	if err != nil {
		t.Fatal(err)
	}

	alerts := rule.Run(nlp.NewBlock("", "This is a test.", ""), file)
	if len(alerts) != 1 {
		t.Errorf("expected one alert, not %v", alerts)
	}

}
