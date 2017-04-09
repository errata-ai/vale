# Vale: Your Style, Our Editor

[![Build Status](https://travis-ci.org/ValeLint/vale.svg?branch=master)](https://travis-ci.org/ValeLint/vale) [![Build status](https://ci.appveyor.com/api/projects/status/snk0oo6ih1nwuf6r/branch/master?svg=true)](https://ci.appveyor.com/project/jdkato/vale/branch/master) [![Go Report Card](https://goreportcard.com/badge/github.com/ValeLint/vale)](https://goreportcard.com/report/github.com/ValeLint/vale) [![codebeat](https://codebeat.co/badges/a9b4b73a-182d-4ed7-8019-0fc5957bad91)](https://codebeat.co/projects/github-com-valelint-vale-master) [![license](https://img.shields.io/github/license/mashape/apistatus.svg)]()

![demo](https://cloud.githubusercontent.com/assets/8785025/22951386/df064226-f2bd-11e6-84e3-4cedfc098528.png)

Vale is a natural language linter that supports plain text, markup (Markdown, reStructuredText, AsciiDoc, and HTML), and source code comments. Vale doesn't attempt to offer a one-size-fits-all collection of rules&mdash;instead, it strives to make customization as easy as possible.

Check out [project website](https://valelint.github.io/) to learn more!

## Features

- [X] Supports Markdown, reStructuredText, AsciiDoc, HTML, and source code.
- [X] Extensible through straightforward YAML files.
- [X] Standalone binaries for Windows, macOS, and Linux.
- [X] Expressive, [EditorConfig-like](http://editorconfig.org/) configuration.

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


|      Style     |                                                      Description                                                      | Development Status |
|:--------------:|:---------------------------------------------------------------------------------------------------------------------:|:------:|
|  [`write-good`](https://github.com/ValeLint/vale/tree/master/styles/write-good)  | Naive linter for English prose for developers who can't write good and wanna learn to do other stuff good too.        |    :white_check_mark:    |
|    [`Joblint`](https://github.com/ValeLint/vale/tree/master/styles/Joblint)   | Test tech job posts for issues with sexism, culture, expectations, and recruiter fails.                               |    :white_check_mark:    |
|    [`jQuery`](https://github.com/ValeLint/vale/tree/master/styles/jQuery)    | A collection of rules based on jQuery's documentation formatting conventions and writing style.                                                                                                                      |    :construction:    |
| [`TheEconomist`](https://github.com/ValeLint/vale/tree/master/styles/TheEconomist) |  A collection of rules based on The Economist Style Guide.                                                                                                                      |   :construction:     |
|   [`Homebrew`](https://github.com/ValeLint/vale/tree/master/styles/Homebrew)   | A set of style and usage guidelines for Homebrew’s prose documentation aimed at users, contributors, and maintainers. |    :construction:    |
|   [`Middlebury`](https://github.com/ValeLint/vale/tree/master/styles/Middlebury)   | A collection of rules based on The Middlebury Editorial Style Guide |    :construction:    |

