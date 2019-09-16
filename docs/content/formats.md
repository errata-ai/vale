## Overview

Vale is "syntax aware," which means that it's capable of both applying
rules to and ignoring certain sections of text. This functionality is
implemented through a *scoping* system. A scope is specified through a *selector* such as `paragraph.rst`, which
indicates that the rule applies to all paragraphs in reStructuredText files.
Here are a few examples:

- `comment` matches all source code comments;
- `comment.line` matches all source code line comments;
- `heading.md` matches all Markdown headings; and
- `text.html` matches all HTML scopes.

The type of file you're working with determines what scopes are available. The supported types are `markup`, `code`, and `text`.

## Available Scopes

### `markup`

|      Scope     |                                                              Description                                                              |
|:--------------:|:-------------------------------------------------------------------------------------------------------------------------------------:|
| `heading`      | Matches all `<h{1,...}>` tags. You can specify an exact level by appending a tags&mdash;for example, `heading.h1` matches all `h1` tags. |
| `table.header` | Matches all `<th>` tags.                                                                                                                |
| `table.cell`   | Matches all `<td>` tags.                                                                                                                |
| `list`         | Matches all `<li>` tags.                                                                                                                |
| `paragraph`    | Matches all paragraphs (segments of text separated by two newlines).                                                                   |
| `sentence`     | Matches all sentences.                                                                                                                |
| `link`         | Matches all `<a>` tags.                                                                                                                 |
| `alt`          | Matches all `alt` attributes.                                                                                                         |
| `blockquote`   | Matches all `<blockquote>` tags.                                                                                                        |
| `summary`      | Matches all body text (excluding list items, headings, and table cells).                                                               |
| `code`         | Matches all `<code>` tags.                                                                                                            |
| `strong`       | Matches all `<strong>` and `<b>` tags.                                                                                                |
| `emphasis`     | Matches all `<em>` and `<i>` tags                                                                                                     |

### `code`

There are two `code` scopes: `comment.line` and `comment.block`.

### `text`

Any format not listed below is considered to be `text` and has no special scoping rules applied.

## Formats

### Markdown [`markup`]

Vale has built-in support for GitHub-Flavored Markdown. By default, it
ignores indented blocks, fenced blocks, and code spans.

### HTML [`markup`]

Vale has built-in support for HTML. By default, it ignores `script`,
`style`, `pre`, `code`, and `tt` tags.

### reStructuredText [`markup`]

Vale supports reStructuredText through the external program
[`rst2html`][p4]. You can get `rst2html` by installing either [Sphinx][p5] or
[docutils][p6].

By default, literal blocks, inline literals, and `code-block`s are ignored.

### AsciiDoc [`markup`]

Vale supports AsciiDoc through the external program [Asciidoctor][p7].

By default, listing blocks and inline literals are ignored.

### DITA [`markup`]

```callout{'title': 'NOTE', 'classes': ['tip']}
You'll need to manually add the `dita-ot-X.X.X/bin` directory to your `$PATH`.
```

Vale supports DITA through the [DITA Open Toolkit](https://www.dita-ot.org/).

By default, `script`, `style`, `pre`, `code`, and `tt` tags are ignored.

### XML [`markup`]

Vale supports XML through the external program [`xsltproc`](http://xmlsoft.org/XSLT/xsltproc.html).

In order for Vale to understand your XML, you need to provide a version 1.0 XSL Transformation (XSLT) for converting to HTML:

```ini
[*.xml]
Transform = docbook-xsl-snapshot/html/docbook.xsl
```

### Source Code [`code`]

<!-- vale 18F.UnexpandedAcronyms = NO -->

|   Language  |          Extensions                   |                                                        Tokens (scope)                                                               |
|-------------|---------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|
| C           | `.c`, `.h`                            | `//` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                                |
| C#          | `.cs`, `.csx`                         | `//` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                                |
| C++         | `.cpp`, `.cc`, `.cxx`, `.hpp`         | `//` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                                |
| CSS         | `.css`                                | `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                                                                |
| Go          | `.go`                                 | `//` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                                |
| Haskell     | `.hs`                                 | `--` (`text.comment.line.ext`), `{-` (`text.comment.block.ext`)                                                                     |
| Java        | `.java`, `.bsh`                       | `//` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                                |
| JavaScript  | `.js`                                 | `//` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                                |
| LESS        | `.less`                               | `//`(`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                                 |
| Lua         | `.lua`                                | `--` (`text.comment.line.ext`), `--[[` (`text.comment.block.ext`)                                                                   |
| Perl        | `.pl`, `.pm`, `.pod`                  | `#` (`text.comment.line.ext`)                                                                                                       |
| PHP         | `.php`                                | `//` (`text.comment.line.ext`), `#` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`) |
| Python      | `.py`, `.py3`, `.pyw`, `.pyi`, `.rpy` | `#` (`text.comment.line.ext`), `"""` (`text.comment.block.ext`)                                                                     |
| R           | `.r`, `.R`                            | `#` (`text.comment.line.ext`)                                                                                                       |
| Ruby        | `.rb`                                 | `#` (`text.comment.line.ext`), `^=begin` (`text.comment.block.ext`)                                                                 |
| Sass        | `.sass`                               | `//` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                                |
| Scala       | `.scala`, `.sbt`                      | `//`(`text.comment.line.ext`),                                                                                                      |
| Swift       | `.swift`                              | `//` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                                |

## Non-Standard Markup

When working with non-HTML markup, you'll probably find that there are certain
non-standard sections of text you'd like to ignore. Vale supports doing this at
both the block and inline levels.

To ignore entire blocks of text&mdash;for example,
[Hugo's shortcodes][p8]&mdash;you'll want to define `BlockIgnores`. For
example, consider the following shortcode-like `file` snippet:

```text
{< file "hello.go" go >}
package main

import "fmt"

func main() {
    fmt.Printf("hello, world\n")
}
{</ file >}
```

To ignore all instances of `file`, we'd use a pattern along the lines of the
following:

```text
BlockIgnores = (?s) *({< file [^>]* >}.*?{</ ?file >})
```

The basic idea is to capture the entire snippet in the first grouping. See
[regex101][p9] for a more thorough explanation.

You can also define more than one by using a list (the `\` allows for line
breaks):

```text
BlockIgnores = (?s) *({< output >}.*?{< ?/ ?output >}), \
(?s) *({< highlight .* >}.*?{< ?/ ?highlight >})
```

To ignore an inline section of text, you'll want to define `TokenIgnores`. For
example, let's say we want to ignore math equations of the form `$...$`:

```text
$\begin{bmatrix} k & k & k \end{bmatrix}^T$
```

Similar to `BlockIgnores`, we just need to define a pattern:

```text
TokenIgnores = (\$+[^\n$]+\$+)
```

See [Configuration](ini) for more details.

[p1]: https://github.com/getify/You-Dont-Know-JS
[p2]: https://github.com/nltk/nltk_book
[p3]: https://github.com/django/django
[p4]: http://docutils.sourceforge.net/docs/user/tools.html#rst2html-py
[p5]: http://www.sphinx-doc.org/en/stable/
[p6]: http://docutils.sourceforge.net/
[p7]: https://rubygems.org/gems/asciidoctor
[p8]: https://gohugo.io/content-management/shortcodes/
[p9]: https://regex101.com/r/mFM0kZ/1/
