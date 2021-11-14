package check

import (
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
	"github.com/errata-ai/vale/v2/internal/rule"
	"github.com/karrick/godirwalk"
)

// Manager controls the loading and validating of the check extension points.
type Manager struct {
	Config *core.Config

	scopes       map[string]struct{}
	rules        map[string]Rule
	styles       []string
	needsTagging bool
}

// NewManager creates a new Manager and loads the rule definitions (that is,
// extended checks) specified by configuration.
func NewManager(config *core.Config) (*Manager, error) {
	var path string

	mgr := Manager{
		Config: config,

		rules:  make(map[string]Rule),
		scopes: make(map[string]struct{}),
	}

	err := mgr.loadDefaultRules()
	if err != nil {
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
			if err = mgr.addRuleFromSource(fName, path); err != nil {
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

// AddRuleFromFile adds the given rule to the manager.
func (mgr *Manager) AddRuleFromFile(name, path string) error {
	content, err := os.ReadFile(path)
	if err != nil {
		return core.NewE100("ReadFile", err)
	}
	return mgr.addCheck(content, name, path)
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

// NeedsTagging indicates if POS tagging is needed.
func (mgr *Manager) NeedsTagging() bool {
	return mgr.needsTagging
}

// AssignNLP determines what NLP tasks a file needs.
func (mgr *Manager) AssignNLP(f *core.File) nlp.NLPInfo {
	return nlp.NLPInfo{
		Scope:        f.RealExt,
		Segmentation: mgr.HasScope("sentence"),
		Splitting:    mgr.HasScope("paragraph"),
		Tagging:      mgr.NeedsTagging(),
		Endpoint:     f.NLP.Endpoint,
		Lang:         f.NLP.Lang,
	}
}

func (mgr *Manager) addStyle(path string) error {
	return godirwalk.Walk(path, &godirwalk.Options{
		Callback: func(fp string, de *godirwalk.Dirent) error {
			if de.IsDir() {
				return nil
			}
			return mgr.addRuleFromSource(de.Name(), fp)
		},
		Unsorted:            true,
		AllowNonDirectory:   true,
		FollowSymbolicLinks: true,
	})
}

func (mgr *Manager) addRuleFromSource(name, path string) error {
	if strings.HasSuffix(name, ".yml") {
		f, err := os.ReadFile(path)
		if err != nil {
			return core.NewE201FromPosition(err.Error(), path, 1)
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
	if scope, ok := generic["scope"]; scope == nil || !ok {
		generic["scope"] = []string{"text"}
	}

	rule, err := buildRule(mgr.Config, generic)
	if err != nil {
		return err
	}

	for _, s := range rule.Fields().Scope {
		base := strings.Split(s, ".")[0]
		mgr.scopes[base] = struct{}{}
	}

	if rule.Fields().Extends == "sequence" {
		mgr.needsTagging = true
	}

	if pos, ok := generic["pos"]; ok && pos != "" {
		mgr.needsTagging = true
	}

	return mgr.AddRule(chkName, rule)
}

func (mgr *Manager) loadDefaultRules() error {
	for _, style := range defaultStyles {
		if core.StringInSlice(style, mgr.styles) {
			return fmt.Errorf("'%v' collides with built-in style", style)
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
	var need []string

	for _, baseDir := range mgr.Config.Paths {
		for _, style := range styles {
			if style == "LanguageTool" {
				// Special case
				continue
			}
			p := filepath.Join(baseDir, style)
			if mgr.hasStyle(style) {
				// We've already loaded this style.
				continue
			} else if has := core.IsDir(p); !has {
				need = append(need, style)
				continue
			}
			if err := mgr.addStyle(p); err != nil {
				return err
			}
			found = append(found, style)
		}
	}

	for _, s := range need {
		if !core.StringInSlice(s, found) {
			return core.NewE100(
				"loadStyles",
				errors.New("style '"+s+"' does not exist on StylesPath"))
		}
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
		if level, ok := mgr.Config.RuleToLevel["Vale.Terms"]; ok {
			vocab["level"] = level
		}
		rule, _ := buildRule(mgr.Config, vocab)
		mgr.rules["Vale.Terms"] = rule
	}

	if len(mgr.Config.RejectedTokens) > 0 {
		avoid := defaultRules["Avoid"]
		for term := range mgr.Config.RejectedTokens {
			avoid["tokens"] = append(avoid["tokens"].([]string), term)
		}
		if level, ok := mgr.Config.RuleToLevel["Vale.Avoid"]; ok {
			avoid["level"] = level
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
