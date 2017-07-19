package tests

import (
	"fmt"
	"github.com/xrash/smetrics"
	"testing"
)

func TestWagnerFischer(t *testing.T) {
	cases := []levenshteincase{
		{"RASH", "RASH", 1, 1, 2, 0},
		{"POTATO", "POTTATO", 1, 1, 2, 1},
		{"POTTATO", "POTATO", 1, 1, 2, 1},
		{"HOUSE", "MOUSE", 1, 1, 2, 2},
		{"MOUSE", "HOUSE", 2, 2, 4, 4},
		{"abc", "xy", 2, 3, 5, 13},
		{"xy", "abc", 2, 3, 5, 12},
	}

	for _, c := range cases {
		if r := smetrics.WagnerFischer(c.s, c.t, c.icost, c.dcost, c.scost); r != c.r {
			fmt.Println(r, "instead of", c.r)
			t.Fail()
		}
	}
}
