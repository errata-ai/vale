---
description: >-
  Vale is a syntax-aware linter for prose built with speed and extensibility in
  mind.
---

# Quick Start



![Example Vale output using a custom style \(18F\)](https://user-images.githubusercontent.com/8785025/71751520-ab91fa00-2e30-11ea-9e67-6e2babb5d0ee.png)

**Vale** is a cross-platform \(macOS, Windows, and Linux\), command-line [linter](https://en.wikipedia.org/wiki/Lint_%28software%29) for prose built with speed and extensibility in mind. Its key features are as follows:

* [Markup support](getting-started/markup.md): Vale supports HTML, Markdown, AsciiDoc, reStructuredText, XML, and DITA—allowing it to avoid most syntax-related false positives.
* [Extensibility](getting-started/styles.md): Unlike most writing-related software, Vale's primary purpose isn't to provide its own advice; it's designed to enforce an existing style guide through its YAML-based extension system.
* [Performance](https://gist.github.com/jdkato/02bb9db72cf6d36c7a52d8b075bdb5df#file-perf-md): Vale typically takes less than 1 second to lint most files, making it fast enough to be included in test suites for large \(&gt; 1,000 files\) repositories.

No matter if you're working with a small in-house standard or a large editorial style guide, Vale will help you maintain consistent and error-free writing.

### Installation

{% hint style="info" %}
If you're using Vale with a markup format other than **Markdown** or **HTML**, you'll also need to install a [parser](getting-started/markup.md#formats).
{% endhint %}

{% tabs %}
{% tab title="macOS" %}
```bash
# See https://formulae.brew.sh/
$ brew install vale
```
{% endtab %}

{% tab title="Windows" %}
```bash
# See https://chocolatey.org/packages/vale
> choco install vale
```
{% endtab %}

{% tab title="Linux" %}
```bash
# See https://docs.brew.sh/Homebrew-on-Linux
$ brew install vale
```

Or use another [package manager](https://repology.org/project/vale/versions).
{% endtab %}
{% endtabs %}

See the dedicated [Installation section](getting-started/installation.md) for more detailed instructions and options.

### Usage

Download or clone [Vale's example repository](https://github.com/errata-ai/vale-boilerplate) and follow the command-line steps below:

```bash
$ cd vale-boilerplate
# Check your version of Vale:
$ vale -h
# Run Vale on the sample content:
$ vale README.md

 README.md
 13:20   warning  'extremely' is a weasel word!  write-good.Weasel    
 15:120  warning  'However' is too wordy.        write-good.TooWordy  
 27:6    warning  'is' is repeated!              write-good.Illusions 

✖ 0 errors, 3 warnings and 0 suggestions in 1 file.
```

