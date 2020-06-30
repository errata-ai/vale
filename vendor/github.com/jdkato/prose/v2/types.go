package prose

// A Token represents an individual token of text such as a word or punctuation
// symbol.
type Token struct {
	Tag   string // The token's part-of-speech tag.
	Text  string // The token's actual content.
	Label string // The token's IOB label.
}

// An Entity represents an individual named-entity.
type Entity struct {
	Text  string // The entity's actual content.
	Label string // The entity's label.
}

// A Sentence represents a segmented portion of text.
type Sentence struct {
	Text string // The sentence's text.
}
