package tests

type jarocase struct {
	s string
	t string
	r float64
}

type levenshteincase struct {
	s     string
	t     string
	icost int
	dcost int
	scost int
	r     int
}

type soundexcase struct {
	s string
	t string
}

type hammingcase struct {
	a    string
	b    string
	diff int
}
