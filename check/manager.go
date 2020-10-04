package check

import (
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/errata-ai/vale/config"
	"github.com/errata-ai/vale/core"
	"github.com/errata-ai/vale/rule"
)

const (
	ignoreCase      = `(?i)`
	wordTemplate    = `(?m)\b(?:%s)\b`
	nonwordTemplate = `(?m)(?:%s)`
)

// Manager controls the loading and validating of the check extension points.
type Manager struct {
	Config *config.Config

	scopes map[string]struct{}
	rules  map[string]Rule
	styles []string
}

// NewManager creates a new Manager and loads the rule definitions (that is,
// extended checks) specified by configuration.
func NewManager(config *config.Config) (*Manager, error) {
	var path string

	mgr := Manager{
		Config: config,

		rules:  make(map[string]Rule),
		scopes: make(map[string]struct{}),
	}

	err := mgr.loadDefaultRules()
	if mgr.Config.StylesPath == "" {
		// If we're not given a StylesPath, there's nothing left to look for.
		return &mgr, err
	}

	// Load our styles ...
	err = mgr.loadStyles(mgr.Config.Styles)
	if err != nil {
		return &mgr, err
	}

	for _, chk := range mgr.Config.Checks {
		// Load any remaining individual rules.
		if !strings.Contains(chk, ".") {
			// A rule must be associated with a style (i.e., "Style[.]Rule").
			continue
		}
		parts := strings.Split(chk, ".")
		if !mgr.hasStyle(parts[0]) {
			// If this rule isn't part of an already-loaded style, we load it
			// individually.
			fName := parts[1] + ".yml"
			path = filepath.Join(mgr.Config.StylesPath, parts[0], fName)
			if err = mgr.AddRuleFromSource(fName, path); err != nil {
				return &mgr, err
			}
		}
	}

	return &mgr, err
}

// AddRule adds the given rule to the manager.
func (mgr *Manager) AddRule(name string, rule Rule) error {
	if _, found := mgr.rules[name]; !found {
		mgr.rules[name] = rule
		return nil
	}
	return fmt.Errorf("the rule '%s' has already been added", name)
}

// AddRuleFromSource adds the given rule to the manager.
func (mgr *Manager) AddRuleFromSource(name, path string) error {
	if strings.HasSuffix(name, ".yml") {
		f, err := mgr.Config.FsWrapper.ReadFile(path)
		if err != nil {
			return fmt.Errorf("failed to load rule '%s'.\n\n%v", name, err)
		}

		style := filepath.Base(filepath.Dir(path))
		chkName := style + "." + strings.Split(name, ".")[0]
		if _, ok := mgr.rules[chkName]; !ok {
			if err = mgr.addCheck(f, chkName, path); err != nil {
				return err
			}
		}
	}
	return nil
}

// Rules are all of the Manager's compiled `Rule`s.
func (mgr *Manager) Rules() map[string]Rule {
	return mgr.rules
}

// HasScope returns `true` if the manager has a rule that applies to `scope`.
func (mgr *Manager) HasScope(scope string) bool {
	_, found := mgr.scopes[scope]
	return found
}

func (mgr *Manager) addStyle(path string) error {
	return mgr.Config.FsWrapper.Walk(path,
		func(fp string, fi os.FileInfo, err error) error {
			if err != nil || fi.IsDir() {
				return err
			}
			return mgr.AddRuleFromSource(fi.Name(), fp)
		})
}

func (mgr *Manager) addCheck(file []byte, chkName, path string) error {
	// Load the rule definition.
	generic, err := parse(file, path)
	if err != nil {
		return err
	}

	// Set default values, if necessary.
	generic["name"] = chkName
	generic["path"] = path

	if level, ok := mgr.Config.RuleToLevel[chkName]; ok {
		generic["level"] = level
	} else if _, ok := generic["level"]; !ok {
		generic["level"] = "warning"
	}
	if _, ok := generic["scope"]; !ok {
		generic["scope"] = "text"
	}

	rule, err := buildRule(mgr.Config, generic)
	if err != nil {
		return err
	}

	base := strings.Split(generic["scope"].(string), ".")[0]
	mgr.scopes[base] = struct{}{}

	return mgr.AddRule(chkName, rule)
}

func (mgr *Manager) loadDefaultRules() error {
	for _, style := range defaultStyles {
		if core.StringInSlice(style, mgr.styles) {
			// The user has a style on their `StylesPath` with the same
			// name as a built-in style.
			//
			// TODO: Should this be considered an error?
			continue
		}

		rules, err := rule.AssetDir(filepath.Join("rule", style))
		if err != nil {
			return err
		}

		for _, name := range rules {
			b, err := rule.Asset(filepath.Join("rule", style, name))
			if err != nil {
				return err
			}

			identifier := strings.Join([]string{
				style, strings.Split(name, ".")[0]}, ".")

			if err = mgr.addCheck(b, identifier, ""); err != nil {
				return err
			}
		}
	}

	// TODO: where should this go?
	mgr.loadVocabRules()

	return nil
}

func (mgr *Manager) loadStyles(styles []string) error {
	var found []string

	baseDir := mgr.Config.StylesPath
	for _, style := range styles {
		p := filepath.Join(baseDir, style)
		if mgr.hasStyle(style) {
			// We've already loaded this style.
			continue
		} else if has, _ := mgr.Config.FsWrapper.DirExists(p); !has {
			return errors.New("missing style: '" + style + "'")
		}
		if err := mgr.addStyle(p); err != nil {
			return err
		}
		found = append(found, style)
	}

	mgr.styles = append(mgr.styles, found...)
	return nil
}

func (mgr *Manager) loadVocabRules() {
	if len(mgr.Config.AcceptedTokens) > 0 {
		vocab := defaultRules["Terms"]
		for term := range mgr.Config.AcceptedTokens {
			if core.IsPhrase(term) {
				vocab["swap"].(map[string]string)[strings.ToLower(term)] = term
			}
		}
		rule, _ := buildRule(mgr.Config, vocab)
		mgr.rules["Vale.Terms"] = rule
	}

	if len(mgr.Config.RejectedTokens) > 0 {
		avoid := defaultRules["Avoid"]
		for term := range mgr.Config.RejectedTokens {
			avoid["tokens"] = append(avoid["tokens"].([]string), term)
		}
		rule, _ := buildRule(mgr.Config, avoid)
		mgr.rules["Vale.Avoid"] = rule
	}

	if mgr.Config.LTPath != "" {
		rule, _ := buildRule(mgr.Config, defaultRules["Grammar"])
		mgr.rules["LanguageTool.Grammar"] = rule
	}
}

func (mgr *Manager) hasStyle(name string) bool {
	styles := append(mgr.styles, defaultStyles...)
	return core.StringInSlice(name, styles)
}
