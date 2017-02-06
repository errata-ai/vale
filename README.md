# `txtlint`: Your Style, Our Editor

[![Build Status](https://travis-ci.org/jdkato/txtlint.svg?branch=master)](https://travis-ci.org/jdkato/txtlint) [![Build status](https://ci.appveyor.com/api/projects/status/0vo1d47jj2ja7v66/branch/master?svg=true)](https://ci.appveyor.com/project/jdkato/txtlint/branch/master) [![Go Report Card](https://goreportcard.com/badge/github.com/jdkato/txtlint)](https://goreportcard.com/report/github.com/jdkato/txtlint) [![license](https://img.shields.io/github/license/mashape/apistatus.svg)]()

![demo](https://cloud.githubusercontent.com/assets/8785025/22620378/85715878-eabf-11e6-99f4-4cc275e6f95f.png)

`txtlint` is a linter for English prose&mdash;no matter if it's plain text, markup or source-code comments. It's built around a plugin system that allows it to lint against arbitrary rules. In practice, this means that `txtlint` can help you adhere to entire editorial style guides or simply break writer-specific bad habits (see [Use Cases]() for more ideas).


Here's an example of `txtlint`'s versatility:

```ini
# These options are specified in either a .txtlint or _txtlint file.
StylesPath = path/to/my/project/styles/directory
MinAlertLevel = warning

[*.{md,txt}]
BasedOnStyles = TheEconomist
txtlint.Editorializing = YES

[*.py]
BasedOnStyles = txtlint
write-good.ThereIs = YES
txtlint.PassiveVoice = NO
```

In this case, we are linting all Markdown and text files in our project against [The Economist](http://www.economist.com/styleguide/introduction). We are also linting Python comments against `txtlint` and [`write-goods`](https://github.com/btford/write-good)'s `ThereIs` rule.

Check out [the wiki](https://github.com/jdkato/txtlint/wiki) to learn more!

## Features

- [X] Supports Markdown, reStructuredText, AsciiDoc, HTML, and source code
- [X] Extensible without programming experience
- [X] External checks can be written in *any* programming language
- [X] Standalone binaries for Windows, macOS, and Linux
- [X] Expressive, [EditorConfig-like](http://editorconfig.org/) configuration
