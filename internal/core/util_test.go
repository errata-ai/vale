package core

import (
	"testing"
)

func TestFormatFromExt(t *testing.T) {
	extToFormat := map[string][]string{
		".py":    {".py", "code"},
		".cxx":   {".c", "code"},
		".mdown": {".md", "markup"},
	}
	m := map[string]string{}
	for ext, format := range extToFormat {
		normExt, f := FormatFromExt(ext, m)
		if format[0] != normExt {
			t.Errorf("expected = %v, got = %v", format[0], normExt)
		}
		if format[1] != f {
			t.Errorf("expected = %v, got = %v", format[1], f)
		}
	}
}

func TestPrepText(t *testing.T) {
	rawToPrepped := map[string]string{
		"foo\r\nbar":     "foo\nbar",
		"foo\r\n\r\nbar": "foo\n\nbar",
	}
	for raw, prepped := range rawToPrepped {
		if prepped != Sanitize(raw) {
			t.Errorf("expected = %v, got = %v", prepped, Sanitize(raw))
		}
	}
}
