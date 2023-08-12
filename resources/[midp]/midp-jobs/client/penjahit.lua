ESX = nil
local PlayerData = {}
local Blips = {}
local JobBlipsPenjahit = {}
local OnDuty = 0
local onambil = false



CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
        Wait(10)
	end
	
    PlayerData = ESX.GetPlayerData()
	refreshBlipsPenjahit()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
	refreshBlipsPenjahit()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
	deleteBlipsPenjahit()
	refreshBlipsPenjahit()
end)

function deleteBlipsPenjahit()
	if JobBlipsPenjahit[1] ~= nil then
		for i=1, #JobBlipsPenjahit, 1 do
			RemoveBlip(JobBlipsPenjahit[i])
			JobBlipsPenjahit[i] = nil
		end
	end
end

function refreshBlipsPenjahit()
	local zones = {}
	local blipInfo = {}

	if PlayerData.job ~= nil then
		if PlayerData.job and PlayerData.job.name == 'tailor' then
			local blip = AddBlipForCoord(465.6, -750.44, 27.36)
			SetBlipSprite  (blip, 366)
			SetBlipDisplay (blip, 4)
			SetBlipScale   (blip, 0.9)
			SetBlipColour  (blip, 4)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Penjualan Pakaian')
			EndTextCommandSetBlipName(blip)
			table.insert(JobBlipsPenjahit, blip)

			local blip1 = AddBlipForCoord(1961.04, 5185.08, 47.96)
			SetBlipSprite  (blip1, 366)
			SetBlipDisplay (blip1, 4)
			SetBlipScale   (blip1, 0.9)
			SetBlipColour  (blip1, 4)
			SetBlipAsShortRange(blip1, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Lokasi Ambil Benang')
			EndTextCommandSetBlipName(blip1)
			table.insert(JobBlipsPenjahit, blip1)

			local blip2 = AddBlipForCoord(713.32, -969.72, 30.4)
			SetBlipSprite  (blip2, 366)
			SetBlipDisplay (blip2, 4)
			SetBlipScale   (blip2, 0.9)
			SetBlipColour  (blip2, 4)
			SetBlipAsShortRange(blip2, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Lokasi Prosess Penjahit')
			EndTextCommandSetBlipName(blip2)
			table.insert(JobBlipsPenjahit, blip2)
		end
	end
end

local pakaianpenjahit = {
	{x = 705.48, y = -960.36, z = 30.4, h = 357.4}
}


local ambilwool = {
	{x = 1961.04, y = 5185.08, z = 47.96, h = 95.16}
}

local penjahitcrafting = {
	{x = 713.32, y = -969.72, z = 30.4, h = 273.84},
	{x = 716.52, y = -961.68, z = 30.4, h = 357.2},
}

local jualpakaian = {
	{x = 465.52, y = -750.4, z = 27.36, h = 272.52}
}

local spawnmobiljahit = {
	{x = 739.12, y = -970.04, z = 24.64, h = 90.52}
}

local nameid = 0

CreateThread(function()
	for k,v in pairs(pakaianpenjahit) do
		exports["ox_target"]:AddBoxZone("pakaianpenjahit", vector3(v.x, v.y, v.z), 1.2, 1.5, {
		  name = "pakaianpenjahit",
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "midp-jobs:pakaianpenjahit",
			icon = "fas fa-tshirt",
			label = "Ganti Pakaian",
			job = {
				["tailor"] = 0,
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

	for k,v in pairs(ambilwool) do
	  exports["ox_target"]:AddBoxZone("Wool", vector3(v.x, v.y, v.z), 1.2, 1.5, {
		name = "Wool",
		heading = v.h,
		debugPoly = false,
		minZ = v.z - 1.0,
		maxZ = v.z + 2.0
	  }, {
		options = {
		{
		  event = "midp-jobs:ambilwool",
		  icon = "fas fa-box-open",
		  label = "Mengambil Benang",
		  job = {
			["tailor"] = 0,
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

	for k,v in pairs(penjahitcrafting) do
		nameid = nameid + 1
		exports["ox_target"]:AddBoxZone("Wool".. nameid, vector3(v.x, v.y, v.z), 5.0, 5.0, {
		  name = "Wool" .. nameid,
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "midp-jobs:jahitPenjahit",
			icon = "fas fa-box-open",
			label = "Menjahit",
			job = {
				["tailor"] = 0,
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

	for k,v in pairs(jualpakaian) do
		exports["ox_target"]:AddBoxZone("jualpakaian", vector3(v.x, v.y, v.z), 1.2, 4.5, {
		  name = "jualpakaian",
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "midp-jobs:jualpakaian",
			icon = "fas fa-tshirt",
			label = "Jual pakaian",
			job = {
				["tailor"] = 0,
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

	for k,v in pairs(spawnmobiljahit) do
		exports["ox_target"]:AddBoxZone("mobiljahit1", vector3(v.x, v.y, v.z), 2.0, 2.5, {
		  name = "mobiljahit1",
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "midp-jobs:spawnmobiljahit",
			icon = "fas fa-car",
			label = "Ambil Van",
			job = {
				["tailor"] = 0,
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
			event = "midp-jobs:hapusmobil",
			icon = "fas fa-sign-out-alt",
			label = "Simpan Van",
			job = {
				["tailor"] = 0,
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

-- EVENT

RegisterNetEvent('midp-jobs:ambilwool')
AddEventHandler('midp-jobs:ambilwool', function()
	if OnDuty == 0 then
		exports['midp-tasknotify']:DoHudText('error', 'Ganti Baju Terlebih Dahulu')
	else
    ESX.TriggerServerCallback('midp-jobs:canPickUp', function(canPickUp)
        if canPickUp then
            if not sibuk then
            sibuk = true
            exports.ox_inventory:Progress({
                duration = 5000,
                label = 'Mengambil Benang...',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    move = false,
                    car = true,
                    combat = true,
                    mouse = false
                },
				anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
            }, function(cancel)
                if not cancel then
                    TriggerServerEvent('midp-core:NambahItems', 'wool', 4)
                    sibuk = false
                else
                    sibuk = false
                    exports['midp-tasknotify']:DoHudText('error', 'Proses Dibatalkan!')
                end
            end)
        end 
            else
            exports['midp-tasknotify']:DoHudText('error', 'Melebihi Batas!')
        end
    end, 'wool')
end
end)

-- PENJAHIT

RegisterNetEvent('midp-jobs:jahitPenjahit')
AddEventHandler('midp-jobs:jahitPenjahit', function()
	if OnDuty == 0 then
		exports['midp-tasknotify']:DoHudText('error', 'Ganti Baju Terlebih Dahulu')
	else
		TriggerEvent('midp-context:sendMenu', {
			{
			id = 1,
			header = "Alat Jahit",
			txt = ""
			},
			{
			id = 2,
			header = "2 Kain",
			txt = "Bahan: 4 Benang",
			params = {
				event = "midp-core:alanMulai",
				args = {type = 'fabric'}
			}
			},
			{
			id = 3,
			header = "1 Pakaian",
			txt = "Bahan: 4 Kain",
			params = {
				event = "midp-core:alanMulai",
				args = {type = 'clothe'}
			}
			},
		})
		TriggerEvent('midp-context:sendMenu', {
			{
				id = 0,
				header = "⬅ Kembali",
				txt = "",
				params = {
					event = " "
				}
			},
		})
	end
end)

RegisterNetEvent('midp-jobs:jualpakaian')
AddEventHandler('midp-jobs:jualpakaian', function()
	if OnDuty == 0 then
		exports['midp-tasknotify']:DoHudText('error', 'Ganti Baju Terlebih Dahulu')
	else
    if not sibuk then
        sibuk = true
        exports.ox_inventory:Progress({
            duration = 5000,
            label = 'Menjual Pakaian...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                combat = true,
                mouse = false
            },
			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
        }, function(cancel)
            if not cancel then
                TriggerServerEvent('midp-jobs:JualBaju', irham.t())
                sibuk = false
            else
                sibuk = false
                exports['midp-tasknotify']:DoHudText('error', 'Proses Dibatalkan!')
            end
        end)
    end 
end
end)

RegisterNetEvent('midp-jobs:spawnmobiljahit')
AddEventHandler('midp-jobs:spawnmobiljahit', function()
	if OnDuty == 0 then
		exports['midp-tasknotify']:DoHudText('error', 'Ganti Baju Terlebih Dahulu')
	else
		ESX.Game.SpawnVehicle('youga', {x = 745.32, y = -970.32, z = 24.64}, 272.2, function(callback_vehicle)
			TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
			--table.insert(spawnedVehicles, vehicle)
			exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
			--TriggerEvent('ir-badside:maxveh', callback_vehicle)
			exports["dl-bensin"]:SetFuel(callback_vehicle, 100)
		end)
	end
end)

RegisterNetEvent('midp-jobs:pakaianpenjahit')
AddEventHandler('midp-jobs:pakaianpenjahit', function()
	OnDuty = OnDuty + 1
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
		else
			TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
		end
	end)
end)