Vale has three configuration components:

- A `.vale.ini` (required): This is where you'll control the majority of Vale's behavior, including
  what files to lint and how to lint them. See the next section for more information.

- A `StylesPath` directory (optional): This is where you'll store all of Vale's optional external
  resources.

- [Custom styles](/vale/styles) (optional): Custom styles are a means of teaching Vale new
  guidelines to lint against.

## `.vale.ini`

```ini
# Example Vale config file (`.vale.ini` or `_vale.ini`)

# Core settings
StylesPath = ci/vale/styles

# The minimum alert level to display (suggestion, warning, or error).
#
# CI builds will only fail on error-level alerts.
MinAlertLevel = warning

# The "formats" section allows you to associate an "unknown" format
# with one of Vale's supported formats.
[formats]
mdx = md

# Global settings (applied to every syntax)
[*]
# List of styles to load
BasedOnStyles = write-good, Joblint
# Style.Rule = {YES, NO} to enable or disable a specific rule
vale.Editorializing = YES
# You can also change the level associated with a rule
vale.Hedging = error

# Syntax-specific settings
# These overwrite any conflicting global settings
[*.{md,txt}]
vale.Editorializing = NO
```

Vale expects its configuration to be in a file named `.vale.ini` or `_vale.ini`. It'll start looking for this file in the same directory as the file that's being linted. If it can't find one, it'll search up to 6 levels up the directory tree. After 6 levels, it'll look for a global configuration file in the OS equivalent of `$HOME` (see below).

| OS      | Search Locations                                     |
|:--------|:-----------------------------------------------------|
| Windows | `$HOME`, `%UserProfile%`, or `%HomeDrive%%HomePath%` |
| macOS   | `$HOME`                                              |
| Linux   | `$HOME`                                              |

If more than one configuration file is present, the closest one takes precedence.

### Available Options

- `StylesPath` (core):

    ```ini
    # Here's an example of a relative path:
    #
    # .vale.ini
    # ci/
    # ├── vale/
    # │   ├── styles/
    StylesPath = ci/vale/styles
    ```

    `StylesPath` specifies where Vale should look for its external resources
    (e.g., styles and ignore files). The path value may be absolute or relative
    to the location of the parent `.vale.ini` file.

- `MinAlertLevel` (core):

    ```ini
    MinAlertLevel = suggestion
    ```

    `MinAlertLevel` specifies the minimum alert severity that Vale will report. The options are
    "suggestion," "warning," or "error" (defaults to "suggestion").

- `IgnoredScopes` (core):

    ```ini
    # By default, `code` and `tt` are ignored.
    IgnoredScopes = code, tt
    ```

    `IgnoredScopes` specifies inline-level HTML tags to ignore. In other words, these tags may
    occur in an active scope (see `SkippedScopes`) but their content still won't raise any alerts.

- `SkippedScopes` (core):

    ```ini
    # By default, `script`, `style`, `pre`, and `figure` are ignored.
    SkippedScopes = script, style, pre, figure
    ```

    `SkippedScopes` specifies block-level HTML tags to ignore. Any content in these scopes will be
    ignored.

- `WordTemplate` (core):

    ```ini
    WordTemplate = `\b(?:%s)\b`
    ```

    `WordTemplate` specifies what Vale will consider to be an individual word.

- `BasedOnStyles` (syntax-specific):

    ```ini
    BasedOnStyles = Joblint, write-good
    ```

    `BasedOnStyles` specifies [styles](/vale/styles) that should have all of their rules enabled.

- `BlockIgnores` (syntax-specific):

    ```ini
    BlockIgnores = (?s) *({< file [^>]* >}.*?{</ ?file >})
    ```

    `BlockIgnores` allow you to exclude certain block-level sections of text
    that don't have an associated HTML tag that could be used with
    `SkippedScopes`. See [Non-Standard Markup](https://errata-ai.github.io/vale/formats/#non-standard-markup)
    for more information.

- `TokenIgnores` (syntax-specific):

    ```ini
    TokenIgnores = (\$+[^\n$]+\$+)
    ```

    `TokenIgnores` allow you to exclude certain inline-level sections of text
    that don't have an associated HTML tag that could be used with
    `IgnoredScopes`. See
    [Non-Standard Markup](https://errata-ai.github.io/vale/formats/#non-standard-markup)
    for more information.

- `Transform` (syntax-specific):

    ```ini
    Transform = docbook-xsl-snapshot/html/docbook.xsl
    ```

    `Transform` specifies a version 1.0 XSL Transformation (XSLT) for converting to HTML. See [Formats#XML](https://errata-ai.github.io/vale/formats/#XML) for more information.

## Ignoring Parts of Your Documents

```callout{'title': 'NOTE', 'classes': ['tip']}
Vale currently does not support comment-based configuration in AsciiDoc documents.
```

Ignore parts of your HTML and Markdown documents using HTML-style comments:

```html
<!-- vale off -->

This is some text

more text here...

<!-- vale on -->

<!-- vale Style.Rule = NO -->

This is some text

<!-- vale Style.Rule = YES -->
```

Ignore parts of your reStructuredText documents:

```rst
.. vale off

This is some text

.. vale on

```

Vale also ignores specific tags for each supported [markup language](/vale/formats).
