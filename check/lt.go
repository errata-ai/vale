package check

import (
	"github.com/errata-ai/vale/v2/config"
	"github.com/errata-ai/vale/v2/core"
	"github.com/errata-ai/vale/v2/rule"
	"github.com/mitchellh/mapstructure"
)

// LanguageTool ...
type LanguageTool struct {
	Definition `mapstructure:",squash"`

	config *config.Config
}

// NewLanguageTool ...
func NewLanguageTool(cfg *config.Config, generic baseCheck) (LanguageTool, error) {
	rule := LanguageTool{}
	path := generic["path"].(string)

	err := mapstructure.Decode(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	rule.config = cfg
	return rule, nil
}

// Run ...
func (l LanguageTool) Run(text string, file *core.File) []core.Alert {
	alerts, err := rule.CheckWithLT(text, file, l.config)
	if err != nil {
		// FIXME: don't panic here
		panic(err)
	}
	return alerts
}

// Fields ...
func (l LanguageTool) Fields() Definition {
	return l.Definition
}

// Pattern ...
func (l LanguageTool) Pattern() string {
	return ""
}
