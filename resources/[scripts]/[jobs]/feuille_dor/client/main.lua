local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local PlayerData = {}
local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg
local CurrentActionData = {}
local playerInService = false
local spawnedVehicles, isInShopMenu = {}, false
local rc = false
local treating = false
local vending = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj)
			ESX = obj
		end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

function OpenCloakroomMenu()
	local elements = {
		{ label = _U('citizen_wear'), value = 'citizen_wear' },
		{ label = 'Prendre le service | tenue travail', value = 'jardin_wear' }
	}

	if PlayerData.job.grade_name == 'boss' then
		table.insert(elements, { label = 'Prendre le service | tenue civil', value = 'civil_wear' })
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom_actions',
		{
			css = 'unknownstory',
			title = _U('cloakroom'),
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'citizen_wear' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)

				if Config.MaxInService ~= -1 then
					ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
						if isInService then

							playerInService = false

							local notification = {
								title = _U('service_anonunce'),
								subject = '',
								msg = _U('service_out_announce', GetPlayerName(PlayerId())),
								iconType = 1
							}

							TriggerServerEvent('esx_service:notifyAllInService', notification, 'feuilledor')

							TriggerServerEvent('esx_service:disableService', 'feuilledor', PlayerData.identifier)
							ESX.ShowNotification(_U('service_out'))
						end
					end, 'feuilledor', PlayerData.identifier)
				end
			end
			if Config.MaxInService ~= -1 and data.current.value ~= 'citizen_wear' then
				local serviceOk = 'waiting'

				ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
					if not isInService then

						ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
							if not canTakeService then
								ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
							else
								serviceOk = true
								playerInService = true

								local notification = {
									title = _U('service_anonunce'),
									subject = '',
									msg = _U('service_in_announce', GetPlayerName(PlayerId())),
									iconType = 1
								}
								TriggerServerEvent('esx_service:notifyAllInService', notification, 'feuilledor')
								ESX.ShowNotification(_U('service_in'))
							end
						end, 'feuilledor', PlayerData.identifier)
					else
						serviceOk = true
					end
				end, 'feuilledor', PlayerData.identifier)
				while type(serviceOk) == 'string' do
					Citizen.Wait(5)
				end
				-- if we couldn't enter service don't let the player get changed
				if not serviceOk then
					return
				end
			end
			if data.current.value == 'jardin_wear' then
				setUniform(data.current.value)
			end
		end, function(data, menu)
			menu.close()
			CurrentAction = nil
		end)
end

function setUniform(job)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[job].male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		else
			if Config.Uniforms[job].female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		end
	end)
end

function OpenVehicleSpawnerMenu(type)
	local playerCoords = GetEntityCoords(PlayerPedId())
	local elements = {
		{ label = _U('garage_storeditem'), action = 'garage' },
		{ label = _U('garage_storeitem'), action = 'store_garage' }
	}

	if (PlayerData.job.grade_name == 'boss') then
		table.insert(elements, { label = _U('garage_buyitem'), action = 'buy_vehicle' })
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle', {
		css = 'unknownstory',
		title = _U('garage_title'),
		align = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.action == 'buy_vehicle' then
			local shopElements, shopCoords = {}
			shopCoords = Config.Zones.CarGarage.InsideShop
			if #Config.AuthorizedVehicles['Shared'] > 0 then
				for k, vehicle in ipairs(Config.AuthorizedVehicles['Shared']) do
					table.insert(shopElements, {
						label = ('%s - <span style="color:green;">%s</span>'):format(vehicle.label, _U('shop_item', ESX.Math.GroupDigits(vehicle.price))),
						name = vehicle.label,
						model = vehicle.model,
						price = vehicle.price,
						type = 'car'
					})
				end
			end
			OpenShopMenu(shopElements, playerCoords, shopCoords)
		end
		if data.current.action == 'garage' then
			local garage = {}

			ESX.TriggerServerCallback('esx_vehicleshop:retrieveJobVehicles', function(jobVehicles)
				if #jobVehicles > 0 then
					for k, v in ipairs(jobVehicles) do
						local props = json.decode(v.vehicle)
						local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(props.model))
						local label = ('%s - <span style="color:darkgoldenrod;">%s</span>: '):format(vehicleName, props.plate)

						if v.stored then
							label = label .. ('<span style="color:green;">%s</span>'):format(_U('garage_stored'))
						else
							label = label .. ('<span style="color:darkred;">%s</span>'):format(_U('garage_notstored'))
						end

						table.insert(garage, {
							label = label,
							stored = v.stored,
							model = props.model,
							vehicleProps = props
						})
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_garage', {
						css = 'unknownstory',
						title = _U('garage_title'),
						align = 'top-left',
						elements = garage
					}, function(data2, menu2)
						if data2.current.stored then
							local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint()

							if foundSpawn then
								menu2.close()

								ESX.Game.SpawnVehicle(data2.current.model, spawnPoint.coords, spawnPoint.heading, function(vehicle)
									ESX.Game.SetVehicleProperties(vehicle, data2.current.vehicleProps)

									TriggerServerEvent('esx_vehicleshop:setJobVehicleState', data2.current.vehicleProps.plate, false)
									ESX.ShowNotification(_U('garage_released'))
								end)
							end
						else
							ESX.ShowNotification(_U('garage_notavailable'))
						end
					end, function(data2, menu2)
						menu2.close()
					end)

				else
					ESX.ShowNotification(_U('garage_empty'))
				end
			end, type)
		end
		if data.current.action == 'store_garage' then
			StoreNearbyVehicle(playerCoords)
		end

	end, function(data, menu)
		menu.close()
	end)

end

function StoreNearbyVehicle(playerCoords)
	local vehicles, vehiclePlates = ESX.Game.GetVehiclesInArea(playerCoords, 30.0), {}

	if #vehicles > 0 then
		for k, v in ipairs(vehicles) do

			-- Make sure the vehicle we're saving is empty, or else it wont be deleted
			if GetVehicleNumberOfPassengers(v) == 0 and IsVehicleSeatFree(v, -1) then
				table.insert(vehiclePlates, {
					vehicle = v,
					plate = ESX.Math.Trim(GetVehicleNumberPlateText(v))
				})
			end
		end
	else
		ESX.ShowNotification(_U('garage_store_nearby'))
		return
	end

	ESX.TriggerServerCallback('feuilledor:storeNearbyVehicle', function(storeSuccess, foundNum)
		if storeSuccess then
			local vehicleId = vehiclePlates[foundNum]
			local attempts = 0
			ESX.Game.DeleteVehicle(vehicleId.vehicle)
			IsBusy = true

			Citizen.CreateThread(function()
				while IsBusy do
					Citizen.Wait(0)
					drawLoadingText(_U('garage_storing'), 255, 255, 255, 255)
				end
			end)

			-- Workaround for vehicle not deleting when other players are near it.
			while DoesEntityExist(vehicleId.vehicle) do
				Citizen.Wait(500)
				attempts = attempts + 1

				-- Give up
				if attempts > 30 then
					break
				end

				vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 30.0)
				if #vehicles > 0 then
					for k, v in ipairs(vehicles) do
						if ESX.Math.Trim(GetVehicleNumberPlateText(v)) == vehicleId.plate then
							ESX.Game.DeleteVehicle(v)
							break
						end
					end
				end
			end

			IsBusy = false
			ESX.ShowNotification(_U('garage_has_stored'))
		else
			ESX.ShowNotification(_U('garage_has_notstored'))
		end
	end, vehiclePlates)
end

function GetAvailableVehicleSpawnPoint()
	local spawnPoints = Config.Zones.CarGarage.SpawnPoints
	local found, foundSpawnPoint = false, nil

	for i = 1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
			found, foundSpawnPoint = true, spawnPoints[i]
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		ESX.ShowNotification(_U('vehicle_blocked'))
		return false
	end
end

function OpenShopMenu(elements, restoreCoords, shopCoords)
	local playerPed = PlayerPedId()
	isInShopMenu = true

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		css = 'unknownstory',
		title = _U('vehicleshop_title'),
		align = 'top-left',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm',
			{
				css = 'unknownstory',
				title = _U('vehicleshop_confirm', data.current.name, data.current.price),
				align = 'top-left',
				elements = {
					{ label = _U('confirm_no'), value = 'no' },
					{ label = _U('confirm_yes'), value = 'yes' }
				}
			}, function(data2, menu2)
				if data2.current.value == 'yes' then
					local newPlate = exports['esx_vehicleshop']:GeneratePlate()
					local vehicle = GetVehiclePedIsIn(playerPed, false)
					local props = ESX.Game.GetVehicleProperties(vehicle)
					props.plate = newPlate

					ESX.TriggerServerCallback('feuilledor:buyJobVehicle', function(bought)
						if bought then
							ESX.ShowNotification(_U('vehicleshop_bought', data.current.name, ESX.Math.GroupDigits(data.current.price)))
							isInShopMenu = false
							ESX.UI.Menu.CloseAll()
							DeleteSpawnedVehicles()
							FreezeEntityPosition(playerPed, false)
							SetEntityVisible(playerPed, true)
							ESX.Game.Teleport(playerPed, restoreCoords)
						else
							ESX.ShowNotification(_U('vehicleshop_money'))
							menu2.close()
						end
					end, props, data.current.type)
				else
					menu2.close()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
	end, function(data, menu)
		isInShopMenu = false
		ESX.UI.Menu.CloseAll()
		DeleteSpawnedVehicles()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		ESX.Game.Teleport(playerPed, restoreCoords)
	end, function(data, menu)
		DeleteSpawnedVehicles()
		WaitForVehicleToLoad(data.current.model)
		ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)
			table.insert(spawnedVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
			if data.current.livery then
				SetVehicleModKit(vehicle, 0)
				SetVehicleLivery(vehicle, data.current.livery)
			end
		end)
	end)

	WaitForVehicleToLoad(elements[1].model)
	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)
		table.insert(spawnedVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)

		if elements[1].livery then
			SetVehicleModKit(vehicle, 0)
			SetVehicleLivery(vehicle, elements[1].livery)
		end
	end)
end

function DeleteSpawnedVehicles()
	while #spawnedVehicles > 0 do
		local vehicle = spawnedVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(spawnedVehicles, 1)
	end
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)

			DisableControlAction(0, Keys['TOP'], true)
			DisableControlAction(0, Keys['DOWN'], true)
			DisableControlAction(0, Keys['LEFT'], true)
			DisableControlAction(0, Keys['RIGHT'], true)
			DisableControlAction(0, 176, true) -- ENTER key
			DisableControlAction(0, Keys['BACKSPACE'], true)

			drawLoadingText(_U('vehicleshop_awaiting_model'), 255, 255, 255, 255)
		end
	end
end

function OpenBossActionsMenu()
	ESX.UI.Menu.CloseAll()
	local elements = {
		{ label = _U('inventory'), value = 'inventory' }
	}

	if (PlayerData.job.grade_name == 'boss') then
		table.insert(elements, { label = _U('boss_actions'), value = 'boss_actions' })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'feuilledor', {
		css = 'unknownstory',
		title = _U('feuilledor'),
		align = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'feuilledor', function(data2, menu2)
				menu.close()
			end)
		elseif data.current.value == 'inventory' then
			OpenRoomMenu(_U('feuilledor'))
		end
	end, function(data, menu)
		menu.close()
		CurrentAction = 'boss_actions_menu'
		CurrentActionMsg = 'Gestion d\'entreprise'
		CurrentActionData = {}
	end)
end

-- DisableControlAction
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isInShopMenu then
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if PlayerData.job ~= nil and PlayerData.job.name == 'feuilledor' then
			local coords = GetEntityCoords(PlayerPedId())
			local isInMarker = false
			local currentZone
			for k, v in pairs(Config.Cloakrooms) do
				if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker = true
					currentZone = k
				end
			end
			for k, v in pairs(Config.Zones) do
				if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker = true
					currentZone = k
				end
			end
			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone = currentZone
				TriggerEvent('feuilledor:hasEnteredMarker', currentZone)
			end
			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('feuilledor:hasExitedMarker', currentZone)
			end
		end
	end
end)

AddEventHandler('feuilledor:hasEnteredMarker', function(zone)
	if zone == 'Cloakroom' then
		CurrentAction = 'menu_cloakroom'
		CurrentActionMsg = _U('open_cloackroom')
		CurrentActionData = {}
	elseif zone == 'Recolte' then
		CurrentAction = 'recolte'
		CurrentActionMsg = _U('recolte')
		CurrentActionData = {}
		TriggerServerEvent('feuilledor:inMarker')
	elseif zone == 'Traitement' then
		CurrentAction = 'traitement'
		CurrentActionMsg = _U('traitement')
		CurrentActionData = {}
		TriggerServerEvent('feuilledor:inMarker')
	elseif zone == 'Vente' then
		CurrentAction = 'vente'
		CurrentActionMsg = _U('vente')
		CurrentActionData = {}
		TriggerServerEvent('feuilledor:inMarker')
	elseif zone == 'CarGarage' then
		CurrentAction = 'garage'
		CurrentActionMsg = _U('garage')
		CurrentActionData = {}
	elseif zone == 'BossActions' then
		CurrentAction = 'boss_actions_menu'
		CurrentActionMsg = _U('boss_actions')
		CurrentActionData = {}
	end
end)

AddEventHandler('feuilledor:hasExitedMarker', function(zone)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end
	if CurrentAction == 'recolte' then
		rc = false
		TriggerServerEvent('feuilledor:outOfMarker')
	elseif CurrentAction == 'traitement' then
		treating = false
		TriggerServerEvent('feuilledor:outOfMarker')
	elseif CurrentAction == 'vente' then
		vending = false
		TriggerServerEvent('feuilledor:outOfMarker')
	end
	CurrentActionMsg = {}
	CurrentAction = nil
end)

RegisterNetEvent('feuilledor:isVente')
AddEventHandler('feuilledor:isVente', function()
	vending = true
end)

RegisterNetEvent('feuilledor:stopVente')
AddEventHandler('feuilledor:stopVente', function()
	vending = false
end)

RegisterNetEvent('feuilledor:isRecolte')
AddEventHandler('feuilledor:isRecolte', function()
	rc = true
end)

RegisterNetEvent('feuilledor:stopRecolte')
AddEventHandler('feuilledor:stopRecolte', function()
	rc = false
end)

RegisterNetEvent('feuilledor:isTraitement')
AddEventHandler('feuilledor:isTraitement', function()
	treating = true
end)

RegisterNetEvent('feuilledor:stopTraitement')
AddEventHandler('feuilledor:stopTraitement', function()
	treating = false
end)

function OpenMobileFeuilledorActionsMenu()

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_custom_actions', {
		css = 'unknownstory',
		title = _U('custom'),
		align = 'top-left',
		elements = {
			{ label = _U('billing'), value = 'billing' },
		}
	}, function(data, _)
		if isBusy then
			return
		end

		if data.current.value == 'billing' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				title = _U('invoice_amount')
			}, function(data1, menu1)
				local amount = tonumber(data1.value)

				if amount == nil or amount < 0 then
					ESX.ShowNotification(_U('amount_invalid'))
				else
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('no_players_nearby'))
					else
						menu1.close()
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_feuilledor', _U('feuilledor'), amount)
					end
				end
			end, function(_, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

-- Display Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.Vente.Pos.x, Config.Zones.Vente.Pos.y, Config.Zones.Vente.Pos.z)

	SetBlipSprite(blip, 140)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipColour(blip, 52)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('La Feuille d\'Or')
	EndTextCommandSetBlipName(blip)
end)

-- Draw Marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if PlayerData.job ~= nil and PlayerData.job.name == 'feuilledor' then
			local coords = GetEntityCoords(PlayerPedId())
			for k, v in pairs(Config.Cloakrooms) do
				if (v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, nil, nil, false)
				end
			end
			if playerInService == true then
				for k, v in pairs(Config.Zones) do
					if (v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
						DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, nil, nil, false)
					end
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustReleased(0, Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'feuilledor' then
			OpenMobileFeuilledorActionsMenu()
		end
		if CurrentAction == 'menu_cloakroom' and (not playerInService or playerInService) then
			ESX.ShowHelpNotification(CurrentActionMsg)
			if IsControlJustReleased(0, Keys['E']) then
				OpenCloakroomMenu()
			end
		end
		if playerInService then
			if not vending and CurrentAction == 'vente' then
				ESX.ShowHelpNotification(CurrentActionMsg)
				if IsControlJustReleased(0, Keys['E']) then
					TriggerServerEvent('feuilledor:startVente')
				end
			elseif not rc and CurrentAction == 'recolte' then
				ESX.ShowHelpNotification(CurrentActionMsg)
				if IsControlJustReleased(0, Keys['E']) then
					TriggerServerEvent('feuilledor:startRecolte')
				end
			elseif not treating and CurrentAction == 'traitement' then
				ESX.ShowHelpNotification(CurrentActionMsg)
				if IsControlJustReleased(0, Keys['E']) then
					TriggerServerEvent('feuilledor:startTraitement')
				end
			elseif CurrentAction == 'garage' then
				ESX.ShowHelpNotification(CurrentActionMsg)
				if IsControlJustReleased(0, Keys['E']) then
					OpenVehicleSpawnerMenu('car')
				end
			elseif CurrentAction == 'boss_actions_menu' and playerInService then
				ESX.ShowHelpNotification(CurrentActionMsg)
				if IsControlJustReleased(0, Keys['E']) then
					OpenBossActionsMenu()
				end
			end
		end
	end
end)

-- Coffre

function OpenRoomMenu(property)
	local elements = {}

	table.insert(elements, { label = _U('remove_object'), value = 'room_inventory' })
	table.insert(elements, { label = _U('deposit_object'), value = 'player_inventory' })

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room',
		{
			css = 'unknownstory',
			title = property,
			align = 'top-left',
			elements = elements
		}, function(data, menu)

			if data.current.value == 'room_inventory' then
				OpenGetStocksMenu()
			elseif data.current.value == 'player_inventory' then
				OpenPutStocksMenu()
			end

		end, function(data, menu)
			menu.close()
		end)
end

function OpenGetStocksMenu()

	ESX.TriggerServerCallback('feuilledor:getStockItems', function(inventory)

		local elements = {}

		for i = 1, #inventory.items, 1 do
			table.insert(elements, {
				label = 'x' .. inventory.items[i].count .. ' ' .. inventory.items[i].label,
				type = 'item_standard',
				value = inventory.items[i].name
			})
		end

		for i = 1, #inventory.weapons, 1 do
			local weapon = inventory.weapons[i]

			table.insert(elements, {
				label = ESX.GetWeaponLabel(weapon.name) .. ' [' .. weapon.ammo .. ']',
				type = 'item_weapon',
				value = weapon.name,
				ammo = weapon.ammo
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
			{ css = 'unknownstory',
			  title = _U('feuilledor_stock'),
			  align = 'top-left',
			  elements = elements
			}, function(data, menu)

				if data.current.type == 'item_standard' then
					local itemName = data.current.value

					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
						title = _U('quantity')
					}, function(data2, menu2)

						local count = tonumber(data2.value)

						if count == nil then
							ESX.ShowNotification(_U('quantity_invalid'))
						else
							menu2.close()
							menu.close()
							TriggerServerEvent('feuilledor:getStockItem', data.current.type, itemName, count)

							Citizen.Wait(300)
							OpenGetStocksMenu()
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.type == 'item_weapon' then
					menu.close()

					TriggerServerEvent('feuilledor:getStockItem', data.current.type, data.current.value, data.current.ammo)
					ESX.SetTimeout(300, function()
						OpenGetStocksMenu()
					end)
				end
			end, function(data, menu)
				menu.close()
			end)

	end)

end

function OpenPutStocksMenu()

	ESX.TriggerServerCallback('feuilledor:getPlayerInventory', function(inventory)

		local elements = {}

		for i = 1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		for i = 1, #inventory.weapons, 1 do
			local weapon = inventory.weapons[i]

			table.insert(elements, {
				label = weapon.label .. ' [' .. weapon.ammo .. ']',
				type = 'item_weapon',
				value = weapon.name,
				ammo = weapon.ammo
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
			{ css = 'unknownstory',
			  title = _U('inventory'),
			  align = 'top-left',
			  elements = elements
			}, function(data, menu)

				if data.current.type == 'item_standard' then
					local itemName = data.current.value

					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
						title = _U('quantity')
					}, function(data2, menu2)

						local count = tonumber(data2.value)

						if count == nil then
							ESX.ShowNotification(_U('quantity_invalid'))
						else
							menu2.close()
							menu.close()
							TriggerServerEvent('feuilledor:putStockItems', data.current.type, itemName, count)

							Citizen.Wait(300)
							OpenPutStocksMenu()
						end

					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.type == 'item_weapon' then
					menu.close()
					TriggerServerEvent('feuilledor:putStockItems', data.current.type, data.current.value, data.current.ammo)

					ESX.SetTimeout(300, function()
						OpenPutStocksMenu()
					end)
				end
			end, function(data, menu)
				menu.close()
			end)
	end)
end
