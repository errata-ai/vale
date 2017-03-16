package core

import (
	"bufio"
	"sort"
	"strings"

	"github.com/jdkato/prose/tokenize"
)

// A File represents a linted text file.
type File struct {
	Alerts     []Alert         // all alerts associated with this file
	BaseStyles []string        // base style assigned in .vale
	Checks     map[string]bool // syntax-specific checks assigned in .txtint
	ChkToCtx   map[string]string
	Counts     map[string]int // word counts
	Format     string         // 'code', 'markup' or 'prose'
	NormedExt  string         // the normalized extension (see util/format.go)
	Path       string         // the full path
	RealExt    string         // actual file extension
	Scanner    *bufio.Scanner // used by lintXXX functions
	Sequences  []string       // tracks various info (e.g., defined abbreviations)
}

// An Alert represents a potential error in prose.
type Alert struct {
	Check       string // the name of the check
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
type ByName []File

func (a ByName) Len() int      { return len(a) }
func (a ByName) Swap(i, j int) { a[i], a[j] = a[j], a[i] }
func (a ByName) Less(i, j int) bool {
	ai, aj := a[i], a[j]
	return ai.Path < aj.Path
}

// SortedAlerts returns all of f's alerts sorted by line and column.
func (f *File) SortedAlerts() []Alert {
	sort.Sort(ByPosition(f.Alerts))
	return f.Alerts
}

// AddAlert calculates the in-text location of an Alert and adds it to a File.
func (f *File) AddAlert(a Alert, ctx string, txt string, lines int, pad int) {
	substring := strings.Split(txt[a.Span[0]:a.Span[1]], "\n")[0]
	if old, ok := f.ChkToCtx[a.Check]; ok {
		ctx = old
	}
	a.Line, a.Span = FindLoc(lines, ctx, txt, a.Span, pad)
	if a.Span[0] > 0 {
		f.Alerts = append(f.Alerts, a)
	}
	f.ChkToCtx[a.Check] = Substitute(ctx, substring, "*")
}

// SentenceTokenizer splits text into sentences.
var SentenceTokenizer = tokenize.NewPunktSentenceTokenizer()
