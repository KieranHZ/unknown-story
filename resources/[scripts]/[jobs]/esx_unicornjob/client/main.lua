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

local PlayerData = {}
local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local Blips = {}

local isBarman = false
local isInMarker = false
local isInPublicMarker = false
local hintIsShowed = false
local hintToDisplay = "no hint to display"
local spawnedVehicles, isInShopMenu = {}, false
local playerInService = false

ESX = nil

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

function IsJobTrue()
    if PlayerData ~= nil then
        local IsJobTrue = false
        if PlayerData.job ~= nil and PlayerData.job.name == 'unicorn' then
            IsJobTrue = true
        end
        return IsJobTrue
    end
end

function IsGradeBoss()
    if PlayerData ~= nil then
        local IsGradeBoss = false
        if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'viceboss' then
            IsGradeBoss = true
        end
        return IsGradeBoss
    end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

function cleanPlayer(playerPed)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
    ResetPedMovementClipset(playerPed, 0)
end

function setClipset(playerPed, clip)
    RequestAnimSet(clip)
    while not HasAnimSetLoaded(clip) do
        Citizen.Wait(0)
    end
    SetPedMovementClipset(playerPed, clip, true)
end

function setUniform(job, playerPed)
    TriggerEvent('skinchanger:getSkin', function(skin)

        if skin.sex == 0 then
            if Config.Uniforms[job].male ~= nil then
                TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
            else
                ESX.ShowNotification(_U('no_outfit'))
            end
            if job ~= 'citizen_wear' and job ~= 'barman_outfit' then
                setClipset(playerPed, "MOVE_M@POSH@")
            end
        else
            if Config.Uniforms[job].female ~= nil then
                TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
            else
                ESX.ShowNotification(_U('no_outfit'))
            end
            if job ~= 'citizen_wear' and job ~= 'barman_outfit' then
                setClipset(playerPed, "MOVE_F@POSH@")
            end
        end

    end)
end

function OpenCloakroomMenu()
    local elements = {
        { label = _U('citizen_wear'), value = 'citizen_wear' },
        { label = _U('barman_outfit'), value = 'barman_outfit' },
        { label = _U('dancer_outfit_1'), value = 'dancer_outfit_1' },
        { label = _U('dancer_outfit_2'), value = 'dancer_outfit_2' },
        { label = _U('dancer_outfit_3'), value = 'dancer_outfit_3' },
        { label = _U('dancer_outfit_4'), value = 'dancer_outfit_4' },
        { label = _U('dancer_outfit_5'), value = 'dancer_outfit_5' },
        { label = _U('dancer_outfit_6'), value = 'dancer_outfit_6' },
        { label = _U('dancer_outfit_7'), value = 'dancer_outfit_7' },
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

                            TriggerServerEvent('esx_service:notifyAllInService', notification, 'unicorn')

                            TriggerServerEvent('esx_service:disableService', 'unicorn', PlayerData.identifier)
                            ESX.ShowNotification(_U('service_out'))
                        end
                    end, 'unicorn', PlayerData.identifier)
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
                                TriggerServerEvent('esx_service:notifyAllInService', notification, 'unicorn')
                                ESX.ShowNotification(_U('service_in'))
                            end
                        end, 'unicorn', PlayerData.identifier)
                    else
                        serviceOk = true
                    end
                end, 'unicorn', PlayerData.identifier)
                while type(serviceOk) == 'string' do
                    Citizen.Wait(5)
                end
                -- if we couldn't enter service don't let the player get changed
                if not serviceOk then
                    return
                end
            end
            if
            data.current.value == 'dancer_outfit_1' or
                data.current.value == 'dancer_outfit_2' or
                data.current.value == 'dancer_outfit_3' or
                data.current.value == 'dancer_outfit_4' or
                data.current.value == 'dancer_outfit_5' or
                data.current.value == 'dancer_outfit_6' or
                data.current.value == 'dancer_outfit_7'
            then
                setUniform(data.current.value, playerPed)
            end
        end, function(data, menu)
            menu.close()
            CurrentAction = nil
        end)
end

--[[
function OpenCloakroomMenu()

    local playerPed = GetPlayerPed(-1)

    local elements = {
        { label = _U('citizen_wear'), value = 'citizen_wear' },
        { label = _U('barman_outfit'), value = 'barman_outfit' },
        { label = _U('dancer_outfit_1'), value = 'dancer_outfit_1' },
        { label = _U('dancer_outfit_2'), value = 'dancer_outfit_2' },
        { label = _U('dancer_outfit_3'), value = 'dancer_outfit_3' },
        { label = _U('dancer_outfit_4'), value = 'dancer_outfit_4' },
        { label = _U('dancer_outfit_5'), value = 'dancer_outfit_5' },
        { label = _U('dancer_outfit_6'), value = 'dancer_outfit_6' },
        { label = _U('dancer_outfit_7'), value = 'dancer_outfit_7' },
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'cloakroom',
        {
            title = _U('cloakroom'),
            align = 'top-left',
            elements = elements,
        },
        function(data, menu)

            isBarman = false
            cleanPlayer(playerPed)

            if data.current.value == 'citizen_wear' then
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    TriggerEvent('skinchanger:loadSkin', skin)
                end)
            end

            if data.current.value == 'barman_outfit' then
                setUniform(data.current.value, playerPed)
                isBarman = true
            end

            if
            data.current.value == 'dancer_outfit_1' or
                data.current.value == 'dancer_outfit_2' or
                data.current.value == 'dancer_outfit_3' or
                data.current.value == 'dancer_outfit_4' or
                data.current.value == 'dancer_outfit_5' or
                data.current.value == 'dancer_outfit_6' or
                data.current.value == 'dancer_outfit_7'
            then
                setUniform(data.current.value, playerPed)
            end

            CurrentAction = 'menu_cloakroom'
            CurrentActionMsg = _U('open_cloackroom')
            CurrentActionData = {}

        end,
        function(data, menu)
            menu.close()
            CurrentAction = 'menu_cloakroom'
            CurrentActionMsg = _U('open_cloackroom')
            CurrentActionData = {}
        end
    )
end
]]

function OpenVaultMenu()

    if Config.EnableVaultManagement then

        local elements = {
            { label = _U('get_weapon'), value = 'get_weapon' },
            { label = _U('put_weapon'), value = 'put_weapon' },
            { label = _U('get_object'), value = 'get_stock' },
            { label = _U('put_object'), value = 'put_stock' }
        }

        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'vault',
            {
                title = _U('vault'),
                align = 'top-left',
                elements = elements,
            },
            function(data, menu)

                if data.current.value == 'get_weapon' then
                    OpenGetWeaponMenu()
                end

                if data.current.value == 'put_weapon' then
                    OpenPutWeaponMenu()
                end

                if data.current.value == 'put_stock' then
                    OpenPutStocksMenu()
                end

                if data.current.value == 'get_stock' then
                    OpenGetStocksMenu()
                end

            end,

            function(data, menu)

                menu.close()

                CurrentAction = 'menu_vault'
                CurrentActionMsg = _U('open_vault')
                CurrentActionData = {}
            end
        )

    end

end

function OpenFridgeMenu()

    local elements = {
        { label = _U('get_object'), value = 'get_stock' },
        { label = _U('put_object'), value = 'put_stock' }
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'fridge',
        {
            title = _U('fridge'),
            align = 'top-left',
            elements = elements,
        },
        function(data, menu)

            if data.current.value == 'put_stock' then
                OpenPutFridgeStocksMenu()
            end

            if data.current.value == 'get_stock' then
                OpenGetFridgeStocksMenu()
            end

        end,

        function(data, menu)

            menu.close()

            CurrentAction = 'menu_fridge'
            CurrentActionMsg = _U('open_fridge')
            CurrentActionData = {}
        end
    )

end

function OpenSocietyActionsMenu()
    local elements = {}

    table.insert(elements, { label = _U('billing'), value = 'billing' })
    if (isBarman or IsGradeBoss()) then
        table.insert(elements, { label = _U('crafting'), value = 'menu_crafting' })
    end
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'unicorn_actions',
        {
            title = _U('unicorn'),
            align = 'top-left',
            elements = elements
        },
        function(data, menu)
            if data.current.value == 'billing' then
                OpenBillingMenu()
            end
            if data.current.value == 'menu_crafting' then
                ESX.UI.Menu.Open(
                    'default', GetCurrentResourceName(), 'menu_crafting',
                    {
                        title = _U('crafting'),
                        align = 'top-left',
                        elements = {
                            { label = _U('jagerbomb'), value = 'jagerbomb' },
                            { label = _U('golem'), value = 'golem' },
                            { label = _U('whiskycoca'), value = 'whiskycoca' },
                            { label = _U('vodkaenergy'), value = 'vodkaenergy' },
                            { label = _U('vodkafruit'), value = 'vodkafruit' },
                            { label = _U('rhumfruit'), value = 'rhumfruit' },
                            { label = _U('teqpaf'), value = 'teqpaf' },
                            { label = _U('rhumcoca'), value = 'rhumcoca' },
                            { label = _U('mojito'), value = 'mojito' },
                            { label = _U('mixapero'), value = 'mixapero' },
                            { label = _U('metreshooter'), value = 'metreshooter' },
                            { label = _U('jagercerbere'), value = 'jagercerbere' },
                        }
                    },
                    function(data2, menu2)
                        TriggerServerEvent('esx_unicornjob:craftingCoktails', data2.current.value)
                        animsAction({ lib = "mini@drinking", anim = "shots_barman_b" })
                    end,
                    function(data2, menu2)
                        menu2.close()
                    end)
            end
        end,
        function(data, menu)
            menu.close()
        end)
end

function OpenBillingMenu()
    ESX.UI.Menu.Open(
        'dialog', GetCurrentResourceName(), 'billing',
        {
            title = _U('billing_amount')
        },
        function(data, menu)
            local amount = tonumber(data.value)
            local player, distance = ESX.Game.GetClosestPlayer()

            if player ~= -1 and distance <= 3.0 then
                menu.close()
                if amount == nil then
                    ESX.ShowNotification(_U('amount_invalid'))
                else
                    TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_unicorn', _U('billing'), amount)
                end
            else
                ESX.ShowNotification(_U('no_players_nearby'))
            end
        end,
        function(data, menu)
            menu.close()
        end)
end

function OpenGetStocksMenu()
    ESX.TriggerServerCallback('esx_unicornjob:getStockItems', function(items)
        print(json.encode(items))
        local elements = {}

        for i = 1, #items, 1 do
            table.insert(elements, { label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name })
        end
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'stocks_menu',
            {
                title = _U('unicorn_stock'),
                elements = elements
            },
            function(data, menu)
                local itemName = data.current.value

                ESX.UI.Menu.Open(
                    'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
                    {
                        title = _U('quantity')
                    },
                    function(data2, menu2)
                        local count = tonumber(data2.value)

                        if count == nil then
                            ESX.ShowNotification(_U('invalid_quantity'))
                        else
                            menu2.close()
                            menu.close()
                            OpenGetStocksMenu()
                            TriggerServerEvent('esx_unicornjob:getStockItem', itemName, count)
                        end
                    end,
                    function(data2, menu2)
                        menu2.close()
                    end)
            end,
            function(data, menu)
                menu.close()
            end)
    end)
end

function OpenPutStocksMenu()
    ESX.TriggerServerCallback('esx_unicornjob:getPlayerInventory', function(inventory)
        local elements = {}

        for i = 1, #inventory.items, 1 do
            local item = inventory.items[i]
            if item.count > 0 then
                table.insert(elements, { label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name })
            end
        end
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'stocks_menu',
            {
                title = _U('inventory'),
                elements = elements
            },
            function(data, menu)
                local itemName = data.current.value

                ESX.UI.Menu.Open(
                    'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
                    {
                        title = _U('quantity')
                    },
                    function(data2, menu2)
                        local count = tonumber(data2.value)

                        if count == nil then
                            ESX.ShowNotification(_U('invalid_quantity'))
                        else
                            menu2.close()
                            menu.close()
                            OpenPutStocksMenu()
                            TriggerServerEvent('esx_unicornjob:putStockItems', itemName, count)
                        end
                    end,
                    function(data2, menu2)
                        menu2.close()
                    end)
            end,
            function(data, menu)
                menu.close()
            end)
    end)
end

function OpenGetFridgeStocksMenu()
    ESX.TriggerServerCallback('esx_unicornjob:getFridgeStockItems', function(items)
        print(json.encode(items))
        local elements = {}

        for i = 1, #items, 1 do
            table.insert(elements, { label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name })
        end
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'fridge_menu',
            {
                title = _U('unicorn_fridge_stock'),
                elements = elements
            },
            function(data, menu)
                local itemName = data.current.value

                ESX.UI.Menu.Open(
                    'dialog', GetCurrentResourceName(), 'fridge_menu_get_item_count',
                    {
                        title = _U('quantity')
                    },
                    function(data2, menu2)
                        local count = tonumber(data2.value)

                        if count == nil then
                            ESX.ShowNotification(_U('invalid_quantity'))
                        else
                            menu2.close()
                            menu.close()
                            OpenGetStocksMenu()
                            TriggerServerEvent('esx_unicornjob:getFridgeStockItem', itemName, count)
                        end
                    end,
                    function(data2, menu2)
                        menu2.close()
                    end)
            end,
            function(data, menu)
                menu.close()
            end)
    end)
end

function OpenPutFridgeStocksMenu()
    ESX.TriggerServerCallback('esx_unicornjob:getPlayerInventory', function(inventory)
        local elements = {}

        for i = 1, #inventory.items, 1 do
            local item = inventory.items[i]

            if item.count > 0 then
                table.insert(elements, { label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name })
            end
        end
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'fridge_menu',
            {
                title = _U('fridge_inventory'),
                elements = elements
            },
            function(data, menu)
                local itemName = data.current.value

                ESX.UI.Menu.Open(
                    'dialog', GetCurrentResourceName(), 'fridge_menu_put_item_count',
                    {
                        title = _U('quantity')
                    },
                    function(data2, menu2)
                        local count = tonumber(data2.value)

                        if count == nil then
                            ESX.ShowNotification(_U('invalid_quantity'))
                        else
                            menu2.close()
                            menu.close()
                            OpenPutFridgeStocksMenu()
                            TriggerServerEvent('esx_unicornjob:putFridgeStockItems', itemName, count)
                        end
                    end,
                    function(data2, menu2)
                        menu2.close()
                    end)
            end,
            function(data, menu)
                menu.close()
            end)
    end)
end

function OpenGetWeaponMenu()
    ESX.TriggerServerCallback('esx_unicornjob:getVaultWeapons', function(weapons)
        local elements = {}

        for i = 1, #weapons, 1 do
            if weapons[i].count > 0 then
                table.insert(elements, { label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name })
            end
        end
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'vault_get_weapon',
            {
                title = _U('get_weapon_menu'),
                align = 'top-left',
                elements = elements,
            },
            function(data, menu)
                menu.close()
                ESX.TriggerServerCallback('esx_unicornjob:removeVaultWeapon', function()
                    OpenGetWeaponMenu()
                end, data.current.value)
            end,
            function(data, menu)
                menu.close()
            end)
    end)
end

function OpenPutWeaponMenu()
    local elements = {}
    local playerPed = GetPlayerPed(-1)
    local weaponList = ESX.GetWeaponList()

    for i = 1, #weaponList, 1 do
        local weaponHash = GetHashKey(weaponList[i].name)

        if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
            local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
            table.insert(elements, { label = weaponList[i].label, value = weaponList[i].name })
        end
    end
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vault_put_weapon',
        {
            title = _U('put_weapon_menu'),
            align = 'top-left',
            elements = elements,
        },
        function(data, menu)
            menu.close()
            ESX.TriggerServerCallback('esx_unicornjob:addVaultWeapon', function()
                OpenPutWeaponMenu()
            end, data.current.value)
        end,
        function(data, menu)
            menu.close()
        end)
end

function OpenShopMenu(zone)
    local elements = {}

    for i = 1, #Config.Zones[zone].Items, 1 do
        local item = Config.Zones[zone].Items[i]

        table.insert(elements, {
            label = item.label .. ' - <span style="color:red;">$' .. item.price .. ' </span>',
            realLabel = item.label,
            value = item.name,
            price = item.price
        })
    end
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'unicorn_shop',
        {
            title = _U('shop'),
            elements = elements
        },
        function(data, menu)
            TriggerServerEvent('esx_unicornjob:buyItem', data.current.value, data.current.price, data.current.realLabel)
        end,
        function(data, menu)
            menu.close()
        end)
end

function animsAction(animObj)
    Citizen.CreateThread(function()
        if not playAnim then
            local playerPed = GetPlayerPed(-1);
            if DoesEntityExist(playerPed) then
                -- Check if ped exist
                dataAnim = animObj
                -- Play Animation
                RequestAnimDict(dataAnim.lib)
                while not HasAnimDictLoaded(dataAnim.lib) do
                    Citizen.Wait(0)
                end
                if HasAnimDictLoaded(dataAnim.lib) then
                    local flag = 0
                    if dataAnim.loop ~= nil and dataAnim.loop then
                        flag = 1
                    elseif dataAnim.move ~= nil and dataAnim.move then
                        flag = 49
                    end
                    TaskPlayAnim(playerPed, dataAnim.lib, dataAnim.anim, 8.0, -8.0, -1, flag, 0, 0, 0, 0)
                    playAnimation = true
                end
                -- Wait end animation
                while true do
                    Citizen.Wait(0)
                    if not IsEntityPlayingAnim(playerPed, dataAnim.lib, dataAnim.anim, 3) then
                        playAnim = false
                        TriggerEvent('ft_animation:ClFinish')
                        break
                    end
                end
            end -- end ped exist
        end
    end)
end

AddEventHandler('unicorn:hasEnteredMarker', function(zone)
    if zone == 'BossActions' and IsGradeBoss() then
        CurrentAction = 'menu_boss_actions'
        CurrentActionMsg = _U('open_bossmenu')
        CurrentActionData = {}
    end

    if zone == 'Cloakrooms' then
        CurrentAction = 'menu_cloakroom'
        CurrentActionMsg = _U('open_cloackroom')
        CurrentActionData = {}
    end

    if Config.EnableVaultManagement then
        if zone == 'Vaults' then
            CurrentAction = 'menu_vault'
            CurrentActionMsg = _U('open_vault')
            CurrentActionData = {}
        end
    end

    if zone == 'Fridge' then
        CurrentAction = 'menu_fridge'
        CurrentActionMsg = _U('open_fridge')
        CurrentActionData = {}
    end

    if zone == 'Flacons' or zone == 'NoAlcool' or zone == 'Apero' or zone == 'Ice' then
        CurrentAction = 'menu_shop'
        CurrentActionMsg = _U('shop_menu')
        CurrentActionData = { zone = zone }
    end

    if zone == 'CarGarage' then
        CurrentAction = 'garage'
        CurrentActionMsg = _U('vehicle_spawner')
        CurrentActionData = {}
    end

    if Config.EnableHelicopters then
        if zone == 'Helicopters' then
            local helicopters = Config.Zones.Helicopters

            if not IsAnyVehicleNearPoint(helicopters.SpawnPoint.x, helicopters.SpawnPoint.y, helicopters.SpawnPoint.z, 3.0) then
                ESX.Game.SpawnVehicle('swift2', {
                    x = helicopters.SpawnPoint.x,
                    y = helicopters.SpawnPoint.y,
                    z = helicopters.SpawnPoint.z
                }, helicopters.Heading, function(vehicle)
                    SetVehicleModKit(vehicle, 0)
                    SetVehicleLivery(vehicle, 0)
                end)
            end
        end
        if zone == 'HelicopterDeleters' then
            local playerPed = GetPlayerPed(-1)

            if IsPedInAnyVehicle(playerPed, false) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)

                CurrentAction = 'delete_vehicle'
                CurrentActionMsg = _U('store_vehicle')
                CurrentActionData = { vehicle = vehicle }
            end
        end
    end
end)

AddEventHandler('unicorn:hasExitedMarker', function(zone)
    if not isInShopMenu then
        ESX.UI.Menu.CloseAll()
    end
    CurrentAction = nil
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
    local specialContact = {
        name = _U('unicorn_phone'),
        number = 'unicorn',
        base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAACXBIWXMAAAsTAAALEwEAmpwYAAA7amlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMxMzggNzkuMTU5ODI0LCAyMDE2LzA5LzE0LTAxOjA5OjAxICAgICAgICAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIKICAgICAgICAgICAgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiCiAgICAgICAgICAgIHhtbG5zOnN0RXZ0PSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VFdmVudCMiCiAgICAgICAgICAgIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIKICAgICAgICAgICAgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIgogICAgICAgICAgICB4bWxuczpwaG90b3Nob3A9Imh0dHA6Ly9ucy5hZG9iZS5jb20vcGhvdG9zaG9wLzEuMC8iCiAgICAgICAgICAgIHhtbG5zOnRpZmY9Imh0dHA6Ly9ucy5hZG9iZS5jb20vdGlmZi8xLjAvIgogICAgICAgICAgICB4bWxuczpleGlmPSJodHRwOi8vbnMuYWRvYmUuY29tL2V4aWYvMS4wLyI+CiAgICAgICAgIDx4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ+eG1wLmRpZDoxMDQwMDUzRUQ2Q0JFMTExOTQwOTgyNTk4MzYxRUYyMzwveG1wTU06T3JpZ2luYWxEb2N1bWVudElEPgogICAgICAgICA8eG1wTU06RG9jdW1lbnRJRD5hZG9iZTpkb2NpZDpwaG90b3Nob3A6YjhkMDYxYTktYzdjOC0xMWU3LWExMzAtZDMzYTkwMzA3ZWYyPC94bXBNTTpEb2N1bWVudElEPgogICAgICAgICA8eG1wTU06SW5zdGFuY2VJRD54bXAuaWlkOjAxMWEzZDQwLWFiOTgtYjI0Yi05MjM2LTA2ZjY4NjQ0ODRjODwveG1wTU06SW5zdGFuY2VJRD4KICAgICAgICAgPHhtcE1NOkRlcml2ZWRGcm9tIHJkZjpwYXJzZVR5cGU9IlJlc291cmNlIj4KICAgICAgICAgICAgPHN0UmVmOmluc3RhbmNlSUQ+eG1wLmlpZDo4RTQyQzM3Njc2RDFFMTExOUE5RUVCNUNGNTQ5MzZCRjwvc3RSZWY6aW5zdGFuY2VJRD4KICAgICAgICAgICAgPHN0UmVmOmRvY3VtZW50SUQ+eG1wLmRpZDoxMDQwMDUzRUQ2Q0JFMTExOTQwOTgyNTk4MzYxRUYyMzwvc3RSZWY6ZG9jdW1lbnRJRD4KICAgICAgICAgPC94bXBNTTpEZXJpdmVkRnJvbT4KICAgICAgICAgPHhtcE1NOkhpc3Rvcnk+CiAgICAgICAgICAgIDxyZGY6U2VxPgogICAgICAgICAgICAgICA8cmRmOmxpIHJkZjpwYXJzZVR5cGU9IlJlc291cmNlIj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OmFjdGlvbj5zYXZlZDwvc3RFdnQ6YWN0aW9uPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6aW5zdGFuY2VJRD54bXAuaWlkOjk1YWFmODAyLTQzY2YtOTg0MC04YjVmLTNmNWJjOGZjNGU4Mjwvc3RFdnQ6aW5zdGFuY2VJRD4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OndoZW4+MjAxNy0xMS0xMlQxNzo0NDoxNiswMTowMDwvc3RFdnQ6d2hlbj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OnNvZnR3YXJlQWdlbnQ+QWRvYmUgUGhvdG9zaG9wIENDIDIwMTcgKFdpbmRvd3MpPC9zdEV2dDpzb2Z0d2FyZUFnZW50PgogICAgICAgICAgICAgICAgICA8c3RFdnQ6Y2hhbmdlZD4vPC9zdEV2dDpjaGFuZ2VkPgogICAgICAgICAgICAgICA8L3JkZjpsaT4KICAgICAgICAgICAgICAgPHJkZjpsaSByZGY6cGFyc2VUeXBlPSJSZXNvdXJjZSI+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDphY3Rpb24+c2F2ZWQ8L3N0RXZ0OmFjdGlvbj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0Omluc3RhbmNlSUQ+eG1wLmlpZDowMTFhM2Q0MC1hYjk4LWIyNGItOTIzNi0wNmY2ODY0NDg0Yzg8L3N0RXZ0Omluc3RhbmNlSUQ+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDp3aGVuPjIwMTctMTEtMTJUMTc6NDQ6MTYrMDE6MDA8L3N0RXZ0OndoZW4+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDpzb2Z0d2FyZUFnZW50PkFkb2JlIFBob3Rvc2hvcCBDQyAyMDE3IChXaW5kb3dzKTwvc3RFdnQ6c29mdHdhcmVBZ2VudD4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OmNoYW5nZWQ+Lzwvc3RFdnQ6Y2hhbmdlZD4KICAgICAgICAgICAgICAgPC9yZGY6bGk+CiAgICAgICAgICAgIDwvcmRmOlNlcT4KICAgICAgICAgPC94bXBNTTpIaXN0b3J5PgogICAgICAgICA8eG1wOkNyZWF0b3JUb29sPkFkb2JlIFBob3Rvc2hvcCBDQyAyMDE3IChXaW5kb3dzKTwveG1wOkNyZWF0b3JUb29sPgogICAgICAgICA8eG1wOkNyZWF0ZURhdGU+MjAxNy0xMS0xMlQxNzozODo0MSswMTowMDwveG1wOkNyZWF0ZURhdGU+CiAgICAgICAgIDx4bXA6TW9kaWZ5RGF0ZT4yMDE3LTExLTEyVDE3OjQ0OjE2KzAxOjAwPC94bXA6TW9kaWZ5RGF0ZT4KICAgICAgICAgPHhtcDpNZXRhZGF0YURhdGU+MjAxNy0xMS0xMlQxNzo0NDoxNiswMTowMDwveG1wOk1ldGFkYXRhRGF0ZT4KICAgICAgICAgPGRjOmZvcm1hdD5pbWFnZS9wbmc8L2RjOmZvcm1hdD4KICAgICAgICAgPHBob3Rvc2hvcDpDb2xvck1vZGU+MzwvcGhvdG9zaG9wOkNvbG9yTW9kZT4KICAgICAgICAgPHRpZmY6T3JpZW50YXRpb24+MTwvdGlmZjpPcmllbnRhdGlvbj4KICAgICAgICAgPHRpZmY6WFJlc29sdXRpb24+NzIwMDAwLzEwMDAwPC90aWZmOlhSZXNvbHV0aW9uPgogICAgICAgICA8dGlmZjpZUmVzb2x1dGlvbj43MjAwMDAvMTAwMDA8L3RpZmY6WVJlc29sdXRpb24+CiAgICAgICAgIDx0aWZmOlJlc29sdXRpb25Vbml0PjI8L3RpZmY6UmVzb2x1dGlvblVuaXQ+CiAgICAgICAgIDxleGlmOkNvbG9yU3BhY2U+NjU1MzU8L2V4aWY6Q29sb3JTcGFjZT4KICAgICAgICAgPGV4aWY6UGl4ZWxYRGltZW5zaW9uPjMyPC9leGlmOlBpeGVsWERpbWVuc2lvbj4KICAgICAgICAgPGV4aWY6UGl4ZWxZRGltZW5zaW9uPjMyPC9leGlmOlBpeGVsWURpbWVuc2lvbj4KICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CiAgIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgCjw/eHBhY2tldCBlbmQ9InciPz6e1E46AAAAIGNIUk0AAHolAACAgwAA+f8AAIDp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'
    }
    TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)


-- Create blips
Citizen.CreateThread(function()
    local blipMarker = Config.Blips.Blip
    local blipCoord = AddBlipForCoord(blipMarker.Pos.x, blipMarker.Pos.y, blipMarker.Pos.z)

    SetBlipSprite(blipCoord, blipMarker.Sprite)
    SetBlipDisplay(blipCoord, blipMarker.Display)
    SetBlipScale(blipCoord, blipMarker.Scale)
    SetBlipColour(blipCoord, blipMarker.Colour)
    SetBlipAsShortRange(blipCoord, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('map_blip'))
    EndTextCommandSetBlipName(blipCoord)
end)


-- Display markers
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if PlayerData.job ~= nil and PlayerData.job.name == 'unicorn' then
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


-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if PlayerData.job ~= nil and PlayerData.job.name == 'unicorn' then
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
                TriggerEvent('unicorn:hasEnteredMarker', currentZone)
            end
            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('unicorn:hasExitedMarker', currentZone)
            end
        end
    end
end)

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if CurrentAction == 'menu_cloakroom' and (not playerInService or playerInService) then
            ESX.ShowHelpNotification(CurrentActionMsg)
            if IsControlJustReleased(0, Keys['E']) then
                OpenCloakroomMenu()
            end
        end
        if playerInService then
            if CurrentAction == 'menu_vault' then
                ESX.ShowHelpNotification(CurrentActionMsg)
                if IsControlJustReleased(0, Keys['E']) and IsJobTrue() then
                    OpenVaultMenu()
                end
            elseif CurrentAction == 'menu_fridge' then
                ESX.ShowHelpNotification(CurrentActionMsg)
                if IsControlJustReleased(0, Keys['E']) and IsJobTrue() then
                    OpenFridgeMenu()
                end
            elseif CurrentAction == 'menu_shop' then
                ESX.ShowHelpNotification(CurrentActionMsg)
                if IsControlJustReleased(0, Keys['E']) and IsJobTrue() then
                    OpenShopMenu(CurrentActionData.zone)
                end
            elseif CurrentAction == 'garage' then
                ESX.ShowHelpNotification(CurrentActionMsg)
                if IsControlJustReleased(0, Keys['E']) and IsJobTrue() then
                    OpenVehicleSpawnerMenu('car')
                end
            elseif CurrentAction == 'menu_boss_actions' and IsGradeBoss() then
                ESX.ShowHelpNotification(CurrentActionMsg)
                if IsControlJustReleased(0, Keys['E']) and IsJobTrue() then
                    local options = {
                        wash = Config.EnableMoneyWash,
                    }
                    ESX.UI.Menu.CloseAll()
                    TriggerEvent('esx_society:openBossMenu', 'unicorn', function(data, menu)
                        menu.close()
                        CurrentAction = 'menu_boss_actions'
                        CurrentActionMsg = _U('open_bossmenu')
                        CurrentActionData = {}
                    end, options)
                end
            end
        end
        if IsControlJustReleased(0, Keys['F6']) and IsJobTrue() and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'unicorn_actions') then
            OpenSocietyActionsMenu()
        end
    end
end)

-----------------------
----- TELEPORTERS -----

AddEventHandler('esx_unicornjob:teleportMarkers', function(position)
    SetEntityCoords(GetPlayerPed(-1), position.x, position.y, position.z)
end)

-- Show top left hint
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if hintIsShowed == true then
            SetTextComponentFormat("STRING")
            AddTextComponentString(hintToDisplay)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
        end
    end
end)

-- Display teleport markers
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsJobTrue() then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            for k, v in pairs(Config.TeleportZones) do
                if (v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
                    DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, true, false, false, false)
                end
            end
        end
    end
end)

-- Activate teleport marker
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local position = nil
        local zone = nil

        if IsJobTrue() then
            for k, v in pairs(Config.TeleportZones) do
                if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                    isInPublicMarker = true
                    position = v.Teleport
                    zone = v
                    break
                else
                    isInPublicMarker = false
                end
            end
            if IsControlJustReleased(0, Keys["E"]) and isInPublicMarker then
                TriggerEvent('esx_unicornjob:teleportMarkers', position)
            end
            -- hide or show top left zone hints
            if isInPublicMarker then
                hintToDisplay = zone.Hint
                hintIsShowed = true
            else
                if not isInMarker then
                    hintToDisplay = "no hint to display"
                    hintIsShowed = false
                end
            end
        end
    end
end)

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
            ESX.ShowNotification('BUY_VEHICLE')
            local shopElements, shopCoords = {}
            shopCoords = Config.Zones.CarGarage.InsideShop
            if #Config.AuthorizedVehicles['Shared'] > 0 then
                ESX.ShowNotification('Autho vehicle > 0')
                for k, vehicle in ipairs(Config.AuthorizedVehicles['Shared']) do
                    table.insert(shopElements, {
                        label = ('%s - <span style="color:green;">%s</span>'):format(vehicle.label, _U('shop_item', ESX.Math.GroupDigits(vehicle.price))),
                        name = vehicle.label,
                        model = vehicle.model,
                        price = vehicle.price,
                        type = 'car'
                    })
                    ESX.ShowNotification('Inserting vehicle')
                end
            end
            OpenShopMenuGarage(shopElements, playerCoords, shopCoords)
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

    ESX.TriggerServerCallback('unicorn:storeNearbyVehicle', function(storeSuccess, foundNum)
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

function OpenShopMenuGarage(elements, restoreCoords, shopCoords)
    ESX.ShowNotification('Open MENU GARAGE')
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

                    ESX.TriggerServerCallback('unicorn:buyJobVehicle', function(bought)
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
