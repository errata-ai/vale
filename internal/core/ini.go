package core

import (
	"errors"
	"fmt"
	"os"
	"path"
	"path/filepath"
	"strings"

	"github.com/errata-ai/ini"
	"github.com/gobwas/glob"
)

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
		cfg.SBaseStyles[lbl] = sStyles

		return nil
	},
	"IgnorePatterns": func(label string, sec *ini.Section, cfg *Config) error {
		cfg.BlockIgnores[label] = sec.Key("IgnorePatterns").Strings(",")
		return nil
	},
	"BlockIgnores": func(label string, sec *ini.Section, cfg *Config) error {
		cfg.BlockIgnores[label] = sec.Key("BlockIgnores").Strings(",")
		return nil
	},
	"TokenIgnores": func(label string, sec *ini.Section, cfg *Config) error {
		cfg.TokenIgnores[label] = sec.Key("TokenIgnores").Strings(",")
		return nil
	},
	"Transform": func(label string, sec *ini.Section, cfg *Config) error {
		canidate := sec.Key("Transform").String()

		abs, err := filepath.Abs(canidate)
		if err != nil {
			return err
		}

		cfg.Stylesheets[label] = filepath.FromSlash(abs)
		return nil

	},
	"Lang": func(label string, sec *ini.Section, cfg *Config) error {
		cfg.FormatToLang[label] = sec.Key("Lang").String()
		return nil
	},
}

var globalOpts = map[string]func(*ini.Section, *Config, []string){
	"BasedOnStyles": func(sec *ini.Section, cfg *Config, args []string) {
		cfg.GBaseStyles = mergeValues(sec.Key("BasedOnStyles").StringsWithShadows(","))
		cfg.Styles = append(cfg.Styles, cfg.GBaseStyles...)
	},
	"IgnorePatterns": func(sec *ini.Section, cfg *Config, args []string) {
		cfg.BlockIgnores["*"] = sec.Key("IgnorePatterns").Strings(",")
	},
	"BlockIgnores": func(sec *ini.Section, cfg *Config, args []string) {
		cfg.BlockIgnores["*"] = sec.Key("BlockIgnores").Strings(",")
	},
	"TokenIgnores": func(sec *ini.Section, cfg *Config, args []string) {
		cfg.TokenIgnores["*"] = sec.Key("TokenIgnores").Strings(",")
	},
	"Lang": func(sec *ini.Section, cfg *Config, args []string) {
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
			entry := sec.Key("StylesPath").MustString("")
			canidate := filepath.FromSlash(entry)

			cfg.StylesPath = determinePath(cfg.Flags.Path, canidate)
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
	"MinAlertLevel": func(sec *ini.Section, cfg *Config, args []string) error {
		if !StringInSlice(cfg.Flags.AlertLevel, AlertLevels) {
			level := sec.Key("MinAlertLevel").String() //.In("suggestion", AlertLevels)
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
	"IgnoredScopes": func(sec *ini.Section, cfg *Config, args []string) error {
		cfg.IgnoredScopes = mergeValues(sec.Key("IgnoredScopes").StringsWithShadows(","))
		return nil
	},
	"WordTemplate": func(sec *ini.Section, cfg *Config, args []string) error {
		cfg.WordTemplate = sec.Key("WordTemplate").String()
		return nil
	},
	"DictionaryPath": func(sec *ini.Section, cfg *Config, args []string) error {
		cfg.DictionaryPath = sec.Key("DictionaryPath").String()
		return nil
	},
	"SkippedScopes": func(sec *ini.Section, cfg *Config, args []string) error {
		cfg.SkippedScopes = mergeValues(sec.Key("SkippedScopes").StringsWithShadows(","))
		return nil
	},
	"IgnoredClasses": func(sec *ini.Section, cfg *Config, args []string) error {
		cfg.IgnoredClasses = mergeValues(sec.Key("IgnoredClasses").StringsWithShadows(","))
		return nil
	},
	"Project": func(sec *ini.Section, cfg *Config, args []string) error {
		cfg.Project = sec.Key("Project").String()
		return loadVocab(cfg.Project, cfg)
	},
	"Vocab": func(sec *ini.Section, cfg *Config, args []string) error {
		cfg.Project = sec.Key("Vocab").String()
		return loadVocab(cfg.Project, cfg)
	},
	"LTPath": func(sec *ini.Section, cfg *Config, args []string) error {
		cfg.LTPath = sec.Key("LTPath").String()
		return nil
	},
	"SphinxBuildPath": func(sec *ini.Section, cfg *Config, args []string) error {
		canidate := filepath.FromSlash(sec.Key("SphinxBuildPath").MustString(""))
		cfg.SphinxBuild = determinePath(cfg.Flags.Path, canidate)
		return nil
	},
	"SphinxAutoBuild": func(sec *ini.Section, cfg *Config, args []string) error {
		cfg.SphinxAuto = sec.Key("SphinxAutoBuild").MustString("")
		return nil
	},
	"ProcessTimeout": func(sec *ini.Section, cfg *Config, args []string) error {
		cfg.Timeout = sec.Key("ProcessTimeout").MustInt()
		return nil
	},
	"NLPEndpoint": func(sec *ini.Section, cfg *Config, args []string) error {
		cfg.NLPEndpoint = sec.Key("NLPEndpoint").MustString("")
		return nil
	},
}

func shadowLoad(source interface{}, others ...interface{}) (*ini.File, error) {
	return ini.LoadSources(ini.LoadOptions{
		AllowShadows:             true,
		SpaceBeforeInlineComment: true}, source, others...)
}

func loadINI(cfg *Config) error {
	var base string
	var uCfg *ini.File
	var err error
	var sources []string

	names := []string{
		".vale", "_vale", "vale.ini", ".vale.ini", "_vale.ini", ""}

	home, err := os.UserHomeDir()
	if err != nil {
		return NewE100("loadINI/homedir", err)
	}

	base = loadConfig(names, []string{"", home})
	if cfg.Flags.Sources != "" {
		for _, source := range strings.Split(cfg.Flags.Sources, ",") {
			abs, _ := filepath.Abs(source)
			sources = append(sources, abs)
		}
	} else {
		sources = []string{base, cfg.Flags.Path}
	}

	if cfg.Flags.Local && FileExists(base) && FileExists(cfg.Flags.Path) {
		uCfg, err = shadowLoad(cfg.Flags.Path, base)
	} else if cfg.Flags.Remote && FileExists(base) && FileExists(cfg.Flags.Path) {
		uCfg, err = shadowLoad(base, cfg.Flags.Path)
		cfg.Flags.Path = base
	} else if cfg.Flags.Sources != "" {
		uCfg, err = processSources(cfg, sources)
	} else {
		base = loadConfig(names, []string{cfg.Flags.Path, "", home})
		uCfg, err = shadowLoad(base)
		cfg.Flags.Path = base
	}

	if err != nil {
		return NewE100(".vale.ini", err)
	} else if StringInSlice(cfg.Flags.AlertLevel, AlertLevels) {
		cfg.MinAlertLevel = LevelToInt[cfg.Flags.AlertLevel]
	}

	uCfg.BlockMode = false
	return processConfig(uCfg, cfg, sources)
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

func processSources(cfg *Config, sources []string) (*ini.File, error) {
	var uCfg *ini.File
	var err error

	if len(sources) == 0 {
		return uCfg, errors.New("no sources provided")
	} else if len(sources) == 1 {
		cfg.Flags.Path = sources[0]
		return ini.Load(cfg.Flags.Path)
	}

	t := sources[1:]
	s := make([]interface{}, len(t))
	for i, v := range t {
		s[i] = v
	}

	uCfg, err = ini.Load(sources[0], s...)
	cfg.Flags.Path = sources[len(sources)-1]

	return uCfg, err
}

func processConfig(uCfg *ini.File, cfg *Config, paths []string) error {
	core := uCfg.Section("")
	global := uCfg.Section("*")
	formats := uCfg.Section("formats")

	// Default settings
	for _, k := range core.KeyStrings() {
		if f, found := coreOpts[k]; found {
			if err := f(core, cfg, paths); err != nil {
				return err
			}
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
		if err != nil {
			return err
		}
		cfg.SecToPat[sec] = pat

		syntaxMap := make(map[string]bool)
		for _, k := range uCfg.Section(sec).KeyStrings() {
			if f, found := syntaxOpts[k]; found {
				if err = f(sec, uCfg.Section(sec), cfg); err != nil {
					return err
				}
			} else {
				syntaxMap[k] = validateLevel(k, uCfg.Section(sec).Key(k).String(), cfg)
				cfg.Checks = append(cfg.Checks, k)
			}
		}
		cfg.SChecks[sec] = syntaxMap
	}

	return nil
}
