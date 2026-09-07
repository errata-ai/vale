package core

import (
	"strings"
	"testing"
)

func parseNotebook(t *testing.T, src string) []Cell {
	t.Helper()
	cells, err := ParseNotebook(&File{Path: "demo.ipynb", RealExt: ".ipynb", Content: src})
	if err != nil {
		t.Fatal(err)
	}
	return cells
}

// A cell's source may be a list or a string; a code cell takes the kernel's
// language; raw cells are kept, to be skipped by the caller.
func TestParseNotebook(t *testing.T) {
	cells := parseNotebook(t, `{
 "cells": [
  {"cell_type": "markdown", "metadata": {}, "source": ["# Title\n", "\n", "Split\n", "across lines."]},
  {"cell_type": "code", "metadata": {}, "outputs": [], "source": ["# a comment\n", "print(1)"]},
  {"cell_type": "raw", "metadata": {}, "source": "raw text"},
  {"cell_type": "markdown", "metadata": {}, "source": "One string."}
 ],
 "metadata": {"kernelspec": {"display_name": "Python 3", "language": "python", "name": "python3"}},
 "nbformat": 4, "nbformat_minor": 5
}`)

	want := []string{
		`markdown@3:57 "# Title\n\nSplit\nacross lines."`,
		`code.py@4:68 "# a comment\nprint(1)"`,
		`raw@5:51 "raw text"`,
		`markdown@6:56 "One string."`,
	}
	if len(cells) != len(want) {
		t.Fatalf("got %d cells, want %d", len(cells), len(want))
	}
	for i, c := range cells {
		if c.String() != want[i] {
			t.Errorf("cell %d = %s, want %s", i, c, want[i])
		}
	}
	if n := len(cells[0].Value.Parts); n != 4 {
		t.Errorf("first cell has %d parts, want 4", n)
	}
}

// The kernel's language comes from the kernelspec, then language_info; a
// cell may name its own; and a language with no grammar leaves it empty.
func TestParseNotebookLanguages(t *testing.T) {
	tests := []struct {
		name, meta, cell, want string
	}{
		{"kernelspec", `"kernelspec": {"language": "R"}`, "", ".r"},
		{"language_info", `"language_info": {"name": "julia"}`, "", ".jl"},
		{"kernelspec wins", `"kernelspec": {"language": "python"}, "language_info": {"name": "R"}`, "", ".py"},
		{"cell override", `"kernelspec": {"language": "python"}`, `"metadata": {"vscode": {"languageId": "javascript"}}`, ".js"},
		{"no grammar", `"kernelspec": {"language": "bash"}`, "", ""},
		{"no metadata", ``, "", ""},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			cellMeta := `"metadata": {}`
			if tt.cell != "" {
				cellMeta = tt.cell
			}
			cells := parseNotebook(t, `{"cells": [{"cell_type": "code", `+cellMeta+`, "source": ["x = 1"]}], "metadata": {`+tt.meta+`}, "nbformat": 4}`)
			if len(cells) != 1 || cells[0].Lang != tt.want {
				t.Errorf("got %v, want lang %q", cells, tt.want)
			}
		})
	}
}

// A `%%markdown` cell is prose. Its magic line is blanked, not removed, so
// the rest of the cell keeps its place.
func TestParseNotebookMagic(t *testing.T) {
	cells := parseNotebook(t, `{"cells": [
  {"cell_type": "code", "metadata": {}, "source": ["%%markdown\n", "# A heading\n", "Prose."]},
  {"cell_type": "code", "metadata": {}, "source": ["%%bash\n", "# a comment"]}
 ], "metadata": {"kernelspec": {"language": "python"}}, "nbformat": 4}`)

	if len(cells) != 2 {
		t.Fatalf("got %d cells, want 2", len(cells))
	}
	if cells[0].Type != "markdown" || cells[0].Value.Text != "          \n# A heading\nProse." {
		t.Errorf("markdown magic: %s", cells[0])
	}
	if line, col := cells[0].Value.Locate(strings.Index(cells[0].Value.Text, "Prose")); line != 2 || col != 86 {
		t.Errorf("Prose at (%d,%d), want (2,86)", line, col)
	}
	if cells[1].Type != "code" || cells[1].Lang != ".py" {
		t.Errorf("other magic stays code in the kernel's language: %s", cells[1])
	}
}

// nbformat 3: cells live in worksheets, a heading is its own kind with a
// level, code is under `input`, and a cell names its language.
func TestParseNotebookV3(t *testing.T) {
	cells := parseNotebook(t, `{
 "worksheets": [{"cells": [
  {"cell_type": "heading", "level": 2, "source": ["A heading"]},
  {"cell_type": "code", "language": "python", "input": ["# comment\n", "x = 1"], "outputs": []},
  {"cell_type": "markdown", "source": ["Prose."]}
 ]}],
 "metadata": {"name": "old"},
 "nbformat": 3, "nbformat_minor": 0
}`)

	want := []string{
		`markdown@3:52 "## A heading"`,
		`code.py@4:58 "# comment\nx = 1"`,
		`markdown@5:41 "Prose."`,
	}
	if len(cells) != len(want) {
		t.Fatalf("got %d cells, want %d", len(cells), len(want))
	}
	for i, c := range cells {
		if c.String() != want[i] {
			t.Errorf("cell %d = %s, want %s", i, c, want[i])
		}
	}

	// The heading's marks are not in the file: the text after them is.
	if line, col := cells[0].Value.Locate(3); line != 3 || col != 52 {
		t.Errorf("heading text at (%d,%d), want (3,52)", line, col)
	}
	if line, col := cells[0].Value.Locate(0); line != 3 || col != 52 {
		t.Errorf("heading mark at (%d,%d), want (3,52)", line, col)
	}
}

func TestParseNotebookErrors(t *testing.T) {
	for _, src := range []string{`{"cells": [`, `[1, 2]`, `{"nbformat": 4}`} {
		if _, err := ParseNotebook(&File{Content: src}); err == nil {
			t.Errorf("%q: expected an error", src)
		}
	}
}
