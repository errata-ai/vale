package core

import (
	"fmt"
	"path/filepath"
	"strings"

	"github.com/errata-ai/ini"
)

func validateFlags(cfg *Config) error {
	if cfg.Flags.Path != "" && !FileExists(cfg.Flags.Path) {
		return NewE100(
			"--config",
			fmt.Errorf("path '%s' does not exist", cfg.Flags.Path))
	}
	return nil
}

func ReadPipeline(provider string, flags *CLIFlags, dry bool) (*Config, *ini.File, error) {
	var sourced *ini.File

	config, err := NewConfig(flags)
	if err != nil {
		return config, nil, err
	} else if err = validateFlags(config); err != nil {
		return config, nil, err
	}

	sourced, err = from(provider, config, dry)
	if err != nil {
		return config, nil, err
	}

	sources, err := pipeConfig(config)
	if err != nil {
		return config, nil, err
	}

	if len(sources) > 0 {
		config.Flags.Sources = strings.Join(sources, ",")

		sourced, err = from(provider, config, dry)
		if err != nil {
			return config, nil, err
		}
	}

	return config, sourced, nil
}

// from updates an existing configuration with values from a user-provided
// source.
func from(provider string, cfg *Config, dry bool) (*ini.File, error) {
	switch provider {
	case "ini":
		return loadINI(cfg, dry)
	default:
		return nil, NewE100(
			"source/From", fmt.Errorf("unknown provider '%s'", provider))
	}
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
