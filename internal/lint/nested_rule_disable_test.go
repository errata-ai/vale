package lint

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/vale-cli/vale/v3/internal/core"
	"github.com/vale-cli/vale/v3/internal/glob"
)

// TestNestedRuleDirectoryDisableRegression is a probe for the
// checkApplies/RuleForAlert reconciliation done while rebasing this branch
// onto the "nested rule directories" feature: a rule loaded from a nested
// style directory has a name with more than one dot (e.g.
// "Std.dates.TimeFormat"), same as a `consistency` check's per-term alert
// name. checkApplies must resolve such a name via l.Manager.RuleForAlert
// (which knows the real, loaded rule names), not by blindly truncating to
// the first two dot-separated segments -- that would turn
// "Std.dates.TimeFormat" into "Std.dates" before looking it up in
// cfg.SChecks, missing a real, exact-name extension override entirely and
// letting the rule run where it should have been disabled.
func TestNestedRuleDirectoryDisableRegression(t *testing.T) {
	dir := t.TempDir()
	styleDir := filepath.Join(dir, "styles", "Std", "dates")
	if err := os.MkdirAll(styleDir, 0o755); err != nil {
		t.Fatal(err)
	}

	if err := os.WriteFile(filepath.Join(styleDir, "TimeFormat.yml"), []byte(
		"extends: existence\n"+
			"message: \"found: '%s'\"\n"+
			"level: warning\n"+
			"scope: paragraph\n"+
			"tokens:\n"+
			"  - badtime\n"), 0o600); err != nil {
		t.Fatal(err)
	}

	cfg, err := core.NewConfig(&core.CLIFlags{IgnoreGlobal: true})
	if err != nil {
		t.Fatal(err)
	}

	cfg.AddStylesPath(filepath.Join(dir, "styles"))
	cfg.Styles = []string{"Std"}
	cfg.GBaseStyles = []string{"Std"}
	cfg.MinAlertLevel = 0
	cfg.Flags.InExt = ".txt"

	// Std.dates.TimeFormat = NO under [*.md]: the same effect a real
	// .vale.ini section has, applied directly to the config fields ini.go's
	// processConfig would otherwise populate from it.
	mdPat, err := glob.Compile("*.md")
	if err != nil {
		t.Fatal(err)
	}
	cfg.SecToPat["*.md"] = mdPat
	cfg.RuleKeys = append(cfg.RuleKeys, "*.md")
	cfg.SChecks["*.md"] = map[string]bool{"Std.dates.TimeFormat": false}

	linter, err := NewLinter(cfg)
	if err != nil {
		t.Fatal(err)
	}

	path := filepath.Join(dir, "doc.md")
	if err = os.WriteFile(path, []byte("A paragraph mentioning badtime here.\n"), 0o600); err != nil {
		t.Fatal(err)
	}

	files, lintErr := linter.Lint([]string{path}, "*")
	if lintErr != nil {
		t.Fatalf("Lint returned an unexpected error: %v", lintErr)
	}

	if got := countAlerts(files, "Std.dates.TimeFormat"); got != 0 {
		t.Errorf("Std.dates.TimeFormat fired %d times, want 0 -- it was "+
			"disabled for .md via a section override, and a nested-directory "+
			"rule name must not be truncated past what the override actually "+
			"named", got)
	}
}
