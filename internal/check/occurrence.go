package check

import (
	"github.com/errata-ai/regexp2"
	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
)

// Occurrence counts the number of times Token appears.
type Occurrence struct {
	Definition `mapstructure:",squash"`
	Token      string
	Max        int
	Min        int
	pattern    *regexp2.Regexp
	Ignorecase bool
}

// NewOccurrence creates a new `occurrence`-based rule.
func NewOccurrence(cfg *core.Config, generic baseCheck, path string) (Occurrence, error) {
	rule := Occurrence{}

	err := decodeRule(generic, &rule)
	if err != nil {
		return rule, readStructureError(err, path)
	}

	regex := ""
	if rule.Ignorecase {
		regex += ignoreCase
	}

	regex += `(?:` + rule.Token + `)`
	re, err := regexp2.CompileStd(regex)
	if err != nil {
		return rule, core.NewE201FromPosition(err.Error(), path, 1)
	}

	rule.pattern = re
	return rule, nil
}

// Run checks the number of occurrences of a user-defined regex against a
// certain threshold.
func (o Occurrence) Run(blk nlp.Block, f *core.File) ([]core.Alert, error) {
	var a core.Alert
	var err error
	var alerts []core.Alert

	txt := blk.Text
	locs := o.pattern.FindAllStringIndex(txt, -1)

	occurrences := len(locs)
	if (o.Max > 0 && occurrences > o.Max) || (o.Min > 0 && occurrences < o.Min) {
		if occurrences == 0 {
			// NOTE: We might not have a location to report -- i.e., by
			// definition, having zero instances of a token may break a rule.
			//
			// In a case like this, the check essentially becomes
			// document-scoped (like `readability`), so we mark the issue at
			// the first line.
			a = core.Alert{
				Check: o.Name, Severity: o.Level, Span: []int{1, 1},
				Link: o.Link}
		} else {
			// NOTE: We take only the first match (`locs[0]`) instead of the
			// whole scope (`txt`) to avoid having to fall back to string
			// matching.
			//
			// See (core/location.go#initialPosition).
			a, err = makeAlert(o.Definition, locs[0], txt)
			if err != nil {
				return alerts, err
			}
		}

		a.Message = o.Message
		a.Description = o.Description
		alerts = append(alerts, a)
	}

	return alerts, nil
}

// Fields provides access to the internal rule definition.
func (o Occurrence) Fields() Definition {
	return o.Definition
}

// Pattern is the internal regex pattern used by this rule.
func (o Occurrence) Pattern() string {
	return o.pattern.String()
}
