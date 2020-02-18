//+build go1.10

package shuffle

import (
	"math/rand"
	"reflect"
)

// Slice shuffles the slice.
func Slice(slice interface{}) {
	rv := reflect.ValueOf(slice)
	swap := reflect.Swapper(slice)
	rand.Shuffle(rv.Len(), swap)
}

// Slice shuffles the slice.
func (s *Shuffler) Slice(slice Interface) {
	rv := reflect.ValueOf(slice)
	swap := reflect.Swapper(slice)
	(*rand.Rand)(s).Shuffle(rv.Len(), swap)
}
