## About

```callout{'title': 'Heads up!', 'classes': ['success']}
**Tired of the command line?** Vale now has a [cross-platform desktop application](https://errata.ai/vale-server/) that introduces a number of new features.
```

**Vale** is a free, open-source linter for prose built with speed and extensibility in mind.

Unlike most writing aids, Vale's primary purpose isn't to provide its own advice; it's designed to
enforce an existing style guide through its YAML-based [extension system](/vale/styles).

No matter if you're working with a small in-house standard or a large editorial style guide, Vale
will help you maintain consistent and error-free writing.

![Vale Screenshot](img/vale-demo.png)

## Installation

Vale runs on Windows, macOS, and Linux. It can be installed via one of the package managers listed
below or manually by downloading an executable from the
[releases page](https://github.com/errata-ai/vale/releases).

<!-- vale off -->

<div id="quickstart">
    <span data-qs-package="brew">brew tap ValeLint/vale</span>
    <span data-qs-package="brew">brew install vale</span>
    <span data-qs-package="docker">docker pull jdkato/vale</span>
    <span data-qs-package="goreleaser">curl -sfL https://install.goreleaser.com/github.com/ValeLint/vale.sh</span>
</div>

<!-- vale on -->

