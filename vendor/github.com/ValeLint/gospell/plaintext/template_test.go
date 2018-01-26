package plaintext

import (
	"testing"
)

func TestStrip(t *testing.T) {
	orig := []byte("foo{{ junk }}bar")
	want := "foo bar"
	got := string(StripTemplate(orig))

	if got != want {
		t.Errorf("Want %q, Got %q", want, got)
	}
}
