## Basics

Vale looks for its configuration in a file named `.vale.ini` or `_vale.ini`. This file may be located in the current working directory, a parent directory or `$HOME`. If more than one configuration file is present, the closest one takes precedence.

The basic structure of a configuration file is as follows:

```ini
# Core settings
StylesPath = path/to/my/project/styles/directory
MinAlertLevel = warning # suggestion, warning or error

# Global settings (applied to every syntax)
[*]
# List of styles to load
BasedOnStyles = vale, MyCustomStyle
# Style.Rule = {YES, NO} to enable or disable a specific rule
vale.Editorializing = YES
# You can also change the level associated with a rule
vale.Hedging = error
...

# Syntax-specific settings
# These overwrite any conflicting global settings
[*.{md,txt}]
...
```

## Using Comments

!!! tip "NOTE"

    reStructuredText uses `.. vale off` style comments.

Vale also supports context-specific configuration in Markdown, HTML, and reStructuredText documents:

```html
<!-- vale off -->

This is some text

more text here...

<!-- vale on -->

<!-- vale Style.Rule = NO -->

This is some text

<!-- vale Style.Rule = YES -->
```

## Examples

Let's say we're working on a project with Python source code and reStructuredText documentation. Assuming we're using styles named `base` (with general style rules) and `ProjectName` (with project-specific rules), we could have the following configuration:

```ini
StylesPath = styles

[*.{rst,py}]
BasedOnStyles = base, ProjectName
```

If we add another style named `docs` with rules we only want to apply to our documentation, we could change it to:

```ini
[*.rst]
BasedOnStyles = base, ProjectName, docs

[*.py]
BasedOnStyles = base, ProjectName
docs.SomeRule = YES # there's actually one rule we want
```
