package tests

import (
	"fmt"
	"github.com/xrash/smetrics"
	"testing"
)

func TestHamming(t *testing.T) {
	cases := []hammingcase{
		{"a", "a", 0},
		{"a", "b", 1},
		{"AAAA", "AABB", 2},
		{"BAAA", "AAAA", 1},
		{"BAAA", "CCCC", 4},
		{"karolin", "kathrin", 3},
		{"karolin", "kerstin", 3},
		{"1011101", "1001001", 2},
		{"2173896", "2233796", 3},
	}

	for _, c := range cases {
		r, err := smetrics.Hamming(c.a, c.b)
		if err != nil {
			t.Fatalf("got error from hamming err=%s", err)
		}
		if r != c.diff {
			fmt.Println(r, "instead of", c.diff)
			t.Fail()
		}
	}
}

func TestHammingError(t *testing.T) {
	res, err := smetrics.Hamming("a", "bbb")
	if err == nil {
		t.Fatalf("expected error from 'a' and 'bbb' on hamming")
	}
	if res != -1 {
		t.Fatalf("erroring response wasn't -1, but %d", res)
	}
}
