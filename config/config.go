// Package config ...
package config

import (
	"bufio"
	"encoding/json"
	"io"
	"path/filepath"
	"strings"

	"github.com/gobwas/glob"
	"github.com/spf13/afero"
)

// Config ...
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

	Built string // A path to a pre-built file (e.g., an HTML file made from a Markdown file)

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
	InExt string `json:"-"` // (optional) extension to associate with stdin

	Simple bool `json:"-"` // (optional) lint all files line-by-line

	// source ...
	AlertLevel string `json:"-"` // (optional) a CLI-provided MinAlertLevel
	Local      bool   `json:"-"` // (optional) prioritize local config files
	Remote     bool   `json:"-"` // (optional) prioritize remote config files
	Sources    string `json:"-"` // (optional) a list of config files to load

	// remove?
	Debug bool `json:"-"` // (optional) print debugging information to stdout/stderr

	// ui ...
	Normalize bool   `json:"-"` // (optional) replace each path separator with a slash ('/')
	NoExit    bool   `json:"-"` // (optional) don't return a nonzero exit code on lint errors
	Relative  bool   `json:"-"` // (optional) return relative paths
	Sorted    bool   `json:"-"` // (optional) sort files by their name for output
	Output    string `json:"-"` // (optional) output style ("line" or "CLI")
	Wrap      bool   `json:"-"` // (optional) wrap output when CLI style
}

// New initializes a Config with its default values.
func New() (*Config, error) {
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
	cfg.Timeout = 2

	return &cfg, nil
}

// AddWordListFile adds vocab terms from a provided file.
func (c *Config) AddWordListFile(name string, accept bool) error {
	fd, err := c.FsWrapper.Open(name)
	defer fd.Close()
	if err != nil {
		return err
	}
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

func (c *Config) String() string {
	c.StylesPath = filepath.ToSlash(c.StylesPath)
	b, _ := json.MarshalIndent(c, "", "  ")
	return string(b)
}
