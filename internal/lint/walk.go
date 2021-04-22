package lint

import (
	"bytes"
	"net/url"
	"strings"

	"github.com/errata-ai/vale/v2/internal/core"
	"github.com/errata-ai/vale/v2/internal/nlp"
	"golang.org/x/net/html"
)

type walker struct {
	lines   int
	section string
	context string

	activeTag string

	idx int
	z   *html.Tokenizer

	// queue holds each segment of text we encounter in a block, which we then
	// use to sequentially update our context.
	queue []string

	// tagHistory holds the HTML tags we encounter in a given block -- e.g.,
	// if we see <ul>, <li>, <p>, we'd get tagHistory = [ul li p]. It's reset
	// on every non-inline end tag.
	tagHistory []string
}

func newWalker(f *core.File, raw []byte, offset int) walker {
	return walker{
		lines:   len(f.Lines) + offset,
		context: f.Content,
		z:       html.NewTokenizer(bytes.NewReader(raw))}
}

func (w *walker) reset() {
	for _, s := range w.queue {
		w.context = updateCtx(w.context, s, html.TextToken)
	}
	w.queue = []string{}
	w.tagHistory = []string{}
}

func (w *walker) append(text string) {
	if text != "" {
		pos := w.advance(text)
		if pos > -1 {
			w.idx = pos
		}
		w.queue = append(w.queue, text)
	}
}

func (w *walker) addTag(tag string) {
	w.tagHistory = append(w.tagHistory, tag)
	w.activeTag = tag
}

func (w *walker) block(text, scope string) nlp.Block {
	line := w.idx

	pos := w.advance(text)
	if pos != line && pos > -1 {
		line = pos
	}

	return nlp.NewLinedBlock(w.context, text, scope, line, nil)
}

func (w *walker) walk() (html.TokenType, html.Token, string) {
	tokt := w.z.Next()
	tok := w.z.Token()
	return tokt, tok, html.UnescapeString(strings.TrimSpace(tok.Data))
}

func (w *walker) replaceToks(tok html.Token) {
	if core.StringInSlice(tok.Data, []string{"img", "a", "p", "script"}) {
		for _, a := range tok.Attr {
			if core.StringInSlice(a.Key, []string{"href", "id", "src"}) {
				if a.Key == "href" {
					a.Val, _ = url.QueryUnescape(a.Val)
				}
				w.context = updateCtx(w.context, a.Val, html.TextToken)
			}
		}
	}
}

func (w *walker) advance(text string) int {
	pos := 0
	for _, s := range strings.Split(text, "\n") {
		pos = strings.Index(w.context, s)
		if pos < 0 {
			for _, ss := range strings.Fields(s) {
				pos = strings.Index(w.context, ss)
			}
		}
	}
	if pos >= 0 {
		l := strings.Count(w.context[:pos], "\n")
		if l > w.idx {
			return l
		}
	}
	return -1
}
