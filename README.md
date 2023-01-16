# qw-crypto
QBCore crypto menu for any server that doesn't have a phone or another script that supports it

**IMPORTANT**
you need add this function to `qb-crypto/server/main.lua` for the script to work 

```lua
function GetCurrentCryptoWorth()
    return Crypto.Worth[coin]
end

exports('GetCurrentCryptoWorth', GetCurrentCryptoWorth)
```
