package source

import (
	"fmt"
	"path/filepath"

	"github.com/errata-ai/vale/v2/config"
	"github.com/errata-ai/vale/v2/core"
)

// From updates an existing configuration with values from a user-provided
// source.
func From(provider string, cfg *config.Config) error {
	switch provider {
	case "ini":
		return loadINI(cfg)
	default:
		return core.NewE100(
			"source/From", fmt.Errorf("unknown provider '%s'", provider))
	}
}

// FindAsset tries to locate a Vale-related resource by looking in the
// user-defined StylesPath.
func FindAsset(cfg *config.Config, path string) string {
	if path == "" {
		return path
	}

	inPath := filepath.Join(cfg.StylesPath, path)
	if core.FileExists(inPath) {
		return inPath
	}

	return determinePath(cfg.Path, path)
}
