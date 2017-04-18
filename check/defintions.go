package check

import "github.com/ValeLint/vale/core"

// A Check implements a single rule.
type Check struct {
	Extends string
	Level   int
	Rule    ruleFn
	Scope   core.Selector
}

// AllChecks holds all of our individual checks. The keys are in the form
// "styleName.checkName".
var AllChecks = map[string]Check{}

// Definition holds the common attributes of rule definitions.
type Definition struct {
	Description string
	Extends     string
	Level       string
	Link        string
	Message     string
	Name        string
	Scope       string
}

// Existence checks for the present of Tokens.
type Existence struct {
	Definition `mapstructure:",squash"`
	Ignorecase bool
	Nonword    bool
	Raw        []string
	Tokens     []string
}

// Substitution switches the values of Swap for its keys.
type Substitution struct {
	Definition `mapstructure:",squash"`
	Ignorecase bool
	Nonword    bool
	Swap       map[string]string
}

// Occurrence counts the number of times Token appears.
type Occurrence struct {
	Definition `mapstructure:",squash"`
	Max        int
	Token      string
}

// Repetition looks for repeated uses of Tokens.
type Repetition struct {
	Definition `mapstructure:",squash"`
	Max        int
	Ignorecase bool
	Tokens     []string
}

// Consistency ensures that the keys and values of Either don't both exist.
type Consistency struct {
	Definition `mapstructure:",squash"`
	Nonword    bool
	Ignorecase bool
	Either     map[string]string
}

// Conditional ensures that the present of First ensures the present of Second.
type Conditional struct {
	Definition `mapstructure:",squash"`
	Ignorecase bool
	First      string
	Second     string
	Exceptions []string
}

// Script runs Exe with Runtime.
type Script struct {
	Definition `mapstructure:",squash"`
	Exe        string
	Runtime    string
}

// Spelling checks spell checks a .
type Spelling struct {
	Definition `mapstructure:",squash"`
	Locale     string
	Ignore     []string
	Add        []string
}

var defaultChecks = []string{
	"Annotations",
	"ComplexWords",
	"Editorializing",
	"GenderBias",
	"Hedging",
	"Litotes",
	"PassiveVoice",
	"Redundancy",
	"Repetition",
	"Uncomparables",
	"Wordiness",
}

var extensionPoints = []string{
	"capitalization",
	"conditional",
	"consistency",
	"existence",
	"occurrence",
	"repetition",
	"script",
	"substitution",
	"spelling",
}
