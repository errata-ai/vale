package check

var existenceTemplate = `extends: existence
message: Consider removing '%s'
level: warning
code: false
ignorecase: true
tokens:
    - appears to be
    - arguably`

var substitutionTemplate = `extends: substitution
message: Consider using '%s' instead of '%s'
level: warning
ignorecase: false
# swap maps tokens in form of bad: good
swap:
  abundance: plenty
  accelerate: speed up`

var occurrenceTemplate = `extends: occurrence
message: "More than 3 commas!"
level: error
# Here, we're counting the number of times a comma appears in a sentence.
# If it occurs more than 3 times, we'll flag it.
scope: sentence
ignorecase: false
max: 3
token: ','`

var conditionalTemplate = `extends: conditional
message: "'%s' has no definition"
level: error
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
level: error
scope: text
ignorecase: true
nonword: false
# We only want one of these to appear.
either:
  advisor: adviser
  centre: center`

var repetitionTemplate = `extends: repetition
message: "'%s' is repeated!"
level: error
alpha: true
tokens:
  - '[^\s]+'`

var capitalizationTemplate = `extends: capitalization
message: "'%s' should be in title case"
level: warning
scope: heading
# $title, $sentence, $lower, $upper, or a pattern.
match: $title
style: AP # AP or Chicago; only applies when match is set to $title.`

var readabilityTemplate = `extends: readability
message: "Grade level (%s) too high!"
level: warning
grade: 8
metrics:
  - Flesch-Kincaid
  - Gunning Fog`

var spellingTemplate = `extends: spelling
message: "Did you really mean '%s'?"
level: error
ignore: ci/vocab.txt`

var checkToTemplate = map[string]string{
	"existence":      existenceTemplate,
	"substitution":   substitutionTemplate,
	"occurrence":     occurrenceTemplate,
	"conditional":    conditionalTemplate,
	"consistency":    consistencyTemplate,
	"repetition":     repetitionTemplate,
	"capitalization": capitalizationTemplate,
	"readability":    readabilityTemplate,
	"spelling":       spellingTemplate,
}

// GetTemplate makes a template for the given extension point.
func GetTemplate(name string) string {
	if template, ok := checkToTemplate[name]; ok {
		return template
	}
	return ""
}

// GetExtenionPoints returns a slice of extension points.
func GetExtenionPoints() []string {
	return extensionPoints
}
