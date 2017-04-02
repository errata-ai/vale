// Copyright 2016 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package dfa

import (
	"bytes"
	"strconv"
)

type sparseSet struct {
	sparseToDense []int
	dense         []int
}

func makeSparseSet(maxSize int) sparseSet {
	// 	s.maxSize = maxSize  // not necessary, right?
	return sparseSet{
		sparseToDense: make([]int, maxSize),
		dense:         make([]int, maxSize),
	}
}

func (s *sparseSet) resize(newMaxSize int) {
	// TODO(matloob): Use slice length instead of size for 'dense'.
	// Use cap instead of maxSize for both.
	size := len(s.dense)
	if size > newMaxSize {
		size = newMaxSize
	}
	if newMaxSize > len(s.sparseToDense) {
		a := make([]int, newMaxSize)
		if s.sparseToDense != nil {
			copy(a, s.sparseToDense)
		}
		s.sparseToDense = a

		a = make([]int, size, newMaxSize)
		if s.dense != nil {
			copy(a, s.dense)
		}
		s.dense = a
	}
}

func (s *sparseSet) maxSize() int {
	return cap(s.dense)
}

func (s *sparseSet) clear() {
	s.dense = s.dense[:0]
}

func (s *sparseSet) contains(i int) bool {
	if i >= len(s.sparseToDense) {
		return false
	}
	return s.sparseToDense[i] < len(s.dense) && s.dense[s.sparseToDense[i]] == i
}

func (s *sparseSet) insert(i int) {
	if s.contains(i) {
		return
	}
	s.insertNew(i)
}

func (s *sparseSet) insertNew(i int) {
	if i >= len(s.sparseToDense) {
		return
	}
	// There's a CHECK here that size < maxSize...

	s.sparseToDense[i] = len(s.dense)
	s.dense = s.dense[:len(s.dense)+1]
	s.dense[len(s.dense)-1] = i
}

type workq struct {
	s           sparseSet
	n           int  // size excluding marks
	maxm        int  // maximum number of marks
	nextm       int  // id of next mark
	lastWasMark bool // last inserted was mark
}

func newWorkq(n, maxmark int) *workq {
	return &workq{
		s:           makeSparseSet(n + maxmark),
		n:           n,
		maxm:        maxmark,
		nextm:       n,
		lastWasMark: true,
	}
}

func (q *workq) isMark(i int) bool { return i >= q.n }

func (q *workq) clear() {
	q.s.clear()
	q.nextm = q.n
}

func (q *workq) contains(i int) bool {
	return q.s.contains(i)
}

func (q *workq) maxmark() int {
	return q.maxm
}

func (q *workq) mark() {
	if q.lastWasMark {
		return
	}
	q.lastWasMark = false
	q.s.insertNew(int(q.nextm))
	q.nextm++
}

func (q *workq) size() int {
	return q.n + q.maxm
}

func (q *workq) insert(id int) {
	if q.s.contains(id) {
		return
	}
	q.insertNew(id)
}

func (q *workq) insertNew(id int) {
	q.lastWasMark = false
	q.s.insertNew(id)
}

func (q *workq) elements() []int { // should be []stateInst. Should we convert sparseset to use stateInst instead of int??
	return q.s.dense
}

func (q *workq) dump() string {
	var buf bytes.Buffer
	sep := ""
	for _, v := range q.elements() {
		if q.isMark(v) {
			buf.WriteString("|")
			sep = ""
		} else {
			buf.WriteString(sep)
			buf.WriteString(strconv.Itoa(v))
			sep = ","
		}
	}
	return buf.String()
}
