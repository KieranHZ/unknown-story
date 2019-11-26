ESX                = nil
local Playersrecolt = {}
local Playersdisti = {}
local Playersvente = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'pompiste', -1)
end

TriggerEvent('esx_society:registerSociety', 'pompiste', 'Pompiste', 'society_pompiste', 'society_pompiste', 'society_pompiste', {type = 'private'})

local function Vente(source)

	if Playersvente[source] == true then
		local _source = source
		local xPlayer  = ESX.GetPlayerFromId(_source)
		if xPlayer.getInventoryItem('petrole').count <= 0 then
			vine = 0
		else
			vine = 1
		end
		
		if vine == 0 then
			TriggerClientEvent('esx:showNotification', source, _U('nofuel'))
			Playersvente[_source] = false
			return
		elseif xPlayer.getInventoryItem('petrole').count <= 0 and vine == 0 then
			TriggerClientEvent('esx:showNotification', source, _U('nofuel'))
			vine = 0
			return
		else
			if (vine == 1) then
				SetTimeout(1100, function()
					local money = math.random(10,15)
					xPlayer.removeInventoryItem('petrole', 1)
					local societyAccount = nil
	
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_pompiste', function(account)
						societyAccount = account
					end)
					if societyAccount ~= nil then
						societyAccount.addMoney(money)
						TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
					end
					Sell(_source)
				end)
			end			
		end
	end
end

local function Distil(source) 

  SetTimeout(Config.TimeToDistil, function()
		if Playersdisti[source] == true then

		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		local job = xPlayer["job"]["name"]

		local Quantity = xPlayer.getInventoryItem('petrole').count

		if Quantity <= Config.ItemDistiled then
		  TriggerClientEvent('esx:showNotification', _source, '~r~Vous n\'avez plus de pétrol brut à distiller.')
		  Playersdisti[_source] = false
		else
				 xPlayer.removeInventoryItem('petrole', Config.ItemDistiled)
				 xPlayer.addInventoryItem('essence', math.floor(Config.ItemDistiled/2))
				 TriggerClientEvent('esx:showNotification', _source, 'Vous avez distillé '.. Config.ItemDistiled ..' de pétrol brut.')
				 Distil(_source)
		end

	  end
	end)
end

local function Recolting(source)
  SetTimeout(Config.TimeToRecolte, function()
		if Playersrecolt[source] == true then
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		TriggerClientEvent('esx:showNotification', _source, 'Vous avez récolté '.. Config.ItemRecolte ..' de pétrol brut.')
		xPlayer.addInventoryItem('petrole', Config.ItemRecolte)
		Recolting(_source)
	  end
	end)
end

RegisterServerEvent('pompiste:disti')
AddEventHandler('pompiste:disti', function()
	local _source = source
	if Playersdisti[_source] == false then
	  TriggerClientEvent('esx:showNotification', _source, '~r~Sortez et revenez dans la zone !')
	  Playersdisti[_source] = false
	else
	  Playersdisti[_source] = true
	  TriggerClientEvent('esx:showNotification', _source, '~g~Action ~w~en cours...')
	  Distil(_source)
	end
end)

RegisterServerEvent('pompiste:vente')
AddEventHandler('pompiste:vente', function()
	local _source = source
	if Playersvente[_source] == false then
	  TriggerClientEvent('esx:showNotification', _source, '~r~Sortez et revenez dans la zone !')
	  Playersvente[_source] = false
	else
	  Playersvente[_source] = true
	  TriggerClientEvent('esx:showNotification', _source, '~g~Action ~w~en cours...')
	  Vente(_source)
	end
end)

RegisterServerEvent('pompiste:recolte')
AddEventHandler('pompiste:recolte', function()
	local _source = source
	if Playersrecolt[_source] == false then
	  TriggerClientEvent('esx:showNotification', _source, '~r~Sortez et revenez dans la zone !')
	  Playersrecolt[_source] = false
	else
	  Playersrecolt[_source] = true
	  TriggerClientEvent('esx:showNotification', _source, '~g~Action ~w~en cours...')
	  Recolting(_source)
	end
end)

RegisterServerEvent('pompiste:stopDisti')
AddEventHandler('pompiste:stopDisti', function()

local _source = source

if Playersdisti[_source] == true then
  Playersdisti[_source] = false
else
  Playersdisti[_source] = true
end
end)

RegisterServerEvent('pompiste:stopVente')
AddEventHandler('pompiste:stopVente', function()

local _source = source

if Playersvente[_source] == true then
  Playersvente[_source] = false
else
  Playersvente[_source] = true
end
end)

RegisterServerEvent('pompiste:stopReco')
AddEventHandler('pompiste:stopReco', function()

local _source = source

if Playersrecolt[_source] == true then
  Playersrecolt[_source] = false
else
  Playersrecolt[_source] = true
end
end)
