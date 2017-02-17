package util

import (
	"bytes"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"unicode/utf8"

	"github.com/Sirupsen/logrus"
)

// ExeDir is our starting location.
var ExeDir string

// NewLogger creates and returns an instance of logrus.Logger.
// If the `--debug` command flag was not provided, we set the level to Error.
func NewLogger() *logrus.Logger {
	log := logrus.New()
	if !CLConfig.Debug {
		log.Level = logrus.ErrorLevel
	}
	log.Out = os.Stdout
	return log
}

// FindLoc calculates the line and span of an Alert.
func FindLoc(count int, ctx string, s string, ext string, loc []int, pad int) (int, []int) {
	var pos int

	substring := s[loc[0]:loc[1]]
	meta := regexp.QuoteMeta(substring)
	diff := loc[0] - utf8.RuneCountInString(s[:loc[0]])
	r := regexp.MustCompile(fmt.Sprintf(`(\b%s|%s)`, meta, meta))
	offset := len(ctx) - len(ctx[loc[0]:])
	pos = r.FindAllStringIndex(ctx[loc[0]:], 1)[0][0] + 1 + offset

	counter := 0
	lines := strings.SplitAfter(ctx, "\n")
	for idx, l := range lines {
		if (counter + utf8.RuneCountInString(l)) >= pos {
			loc[0] = (pos - counter) + pad - diff
			loc[1] = loc[0] + utf8.RuneCountInString(substring) - 1
			return count - (len(lines) - (idx + 1)), loc
		}
		counter += utf8.RuneCountInString(l)
	}
	return count, loc
}

// PrepText prepares text for our check functions.
func PrepText(txt string) string {
	replacements := map[string]string{
		"\r\n":   "\n",
		"\u201c": `"`,
		"\u201d": `"`,
		"\u2018": "'",
		"\u2019": "'",
	}
	for old, new := range replacements {
		txt = strings.Replace(txt, old, new, -1)
	}
	return txt
}

// ExtFromSyntax takes a syntax's name (e.g., "Python") and returns its
// extension (if found).
func ExtFromSyntax(name string) string {
	for r, s := range LookupSyntaxName {
		if matched, _ := regexp.MatchString(r, name); matched {
			return s
		}
	}
	return name
}

// FormatFromExt takes a file extension and returns its [normExt, format]
// list, if supported.
func FormatFromExt(path string) (string, string) {
	ext := filepath.Ext(path)
	for r, f := range FormatByExtension {
		m, _ := regexp.MatchString(r, ext)
		if m {
			return f[0], f[1]
		}
	}
	return "unknown", "unknown"
}

// IsDir determines if the path given by `filename` is a directory.
func IsDir(filename string) bool {
	fi, err := os.Stat(filename)
	return err == nil && fi.IsDir()
}

// FileExists determines if the path given by `filename` exists.
func FileExists(filename string) bool {
	_, err := os.Stat(filename)
	return err == nil
}

// StringInSlice determines if `slice` contains the string `a`.
func StringInSlice(a string, slice []string) bool {
	for _, b := range slice {
		if a == b {
			return true
		}
	}
	return false
}

// AllStringsInSlice determines if `slice` contains the `strings`.
func AllStringsInSlice(strings []string, slice []string) bool {
	for _, s := range strings {
		if !StringInSlice(s, slice) {
			return false
		}
	}
	return true
}

// HasAnyPrefix determines if `text` has any prefix contained in `slice`.
func HasAnyPrefix(text string, slice []string) bool {
	for _, s := range slice {
		if strings.HasPrefix(text, s) {
			return true
		}
	}
	return false
}

// CheckError prints any errors to stdout. A return value of true => no error.
func CheckError(err error, context string) bool {
	if err != nil {
		fmt.Printf("%v (%s)\n", err, context)
	}
	return err == nil
}

// CheckAndClose closes `file` and prints any errors to stdout.
// A return value of true => no error.
func CheckAndClose(file *os.File) bool {
	err := file.Close()
	return CheckError(err, file.Name())
}

// ScanLines splits on CRLF, CR not followed by LF, and LF.
// See http://stackoverflow.com/questions/41433422/read-lines-from-a-file-with-variable-line-endings-in-go
func ScanLines(data []byte, atEOF bool) (advance int, token []byte, err error) {
	if atEOF && len(data) == 0 {
		return 0, nil, nil
	}
	if i := bytes.IndexAny(data, "\r\n"); i >= 0 {
		if data[i] == '\n' {
			// We have a line terminated by single newline.
			return i + 1, data[0:i], nil
		}
		advance = i + 1
		if len(data) > i+1 && data[i+1] == '\n' {
			advance++
		}
		return advance, data[0:i], nil
	}
	// If we're at EOF, we have a final, non-terminated line. Return it.
	if atEOF {
		return len(data), data, nil
	}
	// Request more data.
	return 0, nil, nil
}
