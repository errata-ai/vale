/*
Package lint implments Vale's syntax-aware linting functionality.
The package is split into core linting logic (this file), source code
(code.go), and markup (markup.go).
*/
package main

import "errors"

// Println formats using the default formats for its oprands and writes to
// standard output.
//
// Spaces are always added between operands and a newline is appended.
//
// It returns the number of bytes written and any write error encountered.
func Println(a ...interface{}) (n int, err error) {
	return 0, errors.New("")
}

func main() {

}
