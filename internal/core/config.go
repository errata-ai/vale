package core

import (
	"bufio"
	"encoding/json"
	"errors"
	"io"
	"os"
	"path/filepath"
	"strings"

	"github.com/adrg/xdg"
	"github.com/bmatcuk/doublestar/v4"
	"github.com/errata-ai/ini"

	"github.com/errata-ai/vale/v2/internal/glob"
)

var (
	// ConfigDir is the default location for Vale's configuration files.
	//
	// This was introduced in v3.0.0 as a means of standardizing the location
	// of Vale's configuration files.
	//
	// This directory is relative to the user's specified `StylesPath`, which
	// can be set via the `--config` flag, the `VALE_CONFIG_PATH` environment
	// variable, or the default search process.
	//
	// NOTE: The config pipeline is stored in the top-level `.vale-config`
	// directory. See `cmd/vale/sync.go`.
	ConfigDir = "config"

	VocabDir  = filepath.Join(ConfigDir, "vocabularies")
	DictDir   = filepath.Join(ConfigDir, "dictionaries")
	TmplDir   = filepath.Join(ConfigDir, "templates")
	IgnoreDir = filepath.Join(ConfigDir, "ignore")
)

// ConfigDirs is a list of all directories that contain user-defined, non-style
// configuration files.
var ConfigDirs = []string{VocabDir, DictDir, TmplDir, IgnoreDir}

// ConfigNames is a list of all possible configuration file names.
//
// NOTE: This is leftover from the early days of Vale; we have now standardized
// on `.vale.ini` for documentation purposes.
var configNames = []string{
	".vale",
	"_vale",
	"vale.ini",
	".vale.ini",
	"_vale.ini",
}

// IgnoreFiles returns a list of all user-defined ignore files.
func IgnoreFiles(stylesPath string) ([]string, error) {
	ignore := filepath.Join(stylesPath, IgnoreDir)
	return doublestar.FilepathGlob(filepath.Join(ignore, "**", "*.txt"))
}

// DefaultConfig returns the path to the default configuration file.
//
// We don't create this file automatically because there's no actual notion of
// a "default" configuration -- it's just a file loation.
//
// NOTE: if this file does not exist *and* the user has not specified a
// project-specific configuration file, Vale raises an error.
func DefaultConfig() (string, error) {
	root := xdg.ConfigHome
	if root == "" {
		return "", errors.New("unable to find XDG_CONFIG_HOME")
	}
	return filepath.Join(root, "vale", ".vale.ini"), nil
}

// DefaultStylesPath returns the path to the default styles directory.
//
// NOTE: the default styles directory is only used if neither the
// project-specific nor the global configuration file specify a `StylesPath`.
func DefaultStylesPath() (string, error) {
	root := xdg.DataHome
	if root == "" {
		return "", errors.New("unable to find XDG_DATA_HOME")
	}
	styles := filepath.Join(root, "vale", "styles")

	err := os.MkdirAll(styles, os.ModePerm)
	if err != nil {
		return "", err
	}

	return styles, nil
}

// CLIFlags holds the values that are defined at runtime by the user.
//
// For example, `vale --minAlertLevel=error`.
type CLIFlags struct {
	AlertLevel   string
	Built        string
	Glob         string
	InExt        string
	Output       string
	Path         string
	Sources      string
	Filter       string
	Local        bool
	NoExit       bool
	Normalize    bool
	Relative     bool
	Remote       bool
	Simple       bool
	Sorted       bool
	Wrap         bool
	Version      bool
	Help         bool
	IgnoreGlobal bool
}

// Config holds the configuration values from both the CLI and `.vale.ini`.
type Config struct {
	// General configuration
	BlockIgnores   map[string][]string        // A list of blocks to ignore
	Checks         []string                   // All checks to load
	Formats        map[string]string          // A map of unknown -> known formats
	Asciidoctor    map[string]string          // A map of asciidoctor attributes
	FormatToLang   map[string]string          // A map of format to lang ID
	GBaseStyles    []string                   // Global base style
	GChecks        map[string]bool            // Global checks
	IgnoredClasses []string                   // A list of HTML classes to ignore
	IgnoredScopes  []string                   // A list of HTML tags to ignore
	MinAlertLevel  int                        // Lowest alert level to display
	Vocab          []string                   // The active project
	RuleToLevel    map[string]string          // Single-rule level changes
	SBaseStyles    map[string][]string        // Syntax-specific base styles
	SChecks        map[string]map[string]bool // Syntax-specific checks
	SkippedScopes  []string                   // A list of HTML blocks to ignore
	Stylesheets    map[string]string          // XSLT stylesheet
	StylesPath     string                     // Directory with Rule.yml files
	TokenIgnores   map[string][]string        // A list of tokens to ignore
	WordTemplate   string                     // The template used in YAML -> regexp list conversions
	RootINI        string                     // the path to the project's .vale.ini file

	AcceptedTokens map[string]struct{} `json:"-"` // Project-specific vocabulary (okay)
	RejectedTokens map[string]struct{} `json:"-"` // Project-specific vocabulary (avoid)

	DictionaryPath string // Location to search for dictionaries.

	FallbackPath string               `json:"-"`
	SecToPat     map[string]glob.Glob `json:"-"`
	Styles       []string             `json:"-"`
	Paths        []string             `json:"-"`
	ConfigFiles  []string             `json:"-"`

	NLPEndpoint string // An external API to call for NLP-related work.

	// Command-line configuration
	Flags *CLIFlags `json:"-"`

	StyleKeys []string `json:"-"`
	RuleKeys  []string `json:"-"`
}

// NewConfig initializes a Config with its default values.
func NewConfig(flags *CLIFlags) (*Config, error) {
	var cfg Config

	cfg.AcceptedTokens = make(map[string]struct{})
	cfg.BlockIgnores = make(map[string][]string)
	cfg.Flags = flags
	cfg.Formats = make(map[string]string)
	cfg.Asciidoctor = make(map[string]string)
	cfg.GChecks = make(map[string]bool)
	cfg.MinAlertLevel = 1
	cfg.RejectedTokens = make(map[string]struct{})
	cfg.RuleToLevel = make(map[string]string)
	cfg.SBaseStyles = make(map[string][]string)
	cfg.SChecks = make(map[string]map[string]bool)
	cfg.SecToPat = make(map[string]glob.Glob)
	cfg.Stylesheets = make(map[string]string)
	cfg.TokenIgnores = make(map[string][]string)
	cfg.FormatToLang = make(map[string]string)
	cfg.Paths = []string{""}
	cfg.ConfigFiles = []string{}

	found, err := DefaultStylesPath()
	if err != nil {
		return &cfg, err
	}

	if !flags.IgnoreGlobal {
		cfg.StylesPath = found
		cfg.Paths = []string{found}
	}

	return &cfg, nil
}

// AddWordListFile adds vocab terms from a provided file.
func (c *Config) AddWordListFile(name string, accept bool) error {
	fd, err := os.Open(name)
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
		if len(word) == 0 || strings.HasPrefix(word, "# ") { //nolint:gocritic
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
	return scanner.Err()
}

func (c *Config) String() string {
	c.StylesPath = filepath.ToSlash(c.StylesPath)
	b, _ := json.MarshalIndent(c, "", "  ")
	return string(b)
}

// Get the user-defined packages from a `.vale.ini` file.
func GetPackages(src string) ([]string, error) {
	packages := []string{}

	uCfg, err := ini.Load(src)
	if err != nil {
		return packages, err
	}

	core := uCfg.Section("")
	return core.Key("Packages").Strings(","), nil
}

func GetStylesPath(src string) (string, error) {
	uCfg, err := ini.Load(src)
	if err != nil {
		return "", err
	}

	fallback, err := DefaultStylesPath()
	if err != nil {
		return "", err
	}

	core := uCfg.Section("")
	return core.Key("StylesPath").MustString(fallback), nil
}

func pipeConfig(cfg *Config) ([]string, error) {
	var sources []string

	pipeline := filepath.Join(cfg.StylesPath, ".vale-config")
	if IsDir(pipeline) && len(cfg.Flags.Sources) == 0 {
		configs, err := os.ReadDir(pipeline)
		if err != nil {
			return sources, err
		}

		for _, config := range configs {
			if config.IsDir() {
				continue
			}
			sources = append(sources, filepath.Join(pipeline, config.Name()))
		}
	}

	return sources, nil
}
