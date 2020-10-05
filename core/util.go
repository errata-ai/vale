package core

import (
	"bytes"
	"crypto/md5"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"
	"unicode"
	"unicode/utf8"

	"github.com/errata-ai/vale/config"
	"github.com/jdkato/prose/tag"
	"github.com/jdkato/prose/tokenize"
	"github.com/jdkato/regexp"
	"github.com/spf13/afero"
)

// ExeDir is our starting location.
var ExeDir string
var code = regexp.MustCompile("`?`[^`@\n]+``?")

// This is used to store patterns as we compute them in `initialPosition`.
var cache = sync.Map{}

// Hash computes the MD5 hash of the given string.
func Hash(text string) string {
	hasher := md5.New()
	hasher.Write([]byte(text))
	return hex.EncodeToString(hasher.Sum(nil))
}

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

// IsPhrase returns `true` is s is a phrase-like token.
//
// This is used to differentiate regex tokens from non-regex.
func IsPhrase(s string) bool {
	for _, r := range s {
		if !(unicode.IsLetter(r) && r != ' ') {
			return false
		}
	}
	return true
}

// TextToWords convert raw text into a slice of words.
func TextToWords(text string, nlp bool) []string {
	// TODO: Replace with iterTokenizer?
	tok := tokenize.NewTreebankWordTokenizer()

	words := []string{}
	for _, s := range SentenceTokenizer.Tokenize(text) {
		if nlp {
			words = append(words, tok.Tokenize(s)...)
		} else {
			words = append(words, strings.Fields(s)...)
		}
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

// TextToTokens converts a string to a slice of tokens.
func TextToTokens(text string, needsTagging bool) []tag.Token {
	if needsTagging {
		return Tag(TextToWords(text, true))
	}
	tokens := []tag.Token{}
	for _, word := range TextToWords(text, true) {
		tokens = append(tokens, tag.Token{Text: word})
	}
	return tokens
}

// CheckPOS determines if a match (as found by an extension point) also matches
// the expected part-of-speech in text.
func CheckPOS(loc []int, expected, text string) bool {
	var word string

	pos := 1
	observed := []string{}
	for _, tok := range Tag(TextToWords(text, false)) {
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

// CondSprintf is sprintf, ignores extra arguments.
func CondSprintf(format string, v ...interface{}) string {
	v = append(v, "")
	format += fmt.Sprint("%[", len(v), "]s")
	return fmt.Sprintf(format, v...)
}

// FormatMessage inserts `subs` into `msg`.
func FormatMessage(msg string, subs ...string) string {
	return CondSprintf(msg, StringsToInterface(subs)...)
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

func guessLocation(ctx, sub, match string) (int, string) {
	target := ""
	for _, s := range SentenceTokenizer.Tokenize(sub) {
		if s == match || strings.Index(s, match) > 0 {
			target = s
		}
	}

	if target == "" {
		return -1, sub
	}

	tokens := WordTokenizer.Tokenize(target)
	for _, text := range strings.Split(ctx, "\n") {
		if allStringsInString(tokens, text) {
			return strings.Index(ctx, text) + 1, text
		}
	}

	return -1, sub
}

// initialPosition calculates the position of a match (given by the location in
// the reference document, `loc`) in the source document (`ctx`).
func initialPosition(ctx, txt string, a Alert) (int, string) {
	var idx int
	var pat *regexp.Regexp

	if a.Match == "" {
		// We have nothing to look for -- assume the rule applies to the entire
		// document (e.g., readability).
		return 1, ""
	}

	sub := strings.ToValidUTF8(a.Match, "")
	if p, ok := cache.Load(sub); ok {
		pat = p.(*regexp.Regexp)
	} else {
		pat = regexp.MustCompile(`(?:^|\b|_)` + regexp.QuoteMeta(sub) + `(?:_|\b|$)`)
		cache.Store(sub, pat)
	}

	fsi := pat.FindStringIndex(ctx)
	if fsi == nil {
		idx = strings.Index(ctx, sub)
		if idx < 0 {
			// This should only happen if we're in a scope that contains inline
			// markup (e.g., a sentence with code spans).
			return guessLocation(ctx, txt, sub)
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

// IntInSlice determines if `slice` contains the int `a`.
func IntInSlice(a int, slice []int) bool {
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

func allStringsInString(subs []string, s string) bool {
	for _, sub := range subs {
		if strings.Index(s, sub) < 0 {
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

// LooksLikeStdin determines if s appears to be a string.
func LooksLikeStdin(s string) bool {
	return !(FileExists(s) || IsDir(s)) && s != ""
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

// FindAsset tries to locate a Vale-related resource by looking in the
// user-defined StylesPath.
func FindAsset(cfg *config.Config, path string) string {
	if path == "" {
		return path
	}

	inPath := filepath.Join(cfg.StylesPath, path)
	if FileExists(inPath) {
		return inPath
	}

	return DeterminePath(cfg.Path, path)
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

// CopyFile from a source file system to destination file system.
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
