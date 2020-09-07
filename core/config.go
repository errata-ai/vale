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
	BlockIgnores   map[string][]string        // A list of blocks to ignore
	Checks         []string                   // All checks to load
	Formats        map[string]string          // A map of unknown -> known formats
	GBaseStyles    []string                   // Global base style
	GChecks        map[string]bool            // Global checks
	IgnoredClasses []string                   // A list of HTML classes to ignore
	IgnoredScopes  []string                   // A list of HTML tags to ignore
	MinAlertLevel  int                        // Lowest alert level to display
	Path           string                     // The location of the config file
	Project        string                     // The active project
	RuleToLevel    map[string]string          // Single-rule level changes
	SBaseStyles    map[string][]string        // Syntax-specific base styles
	SChecks        map[string]map[string]bool // Syntax-specific checks
	SkippedScopes  []string                   // A list of HTML blocks to ignore
	Stylesheets    map[string]string          // XSLT stylesheet
	StylesPath     string                     // Directory with Rule.yml files
	TokenIgnores   map[string][]string        // A list of tokens to ignore
	WordTemplate   string                     // The template used in YAML -> regexp list conversions

	AcceptedTokens map[string]struct{} `json:"-"` // Project-specific vocabulary (okay)
	RejectedTokens map[string]struct{} `json:"-"` // Project-specific vocabulary (avoid)

	SphinxBuild string // The location of Sphinx's `_build` path
	SphinxAuto  string // Should we call `sphinx-build`?

	FallbackPath string               `json:"-"`
	FsWrapper    *afero.Afero         `json:"-"`
	LTPath       string               `json:"-"`
	Parsers      map[string]string    `json:"-"`
	SecToPat     map[string]glob.Glob `json:"-"`
	Styles       []string             `json:"-"`
	Timeout      int                  `json:"-"`

	// Command-line configuration
	AlertLevel string `json:"-"` // (optional) a CLI-provided MinAlertLevel
	Debug      bool   `json:"-"` // (optional) print debugging information to stdout/stderr
	InExt      string `json:"-"` // (optional) extension to associate with stdin
	Local      bool   `json:"-"` // (optional) prioritize local config files
	NoExit     bool   `json:"-"` // (optional) don't return a nonzero exit code on lint errors
	Normalize  bool   `json:"-"` // (optional) replace each path separator with a slash ('/')
	Output     string `json:"-"` // (optional) output style ("line" or "CLI")
	Relative   bool   `json:"-"` // (optional) return relative paths
	Remote     bool   `json:"-"` // (optional) prioritize remote config files
	Simple     bool   `json:"-"` // (optional) lint all files line-by-line
	Sorted     bool   `json:"-"` // (optional) sort files by their name for output
	Sources    string `json:"-"` // (optional) a list of config files to load
	Wrap       bool   `json:"-"` // (optional) wrap output when CLI style
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
	cfg.AcceptedTokens = make(map[string]struct{})
	cfg.RejectedTokens = make(map[string]struct{})
	cfg.FsWrapper = &afero.Afero{Fs: afero.NewReadOnlyFs(afero.NewOsFs())}
	cfg.LTPath = "http://localhost:8081/v2/check"
	cfg.Timeout = 1
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
			if _, ok := c.AcceptedTokens[word]; !ok {
				c.AcceptedTokens[word] = struct{}{}
			}
		} else {
			if _, ok := c.RejectedTokens[word]; !ok {
				c.RejectedTokens[word] = struct{}{}
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

// Load reads the .vale/_vale file.
func (c *Config) Load() error {
	var base string
	var uCfg *ini.File
	var err error
	var sources []string

	names := []string{".vale", "_vale", "vale.ini", ".vale.ini", "_vale.ini", ""}
	home, _ := homedir.Dir()

	base = loadConfig(names, []string{"", home})
	if c.Sources != "" {
		for _, source := range strings.Split(c.Sources, ",") {
			abs, _ := filepath.Abs(source)
			sources = append(sources, abs)
		}
	} else {
		sources = []string{base, c.Path}
	}

	if c.Local && FileExists(base) && FileExists(c.Path) {
		uCfg, err = ini.ShadowLoad(c.Path, base)
	} else if c.Remote && FileExists(base) && FileExists(c.Path) {
		uCfg, err = ini.ShadowLoad(base, c.Path)
		c.Path = base
	} else if c.Sources != "" {
		uCfg, err = processSources(c, sources)
	} else {
		base = loadConfig(names, []string{c.Path, "", home})
		uCfg, err = ini.ShadowLoad(base)
		c.Path = base
	}

	if err != nil {
		return err
	} else if StringInSlice(c.AlertLevel, AlertLevels) {
		c.MinAlertLevel = LevelToInt[c.AlertLevel]
	}

	uCfg.BlockMode = false
	return processConfig(uCfg, c, sources)
}

func processSources(cfg *Config, sources []string) (*ini.File, error) {
	var uCfg *ini.File
	var err error

	if len(sources) == 0 {
		return uCfg, errors.New("no sources provided")
	} else if len(sources) == 1 {
		cfg.Path = sources[0]
		return ini.Load(cfg.Path)
	}

	t := sources[1:]
	s := make([]interface{}, len(t))
	for i, v := range t {
		s[i] = v
	}

	uCfg, err = ini.Load(sources[0], s...)
	cfg.Path = sources[len(sources)-1]

	return uCfg, err
}

func processConfig(uCfg *ini.File, cfg *Config, paths []string) error {
	core := uCfg.Section("")
	global := uCfg.Section("*")
	formats := uCfg.Section("formats")

	// Default settings
	for _, k := range core.KeyStrings() {
		if f, found := coreOpts[k]; found {
			f(core, cfg, paths)
		}
	}

	// Format mappings
	for _, k := range formats.KeyStrings() {
		cfg.Formats[k] = formats.Key(k).String()
	}

	// Global settings
	for _, k := range global.KeyStrings() {
		if f, found := globalOpts[k]; found {
			f(global, cfg, paths)
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
		syntaxMap := make(map[string]bool)
		for _, k := range uCfg.Section(sec).KeyStrings() {
			if f, found := syntaxOpts[k]; found {
				f(sec, uCfg.Section(sec), cfg)
			} else {
				syntaxMap[k] = validateLevel(k, uCfg.Section(sec).Key(k).String(), cfg)
				cfg.Checks = append(cfg.Checks, k)
			}
		}
		cfg.SChecks[sec] = syntaxMap
	}

	return nil
}
