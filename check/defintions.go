package check

import "github.com/ValeLint/vale/core"

// A Check implements a single rule.
type Check struct {
	Extends string
	Code    bool
	Level   int
	Rule    ruleFn
	Scope   core.Selector
}

// Definition holds the common attributes of rule definitions.
type Definition struct {
	Description string
	Extends     string
	Level       string
	Link        string
	Message     string
	Name        string
	Scope       string
	Code        bool
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

// Capitalization checks the case of a string.
type Capitalization struct {
	Definition `mapstructure:",squash"`
	Match      string
	Check      func(string) bool
	Style      string
}

var defaultRules = []string{
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
	"substitution",
}
