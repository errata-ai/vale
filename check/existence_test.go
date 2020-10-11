package check

import (
	"testing"

	"github.com/errata-ai/vale/config"
	"github.com/errata-ai/vale/core"
)

func TestExistence(t *testing.T) {
	def := baseCheck{"tokens": []string{"test"}}

	cfg, err := config.New()
	if err != nil {
		t.Fatal(err)
	}

	rule, err := NewExistence(cfg, def)
	if err != nil {
		t.Fatal(err)
	}

	if rule.hasExceptions != false {
		t.Fatal("shouldn't have exceptions")
	}

	file, err := core.NewFile("", cfg)
	if err != nil {
		t.Fatal(err)
	}

	alerts := rule.Run("This is a test.", file)

	if len(alerts) != 1 {
		t.Errorf("expected one alert, not %v", alerts)
	}

}
