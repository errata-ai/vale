package cli

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"

	"github.com/errata-ai/vale/v2/internal/core"
)

type PackageManager struct {
	Path string
}

var library = "https://raw.githubusercontent.com/errata-ai/styles/master/library.json"

func readPkgs(pkgs []string, path string) error {
	lookup, err := getLibrary(path)
	if err != nil {
		return err
	}

	mgr := PackageManager{Path: path}
	for idx, pkg := range pkgs {
		found := false
		for _, entry := range lookup {
			if pkg == entry.Name {
				found = true
				if err = mgr.download(pkg, entry.URL, idx); err != nil {
					return err
				}
			}
		}

		if !found {
			name := fileNameWithoutExt(pkg)
			if err = mgr.download(name, pkg, idx); err != nil {
				return err
			}
		}
	}

	return nil
}

func (mgr *PackageManager) download(name, url string, index int) error {
	dir, err := ioutil.TempDir("", name)
	if err != nil {
		return err
	}

	if err = fetch(url, dir); err != nil {
		return err
	}

	root := filepath.Join(dir, name)
	path := filepath.Join(root, "styles")
	pipe := filepath.Join(mgr.Path, "Pipeline")

	if !core.IsDir(path) {
		return moveAsset(name, dir, mgr.Path) // style-only
	}

	// StylesPath
	if err = moveDir(path, mgr.Path, false); err != nil {
		return err
	}

	// Vocab
	loc1 := filepath.Join(path, "Vocab")
	loc2 := filepath.Join(mgr.Path, "Vocab")
	if err = moveDir(loc1, loc2, false); err != nil {
		return err
	}

	// .vale.ini
	cfg := filepath.Join(root, ".vale.ini")
	if core.FileExists(cfg) {
		pkgs, err := core.GetPackages(cfg)
		if err != nil {
			return err
		} else if err = readPkgs(pkgs, mgr.Path); err != nil {
			return err
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
	files, err := ioutil.ReadDir(old)
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

	if err := os.Rename(src, dst); err != nil {
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

	for i := 0; i < len(styles); i++ {
		s := &styles[i]
		s.InLibrary = true
	}

	err = filepath.WalkDir(path, func(fp string, de os.DirEntry, err error) error {
		if strings.Contains(fp, "add-ons") {
			return filepath.SkipDir
		} else if de.Name() != "meta.json" {
			return nil
		} else if err != nil {
			return err
		}

		name := filepath.Base(filepath.Dir(fp))
		meta := Meta{}

		f, _ := ioutil.ReadFile(fp)
		if err := json.Unmarshal(f, &meta); err != nil {
			return err
		}

		style := &Style{}
		for i := 0; i < len(styles); i++ {
			s := &styles[i]
			if s.Name == name {
				s.Installed = true
				style = s
				break
			}
		}

		feed, err := parseAtom(meta.Feed)
		if err != nil {
			return err
		}

		t, err := toTime(feed.Updated)
		if err != nil {
			return err
		}

		info, err := os.Stat(fp)
		if err != nil {
			return err
		} else if info.ModTime().UTC().Before(t.UTC()) {
			style.HasUpdate = true
		}
		return nil
	})

	return styles, err
}
