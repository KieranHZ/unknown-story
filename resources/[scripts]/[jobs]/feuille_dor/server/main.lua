ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

local isOutMarker

--
--
--

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'feuilledor', Config.MaxInService)
end

-- REGISTER Job
TriggerEvent('esx_phone:registerNumber', 'feuilledor', _U('alert_feuilledor'), true, true)
TriggerEvent('esx_society:registerSociety', 'feuilledor', 'La Feuille d\'Or', 'society_feuilledor', 'society_feuilledor', 'society_feuilledor', { type = 'public' })

local function Vente(source)

	SetTimeout(Config.Zones.Vente.ItemTime, function()
		local _source = source
		if isOutMarker then
			isOutMarker = false
			TriggerClientEvent('feuilledor:stopVente', _source)
			return
		end

		local xPlayer = ESX.GetPlayerFromId(_source)
		local Quantity = xPlayer.getInventoryItem(Config.Zones.Vente.ItemRequires).count

		if Quantity < Config.Zones.Vente.ItemRemove then
			TriggerClientEvent('esx:showNotification', _source, '~r~Vous n\'avez plus de ' .. Config.Zones.Vente.ItemRequires_name .. ' à déposer.')
			TriggerClientEvent('feuilledor:stopVente', _source)
		else
			local amount = Config.Zones.Vente.ItemPrice / 2
			local item = Config.Zones.Vente.ItemRequires
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_feuilledor', function(account)
				account.addMoney(amount)
			end)
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_gouvernor', function(account)
				account.addMoney(amount)
			end)
			xPlayer.removeInventoryItem(item, Config.Zones.Vente.ItemRemove)
			Vente(_source)
		end
	end)
end

RegisterServerEvent('feuilledor:startVente')
AddEventHandler('feuilledor:startVente', function()

	local _source = source

	TriggerClientEvent('feuilledor:isVente', _source)
	TriggerClientEvent('esx:showNotification', _source, '~g~Vente ~w~en cours...')
	Vente(_source)
end)

local function Recolte(source)

	SetTimeout(Config.Zones.Recolte.ItemTime, function()
		local _source = source
		if isOutMarker then
			isOutMarker = false
			TriggerClientEvent('feuilledor:stopRecolte', _source)
			return
		end
		local xPlayer = ESX.GetPlayerFromId(_source)
		local Quantity = xPlayer.getInventoryItem(Config.Zones.Recolte.ItemRequires).count
		if Quantity == Config.Zones.Recolte.ItemMax then
			TriggerClientEvent('esx:showNotification', _source, '~r~Vous n\'avez plus de place dans votre inventaire.')
			TriggerClientEvent('feuilledor:stopRecolte', _source)
		else
			xPlayer.addInventoryItem(Config.Zones.Recolte.ItemDb_name, Config.Zones.Recolte.ItemAdd)
			Recolte(_source)
		end
	end)
end

RegisterServerEvent('feuilledor:startRecolte')
AddEventHandler('feuilledor:startRecolte', function()
	local _source = source

	TriggerClientEvent('feuilledor:isRecolte', _source)
	TriggerClientEvent('esx:showNotification', _source, '~g~Récolte ~w~en cours...')
	Recolte(_source)
end)

local function Traitement(source)
	SetTimeout(Config.Zones.Traitement.ItemTime, function()
		local _source = source
		if isOutMarker then
			isOutMarker = false
			TriggerClientEvent('feuilledor:stopTraitement', _source)
			return
		end

		local xPlayer = ESX.GetPlayerFromId(_source)
		local QuantityTete = xPlayer.getInventoryItem(Config.Zones.Recolte.ItemRequires).count
		local QuantityWeed = xPlayer.getInventoryItem(Config.Zones.Traitement.ItemRequires).count
		if QuantityWeed >= 100 then
			TriggerClientEvent('esx:showNotification', _source, '~r~Votre inventaire est plein.')
			TriggerClientEvent('feuilledor:stopTraitement', _source)
			return
		elseif QuantityTete <= 0 then
			TriggerClientEvent('esx:showNotification', _source, '~r~Vous n\'avez plus de weed a traiter.')
			TriggerClientEvent('feuilledor:stopTraitement', _source)
			return
		else
			xPlayer.addInventoryItem(Config.Zones.Traitement.ItemDb_name, Config.Zones.Traitement.ItemAdd)
			xPlayer.removeInventoryItem(Config.Zones.Recolte.ItemDb_name, Config.Zones.Recolte.ItemRemove)
			Traitement(_source)
		end
	end)
end

RegisterServerEvent('feuilledor:startTraitement')
AddEventHandler('feuilledor:startTraitement', function()

	local _source = source

	TriggerClientEvent('feuilledor:isTraitement', _source)
	TriggerClientEvent('esx:showNotification', _source, '~g~Traitement ~w~en cours...')
	Traitement(_source)
end)

RegisterServerEvent('feuilledor:outOfMarker')
AddEventHandler('feuilledor:outOfMarker', function()
	isOutMarker = true
end)

RegisterServerEvent('feuilledor:inMarker')
AddEventHandler('feuilledor:inMarker', function()
	isOutMarker = false
end)


ESX.RegisterServerCallback('feuilledor:storeNearbyVehicle', function(source, cb, nearbyVehicles)
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
			['@garage'] = 'feuilledor',
			['@putby'] = xPlayer.identifier
		}, function(rowsChanged)
			if rowsChanged == 0 then
				print(('feuilledor: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end

end)

ESX.RegisterServerCallback('feuilledor:buyJobVehicle', function(source, cb, vehicleProps, type)
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
				['@inGarageType'] = 'feuilledor',
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

ESX.RegisterServerCallback('feuilledor:getStockItems', function(source, cb)
	local weapons, items
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_feuilledor', function(inventory)
		items = inventory.items
	end)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_feuilledor', function(store)
		weapons = store.get('weapons') or {}
	end)
	cb({
		items = items,
		weapons = weapons,
	})
end)

ESX.RegisterServerCallback('feuilledor:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory

	cb({
		items = items,
		weapons = xPlayer.getLoadout()
	})
end)

RegisterServerEvent('feuilledor:getStockItem')
AddEventHandler('feuilledor:getStockItem', function(type, itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	if type == 'item_weapon' then
		TriggerEvent('esx_datastore:getSharedDataStore', 'society_feuilledor', function(store)
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
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_feuilledor', function(inventory)
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

RegisterServerEvent('feuilledor:putStockItems')
AddEventHandler('feuilledor:putStockItems', function(type, itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	if type == 'item_standard' then
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_feuilledor', function(inventory)
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

		TriggerEvent('esx_datastore:getSharedDataStore', 'society_feuilledor', function(store)
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
