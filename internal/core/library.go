package core

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"

	"github.com/karrick/godirwalk"
	"github.com/mmcdole/gofeed"
)

var library = "https://raw.githubusercontent.com/errata-ai/styles/master/library.json"

// Style represents an externally-hosted style.
type Style struct {
	// User-provided fields.
	Author      string `json:"author"`
	Description string `json:"description"`
	Deps        string `json:"deps"`
	Feed        string `json:"feed"`
	Homepage    string `json:"homepage"`
	Name        string `json:"name"`
	URL         string `json:"url"`

	// Generated fields.
	HasUpdate bool `json:"has_update"`
	InLibrary bool `json:"in_library"`
	Installed bool `json:"installed"`
	Addon     bool `json:"addon"`
}

// Meta represents an installed style's meta data.
type Meta struct {
	Author      string   `json:"author"`
	Coverage    float64  `json:"coverage"`
	Description string   `json:"description"`
	Email       string   `json:"email"`
	Feed        string   `json:"feed"`
	Lang        string   `json:"lang"`
	License     string   `json:"license"`
	Name        string   `json:"name"`
	Sources     []string `json:"sources"`
	URL         string   `json:"url"`
	Vale        string   `json:"vale_version"`
	Version     string   `json:"version"`
}

// GetLibrary returns the latest style library.
//
// TODO: How do we handle manually-installed styles?
func GetLibrary(path string) ([]Style, error) {
	styles := []Style{}
	parser := gofeed.NewParser()

	resp, err := getJSON(library)
	if err != nil {
		return styles, err
	} else if err = json.Unmarshal(resp, &styles); err != nil {
		return styles, err
	}

	for i := 0; i < len(styles); i++ {
		s := &styles[i]
		s.InLibrary = true
	}

	err = godirwalk.Walk(path, &godirwalk.Options{
		Callback: func(osPathname string, de *godirwalk.Dirent) error {
			if strings.Contains(osPathname, "add-ons") {
				// We skip the no-longer support "add-ons" directory.
				return godirwalk.SkipThis
			} else if de.Name() != "meta.json" {
				return nil
			}
			name := filepath.Base(filepath.Dir(osPathname))
			meta := Meta{}

			f, _ := ioutil.ReadFile(osPathname)
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

			feed, err := parser.ParseURL(meta.Feed)
			if err != nil {
				return err
			}

			info, err := os.Stat(osPathname)
			if err != nil {
				return err
			} else if info.ModTime().UTC().Before(feed.UpdatedParsed.UTC()) {
				style.HasUpdate = true
			}
			return nil
		},
		Unsorted: true,
	})

	return styles, err
}
