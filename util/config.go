package util

import (
	"path"
	"path/filepath"

	"github.com/gobwas/glob"
	"github.com/mitchellh/go-homedir"
	"gopkg.in/ini.v1"
)

// CLConfig holds our command-line configuration.
var CLConfig struct {
	Glob   string // (optional) specifies formats to lint (e.g., "*.{md,py}")
	Output string // (optional) output style ("line" or "CLI")
	Wrap   bool   // (optional) wrap output when CLI style
}

// Config holds our .txtlint configuration.
var Config = loadOptions()

// AlertLevels holds the possible values for "level" in an external rule.
var AlertLevels = []string{"suggestion", "warning", "error"}

// LevelToInt allows us to easily compare levels in lint.go.
var LevelToInt = map[string]int{
	"suggestion": 0,
	"warning":    1,
	"error":      2,
}

type config struct {
	Checks        []string                      // All checks to load
	GBaseStyles   []string                      // Global base style
	GChecks       map[string]bool               // Global checks
	MinAlertLevel int                           // Lowest alert level to display
	SBaseStyles   map[glob.Glob][]string        // Syntax-specific base styles
	SChecks       map[glob.Glob]map[string]bool // Syntax-specific checks
	StylesPath    string                        // Directory with Rule.yml files
}

func newConfig() *config {
	var cfg config
	cfg.GChecks = make(map[string]bool)
	cfg.SBaseStyles = make(map[glob.Glob][]string)
	cfg.SChecks = make(map[glob.Glob]map[string]bool)
	cfg.MinAlertLevel = 0
	cfg.GBaseStyles = []string{"txtlint"}
	return &cfg
}

// loadConfig loads the .txtlint file. It checks the current directory, and
// then the user's home directory.
func loadConfig(names []string) (*ini.File, error) {
	var configPath, hpath string
	var iniFile *ini.File
	var err error

	home, _ := homedir.Dir()
	for _, name := range names {
		hpath = path.Join(home, name)
		if FileExists(name) {
			configPath = name
			break
		} else if FileExists(hpath) {
			configPath = hpath
			break
		}
	}

	iniFile, err = ini.Load(configPath)
	return iniFile, err
}

// loadOptions reads the .txtlint file.
func loadOptions() config {
	cfg := newConfig()
	uCfg, err := loadConfig([]string{".txtlint", "_txtlint"})
	if err != nil {
		return *cfg
	}

	core := uCfg.Section("")
	global := uCfg.Section("*")

	// Default settings
	for _, k := range core.KeyStrings() {
		if k == "StylesPath" {
			abs, _ := filepath.Abs(core.Key(k).MustString(""))
			cfg.StylesPath = abs
		} else if k == "MinAlertLevel" {
			level := core.Key(k).In("info", AlertLevels)
			cfg.MinAlertLevel = LevelToInt[level]
		}
	}

	// Global settings
	cfg.GBaseStyles = global.Key("BasedOnStyles").Strings(",")
	for _, k := range global.KeyStrings() {
		if k == "BasedOnStyles" {
			continue
		} else {
			cfg.GChecks[k] = global.Key(k).MustBool(false)
			cfg.Checks = append(cfg.Checks, k)
		}
	}

	// Syntax-specific settings
	for _, sec := range uCfg.SectionStrings() {
		if sec == "*" || sec == "DEFAULT" {
			continue
		}
		glob := glob.MustCompile(sec)
		syntaxOpts := make(map[string]bool)
		for _, k := range uCfg.Section(sec).KeyStrings() {
			if k == "BasedOnStyles" {
				cfg.SBaseStyles[glob] = uCfg.Section(sec).Key(k).Strings(",")
			} else {
				syntaxOpts[k] = uCfg.Section(sec).Key(k).MustBool(false)
				cfg.Checks = append(cfg.Checks, k)
			}
		}
		cfg.SChecks[glob] = syntaxOpts
	}

	return *cfg
}
