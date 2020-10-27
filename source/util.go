package source

import (
	"io"
	"os"
	"path/filepath"
	"strings"

	"github.com/errata-ai/vale/v2/config"
	"github.com/errata-ai/vale/v2/core"
	"github.com/spf13/afero"
)

func determinePath(configPath string, keyPath string) string {
	if !core.IsDir(configPath) {
		configPath = filepath.Dir(configPath)
	}
	sep := string(filepath.Separator)
	abs, _ := filepath.Abs(keyPath)
	rel := strings.TrimRight(keyPath, sep)
	if abs != rel || !strings.Contains(keyPath, sep) {
		// The path was relative
		return filepath.Join(configPath, keyPath)
	}
	return abs
}

func mergeValues(shadows []string) []string {
	values := []string{}
	for _, v := range shadows {
		for _, s := range strings.Split(v, ",") {
			entry := strings.TrimSpace(s)
			if entry != "" && !core.StringInSlice(entry, values) {
				values = append(values, entry)
			}
		}
	}
	return values
}

func validateLevel(key, val string, cfg *config.Config) bool {
	options := []string{"YES", "suggestion", "warning", "error"}
	if val == "NO" || !core.StringInSlice(val, options) {
		return false
	} else if val != "YES" {
		cfg.RuleToLevel[key] = val
	}
	return true
}

func loadVocab(root string, config *config.Config) error {
	root = filepath.Join(config.StylesPath, "Vocab", root)

	err := config.FsWrapper.Walk(root, func(fp string, fi os.FileInfo, err error) error {
		if filepath.Base(fp) == "accept.txt" {
			return config.AddWordListFile(fp, true)
		} else if filepath.Base(fp) == "reject.txt" {
			return config.AddWordListFile(fp, false)
		}
		return err
	})

	return err
}

func copyFile(srcFs afero.Fs, srcFilePath string, destFs afero.Fs, destFilePath string) error {
	srcFile, err := srcFs.Open(srcFilePath)
	if err != nil {
		return err
	}
	defer srcFile.Close()

	srcInfo, err := srcFile.Stat()
	if err != nil {
		return err
	}

	destFile, err := destFs.Create(destFilePath)
	if err != nil {
		return err
	}
	defer destFile.Close()

	_, err = io.Copy(destFile, srcFile)
	if err != nil {
		return err
	}

	if err != nil {
		err = destFs.Chmod(destFilePath, srcInfo.Mode())
	}

	return nil
}

func copyDir(srcFs afero.Fs, srcDirPath string, destFs afero.Fs, destDirPath string) error {
	// get properties of source dir
	srcInfo, err := srcFs.Stat(srcDirPath)
	if err != nil {
		return err
	}

	// create dest dir
	if err = destFs.MkdirAll(destDirPath, srcInfo.Mode()); err != nil {
		return err
	}

	directory, err := srcFs.Open(srcDirPath)
	if err != nil {
		return err
	}
	defer directory.Close()

	entries, err := directory.Readdir(-1)
	if err != nil {
		return err
	}

	for _, e := range entries {
		srcFullPath := filepath.Join(srcDirPath, e.Name())
		destFullPath := filepath.Join(destDirPath, e.Name())

		if e.IsDir() {
			// create sub-directories - recursively
			if err = copyDir(srcFs, srcFullPath, destFs, destFullPath); err != nil {
				return err
			}
		} else {
			// perform copy
			if err = copyFile(srcFs, srcFullPath, destFs, destFullPath); err != nil {
				return err
			}
		}
	}

	return nil
}
