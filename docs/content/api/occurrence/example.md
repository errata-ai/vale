```yml
extends: occurrence
message: "Sentences should be less than 25 words"
scope: sentence
level: suggestion
max: 25
token: '\b(\w+)\b'
```
