package shuffle

import "sort"

// Interface is a type, typically a collection, that satisfies shuffle.Interface can be
// shuffled by the routines in this package.
type Interface interface {
	// Len is the number of elements in the collection.
	Len() int
	// Swap swaps the elements with indexes i and j.
	Swap(i, j int)
}

// Int64Slice attaches the methods of Interface to []int64, sorting in increasing order.
type Int64Slice []int64

func (p Int64Slice) Len() int           { return len(p) }
func (p Int64Slice) Less(i, j int) bool { return p[i] < p[j] }
func (p Int64Slice) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }

// SortInt64s sorts a slice of int64s in increasing order.
func SortInt64s(a []int64) { sort.Sort(Int64Slice(a)) }

// Ints shuffles a slice of ints.
func Ints(a []int) { Shuffle(sort.IntSlice(a)) }

// Int64s shuffles a slice of int64s.
func Int64s(a []int64) { Shuffle(Int64Slice(a)) }

// Float64s shuffles a slice of float64s.
func Float64s(a []float64) { Shuffle(sort.Float64Slice(a)) }

// Strings shuffles a slice of strings.
func Strings(a []string) { Shuffle(sort.StringSlice(a)) }
