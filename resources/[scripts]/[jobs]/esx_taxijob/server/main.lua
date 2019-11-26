ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'taxi', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'taxi', _U('taxi_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'taxi', 'Taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})

RegisterServerEvent('esx_taxijob:success')
AddEventHandler('esx_taxijob:success', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'taxi' then
		print(('esx_taxijob: %s attempted to trigger success!'):format(xPlayer.identifier))
		return
	end

	math.randomseed(os.time())

	local total = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max)
	local societyAccount

	if xPlayer.job.grade >= 3 then
		total = total * 2
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxi', function(account)
		societyAccount = account
	end)

	if societyAccount then
		local playerMoney  = ESX.Math.Round(total / 100 * 30)
		local societyMoney = ESX.Math.Round(total / 100 * 70)

		xPlayer.addMoney(playerMoney)
		societyAccount.addMoney(societyMoney)

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned', societyMoney, playerMoney))
	else
		xPlayer.addMoney(total)
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_earned', total))
	end

end)

RegisterServerEvent('esx_taxijob:getStockItem')
AddEventHandler('esx_taxijob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'taxi' then
		print(('esx_taxijob: %s attempted to trigger getStockItem!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		local item = inventory.getItem(itemName)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('player_cannot_hold'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', count, item.label))
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_taxijob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_taxijob:putStockItems')
AddEventHandler('esx_taxijob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'taxi' then
		print(('esx_taxijob: %s attempted to trigger putStockItems!'):format(xPlayer.identifier))
		return
	end
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, item.label))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

	end)
end)

ESX.RegisterServerCallback('esx_taxijob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

-- Garage
ESX.RegisterServerCallback('esx_taxijob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
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
			['@garage'] = 'taxi',
			['@putby'] = xPlayer.identifier
		}, function(rowsChanged)
			if rowsChanged == 0 then
				print(('esx_taxijob: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end

end)


ESX.RegisterServerCallback('esx_taxijob:buyJobVehicle', function(source, cb, vehicleProps, type)
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
				['@inGarageType'] = 'taxi',
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
