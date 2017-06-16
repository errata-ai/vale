package shuffle

import (
	"reflect"
	"sort"
	"testing"
)

func TestShuffle(t *testing.T) {
	a := make([]int, 20)
	b := make([]int, len(a))
	for i := 0; i < len(a); i++ {
		a[i] = i
		b[i] = i
	}

	Ints(a)
	if reflect.DeepEqual(a, b) {
		t.Errorf("%v has not been shuffled", a)
	}

	sort.Ints(a)
	if !reflect.DeepEqual(a, b) {
		t.Errorf("got %v\nwant %v", a, b)
	}
}

func TestShuffleInt64Slice(t *testing.T) {
	a := make([]int64, 20)
	b := make([]int64, len(a))
	for i := 0; i < len(a); i++ {
		a[i] = int64(i)
		b[i] = int64(i)
	}

	Int64s(a)
	if reflect.DeepEqual(a, b) {
		t.Errorf("%v has not been shuffled", a)
	}

	SortInt64s(a)
	if !reflect.DeepEqual(a, b) {
		t.Errorf("got %v\nwant %v", a, b)
	}
}
