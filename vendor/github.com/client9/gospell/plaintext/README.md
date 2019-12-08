# plaintext
[![Build Status](https://travis-ci.org/client9/plaintext.svg?branch=master)](https://travis-ci.org/client9/plaintext) [![Go Report Card](http://goreportcard.com/badge/client9/plaintext)](http://goreportcard.com/report/client9/plaintext) [![GoDoc](https://godoc.org/github.com/client9/plaintext?status.svg)](https://godoc.org/github.com/client9/plaintext) [![Coverage](http://gocover.io/_badge/github.com/client9/plaintext)](http://gocover.io/github.com/client9/plaintext) [![license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://raw.githubusercontent.com/client9/plaintext/master/LICENSE)

Extract human languages in plain UTF-8 text from computer code and markup

The output is (or should be) *line-preserving*, meaning, no new lines are added or subtracted.

```html
<p>
foo
</p>
```

becomes

```html

foo

```

