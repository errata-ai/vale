1. `exec`, `eval` and `compile`: These dynamic features of CPython are not
   supported by Grumpy because Grumpy modules consist of statically-compiled Go
   code. Supporting dynamic execution would require bundling Grumpy programs
   with the compilation toolchain, which would be unwieldy and impractically
   slow.

**Tip:** At the time of this writing, some of the features discussed in this book have been implemented in various browsers (Firefox, Chrome, etc.), but some have only been partially implemented and many others have not been implemented at all. Your experience may be mixed trying these examples directly. If so, try them out with transpilers, as most of these features are covered by those tools. ES6Fiddle (http://www.es6fiddle.net/) is a great, easy-to-use playground for trying out ES6, as is the online REPL for the Babel transpiler (http://babeljs.io/repl/).

- Do not capitalize HTML elements in code examples
- here is another list item.
- here is another list item.

Here's a quote: "foo bar baz".

a `.jshintrc` file;

```js
// Bad
if(condition) doSomething();
while(!condition) iterating++;
for(var i=0;i<100;i++) object[array[i]] = someFn(i);
```
