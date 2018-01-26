package plaintext

import (
	"testing"
)

// TestIdentity test is input is passed back
func TestIdentity(t *testing.T) {
	p, err := NewIdentity()
	if err != nil {
		t.Fatalf("unable to run test")
	}
	raw := []byte("whatever[]<>")
	orig := string(raw)
	got := string(p.Text(raw))
	if got != orig {
		t.Errorf("identity failed")
	}
}
