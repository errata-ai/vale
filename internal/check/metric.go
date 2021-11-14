package check

import (
	"context"
	"fmt"

	"github.com/d5/tengo/v2"
	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
	"github.com/mitchellh/mapstructure"
)

// Metric implements arbitrary, readability-like formulas.
type Metric struct {
	Definition `mapstructure:",squash"`
	// `metric` (`string`): the formula to be dynamically evaluated.
	//
	// Variables: # of words, # of sentences, etc.
	Formula   string
	Condition string

	path string
}

// NewMetric creates a new `metric`-based rule.
func NewMetric(cfg *core.Config, generic baseCheck) (Metric, error) {
	rule := Metric{}
	path := generic["path"].(string)

	err := mapstructure.WeakDecode(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	rule.path = path
	rule.Definition.Scope = []string{"summary"}

	return rule, nil
}

// Run calculates the readability level of the given text.
func (o Metric) Run(blk nlp.Block, f *core.File) ([]core.Alert, error) {
	alerts := []core.Alert{}

	parameters := f.ComputeMetrics()
	ctx := context.Background()

	// The actual result of our formula.
	//
	// We need this to allow showing the result in a rule's message.
	res, err := tengo.Eval(ctx, o.Formula, parameters)
	if err != nil {
		return alerts, core.NewE201FromTarget(err.Error(), "formula", o.path)
	}

	// The binary result of our formula:
	eqb := fmt.Sprintf("%f %s", res, o.Condition)

	match, err := tengo.Eval(ctx, eqb, parameters)
	if err != nil {
		return alerts, core.NewE201FromTarget(err.Error(), "condition", o.path)
	}

	if match.(bool) {
		a := core.Alert{Check: o.Name, Severity: o.Level, Span: []int{1, 1},
			Link: o.Link}
		a.Message, a.Description = formatMessages(
			o.Message, o.Description, fmt.Sprintf("%.2f", res))
		alerts = append(alerts, a)
	}

	return alerts, nil
}

// Fields provides access to the internal rule definition.
func (o Metric) Fields() Definition {
	return o.Definition
}

// Pattern is the internal regex pattern used by this rule.
func (o Metric) Pattern() string {
	return o.Formula
}
