package prose

import (
	"bytes"
	"encoding/gob"
	"os"
	"path"
	"strconv"
	"strings"
)

// checkError panics if `err` is not `nil`.
func checkError(err error) {
	if err != nil {
		panic(err)
	}
}

// min returns the minimum of `a` and `b`.
func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

// isPunct determines if the string represents a number.
func isNumeric(s string) bool {
	_, err := strconv.ParseFloat(s, 64)
	return err == nil
}

// stringInSlice determines if `slice` contains the string `a`.
func stringInSlice(a string, slice []string) bool {
	for _, b := range slice {
		if a == b {
			return true
		}
	}
	return false
}

func getAsset(folder, name string) *gob.Decoder {
	b, err := Asset(path.Join("model", folder, name))
	checkError(err)
	return gob.NewDecoder(bytes.NewReader(b))
}

func getDiskAsset(path string) *gob.Decoder {
	f, err := os.Open(path)
	checkError(err)
	return gob.NewDecoder(f)
}

func hasAnyPrefix(s string, prefixes []string) bool {
	n := len(s)
	for _, prefix := range prefixes {
		if n > len(prefix) && strings.HasPrefix(s, prefix) {
			return true
		}
	}
	return false
}

func hasAnySuffix(s string, suffixes []string) bool {
	n := len(s)
	for _, suffix := range suffixes {
		if n > len(suffix) && strings.HasSuffix(s, suffix) {
			return true
		}
	}
	return false
}

func hasAnyIndex(s string, suffixes []string) int {
	n := len(s)
	for _, suffix := range suffixes {
		idx := strings.Index(s, suffix)
		if idx >= 0 && n > len(suffix) {
			return idx
		}
	}
	return -1
}

func nSuffix(word string, length int) string {
	return strings.ToLower(word[len(word)-min(len(word), length):])
}

func nPrefix(word string, length int) string {
	return strings.ToLower(word[:min(len(word), length)])
}

func isBasic(word string) string {
	if stringInSlice(word, enWordList) {
		return "True"
	}
	return "False"
}
