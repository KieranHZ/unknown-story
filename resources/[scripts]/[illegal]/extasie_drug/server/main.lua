ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

local isOutMarker = {}
local treatINProg, sellINProg = {}, {}
--
--
--

AddEventHandler('extasie_drug:treat', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    while not isOutMarker[_source] do
        treatINProg[_source] = true
        Citizen.Wait(Config.Zones.Traitement.ItemTime)
        local QuantityCoffee = xPlayer.getInventoryItem(Config.Zones.Traitement.ItemRequires1).count
        local QuantityLSD = xPlayer.getInventoryItem(Config.Zones.Traitement.ItemRequires).count
        local QuantityExtasie = xPlayer.getInventoryItem(Config.Zones.Traitement.ItemDb_name).count

        if not isOutMarker[_source] then
            if QuantityExtasie >= 100 then
                TriggerClientEvent('esx:showNotification', _source, '~r~Votre inventaire est plein.')
                treatINProg[_source] = false
                return
            elseif QuantityCoffee <= 0 or QuantityLSD <= 0 then
                TriggerClientEvent('esx:showNotification', _source, '~r~Vous n\'avez plus d\'ingrédient à traiter.')
                treatINProg[_source] = false
                return
            else
                xPlayer.addInventoryItem(Config.Zones.Traitement.ItemDb_name, Config.Zones.Traitement.ItemAdd)
                xPlayer.removeInventoryItem(Config.Zones.Traitement.ItemRequires, Config.Zones.Traitement.ItemRemove)
                xPlayer.removeInventoryItem(Config.Zones.Traitement.ItemRequires1, Config.Zones.Traitement.ItemRemove)
            end
        end
    end
    treatINProg[_source] = false
end)

AddEventHandler('extasie_drug:sell', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    while not isOutMarker[_source] do
        sellINProg[_source] = true
        Citizen.Wait(Config.Zones.Vente.ItemTime)
        local Quantity = xPlayer.getInventoryItem(Config.Zones.Vente.ItemRequires).count

        if not isOutMarker[_source] then
            if Quantity < Config.Zones.Vente.ItemRemove then
                TriggerClientEvent('esx:showNotification', _source, '~r~Vous n\'avez plus de ' .. Config.Zones.Vente.ItemRequires_name .. ' à vendre.')
                sellINProg[_source] = false
                return
            else
                local item = Config.Zones.Vente.ItemRequires

                xPlayer.addAccountMoney('black_money', Config.Zones.Vente.ItemPrice)
                xPlayer.removeInventoryItem(item, Config.Zones.Vente.ItemRemove)
            end
        end
    end
    sellINProg[_source] = false
end)

ESX.RegisterServerCallback('extasie_drug:startTraitement', function(source, cb)
    local xPlayers = ESX.GetPlayers()
    local _source = source

    local cops = 0
    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end
    if cops > 0 and not isOutMarker[_source] and not treatINProg[_source] then
        TriggerClientEvent('esx:showNotification', _source, '~g~Traitement ~w~en cours...')
        TriggerEvent('extasie_drug:treat', _source)
        cb(true)
    else
        TriggerClientEvent('esx:showNotification', _source, 'Vous ne pouvez pas traiter pour le moment')
        cb(false)
    end
end)

ESX.RegisterServerCallback('extasie_drug:startVente', function(source, cb)
    local _source = source
    local xPlayers = ESX.GetPlayers()
    local cops = 0

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end
    if cops > 1 and not isOutMarker[_source] and not sellINProg[_source] then
        TriggerClientEvent('esx:showNotification', _source, '~g~Vente ~w~en cours...')
        TriggerEvent('extasie_drug:sell', _source)
        cb(true)
    else
        TriggerClientEvent('esx:showNotification', _source, 'Vous ne pouvez pas vendre pour le moment')
        cb(false)
    end
end)

ESX.RegisterServerCallback('extasie_drug:outOfMarker', function(source, cb)
    local _source = source

    isOutMarker[_source] = true
    cb(true)
end)

ESX.RegisterServerCallback('extasie_drug:inMarker', function(source, cb)
    local _source = source

    isOutMarker[_source] = false
    cb(true)
end)