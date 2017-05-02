package summarize

import (
	"regexp"
	"strings"
	"unicode/utf8"
)

type clearFunc func(word string, suffixes []string) string

// Syllables returns the number of syllables in the string word.
//
// NOTE: This function expects a word (not raw text) as input.
func Syllables(word string) int {
	// See if we can leave early ...
	length := utf8.RuneCountInString(word)
	if length < 1 {
		return 0
	} else if length < 3 {
		return 1
	}

	// See if this is a known cornercase ...
	word = strings.ToLower(word)
	if syllables, ok := cornercases[word]; ok {
		return syllables
	}
	text, count := clean(word)

	// Count multiple vowels
	count += len(vowels.FindAllString(text, -1))

	count -= len(monosyllabicOne.FindAllString(text, -1))
	count -= len(monosyllabicTwo.FindAllString(text, -1))

	count += len(doubleSyllabicOne.FindAllString(text, -1))
	count += len(doubleSyllabicTwo.FindAllString(text, -1))
	count += len(doubleSyllabicThree.FindAllString(text, -1))
	count += len(doubleSyllabicFour.FindAllString(text, -1))

	if count < 1 {
		return 1
	}
	return count
}

func clean(word string) (string, int) {
	var prefix, suffix int
	word, prefix = clearPart(word, incrementToPrefix, trimAnyPrefix)
	word, suffix = clearPart(word, incrementToSuffix, trimAnySuffix)
	return word, prefix + suffix
}

func clearPart(s string, options [][]string, clearer clearFunc) (string, int) {
	old := s
	pos := len(options)
	for i, trim := range options {
		s = clearer(s, trim)
		if s != old {
			return s, (pos - i)
		}
	}
	return s, 0
}

func trimAnySuffix(word string, suffixes []string) string {
	for _, suffix := range suffixes {
		if strings.HasSuffix(word, suffix) {
			return strings.TrimSuffix(word, suffix)
		}
	}
	return word
}

func trimAnyPrefix(word string, prefixes []string) string {
	for _, prefix := range prefixes {
		if strings.HasPrefix(word, prefix) {
			return strings.TrimPrefix(word, prefix)
		}
	}
	return word
}

var cornercases = map[string]int{
	"abalone":     4,
	"abare":       3,
	"abed":        2,
	"abruzzese":   4,
	"abbruzzese":  4,
	"aborigine":   5,
	"aborigines":  5,
	"acreage":     3,
	"adame":       3,
	"adieu":       2,
	"adobe":       3,
	"anemone":     4,
	"apache":      3,
	"aphrodite":   4,
	"apostrophe":  4,
	"ariadne":     4,
	"cafe":        2,
	"cafes":       2,
	"calliope":    4,
	"catastrophe": 4,
	"chile":       2,
	"chloe":       2,
	"circe":       2,
	"coyote":      3,
	"epitome":     4,
	"facsimile":   4,
	"forever":     3,
	"gethsemane":  4,
	"guacamole":   4,
	"hyperbole":   4,
	"jesse":       2,
	"jukebox":     2,
	"karate":      3,
	"machete":     3,
	"maybe":       2,
	"people":      2,
	"recipe":      3,
	"sesame":      3,
	"shoreline":   2,
	"simile":      3,
	"syncope":     3,
	"tamale":      3,
	"yosemite":    4,
	"daphne":      2,
	"eurydice":    4,
	"euterpe":     3,
	"hermione":    4,
	"penelope":    4,
	"persephone":  4,
	"phoebe":      2,
	"zoe":         2,
}

var monosyllabicOne = regexp.MustCompile("cia(l|$)|" +
	"tia|" +
	"cius|" +
	"cious|" +
	"[^aeiou]giu|" +
	"[aeiouy][^aeiouy]ion|" +
	"iou|" +
	"sia$|" +
	"eous$|" +
	"[oa]gue$|" +
	".[^aeiuoycgltdb]{2,}ed$|" +
	".ely$|" +
	"^jua|" +
	"uai|" +
	"eau|" +
	"^busi$|" +
	"(" +
	"[aeiouy]" +
	"(" +
	"b|" +
	"c|" +
	"ch|" +
	"dg|" +
	"f|" +
	"g|" +
	"gh|" +
	"gn|" +
	"k|" +
	"l|" +
	"lch|" +
	"ll|" +
	"lv|" +
	"m|" +
	"mm|" +
	"n|" +
	"nc|" +
	"ng|" +
	"nch|" +
	"nn|" +
	"p|" +
	"r|" +
	"rc|" +
	"rn|" +
	"rs|" +
	"rv|" +
	"s|" +
	"sc|" +
	"sk|" +
	"sl|" +
	"squ|" +
	"ss|" +
	"th|" +
	"v|" +
	"y|" +
	"z" +
	")" +
	"ed$" +
	")|" +
	"(" +
	"[aeiouy]" +
	"(" +
	"b|" +
	"ch|" +
	"d|" +
	"f|" +
	"gh|" +
	"gn|" +
	"k|" +
	"l|" +
	"lch|" +
	"ll|" +
	"lv|" +
	"m|" +
	"mm|" +
	"n|" +
	"nch|" +
	"nn|" +
	"p|" +
	"r|" +
	"rn|" +
	"rs|" +
	"rv|" +
	"s|" +
	"sc|" +
	"sk|" +
	"sl|" +
	"squ|" +
	"ss|" +
	"st|" +
	"t|" +
	"th|" +
	"v|" +
	"y" +
	")" +
	"es$" +
	")",
)
var monosyllabicTwo = regexp.MustCompile("[aeiouy]" +
	"(" +
	"b|" +
	"c|" +
	"ch|" +
	"d|" +
	"dg|" +
	"f|" +
	"g|" +
	"gh|" +
	"gn|" +
	"k|" +
	"l|" +
	"ll|" +
	"lv|" +
	"m|" +
	"mm|" +
	"n|" +
	"nc|" +
	"ng|" +
	"nn|" +
	"p|" +
	"r|" +
	"rc|" +
	"rn|" +
	"rs|" +
	"rv|" +
	"s|" +
	"sc|" +
	"sk|" +
	"sl|" +
	"squ|" +
	"ss|" +
	"st|" +
	"t|" +
	"th|" +
	"v|" +
	"y|" +
	"z" +
	")" +
	"e$",
)
var doubleSyllabicOne = regexp.MustCompile("(?:" +
	"[^aeiouy]ie" +
	"(" +
	"r|" +
	"st|" +
	"t" +
	")|" +
	"[aeiouym]bl|" +
	"eo|" +
	"ism|" +
	"asm|" +
	"thm|" +
	"dnt|" +
	"uity|" +
	"dea|" +
	"gean|" +
	"oa|" +
	"ua|" +
	"eings?|" +
	"[aeiouy]sh?e[rsd]" +
	")$")

var doubleSyllabicTwo = regexp.MustCompile(
	"[^gq]ua[^auieo]|[aeiou]{3}|^(ia|mc|coa[dglx].)")

var doubleSyllabicThree = regexp.MustCompile(
	"[^aeiou]y[ae]|" +
		"[^l]lien|" +
		"riet|" +
		"dien|" +
		"iu|" +
		"io|" +
		"ii|" +
		"uen|" +
		"real|" +
		"iell|" +
		"eo[^aeiou]|" +
		"[aeiou]y[aeiou]",
)
var doubleSyllabicFour = regexp.MustCompile(
	"[^s]ia",
)
var vowels = regexp.MustCompile(
	"[aeiouy]+",
)
var incrementToPrefix = [][]string{
	{
		"above", "anti", "ante", "counter", "hyper", "afore", "agri", "infra",
		"intra", "inter", "over", "semi", "ultra", "under", "extra", "dia",
		"micro", "mega", "kilo", "pico", "nano", "macro"},
	{
		"un", "fore", "ware", "none", "non", "out", "post", "sub", "pre",
		"pro", "dis", "side"},
}
var incrementToSuffix = [][]string{
	{"ology", "ologist", "onomy", "onomist"},
	{"fully", "berry", "woman", "women"},
	{
		"ly", "less", "some", "ful", "er", "ers", "ness", "cian", "cians",
		"ment", "ments", "ette", "ettes", "ville", "villes", "ships", "ship",
		"side", "sides", "port", "ports", "shire", "shires", "tion", "tioned"},
}
