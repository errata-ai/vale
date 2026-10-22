package core

import (
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"gopkg.in/yaml.v3"

	rx "github.com/vale-cli/vale/v3/internal/regex"
	"github.com/vale-cli/vale/v3/internal/spell"
	"github.com/vale-cli/vale/v3/internal/system"
)

// vocabFiles are the names a YAML vocabulary may have.
var vocabFiles = []string{"vocab.yml", "vocab.yaml"}

// vocabEntry is one item of a YAML vocabulary's `accept` or `reject` list:
// a term, or a term mapped to its options.
type vocabEntry struct {
	term string
	opts vocabOptions
	line int
}

// vocabOptions change how an entry's term is matched.
type vocabOptions struct {
	Flags      string `yaml:"flags"`
	Ignorecase bool   `yaml:"ignorecase"`
	Regex      bool   `yaml:"regex"`
}

var vocabKeys = []string{"flags", "ignorecase", "regex"}

func (e *vocabEntry) UnmarshalYAML(node *yaml.Node) error {
	e.line = node.Line
	switch {
	case node.Kind == yaml.ScalarNode:
		e.term = node.Value
		return nil
	case node.Kind != yaml.MappingNode || len(node.Content) != 2:
		return &vocabError{line: node.Line, msg: "an entry is a term, or a term mapped to its options"}
	}

	key, value := node.Content[0], node.Content[1]
	e.term = key.Value
	if value.Kind == yaml.ScalarNode {
		if value.Tag == "!!null" {
			return nil
		}
		return &vocabError{line: value.Line, msg: fmt.Sprintf(
			"'%s' maps to '%s', but a vocabulary entry maps to options; for a replacement, use a substitution rule",
			key.Value, value.Value)}
	} else if value.Kind != yaml.MappingNode {
		return &vocabError{line: value.Line, msg: fmt.Sprintf("'%s' should map to its options", key.Value)}
	}

	for i := 0; i+1 < len(value.Content); i += 2 {
		if k := value.Content[i]; !StringInSlice(k.Value, vocabKeys) {
			return &vocabError{line: k.Line, msg: fmt.Sprintf(
				"'%s' isn't a vocabulary option; expected %s", k.Value, strings.Join(vocabKeys, ", "))}
		}
	}
	return value.Decode(&e.opts)
}

type vocabError struct {
	line int
	msg  string
}

func (e *vocabError) Error() string { return e.msg }

type vocabFile struct {
	Affix  string       `yaml:"affix"`
	Accept []vocabEntry `yaml:"accept"`
	Reject []vocabEntry `yaml:"reject"`
}

// ExpandFunc returns the forms a word's affix flags name.
type ExpandFunc func(word, flags string) ([]string, error)

// BuiltinAffix names the affix file of Vale's built-in dictionary.
const BuiltinAffix = "en_US-web"

// AffixExpander returns the ExpandFunc for the affix file name, found as a
// spelling rule's dictionaries are: in each search path's dictionaries
// folder, then in $DICPATH. An empty name, or BuiltinAffix without a file
// of that name, is the built-in dictionary's.
func AffixExpander(cfg *Config, name string) (ExpandFunc, error) {
	if aff := findAffix(cfg, name); aff != "" {
		return func(word, flags string) ([]string, error) {
			return spell.ExpandWith(aff, word, flags)
		}, nil
	} else if name == "" || name == BuiltinAffix {
		return spell.Expand, nil
	}
	return nil, fmt.Errorf("'%s.aff' not found in %s or $DICPATH", name, DictDir)
}

// readVocabYAML adds the entries of the YAML vocabulary at path to vocab.
func readVocabYAML(path string, vocab *Vocabulary, cfg *Config) error {
	src, err := os.ReadFile(path)
	if err != nil {
		return err
	}

	path = RelToWD(path)

	var file vocabFile
	if err = yaml.Unmarshal(src, &file); err != nil {
		var ve *vocabError
		if errors.As(err, &ve) {
			return NewE201FromPosition(ve.msg, path, ve.line)
		}
		return NewE201FromPosition(err.Error(), path, yamlErrorLine(err))
	}

	expand, err := AffixExpander(cfg, file.Affix)
	if err != nil {
		return NewE201FromTarget(err.Error(), file.Affix, path)
	}

	for _, list := range []struct {
		entries []vocabEntry
		into    *[]string
	}{{file.Accept, &vocab.Accepted}, {file.Reject, &vocab.Rejected}} {
		for _, e := range list.entries {
			patterns, perr := e.patterns(expand)
			if perr != nil {
				return NewE201FromPosition(perr.Error(), path, e.line)
			}
			*list.into = append(*list.into, patterns...)
		}
	}
	return nil
}

// patterns returns what an entry contributes, as the patterns a `.txt`
// vocabulary line would.
func (e *vocabEntry) patterns(expand ExpandFunc) ([]string, error) {
	term := strings.TrimSpace(e.term)
	if term == "" {
		return nil, errors.New("an entry needs a term")
	}

	var out []string
	switch {
	case e.opts.Regex && e.opts.Flags != "":
		return nil, fmt.Errorf("'%s' can't have both 'regex' and 'flags'", term)
	case e.opts.Regex:
		if _, err := rx.Compile(term); err != nil {
			return nil, fmt.Errorf("'%s' isn't a valid pattern: %w", term, err)
		}
		out = []string{term}
	case e.opts.Flags != "":
		words, err := expand(term, e.opts.Flags)
		if err != nil {
			return nil, err
		}
		for _, w := range words {
			out = append(out, literalPattern(w))
		}
	default:
		out = []string{literalPattern(term)}
	}

	if e.opts.Ignorecase {
		for i, p := range out {
			out[i] = "(?i)" + p
		}
	}
	return out, nil
}

// RelToWD returns path relative to the working directory when it's inside
// it, so an error names a file as the user would.
func RelToWD(path string) string {
	if wd, err := os.Getwd(); err == nil {
		path, _ = system.RelInside(wd, path)
	}
	return path
}

// findAffix returns the path of the `.aff` file named name, looked up as a
// spelling rule's dictionaries are: in each search path's dictionaries
// folder, then in $DICPATH.
func findAffix(cfg *Config, name string) string {
	if name == "" {
		return ""
	}
	file := name + ".aff"
	var roots []string
	if cfg != nil {
		for _, p := range cfg.SearchPaths() {
			roots = append(roots, filepath.Join(p, DictDir))
		}
	}
	if dicpath := os.Getenv("DICPATH"); dicpath != "" {
		roots = append(roots, dicpath)
	}
	for _, root := range roots {
		if candidate := filepath.Join(root, file); system.FileExists(candidate) {
			return candidate
		}
	}
	return ""
}

// literalPattern returns a pattern that matches term as written. A term
// whose only special character is a period is left alone, as in a `.txt`
// vocabulary, where periods are matched literally.
func literalPattern(term string) string {
	bare := strings.ReplaceAll(term, ".", "")
	if regexp.QuoteMeta(bare) == bare {
		return term
	}
	return regexp.QuoteMeta(term)
}

var yamlLine = regexp.MustCompile(`line (\d+):`)

// yamlErrorLine returns the first line a yaml.v3 error names, or 0.
func yamlErrorLine(err error) int {
	var line int
	if m := yamlLine.FindStringSubmatch(err.Error()); m != nil {
		_, _ = fmt.Sscan(m[1], &line)
	}
	return line
}
