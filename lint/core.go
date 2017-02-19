package lint

import (
	"bufio"
	"sort"
	"strings"

	"github.com/jdkato/vale/util"
)

// A Linter lints a File.
type Linter struct{}

// An Alert represents a potential error in prose.
type Alert struct {
	Check    string // the name of the check
	Line     int    // the source line
	Link     string // reference material
	Message  string // the output message
	Severity string // 'suggestion', 'warning', or 'error'
	Span     []int  // the [begin, end] location within a line
}

// A File represents a linted text file.
type File struct {
	Alerts     []Alert         // all alerts associated with this file
	BaseStyles []string        // base style assigned in .vale
	Checks     map[string]bool // syntax-specific checks assigned in .txtint
	Counts     map[string]int  // word counts
	Format     string          // 'code', 'markup' or 'prose'
	NormedExt  string          // the normalized extension (see util/format.go)
	Path       string          // the full path
	RealExt    string          // actual file extension
	Scanner    *bufio.Scanner  // used by lintXXX functions
	Sequences  []string        // tracks various info (e.g., defined abbreviations)
}

// A Selector represents a named section of text.
type Selector struct {
	Value string // e.g., text.comment.line.py
}

// A Block represents a section of text.
type Block struct {
	Context string   // parent content (if any) - e.g., paragraph -> sentence
	Text    string   // text content
	Scope   Selector // section selector
}

// NewBlock makes a new Block with prepared text and a Selector.
func NewBlock(ctx string, txt string, sel string) Block {
	txt = util.PrepText(txt)
	if ctx == "" {
		ctx = txt
	} else {
		ctx = util.PrepText(ctx)
	}
	return Block{Context: ctx, Text: txt, Scope: Selector{Value: sel}}
}

// Sections splits a Selector into its parts -- e.g., text.comment.line.py ->
// []string{"text", "comment", "line", "py"}.
func (s Selector) Sections() []string { return strings.Split(s.Value, ".") }

// Contains determines if all if sel's sections are in s.
func (s Selector) Contains(sel Selector) bool {
	return util.AllStringsInSlice(sel.Sections(), s.Sections())
}

// Equal determines if sel == s.
func (s Selector) Equal(sel Selector) bool { return s.Value == sel.Value }

// Has determines if s has a part equal to scope.
func (s Selector) Has(scope string) bool {
	return util.StringInSlice(scope, s.Sections())
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

// SortedAlerts returns all of f's alerts sorted by line and column.
func (f *File) SortedAlerts() []Alert {
	sort.Sort(ByPosition(f.Alerts))
	return f.Alerts
}
