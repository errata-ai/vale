// Copyright (C) 2013-2020 Masterminds
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

package cli

import (
	"math/rand"
	"strconv"
	"strings"
	"text/template"
)

// TxtFuncMap returns a 'text/template'.FuncMap
func TxtFuncMap() template.FuncMap {
	return template.FuncMap(GenericFuncMap())
}

// GenericFuncMap returns a copy of the basic function map as a map[string]interface{}.
func GenericFuncMap() map[string]interface{} {
	gfm := make(map[string]interface{}, len(genericMap))
	for k, v := range genericMap {
		gfm[k] = v
	}
	return gfm
}

var genericMap = map[string]interface{}{
	// Strings
	"trunc":  trunc,
	"trim":   strings.TrimSpace,
	"upper":  strings.ToUpper,
	"lower":  strings.ToLower,
	"title":  strings.Title,
	"substr": substring,
	// Switch order so that "foo" | repeat 5
	"repeat": func(count int, str string) string { return strings.Repeat(str, count) },
	// Deprecated: Use trimAll.
	"trimall": func(a, b string) string { return strings.Trim(b, a) },
	// Switch order so that "$foo" | trimall "$"
	"trimAll":    func(a, b string) string { return strings.Trim(b, a) },
	"trimSuffix": func(a, b string) string { return strings.TrimSuffix(b, a) },
	"trimPrefix": func(a, b string) string { return strings.TrimPrefix(b, a) },
	// Switch order so that "foobar" | contains "foo"
	"contains":  func(substr string, str string) bool { return strings.Contains(str, substr) },
	"hasPrefix": func(substr string, str string) bool { return strings.HasPrefix(str, substr) },
	"hasSuffix": func(substr string, str string) bool { return strings.HasSuffix(str, substr) },
	"quote":     quote,
	"squote":    squote,
	"cat":       cat,
	"indent":    indent,
	"nindent":   nindent,
	"replace":   replace,
	"plural":    plural,
	"toString":  strval,

	// Wrap Atoi to stop errors.
	"atoi":      func(a string) int { i, _ := strconv.Atoi(a); return i },
	"int64":     toInt64,
	"int":       toInt,
	"float64":   toFloat64,
	"toDecimal": toDecimal,

	// split "/" foo/bar returns map[int]string{0: foo, 1: bar}
	"split":     split,
	"splitList": func(sep, orig string) []string { return strings.Split(orig, sep) },
	// splitn "/" foo/bar/fuu returns map[int]string{0: foo, 1: bar/fuu}
	"splitn":    splitn,
	"toStrings": strslice,

	// VERY basic arithmetic.
	"add1": func(i interface{}) int64 { return toInt64(i) + 1 },
	"add": func(i ...interface{}) int64 {
		var a int64 = 0
		for _, b := range i {
			a += toInt64(b)
		}
		return a
	},
	"sub": func(a, b interface{}) int64 { return toInt64(a) - toInt64(b) },
	"div": func(a, b interface{}) int64 { return toInt64(a) / toInt64(b) },
	"mod": func(a, b interface{}) int64 { return toInt64(a) % toInt64(b) },
	"mul": func(a interface{}, v ...interface{}) int64 {
		val := toInt64(a)
		for _, b := range v {
			val = val * toInt64(b)
		}
		return val
	},
	"randInt": func(min, max int) int { return rand.Intn(max-min) + min },
	"biggest": max,
	"max":     max,
	"min":     min,
	"maxf":    maxf,
	"minf":    minf,
	"ceil":    ceil,
	"floor":   floor,
	"round":   round,

	// string slices. Note that we reverse the order b/c that's better
	// for template processing.
	"join":      join,
	"sortAlpha": sortAlpha,

	// Data Structures:
	"list": list,

	"append":      push,
	"push":        push,
	"mustAppend":  mustPush,
	"mustPush":    mustPush,
	"prepend":     prepend,
	"mustPrepend": mustPrepend,
	"first":       first,
	"mustFirst":   mustFirst,
	"last":        last,
	"mustLast":    mustLast,
	"uniq":        uniq,
	"mustUniq":    mustUniq,
	"has":         has,
	"mustHas":     mustHas,
	"slice":       slice,
	"mustSlice":   mustSlice,
	"concat":      concat,
}
