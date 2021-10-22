package check

import (
	"github.com/Knetic/govaluate"
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
	Formula string

	exp *govaluate.EvaluableExpression
}

// NewMetric creates a new `metric`-based rule.
func NewMetric(cfg *core.Config, generic baseCheck) (Metric, error) {
	rule := Metric{}
	path := generic["path"].(string)

	err := mapstructure.WeakDecode(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	exp, err := govaluate.NewEvaluableExpression(rule.Formula)
	if err != nil {
		return rule, core.NewE201FromTarget(err.Error(), "formula", path)
	}
	rule.exp = exp

	rule.Definition.Scope = []string{"summary"}
	return rule, nil
}

// Run calculates the readability level of the given text.
func (o Metric) Run(blk nlp.Block, f *core.File) []core.Alert {
	alerts := []core.Alert{}

	parameters := map[string]interface{}{}
	parameters["heading_count"] = f.Metrics["$headings"]
	parameters["paragraph_count"] = f.Metrics["$paragraphs"]

	result, _ := o.exp.Evaluate(parameters)
	if result != nil && result.(bool) {
		a := core.Alert{Check: o.Name, Severity: o.Level, Span: []int{1, 1},
			Link: o.Link}
		a.Message, a.Description = formatMessages(o.Message, o.Description)
		alerts = append(alerts, a)
	}

	return alerts
}

// Fields provides access to the internal rule definition.
func (o Metric) Fields() Definition {
	return o.Definition
}

// Pattern is the internal regex pattern used by this rule.
func (o Metric) Pattern() string {
	return o.Formula
}
