## Using the CLI

`vale` is a command-line tool for linting prose against style guidelines. Its general usage information is below:

```text
$ vale --help
NAME:
   vale - A command-line linter for prose.

USAGE:
   vale [global options] command [command options] [arguments...]

VERSION:
   vX.X.X

COMMANDS:
     dump-config, dc  Dumps configuration options to stdout and exits
     new              Generates a template for the given extension point
     help, h          Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --glob value     a glob pattern (e.g., --glob='*.{md,txt}') (default: "*")
   --output value   output style ("line", "JSON", or "context") (default: "CLI")
   --ext value      extension to associate with stdin (default: ".txt")
   --no-wrap        don't wrap CLI output
   --no-exit        don't return a nonzero exit code on lint errors
   --sort           sort files by their name in output
   --ignore-syntax  lint all files line-by-line
   --help, -h       show help
   --version, -v    print the version
```
You can run Vale on single files or entire directories. You can also lint only files matching a particular glob:

```bash
$ vale --glob='*.{md,rst}' some-directory
```

Or exclude files matching a particular glob:


```bash
$ vale --glob='!*.min.js' some-directory
```

Vale ships with the following rules:

<!-- vale off -->

| Rule           | Description                                                                        | Severity |
|:--------------:|:----------------------------------------------------------------------------------:|:--------:|
| `Editorializing` |  The use of adverbs or phrases to highlight something as particularly significant. | warning  |
| `GenderBias`     |  The unnecessary use of gender-specific language.                                  |   error  |
| `Hedging`        |  The use of phrases, like "in my opinion," that weaken meaning.                    | warning  |
| `Redundancy`     |  The use of phrases like "ATM machine."                                            |   error  |
| `Repetition`     |  Instances of repeated words, which are often referred to as lexical illusions.    |   error  |
| `Uncomparables`  |  The use of phrases like "very unique."                                            |   error  |

<!-- vale on -->

But Vale's true strength lies in its ability to support *your* style. See [Styles](https://valelint.github.io/docs/styles/) for more information on creating your own style guide.

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

[Editorializing]: https://en.wikipedia.org/wiki/Wikipedia:Manual_of_Style/Words_to_watch#Editorializing
[ComplexWords]: https://plainlanguage.gov/resources/articles/complex-abstract-words/

