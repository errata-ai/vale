package gospell

import (
	"reflect"
	"testing"
)

func TestSplitter(t *testing.T) {

	s := NewSplitter("012345689")

	cases := []struct {
		word string
		want []string
	}{
		{"abc", []string{"abc"}},
		{"abc xyz", []string{"abc", "xyz"}},
		{"abc! xyz!", []string{"abc", "xyz"}},
		{"1st 2nd x86 amd64", []string{"1st", "2nd", "x86", "amd64"}},
	}

	for pos, tt := range cases {
		got := s.Split(tt.word)
		if !reflect.DeepEqual(tt.want, got) {
			t.Errorf("%d want %v  got %v", pos, tt.want, got)
		}
	}
}

func TestIsNumber(t *testing.T) {

	cases := []struct {
		word string
		want bool
	}{
		{"0", true},
		{"00", true},
		{"100", true},
		{"1.", true},
		{"1.0.", true},
		{"1.0.0.", true},
		{"1,0", true},
		{"1-0", true},
		{"1..0", false},
		{"1--0", false},
		{"1..0", false},
		{"1-.0", false},
		{"-1.0", false},
		{",1", false},
	}
	for _, tt := range cases {
		if isNumber(tt.word) != tt.want {
			t.Errorf("%q is not %v", tt.word, tt.want)
		}
	}
}

func TestIsNumberUnits(t *testing.T) {
	cases := []struct {
		word string
		want string
	}{
		{"0", ""},
		{"xxx", ""},
		{"101a-b-c", ""},
		{"10GB", "GB"},
		{"1G", "G"},
	}
	for _, tt := range cases {
		if isNumberUnits(tt.word) != tt.want {
			t.Errorf("%q is not %v", tt.word, tt.want)
		}
	}
}

func TestIsNumberHex(t *testing.T) {
	cases := []struct {
		word string
		want bool
	}{
		{"0", false},
		{"0x", false},
		{"x", false},
		{"0x0", true},
		{"0xF", true},
		{"0xf", true},
		{"0xFF", true},
		{"0x12", true},
		{"x12", true},
		{"x86", true},
		{"xabcdef", true},
		{"0xZZ", false},
	}
	for _, tt := range cases {
		if isNumberHex(tt.word) != tt.want {
			t.Errorf("%q is not %v", tt.word, tt.want)
		}
	}
}

func TestSplitCamelCase(t *testing.T) {
	cases := []struct {
		word string
		want []string
	}{
		{"foo", nil}, // not camel case
		{"Foo", nil}, // not camel case
		{"FOO", nil}, // not camel case
		{"FooBar", []string{"Foo", "Bar"}},
		{"fooBar", []string{"foo", "Bar"}},
		{"FOOword", []string{"FOO", "word"}},
		{"isFOO", []string{"is", "FOO"}},
		{"RemoveURL", []string{"Remove", "Url"}},
	}
	for _, tt := range cases {
		got := splitCamelCase(tt.word)
		if !reflect.DeepEqual(tt.want, got) {
			t.Errorf("%q : want %v got %v", tt.word, tt.want, got)
		}
	}
}
