package lint

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/vale-cli/vale/v3/internal/core"
)

// countAlerts returns how many of files' alerts match check.
func countAlerts(files []*core.File, check string) int {
	n := 0
	for _, f := range files {
		for _, a := range f.Alerts {
			if a.Check == check {
				n++
			}
		}
	}
	return n
}

// writeCollisionSourceStyles writes two styles whose check names would have
// collided under the old identifier-flattening design -- style "Foo-Bar"
// rule "Baz" (check "Foo-Bar.Baz") and style "Foo" rule "Bar-Baz" (check
// "Foo.Bar-Baz"), both of which used to sanitize to the same identifier,
// check_Foo_Bar_Baz -- into stylesDir. Shared with
// TestCheckObjectResolvesFormerlyCollidingCheckNamesIndependently in
// check_object_test.go (same package), which exercises the real check[...]
// indexing path against this exact pair to confirm the redesign resolves
// their counts independently now that there's no flattening step to collide
// on.
func writeCollisionSourceStyles(t *testing.T, stylesDir string) {
	t.Helper()

	fooBarDir := filepath.Join(stylesDir, "Foo-Bar")
	fooDir := filepath.Join(stylesDir, "Foo")
	if err := os.MkdirAll(fooBarDir, 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.MkdirAll(fooDir, 0o755); err != nil {
		t.Fatal(err)
	}

	if err := os.WriteFile(filepath.Join(fooBarDir, "Baz.yml"), []byte(
		"extends: existence\n"+
			"message: \"baz: '%s'\"\n"+
			"level: warning\n"+
			"scope: paragraph\n"+
			"tokens:\n"+
			"  - collidesA\n"), 0o600); err != nil {
		t.Fatal(err)
	}

	if err := os.WriteFile(filepath.Join(fooDir, "Bar-Baz.yml"), []byte(
		"extends: existence\n"+
			"message: \"barbaz: '%s'\"\n"+
			"level: warning\n"+
			"scope: paragraph\n"+
			"tokens:\n"+
			"  - collidesB\n"), 0o600); err != nil {
		t.Fatal(err)
	}
}

// TestMetricFormulaSkipsWordlessDocumentWithoutError is the exact scenario
// that broke Vale's own shipped Readability style after the round-4 fix (in
// the now-deleted collision-detection machinery): a heading-and-code-fence-
// only document -- no prose "words" at all -- linted with a real,
// division-based readability formula (the shape of the bundled
// AutomatedReadability/LIX styles, referencing "characters", "words", and
// "sentences").
//
// The built-in readability values themselves mean nothing without real
// prose and stay absent from ComputeMetrics's params for such a document;
// evaluating the formula anyway would fail with a Tengo "unresolved
// reference" compile error instead of the graceful skip this rule has
// always had for such a document.
//
// This must lint clean, with the readability rule skipped (no alert, no
// error) -- exactly matching testdata/fixtures/styles/Readability/test2.md,
// the actual shipped fixture this regression was caught against in
// internal/e2e's TestScenarios/styles/readability.
func TestMetricFormulaSkipsWordlessDocumentWithoutError(t *testing.T) {
	dir := t.TempDir()
	styleDir := filepath.Join(dir, "styles", "Readability")
	if err := os.MkdirAll(styleDir, 0o755); err != nil {
		t.Fatal(err)
	}

	// The same shape as testdata/styles/Readability/AutomatedReadability.yml:
	// a division-based formula that would hit "unresolved reference" for any
	// operand ComputeMetrics leaves out of params.
	automatedReadability := "extends: metric\n" +
		"message: \"Try to keep the Automated Readability Index (%s) below 8.\"\n" +
		"formula: |\n" +
		"  (4.71 * (characters / words)) + (0.5 * (words / sentences)) - 21.43\n" +
		"condition: \"> 8\"\n"
	if err := os.WriteFile(filepath.Join(styleDir, "AutomatedReadability.yml"), []byte(automatedReadability), 0o600); err != nil {
		t.Fatal(err)
	}

	cfg, err := core.NewConfig(&core.CLIFlags{IgnoreGlobal: true})
	if err != nil {
		t.Fatal(err)
	}

	cfg.AddStylesPath(filepath.Join(dir, "styles"))
	cfg.Styles = []string{"Readability"}
	cfg.GBaseStyles = []string{"Readability"}
	cfg.MinAlertLevel = 0
	cfg.Flags.InExt = ".md"

	linter, err := NewLinter(cfg)
	if err != nil {
		t.Fatal(err)
	}

	// Heading + code fence only, no prose -- the exact shape of
	// testdata/fixtures/styles/Readability/test2.md.
	files, lintErr := linter.LintString("# A section with only code\n\n``` shell\nls\n```\n")
	if lintErr != nil {
		t.Fatalf("LintString returned an unexpected error: %v -- a wordless "+
			"document should skip a readability formula cleanly, not fail "+
			"it with an unresolved-reference compile error", lintErr)
	}

	if got := countAlerts(files, "Readability.AutomatedReadability"); got != 0 {
		t.Errorf("Readability.AutomatedReadability fired %d times, want 0 -- "+
			"it should be skipped entirely for a wordless document", got)
	}
}

// TestMetricParagraphScopeSeesPartialCheckCountNotFinalTotal pins the "so
// far" behavior described in measuredScope's doc comment and in the comment
// right above `parameters["check"] = newCheckCounts(...)` in metric.go: a
// `metric` rule that declares a scope narrower than the default `summary` --
// here, `scope: paragraph` -- runs once per paragraph, in document order, and
// each run sees only the check counts recorded up to that point in the walk,
// not the document's eventual final total. A `summary`-scoped rule (the
// default, exercised elsewhere in this file) runs last and would see the
// final total instead.
//
// Empirically confirmed by running this test against the unmodified code
// before picking the expected values below, per the task's instruction not
// to assume the exact dispatch order:
//
//   - Rules that apply to the same block run in ascending alphabetical order
//     of their full check name (internal/lint/lint.go's inScopeFor sorts
//     scopedRule by name), and every paragraph block here is far under
//     parallelFloor, so it takes the serial path (lintBlockSerial): each
//     rule's Run is called and its alerts are added -- incrementing
//     f.CheckCounts -- one rule fully before the next rule for that same
//     block even runs.
//   - "Style.TheExistenceRule" sorts before "Style.TheMetricRule", so on any
//     paragraph where the existence rule fires, its own alert for THAT
//     paragraph is already counted by the time the metric rule evaluates the
//     very same paragraph. This was the ambiguous case the task called out:
//     confirmed empirically to be "already counted", not "not yet counted".
//     That is why paragraph 1 below reads 1, not 0.
//
// The formula's condition (">= 0") is deliberately always true -- a count is
// never negative -- so the metric rule fires on every paragraph, giving one
// alert per paragraph whose message bakes in the exact check[...] value that
// paragraph saw. The three paragraphs fire the existence rule in the 1st and
// 3rd, but not the 2nd, giving three distinct sample points:
//
//   - Paragraph 1: the existence rule fires here -> count so far = 1.
//   - Paragraph 2: no new alert -> the same count carries forward = 1.
//   - Paragraph 3: the existence rule fires again -> count so far = 2.
//
// Paragraphs 1 and 2 both read 1, which is NOT the document's final total of
// 2 (asserted separately below): a summary-scoped rule would have read 2
// everywhere, which is exactly the "partial, not final" distinction this
// test exists to pin.
func TestMetricParagraphScopeSeesPartialCheckCountNotFinalTotal(t *testing.T) {
	dir := t.TempDir()
	styleDir := filepath.Join(dir, "styles", "Style")
	if err := os.MkdirAll(styleDir, 0o755); err != nil {
		t.Fatal(err)
	}

	if err := os.WriteFile(filepath.Join(styleDir, "TheExistenceRule.yml"), []byte(
		"extends: existence\n"+
			"message: \"found: '%s'\"\n"+
			"level: warning\n"+
			"scope: paragraph\n"+
			"tokens:\n"+
			"  - trigger\n"), 0o600); err != nil {
		t.Fatal(err)
	}

	if err := os.WriteFile(filepath.Join(styleDir, "TheMetricRule.yml"), []byte(
		"extends: metric\n"+
			"message: \"count so far: %s\"\n"+
			"scope: paragraph\n"+
			"formula: check[\"Style.TheExistenceRule\"]\n"+
			"condition: \">= 0\"\n"), 0o600); err != nil {
		t.Fatal(err)
	}

	cfg, err := core.NewConfig(&core.CLIFlags{IgnoreGlobal: true})
	if err != nil {
		t.Fatal(err)
	}

	cfg.AddStylesPath(filepath.Join(dir, "styles"))
	cfg.Styles = []string{"Style"}
	cfg.GBaseStyles = []string{"Style"}
	cfg.MinAlertLevel = 0
	cfg.Flags.InExt = ".md"

	linter, err := NewLinter(cfg)
	if err != nil {
		t.Fatal(err)
	}

	doc := "First paragraph with a trigger word.\n\n" +
		"Second paragraph without it.\n\n" +
		"Third paragraph has trigger again.\n"

	files, lintErr := linter.LintString(doc)
	if lintErr != nil {
		t.Fatalf("LintString returned an unexpected error: %v", lintErr)
	}

	if got := countAlerts(files, "Style.TheExistenceRule"); got != 2 {
		t.Fatalf("Style.TheExistenceRule fired %d times, want 2 (paragraphs 1 and 3)", got)
	}

	var metricMessages []string
	for _, f := range files {
		for _, a := range f.Alerts {
			if a.Check == "Style.TheMetricRule" {
				metricMessages = append(metricMessages, a.Message)
			}
		}
	}

	want := []string{
		"count so far: 1.00",
		"count so far: 1.00",
		"count so far: 2.00",
	}
	if len(metricMessages) != len(want) {
		t.Fatalf("Style.TheMetricRule fired %d times, want %d: got %v",
			len(metricMessages), len(want), metricMessages)
	}
	for i, msg := range metricMessages {
		if msg != want[i] {
			t.Errorf("paragraph %d: metric rule read %q, want %q -- a "+
				"paragraph-scoped metric rule must see only the check count "+
				"recorded so far at its position in the document, not the "+
				"final whole-document total (2)", i+1, msg, want[i])
		}
	}
}
