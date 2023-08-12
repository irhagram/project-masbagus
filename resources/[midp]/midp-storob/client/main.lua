local holdingUp, onLockpick = false, false
local store = ""
local blipRobbery = nil
local startrobbing = nil
local lose = 0
local lose1 = 0
local posrob = nil
local robberycode = {}


function drawTxt(x,y, width, height, scale, text, r,g,b,a, outline)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	if outline then SetTextOutline() end

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x - width/2, y - height/2 + 0.005)
end

RegisterNetEvent('esx_holdup:currentlyRobbing')
AddEventHandler('esx_holdup:currentlyRobbing', function(currentStore)
	holdingUp, store = true, currentStore
end)

RegisterNetEvent('esx_holdup:killBlip')
AddEventHandler('esx_holdup:killBlip', function()
	RemoveBlip(blipRobbery)
end)

RegisterNetEvent('esx_holdup:setBlip')
AddEventHandler('esx_holdup:setBlip', function(position)
	blipRobbery = AddBlipForCoord(position.x, position.y, position.z)

	SetBlipSprite(blipRobbery, 161)
	SetBlipScale(blipRobbery, 2.0)
	SetBlipColour(blipRobbery, 3)

	PulseBlip(blipRobbery)
end)

RegisterNetEvent('esx_holdup:tooFar')
AddEventHandler('esx_holdup:tooFar', function()
	holdingUp, store = false, ''
	exports['midp-tasknotify']:SendAlert('success', 'Perampokan dibatalkan')
end)

RegisterNetEvent('esx_holdup:robberyComplete')
AddEventHandler('esx_holdup:robberyComplete', function(award)
	holdingUp, store = false, ''
	exports['midp-tasknotify']:SendAlert('success', 'Perampokan Berhasil, Mendapat: $DL ' .. ESX.Math.GroupDigits(award), 10000)
end)

RegisterNetEvent('esx_holdup:startTimer')
AddEventHandler('esx_holdup:startTimer', function()
	local timer = Stores[store].secondsRemaining

	Citizen.CreateThread(function()
		while timer > 0 and holdingUp do
			Citizen.Wait(1000)

			if timer > 0 then
				timer = timer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		while holdingUp do
			Citizen.Wait(0)
			drawTxt(0.66, 1.44, 1.0, 1.0, 0.4, _U('robbery_timer', timer), 255, 255, 255, 255)
		end
	end)
end)

function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end

local showing = false

local cooldown = false

Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		local playerPos = GetEntityCoords(PlayerPedId(), true)

		for k,v in pairs(Stores) do
			local storePos = v.position
			local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, storePos.x, storePos.y, storePos.z)


			if distance < Config.Marker.DrawDistance then
				if not holdingUp then
					sleep = 5
					--DrawMarker(Config.Marker.Type, storePos.x, storePos.y, storePos.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, false, false, false, false)

					if distance < 2.0 then
						
						startrobbing = k
						--print(startrobbing)
						Citizen.Wait(10000)
					else
						Citizen.Wait(1000)
					end
				end
			end
		end
		

		if holdingUp then
			local storePos = Stores[store].position
			if Vdist(playerPos.x, playerPos.y, playerPos.z, storePos.x, storePos.y, storePos.z) > Config.MaxDistance then
				TriggerServerEvent('esx_holdup:tooFar', store)
			end
		end

		Wait(sleep)
	end
end)

function handleCooldown()
    cooldown = true
    Citizen.CreateThread(function()
        Citizen.Wait(360000)
        cooldown = false
    end)
end



RegisterNetEvent('dl-storob:opendelay')
AddEventHandler('dl-storob:opendelay', function()
	handleCooldown()
end)

RegisterNetEvent('dl-storob:startrobber')
AddEventHandler('dl-storob:startrobber', function()
	TriggerServerEvent('esx_holdup:robberyStarted', startrobbing)
end)


-- LOCKPICK

RegisterCommand("entrarcasa", function()
    TriggerServerEvent("lockpick:openhtml")
end)

RegisterCommand("helpnui", function(source, args, rawCommand)
	SetNuiFocus( false, false )
	SendNUIMessage({
		showPlayerMenu = false
	})

end)

RegisterNetEvent('lockpick:openlockpick')
AddEventHandler('lockpick:openlockpick', function()
	SetNuiFocus( true, true )
	SendNUIMessage({
		showPlayerMenu = true
	})
	onLockpick = true
	TriggerEvent('dl-storob:onAnim')
end)

RegisterNetEvent('dl-storob:onAnim')
AddEventHandler('dl-storob:onAnim', function()
	local lPed = PlayerPedId()
    RequestAnimDict("veh@break_in@0h@p_m_one@")
    while not HasAnimDictLoaded("veh@break_in@0h@p_m_one@") do
        Citizen.Wait(0)
    end
    while onLockpick do
        if not IsEntityPlayingAnim(lPed, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3) then
            TaskPlayAnim(lPed, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 1, 0.0, 0, 0, 0)
            Citizen.Wait(1500)
            ClearPedTasks(PlayerPedId())
        end
        Citizen.Wait(1)
    end
end)

RegisterNUICallback('win', function(data, cb)
	SetNuiFocus( false, false )
	SendNUIMessage({
		showPlayerMenu = false
	})

	onLockpick = false
	local randomnumb = math.random(11111, 99999)
	exports['midp-tasknotify']:SendAlert('success', 'Code: ' .. randomnumb)
	table.insert(robberycode, {code = randomnumb})
	
  	cb('ok')
end)

RegisterNUICallback('lose', function(data, cb)
	SetNuiFocus( false, false )
	SendNUIMessage({
		showPlayerMenu = false
	})

	lose = lose + 1

	if lose == 2 then
		TriggerServerEvent('dl-storob:item', source)
		lose = 0
	end

	onLockpick = false
	exports['midp-tasknotify']:SendAlert('error', 'Gagal')

	cb('ok')
end)

RegisterNetEvent('dl-storob:resultcode')
AddEventHandler('dl-storob:resultcode', function(result)
	--print(result)
	for index, value in ipairs(robberycode) do
		Citizen.Wait(100)
		if tonumber(result) == tonumber(value.code) then
			exports['midp-tasknotify']:SendAlert('success', 'Berhasil')
			table.remove(robberycode, index)

			--TriggerServerEvent('dl-storob:delay')
			TriggerServerEvent('esx_holdup:robberyStarted', startrobbing)
		else
			exports['midp-tasknotify']:SendAlert('error', 'Code tidak valid')
			lose1 = lose1 + 1

			if lose1 == 3 then
				table.remove(robberycode, index)
				exports['midp-tasknotify']:SendAlert('error', 'Harap bobol ulang!')
				lose1 = 0
			end
		end
	end

end)

local nameid = 0

local coordsbobol = {
	{x = 1734.92, y = 6420.8, z = 35.04, h = 330.48}, -- paleto_twentyfourseven
	{x = 1959.32, y = 3748.92, z = 32.36, h = 26.16}, -- sandyshores_twentyfoursever
	{x = -709.68, y = -904.2, z = 19.2, h = 88.52}, -- littleseoul_twentyfourseven
	{x = 378.24, y = 333.36, z = 103.56, h = 340.52}, -- downtown_twentyfourseven
	{x = 2672.84, y = 3286.68, z = 55.24, h = 70.56}, -- desert_twentyfourseven
	{x = -2959.64, y = 387.08, z = 14.04, h = 174.96}, -- ocean_liquor
	{x = 1126.76, y = -980.08, z = 45.4, h = 4.76}, -- rancho_liquor
	{x = -1220.8, y = -916.04, z = 11.32, h = 129.64}, -- sanandreas_liquor
	{x = -1478.92, y = -375.52, z = 39.16, h = 223.24}, -- morningwood_liquor
	{x = -43.44, y = -1748.48, z = 29.44, h = 48.0}, -- grove_ltd 
	{x = 1159.56, y = -314.08, z = 69.2, h = 98.04}, -- mirror_ltd
	{x = 28.16, y = -1339.2, z = 29.48, h = 359.24}, -- strawberry
	{x = 1707.92, y = 4920.44, z = 42.36, h = 333.44}, -- GRAPESEED
	{x = -3047.8, y = 585.6, z = 7.92, h = 105.64}, -- INSENO
	{x = -3250.08, y = 1004.44, z = 12.84, h = 77.44}, -- barbareno
	{x = 546.4, y = 2662.76, z = 42.16, h= 185.88}, -- route 68
}

local coordsrob = {
    {x = 24.485208511353, y = -1344.9290771484, z = 29.49702835083},
    {x = -3041.1188964844, y = 583.79547119141, z = 7.9089317321777},
    {x = -3244.6740722656, y = 1000.203918457, z = 12.830707550049},
    {x = 1728.8583984375, y = 6417.3662109375, z = 35.037231445313},
    {x = 1697.1257324219,   y = 4925.0732421875, z = 42.063667297363},
    {x = 1958.8876953125,  y = 3741.9675292969, z = 32.343753814697},
    {x = 548.18383789063,  y = 2668.8015136719, z = 42.156494140625},
    {x = 2676.6484375,  y = 3281.5773925781, z = 55.241138458252},
    {x = 2554.8095703125,   y = 382.14569091797, z = 108.62294769287},
    {x = 374.39541625977,  y = 328.47357177734,  z = 103.56638336182},
    {x = 1164.71,  y = -322.74,  z = 69.21},
    {x = -46.71,  y = -1757.95,  z = 29.42},
    {x = -706.12,  y = -913.59,  z = 19.22},
}

Citizen.CreateThread(function()
	for k,v in pairs(coordsbobol) do
		nameid = nameid + 1
		exports["ox_target"]:AddBoxZone("coordsbobol" .. nameid, vector3(v.x, v.y, v.z), 1.5, 1.5, {
			name = "coordsbobol" .. nameid,
			heading = v.h,
			debugPoly = false,
			minZ = v.z - 1.0,
			maxZ = v.z + 2.0
		}, {
			options = {
			{
				event = "dl-storob:startedRobbery",
				icon = "fas fa-lock",
				label = "INPUT CODE",
			},
		},
			distance = 1.7,
		})
	end

	for k,v in pairs(coordsrob) do
		nameid = nameid + 1
		exports["ox_target"]:AddBoxZone("coordsrob" .. nameid, vector3(v.x, v.y, v.z), 1.0, 1.0, {
			name = "coordsrob" .. nameid,
			heading = 91,
			debugPoly = false,
			minZ = v.z - 1.0,
			maxZ = v.z + 2.0
		}, {
			options = {
			{
				event = "dl-storob:startedcode",
				icon = "fas fa-lock",
				label = "Bobol",
				item = "lockpick",
			},
		},
			distance = 1.7,
		})
	end
end)

RegisterNetEvent('dl-storob:startedRobbery')
AddEventHandler('dl-storob:startedRobbery', function()
	if not cooldown then
		local input = lib.inputDialog('MASUKKAN CODE', {'CODE: '})

		if input then
			local result = tonumber(input[1])
			TriggerEvent('dl-storob:resultcode', result)
		end
	else
		exports['midp-tasknotify']:SendAlert('error', 'Warung ini telah di rampok')
	end
end)

RegisterNetEvent('dl-storob:startedcode')
AddEventHandler('dl-storob:startedcode', function()
	ESX.TriggerServerCallback('dl-storob:hack', function(quantity)
		if quantity >= 1 then
			TriggerEvent('lockpick:openlockpick')
		else
			exports['midp-tasknotify']:SendAlert('error', 'Membutuhkan Lockpick')
		end
	end, '')
end)