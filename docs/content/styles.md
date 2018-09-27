## Introduction

Vale has a powerful extension system that doesn't require knowledge of any programming language. Instead, it exposes its functionality through simple
[YAML](http://yaml.org) files.

The core component of Vale's extension system are collections of writing guidelines called *styles*. These guidelines are expressed through *rules*, which are YAML files enforcing a particular writing construct&mdash;e.g., ensuring a certain readability level, sentence length, or heading style.

Styles are organized in a hierarchical folder structure at a user-specified location (see [Configuration](/vale/config/) for more details). For example,

```
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

where *base*, *blog*, and *docs* are your styles.

## Extension Points

The building blocks behind Vale's styles are rules, which utilize extension points to perform specific tasks.

The basic structure of a rule consists of a small header (shown below) followed by extension-specific arguments.

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

!!! tip "NOTE"

    Vale uses Go's [`regexp` package](https://golang.org/pkg/regexp/syntax/) to evaluate all patterns in rule definitions. This means that lookarounds and backreferences are not supported.


<!-- vale 18F.Clarity = NO -->

### `existence`

**Example Definition:**

--8<-- "api/existence/example.md"

**Key Summary:**

--8<-- "api/existence/keys.md"

The most general extension point is `existence`. As its name implies, it looks
for the "existence" of particular tokens.

These tokens can be anything from simple phrases (as in the above example) to complex regular expressions&mdash;e.g., [the number of spaces between sentences](https://github.com/errata-ai/vale-boilerplate/blob/master/src/18F/Spacing.yml) and [the position of punctuation after quotes](https://github.com/errata-ai/vale-boilerplate/blob/master/src/18F/Quotes.yml).

You may define the tokens as elements of lists named either `tokens`
(shown above) or `raw`. The former converts its elements into a word-bounded,
non-capturing group. For instance,

```yaml
tokens:
  - appears to be
  - arguably
```

becomes `\b(?:appears to be|arguably)\b`.

`raw`, on the other hand, simply concatenates its elements&mdash;so, something
like

```yaml
raw:
  - '(?:foo)\sbar'
  - '(baz)'</code></pre>
```

becomes `(?:foo)\sbar(baz)`.


### `substitution`

**Example Definition:**

--8<-- "api/substitution/example.md"

**Key Summary:**

--8<-- "api/substitution/keys.md"

`substitution` associates a string with a preferred form. If we want to suggest
the use of "plenty" instead of "abundance," for example, we'd write:

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

**Example Definition:**

--8<-- "api/occurrence/example.md"

**Key Summary:**

--8<-- "api/occurrence/keys.md"

`occurrence` limits the number of times a particular token can appear in a given scope. In the example above, we're limiting the number of words per sentence.

This is the only extension point that doesn't accept a format specifier in its message.

### `repetition`

**Example Definition:**

--8<-- "api/repetition/example.md"

**Key Summary:**

--8<-- "api/repetition/keys.md"

`repetition` looks for repeated occurrences of its tokens. If `ignorecase` is set to `true`, it'll convert all tokens to lower case for comparison purposes.

### `consistency`

**Example Definition:**

--8<-- "api/consistency/example.md"

**Key Summary:**

--8<-- "api/consistency/keys.md"

`consistency` will ensure that a key and its value (e.g., "advisor" and "adviser") don't both occur in its scope.

### `conditional`

**Example Definition:**

--8<-- "api/conditional/example.md"

**Key Summary:**

--8<-- "api/conditional/keys.md"

`conditional` ensures that the existence of `first` implies the existence of `second`. For example, consider the following text:

<!-- vale off -->

> According to Wikipedia, the World Health Organization (WHO) is a specialized agency of the United Nations that is concerned with international public health. We can now use WHO because it has been defined, but we can't use DAFB because people may not know what it represents. We can use DAFB when it's presented as code, though.

<!-- vale on -->

Running `vale` on the above text with our example rule yields the following:

```shell
test.md:1:224:vale.UnexpandedAcronyms:'DAFB' has no definition
```

`conditional` also takes an optional `exceptions` list. Any token listed as an exception won't be flagged.

### `capitalization`

**Example Definition:**

--8<-- "api/capitalization/example.md"

**Key Summary:**

--8<-- "api/capitalization/keys.md"

`capitalization` checks that the text in the specified scope matches the case of `match`. There are a few pre-defined variables that can be passed as matches:

<!-- vale off -->

- `$title`: "The Quick Brown Fox Jumps Over the Lazy Dog."
- `$sentence`: "The quick brown fox jumps over the lazy dog."
- `$lower`: "the quick brown fox jumps over the lazy dog."
- `$upper`: "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG."

<!-- vale on -->

Additionally, when using `match: $title`, you can specify a style of either AP or Chicago.

### `readability`

**Example Definition:**

--8<-- "api/readability/example.md"

**Key Summary:**

--8<-- "api/readability/keys.md"

`readability` calculates a readability score according the specified metrics. The supported tests are Gunning-Fog, Coleman-Liau, Flesch-Kincaid, SMOG, and Automated Readability.

If more than one is listed (as seen above), the scores will be averaged. This is also the only extension point that doesn't accept a scope, as readability is always calculated using the entire document.

`grade` is the highest acceptable score. Using the example above, a warning will be issued if `grade` exceeds 8.

### `spelling`

**Example Definition:**

```yaml
--8<-- "api/spelling/example.yml"
```

**Key Summary:**

--8<-- "api/spelling/keys.md"

`spelling` implements spell checking based on Hunspell-compatible dictionaries. By default, Vale includes [en_US-web](https://github.com/errata-ai/en_US-web)—an up-to-date, actively maintained dictionary. However, you may also specify your own via the `dic` and `aff` keys (the fully-qualified paths are required; e.g., `/usr/share/hunspell/en_US.dic`).

`spelling` also accepts an `ignore` file, which consists of one word per line to be ignored during spell checking. You may further customize the spell-checking experience by defining *filters*:

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
  - '[pP]y.*\b'  # Ignore all words starting with 'py' -- e.g., 'PyYAML'.
ignore: ci/vocab.txt
```

<!-- vale 18F.Clarity = YES -->
