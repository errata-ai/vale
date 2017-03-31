package core

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	jww "github.com/spf13/jwalterweatherman"
	"matloob.io/regexp"
)

// ExeDir is our starting location.
var ExeDir string

// Stat checks if we have anything waiting in stdin.
func Stat() bool {
	stat, err := os.Stdin.Stat()
	if err != nil || (stat.Mode()&os.ModeCharDevice) != 0 {
		return false
	}
	return true
}

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
	repl := strings.Map(func(r rune) rune {
		if r != '\n' {
			return '*'
		}
		return r
	}, sub)
	return src[:idx] + repl + src[idx+len(sub):], true
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
	idx := strings.Index(ctx, substring)
	pat := `(?:\b|_)` + regexp.QuoteMeta(substring) + `(?:\b|_)`
	query := ctx[Max(idx-1, 0):Min(idx+len(substring), len(ctx))]
	if match, err := regexp.MatchString(pat, query); err != nil || !match {
		// If there's more than one, we take the first bounded option.
		// For example, given that we're looking for "very", "every" => nested
		// and " very " => bounded.
		sloc := regexp.MustCompile(pat).FindStringIndex(ctx)
		if len(sloc) > 0 {
			pos := sloc[0]
			if strings.HasPrefix(ctx[pos:], "_") {
				pos++ // We don't want to include the underscore boundary.
			}
			return pos + 1
		}
	}
	// If the first match is bounded or there's no bounded option, we take the
	// first occurrence of `substring`.
	return idx + 1
}

// FindLoc calculates the line and span of an Alert.
func FindLoc(count int, ctx string, s string, loc []int, pad int) (int, []int) {
	var length int

	substring := s[loc[0]:loc[1]]
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
	return sanitizer.Replace(txt)
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

// Min returns the min of `a` and `b`.
func Min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

// Max returns the max of `a` and `b`.
func Max(a, b int) int {
	if a < b {
		return b
	}
	return a
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
func CheckError(err error) bool {
	if err != nil {
		jww.ERROR.Println(err.Error())
	}
	return err == nil
}

// CheckAndClose closes `file` and prints any errors to stdout.
// A return value of true => no error.
func CheckAndClose(file *os.File) bool {
	err := file.Close()
	return CheckError(err)
}

// sanitizer replaces a set of unicode characters with ASCII equivalents.
var sanitizer = strings.NewReplacer(
	"À", "A",
	"Á", "A",
	"Â", "A",
	"Ã", "A",
	"Ä", "A",
	"Å", "AA",
	"Æ", "AE",
	"Ç", "C",
	"È", "E",
	"É", "E",
	"Ê", "E",
	"Ë", "E",
	"Ì", "I",
	"Í", "I",
	"Î", "I",
	"Ï", "I",
	"Ð", "D",
	"Ł", "L",
	"Ñ", "N",
	"Ò", "O",
	"Ó", "O",
	"Ô", "O",
	"Õ", "O",
	"Ö", "O",
	"Ø", "OE",
	"Ù", "U",
	"Ú", "U",
	"Ü", "U",
	"Û", "U",
	"Ý", "Y",
	"Þ", "Th",
	"ß", "ss",
	"à", "a",
	"á", "a",
	"â", "a",
	"ã", "a",
	"ä", "a",
	"å", "aa",
	"æ", "ae",
	"ç", "c",
	"è", "e",
	"é", "e",
	"ê", "e",
	"ë", "e",
	"ì", "i",
	"í", "i",
	"î", "i",
	"ï", "i",
	"ð", "d",
	"ł", "l",
	"ñ", "n",
	"ń", "n",
	"ò", "o",
	"ó", "o",
	"ô", "o",
	"õ", "o",
	"ō", "o",
	"ö", "o",
	"ø", "oe",
	"ś", "s",
	"ù", "u",
	"ú", "u",
	"û", "u",
	"ū", "u",
	"ü", "u",
	"ý", "y",
	"þ", "th",
	"ÿ", "y",
	"ż", "z",
	"Œ", "OE",
	"œ", "oe",
	"\u201c", `"`,
	"\u201d", `"`,
	"\u2018", "'",
	"\u2019", "'",
	"\u2013", "-",
	"\u2014", "-",
	"\u2026", "...",
	"\r\n", "\n",
	"\r", "\n")
