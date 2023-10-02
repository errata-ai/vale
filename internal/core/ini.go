package core

import (
	"errors"
	"fmt"
	"os"
	"path"
	"path/filepath"
	"strings"

	"github.com/errata-ai/ini"
	"github.com/errata-ai/vale/v2/internal/glob"
)

var configNames = []string{
	".vale",
	"_vale",
	"vale.ini",
	".vale.ini",
	"_vale.ini",
}

var syntaxOpts = map[string]func(string, *ini.Section, *Config) error{
	"BasedOnStyles": func(lbl string, sec *ini.Section, cfg *Config) error {
		pat, err := glob.Compile(lbl)
		if err != nil {
			return NewE201FromTarget(
				fmt.Sprintf("The glob pattern '%s' could not be compiled.", lbl),
				lbl,
				cfg.Flags.Path)
		} else if _, found := cfg.SecToPat[lbl]; !found {
			cfg.SecToPat[lbl] = pat
		}
		sStyles := mergeValues(sec.Key("BasedOnStyles").StringsWithShadows(","))

		cfg.Styles = append(cfg.Styles, sStyles...)
		cfg.StyleKeys = append(cfg.StyleKeys, lbl)
		cfg.SBaseStyles[lbl] = sStyles

		return nil
	},
	"IgnorePatterns": func(label string, sec *ini.Section, cfg *Config) error { //nolint:unparam
		cfg.BlockIgnores[label] = sec.Key("IgnorePatterns").Strings(",")
		return nil
	},
	"BlockIgnores": func(label string, sec *ini.Section, cfg *Config) error { //nolint:unparam
		cfg.BlockIgnores[label] = mergeValues(sec.Key("BlockIgnores").StringsWithShadows(","))
		return nil
	},
	"TokenIgnores": func(label string, sec *ini.Section, cfg *Config) error { //nolint:unparam
		cfg.TokenIgnores[label] = mergeValues(sec.Key("TokenIgnores").StringsWithShadows(","))
		return nil
	},
	"Transform": func(label string, sec *ini.Section, cfg *Config) error { //nolint:unparam
		candidate := sec.Key("Transform").String()
		cfg.Stylesheets[label] = determinePath(cfg.Flags.Path, candidate)
		return nil

	},
	"Lang": func(label string, sec *ini.Section, cfg *Config) error { //nolint:unparam
		cfg.FormatToLang[label] = sec.Key("Lang").String()
		return nil
	},
}

var globalOpts = map[string]func(*ini.Section, *Config, []string){
	"BasedOnStyles": func(sec *ini.Section, cfg *Config, _ []string) {
		cfg.GBaseStyles = mergeValues(sec.Key("BasedOnStyles").StringsWithShadows(","))
		cfg.Styles = append(cfg.Styles, cfg.GBaseStyles...)
	},
	"IgnorePatterns": func(sec *ini.Section, cfg *Config, _ []string) {
		cfg.BlockIgnores["*"] = sec.Key("IgnorePatterns").Strings(",")
	},
	"BlockIgnores": func(sec *ini.Section, cfg *Config, _ []string) {
		cfg.BlockIgnores["*"] = mergeValues(sec.Key("BlockIgnores").StringsWithShadows(","))
	},
	"TokenIgnores": func(sec *ini.Section, cfg *Config, _ []string) {
		cfg.TokenIgnores["*"] = mergeValues(sec.Key("TokenIgnores").StringsWithShadows(","))
	},
	"Lang": func(sec *ini.Section, cfg *Config, _ []string) {
		cfg.FormatToLang["*"] = sec.Key("Lang").String()
	},
}

var coreOpts = map[string]func(*ini.Section, *Config, []string) error{
	"StylesPath": func(sec *ini.Section, cfg *Config, args []string) error {
		paths := sec.Key("StylesPath").ValueWithShadows()
		if cfg.Flags.Local && len(paths) == 2 {
			basePath := determinePath(args[0], filepath.FromSlash(paths[1]))
			mockPath := determinePath(args[1], filepath.FromSlash(paths[0]))
			cfg.Paths = []string{basePath, mockPath}
			cfg.StylesPath = basePath
		} else {
			entry := paths[len(paths)-1]
			candidate := filepath.FromSlash(entry)

			cfg.StylesPath = determinePath(cfg.Flags.Path, candidate)
			if !FileExists(cfg.StylesPath) {
				return NewE201FromTarget(
					fmt.Sprintf("The path '%s' does not exist.", cfg.StylesPath),
					entry,
					cfg.Flags.Path)
			}

			cfg.Paths = []string{cfg.StylesPath}
		}
		return nil
	},
	"MinAlertLevel": func(sec *ini.Section, cfg *Config, _ []string) error {
		if !StringInSlice(cfg.Flags.AlertLevel, AlertLevels) {
			level := sec.Key("MinAlertLevel").String() // .In("suggestion", AlertLevels)
			if index, found := LevelToInt[level]; found {
				cfg.MinAlertLevel = index
			} else {
				return NewE201FromTarget(
					"MinAlertLevel must be 'suggestion', 'warning', or 'error'.",
					level,
					cfg.Flags.Path)
			}
		}
		return nil
	},
	"IgnoredScopes": func(sec *ini.Section, cfg *Config, _ []string) error { //nolint:unparam
		cfg.IgnoredScopes = mergeValues(sec.Key("IgnoredScopes").StringsWithShadows(","))
		return nil
	},
	"WordTemplate": func(sec *ini.Section, cfg *Config, _ []string) error { //nolint:unparam
		cfg.WordTemplate = sec.Key("WordTemplate").String()
		return nil
	},
	"DictionaryPath": func(sec *ini.Section, cfg *Config, _ []string) error { //nolint:unparam
		cfg.DictionaryPath = sec.Key("DictionaryPath").String()
		return nil
	},
	"SkippedScopes": func(sec *ini.Section, cfg *Config, _ []string) error { //nolint:unparam
		cfg.SkippedScopes = mergeValues(sec.Key("SkippedScopes").StringsWithShadows(","))
		return nil
	},
	"IgnoredClasses": func(sec *ini.Section, cfg *Config, _ []string) error { //nolint:unparam
		cfg.IgnoredClasses = mergeValues(sec.Key("IgnoredClasses").StringsWithShadows(","))
		return nil
	},
	"Vocab": func(sec *ini.Section, cfg *Config, _ []string) error {
		cfg.Vocab = mergeValues(sec.Key("Vocab").StringsWithShadows(","))
		for _, v := range cfg.Vocab {
			if err := loadVocab(v, cfg); err != nil {
				return err
			}
		}
		return nil
	},
	"NLPEndpoint": func(sec *ini.Section, cfg *Config, _ []string) error { //nolint:unparam
		cfg.NLPEndpoint = sec.Key("NLPEndpoint").MustString("")
		return nil
	},
}

func shadowLoad(source interface{}, others ...interface{}) (*ini.File, error) {
	return ini.LoadSources(ini.LoadOptions{
		AllowShadows:             true,
		SpaceBeforeInlineComment: true}, source, others...)
}

func loadINI(cfg *Config, dry bool) error {
	var uCfg *ini.File
	var sources []string

	base, err := loadConfig(configNames)
	if err != nil {
		return NewE100("loadINI/homedir", err)
	}
	cfg.RootINI = base

	if cfg.Flags.Sources != "" {
		for _, source := range strings.Split(cfg.Flags.Sources, ",") {
			abs, _ := filepath.Abs(source)
			sources = append(sources, abs)
		}
	}

	fromEnv, hasEnv := os.LookupEnv("VALE_CONFIG_PATH")
	if cfg.Flags.Sources != "" { //nolint:gocritic
		// We have multiple sources -- e.g., local config + remote package(s).
		//
		// See fixtures/config.feature#451 for an explanation of how this has
		// changed since Vale Server was deprecated.
		uCfg, err = processSources(cfg, sources)
		if err != nil {
			return NewE100("config pipeline failed", err)
		}
	} else if cfg.Flags.Path != "" {
		// We've been given a value through `--config`.
		uCfg, err = shadowLoad(cfg.Flags.Path)
		if err != nil {
			return NewE100("invalid --config", err)
		}
		cfg.Root = filepath.Dir(cfg.Flags.Path)
	} else if hasEnv {
		// We've been given a value through `VALE_CONFIG_PATH`.
		uCfg, err = shadowLoad(fromEnv)
		if err != nil {
			return NewE100("invalid VALE_CONFIG_PATH", err)
		}
		cfg.Root = filepath.Dir(fromEnv)
		cfg.Flags.Path = fromEnv
	} else {
		// We're using a config file found using a local search process.
		uCfg, err = shadowLoad(base)
		if err != nil {
			return NewE100(".vale.ini not found", err)
		}
		cfg.Root = filepath.Dir(base)
		cfg.Flags.Path = base
	}

	if StringInSlice(cfg.Flags.AlertLevel, AlertLevels) {
		cfg.MinAlertLevel = LevelToInt[cfg.Flags.AlertLevel]
	}

	uCfg.BlockMode = false
	return processConfig(uCfg, cfg, sources, dry)
}

// loadConfig loads the .vale file. It checks the ancestors of the current
// directory, stopping on the first occurrence of a .vale or _vale file. If
// no ancestor of the current directory has a configuration file, it checks
// the user's home directory for a configuration file.
func loadConfig(names []string) (string, error) {
	var parent string

	cwd, err := os.Getwd()
	if err != nil {
		return "", err
	}

	for {
		parent = filepath.Dir(cwd)

		for _, name := range names {
			loc := path.Join(cwd, name)
			if FileExists(loc) && !IsDir(loc) {
				return loc, nil
			}
		}

		if cwd == parent {
			break
		}
		cwd = parent
	}

	homeDir, err := os.UserHomeDir()
	if err != nil {
		return "", err
	}

	for _, name := range names {
		loc := path.Join(homeDir, name)
		if FileExists(loc) && !IsDir(loc) {
			return loc, nil
		}
	}

	return "", nil
}

func processSources(cfg *Config, sources []string) (*ini.File, error) {
	var uCfg *ini.File
	var err error

	if len(sources) == 0 {
		return uCfg, errors.New("no sources provided")
	} else if len(sources) == 1 {
		cfg.Flags.Path = sources[0]
		return shadowLoad(cfg.Flags.Path)
	}

	t := sources[1:]
	s := make([]interface{}, len(t))
	for i, v := range t {
		s[i] = v
	}

	uCfg, err = shadowLoad(sources[0], s...)
	cfg.Flags.Path = sources[len(sources)-1]

	return uCfg, err
}

func processConfig(uCfg *ini.File, cfg *Config, paths []string, dry bool) error {
	core := uCfg.Section("")
	global := uCfg.Section("*")

	formats := uCfg.Section("formats")
	adoc := uCfg.Section("asciidoctor")

	// Default settings
	for _, k := range core.KeyStrings() {
		if f, found := coreOpts[k]; found {
			if err := f(core, cfg, paths); err != nil && !dry {
				return err
			}
		} else if _, found = syntaxOpts[k]; found {
			msg := fmt.Sprintf("'%s' is a syntax-specific option", k)
			return NewE201FromTarget(msg, k, cfg.RootINI)
		}
	}

	// Format mappings
	for _, k := range formats.KeyStrings() {
		cfg.Formats[k] = formats.Key(k).String()
	}

	// Asciidoctor attributes
	for _, k := range adoc.KeyStrings() {
		cfg.Asciidoctor[k] = adoc.Key(k).String()
	}

	// Global settings
	for _, k := range global.KeyStrings() {
		if f, found := globalOpts[k]; found {
			f(global, cfg, paths)
		} else if _, found = syntaxOpts[k]; found {
			msg := fmt.Sprintf("'%s' is a syntax-specific option", k)
			return NewE201FromTarget(msg, k, cfg.RootINI)
		} else {
			cfg.GChecks[k] = validateLevel(k, global.Key(k).String(), cfg)
			cfg.Checks = append(cfg.Checks, k)
		}
	}

	// Syntax-specific settings
	for _, sec := range uCfg.SectionStrings() {
		if StringInSlice(sec, []string{"*", "DEFAULT", "formats", "asciidoctor"}) {
			continue
		}

		pat, err := glob.Compile(sec)
		if err != nil {
			return err
		}
		cfg.SecToPat[sec] = pat

		syntaxMap := make(map[string]bool)
		for _, k := range uCfg.Section(sec).KeyStrings() {
			if f, found := syntaxOpts[k]; found {
				if err = f(sec, uCfg.Section(sec), cfg); err != nil && !dry {
					return err
				}
			} else {
				syntaxMap[k] = validateLevel(k, uCfg.Section(sec).Key(k).String(), cfg)
				cfg.Checks = append(cfg.Checks, k)
			}
		}
		cfg.RuleKeys = append(cfg.RuleKeys, sec)
		cfg.SChecks[sec] = syntaxMap
	}

	return nil
}
