isHolding = false
holdingProp = nil

stolenItems = {}
currentItem = {}

Citizen.CreateThread(function()
	RequestAnimDict("anim@heists@box_carry@")
	
	-- preload animation
	while not HasAnimDictLoaded("anim@heists@box_carry@") do 
		Citizen.Wait(0)
	end

	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())

		if isHolding then
			-- draws marker at our van
			local markerCoords = GetOffsetFromEntityInWorldCoords(NetToVeh(currentVan), 0.0, -4.5, -1.8)

			DrawMarker(1, markerCoords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 2.5, 204, 255, 0, 50, false, true, 2, nil, nil, false)
			-- detach/drop
			if IsControlJustPressed(0, 51) then
				local isInHouse, house = GetCurrentHouse()

				if isInHouse then
					-- always drop inside house
					DetachEntity(holdingProp)
					ClearPedTasks(PlayerPedId())

					holdingProp = nil
					isHolding = false
					SetPedCanSwitchWeapon(PlayerPedId(), not isHolding)

					currentItem = {}
				else
					-- if outside only drop next to van
					if Vdist(markerCoords, coords) < 3 then
						ShowSubtitle("Objet en sûreté, retournez à l'intérieur pour en voler d'autres.")

						-- send to server
						TriggerServerEvent("burglary:collected", currentItem.id, currentItem.house)

						table.insert(stolenItems, currentItem)
						currentItem = {}

						ClearPedTasks(PlayerPedId())
						DetachEntity(holdingProp)

						Wait(1000)

						SetEntityAsMissionEntity(holdingProp)
						DeleteObject(holdingProp)

						holdingProp = nil
						isHolding = false
						SetPedCanSwitchWeapon(PlayerPedId(), not isHolding)
					end
				end
			end
		else
			if onMission and not isHolding then
				for _,pickup in pairs(pickups) do
					local pickupCoord = GetEntityCoords(pickup.prop)
					local min, max = GetModelDimensions(GetEntityModel(pickup.prop))

					-- show marker above                                                           dir    |       rot
					DrawMarker(20, pickupCoord.x, pickupCoord.y, pickupCoord.z + max.z + 0.3, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 50, true, true, 2, nil, nil, false)

					if Vdist(coords, GetEntityCoords(pickup.prop)) < 2 then
						DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour voler l'objet.")

						-- if pressed E
						if IsControlJustPressed(0, 51) then
							-- steal/pickup prop
							AttachEntityToEntity(pickup.prop, PlayerPedId(), --[[GetPedBoneIndex(PlayerPedId(), 60309)]] -1, 0.0, 0.5, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 2, true)

							TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "walk", 1.0, 1.0, -1, 1 | 16 | 32, 0.0, 0, 0, 0)

							holdingProp = pickup.prop
							isHolding = true

							currentItem = pickup.item

							SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)
							SetPedCanSwitchWeapon(PlayerPedId(), not isHolding)

							ShowSubtitle("Vous avez prit l'objet, amenez-le au camion à l'exterieur.")
							RemoveBlip(pickup.blip)
						end
					end
				end
			else
				Citizen.Wait(500)
			end
		end
	end
end)
