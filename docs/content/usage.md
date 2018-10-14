## Using the CLI

At its core, Vale is designed to be used as a command-line tool. The available
commands and options are discussed below.

- `dc` / `dump-config`:

    ```shell
    $ vale dc
    ...
    ```

    The `dump-config` command prints Vale's configuration, as read from its
    [`.vale.ini`](https://errata-ai.github.io/vale/config/) file, to `stdout`.

- `new`:

    ```shell
    $ vale new existence
    # Save as MyRule.yml on your StylesPath
    # See https://errata-ai.github.io/vale/styles/ for more info
    # "suggestion", "warning" or "error"
    level: warning
    # Text describing this rule (generally longer than 'message').
    description: '...'
    # A link the source or reference.
    link: '...'
    extends: existence
    # "%s" will be replaced by the active token
    message: "found '%s'!"
    ignorecase: false
    tokens:
      - XXX
      - FIXME
      - TODO
      - NOTE
    ```

    The `new` command generates an example implementation for the given
    extension point (`existence` in the example above).

- `-h` / `--help`:

    ```shell
    $ vale -h
    ...
    ```

    The `--help` option prints Vale's CLI usage information to `stdout`.

- `--glob`:

    ```shell
    # Only search `.md` and `.rst` files
    $ vale --glob='*.{md,rst}' directory
    ```

    The `--glob` option specifies the type of files Vale will search. It
    accepts the [standard GNU/Linux syntax](http://tldp.org/LDP/GNU-Linux-Tools-Summary/html/x11655.htm).
    Additionally, any pattern prefixed with an `!` will be negated. For example,

    ```shell
    # Exclude `.txt` files
    $ vale --glob='!*.txt' directory
    ```

    This option takes precedence over any patterns defined in a
    [configuration file]((https://errata-ai.github.io/vale/config/)).

- `--config`:

    ```shell
    $ vale --config='some/file/path/.vale.ini'
    ```

    The `--config` option specifies the location of a
    [configuration file]((https://errata-ai.github.io/vale/config/)). This will
    take precedence over the [default search process](https://errata-ai.github.io/vale/config/#basics).

- `--output`:

    ```shell
    # "line", "JSON", or "CLI" (the default)
    $ vale --output=JSON directory
    ```

    The `--output` option specifies the format that Vale will use to report its
    alerts.

- `--ext`:

    ```shell
    $ vale --ext='.md' '# this is a heading'
    ```

    The `--ext` option allows you to assign a format (e.g., `.md`) to text passed via
    `stdin` (which will default to `.txt`).

- `--no-wrap`:

    ```shell
    $ vale --no-wrap directory
    ```

    The `--no-wrap` option disables word wrapping when using the `CLI` output
    format. By default, `CLI` output will be wrapped to fit your console.

- `--no-exit`:

    ```shell
    $ vale --no-exit directory
    ```

    The `--no-exit` option instructs Vale to always return an exit code of `0`,
    even if errors were found. This is useful if you don't want CI builds to
    fail on Vale-related errors.

- `--sort`:

    ```shell
    $ vale --sort directory
    ```

    The `--sort` option instructs Vale to sort its output by file path. For
    large directories, this can have a noticeable negative impact on performance.

- `--ignore-syntax`:

    ```shell
    $ vale --ignore-syntax directory
    ```

    The `--ignore-syntax` option will cause Vale to *parse* all files as plain
    text. Note, though, that this doesn't change what files Vale will *search*.

    This will often boost performance significantly, but only `text`-scoped
    rules will work.

- `-v` / `--version`:

    ```shell
    $ vale -v
    ...
    ```

    The `--version` option prints Vale's version.

## Editor Integration

<!-- vale docs.Branding = NO -->

<p>
<a href="https://github.com/TimKam/atomic-vale"><img alt="Atom Logo" src="../img/atom.png" title="Atom" width="68" height="68"></a>

<a href="https://packagecontrol.io/packages/SublimeLinter-contrib-vale"><img alt="Sublime Text Logo" src="../img/sublime.png" title="Sublime Text" width="64" height="64"></a>

<a href="https://github.com/w0rp/ale"><img alt="Vim Logo" src="../img/vim.png" title="Vim (ALE)" width="64" height="64"></a>

<a href="https://github.com/abingham/flycheck-vale"><img alt="Emacs Logo" src="../img/emacs.png" title="Emacs" width="64" height="64"></a>

<a href="https://marketplace.visualstudio.com/items?itemName=lunaryorn.vale"><img alt="VS Code Logo" src="../img/vscode.png" title="Visual Studio Code" width="64" height="64"></a>
</p>

<!-- vale docs.Branding = YES -->
