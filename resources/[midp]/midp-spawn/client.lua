local selectedspawnposition = nil
local klikspawn = false
local new           = false
local DIMENUCOK = false
local BOLEH = true
local k             = 270.0
local firstSpawn    = true
local PlayerLoaded  = false
local alancam = 1500
local alanganteng = 50
local pointCamCoords = 75
local pointCamCoords2 = 0
local cam1Time = 500
local cam2Time = 1000

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerLoaded = true
end)

AddEventHandler('playerSpawned', function()
    CreateThread(function()
        while not PlayerLoaded do
            Wait(500)
        end

        --TriggerEvent("dl-phone:LoadHP")
        TriggerEvent("jobui:updateStats")

        if firstSpawn then
            ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(isDead)
                if isDead == false then
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                        if skin ~= nil then
                            TriggerEvent("midp-spawn:openMenu")
                            DIMENUCOK = true
                        else
                            print("first-spawn , not displaying spawner choice")
                        end
                    end)
                end
            end)
            firstSpawn = false
        end
    end)
end)

local BOLEH = true

RegisterNUICallback("SpawnPlayer", function()
    if klikspawn ~= true then
        exports['midp-tasknotify']:DoHudText('inform', 'Silahkan Pilih salah satu lokasi!')
        SetNuiFocus(true, true)
        SendNUIMessage({
            ["Action"] = "OPEN_SPAWNMENU"
        })
    else
        SpawnPlayer(selectedspawnposition)
    end
end)

RegisterNUICallback("SpawnBandara", function()
    selectedspawnposition = { x = -1037.74, y = -2738.04, z = 20.1693, h = 330.11 }

    local playerPed = PlayerPedId()
    local lastlocation = selectedspawnposition
    klikspawn = true

    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", lastlocation.x, lastlocation.y, lastlocation.z + alancam, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam2, lastlocation.x, lastlocation.y, lastlocation.z + pointCamCoords)
    SetCamActiveWithInterp(cam2, cam, cam1Time, true, true)
    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end
    Citizen.Wait(cam1Time)

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", lastlocation.x, lastlocation.y, lastlocation.z + alanganteng, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam, lastlocation.x, lastlocation.y, lastlocation.z + pointCamCoords2)
    SetCamActiveWithInterp(cam, cam2, cam2Time, true, true)
    SetEntityCoords(PlayerPedId(), lastlocation.x, lastlocation.y, lastlocation.z)
end)

RegisterNUICallback("SpawnPelabuhan", function()
    selectedspawnposition = { x = -727.29, y = -1303.56, z = 5.1, h = 44.45 }

    local playerPed = PlayerPedId()
    local lastlocation = selectedspawnposition
    klikspawn = true

    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", lastlocation.x, lastlocation.y, lastlocation.z + alancam, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam2, lastlocation.x, lastlocation.y, lastlocation.z + pointCamCoords)
    SetCamActiveWithInterp(cam2, cam, cam1Time, true, true)
    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end
    Citizen.Wait(cam1Time)

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", lastlocation.x, lastlocation.y, lastlocation.z + alanganteng, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam, lastlocation.x, lastlocation.y, lastlocation.z + pointCamCoords2)
    SetCamActiveWithInterp(cam, cam2, cam2Time, true, true)
    SetEntityCoords(PlayerPedId(), lastlocation.x, lastlocation.y, lastlocation.z)
end)

RegisterNUICallback("SpawnProperty", function(data, cb)
    selectedspawnposition = json.decode(data.coords)

    local playerPed = PlayerPedId()
    local lastlocation = selectedspawnposition
    klikspawn = true

    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", lastlocation.x, lastlocation.y, lastlocation.z + alancam, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam2, lastlocation.x, lastlocation.y, lastlocation.z + pointCamCoords)
    SetCamActiveWithInterp(cam2, cam, cam1Time, true, true)
    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end
    Citizen.Wait(cam1Time)

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", lastlocation.x, lastlocation.y, lastlocation.z + alanganteng, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam, lastlocation.x, lastlocation.y, lastlocation.z + pointCamCoords2)
    SetCamActiveWithInterp(cam, cam2, cam2Time, true, true)
    SetEntityCoords(PlayerPedId(), lastlocation.x, lastlocation.y, lastlocation.z)

    cb('ok')
end)

RegisterNUICallback("SpawnRumah", function(data, cb)
    selectedspawnposition = json.decode(data.coords)

    local playerPed = PlayerPedId()
    local lastlocation = selectedspawnposition
    klikspawn = true

    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", lastlocation.x, lastlocation.y, lastlocation.z + alancam, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam2, lastlocation.x, lastlocation.y, lastlocation.z + pointCamCoords)
    SetCamActiveWithInterp(cam2, cam, cam1Time, true, true)
    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end
    Citizen.Wait(cam1Time)

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", lastlocation.x, lastlocation.y, lastlocation.z + alanganteng, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam, lastlocation.x, lastlocation.y, lastlocation.z + pointCamCoords2)
    SetCamActiveWithInterp(cam, cam2, cam2Time, true, true)
    SetEntityCoords(PlayerPedId(), lastlocation.x, lastlocation.y, lastlocation.z)

    cb('ok')
end)

RegisterNUICallback("SpawnLokasiT", function()
    TriggerServerEvent('midp-spawn:LastLocation')
end)

SpawnPlayer = function(Location)
	local pos = Location
	SetNuiFocus(false, false)
    SetCamActiveWithInterp(cam, cam2, 3700, true, true)
	--callback("ok")
	Citizen.Wait(0)
    DIMENUCOK = false

	PlaySoundFrontend(-1, "Zoom_In", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
    RenderScriptCams(false, true, 500, true, true)
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    Citizen.Wait(0)
    
	SetEntityVisible(PlayerPedId(), true, 0)
	FreezeEntityPosition(PlayerPedId(), false)
    SetPlayerInvisibleLocally(PlayerPedId(), false)
    SetPlayerInvincible(PlayerPedId(), false)
    
    DestroyCam(startcam, false)
    DestroyCam(cam, false)
    DestroyCam(cam2, false)
    Citizen.Wait(0)
    FreezeEntityPosition(PlayerPedId(), false)
	SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
end

RegisterNetEvent('midp-spawn:LastLocationSpawn')
AddEventHandler('midp-spawn:LastLocationSpawn', function(spawn)
    selectedspawnposition = spawn

    local playerPed = PlayerPedId()
    local lastlocation = selectedspawnposition
    klikspawn = true

    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", lastlocation.x, lastlocation.y, lastlocation.z + alancam, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam2, lastlocation.x, lastlocation.y, lastlocation.z + pointCamCoords)
    SetCamActiveWithInterp(cam2, cam, cam1Time, true, true)
    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end
    Citizen.Wait(cam1Time)

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", lastlocation.x, lastlocation.y, lastlocation.z + alanganteng, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam, lastlocation.x, lastlocation.y, lastlocation.z + pointCamCoords2)
    SetCamActiveWithInterp(cam, cam2, cam2Time, true, true)
    SetEntityCoords(PlayerPedId(), lastlocation.x, lastlocation.y, lastlocation.z)
end)

RegisterNetEvent("midp-spawn:openMenu")
AddEventHandler("midp-spawn:openMenu", function()
    ESX.TriggerServerCallback("midp-spawn:showLastLocation", function(allowed)
        ESX.TriggerServerCallback('midp-spawn:getOwnedProperties', function(properties)
            SendNUIMessage({
                ["Action"] = "OPEN_SPAWNMENU",
                ["ShowLastLocation"] = allowed,
                ["OwnedProperties"] = properties
            })
            ESX.TriggerServerCallback('midp-spawn:getOwnedRumah', function(rumah)
                SendNUIMessage({
                    ["Action"] = "OPEN_SPAWNMENU",
                    ["ShowLastLocation"] = allowed,
                    ["OwnedRumah"] = rumah
                })
        
            SetNuiFocus(true, true)
        
            pos = GetEntityCoords(PlayerPedId())
            cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, pos.z + 200.0, 270.00, 0.00, 0.00, 80.00, 0, 0)
            SetCamActive(cam, true)
            RenderScriptCams(true, false, 1, true, true)
            FreezeEntityPosition(PlayerPedId(), true)
            SetEntityVisible(PlayerPedId(), false, false)
            end)
        end)
    end)
end)

RegisterCommand('fixspawn', function()
    if DIMENUCOK == true then
        if BOLEH == true then
            TriggerEvent('midp-spawn:openMenu')
        else
            exports['midp-tasknotify']:DoHudText('inform', 'Silahkan Pilih salah satu lokasi!')
        end
    else
        exports['midp-tasknotify']:DoHudText('error', 'Tidak bisa digunakan kembali!')
    end

    BOLEH = false
end)