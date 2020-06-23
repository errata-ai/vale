# go regexp + RE2 DFA port

`import "matloob.io/regexp"`

See [golang.org/cl/12081](https://golang.org/cl/12081)

* The regexp tests pass. Though there may still be uncaught bugs.

  Let me know if you find any of them! No guarantees!

* regexp/internal/dfa tests are currently failing. I need to fix

  some thingsn there.

* I've got a small change to the DFA that uses package unsafe

  and makes matches 2x faster. I'll try to get it up soon.

* A bunch of cleanup needs to be done all over this package.

