---
description: 'Learn about Vale''s unique, YAML-based extension system'
---

# Styles

## Introduction

Vale has a powerful extension system that doesn't require knowledge of any programming language. Instead, it exposes its functionality through simple [YAML](http://yaml.org) files.

{% hint style="info" %}
**Note**: Vale expect its external rules to have an extension of `.yml`, not `.yaml`, etc.
{% endhint %}

The core component of Vale's extension system are collections of writing guidelines called _styles_. These guidelines are expressed through _rules_, which are YAML files enforcing a particular writing construct—e.g., ensuring a certain readability level, sentence length, or heading style.

Styles are organized in a hierarchical folder structure at a user-specified location \(see [Configuration](configuration.md) for more details\). For example,

```text
styles/
├── base/
│   ├── ComplexWords.yml
│   ├── SentenceLength.yml
│   ...
├── blog/
│   ├── TechTerms.yml
│   ...
└── docs/
    ├── Branding.yml
    ...
```

where _base_, _blog_, and _docs_ are your styles.

## Extension Points

The building blocks behind Vale's styles are rules, which utilize extension points to perform specific tasks.

The basic structure of a rule consists of a small header \(shown below\) followed by extension-specific arguments.

```yaml
# All rules should define the following header keys:
#
# `extends` indicates the extension point being used (see below for information
# on the possible values).
extends: existence
# `message` is shown to the user when the rule is broken.
#
# Many extension points accept format specifiers (%s), which are replaced by
# extracted values. See the exention-specific sections below for more details.
message: "Consider removing '%s'"
# `level` assigns the rule's severity.
#
# The accepted values are suggestion, warning, and error.
level: warning
# `scope` specifies where this rule should apply -- e.g., headings, sentences, etc.
#
# See the Markup section for more information on scoping.
scope: heading
# `code` determines whether or not the content of code spans -- e.g., `foo` for
# Markdown -- is ignored.
code: false
# `link` gives the source for this rule.
link: 'https://errata.ai/'
```

## Creating a Style

`checks` offer a high-level way to extend Vale. They perform operations such as checking for consistency, counting occurrences, and suggesting changes.

{% hint style="info" %}
**Note**: Vale uses Go's [`regexp` package](https://golang.org/pkg/regexp/syntax/) to evaluate all patterns in rule definitions. This means that lookarounds and backreferences aren't supported.
{% endhint %}

### `existence`

#### Example definition

```yaml
extends: existence
message: Consider removing '%s'
level: warning
code: false
ignorecase: true
tokens:
    - appears to be
    - arguably
```

#### Key summary

| Name | Type | Description |
| :--- | :--- | :--- |
| `append` | `bool` | Adds `raw` to the end of `tokens`, assuming both are defined. |
| `ignorecase` | `bool` | Makes all matches case-insensitive. |
| `nonword` | `bool` | Removes the default word boundaries \(`\b`\). |
| `raw` | array | A list of tokens to be concatenated into a pattern. |
| `tokens` | `array` | A list of tokens to be transformed into a non-capturing group. |

The most general extension point is `existence`. As its name implies, it looks for the "existence" of particular tokens.

These tokens can be anything from simple phrases \(as in the above example\) to complex regular expressions—e.g., [the number of spaces between sentences](https://github.com/testthedocs/vale-styles/blob/master/18F/Spacing.yml) and [the position of punctuation after quotes](https://github.com/testthedocs/vale-styles/blob/master/18F/Quotes.yml).

You may define the tokens as elements of lists named either `tokens` \(shown above\) or `raw`. The former converts its elements into a word-bounded, non-capturing group. For instance,

```yaml
tokens:
  - appears to be
  - arguably
```

becomes `\b(?:appears to be|arguably)\b`.

`raw`, on the other hand, simply concatenates its elements—so, something like

```yaml
raw:
  - '(?:foo)\sbar'
  - '(baz)'
```

becomes `(?:foo)\sbar(baz)`.

### `substitution`

#### Example definition

```yaml
extends: substitution
message: Consider using '%s' instead of '%s'
level: warning
ignorecase: false
# swap maps tokens in form of bad: good
swap:
  abundance: plenty
  accelerate: speed up
```

#### Key summary

| Name | Type | Description |
| :--- | :--- | :--- |
| `append` | `bool` | Adds `raw` to the end of `tokens`, assuming both are defined. |
| `ignorecase` | `bool` | Makes all matches case-insensitive. |
| `swap` | `map` | A sequence of `observed: expected` pairs. |
| `pos` | `string` | A regular expression matching tokens to parts of speech. |

`substitution` associates a string with a preferred form. If we want to suggest the use of "plenty" instead of "abundance," for example, we'd write:

```yaml
swap:
  abundance: plenty
```

The keys may be regular expressions, but they can't include nested capture groups:

```yaml
swap:
  '(?:give|gave) rise to': lead to # this is okay
  '(give|gave) rise to': lead to # this is bad!
```

Like `existence`, `substitution` accepts the keys `ignorecase` and `nonword`.

`substitution` can have one or two `%s` format specifiers in its message. This allows us to do either of the following:

```yaml
message: "Consider using '%s' instead of '%s'"
# or
message: "Consider using '%s'"
```

### `occurrence`

#### Example definition

```yaml
extends: occurrence
message: "More than 3 commas!"
level: error
# Here, we're counting the number of times a comma appears 
# in a sentence.
#
# If it occurs more than 3 times, we'll flag it.
scope: sentence
ignorecase: false
max: 3
token: ','
```

#### Key summary

| Name | Type | Description |
| :--- | :--- | :--- |
| `max` | `int` | The maximum amount of times `token` may appear in a given scope. |
| `min` | `int` | The minimum amount of times `token` has to appear in a given scope. |
| `token` | `string` | The token of interest. |

`occurrence` enforces the maximum or minimum number of times a particular token can appear in a given scope.

In the example above, we're limiting the number of words per sentence.

This is the only extension point that doesn't accept a format specifier in its message.

### `repetition`

#### Example definition

```yaml
extends: repetition
message: "'%s' is repeated!"
level: error
alpha: true
tokens:
  - '[^\s]+'
```

#### Key summary

| Name | Type | Description |
| :--- | :--- | :--- |
| `ignorecase` | `bool` | Makes all matches case-insensitive. |
| `alpha` | `bool` | Limits all matches to alphanumeric tokens. |
| `tokens` | `array` | A list of tokens to be transformed into a non-capturing group. |

`repetition` looks for repeated occurrences of its tokens. If `ignorecase` is set to `true`, it'll convert all tokens to lower case for comparison purposes.

### `consistency`

#### Example definition

```yaml
extends: consistency
message: "Inconsistent spelling of '%s'"
level: error
scope: text
ignorecase: true
nonword: false
# We only want one of these to appear.
either:
  advisor: adviser
  centre: center
```

#### Key summary

| Name | Type | Description |
| :--- | :--- | :--- |
| `nonword` | `bool` | Removes the default word boundaries \(`\b`\). |
| `ignorecase` | `bool` | Makes all matches case-insensitive. |
| `either` | `array` | A map of `option 1: option 2` pairs of which only one may appear. |

`consistency` will ensure that a key and its value \(e.g., "advisor" and "adviser"\) don't both occur in its scope.

### `conditional`

#### Example definition

```yaml
extends: conditional
message: "'%s' has no definition"
level: error
scope: text
ignorecase: false
# Ensures that the existence of 'first' implies the existence of 'second'.
first: '\b([A-Z]{3,5})\b'
second: '(?:\b[A-Z][a-z]+ )+\(([A-Z]{3,5})\)'
# ... with the exception of these:
exceptions:
  - ABC
  - ADD
```

#### Key summary

| Name | Type | Description |
| :--- | :--- | :--- |
| `ignorecase` | `bool` | Makes all matches case-insensitive. |
| `first` | `string` | The antecedent of the statement. |
| `second` | `string` | The consequent of the statement. |
| `exceptions` | `array` | An array of strings to be ignored. |

`conditional` ensures that the existence of `first` implies the existence of `second`. For example, consider the following text:

> According to Wikipedia, the World Health Organization \(WHO\) is a specialized agency of the United Nations that is concerned with international public health. We can now use WHO because it has been defined, but we can't use DAFB because people may not know what it represents. We can use DAFB when it's presented as code, though.

Running `vale` on the above text with our example rule yields the following:

```bash
test.md:1:224:vale.UnexpandedAcronyms:'DAFB' has no definition
```

`conditional` also takes an optional `exceptions` list. Any token listed as an exception won't be flagged.

### `capitalization`

#### Example definition

```yaml
extends: capitalization
message: "'%s' should be in title case"
level: warning
scope: heading
# $title, $sentence, $lower, $upper, or a pattern.
match: $title
style: AP # AP or Chicago; only applies when match is set to $title.
```

#### Key summary

| Name | Type | Description |
| :--- | :--- | :--- |
| `match` | `string` | `$title`, `$sentence`, `$lower`, `$upper`, or a pattern. |
| `style` | `string` | AP or Chicago; only applies when match is set to `$title`. |
| `exceptions` | `array` | An array of strings to be ignored. |

`capitalization` checks that the text in the specified scope matches the case of `match`. There are a few pre-defined variables that can be passed as matches:

* `$title`: "The Quick Brown Fox Jumps Over the Lazy Dog."
* `$sentence`: "The quick brown fox jumps over the lazy dog."
* `$lower`: "the quick brown fox jumps over the lazy dog."
* `$upper`: "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG."

Additionally, when using `match: $title`, you can specify a style of either AP or Chicago.

### `readability`

#### Example definition

```yaml
extends: readability
message: "Grade level (%s) too high!"
level: warning
grade: 8
metrics:
  - Flesch-Kincaid
  - Gunning Fog
```

#### Key summary

| Name | Type | Description |
| :--- | :--- | :--- |
| `metrics` | `array` | `$title`, `$sentence`, `$lower`, `$upper`, or a pattern. |
| `grade` | `float` | The highest acceptable score. |

`readability` calculates a readability score according the specified metrics. The supported tests are Gunning-Fog, Coleman-Liau, Flesch-Kincaid, SMOG, and Automated Readability.

If more than one is listed \(as seen above\), the scores will be averaged. This is also the only extension point that doesn't accept a scope, as readability is always calculated using the entire document.

`grade` is the highest acceptable score. Using the example above, a warning will be issued if `grade` exceeds 8.

### `spelling`

#### Example definition

```yaml
extends: spelling
message: "Did you really mean '%s'?"
level: error
ignore: ci/vocab.txt
```

#### Key summary

| Name | Type | Description |
| :--- | :--- | :--- |
| `aff` | `string` | The fully-qualified path to a Hunspell-compatible `.aff` file. |
| `custom` | `bool` | Turn off the default filters for acronyms, abbreviations, and numbers. |
| `dic` | `string` | The fully-qualified path to a Hunspell-compatible `.dic` file. |
| `filters` | `array` | An array of patterns to ignore during spell checking. |
| `ignore` | `string` | A relative path \(from `StylesPath`\) to a personal vocabulary file consisting of one word per line to ignore. |

`spelling` implements spell checking based on Hunspell-compatible dictionaries. By default, Vale includes [en\_US-web](https://github.com/errata-ai/en_US-web)—an up-to-date, actively maintained dictionary. However, you may also specify your own via the `dic` and `aff` keys \(the fully-qualified paths are required; e.g., `/usr/share/hunspell/en_US.dic`\).

`spelling` also accepts an `ignore` file, which consists of one word per line to be ignored during spell checking. You may further customize the spell-checking experience by defining _filters_:

```yaml
extends: spelling
message: "Did you really mean '%s'?"
level: error
# This disables the built-in filters. If you omit this key or set it to false,
# custom filters (see below) are added on top of the built-in ones.
#
# By default, Vale includes filters for acronyms, abbreviations, and numbers.
custom: true
# A "filter" is a regular expression specifying words to ignore during spell
# checking.
filters:
  # Ignore all words starting with 'py' -- e.g., 'PyYAML'.
  - '[pP]y.*\b'
# Vale will search for these files under $StylesPath -- so, vocab.txt is assumed
# to be $StylesPath/vocab.txt.
ignore:
  - vocab.txt
```

## Built-in style

{% hint style="info" %}
**Note**: Prior to Vale v2.0, the built-in style was named `vale` \(lowercase\).
{% endhint %}

Vale comes with a single built-in style named `Vale` that implements two rules, as described in the table below.

| Rule | Scope | Level | Description |
| :--- | :--- | :--- | :--- |
| `Vale.Spelling` | `text` | `error` | Spell checks text while respecting the words listed in a `$StylesPath/vocab.txt` ignore file. |
| `Vale.Repetition` | `text` | `error` | Looks for instances of repeated words such as "the the" or "this this." |

## Third-party styles

Vale has a growing selection of pre-made styles available for download from its [style library](https://github.com/errata-ai/styles).

