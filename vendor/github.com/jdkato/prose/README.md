# Prose

An English-language Part-of-Speech Tagger:

```go
import (
    "fmt"

    "github.com/jdkato/prose"
)

func main() {
    text := "A fast and accurate part-of-speech tagger for Golang."
    for _, tok := range prose.TagText(text) {
        fmt.Println(tok.Text, tok.Tag)
    }
}
```

## Install

```
go get github.com/jdkato/prose
```

## Performance

| Library | Accuracy | Time (sec) |
|:--------|---------:|-----------:|
| NLTK    |    0.893 |      7.773 |
| prose   |    0.961 |      3.083 |

(see [`scripts/test_model.py`](https://github.com/jdkato/aptag/blob/master/scripts/test_model.py).)
