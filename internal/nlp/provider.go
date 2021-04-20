package nlp

import "github.com/jdkato/prose/tag"

// A Block represents a section of text.
type Block struct {
	Context string      // parent content - e.g., sentence -> paragraph
	Line    int         // line of the block
	Scope   string      // section selector
	Text    string      // text content
	Tokens  []tag.Token // POS-tagged tokens
}

// NewBlock makes a new Block with prepared text and a Selector.
func NewBlock(ctx, txt, sel string) Block {
	return NewLinedBlock(ctx, txt, sel, -1, false)
}

// NewLinedBlock creates a Block with an already-known location.
func NewLinedBlock(ctx, txt, sel string, line int, tagging bool) Block {
	var tokens []tag.Token

	if ctx == "" {
		ctx = txt
	}
	if tagging {
		tokens = TextToTokens(txt, true)
	}

	return Block{
		Context: ctx,
		Text:    txt,
		Scope:   sel,
		Line:    line,
		Tokens:  tokens}
}

// NLPInfo handles NLP-related tasks.
//
// Assigning this on a per-file basis allows us to handle multi-language
// projects -- one file might be `en` while another is `ja`, for example.
type NLPInfo struct {
	Tagging      bool // Does the file need POS tagging?
	Segmentation bool // Does the file need sentence segmentation?
	Splitting    bool // Does the file need paragraph splitting?

	Lang     string // Language of the file.
	Endpoint string // API endpoint (optional); TODO: should this be per-file?
	Scope    string // The file's ext scope.
}

// An NLP provider is a library to implements part-of-speech tagging, sentence
// segmentation, and word tokenization.
//
// The default implementation is the pure-Go prose library, but the goal is to
// allow (fairly) seamless integration with non-Go libraries too (such as
// spaCy).
func (n *NLPInfo) Compute(block *Block) ([]Block, error) {
	return prose(n, block)
}
