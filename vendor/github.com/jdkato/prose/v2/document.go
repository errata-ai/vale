package prose

// A DocOpt represents a setting that changes the document creation process.
//
// For example, it might disable named-entity extraction:
//
//    doc := prose.NewDocument("...", prose.WithExtraction(false))
type DocOpt func(doc *Document, opts *DocOpts)

// DocOpts controls the Document creation process:
type DocOpts struct {
	Extract  bool // If true, include named-entity extraction
	Segment  bool // If true, include segmentation
	Tag      bool // If true, include POS tagging
	Tokenize bool // If true, include tokenization
}

// WithTokenization can enable (the default) or disable tokenization.
func WithTokenization(include bool) DocOpt {
	return func(doc *Document, opts *DocOpts) {
		// Tagging and entity extraction both require tokenization.
		opts.Tokenize = include
	}
}

// WithTagging can enable (the default) or disable POS tagging.
func WithTagging(include bool) DocOpt {
	return func(doc *Document, opts *DocOpts) {
		opts.Tag = include
	}
}

// WithSegmentation can enable (the default) or disable sentence segmentation.
func WithSegmentation(include bool) DocOpt {
	return func(doc *Document, opts *DocOpts) {
		opts.Segment = include
	}
}

// WithExtraction can enable (the default) or disable named-entity extraction.
func WithExtraction(include bool) DocOpt {
	return func(doc *Document, opts *DocOpts) {
		opts.Extract = include
	}
}

// UsingModel can enable (the default) or disable named-entity extraction.
func UsingModel(model *Model) DocOpt {
	return func(doc *Document, opts *DocOpts) {
		doc.Model = model
	}
}

// A Document represents a parsed body of text.
type Document struct {
	Model *Model
	Text  string

	// TODO: Store offsets (begin, end) instead of `text` field.
	entities  []Entity
	sentences []Sentence
	tokens    []*Token
}

// Tokens returns `doc`'s tokens.
func (doc *Document) Tokens() []Token {
	tokens := make([]Token, 0, len(doc.tokens))
	for _, tok := range doc.tokens {
		tokens = append(tokens, *tok)
	}
	return tokens
}

// Sentences returns `doc`'s sentences.
func (doc *Document) Sentences() []Sentence {
	return doc.sentences
}

// Entities returns `doc`'s entities.
func (doc *Document) Entities() []Entity {
	return doc.entities
}

var defaultOpts = DocOpts{
	Tokenize: true,
	Segment:  true,
	Tag:      true,
	Extract:  true,
}

// NewDocument creates a Document according to the user-specified options.
//
// For example,
//
//    doc := prose.NewDocument("...")
func NewDocument(text string, opts ...DocOpt) (*Document, error) {
	var pipeError error

	doc := Document{Text: text}
	base := defaultOpts
	for _, applyOpt := range opts {
		applyOpt(&doc, &base)
	}

	if doc.Model == nil {
		doc.Model = defaultModel(base.Tag, base.Extract)
	}

	if base.Segment {
		segmenter := newPunktSentenceTokenizer()
		doc.sentences = segmenter.segment(text)
	}
	if base.Tokenize || base.Tag || base.Extract {
		tokenizer := newIterTokenizer()
		doc.tokens = append(doc.tokens, tokenizer.tokenize(text)...)
	}
	if base.Tag || base.Extract {
		doc.tokens = doc.Model.tagger.tag(doc.tokens)
	}
	if base.Extract {
		doc.tokens = doc.Model.extracter.classify(doc.tokens)
		doc.entities = doc.Model.extracter.chunk(doc.tokens)
	}

	return &doc, pipeError
}
