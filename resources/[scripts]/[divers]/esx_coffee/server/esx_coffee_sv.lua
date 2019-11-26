ESX               = nil
local ItemsLabels = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_coffee:buyItem')
AddEventHandler('esx_coffee:buyItem', function(itemName, price)

	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	if xPlayer.get('money') >= price then

		xPlayer.removeMoney(price)
		xPlayer.addInventoryItem(itemName, 1)

		TriggerClientEvent('esx:showNotification', _source, _U('bought') .. tostring(itemName))

	else
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
	end

end)
