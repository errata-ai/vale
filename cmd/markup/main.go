package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/yuin/goldmark"
	"github.com/yuin/goldmark/extension"
)

// Markdown configuration.
var goldMd = goldmark.New(
	goldmark.WithExtensions(
		extension.GFM,
	),
)

func main() {
	var buf bytes.Buffer

	if source, err := ioutil.ReadFile(os.Args[1]); err == nil {
		if err = goldMd.Convert(source, &buf); err != nil {
			panic(err)
		}
	} else {
		panic(err)
	}

	fmt.Println(buf.String())
}
