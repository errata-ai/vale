package check

import "testing"

func TestWrapSpaces(t *testing.T) {
	cases := []struct{ in, want string }{
		{"for example", `for\s+example`},
		{"in order to", `in\s+order\s+to`},
		{"a  b", `a\s+b`},
		{"word", "word"},
		{`\bfor example\b`, `\bfor\s+example\b`},
		{`[ ]`, `[ ]`},
		{`[a ]b c`, `[a ]b\s+c`},
		{`a\ b`, `a\ b`},
		{`a +b`, `a +b`},
		{`a {2}b`, `a {2}b`},
		{`a ?b`, `a ?b`},
		{`(?x) a b`, `(?x) a b`},
		{`(?i)for example`, `(?i)for\s+example`},
	}
	for _, c := range cases {
		if got := wrapSpaces(c.in); got != c.want {
			t.Errorf("wrapSpaces(%q) = %q; want %q", c.in, got, c.want)
		}
	}
}

func TestUnwrap(t *testing.T) {
	cases := []struct{ in, want string }{
		{"for example", "for example"},
		{"for\nexample", "for example"},
		{"for \n  example", "for example"},
		{"a  b", "a  b"},
	}
	for _, c := range cases {
		if got := unwrap(c.in); got != c.want {
			t.Errorf("unwrap(%q) = %q; want %q", c.in, got, c.want)
		}
	}
}
