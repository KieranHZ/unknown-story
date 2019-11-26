ESX                  = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	addblip()
end)

function addblip()
	Citizen.CreateThread(function()
		local blip = AddBlipForCoord(-1201.0179443359, -1568.3116455078, 3.6111540794373)
	  
		SetBlipSprite (blip, 311)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.7)
		SetBlipColour (blip, 41)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Salle de sport')
		EndTextCommandSetBlipName(blip)
	end)
end

AddEventHandler('esx_status:loaded', function(status)

  TriggerEvent('esx_status:registerStatus', 'sport', 0, '#F5F5F5', 
    function(status)
      if status.val > 0 then
        return true
      else
        return false
      end
    end,
    function(status)
      status.remove(50)
    end
  )
	Citizen.CreateThread(function()
		while true do
			Wait(1000)
			TriggerEvent('esx_status:getStatus', 'sport', function(status)
				if status.val > 0 then	
					StatSetInt(GetHashKey('MP0_STAMINA'), 100, true)
					StatSetInt(GetHashKey('MP0_STRENGTH'), 100, true)
					StatSetInt(GetHashKey('MP0_WHEELIE_ABILITY'), 100, true)
					StatSetInt(GetHashKey('MP0_FLYING_ABILITY'), 100, true)
					StatSetInt(GetHashKey('MP0_SHOOTING_ABILITY'), 100, true)
					StatSetInt(GetHashKey('MP0_STEALTH_ABILITY'), 100, true)
					
				else
					StatSetInt(GetHashKey('MP0_STAMINA'), 0, true)
					StatSetInt(GetHashKey('MP0_STRENGTH'), 0, true)
					StatSetInt(GetHashKey('MP0_WHEELIE_ABILITY'), 0, true)
					StatSetInt(GetHashKey('MP0_FLYING_ABILITY'), 0, true)
					StatSetInt(GetHashKey('MP0_SHOOTING_ABILITY'), 0, true)
					StatSetInt(GetHashKey('MP0_STEALTH_ABILITY'), 0, true)
				end 
			end)
		end
	end)
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0) --{x =-1204.8413085938,y = -1564.2200927734,z = 3.6095089912415 },
		
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		
		if(GetDistanceBetweenCoords(coords, -1204.8413085938, -1564.2200927734, 2.6126837730408, true) < 40.0) then
			 DrawMarker(1, -1204.8413085938, -1564.2200927734, 2.6126837730408, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.3, 0, 0, 200, 200, false, true, 2, false, false, false, false)
		end
		if(GetDistanceBetweenCoords(coords, -1204.8413085938, -1564.2200927734, 3.6095089912415, true) < 2.0) then
			SetTextComponentFormat('STRING')
			AddTextComponentString('Appuyer sur E pour faire des Tractions')
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, 38) then
				TaskStartScenarioAtPosition(GetPlayerPed(-1), "PROP_HUMAN_MUSCLE_CHIN_UPS_PRISON", -1204.93085938,-1564.1190927734,4.587089912415, -145.0, 0, 0, 1)
				FreezeEntityPosition(GetPlayerPed(-1),  true)
				Citizen.Wait(60000)
				FreezeEntityPosition(GetPlayerPed(-1),  false)
				TriggerEvent('esx_status:add','sport', 85000)
				ClearPedTasks(GetPlayerPed(-1))
			end
		end
		
		if(GetDistanceBetweenCoords(coords, -1200.6203613281, -1562.1663818359, 2.6126837730408, true) < 40.0) then
			 DrawMarker(1, -1200.6203613281, -1562.1663818359, 2.6126837730408, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.3, 0, 0, 200, 200, false, true, 2, false, false, false, false)
		end
		if(GetDistanceBetweenCoords(coords, -1200.6203613281, -1562.1663818359, 4.0096755027771, true) < 2.0) then
			SetTextComponentFormat('STRING')
			AddTextComponentString('Appuyer sur E pour faire des pecs')
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, 38) then
				TaskStartScenarioAtPosition(GetPlayerPed(-1), "PROP_HUMAN_SEAT_MUSCLE_BENCH_PRESS", -1200.673613281,-1562.1663818359,4.08596755027771, 125.0, 0, 0, 1)
				FreezeEntityPosition(GetPlayerPed(-1),  true)
				Citizen.Wait(60000)
				FreezeEntityPosition(GetPlayerPed(-1),  false)
				TriggerEvent('esx_status:add','sport', 85000)
				ClearPedTasks(GetPlayerPed(-1))
			end
		end
		
		if(GetDistanceBetweenCoords(coords, -1197.4046630859, -1571.5334472656, 2.6126837730408, true) < 40.0) then
			 DrawMarker(1, -1197.4046630859, -1571.5334472656, 2.6126837730408, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.3, 0, 0, 200, 200, false, true, 2, false, false, false, false)
		end
		if(GetDistanceBetweenCoords(coords, -1197.4046630859, -1571.5334472656, 3.6135630607605, true) < 2.0) then
			SetTextComponentFormat('STRING')
			AddTextComponentString('Appuyer sur E pour faire des abdos')
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, 38) then
				TaskStartScenarioAtPosition(GetPlayerPed(-1), "WORLD_HUMAN_SIT_UPS", coords.x,coords.y,coords.z, 125.0, 0, 0, 1)
				FreezeEntityPosition(GetPlayerPed(-1),  true)
				Citizen.Wait(60000)
				FreezeEntityPosition(GetPlayerPed(-1),  false)
				TriggerEvent('esx_status:add','sport', 85000)
				ClearPedTasks(GetPlayerPed(-1))
			end
		end
		
		if(GetDistanceBetweenCoords(coords, -1200.3863525391, -1573.2603759766, 2.6126837730408, true) < 40.0) then
			 DrawMarker(1, -1200.3863525391, -1573.2603759766, 2.6126837730408, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.3, 0, 0, 200, 200, false, true, 2, false, false, false, false)
		end
		if(GetDistanceBetweenCoords(coords, -1200.3863525391, -1573.2603759766, 3.6135630607605, true) < 2.0) then
			SetTextComponentFormat('STRING')
			AddTextComponentString('Appuyer sur E pour faire des pompes')
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, 38) then
				TaskStartScenarioAtPosition(GetPlayerPed(-1), "WORLD_HUMAN_PUSH_UPS", coords.x,coords.y,coords.z, 125.0, 0, 0, 1)
				FreezeEntityPosition(GetPlayerPed(-1),  true)
				Citizen.Wait(60000)
				FreezeEntityPosition(GetPlayerPed(-1),  false)
				TriggerEvent('esx_status:add','sport', 85000)
				ClearPedTasks(GetPlayerPed(-1))
			end
		end
		
		if(GetDistanceBetweenCoords(coords, -1205.1596679688, -1561.1665039063, 2.6126837730408, true) < 40.0) then
			 DrawMarker(1, -1205.1596679688, -1561.1665039063, 2.6126837730408, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.3, 0, 0, 200, 200, false, true, 2, false, false, false, false)
		end
		if(GetDistanceBetweenCoords(coords, -1205.1596679688, -1561.1665039063, 3.6135630607605, true) < 2.0) then
			SetTextComponentFormat('STRING')
			AddTextComponentString('Appuyer sur E pour faire du Yoga')
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, 38) then
				TaskStartScenarioAtPosition(GetPlayerPed(-1), "WORLD_HUMAN_YOGA", coords.x,coords.y,coords.z, 125.0, 0, 0, 1)
				FreezeEntityPosition(GetPlayerPed(-1),  true)
				Citizen.Wait(60000)
				FreezeEntityPosition(GetPlayerPed(-1),  false)
				TriggerEvent('esx_status:add','sport', 85000)
				ClearPedTasks(GetPlayerPed(-1))
			end
		end
		
		if(GetDistanceBetweenCoords(coords, -1207.6506347656, -1563.0241699219, 2.6126837730408, true) < 40.0) then
			 DrawMarker(1, -1207.6506347656, -1563.0241699219, 2.6126837730408, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.3, 0, 0, 200, 200, false, true, 2, false, false, false, false)
		end
		if(GetDistanceBetweenCoords(coords, -1207.6506347656, -1563.0241699219, 3.61356306076058, true) < 2.0) then
			SetTextComponentFormat('STRING')
			AddTextComponentString('Appuyer sur E pour faire de la muscu')
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, 38) then
				TaskStartScenarioAtPosition(GetPlayerPed(-1), "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS", coords.x,coords.y,coords.z, 125.0, 0, 0, 1)
				FreezeEntityPosition(GetPlayerPed(-1),  true)
				Citizen.Wait(60000)
				FreezeEntityPosition(GetPlayerPed(-1),  false)
				TriggerEvent('esx_status:add','sport', 85000)
				ClearPedTasks(GetPlayerPed(-1))
			end
		end
	end
end)