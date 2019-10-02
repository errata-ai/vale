# Vale: Your style, our editor [![Build Status](https://img.shields.io/travis/errata-ai/vale/master.svg?style=flat-square&amp;logo=travis)](https://travis-ci.org/errata-ai/vale) [![Go Report Card](https://goreportcard.com/badge/github.com/gojp/goreportcard?style=flat-square)](https://goreportcard.com/report/github.com/errata-ai/vale) [![downloads](https://img.shields.io/github/downloads/errata-ai/vale/total.svg?style=flat-square)](https://github.com/errata-ai/vale/releases)

> **:boom: Tired of the command line?** Vale now has a [cross-platform desktop application](https://errata.ai/vale-server/) that introduces a number of new features, including add-ons for **Google Docs** and **Google Chrome**.
>
> See [Why Vale Server?](https://errata-ai.github.io/vale-server/docs/about) for more information.

![vale-demo](https://user-images.githubusercontent.com/8785025/39656657-59e62c26-4fb6-11e8-9f48-ba230400ed55.png)

Vale is a natural language linter that supports plain text, markup (Markdown, reStructuredText, AsciiDoc, and HTML), and source code comments. Vale doesn't attempt to offer a one-size-fits-all collection of rules&mdash;instead, it strives to make customization as easy as possible.

Check out [project website](https://errata-ai.github.io/vale) or [our blog post](https://medium.com/@errata.ai/introducing-vale-an-nlp-powered-linter-for-prose-63c4de31be00) to learn more!

* [Installation](#installation)
* [Usage](#usage)
* [Used By](#used-by)

## Installation

The recommended way to install Vale is through [GoDownloader](https://install.goreleaser.com/projects/):

```console
# Vale will be installed into `/bin/vale`.
$ curl -sfL https://install.goreleaser.com/github.com/ValeLint/vale.sh | sh -s vX.Y.Z
```

where `vX.Y.Z` is your version of choice from the [releases page](https://github.com/errata-ai/vale/releases).

## Usage

###### Using pre-made styles

Vale ships with its own built-in style, [`Vale`](https://errata-ai.github.io/vale/styles/#default-style), that implements spell check and other basic rules. There is also a library of officially-maintained styles available for download at [errata-ai/styles](https://github.com/errata-ai/styles).

To use one of these styles, you'll need to create a [config file](https://errata-ai.github.io/vale/config/) along the lines of the following:

```ini
# This goes in a file named either `.vale.ini` or `_vale.ini`.

StylesPath = path/to/some/directory
MinAlertLevel = warning # suggestion, warning or error

# Only Markdown and .txt files; change to whatever you're using.
[*.{md,txt}]
# List of styles to load.
#
# `Vale` is built-in; other styles need to be unzipped onto your StylesPath (defined above).
BasedOnStyles = Vale, proselint
# Style.Rule = {YES, NO, suggestion, warning, error} to
# enable/disable a rule or change its level.
write-good.E-Prime = NO
```

See [Getting Started](https://errata-ai.github.io/vale/) for more information.

###### Creating your own style

While the built-in styles are useful, Vale is really designed to [meet custom needs](https://errata-ai.github.io/vale/styles/). This is done by using Vale's extension points (called "checks") that can be customized to perform many different kinds of tasks, including [calculating readability](https://github.com/errata-ai/vale/blob/master/styles/demo/Reading.yml), [measuring sentence length](https://github.com/errata-ai/vale/blob/master/styles/demo/SentenceLength.yml), and [enforcing a particular heading style](https://github.com/errata-ai/vale-boilerplate/blob/master/src/18F/Headings.yml).

See the [Microsoft](https://github.com/errata-ai/vale-boilerplate) project for a complete example of a Vale-compatible style guide.

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

###### Third-party integrations

If you'd like to use Vale with another application (such as a text editor), be sure to check out Vale's native desktop application [Vale Server](https://errata.ai/vale-server/). The available integrations currently inlcude **Visual Studio Code**, **Sublime Text 3**, **Atom**, **Google Docs**, and **Google Chrome**.
