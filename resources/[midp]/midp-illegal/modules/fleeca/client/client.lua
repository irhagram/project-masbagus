
Freeze = {F1 = 0, F2 = 0, F3 = 0, F4 = 0, F5 = 0, F6 = 0}
PlayerData = nil
Check = {F1 = false, F2 = false, F3 = false, F4 = false, F5 = false, F6 = false}
SearchChecks = {F1 = false, F2 = false, F3 = false, F4 = false, F5 = false, F6 = false}
LootCheck = {
    F1 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
    F2 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
    F3 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
    F4 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
    F5 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
    F6 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false}
}
Doors = {}
local disableinput = false
local initiator = false
local startdstcheck = false
local currentname = nil
local currentcoords = nil
local done = true
local dooruse = false

Citizen.CreateThread(function() 
	while true do 
	local enabled = false 
	Citizen.Wait(1) 
		if disableinput then 
			enabled = true 
			DisableControl() 
		end 
		if not enabled then 
			Citizen.Wait(500) 
		end 
	end 
end)

function DisableControl() 
	DisableControlAction(0, 73, false) DisableControlAction(0, 24, true) DisableControlAction(0, 257, true) DisableControlAction(0, 25, true) DisableControlAction(0, 263, true) DisableControlAction(0, 32, true) DisableControlAction(0, 34, true) DisableControlAction(0, 31, true) DisableControlAction(0, 30, true) DisableControlAction(0, 45, true) DisableControlAction(0, 22, true) DisableControlAction(0, 44, true) DisableControlAction(0, 37, true) DisableControlAction(0, 23, true) DisableControlAction(0, 288, true) DisableControlAction(0, 289, true) DisableControlAction(0, 170, true) DisableControlAction(0, 167, true) DisableControlAction(0, 73, true) DisableControlAction(2, 199, true) DisableControlAction(0, 47, true) DisableControlAction(0, 264, true) DisableControlAction(0, 257, true) DisableControlAction(0, 140, true) DisableControlAction(0, 141, true) DisableControlAction(0, 142, true) DisableControlAction(0, 143, true) 
end

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    PlayerData.job = job
end)

RegisterNetEvent("alan-fleecarob:resetDoorState")
AddEventHandler("alan-fleecarob:resetDoorState", function(name)
    Freeze[name] = 0
end)

RegisterNetEvent("alan-fleecarob:lootup_c")
AddEventHandler("alan-fleecarob:lootup_c", function(var, var2)
    LootCheck[var][var2] = true
end)

RegisterNetEvent("alan-fleecarob:outcome")
AddEventHandler("alan-fleecarob:outcome", function(oc, arg)
    for i = 1, #Check, 1 do
        Check[i] = false
    end
    for i = 1, #LootCheck, 1 do
        for j = 1, #LootCheck[i] do
            LootCheck[i][j] = false
        end
    end
    if oc then
        Check[arg] = true
        TriggerEvent("alan-fleecarob:startheist", Config_Fleeca.Banks[arg], arg)
    elseif not oc then
        exports['midp-tasknotify']:Alert("SYSTEM", arg, 5000, 'error')
		--TriggerEvent('ox_inventory:notify', {type = 'error', arg})
    end
end)

RegisterNetEvent("alan-fleecarob:startLoot_c")
AddEventHandler("alan-fleecarob:startLoot_c", function(data, name)

    currentname = name
    currentcoords = vector3(data.doors.startloc.x, data.doors.startloc.y, data.doors.startloc.z)
    if not LootCheck[name].Stop then
        Citizen.CreateThread(function()
            while true do
                local pedcoords = GetEntityCoords(PlayerPedId())
                local dst = #(pedcoords - vector3(data.doors.startloc.x, data.doors.startloc.y, data.doors.startloc.z))

                if dst < 40 then
                    if not LootCheck[name].Loot1 then
                        local dst1 = #(pedcoords - vector3(data.trolley1.x, data.trolley1.y, data.trolley1.z + 1))
                    end

                    if LootCheck[name].Stop or (LootCheck[name].Loot1 and LootCheck[name].Loot2 and LootCheck[name].Loot3) then
                        LootCheck[name].Stop = false
                        if initiator then
                            TriggerEvent("alan-fleecarob:reset", name, data)
                            return
                        end
                        return
                    end
                    Citizen.Wait(1)
                else
                    Citizen.Wait(1000)
                end
            end
        end)
    end
end)

RegisterNetEvent("alan-fleecarob:stopHeist_c")
AddEventHandler("alan-fleecarob:stopHeist_c", function(name)
    LootCheck[name].Stop = true
end)

-- MAIN DOOR UPDATE --

AddEventHandler("alan-fleecarob:freezeDoors", function()
    Citizen.CreateThread(function()
        while true do
            for k, v in pairs(Doors) do
                if v[1].obj == nil or not DoesEntityExist(v[1].obj) then
                    v[1].obj = GetClosestObjectOfType(v[1].loc, 1.5, `v_ilev_gb_vaubar`, false, false, false)
                    FreezeEntityPosition(v[1].obj, v[1].locked)
                else
                    FreezeEntityPosition(v[1].obj, v[1].locked)
                    Citizen.Wait(100)
                end
                if v[1].locked then
                    SetEntityHeading(v[1].obj, v[1].h)
                end
                Citizen.Wait(100)
            end
            Citizen.Wait(1)
        end
    end)
end)
RegisterNetEvent("alan-fleecarob:toggleVault")
AddEventHandler("alan-fleecarob:toggleVault", function(key, state)
    dooruse = true
    Doors[key][2].state = nil
    if Config_Fleeca.Banks[key].hash == nil then
        if not state then
            local obj = GetClosestObjectOfType(Config_Fleeca.Banks[key].doors.startloc.x, Config_Fleeca.Banks[key].doors.startloc.y, Config_Fleeca.Banks[key].doors.startloc.z, 2.0, GetHashKey(Config_Fleeca.vaultdoor), false, false, false)
            local count = 0

            repeat
                local heading = GetEntityHeading(obj) - 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Citizen.Wait(10)
            until count == 900
            Doors[key][2].locked = state
            Doors[key][2].state = GetEntityHeading(obj)
            TriggerServerEvent("alan-fleecarob:updateVaultState", key, Doors[key][2].state)
        elseif state then
            local obj = GetClosestObjectOfType(Config_Fleeca.Banks[key].doors.startloc.x, Config_Fleeca.Banks[key].doors.startloc.y, Config_Fleeca.Banks[key].doors.startloc.z, 2.0, GetHashKey(Config_Fleeca.vaultdoor), false, false, false)
            local count = 0

            repeat
                local heading = GetEntityHeading(obj) + 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Citizen.Wait(10)
            until count == 900
            Doors[key][2].locked = state
            Doors[key][2].state = GetEntityHeading(obj)
            TriggerServerEvent("alan-fleecarob:updateVaultState", key, Doors[key][2].state)
        end
    else
        if not state then
            local obj = GetClosestObjectOfType(Config_Fleeca.Banks.F4.doors.startloc.x, Config_Fleeca.Banks.F4.doors.startloc.y, Config_Fleeca.Banks.F4.doors.startloc.z, 2.0, Config_Fleeca.Banks.F4.hash, false, false, false)
            local count = 0
            repeat
                local heading = GetEntityHeading(obj) - 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Citizen.Wait(10)
            until count == 900
            Doors[key][2].locked = state
            Doors[key][2].state = GetEntityHeading(obj)
            TriggerServerEvent("alan-fleecarob:updateVaultState", key, Doors[key][2].state)
        elseif state then
            local obj = GetClosestObjectOfType(Config_Fleeca.Banks.F4.doors.startloc.x, Config_Fleeca.Banks.F4.doors.startloc.y, Config_Fleeca.Banks.F4.doors.startloc.z, 2.0, Config_Fleeca.Banks.F4.hash, false, false, false)
            local count = 0

            repeat
                local heading = GetEntityHeading(obj) + 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Citizen.Wait(10)
            until count == 900
            Doors[key][2].locked = state
            Doors[key][2].state = GetEntityHeading(obj)
            TriggerServerEvent("alan-fleecarob:updateVaultState", key, Doors[key][2].state)
        end
    end
    dooruse = false
end)

AddEventHandler("alan-fleecarob:reset", function(name, data)
    for i = 1, #LootCheck[name], 1 do
        LootCheck[name][i] = false
    end
    Check[name] = false
    Citizen.Wait(1800000)
    exports['midp-tasknotify']:Alert("SYSTEM", "PINTU TERTUTUP!", 5000, 'error')
	--TriggerEvent('ox_inventory:notify', {type = 'error', text = 'VAULT DOOR CLOSING!'})
    TriggerServerEvent("alan-fleecarob:toggleVault", name, true)
    TriggerEvent("alan-fleecarob:cleanUp", data, name)
end)

AddEventHandler("alan-fleecarob:startheist", function(data, name)
    TriggerServerEvent("alan-fleecarob:toggleDoor", name, true) -- ensure to lock the second door for the second, third, fourth... heist
    disableinput = true
    currentname = name
    currentcoords = vector3(data.doors.startloc.x, data.doors.startloc.y, data.doors.startloc.z)
    initiator = true
    RequestModel("p_ld_id_card_01")
    while not HasModelLoaded("p_ld_id_card_01") do
        Citizen.Wait(1)
    end
    local ped = PlayerPedId()

    SetEntityCoords(ped, data.doors.startloc.animcoords.x, data.doors.startloc.animcoords.y, data.doors.startloc.animcoords.z)
    SetEntityHeading(ped, data.doors.startloc.animcoords.h)
    local pedco = GetEntityCoords(PlayerPedId())
    IdProp = CreateObject(`p_ld_id_card_01`, pedco, 1, 1, 0)
    local boneIndex = GetPedBoneIndex(PlayerPedId(), 28422)

    AttachEntityToEntity(IdProp, ped, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_ATM", 0, true)
    Wait(2000)
    Citizen.Wait(1500)
    DetachEntity(IdProp, false, false)
    SetEntityCoords(IdProp, data.prop.first.coords, 0.0, 0.0, 0.0, false)
    SetEntityRotation(IdProp, data.prop.first.rot, 1, true)
    FreezeEntityPosition(IdProp, true)
    Citizen.Wait(500)
    ClearPedTasksImmediately(ped)
    disableinput = false
    Citizen.Wait(1000)
    Wait(2000)
    exports['midp-tasknotify']:Alert("SYSTEM", "HACKING BERHASIL!", 5000, 'success')
	--TriggerEvent('ox_inventory:notify', {type = 'success', text = 'Hacking complete!'})
    PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    TriggerServerEvent("alan-fleecarob:toggleVault", name, false)
    startdstcheck = true
    currentname = name
    SpawnTrolleys(data, name)
end)

AddEventHandler("alan-fleecarob:cleanUp", function(data, name)
    Citizen.Wait(10000)
    for i = 1, 3, 1 do -- full trolley clean
        local obj = GetClosestObjectOfType(data.objects[i].x, data.objects[i].y, data.objects[i].z, 0.75, `hei_prop_hei_cash_trolly_01`, false, false, false)

        if DoesEntityExist(obj) then
            DeleteEntity(obj)
        end
    end
    for j = 1, 3, 1 do -- empty trolley clean
        local obj = GetClosestObjectOfType(data.objects[j].x, data.objects[j].y, data.objects[j].z, 0.75, `hei_prop_hei_cash_trolly_03`, false, false, false)

        if DoesEntityExist(obj) then
            DeleteEntity(obj)
        end
    end
    if DoesEntityExist(IdProp) then
        DeleteEntity(IdProp)
    end
    if DoesEntityExist(IdProp2) then
        DeleteEntity(IdProp2)
    end
    TriggerServerEvent("alan-fleecarob:setCooldown", name)
    initiator = false
end)

function SpawnTrolleys(data, name)
    RequestModel("hei_prop_hei_cash_trolly_01")
    while not HasModelLoaded("hei_prop_hei_cash_trolly_01") do
        Citizen.Wait(1)
    end
    Trolley1 = CreateObject(`hei_prop_hei_cash_trolly_01`, data.trolley1.x, data.trolley1.y, data.trolley1.z, 1, 1, 0)
    local h1 = GetEntityHeading(Trolley1)

    SetEntityHeading(Trolley1, h1 + Config_Fleeca.Banks[name].trolley1.h)
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 20.0)
    local missionplayers = {}

    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            table.insert(missionplayers, GetPlayerServerId(players[i]))
        end
    end
    TriggerServerEvent("alan-fleecarob:startLoot", data, name, missionplayers)
    done = false
end

RegisterNetEvent('alan-fleecarob:grab')
AddEventHandler('alan-fleecarob:grab', function(name)
    disableinput = true
    local ped = PlayerPedId()
    local model = "hei_prop_heist_cash_pile"

    Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, `hei_prop_hei_cash_trolly_01`, false, false, false)
    local CashAppear = function()
	    local pedCoords = GetEntityCoords(ped)
        local grabmodel = GetHashKey(model)

        RequestModel(grabmodel)
        while not HasModelLoaded(grabmodel) do
            Citizen.Wait(100)
        end
	    local grabobj = CreateObject(grabmodel, pedCoords, true)

	    --FreezeEntityPosition(grabobj, true)
	    SetEntityInvincible(grabobj, true)
	    SetEntityNoCollisionEntity(grabobj, ped)
	    SetEntityVisible(grabobj, false, false)
	    AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
	    local startedGrabbing = GetGameTimer()

	    Citizen.CreateThread(function()
		    while GetGameTimer() - startedGrabbing < 37000 do
			    Citizen.Wait(1)
			    DisableControlAction(0, 73, true)
			    if HasAnimEventFired(ped, `CASH_APPEAR`) then
				    if not IsEntityVisible(grabobj) then
					    SetEntityVisible(grabobj, true, false)
				    end
			    end
			    if HasAnimEventFired(ped, `RELEASE_CASH_DESTROY`) then
				    if IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, false, false)
                        TriggerServerEvent("alan-fleecarob:rewardCash")
				    end
			    end
		    end
		    DeleteObject(grabobj)
	    end)
    end
	local trollyobj = Trolley
    local emptyobj = `hei_prop_hei_cash_trolly_03`

	if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
		return
    end
    local baghash =`hei_p_m_bag_var22_arm_s`

    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(baghash)
    RequestModel(emptyobj)
    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and not HasModelLoaded(baghash) do
        Citizen.Wait(100)
    end
	while not NetworkHasControlOfEntity(trollyobj) do
		Citizen.Wait(1)
		NetworkRequestControlOfEntity(trollyobj)
	end
	local bag = CreateObject(`hei_p_m_bag_var22_arm_s`, GetEntityCoords(PlayerPedId()), true, false, false)
    local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
	NetworkStartSynchronisedScene(scene1)
	Citizen.Wait(1500)
	CashAppear()
	local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene2)
	Citizen.Wait(37000)
	local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene3)
    NewTrolley = CreateObject(emptyobj, GetEntityCoords(trollyobj) + vector3(0.0, 0.0, - 0.985), true)
    SetEntityRotation(NewTrolley, GetEntityRotation(trollyobj))
	while not NetworkHasControlOfEntity(trollyobj) do
		Citizen.Wait(1)
		NetworkRequestControlOfEntity(trollyobj)
	end
	DeleteObject(trollyobj)
    PlaceObjectOnGroundProperly(NewTrolley)
	Citizen.Wait(1800)
	DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
	RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
	SetModelAsNoLongerNeeded(emptyobj)
    SetModelAsNoLongerNeeded(`hei_p_m_bag_var22_arm_s`)
    disableinput = false
end)

Citizen.CreateThread(function()
    while true do
        if startdstcheck then
            if initiator then
                local playercoord = GetEntityCoords(PlayerPedId())

                if (GetDistanceBetweenCoords(playercoord, currentcoords, true)) > 20 then
                    LootCheck[currentname].Stop = true
                    startdstcheck = false
                    TriggerServerEvent("alan-fleecarob:stopHeist", currentname)
                end
            end
            Citizen.Wait(1)
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end
    PlayerData = ESX.GetPlayerData()
    while PlayerData == nil do
        Citizen.Wait(100)
    end
    ESX.TriggerServerCallback("alan-fleecarob:getBanks", function(bank, door)
        Config_Fleeca.Banks = bank
        Doors = door
    end)
    TriggerEvent("alan-fleecarob:freezeDoors")
    while true do
        if PlayerData.job.name ~= "police" then
            local coords = GetEntityCoords(PlayerPedId())

        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(1)
    end
end)

RegisterNetEvent('alan-fleecarob:hack')
AddEventHandler('alan-fleecarob:hack', function()
    local coords = GetEntityCoords(PlayerPedId())

    for k, v in pairs(Config_Fleeca.Banks) do
        if not v.onaction then
            local dst = #(GetEntityCoords(PlayerPedId()) - vector3(v.doors.startloc.x, v.doors.startloc.y, v.doors.startloc.z))

            if dst <= 1 and not Check[k] then
                Wait(750)
                exports['midp-context']:OpenHackingGame(function(outcome)
                    if outcome == true then 
                        Wait(750)
                        TriggerServerEvent("alan-fleecarob:startcheck", k)
                       -- local data = {displayCode = '211', description = 'Fleeca Bank Robbery On Progress', priority = 'high', isImportant = 1, recipientList = {'police'}, length = '10000', infoM = 'fa-info-circle', info = 'Check radar for information'}
                        --local dispatchData = {dispatchData = data, caller = 'Alarm', coords = vector3(-596.30, -283.90, 50.3236)}
                        --TriggerServerEvent('wf-alerts:svNotify', dispatchData)
                    elseif outcome == false then
                        exports['midp-tasknotify']:Alert("SYSTEM", "HACKING GAGAL!", 5000, 'error')
                    end
                end)
            end
        end
    end
end)

RegisterNetEvent("alan-fleecarob:policenotify")
AddEventHandler("alan-fleecarob:policenotify", function(name)
    local PlayerData = ESX.GetPlayerData()
    local blip = nil

    while PlayerData.job == nil do
        Citizen.Wait(1)
    end
    if PlayerData.job.name == "police" then
        exports['midp-tasknotify']:Alert("SYSTEM", "ALARM BERBUNYI, MAYDAY!", 5000, 'error')
	--TriggerEvent('ox_inventory:notify', {type = 'error', text = "A bank's alarms are triggered!"})
        if not DoesBlipExist(blip) then
            blip = AddBlipForCoord(Config_Fleeca.Banks[name].doors.startloc.x, Config_Fleeca.Banks[name].doors.startloc.y, Config_Fleeca.Banks[name].doors.startloc.z)
            SetBlipSprite(blip, 161)
            SetBlipScale(blip, 2.0)
            SetBlipColour(blip, 1)

            PulseBlip(blip)
            Citizen.Wait(240000)
            RemoveBlip(blip)
        end
    end
end)

Citizen.CreateThread(function()
exports['ox_target']:AddCircleZone("trolley", vector3(1174.24, 2716.69, 37.07), 1.0, {
	name ="trolley",
	useZ = true,
	--debugPoly=true
	}, {
	options = {
		{
			event = "alan-fleecarob:grab",
			icon = "fas fa-money-bill",
			label = "Ambil Uang",
		},
	},
	distance = 3.7
})

exports['ox_target']:AddCircleZone("trolley2", vector3(-353.34, -59.48, 48.01), 1.0, {
	name ="trolley2",
	useZ = true,
	--debugPoly=true
	}, {
	options = {
		{
			event = "alan-fleecarob:grab",
			icon = "fas fa-money-bill",
			label = "Ambil Uang",
		},
	},
	distance = 3.7
})

exports['ox_target']:AddCircleZone("trolley3", vector3(-2952.69, 483.34, 14.68), 1.0, {
	name ="trolley3",
	useZ = true,
	--debugPoly=true
	}, {
	options = {
		{
			event = "alan-fleecarob:grab",
			icon = "fas fa-money-bill",
			label = "Ambil Uang",
		},
	},
	distance = 3.7
})

exports['ox_target']:AddCircleZone("trolley4", vector3(-1207.50, -339.20, 36.76), 1.0, {
	name ="trolley4",
	useZ = true,
	--debugPoly=true
	}, {
	options = {
		{
			event = "alan-fleecarob:grab",
			icon = "fas fa-money-bill",
			label = "Ambil Uang",
		},
	},
	distance = 3.7
})

exports['ox_target']:AddCircleZone("trolley5", vector3(147.25, -1050.38, 28.35), 1.0, {
	name ="trolley5",
	useZ = true,
	--debugPoly=true
	}, {
	options = {
		{
			event = "alan-fleecarob:grab",
			icon = "fas fa-money-bill",
			label = "Ambil Uang",
		},
	},
	distance = 3.7
})

exports['ox_target']:AddCircleZone("trolley6", vector3(313.450, -289.24, 54.1404), 1.0, {
	name ="trolley6",
	useZ = true,
	--debugPoly=true
	}, {
	options = {
		{
			event = "alan-fleecarob:grab",
			icon = "fas fa-money-bill",
			label = "Ambil Uang",
		},
	},
	distance = 3.7
})

exports['ox_target']:AddBoxZone("fleecapad1", vector3(311.58, -284.62, 54.17), 0.5, 0.2, {
	name="fleecapad1",
	heading=340,
	--debugPoly=false,
	minZ=54.02,
	maxZ=54.72,
	}, {
		options = {
			{
				event = "alan-fleecarob:hack",
				icon = "fas fa-laptop-code",
				label = "Bobol Bank",
				item = "hack_usb",
			},
		},
		distance = 3.5
})

exports['ox_target']:AddBoxZone("fleecapad2", vector3(147.2, -1046.22, 29.38), 0.6, 0.2, {
	name="fleecapad2",
	heading=340,
	--debugPoly=false,
	minZ=29.18,
	maxZ=29.93,
	}, {
		options = {
			{
				event = "alan-fleecarob:hack",
				icon = "fas fa-laptop-code",
				label = "Bobol Bank",
				item = "hack_usb",
			},
		},
		distance = 3.5
})

exports['ox_target']:AddBoxZone("fleecapad3", vector3(-1210.44, -336.41, 37.79), 0.2, 0.55, {
	name="fleecapad3",
	heading=296,
	--debugPoly=false,
	minZ=37.64,
	maxZ=38.34,
	}, {
		options = {
			{
				event = "alan-fleecarob:hack",
				icon = "fas fa-laptop-code",
				label = "Bobol Bank",
				item = "hack_usb",
			},
		},
		distance = 3.5
})

exports['ox_target']:AddBoxZone("fleecapad4", vector3(-2956.5, 482.12, 15.71), 0.15, 0.6, {
	name="fleecapad4",
	heading=357,
	--debugPoly=false,
	minZ=15.51,
	maxZ=16.26,
	}, {
		options = {
			{
				event = "alan-fleecarob:hack",
				icon = "fas fa-laptop-code",
				label = "Bobol Bank",
				item = "hack_usb",
			},
		},
		distance = 3.5
})

exports['ox_target']:AddBoxZone("fleecapad5", vector3(-353.51, -55.47, 49.05), 0.5, 0.2, {
	name="fleecapad5",
	heading=340,
	--debugPoly=false,
	minZ=48.9,
	maxZ=49.6,
	}, {
		options = {
			{
				event = "alan-fleecarob:hack",
				icon = "fas fa-laptop-code",
				label = "Bobol Bank",
				item = "hack_usb",
			},
		},
		distance = 3.5
})

exports['ox_target']:AddBoxZone("fleecapad6", vector3(1175.63, 2712.9, 38.1), 0.6, 0.2, {
	name="fleecapad6",
	heading=0,
	--debugPoly=false,
	minZ=37.9,
	maxZ=38.65,
	}, {
		options = {
			{
				event = "alan-fleecarob:hack",
				icon = "fas fa-laptop-code",
				label = "Bobol Bank",
				item = "hack_usb",
			},
		},
		distance = 3.5
})
end)