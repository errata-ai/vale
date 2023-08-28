package core

import (
	"fmt"
	"path/filepath"
	"strings"
)

func validateFlags(cfg *Config) error {
	if cfg.Flags.Path != "" && !FileExists(cfg.Flags.Path) {
		return NewE100(
			"--config",
			fmt.Errorf("path '%s' does not exist", cfg.Flags.Path))
	}
	return nil
}

func ReadPipeline(provider string, flags *CLIFlags, dry bool) (*Config, error) {
	config, err := NewConfig(flags)
	if err != nil {
		return config, err
	} else if err = validateFlags(config); err != nil {
		return config, err
	}

	err = from(provider, config, dry)
	if err != nil {
		return config, err
	}

	sources, err := pipeConfig(config)
	if err != nil {
		return config, err
	}

	if len(sources) > 0 {
		config.Flags.Sources = strings.Join(sources, ",")

		err = from(provider, config, dry)
		if err != nil {
			return config, err
		}
	}

	return config, nil
}

// from updates an existing configuration with values from a user-provided
// source.
func from(provider string, cfg *Config, dry bool) error {
	switch provider {
	case "ini":
		return loadINI(cfg, dry)
	default:
		return NewE100(
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
