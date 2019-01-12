# Vale: Your Style, Our Editor [![Build Status](https://img.shields.io/travis/errata-ai/vale/master.svg?style=flat-square&amp;logo=travis)](https://travis-ci.org/errata-ai/vale) [![Go Report Card](https://goreportcard.com/badge/github.com/gojp/goreportcard?style=flat-square)](https://goreportcard.com/report/github.com/errata-ai/vale) [![Thanks](https://img.shields.io/badge/say-thanks-ff69b4.svg?style=flat-square&amp;logo=gratipay&amp;logoColor=white)](#say-thanks)

> :star2: We're now offering [**Integration Assistance**](https://errata.ai/about/)! This is a great way to support the project while also getting the time-consuming tasks (e.g., creating a Vale-compatible version of your house style or setting up a CI service) out of the way.

![vale-demo](https://user-images.githubusercontent.com/8785025/39656657-59e62c26-4fb6-11e8-9f48-ba230400ed55.png)

Vale is a natural language linter that supports plain text, markup (Markdown, reStructuredText, AsciiDoc, and HTML), and source code comments. Vale doesn't attempt to offer a one-size-fits-all collection of rules&mdash;instead, it strives to make customization as easy as possible.

Check out [project website](https://errata-ai.github.io/vale) or [our blog post](https://medium.com/@errata.ai/introducing-vale-an-nlp-powered-linter-for-prose-63c4de31be00) to learn more!

## Installation

There are a few options to choose from:

- [Homebrew](http://brew.sh) (macOS):

    ```bash
    $ brew tap ValeLint/vale
    $ brew install vale
    ```

- [Go](https://golang.org/):

    ```shell
    $ go get github.com/errata-ai/vale
    ```

- [Docker](https://hub.docker.com/r/jdkato/vale/):

    ```shell
    $ docker pull jdkato/vale
    ```

- A Windows Installer package (`.msi`), which you'll find on the [releases page](https://github.com/errata-ai/vale/releases).
- Manually on Windows, macOS, or Linux by downloading an executable from the [releases page](https://github.com/errata-ai/vale/releases).

## Plugins for other software

- Atom&mdash;[TimKam/atomic-vale](https://github.com/TimKam/atomic-vale)
- Emacs&mdash;[abingham/flycheck-vale](https://github.com/abingham/flycheck-vale)
- Sublime Text&mdash;[SublimeLinter-contrib-vale](https://packagecontrol.io/packages/SublimeLinter-contrib-vale)
- Visual Studio Code&mdash;[lunaryorn/vscode-vale](https://marketplace.visualstudio.com/items?itemName=lunaryorn.vale)
- Vim&mdash;via [ALE](https://github.com/w0rp/ale) (thanks to @[chew-z](https://github.com/chew-z))

## Usage

###### Using the built-in styles

Vale ships with styles for [proselint](https://github.com/amperser/proselint), [write-good](https://github.com/btford/write-good), and [Joblint](https://github.com/rowanmanning/joblint). The benefits of using these styles over their original implementations include:

- [X] [Improved support for markup](https://errata-ai.github.io/vale/formats/), including the ability to ignore code and target only certain sections of text (e.g., checking headers for a specific capitalization style).
- [X] No need to install and configure npm (Node.js), pip (Python), or other language-specific tools. With Vale, you get all the functionality in a single, standalone binary available for Windows, macOS, and Linux.
- [X] Easily combine, mismatch, or otherwise customize each style.

To use one of these styles, you'll need to create a [config file](https://errata-ai.github.io/vale/config/) alone the lines of the following:

```ini
# This goes in a file named either `.vale.ini` or `_vale.ini`.

StylesPath = path/to/some/directory
MinAlertLevel = warning # suggestion, warning or error

# Only Markdown and .txt files; change to whatever you're using.
[*.{md,txt}]
# List of styles to load.
BasedOnStyles = proselint, write-good, Joblint
# Style.Rule = {YES, NO, suggestion, warning, error} to
# enable/disable a rule or change its level.
write-good.E-Prime = NO
```

###### Creating your own style

While the built-in styles are useful, Vale is really designed to [meet custom needs](https://errata-ai.github.io/vale/styles/). This is done by using Vale's extension points (called "checks") that can be customized to perform many different kinds of tasks, including [calculating readability](https://github.com/errata-ai/vale/blob/master/styles/demo/Reading.yml), [measuring sentence length](https://github.com/errata-ai/vale/blob/master/styles/demo/SentenceLength.yml), and [enforcing a particular heading style](https://github.com/errata-ai/vale-boilerplate/blob/master/src/18F/Headings.yml). See the [vale-boilerplate](https://github.com/errata-ai/vale-boilerplate) repository for a complete example of using Vale to enforce an external editorial style guide.

###### Using the CLI

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
$ echo 'this is some very interesting text' | vale
```

Run Vale on text with an assigned syntax:

```shell
$ vale --ext=.md 'this is some `very` interesting text'
```

See `vale --help` and [Usage](https://errata-ai.github.io/vale/usage/) for more information.

## Say thanks

Hi!

My name is [Joseph Kato](https://github.com/jdkato).

In my spare time, I develop and maintain a few [open-source tools](https://github.com/errata-ai) for collaborative writing. If you'd like to support my work, you can donate via [Square's Cash App](https://cash.me/$jdkato) or make use of my documentation-related [consulting services](https://errata.ai/about/).

I appreciate the support! _Thank you!_
