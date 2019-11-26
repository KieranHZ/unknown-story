local callActive = false
local haveTarget = false
local isCall = false
local work = {}
local target = {}
local working
local PlayerData  = {}


--------------------------------------------
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)
--------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
		-- Be in service of Uber with F1
        -- if IsControlJustPressed(1, 288) then
            -- if not working then
                -- TriggerServerEvent("player:serviceOn", "uber")
				-- SendNotification("Vous avez pris le service uber")
            -- else
                -- TriggerServerEvent("player:serviceOff", "uber")
				-- SendNotification("Vous avez arreté de faire uber")
            -- end
            -- working = not working
        -- end

        -- Trigger a call of Uber with F2
        -- if IsControlJustPressed(1, 289) then
            -- local plyPos = GetEntityCoords(GetPlayerPed(-1), true)
            -- TriggerServerEvent("call:makeCall", "uber", {x=plyPos.x,y=plyPos.y,z=plyPos.z})
			-- SendNotification("Vous avez appelé un uber")
        -- end

        -- Press Y key to get the call
        if IsControlJustPressed(1, 288) and callActive then
			if isCall == false then
				TriggerServerEvent("call:getCall", work)
				SendNotification("~g~Vous avez pris l'appel !")
				target.blip = AddBlipForCoord(target.pos.x, target.pos.y, target.pos.z)
				SetBlipRoute(target.blip, true)
				haveTarget = true
				isCall = true
				callActive = false
			else
				SendNotification("~r~Vous avez déjà un appel en cours !")
			end
        -- Press L key to decline the call
        elseif IsControlJustPressed(1, 289) and callActive then
            SendNotification("~r~Vous avez refusé l'appel.")
            callActive = false
        end
        if haveTarget then
            DrawMarker(1, target.pos.x, target.pos.y, target.pos.z-1, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 255, 0, 200, 0, 0, 0, 0)
            local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
            if Vdist(target.pos.x, target.pos.y, target.pos.z, playerPos.x, playerPos.y, playerPos.z) < 2.0 then
                RemoveBlip(target.blip)
                haveTarget = false
				isCall = false
            end
        end
    end
end)

RegisterNetEvent("call:cancelCall")
AddEventHandler("call:cancelCall", function()
	if haveTarget then
		RemoveBlip(target.blip)
        haveTarget = false
		isCall = false
	else
		TriggerEvent("itinerance:notif", "~r~Vous n'avez aucun appel en cours !")
	end
end)

RegisterNetEvent("call:callIncoming")
AddEventHandler("call:callIncoming", function(job, pos, msg)
    callActive = true
    work = job
    target.pos = pos
	  SendNotification("Appuyez sur ~g~F1~s~ pour prendre l'appel ou ~g~F2~s~ pour le refuser")
      SendNotification("~b~APPEL EN COURS:~w~ " ..tostring(msg))
	if work == "police" then
	  SendNotification("~b~APPEL EN COURS:~w~ " ..tostring(msg))
	elseif work == "mechanic" then
	  SendNotification("~b~APPEL EN COURS:~w~ " ..tostring(msg))
	elseif work == "taxi" then
	  SendNotification("~b~APPEL EN COURS:~w~ " ..tostring(msg))
	elseif work == "ambulance" then
      SendNotification("~b~APPEL EN COURS:~w~ " ..tostring(msg))
	elseif work == "tacos" then
      SendNotification("~b~APPEL EN COURS:~w~ " ..tostring(msg))
	elseif work == "epicier" then
      SendNotification("~b~APPEL EN COURS:~w~ " ..tostring(msg))
	elseif work == "reporter" then
      SendNotification("~b~APPEL EN COURS:~w~ " ..tostring(msg))
	elseif work == "lawyer" then
      SendNotification("~b~APPEL EN COURS:~w~ " ..tostring(msg))
	elseif work == "brewer" then
	  SendNotification("~b~APPEL EN COURS:~w~ " ..tostring(msg))
	elseif work == "unicorn" then
      SendNotification("~b~APPEL EN COURS:~w~ " ..tostring(msg))
	elseif work == "realestateagent" then
      SendNotification("~b~APPEL EN COURS:~w~ " ..tostring(msg))
	elseif work == "cardealer" then
      SendNotification("~b~APPEL EN COURS:~w~ " ..tostring(msg))
	elseif work == "driveschool" then
      SendNotification("~b~APPEL EN COURS:~w~ " ..tostring(msg))
	elseif work == "vigne" then
	  SendNotification("~b~APPEL EN COURS:~w~ " ..tostring(msg))
	elseif work == "armurie" then
      SendNotification("~b~APPEL EN COURS:~w~ " ..tostring(msg))
	elseif work == "brinks" then
      SendNotification("~b~APPEL EN COURS:~w~ " ..tostring(msg))
	end
	
end)

RegisterNetEvent("call:taken")
AddEventHandler("call:taken", function()
    callActive = false
    SendNotification("L'appel a été pris")
end)

RegisterNetEvent("target:call:taken")
AddEventHandler("target:call:taken", function(taken)
    if taken == 1 then
        SendNotification("~g~Quelqu'un arrive !")
    elseif taken == 0 then
        SendNotification("~r~Personne ne peut venir !")
    elseif taken == 2 then
        SendNotification("~y~Veuillez rappeler dans quelques instants.")
    end
end)

-- If player disconnect, remove him from the inService server table
AddEventHandler('playerDropped', function()
	TriggerServerEvent("player:serviceOff", nil)
end)

function SendNotification(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(false, false)
end
