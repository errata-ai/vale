package core

import (
	"bytes"
	"io/ioutil"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
	"unicode/utf8"

	"github.com/errata-ai/vale/v2/internal/nlp"
	"github.com/gobwas/glob"
	"github.com/jdkato/regexp"
)

// AlertLevels holds the possible values for "level" in an external rule.
var AlertLevels = []string{"suggestion", "warning", "error"}

// LevelToInt allows us to easily compare levels in lint.go.
var LevelToInt = map[string]int{
	"suggestion": 0,
	"warning":    1,
	"error":      2,
}

// A File represents a linted text file.
type File struct {
	Alerts     []Alert           // all alerts associated with this file
	BaseStyles []string          // base style assigned in .vale
	Checks     map[string]bool   // syntax-specific checks assigned in .vale
	ChkToCtx   map[string]string // maps a temporary context to a particular check
	Comments   map[string]bool   // comment control statements
	Content    string            // the raw file contents
	Format     string            // 'code', 'markup' or 'prose'
	Lines      []string          // the File's Content split into lines
	NormedExt  string            // the normalized extension (see util/format.go)
	Path       string            // the full path
	Transform  string            // XLST transform
	RealExt    string            // actual file extension
	Sequences  []string          // tracks various info (e.g., defined abbreviations)
	Summary    bytes.Buffer      // holds content to be included in summarization checks

	history  map[string]int
	limits   map[string]int
	isGlobal bool
	simple   bool

	NLP nlp.NLPInfo
}

// An Action represents a possible solution to an Alert.
//
// The possible
type Action struct {
	Name   string   // the name of the action -- e.g, 'replace'
	Params []string // a slice of parameters for the given action
}

// An Alert represents a potential error in prose.
type Alert struct {
	Action      Action // a possible solution
	Check       string // the name of the check
	Description string // why `Message` is meaningful
	Line        int    // the source line
	Link        string // reference material
	Message     string // the output message
	Severity    string // 'suggestion', 'warning', or 'error'
	Span        []int  // the [begin, end] location within a line
	Match       string // the actual matched text

	Hide  bool `json:"-"` // should we hide this alert?
	Limit int  `json:"-"` // the max times to report
}

// A Plugin provides a means of extending Vale.
type Plugin struct {
	Scope string
	Level string
	Rule  func(string, *File) []Alert
}

// A Selector represents a named section of text.
type Selector struct {
	Value []string // e.g., text.comment.line.py
}

// Sections splits a Selector into its parts -- e.g., text.comment.line.py ->
// []string{"text", "comment", "line", "py"}.
func (s Selector) Sections() []string {
	parts := []string{}
	for _, m := range s.Value {
		parts = append(parts, strings.Split(m, ".")...)
	}
	return parts
}

// Contains determines if all if sel's sections are in s.
func (s Selector) Contains(sel Selector) bool {
	return AllStringsInSlice(sel.Sections(), s.Sections())
}

// ContainsString determines if all if sel's sections are in s.
func (s Selector) ContainsString(scope []string) bool {
	for _, option := range scope {
		sel := Selector{Value: []string{option}}
		if s.Contains(sel) {
			return true
		}
	}
	return false
}

// Equal determines if sel == s.
func (s Selector) Equal(sel Selector) bool {
	if len(s.Value) == len(sel.Value) {
		for i, v := range s.Value {
			if sel.Value[i] != v {
				return false
			}
		}
		return true
	}
	return false
}

// Has determines if s has a part equal to scope.
func (s Selector) Has(scope string) bool {
	return StringInSlice(scope, s.Sections())
}

// ByPosition sorts Alerts by line and column.
type ByPosition []Alert

func (a ByPosition) Len() int      { return len(a) }
func (a ByPosition) Swap(i, j int) { a[i], a[j] = a[j], a[i] }
func (a ByPosition) Less(i, j int) bool {
	ai, aj := a[i], a[j]

	if ai.Line != aj.Line {
		return ai.Line < aj.Line
	}
	return ai.Span[0] < aj.Span[0]
}

// ByName sorts Files by their path.
type ByName []*File

func (a ByName) Len() int      { return len(a) }
func (a ByName) Swap(i, j int) { a[i], a[j] = a[j], a[i] }
func (a ByName) Less(i, j int) bool {
	ai, aj := a[i], a[j]
	return ai.Path < aj.Path
}

// NewFile initilizes a File.
func NewFile(src string, config *Config) (*File, error) {
	var format, ext string
	var fbytes []byte

	if FileExists(src) {
		fbytes, _ = ioutil.ReadFile(src)
		if config.Flags.InExt != ".txt" {
			ext, format = FormatFromExt(config.Flags.InExt, config.Formats)
		} else {
			ext, format = FormatFromExt(src, config.Formats)
		}
	} else {
		ext, format = FormatFromExt(config.Flags.InExt, config.Formats)
		fbytes = []byte(src)
		src = "stdin" + config.Flags.InExt
	}

	fp := src
	old := filepath.Ext(fp)
	if normed, found := config.Formats[strings.Trim(old, ".")]; found {
		fp = fp[0:len(fp)-len(old)] + "." + normed
	}

	baseStyles := config.GBaseStyles
	for sec, styles := range config.SBaseStyles {
		if pat, found := config.SecToPat[sec]; found && pat.Match(fp) {
			baseStyles = styles
			break
		}
	}

	checks := make(map[string]bool)
	for sec, smap := range config.SChecks {
		if pat, found := config.SecToPat[sec]; found && pat.Match(fp) {
			checks = smap
			break
		}
	}

	lang := "en"
	for syntax, code := range config.FormatToLang {
		sec, err := glob.Compile(syntax)
		if err != nil {
			return &File{}, err
		} else if sec.Match(fp) {
			lang = code
			break
		}
	}

	transform := ""
	for sec, p := range config.Stylesheets {
		pat, err := glob.Compile(sec)
		if err != nil {
			return &File{}, NewE100(src, err)
		} else if pat.Match(src) {
			transform = p
			break
		}
	}

	content := Sanitize(string(fbytes))
	lines := strings.SplitAfter(content, "\n")
	file := File{
		NormedExt: ext, Format: format, RealExt: filepath.Ext(src),
		BaseStyles: baseStyles, Checks: checks, Lines: lines, Content: content,
		Comments: make(map[string]bool), history: make(map[string]int),
		simple: config.Flags.Simple, Transform: transform,
		limits: make(map[string]int), Path: src,
		NLP: nlp.NLPInfo{Endpoint: config.NLPEndpoint, Lang: lang},
	}

	return &file, nil
}

// SortedAlerts returns all of f's alerts sorted by line and column.
func (f *File) SortedAlerts() []Alert {
	sort.Sort(ByPosition(f.Alerts))
	return f.Alerts
}

// FindLoc calculates the line and span of an Alert.
func (f *File) FindLoc(ctx, s string, pad, count int, a Alert) (int, []int) {
	var length int
	var lines []string

	pos, substring := initialPosition(ctx, s, a)
	if pos < 0 {
		// Shouldn't happen ...
		return pos, []int{0, 0}
	}

	loc := a.Span
	if f.Format == "markup" && !f.simple {
		lines = f.Lines
	} else {
		lines = strings.SplitAfter(ctx, "\n")
	}

	counter := 0
	for idx, l := range lines {
		length = utf8.RuneCountInString(l)
		if (counter + length) >= pos {
			loc[0] = (pos - counter) + pad
			loc[1] = loc[0] + utf8.RuneCountInString(substring) - 1
			extent := length + pad
			if loc[1] > extent {
				loc[1] = extent
			}
			return count - (len(lines) - (idx + 1)), loc
		}
		counter += length
	}

	return count, loc
}

// FormatAlert ensures that all required fields have data.
func FormatAlert(a *Alert, limit int, level, name string) {
	if a.Severity == "" {
		a.Severity = level
	}
	if a.Check == "" {
		a.Check = name
	}
	a.Limit = limit
	a.Message = WhitespaceToSpace(a.Message)
}

func (f *File) assignLoc(ctx string, blk nlp.Block, pad int, a Alert) (int, []int) {
	loc := a.Span
	for idx, l := range strings.SplitAfter(ctx, "\n") {
		if idx == blk.Line {
			length := utf8.RuneCountInString(l)
			pos, substring := initialPosition(l, blk.Text, a)

			loc[0] = pos + pad
			loc[1] = pos + utf8.RuneCountInString(substring) - 1

			extent := length + pad
			if loc[1] > extent {
				loc[1] = extent
			}

			return blk.Line + 1, loc
		}
	}
	return blk.Line + 1, a.Span
}

// AddAlert calculates the in-text location of an Alert and adds it to a File.
func (f *File) AddAlert(a Alert, blk nlp.Block, lines, pad int, lookup bool) {
	ctx := blk.Context
	if old, ok := f.ChkToCtx[a.Check]; ok {
		ctx = old
	}

	if !lookup {
		a.Line, a.Span = f.assignLoc(ctx, blk, pad, a)
	}
	if (!lookup && a.Span[0] < 0) || lookup {
		a.Line, a.Span = f.FindLoc(ctx, blk.Text, pad, lines, a)
	}

	if a.Span[0] > 0 {
		f.ChkToCtx[a.Check], _ = Substitute(ctx, a.Match, '#')
		if !a.Hide {
			// Ensure that we're not double-reporting an Alert:
			entry := strings.Join([]string{
				strconv.Itoa(a.Line),
				strconv.Itoa(a.Span[0]),
				a.Check}, "-")

			if _, found := f.history[entry]; !found {
				// Check rule-assigned limits for reporting:
				count, found := f.limits[a.Check]
				if (!found || a.Limit == 0) || count < a.Limit {
					f.Alerts = append(f.Alerts, a)

					f.history[entry] = 1
					if a.Limit > 0 {
						f.limits[a.Check]++
					}
				}
			}
		}
	}
}

var commentControlRE = regexp.MustCompile(`^vale (.+\..+) = (YES|NO)$`)

// UpdateComments sets a new status based on comment.
func (f *File) UpdateComments(comment string) {
	if comment == "vale off" {
		f.Comments["off"] = true
	} else if comment == "vale on" {
		f.Comments["off"] = false
	} else if commentControlRE.MatchString(comment) {
		check := commentControlRE.FindStringSubmatch(comment)
		if len(check) == 3 {
			f.Comments[check[1]] = check[2] == "NO"
		}
	}
}

// QueryComments checks if there has been an in-text comment for this check.
func (f *File) QueryComments(check string) bool {
	if !f.Comments["off"] {
		if status, ok := f.Comments[check]; ok {
			return status
		}
	}
	return f.Comments["off"]
}

// ResetComments resets the state of all checks back to active.
func (f *File) ResetComments() {
	for check := range f.Comments {
		if check != "off" {
			f.Comments[check] = false
		}
	}
}
