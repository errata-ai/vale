# glob.go

[![](https://godoc.org/github.com/gobwas/glob?status.svg)](https://godoc.org/github.com/gobwas/glob) [![](https://travis-ci.org/gobwas/glob.svg?branch=master)](https://travis-ci.org/gobwas/glob)

> Go Globbing Library.

## Install

```text
    go get github.com/gobwas/glob
```

## Example

```go
package main

import "github.com/gobwas/glob"

func main() {
    var g glob.Glob

    // create simple glob
    g = glob.MustCompile("*.github.com")
    g.Match("api.github.com") // true

    // quote meta characters and then create simple glob 
    g = glob.MustCompile(glob.QuoteMeta("*.github.com"))
    g.Match("*.github.com") // true

    // create new glob with set of delimiters as ["."]
    g = glob.MustCompile("api.*.com", '.')
    g.Match("api.github.com") // true
    g.Match("api.gi.hub.com") // false

    // create new glob with set of delimiters as ["."]
    // but now with super wildcard
    g = glob.MustCompile("api.**.com", '.')
    g.Match("api.github.com") // true
    g.Match("api.gi.hub.com") // true

    // create glob with single symbol wildcard
    g = glob.MustCompile("?at")
    g.Match("cat") // true
    g.Match("fat") // true
    g.Match("at") // false

    // create glob with single symbol wildcard and delimiters ['f']
    g = glob.MustCompile("?at", 'f')
    g.Match("cat") // true
    g.Match("fat") // false
    g.Match("at") // false 

    // create glob with character-list matchers 
    g = glob.MustCompile("[abc]at")
    g.Match("cat") // true
    g.Match("bat") // true
    g.Match("fat") // false
    g.Match("at") // false

    // create glob with character-list matchers 
    g = glob.MustCompile("[!abc]at")
    g.Match("cat") // false
    g.Match("bat") // false
    g.Match("fat") // true
    g.Match("at") // false 

    // create glob with character-range matchers 
    g = glob.MustCompile("[a-c]at")
    g.Match("cat") // true
    g.Match("bat") // true
    g.Match("fat") // false
    g.Match("at") // false

    // create glob with character-range matchers 
    g = glob.MustCompile("[!a-c]at")
    g.Match("cat") // false
    g.Match("bat") // false
    g.Match("fat") // true
    g.Match("at") // false 

    // create glob with pattern-alternatives list 
    g = glob.MustCompile("{cat,bat,[fr]at}")
    g.Match("cat") // true
    g.Match("bat") // true
    g.Match("fat") // true
    g.Match("rat") // true
    g.Match("at") // false 
    g.Match("zat") // false 
}
```

## Performance

This library is created for compile-once patterns. This means, that compilation could take time, but strings matching is done faster, than in case when always parsing template.

If you will not use compiled `glob.Glob` object, and do `g := glob.MustCompile(pattern); g.Match(...)` every time, then your code will be much more slower.

Run `go test -bench=.` from source root to see the benchmarks:

| Pattern | Fixture | Match | Speed \(ns/op\) |
| :--- | :--- | :--- | :--- |
| `[a-z][!a-x]*cat*[h][!b]*eyes*` | `my cat has very bright eyes` | `true` | 432 |
| `[a-z][!a-x]*cat*[h][!b]*eyes*` | `my dog has very bright eyes` | `false` | 199 |
| `https://*.google.*` | `https://account.google.com` | `true` | 96 |
| `https://*.google.*` | `https://google.com` | `false` | 66 |
| `{https://*.google.*,*yandex.*,*yahoo.*,*mail.ru}` | `http://yahoo.com` | `true` | 163 |
| `{https://*.google.*,*yandex.*,*yahoo.*,*mail.ru}` | `http://google.com` | `false` | 197 |
| `{https://*gobwas.com,http://exclude.gobwas.com}` | `https://safe.gobwas.com` | `true` | 22 |
| `{https://*gobwas.com,http://exclude.gobwas.com}` | `http://safe.gobwas.com` | `false` | 24 |
| `abc*` | `abcdef` | `true` | 8.15 |
| `abc*` | `af` | `false` | 5.68 |
| `*def` | `abcdef` | `true` | 8.84 |
| `*def` | `af` | `false` | 5.74 |
| `ab*ef` | `abcdef` | `true` | 15.2 |
| `ab*ef` | `af` | `false` | 10.4 |

The same things with `regexp` package:

| Pattern | Fixture | Match | Speed \(ns/op\) |  |  |  |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `^[a-z][^a-x].*cat.*[h][^b].*eyes.*$` | `my cat has very bright eyes` | `true` | 2553 |  |  |  |
| `^[a-z][^a-x].*cat.*[h][^b].*eyes.*$` | `my dog has very bright eyes` | `false` | 1383 |  |  |  |
| `^https:\/\/.*\.google\..*$` | `https://account.google.com` | `true` | 1205 |  |  |  |
| `^https:\/\/.*\.google\..*$` | `https://google.com` | `false` | 767 |  |  |  |
| \`^\(https:\/\/._.google.._ | ._yandex.._ | ._yahoo.._ | .\*mail.ru\)$\` | `http://yahoo.com` | `true` | 1435 |
| \`^\(https:\/\/._.google.._ | ._yandex.._ | ._yahoo.._ | .\*mail.ru\)$\` | `http://google.com` | `false` | 1674 |
| \`^\(https:\/\/.\*gobwas.com | [http://exclude.gobwas.com\)$\`](http://exclude.gobwas.com%29$`) | `https://safe.gobwas.com` | `true` | 1039 |  |  |
| \`^\(https:\/\/.\*gobwas.com | [http://exclude.gobwas.com\)$\`](http://exclude.gobwas.com%29$`) | `http://safe.gobwas.com` | `false` | 272 |  |  |
| `^abc.*$` | `abcdef` | `true` | 237 |  |  |  |
| `^abc.*$` | `af` | `false` | 100 |  |  |  |
| `^.*def$` | `abcdef` | `true` | 464 |  |  |  |
| `^.*def$` | `af` | `false` | 265 |  |  |  |
| `^ab.*ef$` | `abcdef` | `true` | 375 |  |  |  |
| `^ab.*ef$` | `af` | `false` | 145 |  |  |  |

## Syntax

Syntax is inspired by [standard wildcards](http://tldp.org/LDP/GNU-Linux-Tools-Summary/html/x11655.htm), except that `**` is aka super-asterisk, that do not sensitive for separators.

