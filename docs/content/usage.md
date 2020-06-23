# Using the CLI

At its core, Vale is designed to be used as a command-line tool. The available commands and options are discussed below.

* `dc` / `dump-config`:

  ```text
    $ vale dc
    ...
  ```

  The `dump-config` command prints Vale's configuration, as read from its [`.vale.ini`](https://errata-ai.github.io/vale/config/) file, to `stdout`.

* `new`:

  ```text
    $ vale new existence
    ...
  ```

  The `new` command generates an example implementation for the given extension point.

* `-h` / `--help`:

  ```text
    $ vale -h
    ...
  ```

  The `--help` option prints Vale's CLI usage information to `stdout`.

* `--glob`:

  ```text
    # Only search `.md` and `.rst` files
    $ vale --glob='*.{md,rst}' directory
  ```

  The `--glob` option specifies the type of files Vale will search. It accepts the [standard GNU/Linux syntax](https://github.com/gobwas/glob). Additionally, any pattern prefixed with an `!` will be negated. For example,

  ```text
    # Exclude `.txt` files
    $ vale --glob='!*.txt' directory
  ```

  This option takes precedence over any patterns defined in a [configuration file](https://errata-ai.github.io/vale/config/).

* `--config`:

  ```text
    $ vale --config='some/file/path/.vale.ini'
  ```

  The `--config` option specifies the location of a \[configuration file\]\(\([https://errata-ai.github.io/vale/config/](https://errata-ai.github.io/vale/config/)\)\). This will take precedence over the [default search process](https://errata-ai.github.io/vale/config/#basics).

* `--output`:

  ```text
    # "line", "JSON", or "CLI" (the default)
    $ vale --output=JSON directory
  ```

  The `--output` option specifies the format that Vale will use to report its alerts.

* `--ext`:

  ```text
    $ vale --ext='.md' '# this is a heading'
  ```

  The `--ext` option allows you to assign a format \(e.g., `.md`\) to text passed via `stdin` \(which will default to `.txt`\).

* `--no-wrap`:

  ```text
    $ vale --no-wrap directory
  ```

  The `--no-wrap` option disables word wrapping when using the `CLI` output format. By default, `CLI` output will be wrapped to fit your console.

* `--no-exit`:

  ```text
    $ vale --no-exit directory
  ```

  The `--no-exit` option instructs Vale to always return an exit code of `0`, even if errors were found. This is useful if you don't want CI builds to fail on Vale-related errors.

* `--sort`:

  ```text
    $ vale --sort directory
  ```

  The `--sort` option instructs Vale to sort its output by file path. For large directories, this can have a noticeable negative impact on performance.

* `--ignore-syntax`:

  ```text
    $ vale --ignore-syntax directory
  ```

  The `--ignore-syntax` option will cause Vale to _parse_ all files as plain text. Note, though, that this doesn't change what files Vale will _search_.

  This will often boost performance significantly, but only `text`-scoped rules will work.

* `-v` / `--version`:

  ```text
    $ vale -v
    ...
  ```

  The `--version` option prints Vale's version.

* `--debug`:

  ```text
    $ vale --debug test.md
    ...
  ```

  The `--debug` option instructs Vale to print debugging information to `stdout`.

