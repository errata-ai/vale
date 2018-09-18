## Using the CLI

At its core, Vale is designed to be used as a command-line tool. Its general usage information is given below:

```text
$ vale --help
NAME:
   vale - A command-line linter for prose.

USAGE:
   vale [global options] command [command options] [arguments...]

VERSION:
   vx.x.x

COMMANDS:
     dump-config, dc  Dumps configuration options to stdout and exits
     new              Generates a template for the given extension point
     help, h          Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --glob value     a glob pattern (e.g., --glob='*.{md,txt}') (default: "*")
   --config value   a file path (e.g., --config='some/file/path')
   --output value   output style ("line" or "JSON") (default: "CLI")
   --ext value      extension to associate with stdin (default: ".txt")
   --no-wrap        don't wrap CLI output
   --no-exit        don't return a nonzero exit code on lint errors
   --sort           sort files by their name in output
   --normalize      replace each path separator with a slash ('/')
   --ignore-syntax  lint all files line-by-line
   --relative       return relative paths
   --help, -h       show help
   --version, -v    print the version
```

!!! tip "NOTE"

    Vale's `--glob` argument accepts the [standard syntax](http://tldp.org/LDP/GNU-Linux-Tools-Summary/html/x11655.htm). Additionally, any pattern prefixed with an `!` will be negated.

You can run Vale on single files or entire directories. You can also lint only files matching a particular glob:

```bash
$ vale --glob='*.{md,rst}' some-directory
```

Or exclude files matching a particular glob:


```bash
$ vale --glob='!*.txt' directory
```

## Editor Integration

<!-- vale docs.Branding = NO -->

<p>
<a href="https://github.com/TimKam/atomic-vale"><img alt="Atom Logo" src="../img/atom.png" title="Atom" width="68" height="68"></a>

<a href="https://github.com/ValeLint/SubVale"><img alt="Sublime Text Logo" src="../img/sublime.png" title="Sublime Text" width="64" height="64"></a>

<a href="https://github.com/w0rp/ale"><img alt="Vim Logo" src="../img/vim.png" title="Vim (ALE)" width="64" height="64"></a>

<a href="https://github.com/abingham/flycheck-vale"><img alt="Emacs Logo" src="../img/emacs.png" title="Emacs" width="64" height="64"></a>

<a href="https://marketplace.visualstudio.com/items?itemName=lunaryorn.vale"><img alt="VS Code Logo" src="../img/vscode.png" title="Visual Studio Code" width="64" height="64"></a>
</p>

<!-- vale docs.Branding = YES -->
