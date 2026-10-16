package lint

import (
	"strings"
	"testing"

	"github.com/vale-cli/vale/v3/internal/system"
)

// The executable path loads the same converter the server does: a
// cross-reference without authored text renders as an empty link.
func TestAdocConverterFile(t *testing.T) {
	exe := system.Which([]string{"asciidoctor"})
	if exe == "" {
		t.Skip("asciidoctor not installed")
	}
	conv := adocConverterFile()
	if conv == "" {
		t.Fatal("no converter file was written")
	}

	args := append([]string{}, adocArgs...)
	args = append(args, "-r", conv, "--safe-mode", "secure", "-")
	html, err := system.ExecuteWithInput(exe,
		"= T\n\nSee <<zorbblat>> and xref:other.adoc#x[] and xref:x[kept].\n", args...)
	if err != nil {
		t.Fatal(err)
	}
	// The path stays in the href; it's the link text that must be gone.
	for _, generated := range []string{">[zorbblat]</a>", ">other.html</a>"} {
		if strings.Contains(html, generated) {
			t.Errorf("generated text %q survived:\n%s", generated, html)
		}
	}
	if !strings.Contains(html, ">kept</a>") {
		t.Errorf("authored text was dropped:\n%s", html)
	}
}
