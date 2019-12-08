// Copyright 2016 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package dfa

import (
	"sort"
	"unicode"
	"github.com/jdkato/regexp/internal/input"
	"github.com/jdkato/regexp/syntax"
)

type rangeMap struct {
	bytemap []int
	divides []rune
}

func (rm *rangeMap) lookup(r rune) int {
	// Use the trivial byte map for now...
	// See ComputeByteMap
	if r == input.EndOfText {
		return len(rm.divides)
	}
	if r == input.StartOfText {
		return len(rm.divides) + 1
	}
	if r > 255 {
		// binary search for the range
		lo, hi := 0, len(rm.divides)
		for {
			// search rm.divides
			center := (lo + hi) / 2
			if center == lo {
				return lo
			}
			divcenter := rm.divides[center]
			if r >= divcenter {
				lo = center
			} else {
				hi = center
			}
		}
	}
	// Faster lookup for runes < 256.
	return rm.bytemap[int(r)]
}

// count returns the number of ranges. 0 <= rm.count() < rm.lookup(r) for all runes r.
func (rm *rangeMap) count() int {
	return len(rm.divides) + 2
}

func (rm *rangeMap) init(prog *syntax.Prog) {
	rangemark := make(map[rune]bool)
	addRune := func(r rune) {
		rangemark[r] = true
		rangemark[r+1] = true
	}
	addRuneRange := func(rl, rh rune) {
		rangemark[rl] = true
		rangemark[rh+1] = true
	}
	addRuneFolds := func(r rune) {
		for r1 := unicode.SimpleFold(r) ;r1 != r; r1 = unicode.SimpleFold(r1) {
			addRune(r1)
		}
	}
	for _, inst := range prog.Inst {
		switch inst.Op {
		case syntax.InstRune:
			if len(inst.Rune) == 1 {
				// special case of single rune
				r := inst.Rune[0]
				addRune(r)
				if syntax.Flags(inst.Arg)&syntax.FoldCase != 0 {
					addRuneFolds(r)
				}
				break
			}
			// otherwise inst.Rune is a series of ranges
			for i := 0; i < len(inst.Rune); i += 2 {
				addRuneRange(inst.Rune[i], inst.Rune[i+1])
				if syntax.Flags(inst.Arg)&syntax.FoldCase != 0 {
					for r0 := inst.Rune[i]; r0 <= inst.Rune[i+1]; r0++ {
						// Range mapping doesn't commute, so we have to
						// add folds individually.
						addRuneFolds(r0)
					}
				}
			}
		case syntax.InstRune1:
			r := inst.Rune[0]
			addRune(r)
			if syntax.Flags(inst.Arg)&syntax.FoldCase != 0 {
				addRuneFolds(r)
			}
		case syntax.InstRuneAnyNotNL:
			addRune('\n')
		case syntax.InstEmptyWidth:
			switch syntax.EmptyOp(inst.Arg) {
			case syntax.EmptyBeginLine, syntax.EmptyEndLine:
				addRune('\n')
			case syntax.EmptyWordBoundary, syntax.EmptyNoWordBoundary:
				addRuneRange('A', 'Z')
				addRuneRange('a', 'Z')
				addRuneRange('0', '9')
				addRune('_')
			}
		}
	}

	divides := make([]rune, 0, len(rangemark))
	divides = append(divides, -1)
	for r := range rangemark {
		divides = append(divides, r)
	}
	runeSlice(divides).Sort()
	rm.divides = divides
	rm.bytemap = make([]int, 256)
	k := 0
	for i := range rm.bytemap {
		if rangemark[rune(i)] {
			k++
		}
		rm.bytemap[i] = k
	}
}

// runeSlice exists to permit sorting the case-folded rune sets.
type runeSlice []rune

func (p runeSlice) Len() int           { return len(p) }
func (p runeSlice) Less(i, j int) bool { return p[i] < p[j] }
func (p runeSlice) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }

// Sort is a convenience method.
func (p runeSlice) Sort() {
	sort.Sort(p)
}
