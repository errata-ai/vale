package lint

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/vale-cli/vale/v3/internal/core"
)

// syntheticAITellsRuleCount matches the PR's own motivating case for
// exposing per-check alert counts to `metric` formulas: a style package like
// `tbhb/vale-ai-tells`, which ships about 110 independent pattern rules,
// each an isolated per-instance match.
const syntheticAITellsRuleCount = 110

// buildSyntheticAITellsStyle writes count independent `existence` rules into
// a new "AITells" style directory under dir, one per file, each matching a
// token no other rule -- and no word in aiTellsDocument -- matches. This is
// the shape LoadedChecks construction is benchmarked against below: a style
// with many independent rules, rather than a handful of rules extending each
// other or overlapping in what they match.
func buildSyntheticAITellsStyle(tb testing.TB, dir string, count int) {
	tb.Helper()

	styleDir := filepath.Join(dir, "AITells")
	if err := os.MkdirAll(styleDir, 0o755); err != nil {
		tb.Fatal(err)
	}

	for i := 0; i < count; i++ {
		rule := fmt.Sprintf(
			"extends: existence\n"+
				"message: \"Avoid the tell-word 'aitellword%d'.\"\n"+
				"level: warning\n"+
				"scope: sentence\n"+
				"ignorecase: true\n"+
				"tokens:\n"+
				"  - aitellword%d\n", i, i)

		path := filepath.Join(styleDir, fmt.Sprintf("Rule%03d.yml", i))
		if err := os.WriteFile(path, []byte(rule), 0o600); err != nil {
			tb.Fatal(err)
		}
	}
}

// aiTellsDocument builds realistic prose at least size bytes long, none of
// which contains any of the synthetic style's tell-words. The point of both
// benchmarks below is the cost of loading and running 110 independent rules
// against an ordinary document, not the cost of reporting alerts.
func aiTellsDocument(size int) string {
	var b strings.Builder
	for i := 0; b.Len() < size; i++ {
		fmt.Fprintf(&b, "Paragraph %d walks through the change in plain "+
			"terms, noting what moved and why the team made the call it "+
			"did.\n\n", i)
		fmt.Fprintf(&b, "The rollout went smoothly, and the team is now "+
			"watching the dashboards for anything unexpected over the next "+
			"few days.\n\n")
	}
	return b.String()
}

// syntheticAITellsLinter returns a Linter loaded with exactly the synthetic
// AITells style built by buildSyntheticAITellsStyle -- no built-in Vale
// style alongside it, so l.Manager.Rules() is exactly the synthetic rule
// set -- plus the path to a realistic ~5KB document linted against it,
// matching the PR's own "synthetic 110-rule style ... realistic ~5KB
// document" benchmark description.
func syntheticAITellsLinter(tb testing.TB, count int) (*Linter, string) {
	tb.Helper()

	dir := tb.TempDir()
	buildSyntheticAITellsStyle(tb, dir, count)

	cfg, err := core.NewConfig(&core.CLIFlags{IgnoreGlobal: true})
	if err != nil {
		tb.Fatal(err)
	}

	cfg.AddStylesPath(dir)
	cfg.Styles = []string{"AITells"}
	cfg.GBaseStyles = []string{"AITells"}
	cfg.MinAlertLevel = 0
	cfg.Flags.InExt = ".md"

	linter, err := NewLinter(cfg)
	if err != nil {
		tb.Fatal(err)
	}

	docPath := filepath.Join(dir, "bench.md")
	if writeErr := os.WriteFile(docPath, []byte(aiTellsDocument(5*1024)), 0o600); writeErr != nil {
		tb.Fatal(writeErr)
	}

	return linter, docPath
}

// BenchmarkLoadedChecksConstruction measures the cost of the per-file
// LoadedChecks build in lintFile (see lint.go): a loop over every loaded
// check name, calling checkApplies, which does a couple of map lookups and
// one short scan over f.BaseStyles per check.
//
// It replicates that exact loop rather than calling lintFile itself, so it
// isolates LoadedChecks construction from parsing, NLP assignment, and the
// walk over blocks that a full lint pass also does. See
// BenchmarkLintSyntheticAITells for that full pass, under the same
// synthetic style and document, for direct comparison.
func BenchmarkLoadedChecksConstruction(b *testing.B) {
	linter, docPath := syntheticAITellsLinter(b, syntheticAITellsRuleCount)

	file, err := core.NewFile(docPath, linter.Manager.Config)
	if err != nil {
		b.Fatal(err)
	}

	b.ReportAllocs()
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		file.LoadedChecks = make(map[string]bool, len(linter.Manager.Rules()))
		for name := range linter.Manager.Rules() {
			if linter.checkApplies(name, file) {
				file.LoadedChecks[name] = true
			}
		}
	}
}

// BenchmarkLintSyntheticAITells lints the same synthetic 110-rule style and
// ~5KB document as BenchmarkLoadedChecksConstruction, but the full lint
// pass, so the two numbers are directly comparable: LoadedChecks
// construction against the total cost it is one part of.
func BenchmarkLintSyntheticAITells(b *testing.B) {
	linter, docPath := syntheticAITellsLinter(b, syntheticAITellsRuleCount)

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		if _, err := linter.Lint([]string{docPath}, "*"); err != nil {
			b.Fatal(err)
		}
	}
}
