package core

import (
	"bufio"
	"encoding/json"
	"io"
	"os"
	"path/filepath"
	"strings"

	"github.com/gobwas/glob"
)

// CLIFlags holds the values that are defined at rumtime by the user.
//
// For example, `vale --minAlertLevel=error`.
type CLIFlags struct {
	AlertLevel string
	Built      string
	Glob       string
	InExt      string
	Local      bool
	NoExit     bool
	Normalize  bool
	Output     string
	Path       string
	Relative   bool
	Remote     bool
	Simple     bool
	Sorted     bool
	Sources    string
	Wrap       bool
}

// Config holds the the configuration values from both the CLI and `.vale.ini`.
type Config struct {
	// General configuration
	BlockIgnores   map[string][]string        // A list of blocks to ignore
	Checks         []string                   // All checks to load
	Formats        map[string]string          // A map of unknown -> known formats
	FormatToLang   map[string]string          // A map of format to lang ID
	GBaseStyles    []string                   // Global base style
	GChecks        map[string]bool            // Global checks
	IgnoredClasses []string                   // A list of HTML classes to ignore
	IgnoredScopes  []string                   // A list of HTML tags to ignore
	MinAlertLevel  int                        // Lowest alert level to display
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

	DictionaryPath string // Location to search for dictionaries.

	// TODO: Remove these.
	SphinxBuild string `json:"-"` // The location of Sphinx's `_build` path
	SphinxAuto  string `json:"-"` // Should we call `sphinx-build`?

	FallbackPath string               `json:"-"`
	LTPath       string               `json:"-"`
	SecToPat     map[string]glob.Glob `json:"-"`
	Styles       []string             `json:"-"`
	Timeout      int                  `json:"-"`
	Paths        []string             `json:"-"`

	NLPEndpoint string // An external API to call for NLP-related work.

	// Command-line configuration
	Flags *CLIFlags `json:"-"`
}

// NewConfig initializes a Config with its default values.
func NewConfig(flags *CLIFlags) (*Config, error) {
	var cfg Config

	cfg.AcceptedTokens = make(map[string]struct{})
	cfg.BlockIgnores = make(map[string][]string)
	cfg.Flags = flags
	cfg.Formats = make(map[string]string)
	cfg.GChecks = make(map[string]bool)
	cfg.LTPath = "http://localhost:8081/v2/check"
	cfg.MinAlertLevel = 1
	cfg.RejectedTokens = make(map[string]struct{})
	cfg.RuleToLevel = make(map[string]string)
	cfg.SBaseStyles = make(map[string][]string)
	cfg.SChecks = make(map[string]map[string]bool)
	cfg.SecToPat = make(map[string]glob.Glob)
	cfg.Stylesheets = make(map[string]string)
	cfg.Timeout = 2
	cfg.TokenIgnores = make(map[string][]string)
	cfg.Paths = []string{""}
	cfg.FormatToLang = make(map[string]string)

	return &cfg, nil
}

// AddWordListFile adds vocab terms from a provided file.
func (c *Config) AddWordListFile(name string, accept bool) error {
	fd, err := os.Open(name)
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
