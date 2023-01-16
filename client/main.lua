local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qw-crypto:client:openCommerceInput', function(data)

    if data.commerceType == 'buy' then
        local cryptoPurchase = exports['qb-input']:ShowInput({
            header = "Buy Crypto",
            submitText = "Buy",
            inputs = {
                {
                    text = "Number of Coins to Buy", -- text you want to be displayed as a place holder
                    name = "coins", -- name of the input should be unique otherwise it might override
                    type = "number", -- type of the input
                    isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                },
            },
        })

        if cryptoPurchase ~= nil then
            QBCore.Functions.TriggerCallback('qb-crypto:server:BuyCrypto', function(result)
                print(result)
            end, {Coins = cryptoPurchase.coins})
        end
    else
        local cryptoSell = exports['qb-input']:ShowInput({
            header = "Sell Crypto",
            submitText = "Sell",
            inputs = {
                {
                    text = "Number of Coins to Sell", -- text you want to be displayed as a place holder
                    name = "coins", -- name of the input should be unique otherwise it might override
                    type = "number", -- type of the input
                    isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                    -- default = "CID-1234", -- Default text option, this is optional
                },
            },
        })

        if cryptoSell ~= nil then
            QBCore.Functions.TriggerCallback('qb-crypto:server:SellCrypto', function(result)
                if not result then
                    QBCore.Functions.Notify('You can not do that', 'error')
                end
            end, {Coins = cryptoSell.coins})
        end
    end
end)

RegisterNetEvent('qw-crypto:client:openMenu', function() 
    QBCore.Functions.TriggerCallback('qw-crypto:server:getCryptoInfo', function(result)
        exports['qb-menu']:openMenu({
            {
                header = 'Crypto Actions',
                icon = 'fas fa-code',
                isMenuHeader = true, -- Set to true to make a nonclickable title
            },
            {
                header = 'Current Crypto Price',
                txt = '$'..result.cryptoWorth,
                icon = 'fas fa-money-bill',
                disabled = true
            },
            {
                header = 'Current Crypto Wallet',
                txt = result.playerWallet..' Crypto | $'..(result.playerWallet * result.cryptoWorth),
                icon = 'fas fa-money-bill',
                disabled = true
            },
            {
                header = 'Buy Crypto',
                txt = 'Click to buy crypto',
                icon = 'fas fa-money-bill',
                params = {
                    event = 'qw-crypto:client:openCommerceInput',
                    args = {
                        commerceType = 'buy'
                    }
                }
            },
            {
                header = 'Sell Crypto',
                txt = 'Click to sell crypto',
                icon = 'fas fa-money-bill',
                params = {
                    event = 'qw-crypto:client:openCommerceInput',
                    args = {
                        commerceType = 'sell'
                    }
                }
            }
        })
    end)
end)

function createMenuZone()
    local menuZoneCoords = Config.MenuLocation
    local menuZoneName = 'crypto_menu_zone'

    exports['qb-target']:AddBoxZone(menuZoneName, menuZoneCoords,
                                    1.0, 1.0,
                                    {
        name = menuZoneName,
        debugPoly = Config.Debug,
        heading = Config.MenuHeading,
        minZ = Config.MenuMinZ,
        maxZ = Config.MenuMaxZ
    }, {
        options = {
            {
                type = "client",
                action = function()
                    TriggerEvent("qw-crypto:client:openMenu")
                end,
                icon = "fas fa-hand",
                label = "Open Crypto Menu"
            }
        },
        distance = 2.0
    })
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    createMenuZone()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        createMenuZone()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        exports['qb-target']:RemoveZone('crypto_menu_zone')
    end
end)