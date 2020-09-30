package source

import (
	"fmt"

	"github.com/errata-ai/vale/config"
	"github.com/errata-ai/vale/core"
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
