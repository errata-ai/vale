// +build !closed

package action

import (
	"github.com/errata-ai/vale/core"
)

// GetLibrary returns the latest style library.
func GetLibrary(config *core.Config) error {
	return nil
}

// StartAddons starts all installed add-ons.
func StartAddons(config *core.Config) error {
	return nil
}

// StopAddons stops all installed add-ons.
func StopAddons(config *core.Config, args []string) error {
	return nil
}

// FetchAddon an external (compressed) resource.
func FetchAddon(config *core.Config, args []string) error {
	return nil
}

// GetAddons lists all available add-ons.
func GetAddons(config *core.Config) error {
	return nil
}

// InstallStyle installs the given style using its download link.
func InstallStyle(config *core.Config, args []string) error {
	return nil
}

// ListDir prints all folders on the current StylesPath.
func ListDir(config *core.Config, path string) error {
	return nil
}

// AddProject adds a new project to the current StylesPath.
func AddProject(cfg *core.Config, name string) error {
	return nil
}

// RemoveProject deletes a project from the current StylesPath.
func RemoveProject(cfg *core.Config, name string) error {
	return nil
}

// EditProject renames a project from the current StylesPath.
func EditProject(cfg *core.Config, args []string) error {
	return nil
}

// UpdateVocab updates a vocab file for the given project.
func UpdateVocab(config *core.Config, args []string) error {
	return nil
}

// GetVocab extracts a vocab file for a project.
func GetVocab(config *core.Config, args []string) error {
	return nil
}
