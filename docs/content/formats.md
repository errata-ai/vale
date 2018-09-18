## Overview

Vale is "syntax aware," which means that it's capable of both applying rules to and ignoring certain sections of text. This functionality is implemented through a *scoping* system. A scope (i.e., a particular section of text) is specified through a *selector* such as `paragraph.rst`, which indicates that the rule applies to all paragraphs in reStructuredText files. Here are a few examples:

- `comment` matches all source code comments;
- `comment.line` matches all source code line comments;
- `heading.md` matches all Markdown headings; and
- `text.html` matches all HTML scopes.

The table below summarizes all available scopes.

|   Format   |                             Scopes                            |
|:----------:|---------------------------------------------------------------|
|   markup   | `heading`, `table.header`, `table.cell`, `list`, `paragraph`, `sentence`  |
|    code    | `comment.line`, `comment.block`                                   |
| plain text | `text`                                                          |

## Markdown

Vale has built-in support for GitHub-Flavored Markdown. By default, it ignores indented blocks, fenced blocks, and code spans.

## HTML

Vale has built-in support for HTML. By default, it ignores `script`, `style`, `pre`, `code`, and `tt` tags.

## reStructuredText

Vale supports reStructuredText through the external program [`rst2html`](http://docutils.sourceforge.net/docs/user/tools.html#rst2html-py). If you have [Sphinx](http://www.sphinx-doc.org/en/stable/) or [docutils](http://docutils.sourceforge.net/) installed, you shouldn't need to install `rst2html` separately.

By default, it ignores literal blocks, inline literals, and `code-block`s.

## AsciiDoc

Vale supports AsciiDoc through the external program [AsciiDoctor](https://rubygems.org/gems/asciidoctor). By default, it ignores listing blocks and inline literals.

## Code

<!-- vale 18F.UnexpandedAcronyms = NO -->

|   Syntax   |          Extensions         |                                                        Tokens (scope)                                                       |
|----------|---------------------------|---------------------------------------------------------------------------------------------------------------------------|
| C          | `.c`, `.h`                      | `//` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                              |
| C#         | `.cs`, `.csx`                   | `//` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                              |
| C++        | `.cpp`, `.cc`, `.cxx`, `.hpp`       | `//` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                              |
| CSS        | `.css`                        | `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                                                            |
| Go         | `.go`                         | `//` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                              |
| Haskell    | `.hs`                         | `--` (`text.comment.line.ext`), `{-` (`text.comment.block.ext`)                                                                 |
| Java       | `.java`, `.bsh`                 | `//` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                              |
| JavaScript | `.js`                         | `//` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                              |
| LESS       | `.less`                       | `//`(`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                               |
| Lua        | `.lua`                        | `--` (`text.comment.line.ext`), `--[[` (`text.comment.block.ext`)                                                               |
| Perl       | `.pl`, `.pm`, `.pod`              | `#` (`text.comment.line.ext`)                                                                                                 |
| PHP        | `.php`                        | `//` (`text.comment.line.ext`), `#` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`) |
| Python     | `.py`, `.py3`, `.pyw`, `.pyi`, `.rpy` | `#` (`text.comment.line.ext`), `"""` (`text.comment.block.ext`)                                                                 |
| R          | `.r`, `.R`                      | `#` (`text.comment.line.ext`)                                                                                                 |
| Ruby       | `.rb`                         | `#` (`text.comment.line.ext`), `^=begin` (`text.comment.block.ext`)                                                             |
| Sass       | `.sass`                       | `//` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                              |
| Scala      | `.scala`, `.sbt`                | `//`(`text.comment.line.ext`),                                                                                                |
| Swift      | `.swift`                      | `//` (`text.comment.line.ext`), `/*...*/` (`text.comment.line.ext`), `/*` (`text.comment.block.ext`)                              |

[p1]: https://github.com/getify/You-Dont-Know-JS
[p2]: https://github.com/nltk/nltk_book
[p3]: https://github.com/django/django
