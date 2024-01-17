package lint

import (
	"encoding/json"
	"errors"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"

	"github.com/jdkato/twine/strcase"

	"github.com/errata-ai/vale/v3/internal/check"
	"github.com/errata-ai/vale/v3/internal/core"
)

// Solution is a potential solution to an alert.
type Solution struct {
	Suggestions []string `json:"suggestions"`
	Error       string   `json:"error"`
}

type fixer func(core.Alert, *core.Config) ([]string, error)

var fixers = map[string]fixer{
	"suggest": suggest,
	"replace": replace,
	"remove":  remove,
	"convert": convert,
	"edit":    edit,
}

// ParseAlert returns a slice of suggestions for the given Vale alert.
func ParseAlert(s string, cfg *core.Config) (Solution, error) {
	body := core.Alert{}
	resp := Solution{}

	err := json.Unmarshal([]byte(s), &body)
	if err != nil {
		return Solution{}, err
	}

	suggestions, err := processAlert(body, cfg)
	if err != nil {
		resp.Error = err.Error()
	}
	resp.Suggestions = suggestions

	return resp, nil
}

func processAlert(alert core.Alert, cfg *core.Config) ([]string, error) {
	action := alert.Action.Name
	if f, found := fixers[action]; found {
		return f(alert, cfg)
	}
	return []string{}, errors.New("unknown action")
}

func suggest(alert core.Alert, cfg *core.Config) ([]string, error) {
	var suggestions = []string{}

	name := strings.Split(alert.Check, ".")
	path := filepath.Join(cfg.StylesPath, name[0], name[1]+".yml")

	mgr, err := check.NewManager(cfg)
	if err != nil {
		return suggestions, err
	}

	if !strings.Contains(alert.Check, "Vale.") {
		err = mgr.AddRuleFromFile(alert.Check, path)
		if err != nil {
			return suggestions, err
		}
	}

	rule, ok := mgr.Rules()[alert.Check].(check.Spelling)
	if !ok {
		return suggestions, errors.New("unknown check")
	}

	return rule.Suggest(alert.Match), nil
}

func replace(alert core.Alert, _ *core.Config) ([]string, error) {
	return alert.Action.Params, nil
}

func remove(_ core.Alert, _ *core.Config) ([]string, error) {
	return []string{""}, nil
}

func convert(alert core.Alert, _ *core.Config) ([]string, error) {
	match := alert.Match
	if alert.Action.Params[0] == "simple" {
		match = strcase.Simple(match)
	}
	return []string{match}, nil
}

func edit(alert core.Alert, _ *core.Config) ([]string, error) {
	match := alert.Match

	switch name := alert.Action.Params[0]; name {
	case "regex":
		regex, err := regexp.Compile(alert.Action.Params[1])
		if err != nil {
			return []string{}, err
		}
		match = regex.ReplaceAllString(match, alert.Action.Params[2])
	case "trim_right":
		match = strings.TrimRight(match, alert.Action.Params[1])
	case "trim_left":
		match = strings.TrimLeft(match, alert.Action.Params[1])
	case "trim":
		match = strings.Trim(match, alert.Action.Params[1])
	case "truncate":
		match = strings.Split(match, alert.Action.Params[1])[0]
	case "split":
		index, err := strconv.Atoi(alert.Action.Params[2])
		if err != nil {
			return []string{}, err
		}
		match = strings.Split(match, alert.Action.Params[1])[index]
	}

	return []string{strings.TrimSpace(match)}, nil
}
