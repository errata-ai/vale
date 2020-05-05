package core

import (
	"path/filepath"

	"github.com/gobwas/glob"
	"github.com/spf13/afero"
	"gopkg.in/ini.v1"
)

var syntaxOpts = map[string]func(string, *ini.Section, *Config){
	"BasedOnStyles": func(label string, sec *ini.Section, cfg *Config) {
		pat, err := glob.Compile(label)
		if _, found := cfg.SecToPat[label]; !found && CheckError(err, cfg.Debug) {
			cfg.SecToPat[label] = pat
		}
		sStyles := mergeValues(sec.Key("BasedOnStyles").ValueWithShadows())

		cfg.Styles = append(cfg.Styles, sStyles...)
		cfg.SBaseStyles[label] = sStyles
	},
	"IgnorePatterns": func(label string, sec *ini.Section, cfg *Config) {
		cfg.BlockIgnores[label] = mergeValues(sec.Key("IgnorePatterns").ValueWithShadows())
	},
	"BlockIgnores": func(label string, sec *ini.Section, cfg *Config) {
		cfg.TokenIgnores[label] = mergeValues(sec.Key("BlockIgnores").ValueWithShadows())
	},
	"TokenIgnores": func(label string, sec *ini.Section, cfg *Config) {
		cfg.TokenIgnores[label] = mergeValues(sec.Key("TokenIgnores").ValueWithShadows())
	},
	"Parser": func(label string, sec *ini.Section, cfg *Config) {
		cfg.Parsers[label] = sec.Key("Parser").String()
	},
	"Transform": func(label string, sec *ini.Section, cfg *Config) {
		canidate := sec.Key("Transform").String()
		abs, _ := filepath.Abs(canidate)
		cfg.Stylesheets[label] = filepath.FromSlash(abs)
	},
}

var globalOpts = map[string]func(*ini.Section, *Config, []string){
	"BasedOnStyles": func(sec *ini.Section, cfg *Config, args []string) {
		cfg.GBaseStyles = mergeValues(sec.Key("BasedOnStyles").ValueWithShadows())
		cfg.Styles = append(cfg.Styles, cfg.GBaseStyles...)
	},
	"IgnorePatterns": func(sec *ini.Section, cfg *Config, args []string) {
		cfg.BlockIgnores["*"] = mergeValues(sec.Key("IgnorePatterns").ValueWithShadows())
	},
	"BlockIgnores": func(sec *ini.Section, cfg *Config, args []string) {
		cfg.BlockIgnores["*"] = mergeValues(sec.Key("IgnorePatterns").ValueWithShadows())
	},
	"TokenIgnores": func(sec *ini.Section, cfg *Config, args []string) {
		cfg.TokenIgnores["*"] = mergeValues(sec.Key("TokenIgnores").ValueWithShadows())
	},
}

var coreOpts = map[string]func(*ini.Section, *Config, []string){
	"StylesPath": func(sec *ini.Section, cfg *Config, args []string) {
		paths := sec.Key("StylesPath").ValueWithShadows()
		if cfg.Local && len(paths) == 2 {
			basePath := DeterminePath(args[0], filepath.FromSlash(paths[1]))
			mockPath := DeterminePath(args[1], filepath.FromSlash(paths[0]))
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
			canidate := filepath.FromSlash(sec.Key("StylesPath").MustString(""))
			cfg.StylesPath = DeterminePath(cfg.Path, canidate)
		}
	},
	"MinAlertLevel": func(sec *ini.Section, cfg *Config, args []string) {
		if !StringInSlice(cfg.AlertLevel, AlertLevels) {
			level := sec.Key("MinAlertLevel").In("suggestion", AlertLevels)
			cfg.MinAlertLevel = LevelToInt[level]
		}
	},
	"IgnoredScopes": func(sec *ini.Section, cfg *Config, args []string) {
		cfg.IgnoredScopes = mergeValues(sec.Key("IgnoredScopes").ValueWithShadows())
	},
	"WordTemplate": func(sec *ini.Section, cfg *Config, args []string) {
		cfg.WordTemplate = sec.Key("WordTemplate").String()
	},
	"SkippedScopes": func(sec *ini.Section, cfg *Config, args []string) {
		cfg.SkippedScopes = mergeValues(sec.Key("SkippedScopes").ValueWithShadows())
	},
	"IgnoredClasses": func(sec *ini.Section, cfg *Config, args []string) {
		cfg.IgnoredClasses = mergeValues(sec.Key("IgnoredClasses").ValueWithShadows())
	},
	"Project": func(sec *ini.Section, cfg *Config, args []string) {
		cfg.Project = sec.Key("Project").String()
		loadVocab(cfg.Project, cfg)
	},
	"LTPath": func(sec *ini.Section, cfg *Config, args []string) {
		cfg.LTPath = sec.Key("LTPath").String()
	},
	"SphinxBuildPath": func(sec *ini.Section, cfg *Config, args []string) {
		canidate := filepath.FromSlash(sec.Key("SphinxBuildPath").MustString(""))
		cfg.SphinxBuild = DeterminePath(cfg.Path, canidate)
	},
	"SphinxAutoBuild": func(sec *ini.Section, cfg *Config, args []string) {
		cfg.SphinxAuto = sec.Key("SphinxAutoBuild").MustString("")
	},
}
