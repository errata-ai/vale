package check

import (
	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
	"github.com/errata-ai/vale/v2/internal/rule"
	"github.com/mitchellh/mapstructure"
)

// LanguageTool connects to to an instance of LanguageTool's HTTP server.
type LanguageTool struct {
	Definition `mapstructure:",squash"`

	config *core.Config
}

// NewLanguageTool creates a new `LanguageTool`-based rule.
func NewLanguageTool(cfg *core.Config, generic baseCheck) (LanguageTool, error) {
	rule := LanguageTool{}
	path := generic["path"].(string)

	err := mapstructure.WeakDecode(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	rule.config = cfg
	return rule, nil
}

// Run sends the given text to an instance of LanguageTool.
func (l LanguageTool) Run(blk nlp.Block, file *core.File) []core.Alert {
	alerts, err := rule.CheckWithLT(blk.Text, file, l.config)
	if err != nil {
		// FIXME: don't panic here
		panic(err)
	}
	return alerts
}

// Fields provides access to the internal rule definition.
func (l LanguageTool) Fields() Definition {
	return l.Definition
}

// Pattern is the internal regex pattern used by this rule.
func (l LanguageTool) Pattern() string {
	return ""
}
