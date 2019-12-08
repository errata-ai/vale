// Copyright 2016 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package dfa

import (
	"sync"
	"errors"
	"math"
	"github.com/jdkato/regexp/internal/input"
	"github.com/jdkato/regexp/syntax"
)

type Searcher struct {
	mu sync.Mutex
	re               *syntax.Regexp
	prog               *syntax.Prog
	prefixer input.Prefixer
	fdfa, ldfa, revdfa *DFA
}

func (s *Searcher) Init(prog *syntax.Prog, expr *syntax.Regexp, p input.Prefixer) {
	s.prog = prog
	s.re = expr
	s.prefixer = p
}

var errNotDFA = errors.New("can't use dfa")

func (s *Searcher) Search(i input.Input, pos int, longest bool, matchcap *[]int, ncap int) (bool, error) {
	const budget = (2 << 20)/3
	rinput, ok := i.(input.Rinput)
	if !ok {
		return false, errNotDFA
	}
	var dfa *DFA
	if longest {
		s.mu.Lock()
		if s.ldfa == nil {
			s.ldfa = newDFA(s.prog, longestMatch, budget)
			s.ldfa.prefixer = s.prefixer
		}
		dfa = s.ldfa
		s.mu.Unlock()
	} else {
		s.mu.Lock()
		if s.fdfa == nil {
			s.fdfa = newDFA(s.prog, firstMatch, budget)
			s.fdfa.prefixer = s.prefixer
		}
		dfa = s.fdfa
		s.mu.Unlock()
	}
	var revdfa *DFA
	if s.revdfa == nil {
		s.mu.Lock()
		revprog, err := syntax.CompileReversed(s.re)
		if err != nil {
			panic("CompileReversed failed")
		}
		s.revdfa = newDFA(revprog, longestMatch, budget)
		s.mu.Unlock()
	}
	s.mu.Lock()
	revdfa = s.revdfa
	s.mu.Unlock()

	var matched bool
	*matchcap = (*matchcap)[:ncap]
	p, ep, matched, err := search(dfa, revdfa, rinput, pos)
	if err != nil {
		return false, errNotDFA
	}
	if ncap > 0 {
		(*matchcap)[0], (*matchcap)[1] = p, ep
	}
	return matched, nil
}

type searchParams struct {
	input            input.Rinput
	startpos          int
	anchored          bool
	wantEarliestMatch bool
	runForward        bool
	start             *State
	firstbyte         int64 // int64 to be compatible with atomic ops
	failed            bool  // "out" parameter: whether search gave up
	ep                int   // "out" parameter: end pointer for match

	matches []int
}

func isanchored(prog *syntax.Prog) bool {
	return prog.StartCond() & syntax.EmptyBeginText != 0
}

func search(d, reversed *DFA, i input.Rinput, startpos int) (start int, end int, matched bool, err error) {
	params := searchParams{}
	params.startpos = startpos
	params.wantEarliestMatch = false
	params.input = i
	params.anchored = isanchored(d.prog)
	params.runForward = true
	params.ep = int(math.MaxInt32)
	if !d.analyzeSearch(&params) {
		return -1, -1, false, errors.New("analyze search failed on forward DFA")
	}
	b := d.searchLoop(&params)
	if params.failed {
		return -1, -1, false, errFallBack
	}
	if !b {
		return -1, -1, false, nil
	}
	end = params.ep

	params = searchParams{}
	params.startpos = startpos
	params.ep = end
	params.anchored = true
	params.input = i
	params.runForward = false
	if !reversed.analyzeSearch(&params) {
		return -2, -2, false, errors.New("analyze search failed on reverse DFA")
	}
	b = reversed.searchLoop(&params)
	if DebugDFA {
		DebugPrintf("\nkind %d\n%v\n", d.kind, d.prog)
	}
	if params.failed {
		return -1, -1, false, errFallBack
	}
	return params.ep, end, b, nil
}
