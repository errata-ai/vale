---
description: Configure Tessera
---

# Configure Tessera

```json
"jdbc": {
    "username": "sa",
    "password": "ENC(ujMeokIQ9UFHSuBYetfRjQTpZASgaua3)",
    "url": "jdbc:h2:/qdata/c1/db1",
    "autoCreateTables": true
}
```

Being a Password-Based Encryptor, Jasypt requires a secret key (password) and a configured algorithm
to encrypt/decrypt this config entry. This password can either be loaded into Tessera from file system
or user input. For file system input, the location of this secret file needs to be set in Environment
Variable `TESSERA_CONFIG_SECRET`

##### How to encrypt database password

1. Place the wrapped output, `ENC(rJ70hNidkrpkTwHoVn2sGSp3h3uBWxjb)`, in the config json file
