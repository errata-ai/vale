package cli

import (
	"fmt"
	"math"
	"os"
	"reflect"
	"sort"
	"strconv"
	"strings"

	"github.com/logrusorgru/aurora/v3"
	"github.com/olekukonko/tablewriter"
	"github.com/spf13/cast"
)

var funcs = TxtFuncMap()

func init() {
	funcs["red"] = func(s string) string {
		return fmt.Sprintf("%s", aurora.Red(s))
	}
	funcs["blue"] = func(s string) string {
		return fmt.Sprintf("%s", aurora.Blue(s))
	}
	funcs["yellow"] = func(s string) string {
		return fmt.Sprintf("%s", aurora.Yellow(s))
	}
	funcs["underline"] = func(s string) string {
		return fmt.Sprintf("%s", aurora.Underline(s))
	}
	funcs["newTable"] = func(wrap bool) *tablewriter.Table {
		table := tablewriter.NewWriter(os.Stdout)
		table.SetCenterSeparator("")
		table.SetColumnSeparator("")
		table.SetRowSeparator("")
		table.SetAutoWrapText(wrap)
		return table
	}
	funcs["addRow"] = func(t *tablewriter.Table, r []string) *tablewriter.Table {
		t.Append(r)
		return t
	}
	funcs["renderTable"] = func(t *tablewriter.Table) *tablewriter.Table {
		t.Render()
		t.ClearRows()
		return t
	}
}

func quote(str ...interface{}) string {
	out := make([]string, 0, len(str))
	for _, s := range str {
		if s != nil {
			out = append(out, fmt.Sprintf("%q", strval(s)))
		}
	}
	return strings.Join(out, " ")
}

func squote(str ...interface{}) string {
	out := make([]string, 0, len(str))
	for _, s := range str {
		if s != nil {
			out = append(out, fmt.Sprintf("'%v'", s))
		}
	}
	return strings.Join(out, " ")
}

func cat(v ...interface{}) string {
	v = removeNilElements(v)
	r := strings.TrimSpace(strings.Repeat("%v ", len(v)))
	return fmt.Sprintf(r, v...)
}

func indent(spaces int, v string) string {
	pad := strings.Repeat(" ", spaces)
	return pad + strings.Replace(v, "\n", "\n"+pad, -1)
}

func nindent(spaces int, v string) string {
	return "\n" + indent(spaces, v)
}

func replace(old, new, src string) string {
	return strings.Replace(src, old, new, -1)
}

func plural(one, many string, count int) string {
	if count == 1 {
		return one
	}
	return many
}

func strslice(v interface{}) []string {
	switch v := v.(type) {
	case []string:
		return v
	case []interface{}:
		b := make([]string, 0, len(v))
		for _, s := range v {
			if s != nil {
				b = append(b, strval(s))
			}
		}
		return b
	default:
		val := reflect.ValueOf(v)
		switch val.Kind() {
		case reflect.Array, reflect.Slice:
			l := val.Len()
			b := make([]string, 0, l)
			for i := 0; i < l; i++ {
				value := val.Index(i).Interface()
				if value != nil {
					b = append(b, strval(value))
				}
			}
			return b
		default:
			if v == nil {
				return []string{}
			}

			return []string{strval(v)}
		}
	}
}

func removeNilElements(v []interface{}) []interface{} {
	newSlice := make([]interface{}, 0, len(v))
	for _, i := range v {
		if i != nil {
			newSlice = append(newSlice, i)
		}
	}
	return newSlice
}

func strval(v interface{}) string {
	switch v := v.(type) {
	case string:
		return v
	case []byte:
		return string(v)
	case error:
		return v.Error()
	case fmt.Stringer:
		return v.String()
	default:
		return fmt.Sprintf("%v", v)
	}
}

func trunc(c int, s string) string {
	if c < 0 && len(s)+c > 0 {
		return s[len(s)+c:]
	}
	if c >= 0 && len(s) > c {
		return s[:c]
	}
	return s
}

func join(sep string, v interface{}) string {
	return strings.Join(strslice(v), sep)
}

func split(sep, orig string) map[string]string {
	parts := strings.Split(orig, sep)
	res := make(map[string]string, len(parts))
	for i, v := range parts {
		res["_"+strconv.Itoa(i)] = v
	}
	return res
}

func splitn(sep string, n int, orig string) map[string]string {
	parts := strings.SplitN(orig, sep, n)
	res := make(map[string]string, len(parts))
	for i, v := range parts {
		res["_"+strconv.Itoa(i)] = v
	}
	return res
}

func substring(start, end int, s string) string {
	if start < 0 {
		return s[:end]
	}
	if end < 0 || end > len(s) {
		return s[start:]
	}
	return s[start:end]
}

// toFloat64 converts 64-bit floats
func toFloat64(v interface{}) float64 {
	return cast.ToFloat64(v)
}

func toInt(v interface{}) int {
	return cast.ToInt(v)
}

// toInt64 converts integer types to 64-bit integers
func toInt64(v interface{}) int64 {
	return cast.ToInt64(v)
}

func max(a interface{}, i ...interface{}) int64 {
	aa := toInt64(a)
	for _, b := range i {
		bb := toInt64(b)
		if bb > aa {
			aa = bb
		}
	}
	return aa
}

func maxf(a interface{}, i ...interface{}) float64 {
	aa := toFloat64(a)
	for _, b := range i {
		bb := toFloat64(b)
		aa = math.Max(aa, bb)
	}
	return aa
}

func min(a interface{}, i ...interface{}) int64 {
	aa := toInt64(a)
	for _, b := range i {
		bb := toInt64(b)
		if bb < aa {
			aa = bb
		}
	}
	return aa
}

func minf(a interface{}, i ...interface{}) float64 {
	aa := toFloat64(a)
	for _, b := range i {
		bb := toFloat64(b)
		aa = math.Min(aa, bb)
	}
	return aa
}

func floor(a interface{}) float64 {
	aa := toFloat64(a)
	return math.Floor(aa)
}

func ceil(a interface{}) float64 {
	aa := toFloat64(a)
	return math.Ceil(aa)
}

func round(a interface{}, p int, rOpt ...float64) float64 {
	roundOn := .5
	if len(rOpt) > 0 {
		roundOn = rOpt[0]
	}
	val := toFloat64(a)
	places := toFloat64(p)

	var round float64
	pow := math.Pow(10, places)
	digit := pow * val
	_, div := math.Modf(digit)
	if div >= roundOn {
		round = math.Ceil(digit)
	} else {
		round = math.Floor(digit)
	}
	return round / pow
}

// converts unix octal to decimal
func toDecimal(v interface{}) int64 {
	result, err := strconv.ParseInt(fmt.Sprint(v), 8, 64)
	if err != nil {
		return 0
	}
	return result
}

func intArrayToString(slice []int, delimeter string) string {
	return strings.Trim(strings.Join(strings.Fields(fmt.Sprint(slice)), delimeter), "[]")
}

func list(v ...interface{}) []interface{} {
	return v
}

func push(list interface{}, v interface{}) []interface{} {
	l, err := mustPush(list, v)
	if err != nil {
		panic(err)
	}

	return l
}

func mustPush(list interface{}, v interface{}) ([]interface{}, error) {
	tp := reflect.TypeOf(list).Kind()
	switch tp {
	case reflect.Slice, reflect.Array:
		l2 := reflect.ValueOf(list)

		l := l2.Len()
		nl := make([]interface{}, l)
		for i := 0; i < l; i++ {
			nl[i] = l2.Index(i).Interface()
		}

		return append(nl, v), nil

	default:
		return nil, fmt.Errorf("Cannot push on type %s", tp)
	}
}

func prepend(list interface{}, v interface{}) []interface{} {
	l, err := mustPrepend(list, v)
	if err != nil {
		panic(err)
	}

	return l
}

func mustPrepend(list interface{}, v interface{}) ([]interface{}, error) {
	//return append([]interface{}{v}, list...)

	tp := reflect.TypeOf(list).Kind()
	switch tp {
	case reflect.Slice, reflect.Array:
		l2 := reflect.ValueOf(list)

		l := l2.Len()
		nl := make([]interface{}, l)
		for i := 0; i < l; i++ {
			nl[i] = l2.Index(i).Interface()
		}

		return append([]interface{}{v}, nl...), nil

	default:
		return nil, fmt.Errorf("Cannot prepend on type %s", tp)
	}
}

func last(list interface{}) interface{} {
	l, err := mustLast(list)
	if err != nil {
		panic(err)
	}

	return l
}

func mustLast(list interface{}) (interface{}, error) {
	tp := reflect.TypeOf(list).Kind()
	switch tp {
	case reflect.Slice, reflect.Array:
		l2 := reflect.ValueOf(list)

		l := l2.Len()
		if l == 0 {
			return nil, nil
		}

		return l2.Index(l - 1).Interface(), nil
	default:
		return nil, fmt.Errorf("Cannot find last on type %s", tp)
	}
}

func first(list interface{}) interface{} {
	l, err := mustFirst(list)
	if err != nil {
		panic(err)
	}

	return l
}

func mustFirst(list interface{}) (interface{}, error) {
	tp := reflect.TypeOf(list).Kind()
	switch tp {
	case reflect.Slice, reflect.Array:
		l2 := reflect.ValueOf(list)

		l := l2.Len()
		if l == 0 {
			return nil, nil
		}

		return l2.Index(0).Interface(), nil
	default:
		return nil, fmt.Errorf("Cannot find first on type %s", tp)
	}
}

func sortAlpha(list interface{}) []string {
	k := reflect.Indirect(reflect.ValueOf(list)).Kind()
	switch k {
	case reflect.Slice, reflect.Array:
		a := strslice(list)
		s := sort.StringSlice(a)
		s.Sort()
		return s
	}
	return []string{strval(list)}
}

func uniq(list interface{}) []interface{} {
	l, err := mustUniq(list)
	if err != nil {
		panic(err)
	}

	return l
}

func mustUniq(list interface{}) ([]interface{}, error) {
	tp := reflect.TypeOf(list).Kind()
	switch tp {
	case reflect.Slice, reflect.Array:
		l2 := reflect.ValueOf(list)

		l := l2.Len()
		dest := []interface{}{}
		var item interface{}
		for i := 0; i < l; i++ {
			item = l2.Index(i).Interface()
			if !inList(dest, item) {
				dest = append(dest, item)
			}
		}

		return dest, nil
	default:
		return nil, fmt.Errorf("Cannot find uniq on type %s", tp)
	}
}

func inList(haystack []interface{}, needle interface{}) bool {
	for _, h := range haystack {
		if reflect.DeepEqual(needle, h) {
			return true
		}
	}
	return false
}

func has(needle interface{}, haystack interface{}) bool {
	l, err := mustHas(needle, haystack)
	if err != nil {
		panic(err)
	}

	return l
}

func mustHas(needle interface{}, haystack interface{}) (bool, error) {
	if haystack == nil {
		return false, nil
	}
	tp := reflect.TypeOf(haystack).Kind()
	switch tp {
	case reflect.Slice, reflect.Array:
		l2 := reflect.ValueOf(haystack)
		var item interface{}
		l := l2.Len()
		for i := 0; i < l; i++ {
			item = l2.Index(i).Interface()
			if reflect.DeepEqual(needle, item) {
				return true, nil
			}
		}

		return false, nil
	default:
		return false, fmt.Errorf("Cannot find has on type %s", tp)
	}
}

// $list := [1, 2, 3, 4, 5]
// slice $list     -> list[0:5] = list[:]
// slice $list 0 3 -> list[0:3] = list[:3]
// slice $list 3 5 -> list[3:5]
// slice $list 3   -> list[3:5] = list[3:]
func slice(list interface{}, indices ...interface{}) interface{} {
	l, err := mustSlice(list, indices...)
	if err != nil {
		panic(err)
	}

	return l
}

func mustSlice(list interface{}, indices ...interface{}) (interface{}, error) {
	tp := reflect.TypeOf(list).Kind()
	switch tp {
	case reflect.Slice, reflect.Array:
		l2 := reflect.ValueOf(list)

		l := l2.Len()
		if l == 0 {
			return nil, nil
		}

		var start, end int
		if len(indices) > 0 {
			start = toInt(indices[0])
		}
		if len(indices) < 2 {
			end = l
		} else {
			end = toInt(indices[1])
		}

		return l2.Slice(start, end).Interface(), nil
	default:
		return nil, fmt.Errorf("list should be type of slice or array but %s", tp)
	}
}

func concat(lists ...interface{}) interface{} {
	var res []interface{}
	for _, list := range lists {
		tp := reflect.TypeOf(list).Kind()
		switch tp {
		case reflect.Slice, reflect.Array:
			l2 := reflect.ValueOf(list)
			for i := 0; i < l2.Len(); i++ {
				res = append(res, l2.Index(i).Interface())
			}
		default:
			panic(fmt.Sprintf("Cannot concat type %s as list", tp))
		}
	}
	return res
}
