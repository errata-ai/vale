package gospell

import (
	"testing"
)

func TestRemovePath(t *testing.T) {
	cases := []struct {
		word string
		want string
	}{
		{" /foo/bar abc", "          abc"},
		{"X/foo/bar abc", "X/foo/bar abc"},
		{"[/foo/bar] abc", "[        ] abc"},
		{"/", "/"},
	}
	for pos, tt := range cases {
		got := RemovePath(tt.word)
		if got != tt.want {
			t.Errorf("%d want %q  got %q", pos, tt.want, got)
		}
	}
}
