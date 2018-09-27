```yml
extends: conditional
message: "'%s' has no definition"
level: warning
scope: text
first: \b([A-Z]{3,5})\b
second: (?:\b[A-Z][a-z]+ )+\(([A-Z]{3,5})\)
exceptions:
  - ABC
```
