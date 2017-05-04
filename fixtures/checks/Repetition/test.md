Like the arithmetic operators, bitwise operators are syntactic sugar for calls
to methods of built-in traits. This means bitwise operators can be overridden
for user-defined types. The default meaning of the operators on standard types
is given here. Bitwise `&`, `|` and `^` applied to boolean arguments are
equivalent to logical `&&`, `||` and `!=` evaluated in non-lazy fashion.
