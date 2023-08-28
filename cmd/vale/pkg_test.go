package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/errata-ai/vale/v2/internal/core"
)

var TestData = "../../testdata/pkg"

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

	zip, err := filepath.Abs(filepath.Join(TestData, "write-good.zip"))
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

	zip, err := filepath.Abs(filepath.Join(TestData, "write-good"))
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

func TestLocalComplete(t *testing.T) { //nolint:dupl
	path, err := mockPath()
	if err != nil {
		t.Fatal(err)
	}

	zip, err := filepath.Abs(filepath.Join(TestData, "ISC.zip"))
	if err != nil {
		t.Fatal(err)
	}

	err = readPkg(zip, path, 0)
	if err != nil {
		t.Fatal(err)
	}

	if !core.IsDir(filepath.Join(path, "ISC")) {
		t.Fatal("unable to find 'ISC' in StylesPath")
	}

	vocab := filepath.Join(path, "Vocab", "ISC_General", "accept.txt")
	if !core.FileExists(vocab) {
		t.Fatal("unable to find 'ISC_General' in Vocab")
	}

	b, err := os.ReadFile(vocab)
	if err != nil {
		t.Fatal(err)
	}
	lines := strings.Split(string(b), "\n")

	if !core.StringInSlice("bar", lines) {
		t.Fatalf("unable to find 'bar' in %v", lines)
	}
}

func TestLocalOnlyStyles(t *testing.T) { //nolint:dupl
	path, err := mockPath()
	if err != nil {
		t.Fatal(err)
	}

	zip, err := filepath.Abs(filepath.Join(TestData, "OnlyStyles.zip"))
	if err != nil {
		t.Fatal(err)
	}

	err = readPkg(zip, path, 0)
	if err != nil {
		t.Fatal(err)
	}

	if !core.IsDir(filepath.Join(path, "ISC")) {
		t.Fatal("unable to find 'ISC' in StylesPath")
	}

	vocab := filepath.Join(path, "Vocab", "ISC_General", "accept.txt")
	if !core.FileExists(vocab) {
		t.Fatal("unable to find 'ISC_General' in Vocab")
	}

	b, err := os.ReadFile(vocab)
	if err != nil {
		t.Fatal(err)
	}
	lines := strings.Split(string(b), "\n")

	if !core.StringInSlice("bar", lines) {
		t.Fatalf("unable to find 'bar' in %v", lines)
	}
}

func TestNoPkgFound(t *testing.T) {
	path, err := mockPath()
	if err != nil {
		t.Fatal(err)
	}

	err = readPkg("https://github.com/errata-ai/Microsoft/releases/download/v0.14.1/Microsoft.zip", path, 0)
	if err == nil {
		t.Fatal("expected error, got nil")
	}

	msg := "could not fetch 'https://github.com/errata-ai/Microsoft/releases/download/v0.14.1/Microsoft.zip' (status code '404')"
	if !strings.Contains(err.Error(), msg) {
		t.Fatalf("expected '%s', got '%s'", msg, err.Error())
	}
}
