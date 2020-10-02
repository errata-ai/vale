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
	AllChecks map[string]Rule
	Config    *config.Config
	Scopes    map[string]struct{}
}

// NewManager creates a new Manager and loads the rule definitions (that is,
// extended checks) specified by configuration.
func NewManager(config *config.Config) (*Manager, error) {
	var path string

	mgr := Manager{
		AllChecks: make(map[string]Rule),
		Config:    config,
		Scopes:    make(map[string]struct{}),
	}

	// loadedStyles keeps track of the styles we've loaded as we go.
	loadedStyles := []string{}
	if mgr.Config.StylesPath == "" {
		// If we're not given a StylesPath, there's nothing left to look for.
		err := mgr.loadDefaultRules(loadedStyles)
		return &mgr, err
	}

	// Load our global `BasedOnStyles` ...
	loaded, err := mgr.loadStyles(mgr.Config.GBaseStyles, loadedStyles)
	if err != nil {
		return &mgr, err
	}
	loadedStyles = append(loadedStyles, loaded...)

	// Load our section-specific `BasedOnStyles` ...
	for _, styles := range mgr.Config.SBaseStyles {
		loaded, err := mgr.loadStyles(styles, loadedStyles)
		if err != nil {
			return &mgr, err
		}
		loadedStyles = append(loadedStyles, loaded...)
	}

	for _, chk := range mgr.Config.Checks {
		// Load any remaining individual rules.
		if !strings.Contains(chk, ".") {
			// A rule must be associated with a style (i.e., "Style[.]Rule").
			continue
		}
		parts := strings.Split(chk, ".")
		if !core.StringInSlice(parts[0], loadedStyles) && !core.StringInSlice(parts[0], defaultStyles) {
			// If this rule isn't part of an already-loaded style, we load it
			// individually.
			fName := parts[1] + ".yml"
			path = filepath.Join(mgr.Config.StylesPath, parts[0], fName)
			if err = mgr.LoadCheck(fName, path); err != nil {
				return &mgr, err
			}
		}
	}

	// Finally, after reading the user's `StylesPath`, we load our built-in
	// styles:
	err = mgr.loadDefaultRules(loadedStyles)
	return &mgr, err
}

// LoadCheck adds the given external check to the manager.
func (mgr *Manager) LoadCheck(fName string, fp string) error {
	if strings.HasSuffix(fName, ".yml") {
		f, err := mgr.Config.FsWrapper.ReadFile(fp)
		if err != nil {
			return fmt.Errorf("failed to load rule '%s'.\n\n%v", fName, err)
		}

		style := filepath.Base(filepath.Dir(fp))
		chkName := style + "." + strings.Split(fName, ".")[0]
		if _, ok := mgr.AllChecks[chkName]; !ok {
			if err = mgr.addCheck(f, chkName, fp); err != nil {
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
	if _, ok := generic["scope"]; !ok {
		generic["scope"] = "text"
	}

	rule, err := BuildRule(mgr.Config, generic)
	if err != nil {
		return err
	}

	base := strings.Split(generic["scope"].(string), ".")[0]
	mgr.Scopes[base] = struct{}{}

	mgr.AllChecks[chkName] = rule
	return nil
}

func (mgr *Manager) loadExternalStyle(path string) error {
	return mgr.Config.FsWrapper.Walk(path,
		func(fp string, fi os.FileInfo, err error) error {
			if err != nil || fi.IsDir() {
				return err
			}
			return mgr.LoadCheck(fi.Name(), fp)
		})
}

func (mgr *Manager) loadDefaultRules(loaded []string) error {
	for _, style := range defaultStyles {
		if core.StringInSlice(style, loaded) {
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

func (mgr *Manager) loadStyles(styles []string, loaded []string) ([]string, error) {
	var found []string

	baseDir := mgr.Config.StylesPath
	for _, style := range styles {
		p := filepath.Join(baseDir, style)
		if core.StringInSlice(style, loaded) || core.StringInSlice(style, defaultStyles) {
			// We've already loaded this style.
			continue
		} else if has, _ := mgr.Config.FsWrapper.DirExists(p); !has {
			return found, errors.New("missing style: '" + style + "'")
		}
		if err := mgr.loadExternalStyle(p); err != nil {
			return found, err
		}
		found = append(found, style)
	}

	return found, nil
}

func (mgr *Manager) loadVocabRules() {
	if len(mgr.Config.AcceptedTokens) > 0 {
		vocab := defaultRules["Terms"]
		for term := range mgr.Config.AcceptedTokens {
			if core.IsPhrase(term) {
				vocab["swap"].(map[string]string)[strings.ToLower(term)] = term
			}
		}
		rule, _ := BuildRule(mgr.Config, vocab)
		mgr.AllChecks["Vale.Terms"] = rule
	}

	if len(mgr.Config.RejectedTokens) > 0 {
		avoid := defaultRules["Avoid"]
		for term := range mgr.Config.RejectedTokens {
			avoid["tokens"] = append(avoid["tokens"].([]string), term)
		}
		rule, _ := BuildRule(mgr.Config, avoid)
		mgr.AllChecks["Vale.Avoid"] = rule
	}

	if mgr.Config.LTPath != "" {
		rule, _ := BuildRule(mgr.Config, defaultRules["Grammar"])
		mgr.AllChecks["LanguageTool.Grammar"] = rule
	}
}
