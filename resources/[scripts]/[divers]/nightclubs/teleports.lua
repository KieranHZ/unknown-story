local function FreezePlayerAfterTeleport()

    FreezeEntityPosition(GetPlayerPed(-1), true)
    Citizen.Wait(2000)
    FreezeEntityPosition(GetPlayerPed(-1), false)

end

--Club Entrances
club = {}
club.teleporters = {

    ['La Mesa Entrance'] = {inside = {x = -1569.51, y = -3017.29, z = -74.41}, outside = {x = 758.13, y = -1332.25, z = 27.28}},
    ['Mission Row Entrance'] = {inside = {x = -1569.51, y = -3017.29, z = -74.41}, outside = {x = 345.5, y = -977.8, z = 29.39}},
    ['Strawberry Entrance'] = {inside = {x = -1569.51, y = -3017.29, z = -74.41}, outside = {x = -121.5, y = -1258.55, z = 29.31}},
    ['Vinewood West Entrance'] = {inside = {x = -1569.51, y = -3017.29, z = -74.41}, outside = {x = 4.17, y = 220.52, z = 107.76}},
    ['Cypress Flats Entrance'] = {inside = {x = -1569.51, y = -3017.29, z = -74.41}, outside = {x = 871.41, y = -2100.94, z = 30.48}},
    ['Del Perro Entrance'] = {inside = {x = -1569.51, y = -3017.29, z = -74.41}, outside = {x = -1285.14, y = -652.16, z = 26.63}},
    ['LSIA Entrance'] = {inside = {x = -1569.51, y = -3017.29, z = -74.41}, outside = {x = -676.65, y = -2458.09, z = 13.94}},
    ['Elysian Island Entrance'] = {inside = {x = -1569.51, y = -3017.29, z = -74.41}, outside = {x = 195.39, y = -3167.33, z = 5.79}},
    ['Vinewood Entrance'] = {inside = {x = -1569.51, y = -3017.29, z = -74.41}, outside = {x = 371.98, y = 252.56, z = 103.01}},
    ['Vespucci Entrance'] = {inside = {x = -1569.51, y = -3017.29, z = -74.41}, outside = {x = -1174.62, y = -1153.4, z = 5.66}},

}

--Spawn and animate NPCs

local function LoadAnimation(animation)

    RequestAnimDict(animation)
    while not HasAnimDictLoaded(animation) do
        Citizen.Wait(100)
    end

end

local function LoadModel(model)

    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(100)
    end

end

local function RemoveEntity(entity)

    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end

end

-- Spawn DJ
local dj
local djModel = "CSB_Sol"
local djPos = {x = -1602.98, y = -3012.48, z = -77.8-0.975, head = 270.68}
local djAnimDic = "anim@amb@nightclub@djs@solomun@"
local dj_animations = {
    {anim = "new_sol_dance_a_sol", wait_time = 51000},
    {anim = "sol_dance_b_sol", wait_time = 18000},
    {anim = "sol_dance_c_sol", wait_time = 20000},
    {anim = "sol_dance_d_sol", wait_time = 22000},
    {anim = "sol_dance_e_sol", wait_time = 7000},
    {anim = "sol_dance_f_sol", wait_time = 29000},
    {anim = "sol_dance_g_sol", wait_time = 16000},
    {anim = "sol_dance_h_sol", wait_time = 23000},
    {anim = "sol_dance_i_sol", wait_time = 23000},
    {anim = "sol_dance_j_sol", wait_time = 78000},
    {anim = "sol_dance_k_sol", wait_time = 18000},
    {anim = "sol_dance_l_sol", wait_time = 20500},
    {anim = "sol_sync_a_sol", wait_time = 17000},  
}
      
function SpawnDJ()
    Citizen.CreateThread(function()
        LoadAnimation(djAnimDic)
        LoadModel(djModel)
        RemoveEntity(dj)     
        dj = CreatePed(4, djModel, djPos.x, djPos.y, djPos.z, djPos.head, false, false)
        FreezeEntityPosition(dj, true)
        while true do
            for i = 1, #dj_animations do
                if not dj then return end
                TaskPlayAnim(dj, djAnimDic, dj_animations[i].anim,  4.0, -4, -1, 0, 0, 0, 0, 0)
                Citizen.Wait(dj_animations[i].wait_time)
            end
        end
    end)
end

-- Spawn Bartender
local bartender
local barModel = "S_F_Y_ClubBar_01"
local barPos = {x = -1577.42, y = -3016.61, z = -79.01-0.975, head = 16.07}
local barAnimDic = "anim@amb@nightclub@mini@drinking@bar@drink@idle_a"
local barAnimA = "idle_a"

function SpawnBartender()
    Citizen.CreateThread(function()
        LoadAnimation(barAnimDic)
        LoadModel(barModel)
        RemoveEntity(bartender)    
        bartender = CreatePed(4, barModel, barPos.x, barPos.y, barPos.z, barPos.head, false, false)
        FreezeEntityPosition(bartender, false)
        ClearPedTasks(bartender)
        TaskPlayAnim(bartender, barAnimDic, barAnimA, 4.0, -4, -1, 1, 0, 0, 0, 0)
    end)
end

-- Spawn Doorman
local doorman
local doorModel = "S_M_Y_ClubBar_01"
local doorPos = {x = -1572.08, y = -3013.26, z = -74.41-0.975, head = 267.00}
local doorAnimDic = "amb@world_human_stand_guard@male@base"
local doorAnim = "base"

function SpawnDoorman()
    Citizen.CreateThread(function()
        LoadAnimation(doorAnimDic)
        LoadModel(doorModel)
        RemoveEntity(doorman)    
        doorman = CreatePed(4, doorModel, doorPos.x, doorPos.y, doorPos.z, doorPos.head, false, false)
        FreezeEntityPosition(doorman, false)
        ClearPedTasks(doorman)
        TaskPlayAnim(doorman, doorAnimDic, doorAnim, 4.0, -4, -1, 1, 0, 0, 0, 0)
    end)
end

-- Spawn Bouncer
local guard
local guardModel = "s_m_m_highsec_02"
local guardPos = {x = -1591.12, y = -3013.39, z = -76-0.975, head = 100.00}
local guardAnimDic = "missfbi_s4mop"
local guardAnim = "guard_idle_a"

function SpawnGuard()
    Citizen.CreateThread(function()
        LoadAnimation(guardAnimDic)
        LoadModel(guardModel)
        RemoveEntity(guard)    
        guard = CreatePed(4, guardModel, guardPos.x, guardPos.y, guardPos.z, guardPos.head, false, false)
        FreezeEntityPosition(guard, false)
        ClearPedTasks(guard)
        TaskPlayAnim(guard, guardAnimDic, guardAnim, 4.0, -4, -1, 1, 0, 0, 0, 0)
    end)
end

-- Despawn NPCS
function DespawnNPC()
    RemoveEntity(dj)
    RemoveEntity(bartender)
    RemoveEntity(doorman)
    RemoveEntity(guard) 
    dj = nil -- not sure if these are needed?
    bartender = nil
    doorman = nil 
    guard = nil 
end

-- Get in and out of the Club
CreateThread(function()
    while true do
        Wait(1)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        for k,v in pairs(club.teleporters) do
            --print(v.inside.x)
            if GetDistanceBetweenCoords(v.inside.x, v.inside.y, v.inside.z, coords, true) < 10 then -- Inside Teleport Locations??? create new thread for outside ones?
                --print("coords done got")
                DrawMarker(23,v.inside.x,v.inside.y,v.inside.z-0.975, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5001, 244, 209, 66, 100, 0, 0, 0,0)
                if GetDistanceBetweenCoords(v.inside.x,v.inside.y,v.inside.z, coords, true) < 1 then
                    DrawText3D(v.inside.x,v.inside.y,v.inside.z, "Press [~r~ENTER~s~] to go outside...")
                    if IsControlJustPressed(0, 201) then
                        BeamMeOutsideScotty(k, "outside")
                        DespawnNPC() --despawn NPCs after leaving
                    end
                end
            end
 
            if GetDistanceBetweenCoords(v.outside.x, v.outside.y, v.outside.z, coords, true) < 10 then -- outside Teleport Locations??? create new thread for outside ones?
                --print("coords done got")
                DrawMarker(23,v.outside.x,v.outside.y,v.outside.z-0.975, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5001, 244, 209, 66, 100, 0, 0, 0,0)
                if GetDistanceBetweenCoords(v.outside.x,v.outside.y,v.outside.z, coords, true) < 1 then
                    DrawText3D(v.outside.x,v.outside.y,v.outside.z, "Press [~r~ENTER~s~] to go inside...")
                    if IsControlJustPressed(0, 201) then
                        SpawnDoorman() --spawn NPCs prior to entry
                        SpawnBartender()
                        SpawnGuard()
                        SpawnDJ()
                        club.enteredFrom = coords -- Save entering coords
                        BeamMeOutsideScotty(k, "inside")
                    end
                end
            end
        end
    end
end)
 
function BeamMeOutsideScotty(loc,spot)
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)


    local teleport = club.teleporters[loc]
    if spot == "inside" then
        SetEntityCoords(GetPlayerPed(-1), teleport.inside.x, teleport.inside.y, teleport.inside.z, 1, 0, 0, 1 )
    elseif spot == "outside" then
        if club.enteredFrom then
            SetEntityCoords(GetPlayerPed(-1), club.enteredFrom.x, club.enteredFrom.y, club.enteredFrom.z, 1, 0, 0, 1 )
            club.enteredFrom = nil
        else
            SetEntityCoords(GetPlayerPed(-1), teleport.outside.x, teleport.outside.y, teleport.outside.z, 1, 0, 0, 1 )
        end
    end

    FreezePlayerAfterTeleport()
    DoScreenFadeIn(1000)
end
 
function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)   
end