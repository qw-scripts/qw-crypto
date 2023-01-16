local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('qw-crypto:server:getCryptoInfo', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local cryptoWorth = exports['qb-crypto']:GetCurrentCryptoWorth()
    local playerWallet = math.floor(Player.PlayerData.money.crypto * 100) / 100

    local data = {
        cryptoWorth = cryptoWorth,
        playerWallet = playerWallet
    }
    cb(data)
end)