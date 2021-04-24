// Package api provides an interface for accessing Vale's internal linting
// functionality.
package api

import (
	"errors"
	"io"
	"path/filepath"

	"github.com/errata-ai/vale/v2/internal/check"
	"github.com/errata-ai/vale/v2/internal/cli"
	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/lint"
	"github.com/errata-ai/vale/v2/internal/nlp"
	"github.com/jdkato/prose/tag"
)

// TaggedWord is a word with an NLP context.
type TaggedWord struct {
	Token tag.Token
	Line  int
	Span  []int
}

// CompiledRule is a rule's compiled regex.
type CompiledRule struct {
	Pattern string
}

// TagSentence assigns part-of-speech tags to the given sentence.
func TagSentence(text, lang, endpoint string) ([]nlp.TaggedWord, error) {
	return core.TextToContext(
		text, &nlp.NLPInfo{Lang: lang, Endpoint: endpoint}), nil
}

// TestRule returns the linting results for a single rule
func TestRule(rule, text string) ([]*core.File, error) {
	if !core.FileExists(rule) || !core.FileExists(text) {
		return []*core.File{}, errors.New("invalid arguments")
	}
	// Create a pre-filled configuration:
	cfg, err := core.NewConfig(&cli.Flags)
	if err != nil {
		return []*core.File{}, err
	}

	cfg.MinAlertLevel = 0
	cfg.GBaseStyles = []string{"Test"}
	cfg.Flags.InExt = ".txt" // default value

	linter, err := lint.NewLinter(cfg)
	if err != nil {
		return []*core.File{}, err
	}

	err = linter.Manager.AddRuleFromFile("Test.Rule", rule)
	if err != nil {
		return []*core.File{}, err
	}

	linted, err := linter.Lint([]string{text}, "*")
	if err != nil {
		return []*core.File{}, err
	}
	return linted, nil
}

// CompileRule returns a compiled rule.
func CompileRule(path string) (CompiledRule, error) {
	if !core.FileExists(path) {
		return CompiledRule{}, errors.New("invalid arguments")
	}
	fName := filepath.Base(path)

	cfg, err := core.NewConfig(&cli.Flags)
	if err != nil {
		return CompiledRule{}, err
	}

	// Create our check manager:
	mgr, err := check.NewManager(cfg)
	if err != nil {
		return CompiledRule{}, err
	}

	err = mgr.AddRuleFromFile(fName, path)
	if err != nil {
		return CompiledRule{}, err
	}
	return CompiledRule{Pattern: mgr.Rules()[fName].Pattern()}, nil
}

// PrintError shows an error message in one of Vale's output styles.
func PrintError(err error, style string, out io.Writer) {
	cli.ShowError(err, style, out)
}

// PrintJSONAlerts prints Alerts in map[file.path][]Alert form.
func PrintJSONAlerts(linted []*core.File) bool {
	return cli.PrintJSONAlerts(linted)
}
