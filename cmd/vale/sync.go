package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/mholt/archiver"
	cp "github.com/otiai10/copy"
)

var library = "https://raw.githubusercontent.com/errata-ai/styles/master/library.json"

func newVocab(path, name string) error {
	var ferr error

	root := filepath.Join(path, "Vocab", name)
	if _, err := os.Stat(root); os.IsNotExist(err) {
		ferr = os.MkdirAll(root, os.ModePerm)
		if ferr != nil {
			return ferr
		}
	}

	for _, f := range []string{"accept.txt", "reject.txt"} {
		ferr = os.WriteFile(filepath.Join(root, f), []byte{}, 0644)
	}

	return ferr
}

func initPath(cfg *core.Config) error {
	if !core.IsDir(cfg.StylesPath) {
		if err := os.MkdirAll(cfg.StylesPath, os.ModePerm); err != nil {
			e := fmt.Errorf("unable to initialize StylesPath (value = '%s')", cfg.StylesPath)
			return core.NewE100("initPath", e)
		}
		for _, vocab := range cfg.Vocab {
			if err := newVocab(cfg.StylesPath, vocab); err != nil {
				return err
			}
		}
	}
	return nil
}

func readPkg(pkg, path string, idx int) error {
	lookup, err := getLibrary(path)
	if err != nil {
		return err
	}

	found := false
	for _, entry := range lookup {
		if pkg == entry.Name {
			found = true
			if err = download(pkg, entry.URL, path, idx); err != nil {
				return err
			}
		}
	}

	if !found {
		name := fileNameWithoutExt(pkg)
		if err = loadPkg(name, pkg, path, idx); err != nil {
			return err
		}
	}

	return nil
}

func loadPkg(name, urlOrPath, styles string, index int) error {
	if fileInfo, err := os.Stat(urlOrPath); err == nil {
		if fileInfo.IsDir() {
			return loadLocalPkg(name, urlOrPath, styles, index)
		} else {
			return loadLocalZipPkg(name, urlOrPath, styles, index)
		}
	}
	return download(name, urlOrPath, styles, index)
}

func loadLocalPkg(name, pkgPath, styles string, index int) error {
	dir, err := os.MkdirTemp("", name)
	if err != nil {
		return err
	}

	if err := cp.Copy(pkgPath, dir); err != nil {
		return err
	}

	return installPkg(dir, "", styles, index)
}

func loadLocalZipPkg(name, pkgPath, styles string, index int) error {
	dir, err := os.MkdirTemp("", name)
	if err != nil {
		return err
	}

	if err = archiver.Unarchive(pkgPath, dir); err != nil {
		return err
	}

	return installPkg(dir, name, styles, index)
}

func download(name, url, styles string, index int) error {
	dir, err := os.MkdirTemp("", name)
	if err != nil {
		return err
	}

	if err = fetch(url, dir); err != nil {
		return err
	}

	return installPkg(dir, name, styles, index)
}

func installPkg(dir, name, styles string, index int) error {
	root := filepath.Join(dir, name)
	path := filepath.Join(root, "styles")
	pipe := filepath.Join(styles, ".vale-config")
	cfg := filepath.Join(root, ".vale.ini")

	if !core.IsDir(path) && !core.FileExists(cfg) {
		return moveAsset(name, dir, styles) // style-only
	}

	// StylesPath
	if core.IsDir(path) {
		if err := moveDir(path, styles, false); err != nil {
			return err
		}
		// Vocab
		loc1 := filepath.Join(path, "Vocab")
		if core.IsDir(loc1) {
			loc2 := filepath.Join(styles, "Vocab")
			if err := moveDir(loc1, loc2, false); err != nil {
				return err
			}
		}
	}

	// .vale.ini
	if core.FileExists(cfg) {
		pkgs, err := core.GetPackages(cfg)
		if err != nil {
			return err
		}

		for idx, pkg := range pkgs {
			if err = readPkg(pkg, styles, idx); err != nil {
				return err
			}
		}
		entry := fmt.Sprintf("%d-%s.ini", index, name)

		err = os.Rename(cfg, filepath.Join(root, entry))
		if err != nil {
			return err
		} else if err = moveAsset(entry, root, pipe); err != nil {
			return err
		}
	}

	return nil
}

func moveDir(old, new string, isVocab bool) error {
	files, err := os.ReadDir(old)
	if err != nil {
		return err
	}

	for _, file := range files {
		if file.Name() == "Vocab" == isVocab {
			if err = moveAsset(file.Name(), old, new); err != nil {
				return err
			}
		}
	}

	return nil
}

func moveAsset(name, old, new string) error {
	src := filepath.Join(old, name)
	dst := filepath.Join(new, name)

	if core.FileExists(dst) || core.IsDir(dst) {
		if err := os.RemoveAll(dst); err != nil {
			return err
		}
	}

	err := os.MkdirAll(new, os.ModePerm)
	if err != nil {
		return err
	}

	if err := cp.Copy(src, dst); err != nil {
		return err
	}

	return nil
}

func getLibrary(path string) ([]Style, error) {
	styles := []Style{}

	resp, err := fetchJSON(library)
	if err != nil {
		return styles, err
	} else if err = json.Unmarshal(resp, &styles); err != nil {
		return styles, err
	}

	return styles, err
}
