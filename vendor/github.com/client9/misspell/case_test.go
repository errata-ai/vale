package misspell

import (
	"reflect"
	"testing"
)

func TestCaseStyle(t *testing.T) {
	cases := []struct {
		word string
		want WordCase
	}{
		{"lower", AllLower},
		{"what's", AllLower},
		{"UPPER", AllUpper},
		{"Title", Title},
		{"CamelCase", Mixed},
		{"camelCase", Mixed},
	}

	for pos, tt := range cases {
		got := CaseStyle(tt.word)
		if tt.want != got {
			t.Errorf("Case %d %q: want %v got %v", pos, tt.word, tt.want, got)
		}
	}
}

func TestCaseVariations(t *testing.T) {
	cases := []struct {
		word string
		want []string
	}{
		{"that's", []string{"that's", "That's", "THAT'S"}},
	}
	for pos, tt := range cases {
		got := CaseVariations(tt.word, CaseStyle(tt.word))
		if !reflect.DeepEqual(tt.want, got) {
			t.Errorf("Case %d %q: want %v got %v", pos, tt.word, tt.want, got)
		}
	}
}
