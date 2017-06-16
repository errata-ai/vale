package core

import (
	"bufio"
	"bytes"
	"io/ioutil"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
	"unicode/utf8"

	"github.com/gobwas/glob"
	"github.com/jdkato/prose/tokenize"
)

// A File represents a linted text file.
type File struct {
	Alerts     []Alert           // all alerts associated with this file
	BaseStyles []string          // base style assigned in .vale
	Checks     map[string]bool   // syntax-specific checks assigned in .vale
	ChkToCtx   map[string]string // maps a temporary context to a particular check
	Comments   map[string]bool   // comment control statements
	Content    string            // the raw file contents
	Counts     map[string]int    // word counts
	Format     string            // 'code', 'markup' or 'prose'
	Lines      []string          // the File's Content split into lines
	NormedExt  string            // the normalized extension (see util/format.go)
	Path       string            // the full path
	RealExt    string            // actual file extension
	Scanner    *bufio.Scanner    // used by lintXXX functions
	Sequences  []string          // tracks various info (e.g., defined abbreviations)
}

// An Alert represents a potential error in prose.
type Alert struct {
	Check       string // the name of the check
	Context     string // the surrounding text
	Description string // why `Message` is meaningful
	Line        int    // the source line
	Link        string // reference material
	Message     string // the output message
	Severity    string // 'suggestion', 'warning', or 'error'
	Span        []int  // the [begin, end] location within a line
}

// A Selector represents a named section of text.
type Selector struct {
	Value string // e.g., text.comment.line.py
}

// Sections splits a Selector into its parts -- e.g., text.comment.line.py ->
// []string{"text", "comment", "line", "py"}.
func (s Selector) Sections() []string { return strings.Split(s.Value, ".") }

// Contains determines if all if sel's sections are in s.
func (s Selector) Contains(sel Selector) bool {
	return AllStringsInSlice(sel.Sections(), s.Sections())
}

// Equal determines if sel == s.
func (s Selector) Equal(sel Selector) bool { return s.Value == sel.Value }

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
func NewFile(src string, config *Config) *File {
	var scanner *bufio.Scanner
	var format, ext string
	var fbytes []byte

	if FileExists(src) {
		fbytes, _ = ioutil.ReadFile(src)
		scanner = bufio.NewScanner(bytes.NewReader(fbytes))
		ext, format = FormatFromExt(src)
	} else {
		scanner = bufio.NewScanner(strings.NewReader(src))
		ext, format = FormatFromExt(config.InExt)
		fbytes = []byte(src)
		src = "stdin" + ext
	}

	baseStyles := config.GBaseStyles
	for sec, styles := range config.SBaseStyles {
		pat, err := glob.Compile(sec)
		if CheckError(err) && pat.Match(src) {
			baseStyles = styles
			break
		}
	}

	checks := make(map[string]bool)
	for sec, smap := range config.SChecks {
		pat, err := glob.Compile(sec)
		if CheckError(err) && pat.Match(src) {
			checks = smap
			break
		}
	}

	scanner.Split(SplitLines)
	content := PrepText(string(fbytes))
	lines := strings.SplitAfter(content, "\n")
	file := File{
		Path: src, NormedExt: ext, Format: format, RealExt: filepath.Ext(src),
		BaseStyles: baseStyles, Checks: checks, Scanner: scanner, Lines: lines,
		Comments: make(map[string]bool), Content: content,
	}

	return &file
}

// SortedAlerts returns all of f's alerts sorted by line and column.
func (f *File) SortedAlerts() []Alert {
	sort.Sort(ByPosition(f.Alerts))
	return f.Alerts
}

// FindLoc calculates the line and span of an Alert.
func (f *File) FindLoc(ctx, s string, pad, count int, loc []int) (int, []int, string) {
	var length int
	var lines []string

	pos, substring := initialPosition(ctx, s[loc[0]:loc[1]], loc)
	if pos < 0 {
		// Shouldn't happen ...
		return pos, []int{0, 0}, ""
	}

	if f.Format == "markup" {
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
			return count - (len(lines) - (idx + 1)), loc, l
		}
		counter += length
	}

	return count, loc, ""
}

// AddAlert calculates the in-text location of an Alert and adds it to a File.
func (f *File) AddAlert(a Alert, ctx string, txt string, lines int, pad int) {
	substring := txt[a.Span[0]:a.Span[1]]
	if old, ok := f.ChkToCtx[a.Check]; ok {
		ctx = old
	}
	a.Line, a.Span, a.Context = f.FindLoc(ctx, txt, pad, lines, a.Span)
	if a.Span[0] > 0 {
		f.ChkToCtx[a.Check], _ = Substitute(ctx, substring, '#')
		f.Alerts = append(f.Alerts, a)
	}
}

var commentControlRE = regexp.MustCompile(`^vale (\w+.\w+) = (YES|NO)$`)

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
	if status, ok := f.Comments[check]; ok {
		return status
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

// SentenceTokenizer splits text into sentences.
var SentenceTokenizer = tokenize.NewPunktSentenceTokenizer()
