//go:build !windows
// +build !windows

package main

func unsetManifestRegistry(_ string) error {
	return nil
}

func setManifestRegistry(_, _ string) error {
	return nil
}
