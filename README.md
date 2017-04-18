# Vale: Your Style, Our Editor

[![Build Status](https://travis-ci.org/ValeLint/vale.svg?branch=master)](https://travis-ci.org/ValeLint/vale) [![Build status](https://ci.appveyor.com/api/projects/status/snk0oo6ih1nwuf6r/branch/master?svg=true)](https://ci.appveyor.com/project/jdkato/vale/branch/master) [![Go Report Card](https://goreportcard.com/badge/github.com/ValeLint/vale)](https://goreportcard.com/report/github.com/ValeLint/vale) [![codebeat](https://codebeat.co/badges/a9b4b73a-182d-4ed7-8019-0fc5957bad91)](https://codebeat.co/projects/github-com-valelint-vale-master) [![license](https://img.shields.io/github/license/mashape/apistatus.svg)]()

![demo](https://cloud.githubusercontent.com/assets/8785025/22951386/df064226-f2bd-11e6-84e3-4cedfc098528.png)

Vale is a natural language linter that supports plain text, markup (Markdown, reStructuredText, AsciiDoc, and HTML), and source code comments. Vale doesn't attempt to offer a one-size-fits-all collection of rules&mdash;instead, it strives to make customization as easy as possible.

Check out [project website](https://valelint.github.io/) to learn more!

## Highlights

- [X] Supports Markdown, reStructuredText, AsciiDoc, HTML, and source code.
- [X] Extensible through straightforward YAML files.
- [X] Standalone binaries for Windows, macOS, and Linux.
- [X] Expressive, [EditorConfig-like](http://editorconfig.org/) configuration.

## What can Vale do?

Vale's functionality is split into extension points (called "checks") that can customized to meet your own needs:

- `existence` ([example](https://github.com/ValeLint/vale/blob/master/rule/Hedging.yml)): As its name implies, it looks for the existence of particular strings. This is useful if, for example, we want to discourage the use of a certain word or phrase.
- `substitution` ([example](https://github.com/ValeLint/vale/blob/master/rule/GenderBias.yml)): This is similar to above, but it also suggestions a preferred form. For example, we'd use this if we want to suggest the use of “plenty” instead of “abundance.”
- `occurrence` ([example](https://github.com/ValeLint/vale/blob/master/styles/demo/SentenceLength.yml)): This limits the number of times a particular token can appear in a given scope. For example, if we’re limiting the number of words per sentence.
- `repetition` ([example](https://github.com/ValeLint/vale/blob/master/rule/Repetition.yml)): This checks for repeated occurrences of its tokens (e.g., lexical illusions like “the the”).
- `consistency` ([example](https://github.com/ValeLint/vale/blob/master/styles/demo/Spelling.yml)): This will ensure that a key and its value (e.g., “advisor” and “adviser”) don’t both occur in its scope.
- `conditional` ([example](https://github.com/ValeLint/vale/blob/master/styles/TheEconomist/UnexpandedAcronyms.yml)): This ensures that the existence of `first` implies the existence of `second`. This is useful for things like verifying that an abbreviation has a parenthetical defintion.
- `spelling` ([example](https://github.com/ValeLint/vale/blob/master/styles/demo/CheckSpellings.yml)): This will spell check against a large [list of words](https://github.com/client9/misspell#words) accounting for customizations (e.g., removing or adding words to the dictionary).

Additionally, since Vale is “syntax aware,” you'll never have to worry about syntax-related false positives (e.g., URLs or code blocks). See [Check Types](https://valelint.github.io/styles/#check-types) for more information.

## Installation

There are a few options to choose from:

- Install through [Homebrew](http://brew.sh) on **macOS**:

    ```bash
    $ brew tap ValeLint/vale
    $ brew install vale
    ```
- Install via the Windows Installer package (`.msi`) on the [releases page](https://github.com/valelint/vale/releases).
- Manually install on **Windows**, **macOS**, or **Linux** by downloading an executable from the [releases page](https://github.com/valelint/vale/releases).

## Usage

Run Vale on a single file:

```shell
$ vale README.md
```

Run Vale on files matching a particular glob:

```shell
# Only lint Markdown and reStructuredText
$ vale --glob='*.{md,rst}' directory
```

Or exclude files matching a particular glob:

```shell
# Ignore all `.txt` files
$ vale --glob='!*.txt' directory
```

Pipe input to Vale:

```shell
$ echo 'this is some text' | vale
```

Run Vale on text with an assigned syntax:

```shell
$ vale --ext=.md 'this is some text'
```

See `vale --help` and [Configuration](https://valelint.github.io/config/) for more information.

## Integrations

- Atom&mdash;[TimKam/atomic-vale](https://github.com/TimKam/atomic-vale)
- Sublime Text&mdash;[ValeLint/SubVale](https://github.com/ValeLint/SubVale)

## Reference Styles

|                                       Style (download)                                        | Description                                                                                                           | Development Status |
|:----------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------------:|:------------------:|
|   [`write-good`](https://github.com/ValeLint/docs/raw/master/styles/write-good.zip)   | Naive linter for English prose for developers who can't write good and wanna learn to do other stuff good too.        | :white_check_mark: |
|      [`Joblint`](https://github.com/ValeLint/docs/raw/master/styles/Joblint.zip)      | Test tech job posts for issues with sexism, culture, expectations, and recruiter fails.                               | :white_check_mark: |
|       [`jQuery`](https://github.com/ValeLint/docs/raw/master/styles/jQuery.zip)       | A collection of rules based on jQuery's documentation formatting conventions and writing style.                       |   :construction:   |
| [`TheEconomist`](https://github.com/ValeLint/docs/raw/master/styles/TheEconomist.zip) | A collection of rules based on The Economist Style Guide.                                                             |   :construction:   |
|     [`Homebrew`](https://github.com/ValeLint/docs/raw/master/styles/Homebrew.zip)     | A set of style and usage guidelines for Homebrew’s prose documentation aimed at users, contributors, and maintainers. |   :construction:   |
|   [`Middlebury`](https://github.com/ValeLint/docs/raw/master/styles/Middlebury.zip)   | A collection of rules based on The Middlebury Editorial Style Guide.                                                  |   :construction:   |
|          [`18F`](https://github.com/ValeLint/docs/raw/master/styles/18F.zip)          | Guidelines for creating plain and concise writing.                                                                    |   :construction:   |

To use one of these styles, you'd copy its files onto your `StylesPath` and then specify it in your config file:

```ini
# This goes in a file named either `.vale` or `_vale`.

StylesPath = path/to/some/directory
MinAlertLevel = warning # suggestion, warning or error

[*.{md,txt}] # Only Markdown and .txt files
# List of styles to load
BasedOnStyles = vale, Joblint
# Style.Rule = {YES, NO, suggestion, warning, error} to
# enable/disable a rule or change its level.
vale.Editorializing = NO
```

See [Configuration](https://valelint.github.io/config/) and [Styles](https://valelint.github.io/styles/) for more information.
