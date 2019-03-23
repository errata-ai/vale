package core

import (
	"testing"

	"github.com/stretchr/testify/assert"
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
		assert.Equal(t, format[0], normExt)
		assert.Equal(t, format[1], f)
	}
}

func TestPrepText(t *testing.T) {
	rawToPrepped := map[string]string{
		"foo\r\nbar":     "foo\nbar",
		"foo\r\n\r\nbar": "foo\n\nbar",
	}
	for raw, prepped := range rawToPrepped {
		assert.Equal(t, prepped, PrepText(raw))
	}
}
