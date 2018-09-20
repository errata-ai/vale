package core

import (
	"os"
	"path"
	"path/filepath"
	"strings"

	"github.com/gobwas/glob"
	"github.com/mitchellh/go-homedir"
	ini "gopkg.in/ini.v1"
)

// Glob represents a glob pattern passed via `--glob`.
type Glob struct {
	Negated bool
	Pattern glob.Glob
}

// Match returns whether or not the Glob g matches the string query.
func (g Glob) Match(query string) bool {
	return g.Pattern.Match(query) != g.Negated
}

// NewGlob creates a Glob from the string pat.
func NewGlob(pat string) Glob {
	negate := false
	if strings.HasPrefix(pat, "!") {
		pat = strings.TrimLeft(pat, "!")
		negate = true
	}
	g, gerr := glob.Compile(pat)
	if !CheckError(gerr) {
		panic(gerr)
	}
	return Glob{Pattern: g, Negated: negate}
}

// AlertLevels holds the possible values for "level" in an external rule.
var AlertLevels = []string{"suggestion", "warning", "error"}

// LevelToInt allows us to easily compare levels in lint.go.
var LevelToInt = map[string]int{
	"suggestion": 0,
	"warning":    1,
	"error":      2,
}

// Config holds Vale's configuration, both from the CLI and its config file.
type Config struct {
	// General configuration
	Checks        []string                   // All checks to load
	GBaseStyles   []string                   // Global base style
	GChecks       map[string]bool            // Global checks
	IgnoredScopes []string                   // A list of HTML tags to ignore
	BlockIgnores  map[string][]string        // A list of blocks to ignore
	TokenIgnores  map[string][]string        // A list of tokens to ignore
	MinAlertLevel int                        // Lowest alert level to display
	RuleToLevel   map[string]string          // Single-rule level changes
	SBaseStyles   map[string][]string        // Syntax-specific base styles
	SChecks       map[string]map[string]bool // Syntax-specific checks
	StylesPath    string                     // Directory with Rule.yml files
	WordTemplate  string                     // The template used in YAML -> regexp list conversions
	Parsers       map[string]string          // A map of syntax -> commands
	Path          string                     // The location of the config file

	// Command-line configuration
	Output    string // (optional) output style ("line" or "CLI")
	Wrap      bool   // (optional) wrap output when CLI style
	NoExit    bool   // (optional) don't return a nonzero exit code on lint errors
	Sorted    bool   // (optional) sort files by their name for output
	Normalize bool   // (optional) replace each path separator with a slash ('/')
	Simple    bool   // (optional) lint all files line-by-line
	InExt     string // (optional) extension to associate with stdin
	Relative  bool   // (optional) return relative paths
}

// NewConfig initializes a Config.
func NewConfig() *Config {
	var cfg Config
	cfg.GChecks = make(map[string]bool)
	cfg.SBaseStyles = make(map[string][]string)
	cfg.SChecks = make(map[string]map[string]bool)
	cfg.MinAlertLevel = 1
	cfg.RuleToLevel = make(map[string]string)
	cfg.Parsers = make(map[string]string)
	cfg.BlockIgnores = make(map[string][]string)
	cfg.TokenIgnores = make(map[string][]string)
	return &cfg
}

func validateLevel(key string, val string, cfg *Config) bool {
	options := []string{"YES", "suggestion", "warning", "error"}
	if val == "NO" || !StringInSlice(val, options) {
		return false
	} else if val != "YES" {
		cfg.RuleToLevel[key] = val
	}
	return true
}

// loadConfig loads the .vale file. It checks the current directory up to the
// user's home directory, stopping on the first occurrence of a .vale or _vale
// file.
func loadConfig(names, paths []string) (*ini.File, string, error) {
	var configPath, dir string
	var iniFile *ini.File
	var err error
	var recur bool

	for _, start := range paths {
		count := 0
		for configPath == "" && count < 6 {
			recur = start == "" && count == 0
			if recur {
				dir, _ = os.Getwd()
			} else if count == 0 {
				dir = start
				count = 6
			} else {
				dir = filepath.Dir(dir)
			}
			for _, name := range names {
				loc := path.Join(dir, name)
				if FileExists(loc) && !IsDir(loc) {
					configPath = loc
					break
				}
			}
			count++
		}
	}

	iniFile, err = ini.Load(configPath)
	return iniFile, dir, err
}

// LoadConfig reads the .vale/_vale file.
func LoadConfig(cfg *Config, path string) *Config {
	names := []string{".vale", "_vale", "vale.ini", ".vale.ini", "_vale.ini", ""}
	home, _ := homedir.Dir()

	uCfg, path, err := loadConfig(names, []string{path, "", home})
	if err != nil {
		return cfg
	}

	cfg.Path = path
	core := uCfg.Section("")
	global := uCfg.Section("*")

	// Default settings
	for _, k := range core.KeyStrings() {
		if k == "StylesPath" {
			cfg.StylesPath = DeterminePath(path, core.Key(k).MustString(""))
		} else if k == "MinAlertLevel" {
			level := core.Key(k).In("warning", AlertLevels)
			cfg.MinAlertLevel = LevelToInt[level]
		} else if k == "IgnoredScopes" {
			cfg.IgnoredScopes = core.Key(k).Strings(",")
		} else if k == "WordTemplate" {
			cfg.WordTemplate = core.Key(k).String()
		}
	}

	// Global settings
	cfg.GBaseStyles = global.Key("BasedOnStyles").Strings(",")
	for _, k := range global.KeyStrings() {
		if k == "BasedOnStyles" {
			continue
		} else {
			cfg.GChecks[k] = validateLevel(k, global.Key(k).String(), cfg)
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
			} else if k == "IgnorePatterns" || k == "BlockIgnores" {
				cfg.BlockIgnores[sec] = uCfg.Section(sec).Key(k).Strings(",")
			} else if k == "TokenIgnores" {
				cfg.TokenIgnores[sec] = uCfg.Section(sec).Key(k).Strings(",")
			} else if k == "Parser" {
				cfg.Parsers[sec] = uCfg.Section(sec).Key(k).String()
			} else {
				syntaxOpts[k] = validateLevel(k, uCfg.Section(sec).Key(k).String(), cfg)
				cfg.Checks = append(cfg.Checks, k)
			}
		}
		cfg.SChecks[sec] = syntaxOpts
	}

	return cfg
}
