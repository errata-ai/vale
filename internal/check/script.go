package check

import (
	"github.com/d5/tengo/v2"
	"github.com/d5/tengo/v2/stdlib"
	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
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
func NewScript(cfg *core.Config, generic baseCheck, path string) (Script, error) {
	rule := Script{}

	err := decodeRule(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	rule.path = path
	return rule, nil
}

// Run executes the given script and returns its Alerts.
func (s Script) Run(blk nlp.Block, f *core.File) ([]core.Alert, error) {
	var alerts []core.Alert

	script := tengo.NewScript([]byte(s.Script))
	// TODO: Should we enable the `os` module? Is it worth the security
	// implications?
	//
	// See #495, for example.
	script.SetImports(stdlib.GetModuleMap("text", "fmt", "math"))

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
