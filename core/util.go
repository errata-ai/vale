package core

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"unicode"
	"unicode/utf8"

	"github.com/jdkato/prose/tag"
	"github.com/jdkato/regexp"
	"github.com/xrash/smetrics"
)

// ExeDir is our starting location.
var ExeDir string

func IsLetter(s string) bool {
	for _, r := range s {
		if !unicode.IsLetter(r) {
			return false
		}
	}
	return true
}

// TextToWords convert raw text into a slice of words.
func TextToWords(text string) []string {
	words := []string{}
	for _, s := range SentenceTokenizer.Tokenize(text) {
		words = append(words, strings.Fields(s)...)
	}
	return words
}

// InRange determines if the range r contains the integer n.
func InRange(n int, r []int) bool {
	return len(r) == 2 && (r[0] <= n && n <= r[1])
}

// SlicesEqual determines if the slices a and b are equal.
func SlicesEqual(a, b []string) bool {
	if len(a) != len(b) {
		return false
	}
	for i, v := range a {
		if v != b[i] {
			return false
		}
	}
	return true
}

// CheckPOS determines if a match (as found by an extension point) also matches
// the expected part-of-speech in text.
func CheckPOS(loc []int, expected, text string) bool {
	var word string

	// Initilize our tagger, if needed.
	if Tagger == nil {
		Tagger = tag.NewPerceptronTagger()
	}

	pos := 1
	observed := []string{}
	for _, tok := range Tagger.Tag(TextToWords(text)) {
		if InRange(pos, loc) {
			if len(tok.Text) > 1 {
				word = strings.ToLower(strings.TrimRight(tok.Text, ",.!?:;"))
			} else {
				word = tok.Text
			}
			observed = append(observed, (word + "/" + tok.Tag))
		}
		pos += len(tok.Text) + 1
	}

	match, _ := regexp.MatchString(expected, strings.Join(observed, " "))
	return !match
}

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
		found = append(found, strings.TrimSpace(subs[i]))
	}
	return fmt.Sprintf(msg, StringsToInterface(found)...)
}

// Substitute replaces the substring `sub` with a string of asterisks.
func Substitute(src, sub string, char rune) (string, bool) {
	idx := strings.Index(src, sub)
	if idx < 0 {
		return src, false
	}
	repl := strings.Map(func(r rune) rune {
		if r != '\n' {
			return char
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
func DumpConfig(config *Config) string {
	b, _ := json.MarshalIndent(config, "", "  ")
	return string(b)
}

// JaroWinkler searches `ctx` line-by-line for a JaroWinkler distance score
// greater than a particular threshold.
func JaroWinkler(ctx, sub string) (int, string) {
	threshold := 0.75
	if strings.Contains(sub, "`*") && len(strings.Fields(sub)) < 7 {
		threshold = 0.65 // lower the threshold for short text with code spans
	}
	for _, line := range strings.Split(ctx, "\n") {
		for _, text := range SentenceTokenizer.Tokenize(line) {
			if smetrics.JaroWinkler(sub, text, 0.7, 4) > threshold {
				return strings.Index(ctx, text) + 1, text
			}
		}
	}
	return -1, sub
}

// initialPosition calculates the position of a match (given by the location in
// the reference document, `loc`) in the source document (`ctx`).
func initialPosition(ctx, sub string, loc []int) (int, string) {
	idx := strings.Index(ctx, sub)
	if idx < 0 {
		// Fall back to the JaroWinkler distance. This should only happen if
		// we're in a scope that contains inline markup (e.g., a sentence with
		// code spans).
		return JaroWinkler(ctx, sub)
	}
	pat := `(?:^|\b|_)` + regexp.QuoteMeta(sub) + `(?:\b|_|$)`
	txt := strings.TrimSpace(ctx[Max(idx-1, 0):Min(idx+len(sub)+1, len(ctx))])
	if match, err := regexp.MatchString(pat, txt); err != nil || !match {
		// If there's more than one, we take the first bounded option.
		// For example, given that we're looking for "very", "every" => nested
		// and " very " => bounded.
		sloc := regexp.MustCompile(pat).FindStringIndex(ctx)
		if len(sloc) > 0 {
			idx = sloc[0]
			if strings.HasPrefix(ctx[idx:], "_") {
				idx++ // We don't want to include the underscore boundary.
			}
		}
	}
	return utf8.RuneCountInString(ctx[:idx]) + 1, sub
}

// sanitizer replaces a set of unicode characters with ASCII equivalents.
var sanitizer = strings.NewReplacer(
	"\u201c", `"`,
	"\u201d", `"`,
	"\u2018", "'",
	"\u2019", "'",
	"&rsquo;", "'",
	"\r\n", "\n",
	"\r", "\n")

// PrepText prepares text for our check functions.
func PrepText(txt string) string {
	return sanitizer.Replace(txt)
}

// Indent adds padding to every line of `text`.
func Indent(text, indent string) string {
	if text[len(text)-1:] == "\n" {
		result := ""
		for _, j := range strings.Split(text[:len(text)-1], "\n") {
			result += indent + j + "\n"
		}
		return result
	}
	result := ""
	for _, j := range strings.Split(strings.TrimRight(text, "\n"), "\n") {
		result += indent + j + "\n"
	}
	return result[:len(result)-1]
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

// ContainsAny determines if `text` contains any string in `slice`.
func ContainsAny(text string, slice []string) bool {
	for _, s := range slice {
		if strings.Contains(text, s) {
			return true
		}
	}
	return false
}

// CheckError prints any errors to stdout. A return value of true => no error.
func CheckError(err error) bool {
	if err != nil {
		_, werr := fmt.Fprintln(os.Stderr, err.Error())
		if werr != nil {
			panic(werr)
		}
	}
	return err == nil
}

// LooksLikeStdin determines if s appears to be a string.
func LooksLikeStdin(s string) bool {
	return !(FileExists(s) || IsDir(s))
}

// CheckAndClose closes `file` and prints any errors to stdout.
// A return value of true => no error.
func CheckAndClose(file *os.File) bool {
	err := file.Close()
	return CheckError(err)
}

// SplitLines splits on CRLF, CR not followed by LF, and LF.
func SplitLines(data []byte, atEOF bool) (adv int, token []byte, err error) {
	if atEOF && len(data) == 0 {
		return 0, nil, nil
	}
	if i := bytes.IndexAny(data, "\r\n"); i >= 0 {
		if data[i] == '\n' {
			return i + 1, data[0:i], nil
		}
		adv = i + 1
		if len(data) > i+1 && data[i+1] == '\n' {
			adv++
		}
		return adv, data[0:i], nil
	}
	if atEOF {
		return len(data), data, nil
	}
	return 0, nil, nil
}

// DeterminePath decides if `keyPath` is relative or absolute.
func DeterminePath(configPath string, keyPath string) string {
	sep := string(filepath.Separator)
	abs, _ := filepath.Abs(keyPath)
	rel := strings.TrimRight(keyPath, sep)
	if abs != rel || !strings.Contains(keyPath, sep) {
		// The path was relative
		return filepath.Join(configPath, keyPath)
	}
	return abs
}
