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

- [x] [Atom: TimKam/atomic-vale](https://github.com/TimKam/atomic-vale)
- [x] [Sublime Text: ValeLint/SubVale](https://github.com/ValeLint/SubVale)
