package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"

	"github.com/adrg/xdg"
	"github.com/pterm/pterm"

	"github.com/errata-ai/vale/v3/internal/core"
)

const nativeHostName = "sh.vale.native"
const releaseURL = "https://github.com/errata-ai/vale-native/releases/download/%s/vale-native_%s.%s"

var supportedBrowsers = []string{
	"chrome",
	"firefox",
	"opera",
	"chromium",
	"edge",
}

var extensionByBrowser = map[string]string{
	"chrome": "chrome-extension://gicakheakmadhhfbpikggnapkabikmne/",
}

var (
	errMissingBrowser = errors.New("missing argument 'browser'")
	errInvalidBrowser = fmt.Errorf("invalid browser; must one of %v", supportedBrowsers)
	errMissingExt     = errors.New("no extension for the given browser")
)

type manifest struct {
	Name              string   `json:"name"`
	Description       string   `json:"description"`
	Path              string   `json:"path"`
	Type              string   `json:"type"`
	AllowedExtensions []string `json:"allowed_extensions,omitempty"`
	AllowedOrigins    []string `json:"allowed_origins,omitempty"`
}

func getNativeConfig() (string, error) {
	cfg, err := xdg.ConfigFile("vale/native/config.json")
	if err != nil {
		return "", err
	}
	return cfg, nil
}

func getExecName(name string) string {
	if runtime.GOOS == "windows" {
		return name + ".exe"
	}
	return name
}

func getManifestDirs() (map[string]string, error) {
	home, err := os.UserHomeDir()
	if err != nil {
		return nil, err
	}

	config, err := os.UserConfigDir()
	if err != nil {
		return nil, err
	}

	manifests := map[string]string{}
	switch runtime.GOOS {
	case "linux":
		manifests = map[string]string{
			"chrome":   filepath.Join(home, config, "google-chrome", "NativeMessagingHosts"),
			"firefox":  filepath.Join(home, ".mozilla", "native-messaging-hosts"),
			"opera":    filepath.Join(home, config, "google-chrome", "NativeMessagingHosts"),
			"chromium": filepath.Join(home, config, "chromium", "NativeMessagingHosts"),
		}
	case "darwin":
		manifests = map[string]string{
			"chrome":   filepath.Join(home, "Library/Application Support/Google/Chrome/NativeMessagingHosts"),
			"firefox":  filepath.Join(home, "Library/Application Support/Mozilla/NativeMessagingHosts"),
			"opera":    filepath.Join(home, "Library/Application Support/Google/Chrome/NativeMessagingHosts"),
			"chromium": filepath.Join(home, "Library/Application Support/Chromium/NativeMessagingHosts"),
			"edge":     filepath.Join(home, "Library/Application Support/Microsoft Edge/NativeMessagingHosts"),
		}
	}

	return manifests, nil
}

func getLocation(browser string) (map[string]string, error) {
	cfg, err := getNativeConfig()
	if err != nil {
		return nil, err
	}

	bin := filepath.Dir(cfg)
	if runtime.GOOS == "windows" {
		return map[string]string{
			"appDir":      bin,
			"manifestDir": "",
		}, nil
	}

	manifestDirs, err := getManifestDirs()
	if err != nil {
		return nil, err
	}

	manifest := ""
	if found, ok := manifestDirs[browser]; ok {
		manifest = found
	}

	return map[string]string{
		"appDir":      bin,
		"manifestDir": manifest,
	}, nil
}

func writeNativeConfig() error {
	cfgFile, err := getNativeConfig()
	if err != nil {
		return err
	}

	exe, err := exec.LookPath("vale")
	if err != nil {
		return err
	}

	cfg := map[string]string{
		"path": exe,
	}

	jsonCfg, err := json.Marshal(cfg)
	if err != nil {
		return err
	}

	return os.WriteFile(cfgFile, jsonCfg, os.ModePerm)
}

func installNativeHostUnix(manifestData []byte, manifestFile string) error {
	err := os.WriteFile(manifestFile, manifestData, os.ModePerm)
	if err != nil {
		return core.NewE100("host-install", err)
	}
	return nil
}

func installNativeHostWindows(manifestData []byte, manifestFile, browser string) error {
	cfg, err := getNativeConfig()
	if err != nil {
		return core.NewE100("host-install", err)
	}

	manifestDir := filepath.Join(filepath.Dir(cfg), "manifest", browser)

	err = os.MkdirAll(manifestDir, os.ModePerm)
	if err != nil {
		return core.NewE100("host-install", err)
	}
	subdir := filepath.Join(manifestDir, manifestFile)

	err = os.WriteFile(subdir, manifestData, os.ModePerm)
	if err != nil {
		return core.NewE100("host-install", err)
	}

	err = setManifestRegistry(browser, subdir)
	if err != nil {
		return core.NewE100("host-install", err)
	}

	return nil
}

func getLatestHostRelease() (string, error) {
	resp, err := fetchJSON("https://api.github.com/repos/errata-ai/vale-native/releases/latest")
	if err != nil {
		return "", err
	}

	var release struct {
		TagName string `json:"tag_name"`
	}

	err = json.Unmarshal(resp, &release)
	if err != nil {
		return "", err
	}

	return release.TagName, nil
}

func hostDownloadURL() (string, error) {
	hostVersion, err := getLatestHostRelease()
	if err != nil {
		return "", err
	}
	name := platformAndArch()
	return fmt.Sprintf(releaseURL, hostVersion, name, "zip"), nil
}

func installHost(manifestJSON []byte, manifestFile, browser string) error {
	switch runtime.GOOS {
	case "linux", "darwin":
		return installNativeHostUnix(manifestJSON, manifestFile)
	case "windows":
		return installNativeHostWindows(manifestJSON, manifestFile, browser)
	default:
		return core.NewE100("host-install", fmt.Errorf("unsupported OS: %s", runtime.GOOS))
	}
}

func installNativeHost(args []string, _ *core.CLIFlags) error {
	if len(args) != 1 {
		return core.NewE100("host-install", errMissingBrowser)
	}

	browser := args[0]
	if !core.StringInSlice(browser, supportedBrowsers) {
		return core.NewE100("host-install", errInvalidBrowser)
	}

	steps := []string{"writing config", "fetching binary", "installing host"}
	p, _ := pterm.DefaultProgressbar.WithTotal(len(steps)).WithTitle("Installing host").Start()

	p.UpdateTitle(steps[0])
	err := writeNativeConfig()
	if err != nil {
		return core.NewE100("host-install", err)
	}
	pterm.Success.Println(steps[0])
	p.Increment()

	locations, err := getLocation(browser)
	if err != nil {
		return core.NewE100("host-install", err)
	}

	hostURL, err := hostDownloadURL()
	if err != nil {
		return core.NewE100("host-install", err)
	}
	exeName := getExecName("vale-native")

	oldInstall := []string{exeName, "LICENSE", "README.md"}
	for _, file := range oldInstall {
		fp := filepath.Join(locations["appDir"], file)
		if core.FileExists(fp) {
			err = os.Remove(fp)
			if err != nil {
				return core.NewE100("host-install", err)
			}
		}
	}

	p.UpdateTitle(steps[1])
	err = fetch(hostURL, locations["appDir"])
	if err != nil {
		return core.NewE100("host-install", err)
	}
	pterm.Success.Println(steps[1])
	p.Increment()

	manifestData := manifest{
		Name:        nativeHostName,
		Description: "A native messaging for the Vale CLI.",
		Type:        "stdio",
		Path:        filepath.Join(locations["appDir"], exeName),
	}

	manifestFile := filepath.Join(locations["manifestDir"], manifestData.Name+".json")

	extension, found := extensionByBrowser[browser]
	if !found {
		return core.NewE100("host-install", errMissingExt)
	}

	if browser == "firefox" {
		manifestData.AllowedExtensions = []string{extension}
	} else {
		manifestData.AllowedOrigins = []string{extension}
	}

	manifestJSON, err := json.MarshalIndent(manifestData, "", "  ")
	if err != nil {
		return core.NewE100("host-install", err)
	}

	p.UpdateTitle(steps[2])
	err = installHost(manifestJSON, manifestFile, browser)
	if err != nil {
		return core.NewE100("host-install", err)
	}
	pterm.Success.Println(steps[2])
	p.Increment()

	return nil
}

func uninstallNativeHost(args []string, _ *core.CLIFlags) error {
	if len(args) != 1 {
		return core.NewE100("host-uninstall", errMissingBrowser)
	}

	browser := args[0]
	if !core.StringInSlice(browser, supportedBrowsers) {
		return core.NewE100("host-uninstall", errInvalidBrowser)
	}

	steps := []string{"removing files", "uninstalling host"}
	p, _ := pterm.DefaultProgressbar.WithTotal(len(steps)).WithTitle("Uninstalling host").Start()

	locations, err := getLocation(browser)
	if err != nil {
		return core.NewE100("host-uninstall", err)
	}
	p.UpdateTitle(steps[0])

	exeName := getExecName("vale-native")
	for _, file := range []string{"config.json", exeName, "LICENSE", "README.md", "host.log"} {
		fp := filepath.Join(locations["appDir"], file)
		if core.FileExists(fp) {
			err = os.Remove(filepath.Join(locations["appDir"], file))
			if err != nil {
				return core.NewE100("host-uninstall", err)
			}
		}
	}
	pterm.Success.Println(steps[0])
	p.Increment()

	p.UpdateTitle(steps[1])
	manifestFile := filepath.Join(locations["manifestDir"], nativeHostName+".json")

	if core.FileExists(manifestFile) {
		err = os.Remove(manifestFile)
		if err != nil {
			return core.NewE100("host-uninstall", err)
		}
	}

	err = unsetManifestRegistry(browser)
	if err != nil {
		return core.NewE100("host-uninstall", err)
	}

	pterm.Success.Println(steps[1])
	p.Increment()

	return nil
}
