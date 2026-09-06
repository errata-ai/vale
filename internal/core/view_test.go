package core

import (
	"reflect"
	"strings"
	"testing"
)

func TestFileToValuePositions(t *testing.T) {
	tests := []struct {
		name string
		ext  string
		src  string
		want []scalarPos
	}{
		{
			name: "plain scalar",
			ext:  ".yaml",
			src:  "info:\n  title: sample API\n",
			want: []scalarPos{{Value: "sample API", Line: 2, Column: 10}},
		},
		{
			name: "double-quoted with line continuation",
			ext:  ".yaml",
			src:  "info:\n  description: \"Line 1\\\n    \\ Line 2\"\n",
			// yaml.v3 reports the opening quote at col 16; the
			// resolver advances past it to the first content char.
			want: []scalarPos{{Value: "Line 1 Line 2", Line: 2, Column: 17}},
		},
		{
			name: "literal block scalar",
			ext:  ".yaml",
			src:  "info:\n  description: |\n    First line\n    Second line\n",
			want: []scalarPos{{Value: "First line\nSecond line\n", Line: 3, Column: 5}},
		},
		{
			name: "folded block with trailing whitespace is rewritten to literal",
			ext:  ".yaml",
			// Trailing space after "First line." in the source — the
			// nateKlaux scenario from issue #1018. After the folded→
			// literal rewrite the value carries newlines, so the
			// flat-scalar walk reports the first content line/col.
			src:  "info:\n  description: >\n    First line. \n    Second line.\n",
			want: []scalarPos{{Value: "First line. \nSecond line.\n", Line: 3, Column: 5}},
		},
		{
			name: "single-quoted",
			ext:  ".yaml",
			src:  "title: 'sample'\n",
			want: []scalarPos{{Value: "sample", Line: 1, Column: 9}},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			f := &File{Content: tt.src, RealExt: tt.ext}
			_, scalars, err := fileToValue(f)
			if err != nil {
				t.Fatalf("fileToValue: %v", err)
			}
			if !reflect.DeepEqual(scalars, tt.want) {
				t.Errorf("scalars mismatch\n got=%#v\nwant=%#v", scalars, tt.want)
			}
		})
	}
}

func TestFileToValueArrayRoot(t *testing.T) {
	// A top-level array must be accepted as a document root, not just an
	// object -- see issue #1017. dasel can navigate either.
	tests := []struct {
		name string
		ext  string
		src  string
		expr string
	}{
		{
			name: "json array of objects",
			ext:  ".json",
			src:  "[\n  {\"title\": \"first\"},\n  {\"title\": \"second\"}\n]\n",
			expr: "all().title",
		},
		{
			name: "yaml sequence of mappings",
			ext:  ".yaml",
			src:  "- title: first\n- title: second\n",
			expr: "all().title",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			f := &File{Content: tt.src, RealExt: tt.ext}
			value, _, err := fileToValue(f)
			if err != nil {
				t.Fatalf("fileToValue: %v", err)
			}
			got, serr := selectStrings(value, tt.expr)
			if serr != nil {
				t.Fatalf("selectStrings: %v", serr)
			}
			want := []string{"first", "second"}
			if !reflect.DeepEqual(got, want) {
				t.Errorf("selectStrings = %v, want %v", got, want)
			}
		})
	}
}

func TestScalarResolverConsumesInOrder(t *testing.T) {
	scalars := []scalarPos{
		{Value: "shared", Line: 1, Column: 5},
		{Value: "unique", Line: 2, Column: 5},
		{Value: "shared", Line: 3, Column: 5},
	}
	r := newScalarResolver(scalars)

	if line, col := r.locate("shared"); line != 1 || col != 5 {
		t.Errorf("first 'shared' = (%d,%d), want (1,5)", line, col)
	}
	if line, col := r.locate("shared"); line != 3 || col != 5 {
		t.Errorf("second 'shared' = (%d,%d), want (3,5)", line, col)
	}
	if line, col := r.locate("unique"); line != 2 || col != 5 {
		t.Errorf("'unique' = (%d,%d), want (2,5)", line, col)
	}
	if line, col := r.locate("missing"); line != 0 || col != 0 {
		t.Errorf("missing = (%d,%d), want (0,0)", line, col)
	}
}

func TestFoldedToLiteralRewritesIndicator(t *testing.T) {
	// `>` indicators on folded scalars should be rewritten to `|` so the
	// parsed value preserves newlines. `|` blocks and `>` characters
	// inside string values must be left alone.
	src := []byte("a: >\n  one\n  two\nb: |\n  literal\nc: \"x > y\"\n")
	out, err := foldedToLiteral(src)
	if err != nil {
		t.Fatalf("foldedToLiteral: %v", err)
	}
	got := string(out)
	want := "a: |\n  one\n  two\nb: |\n  literal\nc: \"x > y\"\n"
	if got != want {
		t.Errorf("rewritten output mismatch\n got=%q\nwant=%q", got, want)
	}
}

func TestFileToValueLineContinuationFromIssue1018(t *testing.T) {
	// Reproduces the original issue #1018 report: a double-quoted scalar
	// using `\<newline>` line continuation. Before this fix, vale could
	// not locate "Line 1 Line 2" in the source and erred with E100.
	f := &File{
		RealExt: ".yaml",
		Content: "openapi: 3.0.1\ninfo:\n  description: \"Line 1\\\n    \\ Line 2\"\n",
	}
	value, scalars, err := fileToValue(f)
	if err != nil {
		t.Fatalf("fileToValue: %v", err)
	}

	got, err := selectStrings(value, "info.description")
	if err != nil {
		t.Fatalf("selectStrings: %v", err)
	}
	if len(got) != 1 || got[0] != "Line 1 Line 2" {
		t.Fatalf("selectStrings = %v, want [\"Line 1 Line 2\"]", got)
	}

	r := newScalarResolver(scalars)
	// Walk past the openapi version scalar first.
	r.locate("3.0.1")
	line, col := r.locate("Line 1 Line 2")
	if line != 3 || col != 17 {
		t.Errorf("description position = (%d,%d), want (3,17)", line, col)
	}
}

// A selector that fails in both dialects reports both causes, without the
// wrapping dasel adds at every level.
func TestSelectStringsReportsBothDialects(t *testing.T) {
	value := map[string]any{"messages": []any{
		map[string]any{"role": "user", "content": "asked"},
		map[string]any{"role": "assistant", "content": "answered"},
	}}

	_, err := selectStrings(value, `messages.filter(role == "assistant").content`)
	if err == nil {
		t.Fatal("expected an error")
	}

	msg := err.Error()
	for _, want := range []string{
		"unexpected type: expected map, got array",
		"as a v2 selector: cannot use property selector on non map/struct types",
	} {
		if !strings.Contains(msg, want) {
			t.Errorf("error %q lacks %q", msg, want)
		}
	}
	if strings.Contains(msg, "ast.") {
		t.Errorf("error %q still carries dasel's wrapping", msg)
	}
}

// A selector in either dialect is accepted.
func TestSelectStringsEitherDialect(t *testing.T) {
	value := map[string]any{"messages": []any{
		map[string]any{"role": "user", "content": "asked"},
		map[string]any{"role": "assistant", "content": "answered"},
	}}

	for _, expr := range []string{
		`messages.all().filter(equal(role,assistant)).content`,
		`messages.filter($this.role == "assistant").map(content)`,
	} {
		got, err := selectStrings(value, expr)
		if err != nil {
			t.Fatalf("%s: %v", expr, err)
		}
		if len(got) != 1 || got[0] != "answered" {
			t.Errorf("%s = %v, want [answered]", expr, got)
		}
	}
}

// A value the template never fills still yields its scope, as one empty
// value at the top of the file, so a rule that requires text can report it.
func TestApplyTemplateUnfilledValue(t *testing.T) {
	view := &View{
		Engine: "textfsm",
		Template: `Value Subject (.+)
Value List Trailer ([A-Z][\w-]+: .+)

Start
  ^${Trailer}
  ^${Subject}
`,
		Scopes: []Scope{{Name: "subject", Expr: "Subject"}, {Name: "trailer", Expr: "Trailer"}},
	}
	if err := view.compileTemplate(); err != nil {
		t.Fatal(err)
	}

	cases := []struct {
		name, content string
		want          []ScopedValue
	}{
		{"missing", "fix: a thing\n", []ScopedValue{{Text: "", Line: 1, Column: 1}}},
		{"present", "fix: a thing\n\nSigned-off-by: J <j@x.y>\n",
			[]ScopedValue{{Text: "Signed-off-by: J <j@x.y>", Line: 3, Column: 1}}},
	}

	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			found, err := view.applyTemplate(&File{Content: c.content})
			if err != nil {
				t.Fatal(err)
			}
			var trailer []ScopedValue
			for _, sv := range found {
				if sv.Scope == "trailer" {
					trailer = sv.Values
				}
			}
			if !reflect.DeepEqual(trailer, c.want) {
				t.Errorf("trailer = %#v, want %#v", trailer, c.want)
			}
		})
	}
}

// A file a section matched is read whatever it is called; JSON is YAML.
func TestFileToValueUnknownExtension(t *testing.T) {
	f := &File{RealExt: ".log", Content: `{"messages":[{"role":"assistant","content":"answered"}]}`}

	value, _, err := fileToValue(f)
	if err != nil {
		t.Fatal(err)
	}
	got, err := selectStrings(value, "messages.all().content")
	if err != nil {
		t.Fatal(err)
	}
	if len(got) != 1 || got[0] != "answered" {
		t.Errorf("got %v, want [answered]", got)
	}
}

// With `join`, a list of strings is one value at the first element's line.
func TestApplyJoinsList(t *testing.T) {
	src := `{
 "cells": [
  {"cell_type": "markdown", "source": [
    "# Title\n",
    "\n",
    "A paragraph split\n",
    "across lines."
  ]},
  {"cell_type": "code", "source": ["print(1)"]},
  {"cell_type": "markdown", "source": "One string cell."}
 ]
}
`
	sep := ""
	view := &View{Engine: "dasel", Scopes: []Scope{{
		Name: "cell", Expr: "cells.all().filter(equal(cell_type,markdown)).source", Type: "md", Join: &sep,
	}}}

	found, err := view.Apply(&File{RealExt: ".ipynb", Content: src})
	if err != nil {
		t.Fatal(err)
	}
	want := []ScopedValue{
		{Text: "# Title\n\nA paragraph split\nacross lines.", Line: 4, Column: 6, Joined: true},
		{Text: "One string cell.", Line: 10, Column: 40},
	}
	if !reflect.DeepEqual(found[0].Values, want) {
		t.Errorf("values = %#v, want %#v", found[0].Values, want)
	}

	// Without `join`, the list is dropped and the string cell stays.
	view.Scopes[0].Join = nil
	found, err = view.Apply(&File{RealExt: ".ipynb", Content: src})
	if err != nil {
		t.Fatal(err)
	}
	if len(found[0].Values) != 1 || found[0].Values[0].Text != "One string cell." {
		t.Errorf("values = %#v, want the string cell alone", found[0].Values)
	}
}
