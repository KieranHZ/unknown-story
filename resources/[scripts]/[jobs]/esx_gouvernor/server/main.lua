ESX = nil

local players = {}

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

if Config.MaxInService ~= -1 then
    TriggerEvent('esx_service:activateService', 'gouvernor', Config.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'gouvernor', 'Gouvernement', 'society_gouvernor', 'society_gouvernor', 'society_gouvernor', { type = 'public' })
-----------------------------------------------------

RegisterServerEvent('esx_gouverneur:addPlayer')
AddEventHandler('esx_gouverneur:addPlayer', function(jobName)
    local _source = source
    players[_source] = jobName
end)

RegisterServerEvent('esx_gouverneur:sendSonnette')
AddEventHandler('esx_gouverneur:sendSonnette', function()
    local _source = source
    for i, k in pairs(players) do
        if (k ~= nil) then
            if (k == 'gouvernor') then
                TriggerClientEvent('esx_gouverneur:sendRequest', i, GetPlayerName(_source), _source)
            end
        end
    end
end)

RegisterServerEvent('esx_gouverneur:sendStatusToPoeple')
AddEventHandler('esx_gouverneur:sendStatusToPoeple', function(id, status)
    TriggerClientEvent('esx_gouverneur:sendStatus', id, status)
end)

-------------------------------------------------------

TriggerEvent('esx_phone:registerNumber', 'gouvernor', _U('client'), true, true)

AddEventHandler('esx_phone:ready', function()
    TriggerEvent('esx_phone:registerCallback', function(source, phoneNumber, message, anon)
        local xPlayer = ESX.GetPlayerFromId(source)
        local xPlayers = ESX.GetPlayers()
        local job = 'Citoyen'

        if phoneNumber == 'gouvernor' then
            for i = 1, #xPlayers, 1 do
                local xPlayer2 = ESX.GetPlayerFromId(xPlayers[i])
                if xPlayer2.job.name == 'gouvernor' and xPlayer2.job.grade_name == 'boss' then
                    TriggerClientEvent('esx_phone:onMessage', xPlayer2.source, xPlayer.get('phoneNumber'), message, xPlayer.get('coords'), anon, job, false)
                end
            end
        end
    end)
end)

RegisterServerEvent('esx_gouverneur:giveWeapon')
AddEventHandler('esx_gouverneur:giveWeapon', function(weapon, ammo)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_gouverneur:removeWeapon')
AddEventHandler('esx_gouverneur:removeWeapon', function(weapon)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeWeapon(weapon)
end)

TriggerEvent('esx_phone:registerCallback', function(source, phoneNumber, message, anon)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    if phoneNumber == 'gouvernor' then
        for i = 1, #xPlayers, 1 do
            local xPlayer2 = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer2.job.name == 'gouvernor' and xPlayer2.job.grade_name == 'boss' then
                TriggerClientEvent('esx_phone:onMessage', xPlayer2.source, xPlayer.get('phoneNumber'), message, xPlayer.get('coords'), anon, 'player')
            end
        end
    end
end)

ESX.RegisterServerCallback('esx_gouvernor:storeNearbyVehicle', function(source, cb, nearbyVehicles)
    local xPlayer = ESX.GetPlayerFromId(source)
    local foundPlate, foundNum

    for k, v in ipairs(nearbyVehicles) do
        local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE plate = @plate', {
            ['@plate'] = v.plate,
        })

        if result[1] then
            foundPlate, foundNum = result[1].plate, k
            break
        end
    end
    if not foundPlate then
        cb(false)
    else
        MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true, `in_garage_type` = @garage, `put_by` = @putby WHERE plate = @plate', {
            ['@plate'] = foundPlate,
            ['@garage'] = 'gouvernor',
            ['@putby'] = xPlayer.identifier
        }, function(rowsChanged)
            if rowsChanged == 0 then
                print(('esx_gouvernor: %s has exploited the garage!'):format(xPlayer.identifier))
                cb(false)
            else
                cb(true, foundNum)
            end
        end)
    end
end)

ESX.RegisterServerCallback('esx_gouvernor:buyJobVehicle', function(source, cb, vehicleProps, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = getPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

    -- vehicle model not found
    if price <= 0 then
        cb(false)
    else
        if xPlayer.getMoney() >= price then
            xPlayer.removeMoney(price)
            MySQL.Async.execute('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, stored, in_garage_type, put_by) VALUES (@owner, @vehicle, @plate, @type, @job, @stored, @inGarageType, @put_by)', {
                ['@owner'] = xPlayer.identifier,
                ['@vehicle'] = json.encode(vehicleProps),
                ['@plate'] = vehicleProps.plate,
                ['@type'] = type,
                ['@job'] = xPlayer.job.name,
                ['@stored'] = true,
                ['@inGarageType'] = 'gouvernor',
                ['@put_by'] = xPlayer.identifier
            }, function(_)
                cb(true)
            end)
        else
            cb(false)
        end
    end
end)

function getPriceFromHash(hashKey, jobGrade, type)
    if type == 'car' then
        local vehicles = Config.AuthorizedVehicles[jobGrade]
        local shared = Config.AuthorizedVehicles['Shared']

        for k, v in ipairs(vehicles) do
            if GetHashKey(v.model) == hashKey then
                return v.price
            end
        end
        for k, v in ipairs(shared) do
            if GetHashKey(v.model) == hashKey then
                return v.price
            end
        end
    end
    return 0
end

-- Coffre d'entreprise

ESX.RegisterServerCallback('gouvernor:getStockItems', function(source, cb)
    local weapons, items

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_gouvernor', function(inventory)
        items = inventory.items
    end)
    TriggerEvent('esx_datastore:getSharedDataStore', 'society_gouvernor', function(store)
        weapons = store.get('weapons') or {}
    end)
    cb({
        items = items,
        weapons = weapons,
    })
end)

ESX.RegisterServerCallback('gouvernor:getPlayerInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.inventory

    cb({
        items = items,
        weapons = xPlayer.getLoadout()
    })
end)

RegisterServerEvent('gouvernor:getStockItem')
AddEventHandler('gouvernor:getStockItem', function(type, itemName, count)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local sourceItem = xPlayer.getInventoryItem(itemName)

    if type == 'item_weapon' then
        TriggerEvent('esx_datastore:getSharedDataStore', 'society_gouvernor', function(store)
            local storeWeapons = store.get('weapons') or {}
            local weaponName
            local ammo
            for i = 1, #storeWeapons, 1 do
                if storeWeapons[i].name == itemName then
                    weaponName = storeWeapons[i].name
                    ammo = storeWeapons[i].ammo

                    table.remove(storeWeapons, i)
                    break
                end
            end
            store.set('weapons', storeWeapons)
            xPlayer.addWeapon(weaponName, ammo)
        end)
    elseif type == 'item_standard' then
        TriggerEvent('esx_addoninventory:getSharedInventory', 'society_gouvernor', function(inventory)
            local inventoryItem = inventory.getItem(itemName)

            -- is there enough in the society?
            if count > 0 and inventoryItem.count >= count then

                -- can the player carry the said amount of x item?
                if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
                    TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
                else
                    inventory.removeItem(itemName, count)
                    xPlayer.addInventoryItem(itemName, count)
                    TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
                end
            else
                TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
            end
        end)
    end
end)

RegisterServerEvent('gouvernor:putStockItems')
AddEventHandler('gouvernor:putStockItems', function(type, itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local sourceItem = xPlayer.getInventoryItem(itemName)

    if type == 'item_standard' then
        TriggerEvent('esx_addoninventory:getSharedInventory', 'society_gouvernor', function(inventory)
            local inventoryItem = inventory.getItem(itemName)

            -- does the player have enough of the item?
            if sourceItem.count >= count and count > 0 then
                xPlayer.removeInventoryItem(itemName, count)
                inventory.addItem(itemName, count)
                TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, inventoryItem.label))
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
            end
        end)
    elseif type == 'item_weapon' then

        TriggerEvent('esx_datastore:getSharedDataStore', 'society_gouvernor', function(store)
            local storeWeapons = store.get('weapons') or {}

            table.insert(storeWeapons, {
                name = itemName,
                ammo = count
            })
            store.set('weapons', storeWeapons)
            xPlayer.removeWeapon(itemName)
        end)

    end
end)

function startImpot(d, h, m)
    print('-----------')
    print('Start Impot')
    print('-----------')
    -- Retrieve gouv account
    TriggerEvent('esx_society:getSociety', 'gouvernor', function(govern)
        if govern ~= nil then
            TriggerEvent('esx_addonaccount:getSharedAccount', govern.account, function(account)
                if account ~= nil then
                    -- Retrieve Us Custom Account
                    TriggerEvent('esx_society:getSociety', 'custom', function(society)
                        if society ~= nil then
                            -- verified society
                            TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(uscAccount)
                                -- does the society money to pay its employees?
                                local money = round(((uscAccount.money * Config.ImpotValue) / 100), 0)
                                account.addMoney(money)
                                uscAccount.removeMoney(money)
                            end)
                        end
                    end)
                end
            end)
            TriggerEvent('esx_addonaccount:getSharedAccount', govern.account, function(account)
                if account ~= nil then
                    -- Retrieve Feuille d'Or Account
                    TriggerEvent('esx_society:getSociety', 'feuilledor', function(society)
                        if society ~= nil then
                            -- verified society
                            TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(fdAccount)
                                -- does the society money to pay its employees?
                                local money = round(((fdAccount.money * Config.ImpotValue) / 100), 0)
                                account.addMoney(money)
                                fdAccount.removeMoney(money)
                            end)
                        end
                    end)
                end
            end)
            TriggerEvent('esx_addonaccount:getSharedAccount', govern.account, function(account)
                if account ~= nil then
                    -- Retrieve Cardealer Account
                    TriggerEvent('esx_society:getSociety', 'cardealer', function(society)
                        if society ~= nil then
                            -- verified society
                            TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(cardAccount)
                                -- does the society money to pay its employees?
                                local money = round(((cardAccount.money * Config.ImpotValue) / 100), 0)
                                account.addMoney(money)
                                cardAccount.removeMoney(money)
                            end)
                        end
                    end)
                end
            end)
            --[[            TriggerEvent('esx_addonaccount:getSharedAccount', govern.account, function(account)
                            if account ~= nil then
                                -- Retrieve Banker Account
                                TriggerEvent('esx_society:getSociety', 'banker', function(society)
                                    if society ~= nil then
                                        -- verified society
                                        TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(bankAccount)
                                            -- does the society money to pay its employees?
                                            local money = round(((bankAccount.money * 10) / 100), 0)
                                            account.addMoney(money)
                                            bankAccount.removeMoney(money)
                                        end)
                                    end
                                end)
                            end
                        end)]]
            TriggerEvent('esx_addonaccount:getSharedAccount', govern.account, function(account)
                if account ~= nil then
                    -- Retrieve Unicorn Account
                    TriggerEvent('esx_society:getSociety', 'unicorn', function(society)
                        if society ~= nil then
                            -- verified society
                            TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(uniAccount)
                                -- does the society money to pay its employees?
                                local money = round(((uniAccount.money * Config.ImpotValue) / 100), 0)
                                account.addMoney(money)
                                uniAccount.removeMoney(money)
                            end)
                        end
                    end)
                end
            end)
            TriggerEvent('esx_addonaccount:getSharedAccount', govern.account, function(account)
                if account ~= nil then
                    -- Retrieve Transistep Account
                    TriggerEvent('esx_society:getSociety', 'transistep', function(society)
                        if society ~= nil then
                            -- verified society
                            TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(uniAccount)
                                -- does the society money to pay its employees?
                                local money = round(((uniAccount.money * Config.ImpotValue) / 100), 0)
                                account.addMoney(money)
                                uniAccount.removeMoney(money)
                            end)
                        end
                    end)
                end
            end)
        end
    end)
end

function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

TriggerEvent('cron:runAt', 19, 10, startImpot)
