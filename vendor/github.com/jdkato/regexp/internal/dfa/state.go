// Copyright 2016 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package dfa

// TODO(matloob): rename all the upper-case identifiers to lower-case.

import (
	"bytes"
	"strconv"
	"sync"
)

// just use ints instead of stateinst??
type stateInst int

type State struct {
	mu sync.Mutex

	// Instruction pointers in the state.
	// TODO(matloob): Should these have a different type?
	inst []int

	// Empty string bitfield flags in effect on the way
	// into this state, along with FlagMatch if this is
	// a matching state.
	flag flag

	// Outgoing arrows from State, one per input byte class.
	next []*State
}

func (s *State) isMatch() bool {
	return s.flag&flagMatch != 0
}

type flag uint32

var (
	flagEmptyMask = flag(0xFFF)
	flagMatch     = flag(0x1000)
	flagLastWord  = flag(0x2000)
	flagNeedShift = flag(16)
)

// Special "firstbyte" values for a state.  (Values >= 0 denote actual bytes.)
const (
	fbUnknown int64 = -1 // No analysis has been performed.
	fbMany int64   = -2 // Many bytes will lead out of this state.
	fbNone int64  = -3 // No bytes lead out of this state.
)

const (
	// Indices into start for unanchored searches.
	// Add startAnchored for anchored searches.
	startBeginText       = 0
	startBeginLine       = 2
	startWordBoundary    = 4
	startNonWordBoundary = 6
	maxStart             = 8

	kStartAnchored = 1
)

const mark = -1

// TODO(matloob): in RE2 deadState and fullMatchState are (State*)(1) and (State*)(2)
// respectively. Is it cheaper to compare with those numbers, than these states?
// Do we need to import package unsafe?
var deadState = &State{}
var fullMatchState = &State{}

func isSpecialState(s *State) bool {
	// see above. cc does int comparison because deadState and fullMatchState
	// are special numbers, but that's unsafe.
	// TODO(matloob): convert states back to numbers. (pointers into state array state(-2) and state(-1))
	return s == deadState || s == fullMatchState || s == nil
}

func (s *State) Dump() string {
	switch s {
	case nil:
		return "_"
	case deadState:
		return "X"
	case fullMatchState:
		return "*"
	}
	var buf bytes.Buffer
	sep := ""
	buf.WriteString("(0x<TODO(matloob):state id>)")
	// buf.WriteString(fmt.Sprintf("(%p)", s)
	for _, inst := range s.inst {
		if inst == int(mark) {
			buf.WriteString("|")
			sep = ""
		} else {
			buf.WriteString(sep)
			buf.WriteString(strconv.Itoa(inst))
			sep = ","
		}
	}
	buf.WriteString("flag=0x")
	buf.WriteString(strconv.FormatUint(uint64(s.flag), 16))
	return buf.String()
}

type stateSet struct {
	states []State

	instpool []int
	instpos  int

	nextpool []*State
	nextpos  int
}

func (s *stateSet) init(budget int, runeRanges int, proglen int, nmark int) {
	// estimate State size to avoid using unsafe
	const intsize = 8
	const slicesize = 3*intsize
	const statesize = 2 *slicesize+intsize

	// the cost of one state including the inst and next slices
	onestate := statesize + runeRanges*intsize + (proglen+nmark)*intsize
	numstates := budget/onestate
	// TODO(matloob): actually use budget number
	s.states = make([]State, 0, numstates)

	s.instpool = make([]int, 0, (proglen+nmark)*numstates)
	s.instpos = 0
	s.nextpool = make([]*State, 0, runeRanges*numstates)
	s.nextpos = 0

}

// clear clears the state cache. Must hold the DFA's cache mutex to call clear.
func (s *stateSet) clear() {
	s.states = s.states[:0]
	s.instpool = s.instpool[:0]
	s.nextpool = s.nextpool[:0]
}

func (s *stateSet) find(inst []int, flag flag) *State {
loop:
	for i := range s.states {
		if len(s.states[i].inst) != len(inst) {
			continue
		}
		for j := range inst {
			if s.states[i].inst[j] != inst[j] {
				continue loop
			}
		}
		if s.states[i].flag != flag {
			continue
		}
		return &s.states[i]
	}
	return nil
}

func (s *stateSet) size() int {
	return len(s.states)
}

func (s *stateSet) insert(inst []int, flag flag, nextsize int) *State {
	if len(s.states)+1 > cap(s.states) ||
		s.instpos+len(inst) > cap(s.instpool) ||
		s.nextpos+nextsize > cap(s.nextpool) {
		// state cache is full
		return nil
	}

	// TODO(matloob): can we insert?
	i := len(s.states)
	s.states = s.states[:i+1]
	state := &s.states[i]

	instsize := len(inst)
	state.inst = s.instpool[s.instpos : s.instpos+instsize]
	s.instpos += instsize
	copy(state.inst, inst)

	state.flag = flag

	state.next = s.nextpool[s.nextpos : s.nextpos+nextsize]
	s.nextpos += nextsize
	for i := range state.next {
		state.next[i] = nil
	}

	return state
}

type startInfo struct {
	start     *State
	firstbyte int64
}

type stateSaver struct {
	dfa       *DFA
	inst      []int
	flag      flag
	isSpecial bool
	special   *State // if it's a special state special != nil
}

func (s *stateSaver) Save(dfa *DFA, state *State) {
	s.dfa = dfa
	if isSpecialState(state) {
		s.inst = nil
		s.flag = 0
		s.special = state
		s.isSpecial = true
	}
	s.isSpecial = false
	s.flag = state.flag

	s.inst = s.inst[:0]
	s.inst = append(s.inst, state.inst...)
}

func (s *stateSaver) Restore() *State {
	if s.isSpecial {
		return s.special
	}
	s.dfa.mu.Lock()
	state := s.dfa.cachedState(s.inst, s.flag)
	s.inst = nil
	s.dfa.mu.Unlock()
	return state
}
