package cli

import (
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"

	"github.com/AlecAivazis/survey/v2"
)

var defaultConfig = `StylesPath = %s
MinAlertLevel = suggestion

Vocab = Base

[%s]
BasedOnStyles = Vale, %s`

var base2URL = map[string]string{
	"Google":    "https://github.com/errata-ai/Google/releases/latest/download/Google.zip",
	"Microsoft": "https://github.com/errata-ai/Microsoft/releases/latest/download/Microsoft.zip",
}

func stylize(base string) string {
	if base == "Skip for now" {
		return ""
	} else if strings.HasPrefix(base, "Google") {
		return "Google"
	} else if strings.HasPrefix(base, "Microsoft") {
		return "Microsoft"
	} else {
		return base
	}
}

func toStyle(ans interface{}) interface{} {
	op := ans.(survey.OptionAnswer)
	op.Value = stylize(op.Value)
	return op
}

func toGlob(formats []string) string {
	glob := "*"
	if len(formats) == 1 && formats[0] == "Other" {
		return glob
	}

	exts := []string{}
	for _, f := range formats {
		if f == "Markdown" {
			exts = append(exts, "md")
		} else if f == "AsciiDoc" {
			exts = append(exts, "adoc")
		} else if f == "reStructuredText" {
			exts = append(exts, "rst")
		}
	}
	return fmt.Sprintf(glob+".{%s}", strings.Join(exts, ","))
}

func addVocab(path string) error {
	var ferr error

	root := filepath.Join(path, "Vocab", "Base")
	if _, err := os.Stat(root); os.IsNotExist(err) {
		os.MkdirAll(root, os.ModePerm)
	}

	for _, f := range []string{"accept.txt", "reject.txt"} {
		ferr = ioutil.WriteFile(filepath.Join(root, f), []byte{}, 0644)
	}

	return ferr
}

var questions = []*survey.Question{
	{
		Name: "name",
		Prompt: &survey.Input{
			Message: "What would you like to name your style?",
			Help:    "Styles should have short, single-word names."},
		Validate: func(val interface{}) error {
			if str, ok := val.(string); !ok || strings.Contains(str, " ") || len(str) == 0 {
				return errors.New("style names must be non-empty and cannot contain spaces")
			}
			return nil
		},
	},
	{
		Name: "base",
		Prompt: &survey.Select{
			Message: "Choose a base style to install:",
			Help:    "A \"base\" style serves as a starting point for further customization.",
			Options: []string{"Microsoft Writing Style Guide", "Google Developer Documentation Style Guide", "Skip for now"},
		},
		Validate:  survey.Required,
		Transform: toStyle,
	},
	{
		Name: "format",
		Prompt: &survey.MultiSelect{
			Message: "What file format(s) do you want to lint?",
			Options: []string{"Markdown", "AsciiDoc", "reStructuredText", "Other"},
		},
		Validate: survey.Required,
	},
	{
		Name: "path",
		Prompt: &survey.Input{
			Message: "Where would you like to save your styles?",
			Help:    "This is should be a file path path relative to the current directory.",
			Default: "styles"},
		Validate: func(val interface{}) error {
			if str, ok := val.(string); !ok {
				return errors.New("path must be non-empty")
			} else if err := os.MkdirAll(str, 0755); err != nil {
				return err
			} else if err := addVocab(str); err != nil {
				return err
			}
			return nil
		},
	},
}
