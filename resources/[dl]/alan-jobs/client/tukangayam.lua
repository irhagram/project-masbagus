ESX = nil
local PlayerData = {}
local Blips = {}
local JobBlipsAyam = {}
local OnDutyAayam = 0
local onambil = false

local spawnedVehicles = {}


CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	refreshBlipsAyam()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
	refreshBlipsAyam()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
	deleteBlipsAyam()
	refreshBlipsAyam()
end)

local animal = {
	`a_c_hen`,
}

function deleteBlipsAyam()
	if JobBlipsAyam[1] ~= nil then
		for i=1, #JobBlipsAyam, 1 do
			RemoveBlip(JobBlipsAyam[i])
			JobBlipsAyam[i] = nil
		end
	end
end

function refreshBlipsAyam()
	local zones = {}
	local blipInfo = {}

	if PlayerData.job ~= nil then
		if PlayerData.job and PlayerData.job.name == 'slaughterer' then
			local blip = AddBlipForCoord(144.56, -1480.6, 29.36)
			SetBlipSprite  (blip, 484)
			SetBlipDisplay (blip, 4)
			SetBlipScale   (blip, 0.9)
			SetBlipColour  (blip, 5)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Penjualan Ayam')
			EndTextCommandSetBlipName(blip)
			table.insert(JobBlipsAyam, blip)

			local blip = AddBlipForCoord(2310.52, 4884.8, 41.8)
			SetBlipSprite  (blip, 484)
			SetBlipDisplay (blip, 4)
			SetBlipScale   (blip, 0.9)
			SetBlipColour  (blip, 5)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Lokasi Ayam')
			EndTextCommandSetBlipName(blip)
			table.insert(JobBlipsAyam, blip)
		end
	end
end

local pakaianayam = {
	{x = -1070.01, y = -2002.61, z = 15.79, h = 45}
}

local ayamproses = {
	{x = -97.6, y = 6205.65, z = 31.03, h = 45},
}

local ayamkemas = {
	{x = -101.32, y = 6209.48, z = 31.04, h = 45.92},
}

local jualayam = {
	{x = 144.4, y = -1480.32, z = 29.36, h = 316}
}

local mobilayam = {
	{x = -1057.04, y = -2004.16, z = 13.16, h = 314.12}
}

local nameid = 0

CreateThread(function()
	for k,v in pairs(pakaianayam) do
		exports["ox_target"]:AddBoxZone("pakaianayam1", vector3(v.x, v.y, v.z), 1.2, 1.5, {
		  name = "pakaianayam1",
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "alan-jobs:ondutyayam",
			icon = "fas fa-tshirt",
			label = "Ganti Pakaian",
			job = {
                ["slaughterer"] = 0,
                ["gang"] = 0,
                ["mafia"] = 0,
                ["cartel"] = 0,
                ["biker"] = 0,
                ["yakuza"] = 0,
                ["ormas"] = 0,
				["badside7"] = 0,
				["badside8"] = 0,
				["badside9"] = 0,
				["badside10"] = 0,
				["badside11"] = 0,
				["badside12"] = 0,
				["badside13"] = 0,
				["badside14"] = 0,
            },
		  },
		  {
			event = "alan-jobs:spawnmobilayam",
			icon = "fas fa-car",
			label = "Ambil Truk",
			job = {
                ["slaughterer"] = 0,
                ["gang"] = 0,
                ["mafia"] = 0,
                ["cartel"] = 0,
                ["biker"] = 0,
                ["yakuza"] = 0,
                ["ormas"] = 0,
				["badside7"] = 0,
				["badside8"] = 0,
				["badside9"] = 0,
				["badside10"] = 0,
				["badside11"] = 0,
				["badside12"] = 0,
				["badside13"] = 0,
				["badside14"] = 0,
            },
		  },
		  {
			event = "alan-jobs:hapusmobil",
			icon = "fas fa-sign-out-alt",
			label = "Simpan Truk",
			job = {
                ["slaughterer"] = 0,
                ["gang"] = 0,
                ["mafia"] = 0,
                ["cartel"] = 0,
                ["biker"] = 0,
                ["yakuza"] = 0,
                ["ormas"] = 0,
				["badside7"] = 0,
				["badside8"] = 0,
				["badside9"] = 0,
				["badside10"] = 0,
				["badside11"] = 0,
				["badside12"] = 0,
				["badside13"] = 0,
				["badside14"] = 0,
            },
		  },
		  },
		  distance = 2.0
		})
	end

	for k,v in pairs(ayamproses) do
		nameid = nameid + 1
		exports["ox_target"]:AddBoxZone("ayamproses".. nameid, vector3(v.x, v.y, v.z), 3.2, 8.0, {
		  name = "ayamproses" .. nameid,
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "alan-jobs:prosesAyam",
			icon = "fas fa-box-open",
			label = "Potong Ayam",
			job = {
                ["slaughterer"] = 0,
                ["gang"] = 0,
                ["mafia"] = 0,
                ["cartel"] = 0,
                ["biker"] = 0,
                ["yakuza"] = 0,
                ["ormas"] = 0,
				["badside7"] = 0,
				["badside8"] = 0,
				["badside9"] = 0,
				["badside10"] = 0,
				["badside11"] = 0,
				["badside12"] = 0,
				["badside13"] = 0,
				["badside14"] = 0,
            },
		  },
		  },
		  distance = 2.0
		})
	end

	for k,v in pairs(jualayam) do
		exports["ox_target"]:AddBoxZone("jualayam", vector3(v.x, v.y, v.z), 1.2, 2.5, {
		  name = "jualayam",
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "alan-jobs:jualayam",
			icon = "fas fa-drumstick-bite",
			label = "Jual Ayam",
			job = {
                ["slaughterer"] = 0,
                ["gang"] = 0,
                ["mafia"] = 0,
                ["cartel"] = 0,
                ["biker"] = 0,
                ["yakuza"] = 0,
                ["ormas"] = 0,
				["badside7"] = 0,
				["badside8"] = 0,
				["badside9"] = 0,
				["badside10"] = 0,
				["badside11"] = 0,
				["badside12"] = 0,
				["badside13"] = 0,
				["badside14"] = 0,
            },
		  },
		  },
		  distance = 2.0
		})
	end

	for k,v in pairs(ayamkemas) do
		exports["ox_target"]:AddBoxZone("ayamkemas", vector3(v.x, v.y, v.z), 1.2, 2.5, {
		  name = "ayamkemas",
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "alan-jobs:kemasayam",
			icon = "fas fa-drumstick-bite",
			label = "Kemas Ayam",
			job = {
                ["slaughterer"] = 0,
                ["gang"] = 0,
                ["mafia"] = 0,
                ["cartel"] = 0,
                ["biker"] = 0,
                ["yakuza"] = 0,
                ["ormas"] = 0,
				["badside7"] = 0,
				["badside8"] = 0,
				["badside9"] = 0,
				["badside10"] = 0,
				["badside11"] = 0,
				["badside12"] = 0,
				["badside13"] = 0,
				["badside14"] = 0,
            },
		  },
		  },
		  distance = 2.0
		})
	end
end)

local AnimalsInSession = {}

-- FUNCTION
local maxPed = 0
local count = 0


RegisterCommand('spawnayamn', function()
	createPedAyam()
end)

function createPedAyam()
	reqModelDrug('a_c_hen')

	local x = 2296.32 + math.random(1, 10)
	local y = 4927.44 + math.random(1, 10)
	local z = 41.4

	count = count + 1

	if count < 15 then
		local p2 = CreatePed(5, GetHashKey('a_c_hen'), x, y, z, 0.0, false, true)
		SetEntityAsMissionEntity(p2, true, true)

		table.insert(AnimalsInSession, {id = p2, x = x, y = y, z = z})
	end

	--[[if count < 15 then
		local p2 = CreatePed(5, GetHashKey('a_c_hen'), x, y, z, 0.0, false, true)
		TaskReactAndFleePed(p2, PlayerPedId())

		table.insert(AnimalsInSession, {id = p2, x = x, y = y, z = z})
	end]]
end

function reqModelDrug(ped)
	RequestModel(ped)
	while not HasModelLoaded(ped) do
        RequestModel(ped)
        Wait(100)
    end
end

exports['ox_target']:AddTargetModel(animal, {
	options = {
		{
			event = "alan-jobs:takehewan",
			icon = "fas fa-cut",
			label = "Ambil",
			job = "slaughterer",
		},
	},
	distance = 1.5
})

RegisterNetEvent("alan-jobs:takehewan")
AddEventHandler("alan-jobs:takehewan", function()
	local dead = false
	local plyCoords = GetEntityCoords(PlayerPedId())
	local closestAnimal, closestDistance = ESX.Game.GetClosestPed(plyCoords)
	local animal = `a_c_hen`

	for index, value in ipairs(AnimalsInSession) do
		if DoesEntityExist(value.id) then
			local AnimalCoords = GetEntityCoords(value.id)
			local PlyCoords = GetEntityCoords(PlayerPedId())
			local AnimalHealth = GetEntityHealth(value.id)
			
			local PlyToAnimal = GetDistanceBetweenCoords(PlyCoords, AnimalCoords, true)

			if AnimalHealth <= 0 and PlyToAnimal < 1.5 then
				if OnDutyAayam > 0 then
					if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_MACHETE')  then
						if DoesEntityExist(value.id) then
							table.remove(AnimalsInSession, index)
							SlaughterAnimal(value.id)
						end
					else
						exports['alan-tasknotify']:DoHudText('error', 'Membutuhkan Parang')
					end
				end
			end
		end
	end
end)

function SlaughterAnimal(AnimalId)

	ESX.TriggerServerCallback('alan-jobs:canPickUp', function(canPickUp)
		if canPickUp then
			TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )

			exports.ox_inventory:Progress({
				duration = 2000,
				label = 'Mengambil Ayam',
				useWhileDead = false,
				canCancel = false,
				disable = {
					move = true,
					car = true,
					combat = true,
					mouse = false
				},
				anim = { dict = 'anim@gangops@facility@servers@bodysearch@', clip = 'player_search' },
			}, function(success)
				if onStart then
				end
				if onComplete then
				end
			end)

			ClearPedTasksImmediately(PlayerPedId())
			DeleteEntity(AnimalId)
			TriggerServerEvent('alan-core:NambahItems', 'alive_chicken', 4)
			createPedAyam()
			count = count - 1
		else
			exports['alan-tasknotify']:DoHudText('error', 'Melebihi Batas!')
		end
	end, 'alive_chicken')
end

-- EVENT
RegisterNetEvent('alan-jobs:ondutyayam')
AddEventHandler('alan-jobs:ondutyayam', function()
	OnDutyAayam = OnDutyAayam + 1
	print('berhasil')
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		--print(skin)
		
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
		else
			TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
		end
		if OnDutyAayam == 1 then
			createPedAyam()
			createPedAyam()
			createPedAyam()
			createPedAyam()
			createPedAyam()
		end
	end)
end)

RegisterNetEvent('alan-jobs:getmachete')
AddEventHandler('alan-jobs:getmachete', function()
	TriggerServerEvent('alan-jobs:machete')

end)

RegisterNetEvent('alan-jobs:tangkapayam')
AddEventHandler('alan-jobs:tangkapayam', function()
	if OnDutyAayam == 0 then
		exports['alan-tasknotify']:DoHudText('error', 'Ganti Baju Terlebih Dahulu')
	else
		if onambil then
		else
			ESX.TriggerServerCallback('alan-jobs:canPickUp', function(canPickUp)
				if canPickUp then
					exports.ox_inventory:Progress({
						duration = 2000,
						label = 'Menangkap Ayam',
						useWhileDead = false,
						canCancel = false,
						disable = {
							move = true,
							car = true,
							combat = true,
							mouse = false
						},
						anim = { dict = 'mini@repair', clip = 'fixing_a_ped' }, 
					}, function(onComplete)
						if onComplete then

						end
					end)
					onambil = true
					Wait(5000)
					onambil = false
					TriggerServerEvent('alan-core:NambahItems', 'alive_chicken', 4)
				else
					exports['alan-tasknotify']:DoHudText('error', 'Melebihi Batas')
				end
			end, 'alive_chicken')
		end
	end
end)

-- PENJAHIT

RegisterNetEvent('alan-jobs:prosesAyam')
AddEventHandler('alan-jobs:prosesAyam', function()
	if OnDutyAayam == 0 then
		exports['alan-tasknotify']:DoHudText('error', 'Ganti Baju Terlebih Dahulu')
	else
		ESX.TriggerServerCallback('alan-jobs:cekItem', function(items)
			if items >= 4 then
				if not sibuk then
				sibuk = true
				TriggerServerEvent('alan-core:delItem', 'alive_chicken', 4)
				exports.ox_inventory:Progress({
					duration = 6000,
					label = 'Memotong Ayam...',
					useWhileDead = false,
					canCancel = false,
					disable = {
						move = true,
						car = true,
						combat = true,
						mouse = false
					},
					anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
				})
				TriggerServerEvent('alan-core:NambahItems', 'slaughtered_chicken', 8)
				sibuk = false
			end 
		else
			exports['alan-tasknotify']:DoHudText('error', 'Tidak Memiliki Cukup Ayam!')
			end
		end, 'alive_chicken')
	end
end)

RegisterNetEvent('alan-jobs:kemasayam')
AddEventHandler('alan-jobs:kemasayam', function()
	if OnDutyAayam == 0 then
		exports['alan-tasknotify']:DoHudText('error', 'Ganti Baju Terlebih Dahulu')
	else
		ESX.TriggerServerCallback('alan-jobs:cekItem', function(items)
			if items >= 8 then
				if not sibuk then
				sibuk = true
				TriggerServerEvent('alan-core:delItem', 'slaughtered_chicken', 8)
				exports.ox_inventory:Progress({
					duration = 8000,
					label = 'Mengemas Ayam...',
					useWhileDead = false,
					canCancel = false,
					disable = {
						move = true,
						car = true,
						combat = true,
						mouse = false
					},
					anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
				})
				TriggerServerEvent('alan-core:NambahItems', 'packaged_chicken', 10)
				sibuk = false
			end 
		else
			exports['alan-tasknotify']:DoHudText('error', 'Tidak Memiliki Cukup Ayam Potong!')
			end
		end, 'slaughtered_chicken')
	end
end)

RegisterNetEvent('alan-jobs:jualayam')
AddEventHandler('alan-jobs:jualayam', function()
	if OnDutyAayam == 0 then
		exports['alan-tasknotify']:DoHudText('error', 'Ganti Baju Terlebih Dahulu')
	else
		if onambil then
		else
			exports.ox_inventory:Progress({
				duration = 5000,
				label = 'Menjual Ayam',
				useWhileDead = false,
				canCancel = false,
				disable = {
					move = true,
					car = true,
					combat = true,
					mouse = false
				},
				anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },  
			}, function(onComplete)
				if onComplete then

				end
			end)
			onambil = true
			Wait(500)
			onambil = false
			TriggerServerEvent('alan-jobs:jualAyam', irham.t())
		end
	end
end)

RegisterNetEvent('alan-jobs:spawnmobilayam')
AddEventHandler('alan-jobs:spawnmobilayam', function()
	if OnDutyAayam == 0 then
		exports['alan-tasknotify']:DoHudText('error', 'Ganti Baju Terlebih Dahulu')
	else
		ESX.Game.SpawnVehicle('canter', {x = -1062.72, y = -2019.01, z = 13.16}, 133.84, function(callback_vehicle)
			TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
			exports['alan-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
			exports["dl-bensin"]:SetFuel(callback_vehicle, 100)
		end)
	end
end)

RegisterNetEvent('alan-jobs:hapusmobil')
AddEventHandler('alan-jobs:hapusmobil', function()
	local ped = PlayerPedId()
	local vehicle = GetPlayersLastVehicle()
	local vehicleCoords = GetEntityCoords(vehicle)

	if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(ped), vehicleCoords) < 10.0 then
		ESX.Game.DeleteVehicle(vehicle)
	end
end)

CreateThread(function()
	LoadAnimDict('amb@medic@standing@kneel@base')
	LoadAnimDict('anim@gangops@facility@servers@bodysearch@')
end)

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(10)
    end    
end