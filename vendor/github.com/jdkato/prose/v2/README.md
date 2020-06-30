# prose [![Build Status](https://travis-ci.org/jdkato/prose.svg?branch=master)](https://travis-ci.org/jdkato/prose) [![Build status](https://ci.appveyor.com/api/projects/status/24bepq85nnnk4scr?svg=true)](https://ci.appveyor.com/project/jdkato/prose) [![GoDoc](https://godoc.org/github.com/golang/gddo?status.svg)](https://godoc.org/gopkg.in/jdkato/prose.v2) [![Coverage Status](https://coveralls.io/repos/github/jdkato/prose/badge.svg?branch=v2)](https://coveralls.io/github/jdkato/prose?branch=v2) [![Go Report Card](https://goreportcard.com/badge/github.com/jdkato/prose)](https://goreportcard.com/report/github.com/jdkato/prose) [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/avelino/awesome-go#natural-language-processing)

`prose` is a natural language processing library (English only, at the moment) in *pure Go*. It supports tokenization, segmentation, part-of-speech tagging, and named-entity extraction.

You can can find a more detailed summary on the library's performance here: [Introducing `prose` v2.0.0: Bringing NLP *to Go*](https://medium.com/@errata.ai/introducing-prose-v2-0-0-bringing-nlp-to-go-a1f0c121e4a5).

## Installation

```console
$ go get gopkg.in/jdkato/prose.v2
```

## Usage

### Contents

* [Overview](#overview)
* [Tokenizing](#tokenizing)
* [Segmenting](#segmenting)
* [Tagging](#tagging)
* [NER](#ner)

### Overview


```go
package main

import (
    "fmt"
    "log"

    "gopkg.in/jdkato/prose.v2"
)

func main() {
    // Create a new document with the default configuration:
    doc, err := prose.NewDocument("Go is an open-source programming language created at Google.")
    if err != nil {
        log.Fatal(err)
    }

    // Iterate over the doc's tokens:
    for _, tok := range doc.Tokens() {
        fmt.Println(tok.Text, tok.Tag, tok.Label)
        // Go NNP B-GPE
        // is VBZ O
        // an DT O
        // ...
    }

    // Iterate over the doc's named-entities:
    for _, ent := range doc.Entities() {
        fmt.Println(ent.Text, ent.Label)
        // Go GPE
        // Google GPE
    }

    // Iterate over the doc's sentences:
    for _, sent := range doc.Sentences() {
        fmt.Println(sent.Text)
        // Go is an open-source programming language created at Google.
    }
}
```

The document-creation process adheres to the following sequence of steps:

```text
tokenization -> POS tagging -> NE extraction
            \
             segmenatation
```

Each step may be disabled (assuming later steps aren't required) by passing the appropriate [*functional option*](https://dave.cheney.net/2014/10/17/functional-options-for-friendly-apis). To disable named-entity extraction, for example, you'd do the following:

```go
doc, err := prose.NewDocument(
        "Go is an open-source programming language created at Google.",
        prose.WithExtraction(false))
```

### Tokenizing

`prose` includes a tokenizer capable of hanlding modern text, including the non-word character spans shown below.

| Type            | Example                           |
|-----------------|-----------------------------------|
| Email addresses | `Jane.Doe@example.com`            |
| Hashtags        | `#trending`                       |
| Mentions        | `@jdkato`                         |
| URLs            | `https://github.com/jdkato/prose` |
| Emoticons       | `:-)`, `>:(`, `o_0`, etc.         |


```go
package main

import (
    "fmt"
    "log"

    "gopkg.in/jdkato/prose.v2"
)

func main() {
    // Create a new document with the default configuration:
    doc, err := prose.NewDocument("@jdkato, go to http://example.com thanks :).")
    if err != nil {
        log.Fatal(err)
    }

    // Iterate over the doc's tokens:
    for _, tok := range doc.Tokens() {
        fmt.Println(tok.Text, tok.Tag)
        // @jdkato NN
        // , ,
        // go VB
        // to TO
        // http://example.com NN
        // thanks NNS
        // :) SYM
        // . .
    }
}
```

### Segmenting

`prose` includes one of the most accurate sentence segmenters available, according to the [Golden Rules](https://github.com/diasks2/pragmatic_segmenter#comparison-of-segmentation-tools-libraries-and-algorithms) created by the developers of the `pragmatic_segmenter`.

| Name                | Language | License   | GRS (English)  | GRS (Other) | Speed†   |
|---------------------|----------|-----------|----------------|-------------|----------|
| Pragmatic Segmenter | Ruby     | MIT       | 98.08% (51/52) | 100.00%     | 3.84 s   |
| prose               | Go       | MIT       | 75.00% (39/52) | N/A         | 0.96 s   |
| TactfulTokenizer    | Ruby     | GNU GPLv3 | 65.38% (34/52) | 48.57%      | 46.32 s  |
| OpenNLP             | Java     | APLv2     | 59.62% (31/52) | 45.71%      | 1.27 s   |
| Standford CoreNLP   | Java     | GNU GPLv3 | 59.62% (31/52) | 31.43%      | 0.92 s   |
| Splitta             | Python   | APLv2     | 55.77% (29/52) | 37.14%      | N/A      |
| Punkt               | Python   | APLv2     | 46.15% (24/52) | 48.57%      | 1.79 s   |
| SRX English         | Ruby     | GNU GPLv3 | 30.77% (16/52) | 28.57%      | 6.19 s   |
| Scapel              | Ruby     | GNU GPLv3 | 28.85% (15/52) | 20.00%      | 0.13 s   |

> † The original tests were performed using a *MacBook Pro 3.7 GHz Quad-Core Intel Xeon E5 running 10.9.5*, while `prose` was timed using a *MacBook Pro 2.9 GHz Intel Core i7 running 10.13.3*.

```go
package main

import (
    "fmt"
    "strings"

    "github.com/jdkato/prose"
)

func main() {
    // Create a new document with the default configuration:
    doc, _ := prose.NewDocument(strings.Join([]string{
        "I can see Mt. Fuji from here.",
        "St. Michael's Church is on 5th st. near the light."}, " "))

    // Iterate over the doc's sentences:
    sents := doc.Sentences()
    fmt.Println(len(sents)) // 2
    for _, sent := range sents {
        fmt.Println(sent.Text)
        // I can see Mt. Fuji from here.
        // St. Michael's Church is on 5th st. near the light.
    }
}
```

### Tagging

`prose` includes a tagger based on Textblob's ["fast and accurate" POS tagger](https://github.com/sloria/textblob-aptagger). Below is a comparison of its performance against [NLTK](http://www.nltk.org/)'s implementation of the same tagger on the Treebank corpus:

| Library | Accuracy | 5-Run Average (sec) |
|:--------|---------:|--------------------:|
| NLTK    |    0.893 |               7.224 |
| `prose` |    0.961 |               2.538 |

(See [`scripts/test_model.py`](https://github.com/jdkato/aptag/blob/master/scripts/test_model.py) for more information.)

The full list of supported POS tags is given below.

| TAG        | DESCRIPTION                               |
|------------|-------------------------------------------|
| `(`        | left round bracket                        |
| `)`        | right round bracket                       |
| `,`        | comma                                     |
| `:`        | colon                                     |
| `.`        | period                                    |
| `''`       | closing quotation mark                    |
| ``` `` ``` | opening quotation mark                    |
| `#`        | number sign                               |
| `$`        | currency                                  |
| `CC`       | conjunction, coordinating                 |
| `CD`       | cardinal number                           |
| `DT`       | determiner                                |
| `EX`       | existential there                         |
| `FW`       | foreign word                              |
| `IN`       | conjunction, subordinating or preposition |
| `JJ`       | adjective                                 |
| `JJR`      | adjective, comparative                    |
| `JJS`      | adjective, superlative                    |
| `LS`       | list item marker                          |
| `MD`       | verb, modal auxiliary                     |
| `NN`       | noun, singular or mass                    |
| `NNP`      | noun, proper singular                     |
| `NNPS`     | noun, proper plural                       |
| `NNS`      | noun, plural                              |
| `PDT`      | predeterminer                             |
| `POS`      | possessive ending                         |
| `PRP`      | pronoun, personal                         |
| `PRP$`     | pronoun, possessive                       |
| `RB`       | adverb                                    |
| `RBR`      | adverb, comparative                       |
| `RBS`      | adverb, superlative                       |
| `RP`       | adverb, particle                          |
| `SYM`      | symbol                                    |
| `TO`       | infinitival to                            |
| `UH`       | interjection                              |
| `VB`       | verb, base form                           |
| `VBD`      | verb, past tense                          |
| `VBG`      | verb, gerund or present participle        |
| `VBN`      | verb, past participle                     |
| `VBP`      | verb, non-3rd person singular present     |
| `VBZ`      | verb, 3rd person singular present         |
| `WDT`      | wh-determiner                             |
| `WP`       | wh-pronoun, personal                      |
| `WP$`      | wh-pronoun, possessive                    |
| `WRB`      | wh-adverb                                 |

### NER

`prose` v2.0.0 includes a much improved version of v1.0.0's chunk package, which can identify people (`PERSON`) and geographical/political Entities (`GPE`) by default.

```go
package main

import (
    "gopkg.in/jdkato/prose.v2"
)

func main() {
    doc, _ := prose.NewDocument("Lebron James plays basketbal in Los Angeles.")
    for _, ent := range doc.Entities() {
        fmt.Println(ent.Text, ent.Label)
        // Lebron James PERSON
        // Los Angeles GPE
    }
}
```

However, in an attempt to make this feature more useful, we've made it straightforward to train your own models for specific use cases. See [Prodigy + `prose`: Radically efficient machine teaching *in Go*](https://medium.com/@errata.ai/prodigy-prose-radically-efficient-machine-teaching-in-go-93389bf2d772) for a tutorial.
