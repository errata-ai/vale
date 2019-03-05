## Overview

```callout{'title': 'NOTE', 'classes': ['tip']}
Plugins are currently only supported on Linux and macOS.
```

Vale's built-in [extension points](https://errata-ai.github.io/vale/styles/#extension-points) are designed to cover the majority of linting needs without requiring any programming experience.

In some cases, though, regex-based rules simply aren't powerful enough to adequately express a particular rule or guideline. This is where plugins come into play.

A "plugin" is a Go package that Vale loads at run time, allowing for arbitrary extensions to its built-in functionality. Here's a basic example:

```go
`document{'path': '../../styles/plugins/Example.go'}`
```

With plugins, you have complete access to Go and its [standard library](https://golang.org/pkg/#stdlib), as well as the ability to call scripts from other programming languages using the [`exec`](https://golang.org/pkg/os/exec/) package.

## Creating a Plugin

```callout{'title': 'NOTE', 'classes': ['tip']}
Plugins require Go >= v1.8.0.
```

To create your own plugin, simply export a function returing a `Plugin` as
shown in the example above. The `Rule` implementation can be as complex as you
need and use any aspect of the Go programming language.

After you've created your plugin, place it in `StylesPath/plugins` and compile
it using `-buildmode=plugin`:

```shell
$ go build -buildmode=plugin MyPlugin.go
```

This will produce a shared object (`MyPlugin.so`) containing your plugin's logic.

## Typical Workflow

You'll want to commit your plugin's source file (`.go`) into version control,
but not its shared object (`.so`). This means that if you're using a CI service,
you'll need to build your plugin(s) prior to running Vale. One way to do this is
by creating a `Makefile`:

```cmake
plugins:
	cd styles/plugins/ && \
	go build -buildmode=plugin MyPlugin.go && \
	go build -buildmode=plugin MyOtherPlugin.go
```

You can then run `make plugins` as a CI step.
