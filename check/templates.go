package check

import "fmt"

var baseTemplate = `# Save as MyRule.yml on your StylesPath
# See https://valelint.github.io/styles/#check-types for more info
%s
`
var existenceTemplate = `extends: existence
# "%s" will be replaced by the active token
message: "found '%s'!"
ignorecase: false
# "suggestion", "warning" or "error"
level: warning
tokens:
  - XXX
  - FIXME
  - TODO
  - NOTE`

var substitutionTemplate = `extends: substitution
message: Consider using '%s' instead of '%s'
ignorecase: false
# "suggestion", "warning" or "error"
level: warning
# swap maps tokens in form of bad: good
swap:
  abundance: plenty
  accelerate: speed up`

var checkToTemplate = map[string]string{
	"existence":    existenceTemplate,
	"substitution": substitutionTemplate,
}

// GetTemplate makes a template for the given extension point.
func GetTemplate(name string) string {
	if template, ok := checkToTemplate[name]; ok {
		return fmt.Sprintf(baseTemplate, template)
	}
	return ""
}
