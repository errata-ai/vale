package ast

import (
	"github.com/gobwas/glob/syntax/lexer"
	"reflect"
	"testing"
)

type stubLexer struct {
	tokens []lexer.Token
	pos    int
}

func (s *stubLexer) Next() (ret lexer.Token) {
	if s.pos == len(s.tokens) {
		return lexer.Token{lexer.EOF, ""}
	}
	ret = s.tokens[s.pos]
	s.pos++
	return
}

func TestParseString(t *testing.T) {
	for id, test := range []struct {
		tokens []lexer.Token
		tree   *Node
	}{
		{
			//pattern: "abc",
			tokens: []lexer.Token{
				lexer.Token{lexer.Text, "abc"},
				lexer.Token{lexer.EOF, ""},
			},
			tree: NewNode(KindPattern, nil,
				NewNode(KindText, Text{Text: "abc"}),
			),
		},
		{
			//pattern: "a*c",
			tokens: []lexer.Token{
				lexer.Token{lexer.Text, "a"},
				lexer.Token{lexer.Any, "*"},
				lexer.Token{lexer.Text, "c"},
				lexer.Token{lexer.EOF, ""},
			},
			tree: NewNode(KindPattern, nil,
				NewNode(KindText, Text{Text: "a"}),
				NewNode(KindAny, nil),
				NewNode(KindText, Text{Text: "c"}),
			),
		},
		{
			//pattern: "a**c",
			tokens: []lexer.Token{
				lexer.Token{lexer.Text, "a"},
				lexer.Token{lexer.Super, "**"},
				lexer.Token{lexer.Text, "c"},
				lexer.Token{lexer.EOF, ""},
			},
			tree: NewNode(KindPattern, nil,
				NewNode(KindText, Text{Text: "a"}),
				NewNode(KindSuper, nil),
				NewNode(KindText, Text{Text: "c"}),
			),
		},
		{
			//pattern: "a?c",
			tokens: []lexer.Token{
				lexer.Token{lexer.Text, "a"},
				lexer.Token{lexer.Single, "?"},
				lexer.Token{lexer.Text, "c"},
				lexer.Token{lexer.EOF, ""},
			},
			tree: NewNode(KindPattern, nil,
				NewNode(KindText, Text{Text: "a"}),
				NewNode(KindSingle, nil),
				NewNode(KindText, Text{Text: "c"}),
			),
		},
		{
			//pattern: "[!a-z]",
			tokens: []lexer.Token{
				lexer.Token{lexer.RangeOpen, "["},
				lexer.Token{lexer.Not, "!"},
				lexer.Token{lexer.RangeLo, "a"},
				lexer.Token{lexer.RangeBetween, "-"},
				lexer.Token{lexer.RangeHi, "z"},
				lexer.Token{lexer.RangeClose, "]"},
				lexer.Token{lexer.EOF, ""},
			},
			tree: NewNode(KindPattern, nil,
				NewNode(KindRange, Range{Lo: 'a', Hi: 'z', Not: true}),
			),
		},
		{
			//pattern: "[az]",
			tokens: []lexer.Token{
				lexer.Token{lexer.RangeOpen, "["},
				lexer.Token{lexer.Text, "az"},
				lexer.Token{lexer.RangeClose, "]"},
				lexer.Token{lexer.EOF, ""},
			},
			tree: NewNode(KindPattern, nil,
				NewNode(KindList, List{Chars: "az"}),
			),
		},
		{
			//pattern: "{a,z}",
			tokens: []lexer.Token{
				lexer.Token{lexer.TermsOpen, "{"},
				lexer.Token{lexer.Text, "a"},
				lexer.Token{lexer.Separator, ","},
				lexer.Token{lexer.Text, "z"},
				lexer.Token{lexer.TermsClose, "}"},
				lexer.Token{lexer.EOF, ""},
			},
			tree: NewNode(KindPattern, nil,
				NewNode(KindAnyOf, nil,
					NewNode(KindPattern, nil,
						NewNode(KindText, Text{Text: "a"}),
					),
					NewNode(KindPattern, nil,
						NewNode(KindText, Text{Text: "z"}),
					),
				),
			),
		},
		{
			//pattern: "/{z,ab}*",
			tokens: []lexer.Token{
				lexer.Token{lexer.Text, "/"},
				lexer.Token{lexer.TermsOpen, "{"},
				lexer.Token{lexer.Text, "z"},
				lexer.Token{lexer.Separator, ","},
				lexer.Token{lexer.Text, "ab"},
				lexer.Token{lexer.TermsClose, "}"},
				lexer.Token{lexer.Any, "*"},
				lexer.Token{lexer.EOF, ""},
			},
			tree: NewNode(KindPattern, nil,
				NewNode(KindText, Text{Text: "/"}),
				NewNode(KindAnyOf, nil,
					NewNode(KindPattern, nil,
						NewNode(KindText, Text{Text: "z"}),
					),
					NewNode(KindPattern, nil,
						NewNode(KindText, Text{Text: "ab"}),
					),
				),
				NewNode(KindAny, nil),
			),
		},
		{
			//pattern: "{a,{x,y},?,[a-z],[!qwe]}",
			tokens: []lexer.Token{
				lexer.Token{lexer.TermsOpen, "{"},
				lexer.Token{lexer.Text, "a"},
				lexer.Token{lexer.Separator, ","},
				lexer.Token{lexer.TermsOpen, "{"},
				lexer.Token{lexer.Text, "x"},
				lexer.Token{lexer.Separator, ","},
				lexer.Token{lexer.Text, "y"},
				lexer.Token{lexer.TermsClose, "}"},
				lexer.Token{lexer.Separator, ","},
				lexer.Token{lexer.Single, "?"},
				lexer.Token{lexer.Separator, ","},
				lexer.Token{lexer.RangeOpen, "["},
				lexer.Token{lexer.RangeLo, "a"},
				lexer.Token{lexer.RangeBetween, "-"},
				lexer.Token{lexer.RangeHi, "z"},
				lexer.Token{lexer.RangeClose, "]"},
				lexer.Token{lexer.Separator, ","},
				lexer.Token{lexer.RangeOpen, "["},
				lexer.Token{lexer.Not, "!"},
				lexer.Token{lexer.Text, "qwe"},
				lexer.Token{lexer.RangeClose, "]"},
				lexer.Token{lexer.TermsClose, "}"},
				lexer.Token{lexer.EOF, ""},
			},
			tree: NewNode(KindPattern, nil,
				NewNode(KindAnyOf, nil,
					NewNode(KindPattern, nil,
						NewNode(KindText, Text{Text: "a"}),
					),
					NewNode(KindPattern, nil,
						NewNode(KindAnyOf, nil,
							NewNode(KindPattern, nil,
								NewNode(KindText, Text{Text: "x"}),
							),
							NewNode(KindPattern, nil,
								NewNode(KindText, Text{Text: "y"}),
							),
						),
					),
					NewNode(KindPattern, nil,
						NewNode(KindSingle, nil),
					),
					NewNode(KindPattern, nil,
						NewNode(KindRange, Range{Lo: 'a', Hi: 'z', Not: false}),
					),
					NewNode(KindPattern, nil,
						NewNode(KindList, List{Chars: "qwe", Not: true}),
					),
				),
			),
		},
	} {
		lexer := &stubLexer{tokens: test.tokens}
		result, err := Parse(lexer)
		if err != nil {
			t.Errorf("[%d] unexpected error: %s", id, err)
		}
		if !reflect.DeepEqual(test.tree, result) {
			t.Errorf("[%d] Parse():\nact:\t%s\nexp:\t%s\n", id, result, test.tree)
		}
	}
}
