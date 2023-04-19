package main

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/errata-ai/vale/v2/internal/core"
)

var TEST_DATA = "../../testdata/pkg"

func mockPath() (string, error) {
	cfg, err := core.NewConfig(&core.CLIFlags{})
	if err != nil {
		return "", err
	}
	cfg.StylesPath = os.TempDir()

	err = initPath(cfg)
	if err != nil {
		return "", err
	}

	return cfg.StylesPath, nil
}

func TestLibrary(t *testing.T) {
	path, err := mockPath()
	if err != nil {
		t.Fatal(err)
	}

	err = readPkg("write-good", path, 0)
	if err != nil {
		t.Fatal(err)
	}

	if !core.IsDir(filepath.Join(path, "write-good")) {
		t.Fatal("unable to find 'write-good' in StylesPath")
	}

	if !core.FileExists(filepath.Join(path, "write-good", "E-Prime.yml")) {
		t.Fatal("unable to find 'E-Prime' in StylesPath")
	}
}

func TestLocalZip(t *testing.T) {
	path, err := mockPath()
	if err != nil {
		t.Fatal(err)
	}

	zip, err := filepath.Abs(filepath.Join(TEST_DATA, "write-good.zip"))
	if err != nil {
		t.Fatal(err)
	}

	err = readPkg(zip, path, 0)
	if err != nil {
		t.Fatal(err)
	}

	if !core.IsDir(filepath.Join(path, "write-good")) {
		t.Fatal("unable to find 'write-good' in StylesPath")
	}

	if !core.FileExists(filepath.Join(path, "write-good", "E-Prime.yml")) {
		t.Fatal("unable to find 'E-Prime' in StylesPath")
	}
}

func TestLocalDir(t *testing.T) {
	path, err := mockPath()
	if err != nil {
		t.Fatal(err)
	}

	zip, err := filepath.Abs(filepath.Join(TEST_DATA, "write-good"))
	if err != nil {
		t.Fatal(err)
	}

	err = readPkg(zip, path, 0)
	if err != nil {
		t.Fatal(err)
	}

	if !core.IsDir(filepath.Join(path, "write-good")) {
		t.Fatal("unable to find 'write-good' in StylesPath")
	}

	if !core.FileExists(filepath.Join(path, "write-good", "E-Prime.yml")) {
		t.Fatal("unable to find 'E-Prime' in StylesPath")
	}
}
