package source

import (
	"errors"
	"fmt"
	"os"
	"path"
	"path/filepath"
	"strings"

	"github.com/errata-ai/vale/config"
	"github.com/errata-ai/vale/core"
	"github.com/gobwas/glob"
	"github.com/mitchellh/go-homedir"
	"github.com/spf13/afero"
	"gopkg.in/ini.v1"
)

func mergeValues(shadows []string) []string {
	values := []string{}
	for _, v := range shadows {
		for _, s := range strings.Split(v, ",") {
			entry := strings.TrimSpace(s)
			if entry != "" && !core.StringInSlice(entry, values) {
				values = append(values, entry)
			}
		}
	}
	return values
}

func validateLevel(key, val string, cfg *config.Config) bool {
	options := []string{"YES", "suggestion", "warning", "error"}
	if val == "NO" || !core.StringInSlice(val, options) {
		return false
	} else if val != "YES" {
		cfg.RuleToLevel[key] = val
	}
	return true
}

func loadVocab(root string, config *config.Config) error {
	root = filepath.Join(config.StylesPath, "Vocab", root)

	err := config.FsWrapper.Walk(root, func(fp string, fi os.FileInfo, err error) error {
		if filepath.Base(fp) == "accept.txt" {
			return config.AddWordListFile(fp, true)
		} else if filepath.Base(fp) == "reject.txt" {
			return config.AddWordListFile(fp, false)
		}
		return err
	})

	return err
}

var syntaxOpts = map[string]func(string, *ini.Section, *config.Config) error{
	"BasedOnStyles": func(lbl string, sec *ini.Section, cfg *config.Config) error {
		pat, err := glob.Compile(lbl)
		if err != nil {
			return core.NewE201FromTarget(
				fmt.Sprintf("The glob pattern '%s' could not be compiled.", lbl),
				lbl,
				cfg.Path)
		} else if _, found := cfg.SecToPat[lbl]; !found {
			cfg.SecToPat[lbl] = pat
		}
		sStyles := mergeValues(sec.Key("BasedOnStyles").ValueWithShadows())

		cfg.Styles = append(cfg.Styles, sStyles...)
		cfg.SBaseStyles[lbl] = sStyles

		return nil
	},
	"IgnorePatterns": func(label string, sec *ini.Section, cfg *config.Config) error {
		cfg.BlockIgnores[label] = mergeValues(sec.Key("IgnorePatterns").ValueWithShadows())
		return nil
	},
	"BlockIgnores": func(label string, sec *ini.Section, cfg *config.Config) error {
		cfg.BlockIgnores[label] = mergeValues(sec.Key("BlockIgnores").ValueWithShadows())
		return nil
	},
	"TokenIgnores": func(label string, sec *ini.Section, cfg *config.Config) error {
		cfg.TokenIgnores[label] = mergeValues(sec.Key("TokenIgnores").ValueWithShadows())
		return nil
	},
	"Parser": func(label string, sec *ini.Section, cfg *config.Config) error {
		cfg.Parsers[label] = sec.Key("Parser").String()
		return nil
	},
	"Transform": func(label string, sec *ini.Section, cfg *config.Config) error {
		canidate := sec.Key("Transform").String()

		abs, err := filepath.Abs(canidate)
		if err != nil {
			return err
		}

		cfg.Stylesheets[label] = filepath.FromSlash(abs)
		return nil

	},
}

var globalOpts = map[string]func(*ini.Section, *config.Config, []string){
	"BasedOnStyles": func(sec *ini.Section, cfg *config.Config, args []string) {
		cfg.GBaseStyles = mergeValues(sec.Key("BasedOnStyles").ValueWithShadows())
		cfg.Styles = append(cfg.Styles, cfg.GBaseStyles...)
	},
	"IgnorePatterns": func(sec *ini.Section, cfg *config.Config, args []string) {
		cfg.BlockIgnores["*"] = mergeValues(sec.Key("IgnorePatterns").ValueWithShadows())
	},
	"BlockIgnores": func(sec *ini.Section, cfg *config.Config, args []string) {
		cfg.BlockIgnores["*"] = mergeValues(sec.Key("BlockIgnores").ValueWithShadows())
	},
	"TokenIgnores": func(sec *ini.Section, cfg *config.Config, args []string) {
		cfg.TokenIgnores["*"] = mergeValues(sec.Key("TokenIgnores").ValueWithShadows())
	},
}

var coreOpts = map[string]func(*ini.Section, *config.Config, []string) error{
	"StylesPath": func(sec *ini.Section, cfg *config.Config, args []string) error {
		paths := sec.Key("StylesPath").ValueWithShadows()
		if cfg.Local && len(paths) == 2 {
			basePath := core.DeterminePath(args[0], filepath.FromSlash(paths[1]))
			mockPath := core.DeterminePath(args[1], filepath.FromSlash(paths[0]))
			if basePath != mockPath {
				baseFs := cfg.FsWrapper.Fs
				mockFs := afero.NewMemMapFs()

				err := core.CopyDir(baseFs, basePath, mockFs, mockPath)
				if err != nil {
					return err
				}

				cfg.FsWrapper.Fs = afero.NewCopyOnWriteFs(baseFs, mockFs)
				cfg.FallbackPath = mockPath
			}
		}
		cfg.StylesPath = cfg.FallbackPath
		if cfg.StylesPath == "" {
			entry := sec.Key("StylesPath").MustString("")
			canidate := filepath.FromSlash(entry)

			cfg.StylesPath = core.DeterminePath(cfg.Path, canidate)
			if !core.FileExists(cfg.StylesPath) {
				return core.NewE201FromTarget(
					fmt.Sprintf("The path '%s' does not exist.", cfg.StylesPath),
					entry,
					cfg.Path)
			}
		}

		return nil
	},
	"MinAlertLevel": func(sec *ini.Section, cfg *config.Config, args []string) error {
		if !core.StringInSlice(cfg.AlertLevel, core.AlertLevels) {
			level := sec.Key("MinAlertLevel").String() //.In("suggestion", core.AlertLevels)
			if index, found := core.LevelToInt[level]; found {
				cfg.MinAlertLevel = index
			} else {
				return core.NewE201FromTarget(
					"MinAlertLevel must be 'suggestion', 'warning', or 'error'.",
					level,
					cfg.Path)
			}
		}
		return nil
	},
	"IgnoredScopes": func(sec *ini.Section, cfg *config.Config, args []string) error {
		cfg.IgnoredScopes = mergeValues(sec.Key("IgnoredScopes").ValueWithShadows())
		return nil
	},
	"WordTemplate": func(sec *ini.Section, cfg *config.Config, args []string) error {
		cfg.WordTemplate = sec.Key("WordTemplate").String()
		return nil
	},
	"SkippedScopes": func(sec *ini.Section, cfg *config.Config, args []string) error {
		cfg.SkippedScopes = mergeValues(sec.Key("SkippedScopes").ValueWithShadows())
		return nil
	},
	"IgnoredClasses": func(sec *ini.Section, cfg *config.Config, args []string) error {
		cfg.IgnoredClasses = mergeValues(sec.Key("IgnoredClasses").ValueWithShadows())
		return nil
	},
	"Project": func(sec *ini.Section, cfg *config.Config, args []string) error {
		cfg.Project = sec.Key("Project").String()
		return loadVocab(cfg.Project, cfg)
	},
	"Vocab": func(sec *ini.Section, cfg *config.Config, args []string) error {
		cfg.Project = sec.Key("Vocab").String()
		return loadVocab(cfg.Project, cfg)
	},
	"LTPath": func(sec *ini.Section, cfg *config.Config, args []string) error {
		cfg.LTPath = sec.Key("LTPath").String()
		return nil
	},
	"SphinxBuildPath": func(sec *ini.Section, cfg *config.Config, args []string) error {
		canidate := filepath.FromSlash(sec.Key("SphinxBuildPath").MustString(""))
		cfg.SphinxBuild = core.DeterminePath(cfg.Path, canidate)
		return nil
	},
	"SphinxAutoBuild": func(sec *ini.Section, cfg *config.Config, args []string) error {
		cfg.SphinxAuto = sec.Key("SphinxAutoBuild").MustString("")
		return nil
	},
	"ProcessTimeout": func(sec *ini.Section, cfg *config.Config, args []string) error {
		cfg.Timeout = sec.Key("ProcessTimeout").MustInt()
		return nil
	},
}

func loadINI(cfg *config.Config) error {
	var base string
	var uCfg *ini.File
	var err error
	var sources []string

	names := []string{
		".vale", "_vale", "vale.ini", ".vale.ini", "_vale.ini", ""}

	home, err := homedir.Dir()
	if err != nil {
		return core.NewE100("loadINI/homedir", err)
	}

	base = loadConfig(names, []string{"", home})
	if cfg.Sources != "" {
		for _, source := range strings.Split(cfg.Sources, ",") {
			abs, _ := filepath.Abs(source)
			sources = append(sources, abs)
		}
	} else {
		sources = []string{base, cfg.Path}
	}

	if cfg.Local && core.FileExists(base) && core.FileExists(cfg.Path) {
		uCfg, err = ini.ShadowLoad(cfg.Path, base)
	} else if cfg.Remote && core.FileExists(base) && core.FileExists(cfg.Path) {
		uCfg, err = ini.ShadowLoad(base, cfg.Path)
		cfg.Path = base
	} else if cfg.Sources != "" {
		uCfg, err = processSources(cfg, sources)
	} else {
		base = loadConfig(names, []string{cfg.Path, "", home})
		uCfg, err = ini.ShadowLoad(base)
		cfg.Path = base
	}

	if err != nil {
		return core.NewE100(".vale.ini", err)
	} else if core.StringInSlice(cfg.AlertLevel, core.AlertLevels) {
		cfg.MinAlertLevel = core.LevelToInt[cfg.AlertLevel]
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
				if core.FileExists(loc) && !core.IsDir(loc) {
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

func processSources(cfg *config.Config, sources []string) (*ini.File, error) {
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

func processConfig(uCfg *ini.File, cfg *config.Config, paths []string) error {
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
