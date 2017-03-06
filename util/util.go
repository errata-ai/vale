package util

import (
	"encoding/json"
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

// FormatMessage inserts `subs` into `msg`.
func FormatMessage(msg string, subs ...string) string {
	n := strings.Count(msg, "%s")
	max := len(subs)
	found := []string{}
	for i := 0; i < n && i < max; i++ {
		found = append(found, subs[i])
	}
	return fmt.Sprintf(msg, StringsToInterface(found)...)
}

// StringsToInterface converts a slice of strings to an interface.
func StringsToInterface(strings []string) []interface{} {
	intf := make([]interface{}, len(strings))
	for i, v := range strings {
		intf[i] = v
	}
	return intf
}

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

// DumpConfig returns Vale's configuration in JSON format.
func DumpConfig() string {
	b, _ := json.MarshalIndent(Config, "", "  ")
	return string(b)
}

// FindLoc calculates the line and span of an Alert.
func FindLoc(count int, ctx string, s string, ext string, loc []int, pad int) (int, []int) {
	var length int

	substring := s[loc[0]:loc[1]]
	meta := regexp.QuoteMeta(substring)
	diff := loc[0] - utf8.RuneCountInString(s[:loc[0]])
	r := regexp.MustCompile(fmt.Sprintf(`(\b%s|%s)`, meta, meta))
	offset := len(ctx) - len(ctx[loc[0]:])
	pos := r.FindAllStringIndex(ctx[loc[0]:], 1)[0][0] + 1 + offset

	counter := 0
	lines := strings.SplitAfter(ctx, "\n")
	for idx, l := range lines {
		length = utf8.RuneCountInString(l)
		if (counter + length) >= pos {
			loc[0] = (pos - counter) + pad - diff
			loc[1] = loc[0] + utf8.RuneCountInString(substring) - 1
			extent := length + pad
			if loc[1] > extent {
				loc[1] = extent
			}
			return count - (len(lines) - (idx + 1)), loc
		}
		counter += length
	}

	return count, loc
}

// PrepText prepares text for our check functions.
func PrepText(txt string) string {
	replacements := map[string]string{
		"\u201c": `"`,
		"\u201d": `"`,
		"\u2018": "'",
		"\u2019": "'",
	}
	for old, new := range replacements {
		txt = strings.Replace(txt, old, new, -1)
	}
	txt = strings.Replace(txt, "\r\n", "\n", -1)
	txt = strings.Replace(txt, "\r", "\n", -1)
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
