package action

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"

	"github.com/errata-ai/vale/core"
	"github.com/levigross/grequests"
	"github.com/mholt/archiver"
	"github.com/mmcdole/gofeed"
)

var library = "https://raw.githubusercontent.com/errata-ai/styles/master/library.json"

// Style represents an externally-hosted style.
type Style struct {
	// User-provided fields.
	Author      string `json:"author"`
	Description string `json:"description"`
	Feed        string `json:"feed"`
	Homepage    string `json:"homepage"`
	Name        string `json:"name"`
	URL         string `json:"url"`

	// Generated fields.
	HasUpdate bool `json:"has_update"`
	InLibrary bool `json:"in_library"`
	Installed bool `json:"installed"`
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
func GetLibrary(config *core.Config) error {
	styles := []Style{}
	parser := gofeed.NewParser()

	resp, err := grequests.Get(library, nil)
	if err = json.Unmarshal(resp.Bytes(), &styles); err != nil {
		return err
	}

	for i := 0; i < len(styles); i++ {
		s := &styles[i]
		s.InLibrary = true
	}

	err = filepath.Walk(config.StylesPath, func(fp string, fi os.FileInfo, fe error) error {
		if fe != nil {
			return fe
		} else if fi.Name() == "meta.json" {
			meta := Meta{}
			style := &Style{}

			f, _ := ioutil.ReadFile(fp)
			if err := json.Unmarshal(f, &meta); err != nil {
				return err
			}

			for i := 0; i < len(styles); i++ {
				s := &styles[i]
				if s.Name == meta.Name {
					s.Installed = true
					style = s
					break
				}
			}

			feed, err := parser.ParseURL(meta.Feed)
			if err != nil {
				return err
			}

			if fi.ModTime().UTC().Before(feed.UpdatedParsed.UTC()) {
				style.HasUpdate = true
			}

			if !style.InLibrary {
				// Manually installed
				style.Name = meta.Name
				style.Description = meta.Description
				style.Installed = true
				style.Author = meta.Author

				styles = append(styles, *style)
			}
		}
		return nil
	})

	b, _ := json.MarshalIndent(styles, "", "  ")
	fmt.Println(string(b))
	return err
}

// InstallStyle installs the given style using its download link.
func InstallStyle(config *core.Config, args []string) error {
	path := filepath.Join(config.StylesPath, args[0])
	if core.IsDir(path) {
		os.RemoveAll(path) // Remove existing version
	}

	response, _ := grequests.Get(args[1], nil)

	tmpfile, err := ioutil.TempFile("", "temp.*.zip")
	defer os.Remove(tmpfile.Name()) // clean up

	if err != nil {
		b, _ := json.MarshalIndent(err.Error(), "", "  ")
		fmt.Println(string(b))
		return err
	}

	if _, err := tmpfile.Write(response.Bytes()); err != nil {
		b, _ := json.MarshalIndent(err.Error(), "", "  ")
		fmt.Println(string(b))
		return err
	}

	if err := tmpfile.Close(); err != nil {
		b, _ := json.MarshalIndent(err.Error(), "", "  ")
		fmt.Println(string(b))
		return err
	}

	b, _ := json.MarshalIndent(config, "", "  ")
	fmt.Println(string(b))

	return archiver.Unarchive(tmpfile.Name(), config.StylesPath)
}

// ListDir prints all folders on the current StylesPath.
func ListDir(config *core.Config, path string) error {
	files, err := ioutil.ReadDir(filepath.Join(config.StylesPath, path))
	if err != nil {
		return err
	}
	styles := []string{}
	for _, f := range files {
		if f.IsDir() && f.Name() != "Vocab" {
			styles = append(styles, f.Name())
		}
	}
	b, _ := json.MarshalIndent(styles, "", "  ")
	fmt.Println(string(b))
	return nil
}

// AddProject adds a new project to the current StylesPath.
func AddProject(cfg *core.Config, name string) error {
	var ferr error

	root := filepath.Join(cfg.StylesPath, "Vocab", name)
	if _, err := os.Stat(root); os.IsNotExist(err) {
		os.MkdirAll(root, os.ModePerm)
	}

	for _, f := range []string{"accept.txt", "reject.txt"} {
		ferr = ioutil.WriteFile(filepath.Join(root, f), []byte{}, 0644)
	}

	return ferr
}

// RemoveProject deletes a project from the current StylesPath.
func RemoveProject(cfg *core.Config, name string) error {
	return os.RemoveAll(filepath.Join(cfg.StylesPath, "Vocab", name))
}

// EditProject renames a project from the current StylesPath.
func EditProject(cfg *core.Config, args []string) error {
	old := filepath.Join(cfg.StylesPath, "Vocab", args[0])
	new := filepath.Join(cfg.StylesPath, "Vocab", args[1])
	return os.Rename(old, new)
}

// UpdateVocab updates a vocab file for the given project.
func UpdateVocab(config *core.Config, args []string) error {
	parts := strings.Split(args[0], ".")
	dest := filepath.Join(config.StylesPath, "Vocab", parts[0], parts[1]+".txt")
	fmt.Println("Updated " + dest)
	return ioutil.WriteFile(dest, []byte(args[1]), 0644)
}

// GetVocab extracts a vocab file for a project.
func GetVocab(config *core.Config, args []string) error {
	vocab := filepath.Join(config.StylesPath, "Vocab", args[0], args[1]+".txt")
	words := []string{}

	if core.FileExists(vocab) {
		f, _ := os.Open(vocab)
		scanner := bufio.NewScanner(f)
		for scanner.Scan() {
			words = append(words, scanner.Text())
		}
	}

	b, err := json.MarshalIndent(words, "", "  ")
	fmt.Println(string(b))

	return err
}
