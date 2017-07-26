package dfa

import (
	"unicode/utf8"
	"testing"
	"strconv"
	"strings"
	)

func isSingleBytes(s string) bool {
	for _, c := range s {
		if c >= utf8.RuneSelf {
			return false
		}
	}
	return true
}

func parseResult(t *testing.T, file string, lineno int, res string) []int {
	// A single - indicates no match.
	if res == "-" {
		return nil
	}
	// Otherwise, a space-separated list of pairs.
	n := 1
	for j := 0; j < len(res); j++ {
		if res[j] == ' ' {
			n++
		}
	}
	out := make([]int, 2*n)
	i := 0
	n = 0
	for j := 0; j <= len(res); j++ {
		if j == len(res) || res[j] == ' ' {
			// Process a single pair.  - means no submatch.
			pair := res[i:j]
			if pair == "-" {
				out[n] = -1
				out[n+1] = -1
			} else {
				k := strings.Index(pair, "-")
				if k < 0 {
					t.Fatalf("%s:%d: invalid pair %s", file, lineno, pair)
				}
				lo, err1 := strconv.Atoi(pair[:k])
				hi, err2 := strconv.Atoi(pair[k+1:])
				if err1 != nil || err2 != nil || lo > hi {
					t.Fatalf("%s:%d: invalid pair %s", file, lineno, pair)
				}
				out[n] = lo
				out[n+1] = hi
			}
			n += 2
			i = j + 1
		}
	}
	return out
}

func same(x, y []int) bool {
	if len(x) != len(y) {
		return false
	}
	for i, xi := range x {
		if xi != y[i] {
			return false
		}
	}
	return true
}
