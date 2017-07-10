//+build go1.7

package shuffle_test

import (
	"fmt"
	"math/rand"
	"testing"

	"github.com/shogo82148/go-shuffle"
)

func ExampleInts() {
	x := []int{1, 2, 3, 4, 5}
	shuffle.Ints(x)
	for _, value := range x {
		fmt.Println(value)
		// Unordered output:
		// 1
		// 2
		// 3
		// 4
		// 5
	}
}

func BenchmarkInts(b *testing.B) {
	for _, n := range []int{1, 10, 100, 1000, 10000} {

		b.Run(fmt.Sprintf("shuffle %d", n), func(b *testing.B) {
			a := make([]int, n)
			for i := 0; i < b.N; i++ {
				shuffle.Ints(a)
			}
		})

		b.Run(fmt.Sprintf("perm %d", n), func(b *testing.B) {
			for i := 0; i < b.N; i++ {
				rand.Perm(n)
			}
		})

		b.Run(fmt.Sprintf("perm and move %d", n), func(b *testing.B) {
			s1 := make([]int, n)
			s2 := make([]int, n)
			for i := 0; i < b.N; i++ {
				for i, j := range rand.Perm(n) {
					s2[i] = s1[j]
				}
			}
		})

	}
}

func BenchmarkFloat64s(b *testing.B) {
	for _, n := range []int{1, 10, 100, 1000, 10000} {

		b.Run(fmt.Sprintf("shuffle %d", n), func(b *testing.B) {
			a := make([]float64, n)
			for i := 0; i < b.N; i++ {
				shuffle.Float64s(a)
			}
		})

		b.Run(fmt.Sprintf("perm and move %d", n), func(b *testing.B) {
			s1 := make([]float64, n)
			s2 := make([]float64, n)
			for i := 0; i < b.N; i++ {
				for i, j := range rand.Perm(n) {
					s2[i] = s1[j]
				}
			}
		})

	}
}
