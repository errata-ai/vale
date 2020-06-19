package core

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"unicode"
	"unicode/utf8"

	"github.com/icza/gox/fmtx"
	"github.com/jdkato/prose/tag"
	"github.com/jdkato/regexp"
	"github.com/levigross/grequests"
	"github.com/mholt/archiver"
	"github.com/spf13/afero"
	"github.com/xrash/smetrics"
)

// ExeDir is our starting location.
var ExeDir string
var code = regexp.MustCompile("`?`[^`@\n]+``?")

// PrintJSON prints the data type `t` as JSON.
func PrintJSON(t interface{}) error {
	b, err := json.MarshalIndent(t, "", "  ")
	if err != nil {
		fmt.Println("{}")
		return err
	}
	fmt.Println(string(b))
	return nil
}

// Fetch an external (compressed) resource.
//
// For example:
//
// https://www.languagetool.org/download/LanguageTool-4.7.zip
func Fetch(src, dst string, debug bool) error {
	// Fetch the resource from the web:
	resp, err := grequests.Get(src, nil)
	if err != nil {
		return err
	}

	// Create a temp file to represent the archive locally:
	tmpfile, err := ioutil.TempFile("", "temp.*.zip")
	if err != nil {
		return err
	}

	defer os.Remove(tmpfile.Name()) // clean up

	// Write to the  local archive:
	_, err = io.Copy(tmpfile, resp.RawResponse.Body)
	if err != nil {
		return err
	} else if err = tmpfile.Close(); err != nil {
		return err
	}
	return archiver.Unarchive(tmpfile.Name(), dst)
}

// ToSentence converts a slice of terms into sentence.
func ToSentence(words []string, andOrOr string) string {
	l := len(words)
	if l == 1 {
		return words[0]
	} else if l == 2 {
		return words[0] + " or " + words[1]
	}
	wordsForSentence := make([]string, l)
	copy(wordsForSentence, words)
	wordsForSentence[l-1] = andOrOr + " " + wordsForSentence[l-1]
	return strings.Join(wordsForSentence, ", ")
}

// IsLetter returns `true` if s contains all letter characters and false if not.
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

// Tag assigns part-of-speech tags to `words`.
func Tag(words []string) []tag.Token {
	if Tagger == nil {
		Tagger = tag.NewPerceptronTagger()
	}
	return Tagger.Tag(words)
}

// CheckPOS determines if a match (as found by an extension point) also matches
// the expected part-of-speech in text.
func CheckPOS(loc []int, expected, text string) bool {
	var word string

	pos := 1
	observed := []string{}
	for _, tok := range Tag(TextToWords(text)) {
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
	return fmtx.CondSprintf(msg, StringsToInterface(subs)...)
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
	config.StylesPath = filepath.ToSlash(config.StylesPath)
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
func initialPosition(ctx, sub string) (int, string) {
	idx := -1
	sub = strings.ToValidUTF8(sub, "")

	pat := regexp.MustCompile(`(?:^|\b|_)` + regexp.QuoteMeta(sub) + `(?:_|\b|$)`)
	fsi := pat.FindStringIndex(ctx)

	if len(fsi) == 0 {
		idx = strings.Index(ctx, sub)
		if idx < 0 {
			// Fall back to the JaroWinkler distance. This should only happen if
			// we're in a scope that contains inline markup (e.g., a sentence with
			// code spans).
			return JaroWinkler(ctx, sub)
		}
	} else {
		idx = fsi[0]
	}

	if strings.HasPrefix(ctx[idx:], "_") {
		idx++ // We don't want to include the underscore boundary.
	}
	return utf8.RuneCountInString(ctx[:idx]) + 1, sub
}

// sanitizer replaces a set of unicode characters with ASCII equivalents.
var sanitizer = strings.NewReplacer(
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
func FormatFromExt(path string, mapping map[string]string) (string, string) {
	ext := strings.Trim(filepath.Ext(path), ".")
	if format, found := mapping[ext]; found {
		ext = format
	}
	ext = "." + ext
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
func CheckError(err error, debug bool) bool {
	if err != nil && debug {
		fmt.Println(err.Error())
	}
	return err == nil
}

// CheckErrorWithMsg prints any errors to stdout.
func CheckErrorWithMsg(err error, debug bool, message string) bool {
	if err != nil && debug {
		if message != "" {
			fmt.Println(message)
		} else {
			fmt.Println(err.Error())
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
func CheckAndClose(file *os.File, debug bool) bool {
	err := file.Close()
	return CheckError(err, debug)
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
	if !IsDir(configPath) {
		configPath = filepath.Dir(configPath)
	}
	sep := string(filepath.Separator)
	abs, _ := filepath.Abs(keyPath)
	rel := strings.TrimRight(keyPath, sep)
	if abs != rel || !strings.Contains(keyPath, sep) {
		// The path was relative
		return filepath.Join(configPath, keyPath)
	}
	return abs
}

// CopyFile from a source file sysmtem to destination file system.
func CopyFile(srcFs afero.Fs, srcFilePath string, destFs afero.Fs, destFilePath string) error {
	srcFile, err := srcFs.Open(srcFilePath)
	if err != nil {
		return err
	}
	defer srcFile.Close()

	srcInfo, err := srcFile.Stat()
	if err != nil {
		return err
	}

	destFile, err := destFs.Create(destFilePath)
	if err != nil {
		return err
	}
	defer destFile.Close()

	_, err = io.Copy(destFile, srcFile)
	if err != nil {
		return err
	}

	if err != nil {
		err = destFs.Chmod(destFilePath, srcInfo.Mode())
	}

	return nil
}

// CopyDir from a source file system to destination file system.
func CopyDir(srcFs afero.Fs, srcDirPath string, destFs afero.Fs, destDirPath string) error {
	// get properties of source dir
	srcInfo, err := srcFs.Stat(srcDirPath)
	if err != nil {
		return err
	}

	// create dest dir
	if err = destFs.MkdirAll(destDirPath, srcInfo.Mode()); err != nil {
		return err
	}

	directory, err := srcFs.Open(srcDirPath)
	if err != nil {
		return err
	}
	defer directory.Close()

	entries, err := directory.Readdir(-1)
	if err != nil {
		return err
	}

	for _, e := range entries {
		srcFullPath := filepath.Join(srcDirPath, e.Name())
		destFullPath := filepath.Join(destDirPath, e.Name())

		if e.IsDir() {
			// create sub-directories - recursively
			if err = CopyDir(srcFs, srcFullPath, destFs, destFullPath); err != nil {
				return err
			}
		} else {
			// perform copy
			if err = CopyFile(srcFs, srcFullPath, destFs, destFullPath); err != nil {
				return err
			}
		}
	}

	return nil
}
