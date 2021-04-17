package check

import (
	"fmt"
	"sort"
	"strconv"
	"strings"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
	"github.com/jdkato/regexp"
	"gopkg.in/yaml.v2"
)

// Rule represents in individual writing construct to enforce.
type Rule interface {
	Run(blk nlp.Block, file *core.File) []core.Alert
	Fields() Definition
	Pattern() string
}

// Definition holds the common attributes of rule definitions.
type Definition struct {
	Action      core.Action
	Description string
	Extends     string
	Level       string
	Limit       int
	Link        string
	Message     string
	Name        string
	Scope       []string
	Selector    core.Selector
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
	"sequence",
}
var defaultRules = map[string]map[string]interface{}{
	"Avoid": {
		"extends":    "existence",
		"name":       "Vale.Avoid",
		"level":      "error",
		"message":    "Avoid using '%s'.",
		"scope":      "text",
		"ignorecase": false,
		"tokens":     []string{},
		"path":       "",
	},
	"Terms": {
		"extends":    "substitution",
		"name":       "Vale.Terms",
		"level":      "error",
		"message":    "Use '%s' instead of '%s'.",
		"scope":      "text",
		"ignorecase": true,
		"swap":       map[string]string{},
		"path":       "",
	},
	"Grammar": {
		"extends": "lt",
		"name":    "LanguageTool.Grammar",
		"level":   "warning",
		"scope":   "summary",
		"path":    "",
	},
}

const (
	ignoreCase      = `(?i)`
	wordTemplate    = `(?m)\b(?:%s)\b`
	nonwordTemplate = `(?m)(?:%s)`
	tokenTemplate   = `^(?:%s)$`
)

type baseCheck map[string]interface{}

func buildRule(cfg *core.Config, generic baseCheck) (Rule, error) {
	name := generic["extends"].(string)

	switch name {
	case "existence":
		return NewExistence(cfg, generic)
	case "substitution":
		return NewSubstitution(cfg, generic)
	case "capitalization":
		return NewCapitalization(cfg, generic)
	case "occurrence":
		return NewOccurrence(cfg, generic)
	case "spelling":
		return NewSpelling(cfg, generic)
	case "repetition":
		return NewRepetition(cfg, generic)
	case "readability":
		return NewReadability(cfg, generic)
	case "conditional":
		return NewConditional(cfg, generic)
	case "consistency":
		return NewConsistency(cfg, generic)
	case "sequence":
		return NewSequence(cfg, generic)
	case "lt":
		return NewLanguageTool(cfg, generic)
	default:
		path := generic["path"].(string)
		return Existence{}, core.NewE201FromTarget(
			fmt.Sprintf("'extends' key must be one of %v.", extensionPoints),
			name,
			path)
	}
}

func formatMessages(msg string, desc string, subs ...string) (string, string) {
	return core.FormatMessage(msg, subs...), core.FormatMessage(desc, subs...)
}

func makeAlert(chk Definition, loc []int, txt string) core.Alert {
	match := txt[loc[0]:loc[1]]
	a := core.Alert{
		Check: chk.Name, Severity: chk.Level, Span: loc, Link: chk.Link,
		Match: match, Action: chk.Action}
	a.Message, a.Description = formatMessages(chk.Message, chk.Description, match)
	return a
}

func parse(file []byte, path string) (map[string]interface{}, error) {
	generic := map[string]interface{}{}

	if err := yaml.Unmarshal(file, &generic); err != nil {
		r := regexp.MustCompile(`yaml: line (\d+): (.+)`)
		if r.MatchString(err.Error()) {
			groups := r.FindStringSubmatch(err.Error())
			i, err := strconv.Atoi(groups[1])
			if err != nil {
				return generic, core.NewE100("addCheck/Atoi", err)
			}
			return generic, core.NewE201FromPosition(groups[2], path, i)
		}
	} else if err := validateDefinition(generic, path); err != nil {
		return generic, err
	}

	return generic, nil
}

func validateDefinition(generic map[string]interface{}, path string) error {
	if point, ok := generic["extends"]; !ok || point == nil {
		return core.NewE201FromPosition(
			"Missing the required 'extends' key.",
			path,
			1)
	} else if !core.StringInSlice(point.(string), extensionPoints) {
		key := point.(string)
		return core.NewE201FromTarget(
			fmt.Sprintf("'extends' key must be one of %v.", extensionPoints),
			key,
			path)
	}

	if _, ok := generic["message"]; !ok {
		return core.NewE201FromPosition(
			"Missing the required 'message' key.",
			path,
			1)
	}

	if level, ok := generic["level"]; ok {
		if level == nil || !core.StringInSlice(level.(string), core.AlertLevels) {
			return core.NewE201FromTarget(
				fmt.Sprintf("'level' must be one of %v", core.AlertLevels),
				"level",
				path)
		}
	}

	if generic["code"] != nil && generic["code"].(bool) {
		return core.NewE201FromTarget(
			"`code` is deprecated; please use `scope: raw` instead.",
			"code",
			path)
	}

	return nil
}

func readStructureError(err error, path string) error {
	r := regexp.MustCompile(`\* '(.+)' (.+)`)
	if r.MatchString(err.Error()) {
		groups := r.FindStringSubmatch(err.Error())
		return core.NewE201FromTarget(
			groups[2],
			strings.ToLower(groups[1]),
			path)
	}
	return err
}

func makeRegexp(
	template string,
	noCase bool,
	word func() bool,
	callback func() string,
	append bool,
) string {
	regex := ""

	if word() {
		if template != "" {
			regex += template
		} else {
			regex += wordTemplate
		}
	} else {
		regex += nonwordTemplate
	}

	if append {
		regex += callback()
	} else {
		regex = callback() + regex
	}

	if noCase {
		regex = ignoreCase + regex
	}

	return regex
}

func matchToken(expected, observed string, ignorecase bool) bool {
	p := expected
	if ignorecase {
		p = ignoreCase + p
	}

	r, err := regexp.Compile(fmt.Sprintf(tokenTemplate, expected))
	if core.IsPhrase(expected) || err != nil {
		return expected == observed
	}
	return r.MatchString(observed)
}

func updateExceptions(previous []string, current map[string]struct{}) []string {
	for term := range current {
		previous = append(previous, term)
	}

	// NOTE: This is required to ensure that we have greedy alternation.
	sort.Slice(previous, func(p, q int) bool {
		return len(previous[p]) > len(previous[q])
	})

	return previous
}
