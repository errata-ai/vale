# prose [![Travis CI](https://img.shields.io/travis/jdkato/prose.svg?style=flat-square)](https://travis-ci.org/jdkato/prose) [![AppVeyor branch](https://img.shields.io/appveyor/ci/jdkato/prose/master.svg?style=flat-square)](https://ci.appveyor.com/project/jdkato/prose/branch/master) [![GoDoc](https://img.shields.io/badge/godoc-reference-5272B4.svg?style=flat-square)](https://godoc.org/github.com/jdkato/prose) [![Coveralls branch](https://img.shields.io/coveralls/jdkato/prose/master.svg?style=flat-square)](https://coveralls.io/github/jdkato/prose?branch=master) [![Go Report Card](https://goreportcard.com/badge/github.com/jdkato/prose?style=flat-square)](https://goreportcard.com/report/github.com/jdkato/prose) [![awesome](https://img.shields.io/badge/awesome-%E2%9C%93-ff69b4.svg?style=flat-square)](https://github.com/avelino/awesome-go#natural-language-processing)

`prose` is Go library for text (primarily English at the moment) processing that supports tokenization, part-of-speech tagging, named-entity extraction, and more. The library's functionality is split into subpackages designed for modular use. See the [documentation](https://godoc.org/github.com/jdkato/prose) for more information.

## Install

```console
$ go get github.com/jdkato/prose/...
```

## Usage

### Contents

* [Tokenizing](#tokenizing-godoc)
* [Tagging](#tagging-godoc)
* [Transforming](#transforming-godoc)
* [Summarizing](#summarizing-godoc)
* [Chunking](#chunking-godoc)
* [License](#license)


### Tokenizing ([GoDoc](https://godoc.org/github.com/jdkato/prose/tokenize))

Word, sentence, and regexp tokenizers are available. Every tokenizer implements the [same interface](https://godoc.org/github.com/jdkato/prose/tokenize#ProseTokenizer), which makes it easy to customize tokenization in other parts of the library.

```go
package main

import (
    "fmt"

    "github.com/jdkato/prose/tokenize"
)

func main() {
    text := "They'll save and invest more."
    tokenizer := tokenize.NewTreebankWordTokenizer()
    for _, word := range tokenizer.Tokenize(text) {
        // [They 'll save and invest more .]
        fmt.Println(word)
    }
}
```

### Tagging ([GoDoc](https://godoc.org/github.com/jdkato/prose/tag))

The `tag` package includes a port of Textblob's ["fast and accurate" POS tagger](https://github.com/sloria/textblob-aptagger). Below is a comparison of its performance against [NLTK](http://www.nltk.org/)'s implementation of the same tagger (see [`scripts/test_model.py`](https://github.com/jdkato/aptag/blob/master/scripts/test_model.py)):

| Library | Accuracy | 5-Run Average (sec) |
|:--------|---------:|--------------------:|
| NLTK    |    0.893 |               7.224 |
| `prose` |    0.961 |               2.538 |

```go
package main

import (
    "fmt"

    "github.com/jdkato/prose/tag"
    "github.com/jdkato/prose/tokenize"
)

func main() {
    text := "A fast and accurate part-of-speech tagger for Golang."
    words := tokenize.NewTreebankWordTokenizer().Tokenize(text)

    tagger := tag.NewPerceptronTagger()
    for _, tok := range tagger.Tag(words) {
        fmt.Println(tok.Text, tok.Tag)
    }
}
```

### Transforming ([GoDoc](https://godoc.org/github.com/jdkato/prose/transform))

The `tranform` package currently only has one function: converting strings to title case. Unlike `strings.Title`, `tranform` adheres to common guidelines&mdash;including styles for both the [AP Stylebook](https://www.apstylebook.com/) and [The Chicago Manual of Style](http://www.chicagomanualofstyle.org/home.html). Additionally, you can easily add your own custom style by defining an [`IgnoreFunc`](https://godoc.org/github.com/jdkato/prose/transform#IgnoreFunc) callback.

Inspiration and test data taken from [python-titlecase](https://github.com/ppannuto/python-titlecase) and [to-title-case](https://github.com/gouch/to-title-case).

```go
package main

import (
    "fmt"
    "strings"

    "github.com/jdkato/prose/transform"
)

func main() {
    text := "the last of the mohicans"
    tc := transform.NewTitleConverter(transform.APStyle)
    fmt.Println(strings.Title(text))   // The Last Of The Mohicans
    fmt.Println(tc.Title(text)) // The Last of the Mohicans
}
```

### Summarizing ([GoDoc](https://godoc.org/github.com/jdkato/prose/summarize))

The `summarize` package includes functions for computing standard readability and usage statistics. It's among the most accurate implementations available due to its reliance on legitimate tokenizers (whereas others, like [readability-score](https://github.com/DaveChild/Text-Statistics/blob/master/src/DaveChild/TextStatistics/Text.php#L308), rely on naive regular expressions).

```go
package main

import (
    "fmt"

    "github.com/jdkato/prose/summarize"
)

func main() {
    doc := summarize.NewDocument("This is some interesting text.")
    fmt.Println(doc.SMOG(), doc.FleschKincaid())
}
```

### Chunking ([GoDoc](https://godoc.org/github.com/jdkato/prose/chunk))

The `chunk` package implements named-entity extraction using a regular expression indicating what chunks you're looking for and pre-tagged input.

```go
package main

import (
    "fmt"

    "github.com/jdkato/prose/chunk"
    "github.com/jdkato/prose/tag"
    "github.com/jdkato/prose/tokenize"
)

func main() {
    words := tokenize.TextToWords("Go is a open source programming language created at Google.")
    regex := chunk.TreebankNamedEntities

    tagger := tag.NewPerceptronTagger()
    for _, entity := range chunk.Chunk(tagger.Tag(words), regex) {
        fmt.Println(entity) // [Go Google]
    }
}
```

## License

If not otherwise specified (see below), the source files are distributed under MIT License found in the [LICENSE](https://github.com/jdkato/prose/blob/master/LICENSE) file.

Additionally, the following files contain their own license information:

- [`tag/aptag.go`](https://github.com/jdkato/prose/blob/master/tag/aptag.go): MIT © Matthew Honnibal.
- [`tokenize/punkt.go`](https://github.com/jdkato/prose/blob/master/tokenize/punkt.go): MIT © Eric Bower.
- [`tokenize/pragmatic.go`](https://github.com/jdkato/prose/blob/master/tokenize/pragmatic.go): MIT © Kevin S. Dias.
