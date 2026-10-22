package system

import (
	"path/filepath"
	"runtime"
	"testing"
)

func TestDeterminePath(t *testing.T) {
	// These cases use Windows-style paths (drive letters, backslash
	// separators), and DeterminePath joins with the OS-native separator. They
	// only resolve correctly on Windows -- elsewhere `\` isn't a separator, so
	// skip rather than fail.
	if runtime.GOOS != "windows" {
		t.Skip("Windows-only path semantics")
	}

	tests := []struct {
		configPath string
		keyPath    string
		expected   string
	}{
		{
			configPath: "C:\\Source\\project\\.vale.ini",
			keyPath:    "transform.xsl",
			expected:   "C:\\Source\\project\\transform.xsl",
		},
		{
			configPath: "C:\\Source\\project\\.vale.ini",
			keyPath:    "styles/transform.xsl",
			expected:   "C:\\Source\\project\\styles\\transform.xsl",
		},
		{
			configPath: "C:\\Source\\project\\.vale.ini",
			keyPath:    "C:\\Other\\transform.xsl",
			expected:   "C:\\Other\\transform.xsl",
		},
	}

	for _, tt := range tests {
		actual := DeterminePath(tt.configPath, tt.keyPath)
		// Clean the paths to ensure separators match for comparison
		actual = filepath.Clean(actual)
		expected := filepath.Clean(tt.expected)
		if actual != expected {
			t.Errorf("DeterminePath(%q, %q) = %q; want %q", tt.configPath, tt.keyPath, actual, expected)
		}
	}
}

func TestRelInside(t *testing.T) {
	base := t.TempDir()

	cases := []struct {
		path   string
		want   string
		inside bool
	}{
		{filepath.Join(base, "docs", "a.md"), filepath.Join("docs", "a.md"), true},
		{base, ".", true},
		{filepath.Join(base, "..foo", "a.md"), filepath.Join("..foo", "a.md"), true},
		{filepath.Dir(base), filepath.Dir(base), false},
		{filepath.Join(filepath.Dir(base), "other.md"), filepath.Join(filepath.Dir(base), "other.md"), false},
	}
	for _, c := range cases {
		got, inside := RelInside(base, c.path)
		if got != c.want || inside != c.inside {
			t.Errorf("RelInside(%q) = %q, %v; want %q, %v", c.path, got, inside, c.want, c.inside)
		}
	}
}
