package vale

import (
	"io/ioutil"
	"os"

	"github.com/jdkato/vale/core"
)

// Lint accepts a file or directory and returns a slice of linted Files.
func Lint(src string) ([]core.File, error) {
	linter := new(core.Linter)
	return linter.Lint(src, "*")
}

// LintString accepts a string and its associated extension, and returns a
// slice of linted Files.
func LintString(content string, ext string) ([]core.File, error) {
	linter := new(core.Linter)
	bytes := []byte(content)
	tmpfile, err := ioutil.TempFile("", "valetmp"+ext)
	if err != nil {
		return nil, err
	}
	defer os.Remove(tmpfile.Name())

	if _, err := tmpfile.Write(bytes); err != nil {
		return nil, err
	}
	if err := tmpfile.Close(); err != nil {
		return nil, err
	}
	return linter.Lint(tmpfile.Name(), "*")
}
