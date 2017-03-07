1. `exec`, `eval` and `compile`: These dynamic features of CPython are not
   supported by Grumpy because Grumpy modules consist of statically-compiled Go
   code. Supporting dynamic execution would require bundling Grumpy programs
   with the compilation toolchain, which would be unwieldy and impractically
   slow.
