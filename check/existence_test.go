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

	file := core.NewFile("This is a test.", cfg)
	alerts := rule.Run("This is a test.", file)

	if len(alerts) != 1 {
		t.Fatal("expected one alert")
	}

}
