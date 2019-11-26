ESX = nil
local InService = {}
local MaxInService = {}

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

function GetInServiceCount(name)
	local count = 0

	for k, v in pairs(InService[name]) do
		if v == true then
			count = count + 1
		end
	end
	return count
end

AddEventHandler('esx_service:activateService', function(name, max)
	InService[name] = {}
	MaxInService[name] = max
end)

RegisterServerEvent('esx_service:disableService')
AddEventHandler('esx_service:disableService', function(name, identifier)
	InService[name][identifier] = nil
end)

RegisterServerEvent('esx_service:notifyAllInService')
AddEventHandler('esx_service:notifyAllInService', function(notification, name)
	local xPlayer
	for k, v in pairs(InService[name]) do
		if v == true then
			xPlayer = ESX.GetPlayerFromIdentifier(k)
			if xPlayer ~= nil then
				TriggerClientEvent('esx_service:notifyAllInService', xPlayer.source, notification, source)
			end
		end
	end
end)

ESX.RegisterServerCallback('esx_service:enableService', function(_, cb, name, identifier)
	local inServiceCount = GetInServiceCount(name)

	if inServiceCount >= MaxInService[name] then
		cb(false, MaxInService[name], inServiceCount)
	else
		InService[name][identifier] = true
		cb(true, MaxInService[name], inServiceCount)
	end
end)

AddEventHandler('esx_service:isInServicePayCheck', function(cb, xPlayer)
	local isInService = false

	if InService[xPlayer.job.name] ~= nil then
		if InService[xPlayer.job.name][xPlayer.identifier] then
			isInService = true
		end

	end
	cb(isInService)
end)

ESX.RegisterServerCallback('esx_service:isInService', function(_, cb, name, identifier)
	local isInService = false

	if InService[name][identifier] then
		isInService = true
	end
	cb(isInService)
end)

ESX.RegisterServerCallback('esx_service:getInServiceList', function(_, cb, name)
	cb(InService[name])
end)

AddEventHandler('playerDropped', function()
	local _source = source

	for k, v in pairs(InService) do
		if v[_source] == true then
			v[_source] = nil
		end
	end
end)
