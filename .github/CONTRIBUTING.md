# Contributing to Vale

Interested in contributing to Vale? Great! We welcome contributions of any kind including documentation improvements, bug reports, feature requests, pull requests, etc.

## Table of Contents

* [Introduction](#intro)
* [Testing](#testing)
* [Setting up a Development Environment](#devenv)
* [Code Contribution Guidelines](#code-guidelines)
* [Commit Message Guidelines](#commit-guidelines)
* [Terminology](#terms)

## <a name="intro"></a> Introduction

Vale is a natural language linter that supports plain text, markup (Markdown, reStructuredText, AsciiDoc, and HTML), and source code comments. However, unlike many similar projects, Vale's primary focus isn't on providing a collection of rules everyone must follow&mdash;instead, Vale aims to be flexible enough to support many different styles (see the [reference styles](https://github.com/ValeLint/vale#reference-styles) for examples).

More specifically, Vale is written in Go and split into packages that are tasked with performing specific tasks:

- `check` handles the loading and validating of external rules (YAML files).
- `core`: includes the main structures used throughout the application (e.g., `File` and `Alert`) and manages configuration files (`.vale` or `_vale`).
- `lint` handles the actual linting, which includes knowing when to apply rules and how to handle specific file formats.
- `rule` implements Vale's built-in style.
- `ui` manages displaying information to users.

There is also a `styles` directory that contains the source for Vale's reference styles.

## <a name="testing"></a> Testing

Vale is tested using both integration and unit tests.

Integration tests are the most plentiful at the moment. They're implemented using the behavior-driven development framework [Cucumber](https://cucumber.io/). You'll find the relevant files for these tests in the `fixtures` and `features` directories. Unit tests are found in the `*_test.go` files inside the actual Go packages. 

We also track Vale's performance on a per-commit basis through benchmarks. On every commit, you'll see comparison against the last tagged release (over 10 runs) on CI builds:

```text
LintRST-2   1.63s ± 2%   1.65s ± 2%  +0.95%  (p=0.031 n=10+10)
LintMD-2    1.54s ± 1%   1.54s ± 1%    ~     (p=0.604 n=10+10)
```


To run the tests, you'll want to invoke either `make bench` or `make ci` (see [Setting up a Development Environment]() for more information).

## <a name="devenv"></a> Setting up a Development Environment

You'll need to have [Ruby](https://www.ruby-lang.org/en/downloads/) (v2.3+) and [Go](https://golang.org/) (v1.7+) installed. Next, you'll need to install and configure [`aruba`](https://github.com/cucumber/aruba) (assuming you're inside the `vale` directory):

```bash
$ gem install bundler # if necessary
$ aruba init --test-framework cucumber
$ make setup
$ make ci
```

To get all tests passing, you'll also need [Asciidoctor](http://asciidoctor.org/) and [rst2html](http://docutils.sourceforge.net/docs/user/tools.html#rst2html-py) available on your `$PATH`. The latter is installed with both [Sphinx](http://www.sphinx-doc.org/en/stable/) and [docutils](https://pypi.python.org/pypi/docutils).

## <a name="code-guidelines"></a>  Code Contribution Guidelines

To make the contribution process as seamless as possible, we ask for the following:

* Fork the project and make your changes.
* When you’re ready to create a pull request, be sure to:
    * Run `make lint` to check your Go code style.
    * Squash your commits into a single commit. `git rebase -i`. It’s okay to force update your pull request with `git push -f`.
    * Follow the **Git Commit Message Guidelines** below.

## <a name="commit-guidelines"></a> Git Commit Message Guidelines

Vale follows a modified version of the [AngularJS Commit Guidelines](https://github.com/angular/angular.js/blob/master/CONTRIBUTING.md#-git-commit-guidelines). A commit message should take the following form:

```
<type>: <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

with `<body>` and `<footer>` being optional.

An example would be something like:

```text
refactor: make "warning" the default lint level

Also demotes `Annotations` and `PassiveVoice` to "suggestions."

Related to #30.
```

## <a name="terms"></a> Terminology

| Term  | Definition                                                                                                                                                                        |
|:-----:|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| check | A "check" is one of Vale's extension points (e.g., `existence` and `substitution`) that performs a single task such as looking for the existence of a word.                       |
| rule  | A "rule" is an actual implementation of a check. For example, [`Hedging`](https://github.com/ValeLint/vale/blob/master/rule/Hedging.yml) is one of Vale's built-in rules.         |
| style | A "style" is a collection of rules. For example, [`Joblint`](https://github.com/ValeLint/vale/tree/master/styles/Joblint) is a style that consists of rules such as `LegacyTech`. |
