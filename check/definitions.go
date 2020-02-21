package check

import (
	"github.com/errata-ai/vale/core"
	"github.com/jdkato/regexp"
)

// A Check implements a single rule.
type Check struct {
	Code    bool
	Extends string
	Level   int
	Pattern string
	Rule    ruleFn
	Scope   core.Selector
}

// Definition holds the common attributes of rule definitions.
type Definition struct {
	Action      core.Action
	Code        bool
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
	// `append` (`bool`): Adds `raw` to the end of `tokens`, assuming both are defined.
	Append bool
	// `ignorecase` (`bool`): Makes all matches case-insensitive.
	Ignorecase bool
	// `nonword` (`bool`): Removes the default word boundaries (`\b`).
	Nonword bool
	// `raw` (`array`): A list of tokens to be concatenated into a pattern.
	Raw []string
	// `tokens` (`array`): A list of tokens to be transformed into a non-capturing group.
	Tokens []string
}

// Substitution switches the values of Swap for its keys.
type Substitution struct {
	Definition `mapstructure:",squash"`
	// `ignorecase` (`bool`): Makes all matches case-insensitive.
	Ignorecase bool
	// `nonword` (`bool`): Removes the default word boundaries (`\b`).
	Nonword bool
	// `swap` (`map`): A sequence of `observed: expected` pairs.
	Swap map[string]string
	// `pos` (`string`): A regular expression matching tokens to parts of speech.
	POS string
}

// Occurrence counts the number of times Token appears.
type Occurrence struct {
	Definition `mapstructure:",squash"`
	// `ignorecase` (`bool`): Makes all matches case-insensitive.
	Ignorecase bool
	// `max` (`int`): The maximum amount of times `token` may appear in a given scope.
	Max int
	// `min` (`int`): The minimum amount of times `token` has to appear in a given scope.
	Min int
	// `token` (`string`): The token of interest.
	Token string
}

// Repetition looks for repeated uses of Tokens.
type Repetition struct {
	Definition `mapstructure:",squash"`
	Max        int
	// `ignorecase` (`bool`): Makes all matches case-insensitive.
	Ignorecase bool
	// `alpha` (`bool`): Limits all matches to alphanumeric tokens.
	Alpha bool
	// `tokens` (`array`): A list of tokens to be transformed into a non-capturing group.
	Tokens []string
}

// Consistency ensures that the keys and values of Either don't both exist.
type Consistency struct {
	Definition `mapstructure:",squash"`
	// `nonword` (`bool`): Removes the default word boundaries (`\b`).
	Nonword bool
	// `ignorecase` (`bool`): Makes all matches case-insensitive.
	Ignorecase bool
	// `either` (`map`): A map of `option 1: option 2` pairs, of which only one may appear.
	Either map[string]string
}

// Conditional ensures that the present of First ensures the present of Second.
type Conditional struct {
	Definition `mapstructure:",squash"`
	// `ignorecase` (`bool`): Makes all matches case-insensitive.
	Ignorecase bool
	// `first` (`string`): The antecedent of the statement.
	First string
	// `second` (`string`): The consequent of the statement.
	Second string
	// `exceptions` (`array`): An array of strings to be ignored.
	Exceptions []string
}

// Capitalization checks the case of a string.
type Capitalization struct {
	Definition `mapstructure:",squash"`
	// `match` (`string`): $title, $sentence, $lower, $upper, or a pattern.
	Match string
	Check func(string, []string) bool
	// `style` (`string`): AP or Chicago; only applies when match is set to $title.
	Style string
	// `exceptions` (`array`): An array of strings to be ignored.
	Exceptions []string
	// `indicators` (`array`): An array of suffixes that indicate the next
	// token should be ignored.
	Indicators []string
}

// Readability checks the reading grade level of text.
type Readability struct {
	Definition `mapstructure:",squash"`
	// `metrics` (`array`): One or more of Gunning Fog, Coleman-Liau, Flesch-Kincaid, SMOG, and Automated Readability.
	Metrics []string
	// `grade` (`float`): The highest acceptable score.
	Grade float64
}

// Spelling checks text against a Hunspell dictionary.
type Spelling struct {
	Definition `mapstructure:",squash"`
	// `aff` (`string`): The fully-qualified path to a Hunspell-compatible `.aff` file.
	Aff string
	// `custom` (`bool`): Turn off the default filters for acronyms, abbreviations, and numbers.
	Custom bool
	// `dic` (`string`): The fully-qualified path to a Hunspell-compatible `.dic` file.
	Dic string
	// `filters` (`array`): An array of patterns to ignore during spell checking.
	Filters []*regexp.Regexp
	// `ignore` (`array`): An array of relative paths (from `StylesPath`) to files consisting of one word per line to ignore.
	Ignore     []string
	Exceptions []string
	Threshold  int
}

var defaultStyles = []string{"Vale"}

var extensionPoints = []string{
	"capitalization",
	"conditional",
	"consistency",
	"existence",
	"occurrence",
	"repetition",
	"substitution",
	"readability",
	"spelling",
}
