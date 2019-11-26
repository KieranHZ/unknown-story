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
local Vehicles = {}
local lsMenuIsShowed = false
local myCar = {}
local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg
local CurrentActionData = {}
local playerInService = false
local Blips = {}
local OnJob = false
local Done = false
local spawnedVehicles, isInShopMenu = {}, false

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
	ESX.TriggerServerCallback('us_custom:getVehiclesPrices', function(vehicles)
		Vehicles = vehicles
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('us_custom:installMod')
AddEventHandler('us_custom:installMod', function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	myCar = ESX.Game.GetVehicleProperties(vehicle)
	TriggerServerEvent('us_custom:refreshOwnedVehicle', myCar)
end)

RegisterNetEvent('us_custom:cancelInstallMod')
AddEventHandler('us_custom:cancelInstallMod', function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	ESX.Game.SetVehicleProperties(vehicle, myCar)
end)

AddEventHandler('us_custom:hasEnteredMarker', function(zone)
	if zone == 'CustomActions' then
		CurrentAction = 'custom_actions_menu'
		CurrentActionMsg = _U('open_actions')
	elseif zone == 'Cloakroom' then
		CurrentAction = 'menu_cloakroom'
		CurrentActionMsg = _U('open_cloackroom')
		CurrentActionData = {}
	elseif zone == 'Vente' then
		CurrentAction = 'vente'
		CurrentActionMsg = Config.Zones.Vente.hint
		CurrentActionData = {}
	elseif zone == 'CarGarage' then
		CurrentAction = 'vehiclespawn_menu'
		CurrentActionMsg = Config.Zones.CarGarage.hint
		CurrentActionData = {}
	elseif zone == 'ls1' or zone == 'ls2' then
		CurrentAction = 'main'
		CurrentActionMsg = _U('press_custom')
	end
end)

AddEventHandler('us_custom:hasExitedMarker', function(zone)
	if CurrentAction == 'vente' then
		TriggerServerEvent('us_custom:stopVente')
	end
	CurrentAction = nil
end)

function OpenLSMenu(elems, menuName, menuTitle, parent)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), menuName,
		{
			css = 'unknownstory',
			title = menuTitle,
			align = 'top-left',
			elements = elems
		}, function(data, menu)
			local isRimMod, found = false, false
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

			if data.current.modType == "modFrontWheels" then
				isRimMod = true
			end

			for k, v in pairs(Config.Menus) do

				if k == data.current.modType or isRimMod then

					if data.current.label == _U('by_default') or string.match(data.current.label, _U('installed')) then
						ESX.ShowNotification(_U('already_own', data.current.label))
						TriggerEvent('us_custom:installMod')
					else
						local vehiclePrice = 50000
						for i = 1, #Vehicles, 1 do
							if GetEntityModel(vehicle) == GetHashKey(Vehicles[i].model) then
								vehiclePrice = Vehicles[i].price
								break
							end
						end
						if isRimMod then
							price = math.floor((vehiclePrice * data.current.price / 100) / 2)
							TriggerServerEvent("us_custom:buyMod", price)
						elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
							price = math.floor((vehiclePrice * v.price[data.current.modNum + 1] / 100) / 2)
							TriggerServerEvent("us_custom:buyMod", price)
						elseif v.modType == 17 then
							price = math.floor((vehiclePrice * v.price[1] / 100) / 2)
							TriggerServerEvent("us_custom:buyMod", price)
						else
							price = math.floor((vehiclePrice * v.price / 100) / 2)
							TriggerServerEvent("us_custom:buyMod", price)
						end
					end

					menu.close()
					found = true
					break
				end

			end

			if not found then
				GetAction(data.current)
			end
		end, function(data, menu)
			-- on cancel
			menu.close()
			TriggerEvent('us_custom:cancelInstallMod')

			local playerPed = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			SetVehicleDoorsShut(vehicle, false)

			if parent == nil then
				lsMenuIsShowed = false
				vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
				FreezeEntityPosition(vehicle, false)
				myCar = {}
			end
		end, function(data, menu)
			-- on change
			UpdateMods(data.current)
		end)
end

function OpenCustomActionsMenu()
	local elements = {
		{ label = _U('inventory'), value = 'inventory' }
	}

	if PlayerData.job and PlayerData.job.grade_name == 'boss' then
		table.insert(elements, { label = _U('boss_actions'), value = 'boss_actions' })
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'custom_actions', {
		css = 'unknownstory',
		title = _U('custom'),
		align = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'custom', function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'inventory' then
			OpenRoomMenu(_U('inventory'))
		end
	end, function(data, menu)
		menu.close()
		CurrentAction = 'custom_actions_menu'
	end)
end

function UpdateMods(data)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

	if data.modType ~= nil then
		local props = {}

		if data.wheelType ~= nil then
			props['wheels'] = data.wheelType
			SetVehiclePropertiesCustom(vehicle, props)
			props = {}
		elseif data.modType == 'neonColor' then
			if data.modNum[1] == 0 and data.modNum[2] == 0 and data.modNum[3] == 0 then
				props['neonEnabled'] = { false, false, false, false }
			else
				props['neonEnabled'] = { true, true, true, true }
			end
			SetVehiclePropertiesCustom(vehicle, props)
			props = {}
		elseif data.modType == 'tyreSmokeColor' then
			props['modSmokeEnabled'] = true
			SetVehiclePropertiesCustom(vehicle, props)
			props = {}
		end

		props[data.modType] = data.modNum
		SetVehiclePropertiesCustom(vehicle, props)
	end
end

function GetAction(data)
	local elements = {}
	local menuName = ''
	local menuTitle = ''
	local parent
	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	local currentMods = ESX.Game.GetVehicleProperties(vehicle)

	if data.value == 'modSpeakers' or
		data.value == 'modTrunk' or
		data.value == 'modHydrolic' or
		data.value == 'modEngineBlock' or
		data.value == 'modAirFilter' or
		data.value == 'modStruts' or
		data.value == 'modTank' then
		SetVehicleDoorOpen(vehicle, 4, false)
		SetVehicleDoorOpen(vehicle, 5, false)
	elseif data.value == 'modDoorSpeaker' then
		SetVehicleDoorOpen(vehicle, 0, false)
		SetVehicleDoorOpen(vehicle, 1, false)
		SetVehicleDoorOpen(vehicle, 2, false)
		SetVehicleDoorOpen(vehicle, 3, false)
	else
		SetVehicleDoorsShut(vehicle, false)
	end

	local vehiclePrice = 50000

	for i = 1, #Vehicles, 1 do
		if GetEntityModel(vehicle) == GetHashKey(Vehicles[i].model) then
			vehiclePrice = Vehicles[i].price
			break
		end
	end

	for k, v in pairs(Config.Menus) do

		if data.value == k then

			menuName = k
			menuTitle = v.label
			parent = v.parent

			if v.modType ~= nil then

				if v.modType == 22 then
					table.insert(elements, { label = " " .. _U('by_default'), modType = k, modNum = false })
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then
					-- disable neon
					table.insert(elements, { label = " " .. _U('by_default'), modType = k, modNum = { 0, 0, 0 } })
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then
					local num = myCar[v.modType]
					table.insert(elements, { label = " " .. _U('by_default'), modType = k, modNum = num })
				elseif v.modType == 17 then
					table.insert(elements, { label = " " .. _U('no_turbo'), modType = k, modNum = false })
				else
					table.insert(elements, { label = " " .. _U('by_default'), modType = k, modNum = -1 })
				end

				if v.modType == 14 then
					-- HORNS
					for j = 0, 51, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = GetHornName(j) .. ' - <span style="color:cornflowerblue;">' .. _U('installed') .. '</span>'
						else
							price = math.floor(vehiclePrice * v.price / 100)
							_label = GetHornName(j) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, { label = _label, modType = k, modNum = j })
					end
				elseif v.modType == 'plateIndex' then
					-- PLATES
					for j = 0, 4, 1 do
						local _label = ''
						if j == currentMods.plateIndex then
							_label = GetPlatesName(j) .. ' - <span style="color:cornflowerblue;">' .. _U('installed') .. '</span>'
						else
							price = math.floor(vehiclePrice * v.price / 100)
							_label = GetPlatesName(j) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, { label = _label, modType = k, modNum = j })
					end
				elseif v.modType == 22 then
					-- NEON
					local _label = ''
					if currentMods.modXenon then
						_label = _U('neon') .. ' - <span style="color:cornflowerblue;">' .. _U('installed') .. '</span>'
					else
						price = math.floor(vehiclePrice * v.price / 100)
						_label = _U('neon') .. ' - <span style="color:green;">$' .. price .. ' </span>'
					end
					table.insert(elements, { label = _label, modType = k, modNum = true })
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then
					-- NEON & SMOKE COLOR
					local neons = GetNeons()
					price = math.floor(vehiclePrice * v.price / 100)
					for i = 1, #neons, 1 do
						table.insert(elements, {
							label = '<span style="color:rgb(' .. neons[i].r .. ',' .. neons[i].g .. ',' .. neons[i].b .. ');">' .. neons[i].label .. ' - <span style="color:green;">$' .. price .. '</span>',
							modType = k,
							modNum = { neons[i].r, neons[i].g, neons[i].b }
						})
					end
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then
					-- RESPRAYS
					local colors = GetColors(data.color)
					for j = 1, #colors, 1 do
						local _label = ''
						price = math.floor(vehiclePrice * v.price / 100)
						_label = colors[j].label .. ' - <span style="color:green;">$' .. price .. ' </span>'
						table.insert(elements, { label = _label, modType = k, modNum = colors[j].index })
					end
				elseif v.modType == 'windowTint' then
					-- WINDOWS TINT
					for j = 1, 5, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = GetWindowName(j) .. ' - <span style="color:cornflowerblue;">' .. _U('installed') .. '</span>'
						else
							price = math.floor(vehiclePrice * v.price / 100)
							_label = GetWindowName(j) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, { label = _label, modType = k, modNum = j })
					end
				elseif v.modType == 23 then
					-- WHEELS RIM & TYPE
					local props = {}

					props['wheels'] = v.wheelType
					SetVehiclePropertiesCustom(vehicle, props)

					local modCount = GetNumVehicleMods(vehicle, v.modType)
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName ~= nil then
							local _label = ''
							if j == currentMods.modFrontWheels then
								_label = GetLabelText(modName) .. ' - <span style="color:cornflowerblue;">' .. _U('installed') .. '</span>'
							else
								price = math.floor(vehiclePrice * v.price / 100)
								_label = GetLabelText(modName) .. ' - <span style="color:green;">$' .. price .. ' </span>'
							end
							table.insert(elements, { label = _label, modType = 'modFrontWheels', modNum = j, wheelType = v.wheelType, price = v.price })
						end
					end
				elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- UPGRADES
					for j = 0, modCount, 1 do
						local _label = ''
						if j == currentMods[k] then
							_label = _U('level', j + 1) .. ' - <span style="color:cornflowerblue;">' .. _U('installed') .. '</span>'
						else
							price = math.floor(vehiclePrice * v.price[j + 1] / 100)
							_label = _U('level', j + 1) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, { label = _label, modType = k, modNum = j })
						if j == modCount - 1 then
							break
						end
					end
				elseif v.modType == 17 then
					-- TURBO
					local _label = ''
					if currentMods[k] then
						_label = 'Turbo - <span style="color:cornflowerblue;">' .. _U('installed') .. '</span>'
					else
						_label = 'Turbo - <span style="color:green;">$' .. math.floor(vehiclePrice * v.price[1] / 100) .. ' </span>'
					end
					table.insert(elements, { label = _label, modType = k, modNum = true })
				else
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- BODYPARTS
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName ~= nil then
							local _label = ''
							if j == currentMods[k] then
								_label = GetLabelText(modName) .. ' - <span style="color:cornflowerblue;">' .. _U('installed') .. '</span>'
							else
								price = math.floor(vehiclePrice * v.price / 100)
								_label = GetLabelText(modName) .. ' - <span style="color:green;">$' .. price .. ' </span>'
							end
							table.insert(elements, { label = _label, modType = k, modNum = j })
						end
					end
				end
			else
				if data.value == 'primaryRespray' or data.value == 'secondaryRespray' or data.value == 'pearlescentRespray' or data.value == 'modFrontWheelsColor' then
					for i = 1, #Config.Colors, 1 do
						if data.value == 'primaryRespray' then
							table.insert(elements, { label = Config.Colors[i].label, value = 'color1', color = Config.Colors[i].value })
						elseif data.value == 'secondaryRespray' then
							table.insert(elements, { label = Config.Colors[i].label, value = 'color2', color = Config.Colors[i].value })
						elseif data.value == 'pearlescentRespray' then
							table.insert(elements, { label = Config.Colors[i].label, value = 'pearlescentColor', color = Config.Colors[i].value })
						elseif data.value == 'modFrontWheelsColor' then
							table.insert(elements, { label = Config.Colors[i].label, value = 'wheelColor', color = Config.Colors[i].value })
						end
					end
				else
					for l, w in pairs(v) do
						if l ~= 'label' and l ~= 'parent' then
							table.insert(elements, { label = w, value = l })
						end
					end
				end
			end
			break
		end
	end

	table.sort(elements, function(a, b)
		return a.label < b.label
	end)

	OpenLSMenu(elements, menuName, menuTitle, parent)
end

function OpenCloakroomMenu()
	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name
	local elements = {
		{ label = _U('citizen_wear'), value = 'citizen_wear' },
	}

	if grade == 'recruit' then
		table.insert(elements, { label = _U('job_wear'), value = 'recruit_wear' })
	elseif grade == 'experienced' then
		table.insert(elements, { label = _U('job_wear'), value = 'experienced_wear' })
	elseif grade == 'boss' then
		table.insert(elements, { label = _U('job_wear'), value = 'boss_wear' })
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

							TriggerServerEvent('esx_service:notifyAllInService', notification, 'custom')

							TriggerServerEvent('esx_service:disableService', 'custom', PlayerData.identifier)
							ESX.ShowNotification(_U('service_out'))
						end
					end, 'custom', PlayerData.identifier)
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
								TriggerServerEvent('esx_service:notifyAllInService', notification, 'custom')
								ESX.ShowNotification(_U('service_in'))
							end
						end, 'custom', PlayerData.identifier)
					else
						serviceOk = true
					end
				end, 'custom', PlayerData.identifier)
				while type(serviceOk) == 'string' do
					Citizen.Wait(5)
				end
				-- if we couldn't enter service don't let the player get changed
				if not serviceOk then
					return
				end
			end
			if
			data.current.value == 'recruit_wear' or
				data.current.value == 'experienced_wear' or
				data.current.value == 'boss_wear'
			then
				setUniform(data.current.value, playerPed)
			end
		end, function(data, menu)
			menu.close()
			CurrentAction = nil
		end)
end

function OpenMobileCustomActionsMenu()

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_custom_actions', {
		css = 'unknownstory',
		title = _U('custom'),
		align = 'top-left',
		elements = {
			{ label = _U('billing'), value = 'billing' },
			{ label = _U('clean'), value = 'clean_vehicle' },
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
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_custom', _U('custom'), amount)
					end
				end
			end, function(_, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'clean_vehicle' then

			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()
			local coords = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(10000)

					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(_U('vehicle_cleaned'))
					isBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

function setUniform(job, playerPed)
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
--///////////////////////////////////////////////////////////
--Surcharge de ESX.Game.SetVehicleProperties(vehicule, props)
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SetVehiclePropertiesCustom = function(vehicle, props)
	SetVehicleModKit(vehicle, 0)

	if props.plate ~= nil then
		SetVehicleNumberPlateText(vehicle, props.plate)
	end

	if props.plateIndex ~= nil then
		SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
	end

	if props.health ~= nil then
		SetEntityHealth(vehicle, props.health)
	end

	if props.dirtLevel ~= nil then
		SetVehicleDirtLevel(vehicle, props.dirtLevel)
	end

	if props.color1 ~= nil then
		local _, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, props.color1, color2)
	end

	if props.color2 ~= nil then
		local color1, _ = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, color1, props.color2)
	end

	if props.pearlescentColor ~= nil then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
	end

	if props.wheelColor ~= nil then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, pearlescentColor, props.wheelColor)
	end

	if props.wheels ~= nil then
		SetVehicleWheelType(vehicle, props.wheels)
	end

	if props.windowTint ~= nil then
		SetVehicleWindowTint(vehicle, props.windowTint)
	end

	if props.neonEnabled ~= nil then
		SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
		SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
		SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
		SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
	end

	if props.extras ~= nil then
		for id, enabled in pairs(props.extras) do
			if enabled then
				SetVehicleExtra(vehicle, tonumber(id), 0)
			else
				SetVehicleExtra(vehicle, tonumber(id), 1)
			end
		end
	end

	if props.neonColor ~= nil then
		SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
	end

	if props.modSmokeEnabled ~= nil then
		ToggleVehicleMod(vehicle, 20, true)
	end

	if props.tyreSmokeColor ~= nil then
		SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
	end

	if props.modSpoilers ~= nil then
		SetVehicleMod(vehicle, 0, props.modSpoilers, false)
	end

	if props.modFrontBumper ~= nil then
		SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
	end

	if props.modRearBumper ~= nil then
		SetVehicleMod(vehicle, 2, props.modRearBumper, false)
	end

	if props.modSideSkirt ~= nil then
		SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
	end

	if props.modExhaust ~= nil then
		SetVehicleMod(vehicle, 4, props.modExhaust, false)
	end

	if props.modFrame ~= nil then
		SetVehicleMod(vehicle, 5, props.modFrame, false)
	end

	if props.modGrille ~= nil then
		SetVehicleMod(vehicle, 6, props.modGrille, false)
	end

	if props.modHood ~= nil then
		SetVehicleMod(vehicle, 7, props.modHood, false)
	end

	if props.modFender ~= nil then
		SetVehicleMod(vehicle, 8, props.modFender, false)
	end

	if props.modRightFender ~= nil then
		SetVehicleMod(vehicle, 9, props.modRightFender, false)
	end

	if props.modRoof ~= nil then
		SetVehicleMod(vehicle, 10, props.modRoof, false)
	end

	if props.modEngine ~= nil then
		SetVehicleMod(vehicle, 11, props.modEngine, false)
	end

	if props.modBrakes ~= nil then
		SetVehicleMod(vehicle, 12, props.modBrakes, false)
	end

	if props.modTransmission ~= nil then
		SetVehicleMod(vehicle, 13, props.modTransmission, false)
	end

	if props.modHorns ~= nil then
		SetVehicleMod(vehicle, 14, props.modHorns, false)
	end

	if props.modSuspension ~= nil then
		SetVehicleMod(vehicle, 15, props.modSuspension, false)
	end

	if props.modArmor ~= nil then
		SetVehicleMod(vehicle, 16, props.modArmor, false)
	end

	if props.modTurbo ~= nil then
		ToggleVehicleMod(vehicle, 18, props.modTurbo)
	end

	if props.modXenon ~= nil then
		ToggleVehicleMod(vehicle, 22, props.modXenon)
	end

	if props.modFrontWheels ~= nil then
		SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
	end

	if props.modBackWheels ~= nil then
		SetVehicleMod(vehicle, 24, props.modBackWheels, false)
	end

	if props.modPlateHolder ~= nil then
		SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
	end

	if props.modVanityPlate ~= nil then
		SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
	end

	if props.modTrimA ~= nil then
		SetVehicleMod(vehicle, 27, props.modTrimA, false)
	end

	if props.modOrnaments ~= nil then
		SetVehicleMod(vehicle, 28, props.modOrnaments, false)
	end

	if props.modDashboard ~= nil then
		SetVehicleMod(vehicle, 29, props.modDashboard, false)
	end

	if props.modDial ~= nil then
		SetVehicleMod(vehicle, 30, props.modDial, false)
	end

	if props.modDoorSpeaker ~= nil then
		SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
	end

	if props.modSeats ~= nil then
		SetVehicleMod(vehicle, 32, props.modSeats, false)
	end

	if props.modSteeringWheel ~= nil then
		SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
	end

	if props.modShifterLeavers ~= nil then
		SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
	end

	if props.modAPlate ~= nil then
		SetVehicleMod(vehicle, 35, props.modAPlate, false)
	end

	if props.modSpeakers ~= nil then
		SetVehicleMod(vehicle, 36, props.modSpeakers, false)
	end

	if props.modTrunk ~= nil then
		SetVehicleMod(vehicle, 37, props.modTrunk, false)
	end

	if props.modHydrolic ~= nil then
		SetVehicleMod(vehicle, 38, props.modHydrolic, false)
	end

	if props.modEngineBlock ~= nil then
		SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
	end

	if props.modAirFilter ~= nil then
		SetVehicleMod(vehicle, 40, props.modAirFilter, false)
	end

	if props.modStruts ~= nil then
		SetVehicleMod(vehicle, 41, props.modStruts, false)
	end

	if props.modArchCover ~= nil then
		SetVehicleMod(vehicle, 42, props.modArchCover, false)
	end

	if props.modAerials ~= nil then
		SetVehicleMod(vehicle, 43, props.modAerials, false)
	end

	if props.modTrimB ~= nil then
		SetVehicleMod(vehicle, 44, props.modTrimB, false)
	end

	if props.modTank ~= nil then
		SetVehicleMod(vehicle, 45, props.modTank, false)
	end

	if props.modWindows ~= nil then
		SetVehicleMod(vehicle, 46, props.modWindows, false)
	end

	if props.modLivery ~= nil then
		SetVehicleMod(vehicle, 48, props.modLivery, false)
		SetVehicleLivery(vehicle, props.modLivery)
	end
end

-- Blips
Citizen.CreateThread(function()
	for _, v in pairs(Config.Zones) do
		if v.Hide == false then
			local blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)
			SetBlipSprite(blip, 72)
			SetBlipScale(blip, 0.7)
			SetBlipColour(blip, 83)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(v.Name)
			EndTextCommandSetBlipName(blip)
		end
	end
end)

-- Prevent Free Tunning Bug
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if lsMenuIsShowed then
			DisableControlAction(2, Keys['F1'], true)
			DisableControlAction(2, Keys['F2'], true)
			DisableControlAction(2, Keys['F3'], true)
			DisableControlAction(2, Keys['F6'], true)
			DisableControlAction(2, Keys['F7'], true)
			DisableControlAction(2, Keys['F'], true)
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
		if PlayerData.job ~= nil and PlayerData.job.name == 'custom' then
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
				TriggerEvent('us_custom:hasEnteredMarker', currentZone)
			end
			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('us_custom:hasExitedMarker', currentZone)
			end
		end
	end
end)

-- Draw Marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if PlayerData.job ~= nil and PlayerData.job.name == 'custom' then
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
		local playerPed = PlayerPedId()
		if IsControlJustReleased(0, Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'custom' then
			OpenMobileCustomActionsMenu()
		end
		if not playerInService or playerInService then
			if CurrentAction == 'menu_cloakroom' then
				ESX.ShowHelpNotification(CurrentActionMsg)
				if IsControlJustReleased(0, Keys['E']) then
					OpenCloakroomMenu()
				end
			end
		end
		if playerInService and OnJob == false then
			if CurrentAction == 'custom_actions_menu' then
				ESX.ShowHelpNotification(CurrentActionMsg)

				if IsControlJustReleased(0, Keys['E']) and PlayerData.job and PlayerData.job.name == 'custom' then
					OpenCustomActionsMenu()
				end
			elseif CurrentAction == 'main' and not lsMenuIsShowed then
				ESX.ShowHelpNotification(CurrentActionMsg)

				if IsControlJustReleased(0, Keys['E']) and PlayerData.job and PlayerData.job.name == 'custom' then
					if IsPedInAnyVehicle(playerPed, false) then
						lsMenuIsShowed = true
						local vehicle = GetVehiclePedIsIn(playerPed, false)
						FreezeEntityPosition(vehicle, true)

						myCar = ESX.Game.GetVehicleProperties(vehicle)

						ESX.UI.Menu.CloseAll()
						GetAction({ value = 'main' })
					end
				end
			elseif CurrentAction == 'vehiclespawn_menu' then
				ESX.ShowHelpNotification(CurrentActionMsg)

				if IsControlJustReleased(0, Keys['E']) and PlayerData.job and PlayerData.job.name == 'custom' then
					if IsPedInAnyVehicle(playerPed, 0) then
						ESX.ShowNotification(_U('in_vehicle'))
					else
						OpenVehicleSpawnerMenu('car')
					end
				end
			elseif CurrentAction == 'vente' then
				ESX.ShowHelpNotification(CurrentActionMsg)
				if IsControlJustReleased(0, Keys['E']) and PlayerData.job and PlayerData.job.name == 'custom' then
					TriggerServerEvent('us_custom:startVente')
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(1, Keys['DELETE']) and PlayerData.job ~= nil and PlayerData.job.name == 'custom' then
			if OnJob then
				StopNPCJob(true)
				RemoveBlip(Blips['NPCTargetDAB'])
				OnJob = false
			else
				local playerPed = GetPlayerPed(-1)
				if IsPedInAnyVehicle(playerPed, false) and IsVehicleModel(GetVehiclePedIsIn(playerPed, false), GetHashKey('SlamVan3')) then
					StartNPCJob()
					OnJob = true
				else
					ESX.ShowNotification(_U('not_good_veh'))
				end
			end
		end
	end
end)

-- Prise du véhicule
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
			ESX.ShowNotification('shopcoords')
			if #Config.AuthorizedVehicles['Shared'] > 0 then
				ESX.ShowNotification('authorizedVehicles > 0')
				for k, vehicle in ipairs(Config.AuthorizedVehicles['Shared']) do
					table.insert(shopElements, {
						label = ('%s - <span style="color:green;">%s</span>'):format(vehicle.label, _U('shop_item', ESX.Math.GroupDigits(vehicle.price))),
						name = vehicle.label,
						model = vehicle.model,
						price = vehicle.price,
						type = 'car'
					})
					ESX.ShowNotification('Inserting Vehicle')
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

	ESX.TriggerServerCallback('us_custom:storeNearbyVehicle', function(storeSuccess, foundNum)
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

					ESX.TriggerServerCallback('us_custom:buyJobVehicle', function(bought)
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


--NPC Missions
function SelectDAB()
	local index = GetRandomIntInRange(1, #Config.DAB)
	for k, v in pairs(Config.Zones) do
		if v.Pos.x == Config.DAB[index].x and v.Pos.y == Config.DAB[index].y and v.Pos.z == Config.DAB[index].z then
			return k
		end
	end
end

function StartNPCJob()
	NPCTargetDAB = SelectDAB()
	local zone = Config.Zones[NPCTargetDAB]

	OnJob = true
	Blips['NPCTargetDAB'] = AddBlipForCoord(zone.Pos.x, zone.Pos.y, zone.Pos.z)
	SetBlipRoute(Blips['NPCTargetDAB'], true)
	ESX.ShowNotification(_U('GPS_info'))
	Done = true
end

function StopNPCJob(cancel)
	if Blips['NPCTargetDAB'] ~= nil then
		RemoveBlip(Blips['NPCTargetDAB'])
		Blips['NPCTargetDAB'] = nil
	end

	OnJob = false

	if cancel then
		ESX.ShowNotification(_U('cancel_mission'))
	else
		TriggerServerEvent('us_custom:GiveItem')
		StartNPCJob()
		Done = true
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NPCTargetDAB ~= nil and OnJob == true then
			local coords = GetEntityCoords(GetPlayerPed(-1))
			local zone = Config.Zones[NPCTargetDAB]
			if GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < 3 then
				HelpPromt(_U('pickup'))
				if IsControlJustReleased(1, Keys['N5']) and PlayerData.job ~= nil then
					StopNPCJob()
					Wait(300)
					Done = false
				end
			end
		end
	end
end)

function HelpPromt(text)
	Citizen.CreateThread(function()
		SetTextComponentFormat('STRING')
		AddTextComponentString(text)
		DisplayHelpTextFromStringLabel(0, state, 0, -1)
	end)
end

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

	ESX.TriggerServerCallback('custom:getStockItems', function(inventory)

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
			{
				css = 'unknownstory',
				title = _U('custom_stock'),
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
							TriggerServerEvent('custom:getStockItem', data.current.type, itemName, count)

							Citizen.Wait(300)
							OpenGetStocksMenu()
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.type == 'item_weapon' then
					menu.close()

					TriggerServerEvent('custom:getStockItem', data.current.type, data.current.value, data.current.ammo)
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

	ESX.TriggerServerCallback('custom:getPlayerInventory', function(inventory)

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
			{
				css = 'unknownstory',
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
							TriggerServerEvent('custom:putStockItems', data.current.type, itemName, count)

							Citizen.Wait(300)
							OpenPutStocksMenu()
						end

					end, function(data2, menu2)
						menu2.close()
					end)
				elseif data.current.type == 'item_weapon' then
					menu.close()
					TriggerServerEvent('custom:putStockItems', data.current.type, data.current.value, data.current.ammo)

					ESX.SetTimeout(300, function()
						OpenPutStocksMenu()
					end)
				end
			end, function(data, menu)
				menu.close()
			end)
	end)
end
