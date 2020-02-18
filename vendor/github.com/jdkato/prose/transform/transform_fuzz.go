// +build gofuzz

package transform

func Fuzz(data []byte) int {
	s := string(data)

	// Case transformations
	Simple(s)
	Snake(s)
	Dash(s)
	Dot(s)
	Constant(s)
	Pascal(s)
	Camel(s)

	// Title converters
	tc := NewTitleConverter(APStyle)
	tc.Title(s)

	return 0
}
