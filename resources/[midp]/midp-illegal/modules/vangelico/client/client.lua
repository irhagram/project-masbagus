
local canthermite = false
local successful = false


Citizen.CreateThread(function()
    if Config_Vangelico.ShowBlip == true then
        local blip = AddBlipForCoord(Config_Vangelico.BlipCoords)
        SetBlipSprite(blip, 617)
        SetBlipColour(blip, 3)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        SetBlipDisplay(blip, 4)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Toko Berlian")
        EndTextCommandSetBlipName(blip)
    end
end)

Citizen.CreateThread(function()

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

function FirstLoadup()
    CreateTargets() 
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

function UnAuthJob()

	local UnAuthjob = false
	for i,v in pairs(Config_Vangelico.UnAuthJobs) do
		if PlayerData.job.name == v then
			UnAuthjob = true
			break
		end
	end

	return UnAuthjob
end

local CircleZone = CircleZone:Create(vector3(-596.30, -283.90, 50.3236), 1.0, {
    name="circle_zone",
    debugPoly=false,
})

Citizen.CreateThread(function()
    while true do
        local coords = GetEntityCoords(PlayerPedId())
        nearFuseBox = CircleZone:isPointInside(coords)
        Citizen.Wait(500)
        if nearFuseBox then
            canthermite = true
        end
    end
end)

RegisterNetEvent('dl-vdoors:set')
AddEventHandler('dl-vdoors:set', function(doorId, isLocked)
    DoorSystemSetDoorState(doorId, isLocked and 1 or 0)
end)

RegisterNetEvent('dl-vdoors:initialize')
AddEventHandler('dl-vdoors:initialize', function(allDoors)
    for doorId, door in pairs(allDoors) do
        AddDoorToSystem(doorId, door.Model, door.Coordinates)
        DoorSystemSetDoorState(doorId, door.Locked and 1 or 0)
    end
end)
RegisterNetEvent('dl-robjewel:thermite')
AddEventHandler('dl-robjewel:thermite', function()
    local playercoords = GetEntityCoords(PlayerPedId())
   
    if canthermite then
        RequestAnimDict('anim@heists@ornate_bank@thermal_charge')
        RequestModel('hei_p_m_bag_var22_arm_s')
        RequestNamedPtfxAsset('scr_ornate_heist')
        while not HasAnimDictLoaded('anim@heists@ornate_bank@thermal_charge') and not HasModelLoaded('hei_p_m_bag_var22_arm_s') and not HasNamedPtfxAssetLoaded('scr_ornate_heist') do
            Citizen.Wait(50)
        end
        TaskGoStraightToCoord(PlayerPedId(), -596.26, -283.82, 50.3236, 1.0, -1, 299.32, 0.0)
        Citizen.Wait(2000)
        -- SetEntityCoords(PlayerPedId(), -596.30, -283.90, 50.3237)

        exports['midp-ui']:thermiteminigame(10, 3, 3, 10,
        function() -- success
            --print("success")
                FirstLoadup() -- creating the targets
                local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
                local bagscene = NetworkCreateSynchronisedScene(-596.14, -283.74, 50.3236, rotx, roty, rotz + 1.1, 2, false, false, 1065353216, 0, 1.3)
                local bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), -596.14, -283.74, 50.3236,  true,  true, false)
                local data = {displayCode = '211', description = 'Vangelico Robbery On Progress', priority = 'high', isImportant = 1, recipientList = {'police'}, length = '10000', infoM = 'fa-info-circle', info = 'Check radar for information'}
                local dispatchData = {dispatchData = data, caller = 'Alarm', coords = vector3(-596.30, -283.90, 50.3236)}
                TriggerServerEvent('wf-alerts:svNotify', dispatchData)

                SetEntityCollision(bag, false, true)
                NetworkAddPedToSynchronisedScene(PlayerPedId(), bagscene, 'anim@heists@ornate_bank@thermal_charge', 'thermal_charge', 1.2, -4.0, 1, 16, 1148846080, 0)
                NetworkAddEntityToSynchronisedScene(bag, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'bag_thermal_charge', 4.0, -8.0, 1)
                SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 0)
                NetworkStartSynchronisedScene(bagscene)
                Citizen.Wait(1500)
                local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
                local thermite = CreateObject(GetHashKey('hei_prop_heist_thermite'), x, y, z + 0.3,  true,  true, true)

                SetEntityCollision(thermite, false, true)
                AttachEntityToEntity(thermite, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
                Citizen.Wait(2000)
                DeleteObject(bag)
                SetPedComponentVariation(PlayerPedId(), 5, 45, 0, 0)
                DetachEntity(thermite, 1, 1)
                FreezeEntityPosition(thermite, true)
                TriggerServerEvent('dl-robjewel:particleserver', method)
                SetPtfxAssetNextCall('scr_ornate_heist')
                local effect = StartParticleFxLoopedAtCoord('scr_heist_ornate_thermal_burn', -596.14, -282.74, 50.3236, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

                
                NetworkStopSynchronisedScene(bagscene)
                TaskPlayAnim(PlayerPedId(), 'anim@heists@ornate_bank@thermal_charge', 'cover_eyes_intro', 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
                TaskPlayAnim(PlayerPedId(), 'anim@heists@ornate_bank@thermal_charge', 'cover_eyes_loop', 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
                Citizen.Wait(10000)
                ClearPedTasks(PlayerPedId())
                DeleteObject(thermite)
                StopParticleFxLooped(effect, 0)
                successful = true
                TriggerServerEvent('dl-robjewel:thermitedelete')
                ExecuteCommand('vdoors 1')
                ExecuteCommand('vdoors 2')
                TriggerServerEvent("dl-robjewel:policenotify")
                --DoorSystemSetDoorState(1425919976, 0, false, false)
                --DoorSystemSetDoorState(9467943, 0, false, false)
        end,
        function() -- failure
		if Config_Vangelico.UseAlarmSound == true then
		Alarm()
		end
            exports['midp-tasknotify']:SendAlert('error', 'Gagal!')
            TriggerServerEvent('dl-robjewel:thermitedelete')
        end)
    end
end)

RegisterNetEvent('dl-robjewel:ptfxparticle')
AddEventHandler('dl-robjewel:ptfxparticle', function(method)
    local ptfx

    RequestNamedPtfxAsset('scr_ornate_heist')
    while not HasNamedPtfxAssetLoaded('scr_ornate_heist') do
        Citizen.Wait(1)
    end
        ptfx = vector3(-596.14, -282.74, 50.3236)
    SetPtfxAssetNextCall('scr_ornate_heist')
    local effect = StartParticleFxLoopedAtCoord('scr_heist_ornate_thermal_burn', ptfx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Citizen.Wait(4000)
    
    StopParticleFxLooped(effect, 0)
end)

local weaponTypes = {
    ["2685387236"] = { "Unarmed", ["slot"] = 0 },
    ["3566412244"] = { "Melee", ["slot"] = 1 },
    ["-728555052"] = { "Melee", ["slot"] = 1 },
    ["416676503"] = { "Pistol", ["slot"] = 2 },
    ["3337201093"] = { "SMG", ["slot"] = 3 },
    ["970310034"] = { "AssaultRifle", ["slot"] = 4 },
    ["-957766203"] = { "AssaultRifle", ["slot"] = 4 },
    ["3539449195"] = { "DigiScanner", ["slot"] = 4 },
    ["4257178988"] = { "FireExtinguisher", ["slot"] = 0 },
    ["1159398588"] = { "MG", ["slot"] = 4 },
    ["3493187224"] = { "NightVision", ["slot"] = 0 },
    ["431593103"] = { "Parachute", ["slot"] = 0 },
    ["860033945"] = { "Shotgun", ["slot"] = 3 },
    ["3082541095"] = { "Sniper", ["slot"] = 3 },
    ["690389602"] = { "Stungun", ["slot"] = 1 },
    ["2725924767"] = { "Heavy", ["slot"] = 4 },
    ["1548507267"] = { "Thrown", ["slot"] = 0 },
    ["1595662460"] = { "PetrolCan", ["slot"] = 1 }
}

--local _,wep = GetCurrentPedWeapon(playerPed)
local jewelry = false

function weaponTypeC()
	local w = GetSelectedPedWeapon(PlayerPedId())
	local wg = GetWeapontypeGroup(w)
	if weaponTypes[""..wg..""] then
		return weaponTypes[""..wg..""]["slot"]
	else
		return 0
	end
end

function giveitems()
    TriggerServerEvent('dl-robjewel:rewards')
end

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
     Citizen.Wait(5)
    end
end

local showcases = {
	{x = 147.085, y = -1048.612, z = 29.346, heading = 70.326, isOpen = false, rayfire = "DES_Jewel_Cab"},--
	{x = -626.735, y = -238.545, z = 38.057, heading = 214.907, isOpen = false, rayfire = "DES_Jewel_Cab3"},--
	{x = -625.697, y = -237.877, z = 38.057, heading = 217.311, isOpen = false, rayfire = "DES_Jewel_Cab4"},--
	{x = -626.825, y = -235.347, z = 38.057, heading = 33.745, isOpen = false, rayfire = "DES_Jewel_Cab"},--
	{x = -625.77, y = -234.563, z = 38.057, heading = 33.572, isOpen = false, rayfire = "DES_Jewel_Cab2"},--
	{x = -627.957, y = -233.918, z = 38.057, heading = 215.214, isOpen = false, rayfire = "DES_Jewel_Cab"},--
	{x = -626.971, y = -233.134, z = 38.057, heading = 215.532, isOpen = false, rayfire = "DES_Jewel_Cab3"},--
	{x = -624.433, y = -231.161, z = 38.057, heading = 305.159, isOpen = false, rayfire = "DES_Jewel_Cab3"},--
	{x = -623.045, y = -232.969, z = 38.057, heading = 303.496, isOpen = false, rayfire = "DES_Jewel_Cab4"},--
	{x = -620.265, y = -234.502, z = 38.057, heading = 217.504, isOpen = false, rayfire = "DES_Jewel_Cab"},--
	{x = -619.225, y = -233.677, z = 38.057, heading = 213.35, isOpen = false, rayfire = "DES_Jewel_Cab2"},--
	{x = -620.025, y = -233.354, z = 38.057, heading = 34.18, isOpen = false, rayfire = "DES_Jewel_Cab2"},--
	{x = -617.487, y = -230.605, z = 38.057, heading = 309.177, isOpen = false, rayfire = "DES_Jewel_Cab3"},--
	{x = -618.304, y = -229.481, z = 38.057, heading = 304.243, isOpen = false, rayfire = "DES_Jewel_Cab4"},--
	{x = -619.741, y = -230.32, z = 38.057, heading = 124.283, isOpen = false, rayfire = "DES_Jewel_Cab"},--
	{x = -619.69, y = -227.61, z = 38.057, heading = 305.245, isOpen = false, rayfire = "DES_Jewel_Cab"},--
	{x = -620.481, y = -226.59, z = 38.057, heading = 304.677, isOpen = false, rayfire = "DES_Jewel_Cab2"},--
	{x = -621.098, y = -228.495, z = 38.057, heading = 127.046, isOpen = false, rayfire = "DES_Jewel_Cab3"},--
	{x = -623.855, y = -227.051, z = 38.057, heading = 38.605, isOpen = false, rayfire = "DES_Jewel_Cab"},--
	{x = -624.977, y = -227.884, z = 38.057, heading = 48.847, isOpen = false, rayfire = "DES_Jewel_Cab4"},--
	{x = -624.056, y = -228.228, z = 38.057, heading = 216.443, isOpen = false, rayfire = "DES_Jewel_Cab4"},--
}

function animation()
	local playerPos = GetEntityCoords(PlayerPedId(), true)
    loadAnimDict('missheist_jewel')
    for i,v in pairs(showcases) do 
        if #(playerPos - vector3(v.x, v.y, v.z)) < 0.75 then
            SetEntityCoords(PlayerPedId(), v.x, v.y, v.z-0.95)
            SetEntityHeading(PlayerPedId(), v.heading)
            TaskPlayAnim(PlayerPedId(), 'missheist_jewel', 'smash_case', 8.0, 8.0, -1, 33, 0, 0, 0, 0)
            while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
                RequestNamedPtfxAsset('scr_jewelheist')
                Citizen.Wait(0)
            end
	    Wait(250)
            PlaySoundFromCoord(-1, 'Glass_Smash', playerPos.x, playerPos.y, playerPos.z, "", 0, 2.0, 0)
            SetPtfxAssetNextCall('scr_jewelheist')
            StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', v.x, v.y, v.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	    --GetRayFireMapObject(vector3(v.x, v.y, v.z), 1, v.rayfire)
                
            Citizen.Wait(5000)
            ClearPedTasks(PlayerPedId())
        end
    end
end


RegisterNetEvent('dl-robjewel:loot')
AddEventHandler('dl-robjewel:loot', function(name)
    if successful and weaponTypeC() > 1 then
            animation()
            giveitems()
            jewelry = true
            exports.ox_target:RemoveZone('Case_Zone'..name)
    else
        exports['midp-tasknotify']:SendAlert('error', 'Silahkan gunakan senjata!', 5000)
    end
end)


Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 50)
        if jewelry then
            sleep = 0
            for i = 1, #players, 1 do
                TriggerServerEvent('dl-robjewel:allnotify', GetPlayerServerId(players))
            end
            Citizen.Wait(600000)
            ExecuteCommand('vdoors 1')
            ExecuteCommand('vdoors 2')
        end 
        Citizen.Wait(sleep)
    end
end)

exports['ox_target']:AddBoxZone('alarmbox', vector3(-595.94, -283.69, 50.32), 0.8, 0.25, {
	name='alarmbox',
	heading=30,
	--debugPoly=true,
	minZ=50.12,
	maxZ=51.32,
	}, {
		options = {
			{
                event = 'dl-robjewel:thermite',
                icon = 'fas fa-bomb',
                label = 'Disrupt Security',
                item = 'thermite',
			},
		},
		distance = 1.5
})

function CreateTargets()
    for k,v in pairs(Config_Vangelico.Showcases) do
        exports['ox_target']:AddBoxZone('Case_Zone'..k, v.location, v.size[1], v.size[2],
            {
                name = 'Case_Zone'..k,
                heading = v.heading,
                --debugPoly = true,
                minZ = v.zcoords[1],
                maxZ = v.zcoords[2],
            }, {
                options = {{
                    icon = 'fas fa-gem', 
                    label = 'Steal Jewels',
                    --event = v.event,
                    action = function()
                        local name = k
                        TriggerEvent('dl-robjewel:loot', name)
                    end
    
                }},
                distance = 1.5
            }
        )
    end
end

AddEventHandler('dl-robjewel:alarmBlip', function()
	local transT = 250
	local Blip = AddBlipForCoord(Config_Vangelico.BlipCoords)
	SetBlipSprite(Blip,  10)
	SetBlipColour(Blip,  1)
	SetBlipAlpha(Blip,  transT)
	SetBlipAsShortRange(Blip,  false)
	while transT ~= 0 do
		Wait(100)
		transT = transT - 1
		SetBlipAlpha(Blip,  transT)
		if transT == 0 then
			SetBlipSprite(Blip,  2)
			return
		end
	end
end)

function Alarm()
    exports.xsound:PlayUrlPos('alarm', 'SOUND URL HERE', 0.5, vector3(POSITIONALARM), true)
    exports['ox_target']:AddBoxZone("Alarmbutton", vector3(ALARM.BOX.COORDS), 0.30, 0.20, {
        name="Alarmbutton",
        heading=0.0,
        debugPoly=true,
        minZ=30.77834,
        maxZ=30.87834,
        }, {
            options = {
                {
                    icon = "fas fa-bell",
                    label = "Disable alarm",
                    action = function()
                        --"Possible minigame to stop alarm"
                        exports.xsound:Destroy('alarm')
                    end
                },
            },
            distance = 1.5
    })
end


AddEventHandler('onResourceStart', function(resourceName)
	if (resourceName == GetCurrentResourceName() and Config_Vangelico.Debug) then
        while (ESX == nil) do Citizen.Wait(100) end        
        Citizen.Wait(5000)
        ESX.PlayerLoaded = true
	end
end)

AddEventHandler('onResourceStop', function()
	for k,v in pairs(Config_Vangelico.Showcases) do
        exports['ox_target']:RemoveZone('Case_Zone'..k)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    while (ESX == nil) do Citizen.Wait(100) end    
    Citizen.Wait(5000)
    ESX.PlayerData = xPlayer
 	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)
