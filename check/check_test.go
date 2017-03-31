package check

import (
	"path/filepath"
	"testing"
)

var msgtests = []struct {
	in   string
	args []string
	out  string
}{
	{"Avoid using '%s'", []string{"foo", "bar"}, "Avoid using 'foo'"},
	{"Avoid using 'foo'", []string{"foo", "bar"}, "Avoid using 'foo'"},
	{"Use '%s', not '%s'", []string{"foo", "bar"}, "Use 'foo', not 'bar'"},
}

func TestFormatMessage(t *testing.T) {
	for _, tt := range msgtests {
		s, _ := formatMessages(tt.in, tt.in, tt.args...)
		if s != tt.out {
			t.Errorf("(%q, %v) => %q != %q", tt.in, tt.args, s, tt.out)
		}
	}
}

func BenchmarkVale(b *testing.B) {
	for n := 0; n < b.N; n++ {
		loadDefaultChecks()
	}
}

func BenchmarkWriteGood(b *testing.B) {
	benchmarkExternal("../styles/write-good", b)
}

func BenchmarkJobLint(b *testing.B) {
	benchmarkExternal("../styles/JobLint", b)
}

func BenchmarkTheEconomist(b *testing.B) {
	benchmarkExternal("../styles/TheEconomist", b)
}

func BenchmarkHomebrew(b *testing.B) {
	benchmarkExternal("../styles/Homebrew", b)
}

func BenchmarkMiddlebury(b *testing.B) {
	benchmarkExternal("../styles/Middlebury", b)
}

func benchmarkExternal(path string, b *testing.B) {
	path, err := filepath.Abs(path)
	if err != nil {
		panic(err)
	}
	for n := 0; n < b.N; n++ {
		loadExternalStyle(path)
	}
}
