package core

import (
	"fmt"
	"path/filepath"
)

// From updates an existing configuration with values from a user-provided
// source.
func From(provider string, cfg *Config) error {
	switch provider {
	case "ini":
		return loadINI(cfg)
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
