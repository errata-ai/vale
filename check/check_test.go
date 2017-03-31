package check

import (
	"path/filepath"
	"testing"
)

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

func benchmarkExternal(path string, b *testing.B) {
	path, err := filepath.Abs(path)
	if err != nil {
		panic(err)
	}
	for n := 0; n < b.N; n++ {
		loadExternalStyle(path)
	}
}
