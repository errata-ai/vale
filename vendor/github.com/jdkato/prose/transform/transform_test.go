package transform

import "fmt"

func ExampleNewTitleConverter() {
	tc := NewTitleConverter(APStyle)
	fmt.Println(tc.Title("the last of the mohicans"))
	// Output: The Last of the Mohicans
}
