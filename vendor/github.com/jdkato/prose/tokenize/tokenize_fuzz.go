// +build gofuzz

package tokenize

func Fuzz(data []byte) int {
	s := string(data)

	t1 := NewWordBoundaryTokenizer()
	t1.Tokenize(s)

	t2 := NewWordPunctTokenizer()
	t2.Tokenize(s)

	t3 := NewTreebankWordTokenizer()
	t3.Tokenize(s)

	t4 := NewBlanklineTokenizer()
	t4.Tokenize(s)

	return 0
}
