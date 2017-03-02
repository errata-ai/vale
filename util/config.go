package util

import (
	"os"
	"path"
	"path/filepath"
	"strings"

	"github.com/mitchellh/go-homedir"
	"gopkg.in/ini.v1"
)

// CLConfig holds our command-line configuration.
var CLConfig struct {
	Output string // (optional) output style ("line" or "CLI")
	Wrap   bool   // (optional) wrap output when CLI style
	Debug  bool   // (optional) prints dubugging info to stdout
	NoExit bool   // (optional) don't return a nonzero exit code on lint errors
}

// Config holds our .vale configuration.
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
	Checks        []string                   // All checks to load
	GBaseStyles   []string                   // Global base style
	GChecks       map[string]bool            // Global checks
	MinAlertLevel int                        // Lowest alert level to display
	SBaseStyles   map[string][]string        // Syntax-specific base styles
	SChecks       map[string]map[string]bool // Syntax-specific checks
	StylesPath    string                     // Directory with Rule.yml files
}

func newConfig() *config {
	var cfg config
	cfg.GChecks = make(map[string]bool)
	cfg.SBaseStyles = make(map[string][]string)
	cfg.SChecks = make(map[string]map[string]bool)
	cfg.MinAlertLevel = 0
	cfg.GBaseStyles = []string{"vale"}
	return &cfg
}

func determinePath(configPath string, keyPath string) string {
	sep := string(filepath.Separator)
	abs, _ := filepath.Abs(keyPath)
	rel := strings.TrimRight(keyPath, sep)
	if abs != rel || !strings.Contains(keyPath, sep) {
		// The path was relative
		return filepath.Join(configPath, keyPath)
	}
	return abs
}

// loadConfig loads the .vale file. It checks the current directory up to the
// user's home directory, stopping on the first occurrence of a .vale or _vale
// file.
func loadConfig(names []string) (*ini.File, string, error) {
	var configPath, dir string
	var iniFile *ini.File
	var err error

	count := 0
	for configPath == "" && count < 6 {
		if count == 0 {
			dir, _ = os.Getwd()
		} else {
			dir = filepath.Dir(dir)
		}
		for _, name := range names {
			loc := path.Join(dir, name)
			if FileExists(loc) {
				configPath = loc
				break
			}
		}
		count++
	}

	if configPath == "" {
		configPath, _ = homedir.Dir()
	}
	iniFile, err = ini.Load(configPath)
	return iniFile, dir, err
}

// loadOptions reads the .vale file.
func loadOptions() config {
	cfg := newConfig()
	uCfg, path, err := loadConfig([]string{".vale", "_vale"})
	if err != nil {
		return *cfg
	}

	core := uCfg.Section("")
	global := uCfg.Section("*")

	// Default settings
	for _, k := range core.KeyStrings() {
		if k == "StylesPath" {
			cfg.StylesPath = determinePath(path, core.Key(k).MustString(""))
		} else if k == "MinAlertLevel" {
			level := core.Key(k).In("suggestion", AlertLevels)
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
		syntaxOpts := make(map[string]bool)
		for _, k := range uCfg.Section(sec).KeyStrings() {
			if k == "BasedOnStyles" {
				cfg.SBaseStyles[sec] = uCfg.Section(sec).Key(k).Strings(",")
			} else {
				syntaxOpts[k] = uCfg.Section(sec).Key(k).MustBool(false)
				cfg.Checks = append(cfg.Checks, k)
			}
		}
		cfg.SChecks[sec] = syntaxOpts
	}

	return *cfg
}
