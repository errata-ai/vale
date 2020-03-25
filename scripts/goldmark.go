package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/yuin/goldmark"
)

func main() {
	var buf bytes.Buffer

	if source, err := ioutil.ReadFile(os.Args[1]); err == nil {
		if err = goldmark.Convert(source, &buf); err != nil {
			panic(err)
		}
	} else {
		panic(err)
	}

	fmt.Println(buf.String())
}
