ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- car jack

RegisterServerEvent('esx_outlawalert:carJackInProgress')
AddEventHandler('esx_outlawalert:carJackInProgress', function(targetCoords, streetName, vehicleLabel, primary, playerGender)
	if playerGender == 0 then
		playerGender = _U('male')
	else
		playerGender = _U('female')
	end

	-- Si vehicleLabel nil on envoie pas la notif
	if vehicleLabel == 'NULL' then
		vehicleLabel = 'Inconnu'
	end
	TriggerClientEvent('esx_outlawalert:outlawNotify', -1, 'CHAR_CALL911', 1, _U('carjack'), _U('carjack2', vehicleLabel, primary, streetName))
	TriggerClientEvent('esx_outlawalert:carJackInProgress', -1, targetCoords)
end)

--gun shot

RegisterServerEvent('esx_outlawalert:gunshotInProgress')
AddEventHandler('esx_outlawalert:gunshotInProgress', function(targetCoords, streetName)

	TriggerClientEvent('esx_outlawalert:outlawNotify', -1, 'CHAR_CALL911', 1, _U('gunshot'), _U('gunshot2', streetName))
	TriggerClientEvent('esx_outlawalert:gunshotInProgress', -1, targetCoords)
end)

ESX.RegisterServerCallback('esx_outlawalert:isVehicleOwner', function(source, cb, plate)
	local identifier = GetPlayerIdentifier(source, 0)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
		['@owner'] = identifier,
		['@plate'] = plate
	}, function(result)
		if result[1] then
			cb(result[1].owner == identifier)
		else
			cb(false)
		end
	end)
end)
