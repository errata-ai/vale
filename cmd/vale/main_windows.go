//go:build windows
// +build windows

package main

import (
	"fmt"

	"golang.org/x/sys/windows/registry"
)

func unsetManifestRegistry(browser string) error {
	var key string

	switch browser {
	case "chrome", "opera", "chromium":
		key = `SOFTWARE\Google\Chrome\NativeMessagingHosts\`
	case "firefox":
		key = `SOFTWARE\Mozilla\NativeMessagingHosts\`
	case "edge":
		key = `SOFTWARE\Microsoft\Edge\NativeMessagingHosts\`
	default:
		return fmt.Errorf("unsupported browser: %s", browser)
	}
	key += nativeHostName

	return registry.DeleteKey(registry.CURRENT_USER, key)
}

func setManifestRegistry(browser, manifestPath string) error {
	var key string

	switch browser {
	case "chrome", "opera", "chromium":
		key = `SOFTWARE\Google\Chrome\NativeMessagingHosts\`
	case "firefox":
		key = `SOFTWARE\Mozilla\NativeMessagingHosts\`
	case "edge":
		key = `SOFTWARE\Microsoft\Edge\NativeMessagingHosts\`
	default:
		return fmt.Errorf("unsupported browser: %s", browser)
	}
	key += nativeHostName

	k, _, err := registry.CreateKey(registry.CURRENT_USER, key, registry.WOW64_64KEY|registry.WRITE)
	if err != nil {
		return err
	}
	defer k.Close()

	if err := k.SetStringValue("", manifestPath); err != nil {
		return err
	}

	return nil
}
