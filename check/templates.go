package check

import "fmt"

var baseTemplate = `# Save as MyRule.yml on your StylesPath
# See https://valelint.github.io/styles/#check-types for more info
# "suggestion", "warning" or "error"
level: warning
# Text describing this rule (generally longer than 'message').
description: '...'
# A link the source or reference.
link: '...'
%s`

var existenceTemplate = `extends: existence
# "%s" will be replaced by the active token
message: "found '%s'!"
ignorecase: false
tokens:
  - XXX
  - FIXME
  - TODO
  - NOTE`

var substitutionTemplate = `extends: substitution
message: Consider using '%s' instead of '%s'
ignorecase: false
# swap maps tokens in form of bad: good
swap:
  abundance: plenty
  accelerate: speed up`

var occurrenceTemplate = `extends: occurrence
message: "More than 3 commas!"
# Here, we're counting the number of times a comma appears in a sentence.
# If it occurs more than 3 times, we'll flag it.
scope: sentence
ignorecase: false
max: 3
token: ','`

var conditionalTemplate = `extends: conditional
message: "'%s' has no definition"
scope: text
ignorecase: false
# Ensures that the existence of 'first' implies the existence of 'second'.
first: \b([A-Z]{3,5})\b
second: (?:\b[A-Z][a-z]+ )+\(([A-Z]{3,5})\)
# ... with the exception of these:
exceptions:
  - ABC
  - ADD`

var consistencyTemplate = `extends: consistency
message: "Inconsistent spelling of '%s'"
scope: text
ignorecase: true
nonword: false
# We only want one of these to appear.
either:
  advisor: adviser
  centre: center`

var repetitionTemplate = `extends: repetition
message: "'%s' is repeated!"
scope: paragraph
ignorecase: false
# Will flag repeated occurrences of the same token (e.g., "this this").
tokens:
  - '[^\s]+'`

var spellingTemplate = `extends: spelling
message: "Use '%s' instead of '%s'"
# "US", "UK" or omit to ignore locality differences
locale: US
ignore:
  - Something # don't flag these words
add: # Add these word pairs
  - Valelint # bad
  - ValeLint # good`

var checkToTemplate = map[string]string{
	"existence":    existenceTemplate,
	"substitution": substitutionTemplate,
	"occurrence":   occurrenceTemplate,
	"conditional":  conditionalTemplate,
	"consistency":  consistencyTemplate,
	"repetition":   repetitionTemplate,
	"spelling":     spellingTemplate,
}

// GetTemplate makes a template for the given extension point.
func GetTemplate(name string) string {
	if template, ok := checkToTemplate[name]; ok {
		return fmt.Sprintf(baseTemplate, template)
	}
	return ""
}
