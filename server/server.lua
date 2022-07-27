
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
RegisterServerEvent("Infram:globalEvent")
AddEventHandler("Infram:globalEvent", function(options)
    TriggerClientEvent("Infram:eventHandler", -1, options["event"] or "none", options["data"] or nil)
end)

RegisterServerEvent("Infram:Win")
AddEventHandler("Infram:Win", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    print(xPlayer.source)
    xPlayer.addMoney(math.random(Config.RandomCash[1], Config.RandomCash[2]))
    -- z napadu uzyskałeś
end)
