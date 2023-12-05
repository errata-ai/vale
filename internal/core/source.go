package core

import (
	"fmt"
	"path/filepath"
	"strings"

	"github.com/errata-ai/ini"
)

type ConfigSrc int

const (
	FileSrc ConfigSrc = iota
	StringSrc
)

func ReadPipeline(flags *CLIFlags, dry bool) (*Config, error) {
	config, err := NewConfig(flags)
	if err != nil {
		return config, err
	} else if err = validateFlags(config); err != nil {
		return config, err
	}

	_, err = FromFile(config, dry)
	if err != nil {
		return config, err
	}

	sources, err := pipeConfig(config)
	if err != nil {
		return config, err
	}

	if len(sources) > 0 {
		config.Flags.Sources = strings.Join(sources, ",")

		_, err = FromFile(config, dry)
		if err != nil {
			return config, err
		}
	}

	return config, nil
}

// from updates an existing configuration with values From a user-provided
// source.
func from(provider ConfigSrc, src string, cfg *Config, dry bool) (*ini.File, error) {
	switch provider {
	case FileSrc:
		return loadINI(cfg, dry)
	case StringSrc:
		return loadStdin(src, cfg, dry)
	default:
		return nil, NewE100(
			"source/From", fmt.Errorf("unknown provider '%v'", provider))
	}
}

// FromFile loads an INI configuration from a file.
func FromFile(cfg *Config, dry bool) (*ini.File, error) {
	return from(FileSrc, "", cfg, dry)
}

// FromString loads an INI configuration from a string.
func FromString(src string, cfg *Config, dry bool) (*ini.File, error) {
	return from(StringSrc, src, cfg, dry)
}

// FindAsset tries to locate a Vale-related resource by looking in the
// user-defined StylesPath.
func FindAsset(cfg *Config, path string) string {
	if path == "" {
		return path
	}

	inPath := filepath.Join(cfg.StylesPath, path)
	if FileExists(inPath) {
		return inPath
	}

	return determinePath(cfg.Flags.Path, path)
}

func validateFlags(cfg *Config) error {
	if cfg.Flags.Path != "" && !FileExists(cfg.Flags.Path) {
		return NewE100(
			"--config",
			fmt.Errorf("path '%s' does not exist", cfg.Flags.Path))
	}
	return nil
}
