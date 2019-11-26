
ESX = nil
local PlayerData = {}
local menuOpen = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

Citizen.CreateThread(function()

	for _,k in pairs(locations) do
		createBlip(k.coordsIn.x, k.coordsIn.y, k.coordsIn.z, 455, 0.7, "Location de jetski", 2)
	end


	while true do 
		Citizen.Wait(1)

		for _,k in pairs(locations) do
			local pedCoords = GetEntityCoords(PlayerPedId())

			if(GetDistanceBetweenCoords(pedCoords, k.coordsIn.x, k.coordsIn.y, k.coordsIn.z, true) < 20)then
				DrawMarker(27,k.coordsIn.x,k.coordsIn.y, k.coordsIn.z-1.7,0,0,0,0,0,0,3.501,3.5001,0.5001,0,155,255,200,0,0,0,0)
			end
			if(GetDistanceBetweenCoords(pedCoords, k.coordsIn.x, k.coordsIn.y, k.coordsIn.z, true) < 6)then
				showInfo("Appuyez sur ~INPUT_CONTEXT~ pour louer un véhicule")
				if(IsControlJustPressed(1, 38)) then
					showMenu(k)
					menuOpen = true
				end
			end
		end
	end
end)

function showMenu(k)

	local elements = {
		{label = 'Jetski', value = 'seashark', price = 30},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehicle_menu',
		{
			title = 'Location de véhicules',
			elements = elements
		},
		function(data, menu)
			for i=1, #elements, 1 do
				ESX.Game.SpawnVehicle(data.current.value, k.coordsOut[1], k.coordsOut[2], function(vehicle)
					TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
				end)
				TriggerServerEvent('esx_location:buy', data.current.price)
				print(data.current.price)
			end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end














function showInfo(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end

function createBlip(x,y,z,id, onlyShortRange, name,color)
	local blip = AddBlipForCoord(x,y,z)
	SetBlipSprite(blip, id)
	SetBlipAsShortRange(blip, onlyShortRange)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
    SetBlipColour(blip, color)
	SetBlipScale(blip, 0.7)
    return blip
end
