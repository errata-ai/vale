package sizedwaitgroup

import (
	"sync/atomic"
	"testing"
)

func TestWait(t *testing.T) {
	swg := New(10)
	var c uint32

	for i := 0; i < 10000; i++ {
		swg.Add()
		go func(c *uint32) {
			defer swg.Done()
			atomic.AddUint32(c, 1)
		}(&c)
	}

	swg.Wait()

	if c != 10000 {
		t.Fatalf("%d, not all routines have been executed.", c)
	}
}

func TestThrottling(t *testing.T) {
	var c uint32

	swg := New(4)

	if len(swg.current) != 0 {
		t.Fatalf("the SizedWaitGroup should start with zero.")
	}

	for i := 0; i < 10000; i++ {
		swg.Add()
		go func(c *uint32) {
			defer swg.Done()
			atomic.AddUint32(c, 1)
			if len(swg.current) > 4 {
				t.Fatalf("not the good amount of routines spawned.")
				return
			}
		}(&c)
	}

	swg.Wait()
}

func TestNoThrottling(t *testing.T) {
	var c uint32
	swg := New(0)
	if len(swg.current) != 0 {
		t.Fatalf("the SizedWaitGroup should start with zero.")
	}
	for i := 0; i < 10000; i++ {
		swg.Add()
		go func(c *uint32) {
			defer swg.Done()
			atomic.AddUint32(c, 1)
		}(&c)
	}
	swg.Wait()
	if c != 10000 {
		t.Fatalf("%d, not all routines have been executed.", c)
	}
}
