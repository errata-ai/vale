package check

import (
	"fmt"
	"testing"

	"github.com/jdkato/prose/v3/segment"

	"github.com/vale-cli/vale/v3/internal/core"
	"github.com/vale-cli/vale/v3/internal/nlp"
)

// BenchmarkFileSentencesCache isolates the cost this PR's "Full performance
// reasoning" attributes to File.Sentences' cache: a repeated call against the
// same text should hit a map lookup (TokenCache.sentences) instead of paying
// for Punkt segmentation again.
//
// Cold constructs a fresh File -- so a fresh, empty TokenCache -- on every
// iteration, forcing f.Sentences to actually segment text each time. Cached
// primes the cache once outside the timed loop, then calls f.Sentences
// against that same File every iteration, so only the map lookup and its
// surrounding bookkeeping are timed.
func BenchmarkFileSentencesCache(b *testing.B) {
	text := "I bought a widget that arrived promptly, said the courier. " +
		"It shipped Tuesday and cleared customs Thursday. " +
		"The invoice listed three line items and a discount code."

	b.Run("Cold", func(b *testing.B) {
		b.ReportAllocs()
		for i := 0; i < b.N; i++ {
			f := &core.File{NLP: nlp.Info{Segmentation: true}}
			if _, err := f.Sentences(text); err != nil {
				b.Fatalf("segmenting: %v", err)
			}
		}
	})

	b.Run("Cached", func(b *testing.B) {
		f := &core.File{NLP: nlp.Info{Segmentation: true}}
		if _, err := f.Sentences(text); err != nil {
			b.Fatalf("priming cache: %v", err)
		}

		b.ReportAllocs()
		for i := 0; i < b.N; i++ {
			if _, err := f.Sentences(text); err != nil {
				b.Fatalf("segmenting: %v", err)
			}
		}
	})
}

// BenchmarkSequenceMaxMinCacheSharing tests the "Full performance reasoning"
// section's claim about a style's `sequence` rules as a whole: the new
// per-sentence segmentation pass is cached per file, so only the first rule
// to touch a sentence pays for it, and every other rule sharing that file's
// cache gets a hit.
//
// ColdEachRun builds a fresh File -- so an empty TokenCache -- for every
// timed call, meaning the one `max`/`min` rule it runs always pays full
// segmentation cost. This is the "one rule against a cold cache" case.
//
// SharedAcrossRules runs five `max`/`min` threshold rules, one after another,
// against the same paragraph block of one shared File, so only the first of
// the five segments the paragraph; the other four hit the cache. Its result
// is reported per-rule (total time divided by the number of rules run per
// iteration) via a custom "ns/rule" metric, so it is directly comparable to
// ColdEachRun's ns/op.
func BenchmarkSequenceMaxMinCacheSharing(b *testing.B) {
	newThresholdRule := func(name string) Sequence {
		rule, err := NewSequence(testConfig(), baseCheck{
			"extends":    "sequence",
			"name":       name,
			"level":      "error",
			"ignorecase": true,
			"message":    "Too many matches (found %d).",
			"scope":      []string{"paragraph"},
			"max":        2,
			"tokens": []interface{}{
				map[string]interface{}{"pattern": "widget"},
				map[string]interface{}{"pattern": "arrived", "skip": 1},
			},
		}, name)
		if err != nil {
			b.Fatalf("building rule %s: %v", name, err)
		}
		return rule
	}

	text := "I bought a widget that arrived promptly, said the courier. " +
		"A second widget arrived Thursday, and a third widget arrived Friday. " +
		"The invoice listed three line items and a discount code."
	blk := nlp.NewLinedBlock("", text, "paragraph.text.md", 1)

	b.Run("ColdEachRun", func(b *testing.B) {
		rule := newThresholdRule("Bench.ColdEachRun")

		b.ReportAllocs()
		for i := 0; i < b.N; i++ {
			f := &core.File{NLP: nlp.Info{Segmentation: true}}
			if _, err := rule.Run(blk, f, testConfig()); err != nil {
				b.Fatalf("running rule: %v", err)
			}
		}
		// One rule per timed call, so ns/op and ns/rule are the same number --
		// reported under both names so this is directly comparable to
		// SharedAcrossRules' own "ns/rule" metric (e.g. with benchstat).
		b.ReportMetric(float64(b.Elapsed().Nanoseconds())/float64(b.N), "ns/rule")
	})

	b.Run("SharedAcrossRules", func(b *testing.B) {
		const ruleCount = 5

		rules := make([]Sequence, ruleCount)
		for i := range rules {
			rules[i] = newThresholdRule(fmt.Sprintf("Bench.Shared%d", i))
		}

		b.ReportAllocs()
		for i := 0; i < b.N; i++ {
			f := &core.File{NLP: nlp.Info{Segmentation: true}}
			for _, rule := range rules {
				if _, err := rule.Run(blk, f, testConfig()); err != nil {
					b.Fatalf("running rule: %v", err)
				}
			}
		}
		b.ReportMetric(float64(b.Elapsed().Nanoseconds())/float64(b.N)/float64(ruleCount), "ns/rule")
	})
}

// BenchmarkSequencePlainRuleSentencesOverhead isolates the marginal cost this
// PR's "Full performance reasoning" section describes for a plain
// (sentence-scoped) rule -- the case that dominates a real style, where `max`
// and `min` are the exception rather than the rule.
//
// A plain rule's own scope is always narrowed to `sentence` (sentenceScope),
// so blk.Text below is already exactly one sentence -- the same as it was
// before this PR. What changed is that Run now reaches that one sentence by
// calling f.Sentences(blk.Text) and walking whatever it returns (see Run),
// where it used to tag blk.Text directly with no segmentation step at all.
//
// NoSentencesCall calls matchesIn directly against a synthetic
// segment.Sentence built from blk.Text, bypassing f.Sentences entirely --
// the tagging and candidate-walking work this rule did before this PR,
// since a plain rule's block was already one sentence beforehand too. This
// is the "old" baseline.
//
// ColdEachRun calls Run itself (through f.Sentences, cold every iteration),
// and SharedAcrossRules runs several plain rules against one shared File so
// only the first pays that cold cost. Comparing either against
// NoSentencesCall's baseline is what quantifies "a few percent slower" for
// one rule and "within noise" for several sharing a cache.
func BenchmarkSequencePlainRuleSentencesOverhead(b *testing.B) {
	newPlainRule := func(name string) Sequence {
		rule, err := NewSequence(testConfig(), baseCheck{
			"extends":    "sequence",
			"name":       name,
			"level":      "error",
			"ignorecase": true,
			"message":    "matched",
			"tokens": []interface{}{
				map[string]interface{}{"pattern": "widget"},
				map[string]interface{}{"pattern": "arrived", "skip": 1},
			},
		}, name)
		if err != nil {
			b.Fatalf("building rule %s: %v", name, err)
		}
		return rule
	}

	text := "I bought a widget that arrived promptly, said the courier."
	blk := nlp.NewLinedBlock("", text, "sentence.text.md", 1)

	b.Run("NoSentencesCall", func(b *testing.B) {
		rule := newPlainRule("Bench.NoSentencesCall")
		idx, tok, ok := rule.anchor()
		if !ok {
			b.Fatalf("rule has no anchor")
		}
		sent := segment.Sentence{Text: blk.Text, Start: 0}

		b.ReportAllocs()
		for i := 0; i < b.N; i++ {
			f := &core.File{NLP: nlp.Info{Segmentation: true}}
			if _, err := rule.matchesIn(sent, blk, f, idx, tok, true, testConfig()); err != nil {
				b.Fatalf("matching: %v", err)
			}
		}
	})

	b.Run("ColdEachRun", func(b *testing.B) {
		rule := newPlainRule("Bench.ColdEachRun")

		b.ReportAllocs()
		for i := 0; i < b.N; i++ {
			f := &core.File{NLP: nlp.Info{Segmentation: true}}
			if _, err := rule.Run(blk, f, testConfig()); err != nil {
				b.Fatalf("running rule: %v", err)
			}
		}
	})

	b.Run("SharedAcrossRules", func(b *testing.B) {
		const ruleCount = 5

		rules := make([]Sequence, ruleCount)
		for i := range rules {
			rules[i] = newPlainRule(fmt.Sprintf("Bench.PlainShared%d", i))
		}

		b.ReportAllocs()
		for i := 0; i < b.N; i++ {
			f := &core.File{NLP: nlp.Info{Segmentation: true}}
			for _, rule := range rules {
				if _, err := rule.Run(blk, f, testConfig()); err != nil {
					b.Fatalf("running rule: %v", err)
				}
			}
		}
		b.ReportMetric(float64(b.Elapsed().Nanoseconds())/float64(b.N)/float64(ruleCount), "ns/rule")
	})

	// The same five rules and shared File as SharedAcrossRules, but each rule
	// calls matchesIn directly instead of Run, bypassing f.Sentences the same
	// way NoSentencesCall does above.
	//
	// Five rules against one shared File already amortize their *tagging*
	// cache hits regardless of this PR -- TokenCache.Tokens predates it and is
	// keyed by text, not by which rule asks -- so comparing SharedAcrossRules
	// directly against NoSentencesCall's single-rule baseline would also be
	// measuring that pre-existing amortization, not this PR's new sentence
	// cache. Comparing SharedAcrossRules against this control instead holds
	// the tagging amortization constant across both and isolates exactly the
	// per-rule cost the new f.Sentences cache hit adds on top of it.
	b.Run("SharedAcrossRulesNoSentencesCall", func(b *testing.B) {
		const ruleCount = 5

		rules := make([]Sequence, ruleCount)
		anchors := make([]int, ruleCount)
		tokens := make([]NLPToken, ruleCount)
		for i := range rules {
			rules[i] = newPlainRule(fmt.Sprintf("Bench.PlainSharedNoSeg%d", i))
			idx, tok, ok := rules[i].anchor()
			if !ok {
				b.Fatalf("rule has no anchor")
			}
			anchors[i], tokens[i] = idx, tok
		}
		sent := segment.Sentence{Text: blk.Text, Start: 0}

		b.ReportAllocs()
		for i := 0; i < b.N; i++ {
			f := &core.File{NLP: nlp.Info{Segmentation: true}}
			for j, rule := range rules {
				if _, err := rule.matchesIn(sent, blk, f, anchors[j], tokens[j], true, testConfig()); err != nil {
					b.Fatalf("matching: %v", err)
				}
			}
		}
		b.ReportMetric(float64(b.Elapsed().Nanoseconds())/float64(b.N)/float64(ruleCount), "ns/rule")
	})
}
