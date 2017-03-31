package lexer

import (
	"testing"
)

func TestLexGood(t *testing.T) {
	for id, test := range []struct {
		pattern string
		items   []Token
	}{
		{
			pattern: "",
			items: []Token{
				Token{EOF, ""},
			},
		},
		{
			pattern: "hello",
			items: []Token{
				Token{Text, "hello"},
				Token{EOF, ""},
			},
		},
		{
			pattern: "/{rate,[0-9]]}*",
			items: []Token{
				Token{Text, "/"},
				Token{TermsOpen, "{"},
				Token{Text, "rate"},
				Token{Separator, ","},
				Token{RangeOpen, "["},
				Token{RangeLo, "0"},
				Token{RangeBetween, "-"},
				Token{RangeHi, "9"},
				Token{RangeClose, "]"},
				Token{Text, "]"},
				Token{TermsClose, "}"},
				Token{Any, "*"},
				Token{EOF, ""},
			},
		},
		{
			pattern: "hello,world",
			items: []Token{
				Token{Text, "hello,world"},
				Token{EOF, ""},
			},
		},
		{
			pattern: "hello\\,world",
			items: []Token{
				Token{Text, "hello,world"},
				Token{EOF, ""},
			},
		},
		{
			pattern: "hello\\{world",
			items: []Token{
				Token{Text, "hello{world"},
				Token{EOF, ""},
			},
		},
		{
			pattern: "hello?",
			items: []Token{
				Token{Text, "hello"},
				Token{Single, "?"},
				Token{EOF, ""},
			},
		},
		{
			pattern: "hellof*",
			items: []Token{
				Token{Text, "hellof"},
				Token{Any, "*"},
				Token{EOF, ""},
			},
		},
		{
			pattern: "hello**",
			items: []Token{
				Token{Text, "hello"},
				Token{Super, "**"},
				Token{EOF, ""},
			},
		},
		{
			pattern: "[日-語]",
			items: []Token{
				Token{RangeOpen, "["},
				Token{RangeLo, "日"},
				Token{RangeBetween, "-"},
				Token{RangeHi, "語"},
				Token{RangeClose, "]"},
				Token{EOF, ""},
			},
		},
		{
			pattern: "[!日-語]",
			items: []Token{
				Token{RangeOpen, "["},
				Token{Not, "!"},
				Token{RangeLo, "日"},
				Token{RangeBetween, "-"},
				Token{RangeHi, "語"},
				Token{RangeClose, "]"},
				Token{EOF, ""},
			},
		},
		{
			pattern: "[日本語]",
			items: []Token{
				Token{RangeOpen, "["},
				Token{Text, "日本語"},
				Token{RangeClose, "]"},
				Token{EOF, ""},
			},
		},
		{
			pattern: "[!日本語]",
			items: []Token{
				Token{RangeOpen, "["},
				Token{Not, "!"},
				Token{Text, "日本語"},
				Token{RangeClose, "]"},
				Token{EOF, ""},
			},
		},
		{
			pattern: "{a,b}",
			items: []Token{
				Token{TermsOpen, "{"},
				Token{Text, "a"},
				Token{Separator, ","},
				Token{Text, "b"},
				Token{TermsClose, "}"},
				Token{EOF, ""},
			},
		},
		{
			pattern: "/{z,ab}*",
			items: []Token{
				Token{Text, "/"},
				Token{TermsOpen, "{"},
				Token{Text, "z"},
				Token{Separator, ","},
				Token{Text, "ab"},
				Token{TermsClose, "}"},
				Token{Any, "*"},
				Token{EOF, ""},
			},
		},
		{
			pattern: "{[!日-語],*,?,{a,b,\\c}}",
			items: []Token{
				Token{TermsOpen, "{"},
				Token{RangeOpen, "["},
				Token{Not, "!"},
				Token{RangeLo, "日"},
				Token{RangeBetween, "-"},
				Token{RangeHi, "語"},
				Token{RangeClose, "]"},
				Token{Separator, ","},
				Token{Any, "*"},
				Token{Separator, ","},
				Token{Single, "?"},
				Token{Separator, ","},
				Token{TermsOpen, "{"},
				Token{Text, "a"},
				Token{Separator, ","},
				Token{Text, "b"},
				Token{Separator, ","},
				Token{Text, "c"},
				Token{TermsClose, "}"},
				Token{TermsClose, "}"},
				Token{EOF, ""},
			},
		},
	} {
		lexer := NewLexer(test.pattern)
		for i, exp := range test.items {
			act := lexer.Next()
			if act.Type != exp.Type {
				t.Errorf("#%d %q: wrong %d-th item type: exp: %q; act: %q\n\t(%s vs %s)", id, test.pattern, i, exp.Type, act.Type, exp, act)
			}
			if act.Raw != exp.Raw {
				t.Errorf("#%d %q: wrong %d-th item contents: exp: %q; act: %q\n\t(%s vs %s)", id, test.pattern, i, exp.Raw, act.Raw, exp, act)
			}
		}
	}
}
