# NOTE: This is a single comment line

#=
  NOTE: I am a mlutiline comment, but i use words that are
  obviously maybe avoidable
=#

function NOTE()
    # NOTE: I am a comment inside a function
    return 1
end

"""
    f(x)

I am a simple doc string of a quadratic function. TODO
This is Markdown and hence the first line is just a code block

TODO
"""
TODO(x) = x^2 # NOTE: this is another comment.

raw"""
    g(x)

I am an example doc string, which is also in Markdown,
just that math is in ``g(x) = x^3`` two backticks

XXX: here too.
"""
function g(x)
    return x^3
end

@doc raw"""
    h(x)

I am an example doc string, which has one further macro (`@doc`) upfront,
there might also be other macros or string types (besides raw and doc) upfront.

NOTE: I am a comment in the doc string.
"""
function XXX(x)
    return x^4
end

# XXX: single strings could also be doc strings I think.

function i(x)
    TODO = 10
    println("I am just a single line string")
    return x^5
end
