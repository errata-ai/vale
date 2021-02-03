package gofeed

import (
	"bytes"
	"context"
	"errors"
	"fmt"
	"io"
	"net/http"
	"strings"

	"github.com/mmcdole/gofeed/atom"
	"github.com/mmcdole/gofeed/json"
	"github.com/mmcdole/gofeed/rss"
)

// ErrFeedTypeNotDetected is returned when the detection system can not figure
// out the Feed format
var ErrFeedTypeNotDetected = errors.New("Failed to detect feed type")

// HTTPError represents an HTTP error returned by a server.
type HTTPError struct {
	StatusCode int
	Status     string
}

func (err HTTPError) Error() string {
	return fmt.Sprintf("http error: %s", err.Status)
}

// Parser is a universal feed parser that detects
// a given feed type, parsers it, and translates it
// to the universal feed type.
type Parser struct {
	AtomTranslator Translator
	RSSTranslator  Translator
	JSONTranslator Translator
	Client         *http.Client
	rp             *rss.Parser
	ap             *atom.Parser
	jp             *json.Parser
}

// NewParser creates a universal feed parser.
func NewParser() *Parser {
	fp := Parser{
		rp: &rss.Parser{},
		ap: &atom.Parser{},
		jp: &json.Parser{},
	}
	return &fp
}

// Parse parses a RSS or Atom or JSON feed into
// the universal gofeed.Feed.  It takes an
// io.Reader which should return the xml/json content.
func (f *Parser) Parse(feed io.Reader) (*Feed, error) {
	// Wrap the feed io.Reader in a io.TeeReader
	// so we can capture all the bytes read by the
	// DetectFeedType function and construct a new
	// reader with those bytes intact for when we
	// attempt to parse the feeds.
	var buf bytes.Buffer
	tee := io.TeeReader(feed, &buf)
	feedType := DetectFeedType(tee)

	// Glue the read bytes from the detect function
	// back into a new reader
	r := io.MultiReader(&buf, feed)

	switch feedType {
	case FeedTypeAtom:
		return f.parseAtomFeed(r)
	case FeedTypeRSS:
		return f.parseRSSFeed(r)
	case FeedTypeJSON:
		return f.parseJSONFeed(r)
	}

	return nil, ErrFeedTypeNotDetected
}

// ParseURL fetches the contents of a given url and
// attempts to parse the response into the universal feed type.
func (f *Parser) ParseURL(feedURL string) (feed *Feed, err error) {
	return f.ParseURLWithContext(feedURL, context.Background())
}

// ParseURLWithContext fetches contents of a given url and
// attempts to parse the response into the universal feed type.
// Request could be canceled or timeout via given context
func (f *Parser) ParseURLWithContext(feedURL string, ctx context.Context) (feed *Feed, err error) {
	client := f.httpClient()

	req, err := http.NewRequest("GET", feedURL, nil)
	if err != nil {
		return nil, err
	}
	req = req.WithContext(ctx)
	req.Header.Set("User-Agent", "Gofeed/1.0")
	resp, err := client.Do(req)

	if err != nil {
		return nil, err
	}

	if resp != nil {
		defer func() {
			ce := resp.Body.Close()
			if ce != nil {
				err = ce
			}
		}()
	}

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		return nil, HTTPError{
			StatusCode: resp.StatusCode,
			Status:     resp.Status,
		}
	}

	return f.Parse(resp.Body)
}

// ParseString parses a feed XML string and into the
// universal feed type.
func (f *Parser) ParseString(feed string) (*Feed, error) {
	return f.Parse(strings.NewReader(feed))
}

func (f *Parser) parseAtomFeed(feed io.Reader) (*Feed, error) {
	af, err := f.ap.Parse(feed)
	if err != nil {
		return nil, err
	}
	return f.atomTrans().Translate(af)
}

func (f *Parser) parseRSSFeed(feed io.Reader) (*Feed, error) {
	rf, err := f.rp.Parse(feed)
	if err != nil {
		return nil, err
	}

	return f.rssTrans().Translate(rf)
}

func (f *Parser) parseJSONFeed(feed io.Reader) (*Feed, error) {
	jf, err := f.jp.Parse(feed)
	if err != nil {
		return nil, err
	}
	return f.jsonTrans().Translate(jf)
}

func (f *Parser) atomTrans() Translator {
	if f.AtomTranslator != nil {
		return f.AtomTranslator
	}
	f.AtomTranslator = &DefaultAtomTranslator{}
	return f.AtomTranslator
}

func (f *Parser) rssTrans() Translator {
	if f.RSSTranslator != nil {
		return f.RSSTranslator
	}
	f.RSSTranslator = &DefaultRSSTranslator{}
	return f.RSSTranslator
}

func (f *Parser) jsonTrans() Translator {
	if f.JSONTranslator != nil {
		return f.JSONTranslator
	}
	f.JSONTranslator = &DefaultJSONTranslator{}
	return f.JSONTranslator
}

func (f *Parser) httpClient() *http.Client {
	if f.Client != nil {
		return f.Client
	}
	f.Client = &http.Client{}
	return f.Client
}
