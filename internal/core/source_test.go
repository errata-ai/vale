package core

import (
	"os"
	"path/filepath"
	"testing"
)

var knownConfig = filepath.Join(testData, "fixtures", "formats", ".vale.ini")

// TestNoBaseConfig tests that we raise an error if we can't find a base
// config.
func TestNoBaseConfig(t *testing.T) {
	cfg, err := NewConfig(&CLIFlags{})
	if err != nil {
		t.Fatal(err)
	}

	homeDir, err := os.UserHomeDir()
	if err != nil {
		t.Fatal(err)
	}

	err = os.Chdir(homeDir)
	if err != nil {
		t.Fatal(err)
	}

	_, err = FromFile(cfg, true)
	if err == nil {
		t.Fatal("Expected error, got nil", cfg.ConfigFiles)
	}
}

// TestFlagBase tests that we respect the `--config` option for setting a base
// config.
func TestFlagBase(t *testing.T) {
	cfg, err := NewConfig(&CLIFlags{Path: knownConfig})
	if err != nil {
		t.Fatal(err)
	}

	homeDir, err := os.UserHomeDir()
	if err != nil {
		t.Fatal(err)
	}

	err = os.Chdir(homeDir)
	if err != nil {
		t.Fatal(err)
	}

	_, err = FromFile(cfg, true)
	if err != nil {
		t.Fatal(err)
	}
}

// TestEnvBase tests that we respect the `VALE_CONFIG_PATH` option for setting
// a base config.
func TestEnvBase(t *testing.T) {
	os.Setenv("VALE_CONFIG_PATH", knownConfig)

	cfg, err := NewConfig(&CLIFlags{})
	if err != nil {
		t.Fatal(err)
	}

	homeDir, err := os.UserHomeDir()
	if err != nil {
		t.Fatal(err)
	}

	err = os.Chdir(homeDir)
	if err != nil {
		t.Fatal(err)
	}

	_, err = FromFile(cfg, true)
	if err != nil {
		t.Fatal(err)
	}

	os.Unsetenv("VALE_CONFIG_PATH")
}
