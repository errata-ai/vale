package check

import (
	"github.com/d5/tengo/v2"
	"github.com/d5/tengo/v2/stdlib"
	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
	"github.com/mitchellh/mapstructure"
)

// Script is Tango-based script.
//
// see https://github.com/d5/tengo.
type Script struct {
	Definition `mapstructure:",squash"`
	Script     string

	path string
}

// NewScript creates a new `script`-based rule.
func NewScript(cfg *core.Config, generic baseCheck) (Script, error) {
	rule := Script{}
	path := generic["path"].(string)

	err := mapstructure.WeakDecode(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	rule.path = path
	return rule, nil
}

// Run calculates the readability level of the given text.
func (s Script) Run(blk nlp.Block, f *core.File) ([]core.Alert, error) {
	alerts := []core.Alert{}

	script := tengo.NewScript([]byte(s.Script))
	script.SetImports(stdlib.GetModuleMap("text", "fmt"))

	err := script.Add("scope", blk.Text)
	if err != nil {
		return alerts, core.NewE201FromTarget(err.Error(), "script", s.path)
	}

	compiled, err := script.Compile()
	if err != nil {
		return alerts, core.NewE201FromTarget(err.Error(), "script", s.path)
	}

	if err := compiled.Run(); err != nil {
		return alerts, core.NewE201FromTarget(err.Error(), "script", s.path)
	}

	for _, loc := range toLocation(compiled.Get("matches").Array()) {
		alerts = append(alerts, makeAlert(s.Definition, loc, blk.Text))
	}

	return alerts, nil
}

func toLocation(a []interface{}) [][]int {
	locs := [][]int{}
	for _, i := range a {
		m := i.(map[string]interface{})
		locs = append(locs, []int{
			int(m["begin"].(int64)),
			int(m["end"].(int64)),
		})
	}
	return locs
}

// Fields provides access to the internal rule definition.
func (s Script) Fields() Definition {
	return s.Definition
}

// Pattern is the internal regex pattern used by this rule.
func (s Script) Pattern() string {
	return s.Script
}
