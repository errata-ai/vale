# Vale: Your Style, Our Editor

[![Build Status](https://travis-ci.org/ValeLint/vale.svg?branch=master)](https://travis-ci.org/ValeLint/vale) [![Build status](https://ci.appveyor.com/api/projects/status/snk0oo6ih1nwuf6r/branch/master?svg=true)](https://ci.appveyor.com/project/jdkato/vale/branch/master) [![Go Report Card](https://goreportcard.com/badge/github.com/ValeLint/vale)](https://goreportcard.com/report/github.com/ValeLint/vale) [![release](https://img.shields.io/github/release/valelint/vale.svg)](https://github.com/ValeLint/vale/releases/latest) [![Snap Status](https://build.snapcraft.io/badge/ValeLint/vale.svg)](https://build.snapcraft.io/user/ValeLint/vale)

![demo](https://cloud.githubusercontent.com/assets/8785025/22951386/df064226-f2bd-11e6-84e3-4cedfc098528.png)

Vale is a natural language linter that supports plain text, markup (Markdown, reStructuredText, AsciiDoc, and HTML), and source code comments. Vale doesn't attempt to offer a one-size-fits-all collection of rules&mdash;instead, it strives to make customization as easy as possible.

Check out [project website](https://valelint.github.io/docs/) to learn more!

## Highlights

- [X] Supports Markdown, reStructuredText, AsciiDoc, HTML, and source code.
- [X] Extensible through straightforward YAML files.
- [X] Standalone binaries for Windows, macOS, and Linux.
- [X] Expressive, [EditorConfig-like](http://editorconfig.org/) configuration.

## Features

Vale's functionality is split into extension points (called "checks") that can be customized to perform many different kinds of tasks, including [calculating readability](https://github.com/ValeLint/vale/blob/master/styles/demo/Reading.yml), [measuring sentence length](https://github.com/ValeLint/vale/blob/master/styles/jQuery/SentenceLength.yml), [enforcing a particular heading style](https://github.com/ValeLint/vale/blob/master/styles/18F/Titles.yml), and [identifying undefined acronyms](https://github.com/ValeLint/vale/blob/master/styles/TheEconomist/UnexpandedAcronyms.yml). See the [Style Showcase](https://valelint.github.io/docs/showcase/) for more advanced examples.

Additionally, since Vale is "syntax aware," you'll never have to worry about syntax-related false positives (e.g., URLs or code blocks). See [Creating a style](https://valelint.github.io/docs/styles/#creating-a-style) for more information.

## Installation

There are a few options to choose from:

- [Homebrew](http://brew.sh) or [Linuxbrew](http://linuxbrew.sh/):

    ```bash
    $ brew tap ValeLint/vale
    $ brew install vale
    ```
- [Chocolatey](https://chocolatey.org/packages/vale/):		
		
     ```shell		
     C:\> choco install vale		
     ```
- [snapcraft](https://snapcraft.io/):

    ```bash
    $ snap install vale
    ```
    
- A Windows Installer package (`.msi`), which you'll find on the [releases page](https://github.com/valelint/vale/releases).
- Manually on Windows, macOS, or Linux by downloading an executable from the [releases page](https://github.com/valelint/vale/releases).

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
$ echo 'this is some very interesting text' | vale
```

Run Vale on text with an assigned syntax:

```shell
$ vale --ext=.md 'this is some `very` interesting text'
```

See `vale --help` and [Configuration](https://valelint.github.io/docs/config/) for more information.

## Integrations

- Atom&mdash;[TimKam/atomic-vale](https://github.com/TimKam/atomic-vale)
- Emacs&mdash;[abingham/flycheck-vale](https://github.com/abingham/flycheck-vale)
- Sublime Text&mdash;[ValeLint/SubVale](https://github.com/ValeLint/SubVale)
- Visual Studio Code&mdash;[lunaryorn/vscode-vale](https://marketplace.visualstudio.com/items?itemName=lunaryorn.vale)
- Vim&mdash;via [ALE](https://github.com/w0rp/ale) (thanks to @[chew-z](https://github.com/chew-z))

## Reference Styles

|           Style (source)           |               Download                |                                                      Description                                                      | Development Status |
|:----------------------------------:|:-------------------------------------:|:---------------------------------------------------------------------------------------------------------------------:|:------------------:|
|          [`18F`][18F-src]          |          [`18F.zip`][18F-dl]          |                                  Guidelines for creating plain and concise writing.                                   |   :construction:   |
|     [`Homebrew`][Homebrew-src]     |     [`Homebrew.zip`][Homebrew-dl]     | A set of style and usage guidelines for Homebrew’s prose documentation aimed at users, contributors, and maintainers. |   :construction:   |
|      [`Joblint`][Joblint-src]      |      [`Joblint.zip`][Joblint-dl]      |                Test tech job posts for issues with sexism, culture, expectations, and recruiter fails.                | :white_check_mark: |
|       [`jQuery`][jQuery-src]       |       [`jQuery.zip`][jQuery-dl]       |            A collection of rules based on jQuery's documentation formatting conventions and writing style.            |   :construction:   |
|    [`MailChimp`][MailChimp-src]    |    [`MailChimp.zip`][MailChimp-dl]    |                             Writing style guidelines used on the MailChimp documentation.                             |   :construction:   |
|   [`Middlebury`][Middlebury-src]   |   [`Middlebury.zip`][Middlebury-dl]   |                         A collection of rules based on The Middlebury Editorial Style Guide.                          |   :construction:   |
|    [`OpenStack`][OpenStack-src]    |    [`OpenStack.zip`][OpenStack-dl]    |                             Writing style guidelines used on the OpenStack documentation.                             |   :construction:   |
|    [`proselint`][proselint-src]    |    [`proselint.zip`][proselint-dl]    |                 A linter for English prose that aggregates knowledge about best practices in writing.                 | :white_check_mark: |
|         [`Rust`][Rust-src]         |         [`Rust.zip`][Rust-dl]         |                        Writing style guidelines used on *The Rust Programming Language* book.                         | :white_check_mark: |
| [`TheEconomist`][TheEconomist-src] | [`TheEconomist.zip`][TheEconomist-dl] |                               A collection of rules based on The Economist Style Guide.                               |   :construction:   |
|   [`write-good`][write-good-src]   |   [`write-good.zip`][write-good-dl]   |    Naive linter for English prose for developers who can't write good and wanna learn to do other stuff good too.     | :white_check_mark: |

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

See [Configuration](https://valelint.github.io/docs/config/) and [Styles](https://valelint.github.io/docs/styles/) for more information.

<!-- styles -->

[write-good-src]: https://github.com/btford/write-good
[write-good-dl]: https://github.com/ValeLint/docs/raw/master/styles/write-good.zip

[Joblint-src]: https://github.com/rowanmanning/joblint
[Joblint-dl]: https://github.com/ValeLint/docs/raw/master/styles/Joblint.zip

[jQuery-src]: https://contribute.jquery.org/style-guide/prose/
[jQuery-dl]: https://github.com/ValeLint/docs/raw/master/styles/jQuery.zip

[TheEconomist-src]: http://www.economist.com/styleguide/introduction
[TheEconomist-dl]: https://github.com/ValeLint/docs/raw/master/styles/TheEconomist.zip

[Homebrew-src]: http://docs.brew.sh/Prose-Style-Guidelines.html
[Homebrew-dl]: https://github.com/ValeLint/docs/raw/master/styles/Homebrew.zip

[Middlebury-src]: https://middlebury.github.io/styleguide/editorial/
[Middlebury-dl]: https://github.com/ValeLint/docs/raw/master/styles/Middlebury.zip

[18F-src]: https://pages.18f.gov/content-guide/
[18F-dl]: https://github.com/ValeLint/docs/raw/master/styles/18F.zip

[OpenStack-src]: https://docs.openstack.org/contributor-guide/writing-style.html
[OpenStack-dl]: https://github.com/ValeLint/docs/raw/master/styles/OpenStack.zip

[MailChimp-src]: http://styleguide.mailchimp.com/
[MailChimp-dl]: https://github.com/ValeLint/docs/raw/master/styles/MailChimp.zip

[Rust-src]: https://github.com/rust-lang/book/blob/master/second-edition/style-guide.md
[Rust-dl]: https://github.com/ValeLint/docs/raw/master/styles/Rust.zip

[proselint-src]: https://github.com/amperser/proselint
[proselint-dl]: https://github.com/ValeLint/docs/raw/master/styles/proselint.zip
