ESX = nil
local weaponEntityExists = false
local weaponModel = nil
local weaponName = nil
local weaponEntity = nil
local ox_inventory = exports.ox_inventory
local count = 0
local sleep = 0
local loaded = false
local holdingMega = false
local ped = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local currentjob = ""

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    local job = xPlayer.job.name

    currentjob = job
    if job == "police" or job == "ambulance" or job == "mechanic" or job == "pedagang" then -- job's name here
        TriggerServerEvent("utk_sl:userjoined", job)
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    if currentjob == "police" or currentjob == "ambulance" or currentjob == "mechanic" or currentjob == "pedagang" then -- job's name here
        if not (currentjob == job.name) then
            TriggerServerEvent("utk_sl:jobchanged", currentjob, job.name, 1)
        end
    else
        if job.name == "police" or job.name == "ambulance" or job.name == "mechanic" or job.name == "pedagang" then -- job's name here
            TriggerServerEvent("utk_sl:jobchanged", currentjob, job.name, 0)
        end
    end
    currentjob = job.name
end)

AddEventHandler('esx:onPlayerSpawn', function()
    respawningCheckWeapon()
end)

CreateThread(function()
	while true do
        local namanya = GetPlayerName(PlayerId())
        local kantong = GetPlayerServerId(PlayerId())
		SetDiscordAppId(990955930797637692)
        SetRichPresence('[' ..kantong.. '] '..namanya)
		SetDiscordRichPresenceAsset('dailylife')
        SetDiscordRichPresenceAssetText('DAILYLIFE')
        SetDiscordRichPresenceAssetSmall('bar')
        SetDiscordRichPresenceAssetSmallText('This is a lsmall icon with text')
		Wait(60000)

        SetDiscordRichPresenceAction(0, "Connect FiveM", "fivem://connect/202.83.122.242")
        SetDiscordRichPresenceAction(1, "Discord", "https://discord.gg/Qhr8DW8aqv")
		Wait(60000)
	end
end)

CreateThread(function()
    while true do
        Wait(0)
	    local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
	       DisableControlAction(1, 140, true)
       	   DisableControlAction(1, 141, true)
           DisableControlAction(1, 142, true)
        end
    end
end)

function DeleteWeaponObject(weaponEntity)
    DeleteObject(weaponEntity)
    weaponModel = nil
    weaponEntityExists = false
end

CreateThread(function()
	AddTextEntry('FE_THDR_GTAO', 'DAILYLIFE ROLEPLAY')
	AddTextEntry('PM_PANE_CFX', 'DAILYLIFE ROLEPLAY')
end)

local curWeapon = nil

local Weapons = {
    --[`WEAPON_KNIFE`] = {object = `prop_w_me_knife_01`, item = 'WEAPON_KNIFE', bone = 24818, pos = vector3(-0.2,-0.12,0.1), rot = vector3(10.0,180.0,20.0)},
    --[`WEAPON_NIGHTSTICK`] = {object = `w_me_nightstick`, item = 'WEAPON_NIGHTSTICK', bone = 58271, pos = vector3(-0.01,0.1,-0.07), rot = vector3(-55.0,160.0,0.0)},
    --[`WEAPON_HAMMER`] = {object = `prop_tool_hammer`, item = 'WEAPON_HAMMER', bone = 24818, pos = vector3(65536.0,65536.0,65536.0), rot = vector3(0.0,0.0,0.0)},
    --[`WEAPON_BAT`] = {object = `w_me_bat`, item = 'WEAPON_BAT', bone = 24818, pos = vector3(0.1,-0.2,0.12), rot = vector3(10.0,290.0,0.0)},
    --[`WEAPON_GOLFCLUB`] = {object = `w_me_gclub`, item = 'WEAPON_GOLFCLUB', bone = 24818, pos = vector3(65536.0,65536.0,65536.0), rot = vector3(0.0,0.0,0.0)},
    --[`WEAPON_CROWBAR`] = {object = `w_me_crowbar`, item = 'WEAPON_CROWBAR', bone = 24818, pos = vector3(65536.0,65536.0,65536.0), rot = vector3(0.0,0.0,0.0)},
    --[`WEAPON_KNUCKLE`] = {object = `prop_w_me_dagger`, item = 'WEAPON_KNUCKLE', bone = 24818, pos = vector3(65536.0,65536.0,65536.0), rot = vector3(0.0,0.0,0.0)},
    --[`WEAPON_HATCHET`] = {object = `w_me_hatchet`, item = 'WEAPON_HATCHET', bone = 24818, pos = vector3(65536.0,65536.0,65536.0), rot = vector3(0.0,0.0,0.0)},
    --[`WEAPON_MACHETE`] = {object = `prop_ld_w_me_machette`, item = 'WEAPON_MACHETE', bone = 58271, pos = vector3(-0.01,0.1,-0.07), rot = vector3(-55.0,160.0,0.0)},
    --[`WEAPON_SWITCHBLADE`] = {object = `w_me_switchblade`, item = 'WEAPON_SWITCHBLADE', bone = 24818, pos = vector3(-0.2,-0.12,0.1), rot = vector3(10.0,180.0,20.0)},
    --[`WEAPON_WRENCH`] = {object = `w_me_wrench`, item = 'WEAPON_WRENCH', bone = 24818, pos = vector3(-0.2,-0.12,0.1), rot = vector3(10.0,180.0,20.0)},
    --[`WEAPON_FLASHLIGHT`] = {object = `prop_w_me_knife_01`, item = 'WEAPON_FLASHLIGHT', bone = 51826, pos = vector3(-0.1,10.0,0.07), rot = vector3(10.0,180.0,20.0)},

    --[`WEAPON_PISTOL50`] = {object = `w_pi_pistol50`, item = 'WEAPON_PISTOL50', bone = 24818, pos = vector3(-0.2,-0.13,0), rot = vector3(10.0,150.0,10.0)},
    --[`WEAPON_PISTOL`] = {object = `w_pi_pistol`, item = 'WEAPON_PISTOL', bone = 24818, pos = vector3(-0.2,-0.13,0), rot = vector3(10.0,150.0,10.0)},
    --[`WEAPON_COMBATPISTOL`] = {object = `w_pi_combatpistol`, item = 'WEAPON_COMBATPISTOL', bone = 51826, pos = vector3(-0.01,0.10,0.07), rot = vector3(-135.0,0.0,0.0)},
    --[`WEAPON_VINTAGEPISTOL`] = {object = `w_pi_vintage_pistol`, item = 'WEAPON_VINTAGEPISTOL', bone = 51826, pos = vector3(-0.01,-0.10,0.07), rot = vector3(-155.0,0.0,0.0)},
    --[`WEAPON_HEAVYPISTOL`] = {object = `w_pi_heavypistol`, item = 'WEAPON_HEAVYPISTOL', bone = 24818, pos = vector3(-0.2,-0.13,0), rot = vector3(-155.0,0.0,0.0)},
    --[`WEAPON_SNSPISTOL`] = {object = `w_pi_sns_pistol`, item = 'WEAPON_SNSPISTOL', bone = 58271, pos = vector3(-0.2,-0.13,0), rot = vector3(-155.0,0.0,0.0)},
    --[`WEAPON_FLAREGUN`] = {object = `w_pi_flaregun`, item = 'WEAPON_FLAREGUN', bone = 58271, pos = vector3(-0.01,-0.1,-0.7), rot = vector3(-55.0,0.10,0.0)},
    --[`WEAPON_REVOLVER`] = {object = `w_pi_revolver`, item = 'WEAPON_REVOLVER', bone = 24818, pos = vector3(-0.2,-0.13,0.0), rot = vector3(10.0,180.0,5.0)},
    --[`WEAPON_REVOLVER_MK2`] = {object = `w_pi_revolvermk2`, item = 'WEAPON_REVOLVER_MK2', bone = 24818, pos = vector3(-0.2,-0.13,0.0), rot = vector3(10.0,180.0,5.0)},
    --[`WEAPON_APPISTOL`] = {object = `w_pi_appistol`, item = 'WEAPON_APPISTOL', bone = 51826, pos = vector3(-0.01,0.10,0.07), rot = vector3(-135.0,0.0,0.0)},
    --[`WEAPON_PISTOL_MK2`] = {object = `w_pi_pistolmk2`, item = 'WEAPON_PISTOL_MK2', bone = 51826, pos = vector3(-0.01,0.10,0.07), rot = vector3(-135.0,0.0,0.0)},
    --[`WEAPON_STUNGUN`] = {object = `w_pi_stungun`, item = 'WEAPON_STUNGUN', bone = 51826, pos = vector3(-0.01,0.10,0.07), rot = vector3(-135.0,0.0,0.0)},

    --smg
    --[`WEAPON_MICROSMG`] = {object = `w_sb_microsmg`, item = 'WEAPON_MICROSMG', bone = 24818, pos = vector3(0.0,-0.2,-0.15), rot = vector3(100.0,180.0,0.0)},
    --[`WEAPON_SMG`] = {object = `w_sb_smg`, item = 'WEAPON_SMG', bone = 24818, pos = vector3(0.1,-0.2,-0.15), rot = vector3(100.0,180.0,0.0)},
    --[`WEAPON_MG`] = {object = `w_mg_mg`, item = 'WEAPON_MG', bone = 24818, pos = vector3(0.1,-0.2,-0.15), rot = vector3(100.0,180.0,0.0)},
    --[`WEAPON_COMBATMG`] = {object = `w_mg_combatmg`, item = 'WEAPON_COMBATMG', bone = 24818, pos = vector3(0.1,-0.15,0.0), rot = vector3(0.0,135.0,0.0)},
    --[`WEAPON_GUSENBERG`] = {object = `w_sb_gusenberg`, item = 'WEAPON_GUSENBERG', bone = 24818, pos = vector3(0.1,-0.15,0.0), rot = vector3(0.0,135.0,0.0)},
    --[`WEAPON_COMBATPDW`] = {object = `w_sb_pdw`, item = 'WEAPON_COMBATPDW', bone = 24818, pos = vector3(65536.0,65536.0,65536.0), rot = vector3(0.0,0.0,0.0)},
    --[`WEAPON_MACHINEPISTOL`] = {object = `w_sb_compactsmg`, item = 'WEAPON_MACHINEPISTOL', bone = 24818, pos = vector3(0.05,-0.2,-0.0), rot = vector3(0.0,170.0,0.0)},
    --[`WEAPON_ASSAULTSMG`] = {object = `w_sb_assaultsmg`, item = 'WEAPON_ASSAULTSMG', bone = 24818, pos = vector3(0.1,-0.2,-0.15), rot = vector3(100.0,180.0,0.0)},
    --[`WEAPON_MINISMG`] = {object = `w_sb_smg`, item = 'WEAPON_MINISMG', bone = 24818, pos = vector3(0.0,-0.2,-0.15), rot = vector3(100.0,180.0,0.0)},

    --RIFLE
    --[`WEAPON_ASSAULTRIFLE`] = {object = `w_ar_assaultrifle`, item = 'WEAPON_ASSAULTRIFLE', bone = 24818, pos = vector3(0.1,-0.2,-0.15), rot = vector3(100.0,180.0,0.0)},
    --[`WEAPON_CARBINERIFLE`] = {object = `w_ar_carbinerifle`, item = 'WEAPON_CARBINERIFLE', bone = 24818, pos = vector3(0.1,-0.2,-0.15), rot = vector3(100.0,180.0,0.0)},
    --[`WEAPON_CARBINERIFLE_MK2`] = {object = `w_ar_carbineriflemk2`, item = 'WEAPON_CARBINERIFLE_MK2', bone = 24818, pos = vector3(0.1,-0.2,-0.15), rot = vector3(100.0,180.0,0.0)},
    --[`WEAPON_ADVANCEDRIFLE`] = {object = `w_ar_advancedrifle`, item = 'WEAPON_ADVANCEDRIFLE', bone = 24818, pos = vector3(0.1,-0.2,-0.15), rot = vector3(100.0,180.0,0.0)},
    --[`WEAPON_SPECIALCARBINE`] = {object = `w_ar_specialcarbine`, item = 'WEAPON_SPECIALCARBINE', bone = 24818, pos = vector3(0.1,-0.2,-0.15), rot = vector3(100.0,180.0,0.0)},
    --[`WEAPON_BULLPUPRIFLE`] = {object = `w_ar_bullpuprifle`, item = 'WEAPON_BULLPUPRIFLE', bone = 24818, pos = vector3(0.1,-0.2,-0.15), rot = vector3(100.0,180.0,0.0)},
    --[`WEAPON_COMPACTRIFLE`] = {object = `w_ar_assaultrifle`, item = 'WEAPON_COMPACTRIFLE', bone = 24818, pos = vector3(0.1,-0.2,-0.15), rot = vector3(100.0,180.0,0.0)},

    --SHOOTGUN--
    --[`WEAPON_PUMPSHOTGUN`] = {object = `w_sg_pumpshotgun`, item = 'WEAPON_PUMPSHOTGUN', bone = 24818, pos = vector3(0.1,-0.15,0.0), rot = vector3(0.0,135.0,0.0)},
    --[`WEAPON_SAWNOFFSHOTGUN`] = {object = `w_sg_pumpshotgun`, item = 'WEAPON_SAWNOFFSHOTGUN', one = 24818, pos = vector3(0.1,-0.15,0.0), rot = vector3(0.0,135.0,0.0)},
    --[`WEAPON_BULLPUPSHOTGUN`] = {object = `w_sg_assaultshotgun`, item = 'WEAPON_BULLPUPSHOTGUN', bone = 24818, pos = vector3(0.1,-0.15,0.0), rot = vector3(0.0,135.0,0.0)},
    --[`WEAPON_ASSAULTSHOTGUN`] = {object = `w_sg_assaultshotgun`, item = 'WEAPON_ASSAULTSHOTGUN', bone = 24818, pos = vector3(0.1,-0.15,0.0), rot = vector3(0.0,0.0,0.0)},
    --[`WEAPON_MUSKET`] = {object = `w_ar_musket`, item = 'WEAPON_MUSKET', bone = 24818, pos = vector3(0.1,-0.15,0.0), rot = vector3(0.0,135.0,0.0)},
    --[`WEAPON_HEAVYSHOTGUN`] = {object = `w_sg_heavyshotgun`, item = 'WEAPON_HEAVYSHOTGUN', bone = 24818, pos = vector3(0.1,-0.15,0.0), rot = vector3(0.0,225.0,0.0)},
    --[`WEAPON_DBSHOTGUN`] = {object = `w_ar_musket`, item = 'WEAPON_DBSHOTGUN', bone = 24818, pos = vector3(0.1,-0.15,0.0), rot = vector3(0.0,0.0,0.0)},
    --[`WEAPON_AUTOSHOTGUN`] = {object = `w_sg_heavyshotgun`, item = 'WEAPON_AUTOSHOTGUN', bone = 24818, pos = vector3(0.1,0.15,0.0), rot = vector3(0.0,0.0,0.0)},

    --sniper
    --[`WEAPON_SNIPERRIFLE`] = {object = `w_sr_sniperrifle`, item = 'WEAPON_SNIPERRIFLE', bone = 24818, pos = vector3(0.1,-0.2,0.12), rot = vector3(100.0,180.0,0.0)},
    --[`WEAPON_HEAVYSNIPER`] = {object = `w_sr_heavysniper`, item = 'WEAPON_HEAVYSNIPER', bone = 24818, pos = vector3(0.1,-0.2,0.12), rot = vector3(100.0,180.0,0.0)},
    --[`WEAPON_MARKSMANRIFLE`] = {object = `w_sr_marksmanrifle`, item = 'WEAPON_MARKSMANRIFLE', bone = 24818, pos = vector3(0.1,-0.2,0.12), rot = vector3(100.0,180.0,0.0)},
}

local slots = {

    [1] = {
        pos = vec3(0.13, -0.19, -0.04),
        entity = nil,
        hash = nil
    },
    [2] = {
        pos = vec3(0.13, -0.15, -0.16),
        entity = nil,
        hash = nil
    },
    [3] = {
        pos = vec3(0.13, -0.15, 0.07),
        entity = nil,
        hash = nil
    },

}

AddEventHandler('ox_inventory:currentWeapon', function(data)
    if data then
        for k, v in pairs (Weapons) do
            if k == data.hash then
                curWeapon = data.hash
                removeWeapon(data.hash)
            end
        end
    else
        if curWeapon then
            putOnBack(curWeapon)
        end
    end
end)


function removeWeapon(hash)
    for k, v in pairs(Weapons) do
        if hash == k then
            removeFromSlot(hash)
        end
    end
end

function removeFromInv(hash)
    removeFromSlot(hash)
end

function putOnBack(hash)
    local whatSlot = checkForSlot(hash)
    if whatSlot then
        curWeapon = nil
        local object = Weapons[hash].object
        if not HasModelLoaded(object) then
            RequestModel(object)
            Wait(10)
        end
        local coords = GetEntityCoords(PlayerPedId())
         local prop = CreateObject(object, coords.x, coords.y, coords.z,  true,  true, true)
        slots[whatSlot].entity = prop
        slots[whatSlot].hash = hash
        AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  Weapons[hash].bone), Weapons[hash].pos.x, Weapons[hash].pos.y, Weapons[hash].pos.z, Weapons[hash].rot.x, Weapons[hash].rot.y, Weapons[hash].rot.z, true, true, false, true, 2, true)
    end
end

function respawningCheckWeapon()
    for k, v in pairs(slots) do
        if v.entity ~= nil then
            if DoesEntityExist(v.entity) then
                    DeleteEntity(v.entity)
            end
            local whatItem = Weapons[v.hash].item
            local count = exports.ox_inventory:Search(2, whatItem)
            local oldHash = v.hash
            v.entity = nil
            v.hash = nil
            if count > 0 then
                putOnBack(oldHash)
            end
        end
    end
end

function checkForSlot(hash)
    local result = nil
    if not noDupes(hash) then
        for k, v in pairs(slots) do
            if not v.entity then
                result = k
            end
        end
    end
    return result
end

function noDupes(hash)
    local result = false
    for k, v in pairs(slots) do 
        if v.hash == hash then
            result = true
        end
    end
    return result
end

function removeFromSlot(hash)
    local whatItem = Weapons[hash].item
    local count = exports.ox_inventory:Search(2, whatItem)
    for k, v in pairs(slots) do
        if v.hash == hash then
            if count <= 0 then
                DetachEntity(v.entity)
                DeleteEntity(v.entity)
                slots[k].entity = nil
                slots[k].hash = nil
            elseif hash == curWeapon then
                DetachEntity(v.entity)
                DeleteEntity(v.entity)
                slots[k].entity = nil
                slots[k].hash = nil  
            elseif inCar then
                DetachEntity(v.entity)
                DeleteEntity(v.entity)
                slots[k].entity = nil
                slots[k].hash = nil  
            end
        end
    end
end

AddEventHandler('ox_inventory:updateInventory', function(changes)
    for k, v in pairs(Weapons) do
        local count = exports.ox_inventory:Search(2, v.item)
        if count > 0 and curWeapon == nil then
            putOnBack(k)
        else
            removeFromInv(k)
        end
    end
end)

RegisterCommand('fixprop', function()
    for k, v in pairs(GetGamePool('CObject')) do
        if IsEntityAttachedToEntity(PlayerPedId(), v) then
            SetEntityAsMissionEntity(v, true, true)
            DeleteObject(v)
            DeleteEntity(v)
        end
    end
    respawningCheckWeapon()
end)

RegisterNetEvent("megaphone:Toggle", function()
    if not holdingMega then
        holdingMega = true
        CreateThread(function()
            while true do
                Wait(1000) 
                if not IsEntityPlayingAnim(PlayerPedId(),"amb@world_human_mobile_film_shocking@female@base", "base", 3) and holdingMega then
                    holdingMega = false
                    ExecuteCommand('e c')
                    exports["pma-voice"]:clearProximityOverride()
                    TerminateThisThread()
                    break
                end
            end
        end)
        ExecuteCommand('e megaphone')
        exports["pma-voice"]:overrideProximityRange(50.0, true)
    else
        holdingMega = false
        ExecuteCommand('e c')
        exports["pma-voice"]:clearProximityOverride()
    end
end)

secondsUntilKick = 2000

CreateThread(function()
    while true do
        Wait(1000)
        playerPed = GetPlayerPed(-1)
        if playerPed then
            currentPos = GetEntityCoords(playerPed, true)
            if currentPos == prevPos then
                if time > 0 then
                    if time == math.ceil(secondsUntilKick / 2) then
                        TriggerEvent('chat:addMessage', { 
                            template = '<div class="chat-message-rep"><b>SYSTEM</b>: {0}</div>',
                            args = { "Terdeteksi AFK [1/2]" }
                        })
                    end
                    time = time - 1
                else
                    TriggerServerEvent("midp-core:keluarKau", "Terdeteksi AFK [2/2]")
                end
            else
                time = secondsUntilKick
            end
            prevPos = currentPos
        end
    end
end)

RegisterNetEvent('alan-toolkit:onUse')
AddEventHandler('alan-toolkit:onUse', function()
    local playerped = PlayerPedId()
    local coordA = GetEntityCoords(playerped, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    local targetVehicle = getVehicleInDirection(coordA, coordB)

    if IsPedSittingInAnyVehicle(playerPed) then
        exports['midp-tasknotify']:SendAlert('error', 'Jangan didalam kendaraan!', 10000)
    else
        if targetVehicle ~= 0 then
            local d1,d2 = GetModelDimensions(GetEntityModel(targetVehicle))
            local moveto = GetOffsetFromEntityInWorldCoords(targetVehicle, 0.0,d2["y"]+0.5,0.0)
            local dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
            local count = 1000

            while dist > 1.0 and count > 0 do
                dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
                Wait(1)
                count = count - 1
                DrawText3Ds(moveto["x"],moveto["y"],moveto["z"],"Perbaiki disini")
            end

            local timeout = 20
            NetworkRequestControlOfEntity(targetVehicle)
            while not NetworkHasControlOfEntity(targetVehicle) and timeout > 0 do 
                NetworkRequestControlOfEntity(targetVehicle)
                Wait(100)
                timeout = timeout -1
            end

            local r1 = math.random(1, 10)
            local r2 = math.random(1, 10)
            local engine = GetEntityBoneIndexByName(targetVehicle, 'engine')
            local coordsE = GetWorldPositionOfEntityBone(targetVehicle, engine)

            SetVehicleDoorOpen(targetVehicle, 4, 0, 0)
            exports['mythic_progbar']:Progress({
                name = "toolkit",
                duration = 30000,
                label = 'Memperbaiki',
                useWhileDead = true,
                canCancel = false,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "mini@repair",
                    anim = "fixing_a_player",
                    flags = 49,
                },
            }, function(cancelled)
                if not cancelled then
                    if r1 == r2 then
                        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
                        PlaySoundFromCoord(-1, "Jet_Explosions", coordsE.x, coordsE.y, coordsE.z, "exile_1", 0, 0, 0)
                        exports['midp-tasknotify']:SendAlert('error', 'Terjadi kesalahan, mesin terbakar!', 10000)
                        ClearPedTasksImmediately(playerped)
                        SetVehicleEngineHealth(targetVehicle, 0)
                        TriggerServerEvent('alan-toolkit:removeKit')
                        Wait(4000)
                        SetVehicleTimedExplosion(targetVehicle)
                    else
                        SetVehicleEngineHealth(targetVehicle, 700.0)
                        SetVehicleBodyHealth(targetVehicle, 700.0)
                        TriggerServerEvent('alan-toolkit:removeKit')
                        SetVehicleDoorShut(targetVehicle, 4, 1, 1) 
                    end
                end
            end)
        end
    end
end)

function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)   
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

function DrawText3Ds(x,y,z, text)
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

RegisterCommand('fixdrop', function()
    local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
    if playerCoords.z < 25 then
        local playerCoordsUP = GetEntityCoords(playerPed)
        playerCoordsUP = vector3(playerCoordsUP.x, playerCoordsUP.y, playerCoordsUP.z + 200)
        local unusedBool, nearZ = GetGroundZFor_3dCoord(playerCoordsUP.x, playerCoordsUP.y, 99999.0, 1)
        nearZ = nearZ + 2.0
        playerCoordsUP = vector3(playerCoordsUP.x, playerCoordsUP.y, nearZ)

        if IsPedInAnyVehicle(playerPed, true) then
            SetEntityCoords(GetVehiclePedIsUsing(playerPed), playerCoordsUP)
        else
            SetEntityCoords(playerPed, playerCoordsUP)
        end
        
        Wait(5000)
        exports['midp-tasknotify']:SendAlert('inform', 'Kamu berhasil ke teleport ke atas')
	else
		exports['midp-tasknotify']:SendAlert('error', 'Hanya bisa digunakan saat tenggelam!')
    end
end)