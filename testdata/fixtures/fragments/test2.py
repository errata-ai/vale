"""
This module defines pdoc's documentation objects. A documentation object
corresponds to *something* in your Python code that has a docstring or type
annotation. Typically, this only includes modules, classes, functions and
methods. However, `pdoc` adds support for extracting documentation from the
abstract syntax tree, which means that variables (module, class or instance)
are supported too.

There are four main types of documentation objects:

- `Module`
- `Class`
- `Function`
- `Variable`

All docmentation types make heavy use of `@functools.cached_property`
decorators.

This means they have a large set of attributes that are lazily computed on
first access.

By convention, all attributes are read-only, although this is not enforced at
runtime.
"""
from __future__ import annotations

import enum
import inspect
import os
import pkgutil
import re
import sys
import textwrap
import traceback
import types
import warnings
from abc import ABCMeta, abstractmethod
from collections.abc import Callable
from functools import wraps
from pathlib import Path
from typing import Any, ClassVar, Generic, TypeVar, Union

from pdoc import doc_ast, doc_pyi, extract
from pdoc.doc_types import (
    GenericAlias,
    NonUserDefinedCallables,
    empty,
    resolve_annotations,
    safe_eval_type,
)

from ._compat import cache, cached_property, formatannotation, get_origin


def _include_fullname_in_traceback(f):
    """
    `Doc.__repr__` should not raise, but it may raise if we screwed up.

    Debugging this is a bit tricky, because, well, we can't repr() in the
    traceback either then.

    This decorator adds location information to the traceback, which helps
    tracking down bugs.
    """

    @wraps(f)
    def wrapper(self):
        try:
            return f(self)
        except Exception as e:
            raise RuntimeError(f"Error in {self.fullname}'s repr!") from e

    return wrapper


T = TypeVar("T")


class Doc(Generic[T]):
    """
    A base class for all documentation objects.
    """

    modulename: str
    """
    The module that this object is in, for example `pdoc.doc`.
    """

    qualname: str
    """
    The qualified identifier name for this object. For example, if we have the
    following code:

    ```python
    class Foo:
        def bar(self):
            pass
    ```

    The qualname of `Foo`'s `bar` method is `Foo.bar`. The qualname of the
    `Foo` class is just `Foo`.

    See <https://www.python.org/dev/peps/pep-3155/> for details.
    """

    obj: T
    """
    The underlying Python object.
    """

    taken_from: tuple[str, str]
    """
    `(modulename, qualname)` of this doc object's original location.

    In the context of a module, this points to the location it was imported
    from, in the context of classes, this points to the class an attribute is
    inherited from.
    """

    def __init__(
        self, modulename: str, qualname: str, obj: T,
        taken_from: tuple[str, str]
    ):
        """
        Initializes a documentation object, where `modulename` is the name this
        module is defined in, `qualname` contains a dotted path leading to the
        object from the module top-level, and `obj` is the object to document.
        """
        self.modulename = modulename
        self.qualname = qualname
        self.obj = obj
        self.taken_from = taken_from

    @cached_property
    def fullname(self) -> str:
        """
        The full qualified name of this doc object, for example `pdoc.doc.Doc`.
        """
        # qualname is empty for modules
        return f"{self.modulename}.{self.qualname}".rstrip(".")

    @cached_property
    def name(self) -> str:
        """
        The name of this object. For top-level functions and classes, this is
        equal to the qualname attribute.
        """
        return self.fullname.split(".")[-1]

    @cached_property
    def docstring(self) -> str:
        """
        The docstring for this object. It has already been cleaned by
        `inspect.cleandoc`.

        If no docstring can be found, an empty string is returned.
        """
        return _safe_getdoc(self.obj)

    @cached_property
    def source(self) -> str:
        """
        The source code of the Python object as a `str`.

        If the source cannot be obtained (for example, because we are dealing
        with a native C object), an empty string is returned.
        """
        return doc_ast.get_source(self.obj)

    @cached_property
    def source_file(self) -> Path | None:
        """
        The name of the Python source file in which this object was defined.

        `None` for built-in objects.
        """
        try:
            return Path(
                inspect.getsourcefile(self.obj) or inspect.getfile(self.obj)
            )  # type: ignore
        except TypeError:
            return None

    @cached_property
    def source_lines(self) -> tuple[int, int] | None:
        """
        Return a `(start, end)` line nuber tuple for this object.
        If no source file can be found, `None` is returned.
        """
        try:
            lines, start = inspect.getsourcelines(self.obj)  # type: ignore
            return start, start + len(lines) - 1
        except Exception:
            return None

    @cached_property
    def is_inherited(self) -> bool:
        """
        If True, the doc object is inherited from another location.

        This most commonly refers to methods inherited by a subclass,
        but can also apply to variables that are assigned a class defined
        in a different module.
        """
        return (self.modulename, self.qualname) != self.taken_from

    @classmethod
    @property
    def type(cls) -> str:
        """
        The type of the doc object, either `"module"`, `"class"`, `"function"`,
        or `"variable"`.
        """
        return cls.__name__.lower()

    if sys.version_info < (3, 9):  # pragma: no cover
        # no @classmethod @property in 3.8
        @property
        def type(self) -> str:  # noqa
            return self.__class__.__name__.lower()

    def __lt__(self, other):
        assert isinstance(other, Doc)
        return self.fullname.replace("__init__", "").__lt__(
            other.fullname.replace("__init__", "")
        )


class Namespace(Doc[T], metaclass=ABCMeta):
    """
    A documentation object that can have children. In other words, either a
    module or a class.
    """

    @cached_property
    @abstractmethod
    def _member_objects(self) -> dict[str, Any]:
        """
        A mapping from *all* public and private member names to their Python
        objects.
        """

    @cached_property
    @abstractmethod
    def _var_docstrings(self) -> dict[str, str]:
        """A mapping from some member vaiable names to their docstrings."""

    @cached_property
    @abstractmethod
    def _var_annotations(self) -> dict[str, Any]:
        """
        A mapping from some member vaiable names to their type annotations.
        """

    @abstractmethod
    def _taken_from(self, member_name: str, obj: Any) -> tuple[str, str]:
        """
        The location this member was taken from. If unknown,
        `(modulename, qualname)` is returned.
        """
