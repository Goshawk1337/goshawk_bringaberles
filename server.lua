ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("nwrp_esx:checkMoney", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= Config.Osszeg then
        xPlayer.removeMoney(Config.Osszeg)
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent("nwrp_esx:giveItem")
AddEventHandler("nwrp_esx:giveItem", function(amount, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem("vehgps", 1)
end)

RegisterServerEvent("nwrp_esx:penzvissza")
AddEventHandler("nwrp_esx:penzvissza", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.addMoney(Config.Osszeg)
end)

RegisterServerEvent("nwrp_esx:removeItem")
AddEventHandler("nwrp_esx:removeItem", function(amount, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem("vehgps", 1)
end)
