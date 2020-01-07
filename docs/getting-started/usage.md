---
description: >-
  At its core, Vale is designed to be used as a command-line tool. The available
  commands and options are discussed below.
---

# Usage

## Commands

### `ls-config / dc`

#### Description

Print the current configuration options \(as JSON\) to `stdout`.

#### Usage

```text
$ vale ls-config
...
```

### `new-rule`

#### Description

Generate a template for the given extension point.

#### Usage

```text
$ vale new-rule EXTENSION_POINT
...
```

Where `EXTENSION_POINT` is one of the available extension points.

## Options

### `-h` / `--help`

#### Description

The `--help` option prints Vale's CLI usage information to `stdout`.

#### Usage

```text
$ vale -h
...
```

### `--glob`

#### Description

The `--glob` option specifies the type of files Vale will search. It accepts the [standard GNU/Linux syntax](https://github.com/gobwas/glob). Additionally, any pattern prefixed with an `!` will be negated. For example,

```bash
# Exclude `.txt` files
  $ vale --glob='!*.txt' directory
```

This option takes precedence over any patterns defined in a [configuration file]().

#### Usage

```bash
# Only search `.md` and `.rst` files
$ vale --glob='*.{md,rst}' directory
```

### `--config`

#### Description

The `--config` option specifies the location of a configuration file. This will take precedence over the [default search process]().

#### Usage

```bash
$ vale --config='some/file/path/.vale.ini'
```

### `--output`

#### Description

The `--output` option specifies the format that Vale will use to report its alerts.

#### Usage

```bash
# "line", "JSON", or "CLI" (the default)
$ vale --output=JSON directory
```

### `--ext`

**Description**

The `--ext` option allows you to assign a format \(e.g., `.md`\) to text passed via `stdin` \(which will default to `.txt`\).

#### Usage

```bash
$ vale --ext='.md' '# this is a heading'
```

### `--no-wrap`

**Description**

The `--no-wrap` option disables word wrapping when using the `CLI` output format. By default, `CLI` output will be wrapped to fit your console.

#### Usage

```bash
$ vale --no-wrap directory
```

### `--no-exit`

**Description**

The `--no-exit` option instructs Vale to always return an exit code of `0`, even if errors were found. This is useful if you don't want CI builds to fail on Vale-related errors.

#### Usage

```text
$ vale --no-exit directory
```

The `--no-exit` option instructs Vale to always return an exit code of `0`, even if errors were found. This is useful if you don't want CI builds to fail on Vale-related errors.

### `--sort`

**Description**

The `--sort` option instructs Vale to sort its output by file path. For large directories, this can have a noticeable negative impact on performance.

#### Usage

```bash
$ vale --sort directory
```

### `--ignore-syntax`

**Description**

The `--ignore-syntax` option will cause Vale to _parse_ all files as plain text. Note, though, that this doesn't change what files Vale will _search_.

This will often boost performance significantly, but only `text`-scoped rules will work.

#### Usage

```text
$ vale --ignore-syntax directory
```

### `-v` / `--version`

**Description**

The `--version` option prints Vale's version.

#### Usage

```text
$ vale -v
...
```

### `--debug`

**Description**

The `--debug` option instructs Vale to print debugging information to `stdout`.

#### Usage

```text
$ vale --debug test.md
...
```

### `--minAlertLevel`

**Description**

The `--minAlertLevel` option sets the minimum alert level to display. This takes precedence over the value set in a configuration file.

#### Usage

```text
$ vale --minAlertLevel LEVEL
```

Where `LEVEL` is `suggestion`, `warning`, or `error`.

