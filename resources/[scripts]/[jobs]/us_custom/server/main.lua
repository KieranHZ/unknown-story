ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local Vehicles
local PlayersVente = {}

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'custom', Config.MaxInService)
end

-- REGISTER Job
TriggerEvent('esx_phone:registerNumber', 'custom', _U('alert_custom'), true, true)
TriggerEvent('esx_society:registerSociety', 'custom', 'US Custom', 'society_custom', 'society_custom', 'society_custom', {type = 'public'})

RegisterServerEvent('us_custom:buyMod')
AddEventHandler('us_custom:buyMod', function(price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	price = tonumber(price)

	if Config.IsCustomJobOnly then
		local societyAccount
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_custom', function(account)
			societyAccount = account
		end)
		if price < societyAccount.money then
			TriggerClientEvent('us_custom:installMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('purchased'))
			societyAccount.removeMoney(price)
		else
			TriggerClientEvent('us_custom:cancelInstallMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_money'))
		end
	else
		if price < xPlayer.getMoney() then
			TriggerClientEvent('us_custom:installMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('purchased'))
			xPlayer.removeMoney(price)
		else
			TriggerClientEvent('us_custom:cancelInstallMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_money'))
		end
	end
end)

RegisterServerEvent('us_custom:refreshOwnedVehicle')
AddEventHandler('us_custom:refreshOwnedVehicle', function(myCar)
	MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate',
	{
		['@plate']   = myCar.plate,
		['@vehicle'] = json.encode(myCar)
	})
end)

ESX.RegisterServerCallback('us_custom:getVehiclesPrices', function(source, cb)
	if Vehicles == nil then
		MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(result)
			local vehicles = {}

			for i=1, #result, 1 do
				table.insert(vehicles, {
					model = result[i].model,
					price = result[i].price
				})
			end

			Vehicles = vehicles
			cb(Vehicles)
		end)
	else
		cb(Vehicles)
	end
end)

RegisterServerEvent('us_custom:GiveItem')
AddEventHandler('us_custom:GiveItem', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local Quantity = xPlayer.getInventoryItem(Config.Zones.Vente.ItemRequires).count

	if Quantity >= 5 then
		TriggerClientEvent('esx:showNotification', _source, _U('stop_npc'))
		return
	else
		local amount = Config.Zones.Vente.ItemAdd
		local item = Config.Zones.Vente.ItemDb_name
		xPlayer.addInventoryItem(item, amount)
	end
end)

local function Vente(source)

	SetTimeout(Config.Zones.Vente.ItemTime, function()

		if PlayersVente[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local Quantity = xPlayer.getInventoryItem(Config.Zones.Vente.ItemRequires).count

			if Quantity < Config.Zones.Vente.ItemRemove then
				TriggerClientEvent('esx:showNotification', _source, '~r~Vous n\'avez plus de ' .. Config.Zones.Vente.ItemRequires_name .. ' à déposer.')
				PlayersVente[_source] = false
			else
				local amount = Config.Zones.Vente.ItemPrice / 2
				local item = Config.Zones.Vente.ItemRequires
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_custom', function(account)
					account.addMoney(amount)
				end)
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_gouvernor', function(account)
					account.addMoney(amount)
				end)
				xPlayer.removeInventoryItem(item, Config.Zones.Vente.ItemRemove)
				Vente(_source)
			end
		end
	end)
end

RegisterServerEvent('us_custom:startVente')
AddEventHandler('us_custom:startVente', function()

	local _source = source

	if PlayersVente[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~Sortez et revenez dans la zone !')
		PlayersVente[_source] = false
	else
		PlayersVente[_source] = true
		TriggerClientEvent('esx:showNotification', _source, '~g~Action ~w~en cours...')
		Vente(_source)
	end
end)


RegisterServerEvent('us_custom:stopVente')
AddEventHandler('us_custom:stopVente', function()

	local _source = source

	if PlayersVente[_source] == true then
		PlayersVente[_source] = false
	else
		PlayersVente[_source] = true
	end
end)

-- Garage
ESX.RegisterServerCallback('us_custom:storeNearbyVehicle', function(source, cb, nearbyVehicles)
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
			['@garage'] = 'custom',
			['@putby'] = xPlayer.identifier
		}, function(rowsChanged)
			if rowsChanged == 0 then
				print(('us_custom: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end
end)

ESX.RegisterServerCallback('us_custom:buyJobVehicle', function(source, cb, vehicleProps, type)
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
				['@inGarageType'] = 'custom',
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

		for _, v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end

		for _, v in ipairs(shared) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	end

	return 0
end

-- Coffre d'entreprise

ESX.RegisterServerCallback('custom:getStockItems', function(source, cb)
	local weapons, items
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_custom', function(inventory)
		items = inventory.items
	end)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_custom', function(store)
		weapons = store.get('weapons') or {}
	end)
	cb({
		items = items,
		weapons = weapons,
	})
end)

ESX.RegisterServerCallback('custom:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory

	cb({
		items = items,
		weapons = xPlayer.getLoadout()
	})
end)

RegisterServerEvent('custom:getStockItem')
AddEventHandler('custom:getStockItem', function(type, itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	if type == 'item_weapon' then
		TriggerEvent('esx_datastore:getSharedDataStore', 'society_custom', function(store)
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
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_custom', function(inventory)
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

RegisterServerEvent('custom:putStockItems')
AddEventHandler('custom:putStockItems', function(type, itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	if type == 'item_standard' then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_custom', function(inventory)
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

		TriggerEvent('esx_datastore:getSharedDataStore', 'society_custom', function(store)
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
