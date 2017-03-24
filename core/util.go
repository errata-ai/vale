package core

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"

	jww "github.com/spf13/jwalterweatherman"
)

// ExeDir is our starting location.
var ExeDir string

// Which checks for the existence of any command in `cmds`.
func Which(cmds []string) string {
	for _, cmd := range cmds {
		path, err := exec.LookPath(cmd)
		if err == nil {
			return path
		}
	}
	return ""
}

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

// Substitute replaces the substring `sub` with a string of asterisks.
func Substitute(src string, sub string) (string, bool) {
	idx := strings.Index(src, sub)
	if idx < 0 {
		return src, false
	}
	count := len(sub)
	return src[:idx] + strings.Repeat("*", count) + src[idx+count:], true
}

// StringsToInterface converts a slice of strings to an interface.
func StringsToInterface(strings []string) []interface{} {
	intf := make([]interface{}, len(strings))
	for i, v := range strings {
		intf[i] = v
	}
	return intf
}

// DumpConfig returns Vale's configuration in JSON format.
func DumpConfig() string {
	b, _ := json.MarshalIndent(Config, "", "  ")
	return string(b)
}

// initialPosition calculates the position of a match (given by the location in
// the reference document, `loc`) in the source document (`ctx`).
func initialPosition(ctx string, substring string, loc []int) int {
	if strings.Count(ctx, substring) > 1 {
		// If there's more than one, we take the first bounded option.
		// For example, given that we're looking for "very", "every" => nested
		// and " very " => bounded.
		subctx := ctx[loc[0]:]
		pat := fmt.Sprintf(`(?:\b|_)%s(?:\b|_)`, regexp.QuoteMeta(substring))
		sloc := regexp.MustCompile(pat).FindStringIndex(subctx)
		if len(sloc) > 0 {
			pos := sloc[0]
			if strings.HasPrefix(ctx[pos:], "_") {
				pos++ // We don't want to include the underscore boundary.
			}
			return pos + (len(ctx) - len(subctx)) + 1
		}
	}
	// If there's only one option or no bounded option, we take the first
	// occurrence of `substring`.
	return strings.Index(ctx, substring) + 1
}

// FindLoc calculates the line and span of an Alert.
func FindLoc(count int, ctx string, s string, loc []int, pad int) (int, []int) {
	var length int

	substring := strings.Split(s[loc[0]:loc[1]], "\n")[0]
	pos := initialPosition(ctx, substring, loc)

	counter := 0
	lines := strings.SplitAfter(ctx, "\n")
	for idx, l := range lines {
		length = len(l)
		if (counter + length) >= pos {
			loc[0] = (pos - counter) + pad
			loc[1] = loc[0] + len(substring) - 1
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
		"\u2013": "-",
		"\u2014": "-",
	}
	for old, new := range replacements {
		txt = strings.Replace(txt, old, new, -1)
	}
	txt = strings.Replace(txt, "\r\n", "\n", -1)
	txt = strings.Replace(txt, "\r", "\n", -1)
	return txt
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
func CheckError(err error, message string) bool {
	if err != nil {
		jww.ERROR.Println(message)
	}
	return err == nil
}

// CheckAndClose closes `file` and prints any errors to stdout.
// A return value of true => no error.
func CheckAndClose(file *os.File) bool {
	err := file.Close()
	return CheckError(err, file.Name())
}
