package core

import (
	"bufio"
	"errors"
	"io"
	"os"
	"path"
	"path/filepath"
	"strings"

	"github.com/gobwas/glob"
	"github.com/mitchellh/go-homedir"
	"github.com/spf13/afero"
	"gopkg.in/ini.v1"
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
func NewGlob(pat string, debug bool) Glob {
	negate := false
	if strings.HasPrefix(pat, "!") {
		pat = strings.TrimLeft(pat, "!")
		negate = true
	}
	g, gerr := glob.Compile(pat)
	if !CheckError(gerr, debug) {
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
	Blacklist     map[string]struct{}        // Project-specific vocabulary (avoid)
	BlockIgnores  map[string][]string        // A list of blocks to ignore
	Checks        []string                   // All checks to load
	Formats       map[string]string          // A map of unknown -> known formats
	GBaseStyles   []string                   // Global base style
	GChecks       map[string]bool            // Global checks
	IgnoredScopes []string                   // A list of HTML tags to ignore
	MinAlertLevel int                        // Lowest alert level to display
	Parsers       map[string]string          // A map of syntax -> commands
	Path          string                     // The location of the config file
	Project       string                     // The active project
	RuleToLevel   map[string]string          // Single-rule level changes
	SBaseStyles   map[string][]string        // Syntax-specific base styles
	SChecks       map[string]map[string]bool // Syntax-specific checks
	SkippedScopes []string                   // A list of HTML blocks to ignore
	Stylesheets   map[string]string          // XSLT stylesheet
	StylesPath    string                     // Directory with Rule.yml files
	TokenIgnores  map[string][]string        // A list of tokens to ignore
	Whitelist     map[string]struct{}        // Project-specific vocabulary (okay)
	WordTemplate  string                     // The template used in YAML -> regexp list conversions

	SphinxBuild string // The location of Sphinx's `_build` path
	SphinxAuto  string // Should we call `sphinx-build`?

	SecToPat     map[string]glob.Glob `json:"-"`
	FsWrapper    *afero.Afero         `json:"-"`
	FallbackPath string               `json:"-"`
	LTPath       string               `json:"-"`
	AuthToken    string               `json:"-"`
	Styles       []string             `json:"-"`

	// Command-line configuration
	Debug     bool   // (optional) print debugging information to stdout/stderr
	InExt     string // (optional) extension to associate with stdin
	NoExit    bool   // (optional) don't return a nonzero exit code on lint errors
	Normalize bool   // (optional) replace each path separator with a slash ('/')
	Output    string // (optional) output style ("line" or "CLI")
	Relative  bool   // (optional) return relative paths
	Simple    bool   // (optional) lint all files line-by-line
	Sorted    bool   // (optional) sort files by their name for output
	Wrap      bool   // (optional) wrap output when CLI style
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
	cfg.Stylesheets = make(map[string]string)
	cfg.Formats = make(map[string]string)
	cfg.BlockIgnores = make(map[string][]string)
	cfg.TokenIgnores = make(map[string][]string)
	cfg.SecToPat = make(map[string]glob.Glob)
	cfg.Whitelist = make(map[string]struct{})
	cfg.Blacklist = make(map[string]struct{})
	cfg.FsWrapper = &afero.Afero{Fs: afero.NewReadOnlyFs(afero.NewOsFs())}
	cfg.LTPath = "http://localhost:8081/v2/check"
	return &cfg
}

func (c *Config) addWordListFile(name string, accept bool) error {
	fd, err := c.FsWrapper.Open(name)
	if err != nil {
		return err
	}
	defer fd.Close()
	return c.addWordList(fd, accept)
}

func (c *Config) addWordList(r io.Reader, accept bool) error {
	scanner := bufio.NewScanner(r)
	for scanner.Scan() {
		word := strings.TrimSpace(scanner.Text())
		if len(word) == 0 || word == "#" {
			continue
		} else if accept {
			if _, ok := c.Whitelist[word]; !ok {
				c.Whitelist[word] = struct{}{}
			}
		} else {
			if _, ok := c.Blacklist[word]; !ok {
				c.Blacklist[word] = struct{}{}
			}
		}
	}
	if err := scanner.Err(); err != nil {
		return err
	}
	return nil
}

func loadVocab(root string, config *Config) error {
	root = filepath.Join(config.StylesPath, "Vocab", root)

	err := config.FsWrapper.Walk(root, func(fp string, fi os.FileInfo, err error) error {
		if filepath.Base(fp) == "accept.txt" {
			config.addWordListFile(fp, true)
		} else if filepath.Base(fp) == "reject.txt" {
			config.addWordListFile(fp, false)
		}
		return nil
	})

	return err
}

func mergeValues(shadows []string) []string {
	values := []string{}
	for _, v := range shadows {
		for _, s := range strings.Split(v, ",") {
			entry := strings.TrimSpace(s)
			if entry != "" && !StringInSlice(entry, values) {
				values = append(values, entry)
			}
		}
	}
	return values
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
func loadConfig(names, paths []string) string {
	var configPath, dir string
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
					if name == "" {
						dir = filepath.Dir(configPath)
					}
					break
				}
			}
			count++
		}
	}

	return configPath
}

// LoadConfig reads the .vale/_vale file.
func LoadConfig(cfg *Config, upath string, min string, compat, rev bool) (*Config, error) {
	var base string
	var uCfg *ini.File
	var err error

	names := []string{".vale", "_vale", "vale.ini", ".vale.ini", "_vale.ini", ""}
	home, _ := homedir.Dir()

	base = loadConfig(names, []string{"", home})
	if compat && FileExists(base) && FileExists(upath) {
		uCfg, err = ini.ShadowLoad(upath, base)
		cfg.Path = upath
	} else if rev && FileExists(base) && FileExists(upath) {
		uCfg, err = ini.ShadowLoad(base, upath)
		cfg.Path = base
	} else {
		base = loadConfig(names, []string{upath, "", home})
		uCfg, err = ini.ShadowLoad(base)
		cfg.Path = base
	}

	if err != nil {
		return cfg, err
	} else if StringInSlice(min, AlertLevels) {
		cfg.MinAlertLevel = LevelToInt[min]
	}

	core := uCfg.Section("")
	global := uCfg.Section("*")
	formats := uCfg.Section("formats")

	// Default settings
	for _, k := range core.KeyStrings() {
		if k == "StylesPath" {
			paths := core.Key(k).ValueWithShadows()
			if compat && len(paths) == 2 {
				basePath := DeterminePath(base, filepath.FromSlash(paths[1]))
				mockPath := DeterminePath(upath, filepath.FromSlash(paths[0]))
				if basePath != mockPath {
					baseFs := cfg.FsWrapper.Fs
					mockFs := afero.NewMemMapFs()
					if CheckError(CopyDir(baseFs, basePath, mockFs, mockPath), cfg.Debug) {
						cfg.FsWrapper.Fs = afero.NewCopyOnWriteFs(baseFs, mockFs)
						cfg.FallbackPath = mockPath
					}
				}
			}
			cfg.StylesPath = cfg.FallbackPath
			if cfg.StylesPath == "" {
				canidate := filepath.FromSlash(core.Key(k).MustString(""))
				cfg.StylesPath = DeterminePath(cfg.Path, canidate)
			}
		} else if k == "MinAlertLevel" {
			if !StringInSlice(min, AlertLevels) {
				level := core.Key(k).In("suggestion", AlertLevels)
				cfg.MinAlertLevel = LevelToInt[level]
			}
		} else if k == "IgnoredScopes" {
			cfg.IgnoredScopes = mergeValues(core.Key(k).ValueWithShadows())
		} else if k == "WordTemplate" {
			cfg.WordTemplate = core.Key(k).String()
		} else if k == "SkippedScopes" {
			cfg.SkippedScopes = mergeValues(core.Key(k).ValueWithShadows())
		} else if k == "Project" {
			cfg.Project = core.Key(k).String()
			loadVocab(cfg.Project, cfg)
		} else if k == "LTPath" {
			cfg.LTPath = core.Key(k).String()
		} else if k == "SphinxBuildPath" {
			canidate := filepath.FromSlash(core.Key(k).MustString(""))
			cfg.SphinxBuild = DeterminePath(cfg.Path, canidate)
		} else if k == "SphinxAutoBuild" {
			cfg.SphinxAuto = core.Key(k).MustString("")
		} else {
			CheckError(errors.New("unknown key: '"+k+"'"), cfg.Debug)
		}
	}
	// Format mappings
	for _, k := range formats.KeyStrings() {
		cfg.Formats[k] = formats.Key(k).String()
	}

	// Global settings
	for _, k := range global.KeyStrings() {
		sec := "*"
		if k == "BasedOnStyles" {
			cfg.GBaseStyles = mergeValues(global.Key("BasedOnStyles").ValueWithShadows())
			cfg.Styles = append(cfg.Styles, cfg.GBaseStyles...)
		} else if k == "IgnorePatterns" || k == "BlockIgnores" {
			cfg.BlockIgnores[sec] = mergeValues(uCfg.Section(sec).Key(k).ValueWithShadows())
		} else if k == "TokenIgnores" {
			cfg.TokenIgnores[sec] = mergeValues(uCfg.Section(sec).Key(k).ValueWithShadows())
		} else {
			cfg.GChecks[k] = validateLevel(k, global.Key(k).String(), cfg)
			cfg.Checks = append(cfg.Checks, k)
		}
	}

	// Syntax-specific settings
	for _, sec := range uCfg.SectionStrings() {
		if sec == "*" || sec == "DEFAULT" || sec == "formats" {
			continue
		}
		pat, err := glob.Compile(sec)
		if CheckError(err, cfg.Debug) {
			cfg.SecToPat[sec] = pat
		}
		syntaxOpts := make(map[string]bool)
		for _, k := range uCfg.Section(sec).KeyStrings() {
			if k == "BasedOnStyles" {
				pat, err := glob.Compile(sec)
				if _, found := cfg.SecToPat[sec]; !found && CheckError(err, cfg.Debug) {
					cfg.SecToPat[sec] = pat
				}
				sStyles := mergeValues(uCfg.Section(sec).Key(k).ValueWithShadows())

				cfg.Styles = append(cfg.Styles, sStyles...)
				cfg.SBaseStyles[sec] = sStyles
			} else if k == "IgnorePatterns" || k == "BlockIgnores" {
				cfg.BlockIgnores[sec] = mergeValues(uCfg.Section(sec).Key(k).ValueWithShadows())
			} else if k == "TokenIgnores" {
				cfg.TokenIgnores[sec] = mergeValues(uCfg.Section(sec).Key(k).ValueWithShadows())
			} else if k == "Parser" {
				cfg.Parsers[sec] = uCfg.Section(sec).Key(k).String()
			} else if k == "Transform" {
				canidate := uCfg.Section(sec).Key(k).String()
				abs, _ := filepath.Abs(canidate)
				cfg.Stylesheets[sec] = filepath.FromSlash(abs)
			} else {
				syntaxOpts[k] = validateLevel(k, uCfg.Section(sec).Key(k).String(), cfg)
				cfg.Checks = append(cfg.Checks, k)
			}
		}
		cfg.SChecks[sec] = syntaxOpts
	}

	return cfg, err
}
