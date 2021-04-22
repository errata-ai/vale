package nlp

import (
	"strings"
)

type segmenter func(string) []string

// A Block represents a section of text.
type Block struct {
	Context string // parent content - e.g., sentence -> paragraph
	Line    int    // line of the block
	Scope   string // section selector
	Text    string // text content
}

// NewBlock makes a new Block with prepared text and a Selector.
func NewBlock(ctx, txt, sel string) Block {
	return NewLinedBlock(ctx, txt, sel, -1, nil)
}

// NewLinedBlock creates a Block with an already-known location.
func NewLinedBlock(ctx, txt, sel string, line int, nlp *NLPInfo) Block {
	if ctx == "" {
		ctx = txt
	}

	return Block{
		Context: ctx,
		Text:    txt,
		Scope:   sel,
		Line:    line}
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
	seg := SentenceTokenizer.Tokenize
	if n.Endpoint != "" && n.Lang != "en" {
		// We only use external segmentation for non-English text since prose
		// (our native library) is more efficient.
		seg = func(text string) []string {
			ret, err := segment(text, n.Lang, n.Endpoint)
			if err != nil {
				panic(err)
			}
			return ret.Sents
		}
	}
	return n.doNLP(block, seg)
}

func (n *NLPInfo) doNLP(blk *Block, seg segmenter) ([]Block, error) {
	blks := []Block{}

	ctx := blk.Context
	idx := blk.Line
	ext := n.Scope

	if n.Splitting {
		for _, p := range strings.SplitAfter(blk.Text, "\n\n") {
			blks = append(
				blks, NewLinedBlock(ctx, p, "paragraph"+ext, idx, nil))
		}
	}

	if n.Segmentation {
		for _, s := range seg(blk.Text) {
			blks = append(
				blks, NewLinedBlock(ctx, s, "sentence"+ext, idx, nil))
		}
	}

	blks = append(
		blks, NewLinedBlock(ctx, blk.Text, "text"+ext, idx, nil))

	return blks, nil
}
