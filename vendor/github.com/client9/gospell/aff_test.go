package gospell

import (
	"reflect"
	"strings"
	"testing"
)

// SmokeTest for AFF parser.  Contains a little bit of everything.
//
func TestAFFSmoke(t *testing.T) {
	sample := `
#

TRY abc
WORDCHARS 123
ICONV 1
ICONV a b
PFX A Y 1
PFX A   0     re .
SFX D Y 4
SFX D   0     d          e
SFX D   y     ied        [^aeiou]y
SFX D   0     ed         [^ey]
SFX D   0     ed         [aeiou]y
REP 1
REP a ei
COMPOUNDMIN 2
`
	aff, err := NewDictConfig(strings.NewReader(sample))
	if err != nil {
		t.Fatalf("Unable to parse sample: %s", err)
	}

	if aff.TryChars != "abc" {
		t.Errorf("TRY stanza is %s", aff.TryChars)
	}

	if aff.WordChars != "123" {
		t.Errorf("WORDCHARS stanza is %s", aff.WordChars)
	}

	if aff.CompoundMin != 2 {
		t.Errorf("COMPOUNDMIN stanza not processed, want 2 got %d", aff.CompoundMin)
	}

	if len(aff.IconvReplacements) != 2 {
		t.Errorf("Didn't get ICONV replacement")
	} else {
		if aff.IconvReplacements[0] != "a" || aff.IconvReplacements[1] != "b" {
			t.Errorf("Replacement isnt a->b, got %v", aff.IconvReplacements)
		}
	}

	if len(aff.Replacements) != 1 {
		t.Errorf("Didn't get REPlacement")
	} else {
		pair := aff.Replacements[0]
		if pair[0] != "a" || pair[1] != "ei" {
			t.Errorf("Replacement isnt [a ie] got %v", pair)
		}
	}

	if len(aff.AffixMap) != 2 {
		t.Errorf("AffixMap is wrong size")
	}
	a, ok := aff.AffixMap[rune('A')]
	if !ok {
		t.Fatalf("Didn't get Affix for A")
	}
	if a.Type != Prefix {
		t.Fatalf("A Affix should be PFX %v, got %v", Prefix, a.Type)
	}
	if !a.CrossProduct {
		t.Fatalf("A Affix should be a cross product")
	}

	variations := a.Expand("define", nil)
	if len(variations) != 1 {
		t.Fatalf("Expected 1 variation got %d", len(variations))
	}
	if variations[0] != "redefine" {
		t.Errorf("Expected %s got %s", "redefine", variations[0])
	}

	a, ok = aff.AffixMap[rune('D')]
	if !ok {
		t.Fatalf("Didn't get Affix for D")
	}
	if a.Type != Suffix {
		t.Fatalf("Affix D is not a SFX %v", Suffix)
	}
	if len(a.Rules) != 4 {
		t.Fatalf("Affix should have 4 rules, got %d", len(a.Rules))
	}
	variations = a.Expand("accept", nil)
	if len(variations) != 1 {
		t.Fatalf("D Affix should have %d rules, got %d", 1, len(variations))
	}
	if variations[0] != "accepted" {
		t.Errorf("Expected %s got %s", "accepted", variations[0])
	}
}

func TestExpand(t *testing.T) {
	sample := `
SET UTF-8
TRY esianrtolcdugmphbyfvkwzESIANRTOLCDUGMPHBYFVKWZ'

REP 2
REP f ph
REP ph f

PFX A Y 1
PFX A 0 re .

SFX B Y 2
SFX B 0 ed [^y]
SFX B y ied y
`
	aff, err := NewDictConfig(strings.NewReader(sample))
	if err != nil {
		t.Fatalf("Unable to parse sample: %s", err)
	}

	cases := []struct {
		word string
		want []string
	}{
		{"hello", []string{"hello"}},
		{"try/B", []string{"try", "tried"}},
		{"work/AB", []string{"work", "worked", "rework", "reworked"}},
	}
	for pos, tt := range cases {
		got, err := aff.Expand(tt.word, nil)
		if err != nil {
			t.Errorf("%d: affix expansions error: %s", pos, err)
		}
		if !reflect.DeepEqual(tt.want, got) {
			t.Errorf("%d: affix expansion want %v got %v", pos, tt.want, got)
		}
	}
}

func TestCompound(t *testing.T) {
	sampleAff := `
SET UTF-8
COMPOUNDMIN 1
ONLYINCOMPOUND c
COMPOUNDRULE 2
COMPOUNDRULE n*1t
COMPOUNDRULE n*mp
WORDCHARS 0123456789
`
	sampleDic := `23
0/nm
0th/pt
1/n1
1st/p
1th/tc
2/nm
2nd/p
2th/tc
3/nm
3rd/p
3th/tc
4/nm
4th/pt
5/nm
5th/pt
6/nm
6th/pt
7/nm
7th/pt
8/nm
8th/pt
9/nm
9th/pt
`
	aff := strings.NewReader(sampleAff)
	dic := strings.NewReader(sampleDic)
	gs, err := NewGoSpellReader(aff, dic)
	if err != nil {
		t.Fatalf("Unable to create GoSpell: %s", err)
	}

	cases := []struct {
		word  string
		spell bool
	}{
		{"0", true},
		{"1", true},
		{"2", true},
		{"3", true},
		{"4", true},
		{"5", true},
		{"6", true},
		{"7", true},
		{"8", true},
		{"9", true},
		{"10", true},
		{"21", true},
		{"32", true},
		{"43", true},
		{"54", true},
		{"65", true},
		{"76", true},
		{"87", true},
		{"98", true},
		{"99", true},
		{"1st", true},
		{"21st", true},
		{"11th", true},
		{"1th", false},
		{"12th", true},
		{"2th", false},
		{"13th", true},
		{"3th", false},
		{"3rd", true},
		{"33rd", true},
		{"4th", true},
		{"5th", true},
		{"6th", true},
		{"7th", true},
		{"8th", true},
		{"9th", true},
		{"14th", true},
		{"15th", true},
		{"16th", true},
		{"17th", true},
		{"18th", true},
		{"19th", true},
		{"111", true},
		{"111st", false},
		{"111th", true},
	}
	for pos, tt := range cases {
		if gs.Spell(tt.word) != tt.spell {
			t.Errorf("%d %q was not %v", pos, tt.word, tt.spell)
		}
	}
}

func TestSpell(t *testing.T) {
	sampleAff := `
SET UTF-8
WORDCHARS 0123456789

PFX A Y 1
PFX A 0 re .

SFX B Y 2
SFX B 0 ed [^y]
SFX B y ied y
`

	sampleDic := `4
hello
try/B
work/AB
GB
`
	aff := strings.NewReader(sampleAff)
	dic := strings.NewReader(sampleDic)
	gs, err := NewGoSpellReader(aff, dic)
	if err != nil {
		t.Fatalf("Unable to create GoSpell: %s", err)
	}

	cases := []struct {
		word  string
		spell bool
	}{
		{"hello", true},
		{"try", true},
		{"tried", true},
		{"work", true},
		{"worked", true},
		{"rework", true},
		{"reworked", true},
		{"junk", false},
		{"100", true},
		{"1", true},
		{"100GB", true},
		{"100mi", false},
		{"0xFF", true},
		{"0x12ff", true},
	}
	for pos, tt := range cases {
		if gs.Spell(tt.word) != tt.spell {
			t.Errorf("%d %q was not %v", pos, tt.word, tt.spell)
		}
	}
}
