package cli

import (
	"bufio"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strconv"
	"strings"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/jdkato/prose/transform"
	"github.com/karrick/godirwalk"
	"github.com/mmcdole/gofeed"
	"github.com/schollz/closestmatch"
	"github.com/xrash/smetrics"
)

// Solution is a potential solution to an alert.
type Solution struct {
	Suggestions []string `json:"suggestions"`
	Error       string   `json:"error"`
}

// An Action represents a possible solution to an Alert.
//
// The possible
type Action struct {
	Name   string   // the name of the action -- e.g, 'replace'
	Params []string // a slice of parameters for the given action
}

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

type fixer func(core.Alert) ([]string, error)

var fixers = map[string]fixer{
	"suggest": suggest,
	"replace": replaced,
	"remove":  remove,
	"convert": convert,
	"edit":    edit,
}

func init() {
	flag.BoolVar(&Flags.Remote, "mode-rev-compat", false,
		"prioritize local Vale configurations")
	flag.StringVar(&Flags.Built, "built", "", "post-processed file path")

	Actions["install"] = install
	Actions["suggest"] = getSuggestions
	Actions["new-project"] = newVocab
	Actions["remove-project"] = removeVocab
	Actions["edit-project"] = editVocab
	Actions["ls-projects"] = getVocabs
	Actions["get-vocab"] = getVocab
	Actions["update-vocab"] = updateVocab
	Actions["ls-styles"] = getStyles
	Actions["ls-library"] = getLibrary
}

func fetch(src, dst string) error {
	// Fetch the resource from the web:
	resp, err := http.Get(src)
	if err != nil {
		return err
	}

	// Create a temp file to represent the archive locally:
	tmpfile, err := ioutil.TempFile("", "temp.*.zip")
	if err != nil {
		return err
	}
	defer os.Remove(tmpfile.Name()) // clean up

	// Write to the  local archive:
	_, err = io.Copy(tmpfile, resp.Body)
	if err != nil {
		return err
	} else if err = tmpfile.Close(); err != nil {
		return err
	}
	return core.Unzip(tmpfile.Name(), dst)
}

// parseAlert returns a slice of suggestions for the given Vale alert.
func parseAlert(s string) (Solution, error) {
	body := core.Alert{}
	resp := Solution{}

	err := json.Unmarshal([]byte(s), &body)
	if err != nil {
		return Solution{}, err
	}

	suggestions, err := processAlert(body)
	if err != nil {
		resp.Error = err.Error()
	}
	resp.Suggestions = suggestions

	return resp, nil
}

func processAlert(alert core.Alert) ([]string, error) {
	action := alert.Action.Name
	if f, found := fixers[action]; found {
		return f(alert)
	}
	return []string{}, errors.New("unknown action")
}

func install(args []string, cfg *core.Config) error {
	style := filepath.Join(cfg.StylesPath, args[0])
	if core.IsDir(style) {
		os.RemoveAll(style) // Remove existing version
	}
	return fetch(args[1], cfg.StylesPath)
}

func newVocab(args []string, cfg *core.Config) error {
	if len(args) != 2 {
		return sendResponse(
			"failed to create project",
			errors.New("invalid arguments; expected 2"),
		)
	}
	err := AddProject(args[0], args[1])
	if err != nil {
		return sendResponse("failed to create project", err)
	}
	return sendResponse(fmt.Sprintf(
		"Successfully created '%s'", args[1]), nil)
}

func removeVocab(args []string, cfg *core.Config) error {
	if len(args) != 2 {
		return sendResponse(
			"failed to create project",
			errors.New("invalid arguments; expected 2"),
		)
	}
	return RemoveProject(args[0], args[1])
}

func editVocab(args []string, cfg *core.Config) error {
	return EditProject(args)
}

func getVocabs(args []string, cfg *core.Config) error {
	projects, err := ListDir(args[0], "Vocab")
	if err != nil {
		return sendResponse("failed to list projects", err)
	}
	return printJSON(projects)
}

func getVocab(args []string, cfg *core.Config) error {
	words, err := GetVocab(args)
	if err != nil {
		return sendResponse("failed to get vocab", err)
	}
	return printJSON(words)
}

func updateVocab(args []string, cfg *core.Config) error {
	err := UpdateVocab(args)
	if err != nil {
		return sendResponse(
			fmt.Sprintf("Failed to update '%s'", args[1]),
			err)
	}
	return sendResponse(fmt.Sprintf(
		"Successfully updated '%s'", args[1]), nil)
}

func getStyles(args []string, cfg *core.Config) error {
	styles, err := ListDir(args[0], "")
	if err != nil {
		return sendResponse("failed to list styles", err)
	}
	return printJSON(styles)
}

func getLibrary(args []string, cfg *core.Config) error {
	styles, err := GetLibrary(args[0])
	if err != nil {
		return sendResponse("Failed to fetch library", err)
	}
	return printJSON(styles)
}

func getSuggestions(args []string, cfg *core.Config) error {
	resp, err := parseAlert(args[0])
	if err != nil {
		return err
	}
	return printJSON(resp)
}

func processSuggestions(word string, opt []string) []string {
	sort.SliceStable(opt, func(i, j int) bool {
		return smetrics.Jaro(word, opt[i]) > smetrics.Jaro(word, opt[j])
	})
	return opt[:3]
}

func suggest(alert core.Alert) ([]string, error) {
	cm := closestmatch.New(core.Words, []int{2})

	suggestions := []string{}
	if alert.Action.Params[0] == "spellings" {
		target := alert.Match
		matches := cm.ClosestN(strings.ToLower(target), 10)
		for _, s := range processSuggestions(target, matches) {
			if target == strings.Title(target) {
				s = strings.Title(s)
			}
			suggestions = append(suggestions, s)
		}
	}

	return suggestions, nil
}

func replaced(alert core.Alert) ([]string, error) {
	return alert.Action.Params, nil
}

func remove(alert core.Alert) ([]string, error) {
	return []string{""}, nil
}

func convert(alert core.Alert) ([]string, error) {
	match := alert.Match
	if alert.Action.Params[0] == "simple" {
		match = transform.Simple(match)
	}
	return []string{match}, nil
}

func edit(alert core.Alert) ([]string, error) {
	match := alert.Match

	switch name := alert.Action.Params[0]; name {
	case "replace":
		regex, err := regexp.Compile(alert.Action.Params[1])
		if err != nil {
			return []string{}, err
		}
		match = regex.ReplaceAllString(match, alert.Action.Params[2])
	case "trim":
		match = strings.TrimRight(match, alert.Action.Params[1])
	case "remove":
		match = strings.Trim(match, alert.Action.Params[1])
	case "truncate":
		match = strings.Split(match, alert.Action.Params[1])[0]
	case "split":
		index, err := strconv.Atoi(alert.Action.Params[2])
		if err != nil {
			return []string{}, err
		}
		match = strings.Split(match, alert.Action.Params[1])[index]
	}

	return []string{strings.TrimSpace(match)}, nil
}

// ListDir prints all folders on the current StylesPath.
func ListDir(path, entry string) ([]string, error) {
	var styles []string

	files, err := ioutil.ReadDir(filepath.Join(path, entry))
	if err != nil {
		return styles, err
	}

	for _, f := range files {
		if f.IsDir() && f.Name() != "Vocab" {
			styles = append(styles, f.Name())
		}
	}
	return styles, nil
}

// AddProject adds a new project to the current StylesPath.
func AddProject(path, name string) error {
	var ferr error

	root := filepath.Join(path, "Vocab", name)
	if _, err := os.Stat(root); os.IsNotExist(err) {
		os.MkdirAll(root, os.ModePerm)
	}

	for _, f := range []string{"accept.txt", "reject.txt"} {
		ferr = ioutil.WriteFile(filepath.Join(root, f), []byte{}, 0644)
	}

	return ferr
}

// RemoveProject deletes a project from the current StylesPath.
func RemoveProject(path, name string) error {
	return os.RemoveAll(filepath.Join(path, "Vocab", name))
}

// EditProject renames a project from the current StylesPath.
func EditProject(args []string) error {
	old := filepath.Join(args[0], "Vocab", args[1])
	new := filepath.Join(args[0], "Vocab", args[2])
	return os.Rename(old, new)
}

// UpdateVocab updates a vocab file for the given project.
func UpdateVocab(args []string) error {
	parts := strings.Split(args[1], ".")
	dest := filepath.Join(args[0], "Vocab", parts[0], parts[1]+".txt")
	return ioutil.WriteFile(dest, []byte(args[2]), 0644)
}

// GetVocab extracts a vocab file for a project.
func GetVocab(args []string) ([]string, error) {
	vocab := filepath.Join(args[0], "Vocab", args[1], args[2]+".txt")
	words := []string{}

	if core.FileExists(vocab) {
		f, err := os.Open(vocab)
		if err != nil {
			return words, err
		}
		scanner := bufio.NewScanner(f)
		for scanner.Scan() {
			words = append(words, scanner.Text())
		}
	}

	return words, nil
}

// GetLibrary returns the latest style library.
//
// TODO: How do we handle manually-installed styles?
func GetLibrary(path string) ([]Style, error) {
	styles := []Style{}
	parser := gofeed.NewParser()

	resp, err := readJSON(library)
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
