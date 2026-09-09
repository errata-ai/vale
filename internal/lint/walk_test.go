package lint

import (
	"index/suffixarray"
	"strings"
	"testing"
)

func TestSubInplace(t *testing.T) {
	cases := []struct {
		desc     string
		ctx      string
		sub      string
		want     string
		expected bool
	}{
		{
			desc:     "simple word",
			ctx:      "the quick fox",
			sub:      "quick",
			want:     "the @@@@@ fox",
			expected: true,
		},
		{
			desc:     "only first occurrence",
			ctx:      "foo foo", //nolint:dupword // intentional repeat
			sub:      "foo",
			want:     "@@@ foo",
			expected: true,
		},
		{
			desc:     "not found",
			ctx:      "hello",
			sub:      "world",
			want:     "hello",
			expected: false,
		},
		{
			desc:     "whole context equals sub",
			ctx:      "/",
			sub:      "/",
			want:     "@",
			expected: true,
		},
		{
			desc:     "repeated symbols (see #1099)",
			ctx:      "////",
			sub:      "////",
			want:     "@@@@",
			expected: true,
		},
		{
			desc:     "newlines are preserved",
			ctx:      "a\nb",
			sub:      "a\nb",
			want:     "@\n@",
			expected: true,
		},
		{
			desc:     "multi-byte runes are preserved",
			ctx:      "café",
			sub:      "café",
			want:     "@@@é",
			expected: true,
		},
	}

	for _, c := range cases {
		t.Run(c.desc, func(t *testing.T) {
			buf := []byte(c.ctx)

			found := subInplace(buf, c.sub, '@')
			if found != c.expected {
				t.Fatalf("found = %v; want %v", found, c.expected)
			}

			if got := string(buf); got != c.want {
				t.Fatalf("result = %q; want %q", got, c.want)
			}

			// The mask is length-preserving: positions in the context must
			// remain stable so that later lookups still line up.
			if len(buf) != len(c.ctx) {
				t.Fatalf("length changed: got %d, want %d", len(buf), len(c.ctx))
			}
		})
	}
}

// TestSubInplaceReadOnlyBacking guards against the regression in #1099, where
// the walker aliased a (potentially read-only) string backing array and then
// wrote to it. newWalker now copies the content, so the buffer handed to
// subInplace is always writable -- even when f.Content is a constant.
func TestSubInplaceReadOnlyBacking(t *testing.T) {
	const constContent = "////" // lives in the binary's read-only data.

	buf := []byte(constContent)
	if !subInplace(buf, constContent, '@') {
		t.Fatal("expected a match")
	}

	if string(buf) != "@@@@" {
		t.Fatalf("result = %q; want %q", string(buf), "@@@@")
	}
}

func TestScopeSafe(t *testing.T) {
	cases := map[string]bool{
		"title":           true,
		"admonitionblock": true,
		"sect-level1":     true,
		"h2":              true,
		"":                false,
		"a.b":             false, // `.` separates scope parts
		"a&b":             false, // `&` combines them
		"~a":              false, // `~` negates one
	}
	for in, want := range cases {
		if got := scopeSafe(in); got != want {
			t.Errorf("scopeSafe(%q) = %v, want %v", in, got, want)
		}
	}
}

func TestWalkerClasses(t *testing.T) {
	tests := []struct {
		name string
		cls  []string
		want []string
	}{
		{"none", []string{"", ""}, nil},
		{"one", []string{"", "title"}, []string{"title"}},
		{"multi-valued", []string{"admonitionblock note"}, []string{"admonitionblock", "note"}},
		{"repeats collapse", []string{"title", "title"}, []string{"title"}},
		{"unsafe dropped", []string{"a.b good"}, []string{"good"}},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			w := &walker{clsHistory: tt.cls}
			got := w.classes()
			if len(got) != len(tt.want) {
				t.Fatalf("classes() = %v, want %v", got, tt.want)
			}
			for i := range got {
				if got[i] != tt.want[i] {
					t.Errorf("classes() = %v, want %v", got, tt.want)
				}
			}
		})
	}
}

// An element's attributes are masked out of the context, but not the source
// bytes its own text still has to find. An autolink writes the URL once and
// the parser reports it twice -- as `href` and as text -- so masking the
// attribute first sent the text's search to the next copy of that URL, wherever
// in the document it happened to be. See #847.
func TestWalkerFlush(t *testing.T) {
	tests := []struct {
		name    string
		pending []string
		text    string
		want    string
	}{
		{
			name:    "autolink keeps its own bytes",
			pending: []string{"http://github.com"},
			text:    "http://github.com",
			want:    "http://github.com here\nand http://github.com there\n",
		},
		{
			name:    "a link target is masked",
			pending: []string{"http://github.com"},
			text:    "read this",
			want:    "@@@@@@@@@@@@@@@@@ here\nand http://github.com there\n",
		},
		{
			name:    "no text of its own",
			pending: []string{"http://github.com"},
			text:    "",
			want:    "@@@@@@@@@@@@@@@@@ here\nand http://github.com there\n",
		},
	}

	const src = "http://github.com here\nand http://github.com there\n"
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			w := &walker{context: []byte(src), pending: tt.pending}

			w.flush(tt.text)

			if got := w.getCtx(); got != tt.want {
				t.Errorf("flush(%q) left %q, want %q", tt.text, got, tt.want)
			}
			if w.pending != nil {
				t.Errorf("pending = %v, want nil", w.pending)
			}
		})
	}
}

// The index must answer exactly what a scan of the masked context answers,
// as masks accumulate: the first occurrence still present, or none.
func TestFirstMatchesScan(t *testing.T) {
	src := strings.Repeat("Click **Click here** to continue. Übung macht den Meister. ", 40) +
		"a\n\nb\n\nx y z\n" + strings.Repeat("the end of the line\n", 20)
	w := &walker{context: []byte(src), index: suffixarray.New([]byte(src))}

	needles := []string{"Click", "Click here", "Übung", "Meister.", "the", "line", "x y z", "nope", "", "\n\n"}
	check := func(step string) {
		ctx := string(w.context)
		for _, n := range needles {
			if got, want := w.first(n), strings.Index(ctx, n); got != want {
				t.Fatalf("%s: first(%q) = %d, want %d", step, n, got, want)
			}
		}
	}

	check("before masking")
	for i := 0; i < 60; i++ {
		for _, n := range []string{"Click here", "Click", "Übung macht den Meister.", "the end", "line"} {
			w.sub(n, '@')
			check("after masking " + n)
		}
	}
}

// A walker with an index and one without place the same lines.
func TestAdvanceWithIndexMatchesScan(t *testing.T) {
	src := strings.Repeat("one two three\n\nfour five\n\n", 30)
	plain := &walker{context: []byte(src)}
	indexed := &walker{context: []byte(src), index: suffixarray.New([]byte(src))}

	for i := 0; i < 30; i++ {
		for _, text := range []string{"one two three", "four five", "six"} {
			a, b := plain.advance(text), indexed.advance(text)
			if a != b {
				t.Fatalf("advance(%q) = %d with index, %d without", text, b, a)
			}
			if a >= 0 {
				plain.idx, indexed.idx = a, a
			}
			plain.reset()
			indexed.reset()
			plain.append(text)
			indexed.append(text)
		}
	}
}
