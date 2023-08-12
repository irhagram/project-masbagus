local PlayerData = {}
local Blips = {}
local JobBlipsMiner = {}
local onambil = false

local OnDuty = 0

CreateThread(function()


	while ESX.GetPlayerData().job == nil do
        Wait(10)
	end
	
    PlayerData = ESX.GetPlayerData()
	refreshBlipsTambang()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
	refreshBlipsTambang()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
	deleteBlipsTambang()
	refreshBlipsTambang()
end)

function deleteBlipsTambang()
	if JobBlipsMiner[1] ~= nil then
		for i=1, #JobBlipsMiner, 1 do
			RemoveBlip(JobBlipsMiner[i])
			JobBlipsMiner[i] = nil
		end
	end
end

function refreshBlipsTambang()
	local zones = {}
	local blipInfo = {}

	if PlayerData.job ~= nil then
		if PlayerData.job and PlayerData.job.name == 'miner' then
			local blip = AddBlipForCoord(2952.24, 2769.44, 39.08)
			SetBlipSprite  (blip, 318)
			SetBlipDisplay (blip, 4)
			SetBlipScale   (blip, 0.9)
			SetBlipColour  (blip, 5)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Lokasi Batu')
			EndTextCommandSetBlipName(blip)
			table.insert(JobBlipsMiner, blip)

			local blip1 = AddBlipForCoord(2927.2, 2791.6, 40.4)
			SetBlipSprite  (blip1, 318)
			SetBlipDisplay (blip1, 4)
			SetBlipScale   (blip1, 0.9)
			SetBlipColour  (blip1, 5)
			SetBlipAsShortRange(blip1, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Lokasi Batu')
			EndTextCommandSetBlipName(blip1)
			table.insert(JobBlipsMiner, blip1)

			local blip2 = AddBlipForCoord(1610.79, 3873.94, 32.31)
			SetBlipSprite  (blip2, 318)
			SetBlipDisplay (blip2, 4)
			SetBlipScale   (blip2, 0.9)
			SetBlipColour  (blip2, 5)
			SetBlipAsShortRange(blip2, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Pencucian Batu')
			EndTextCommandSetBlipName(blip2)
			table.insert(JobBlipsMiner, blip2)

			local blip3 = AddBlipForCoord(1085.64, -2001.8, 31.4)
			SetBlipSprite  (blip3, 318)
			SetBlipDisplay (blip3, 4)
			SetBlipScale   (blip3, 0.9)
			SetBlipColour  (blip3, 5)
			SetBlipAsShortRange(blip3, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Peleburan Batu')
			EndTextCommandSetBlipName(blip3)
			table.insert(JobBlipsMiner, blip3)

			local blip4 = AddBlipForCoord(1240.42, -3288.75, 5.53)
			SetBlipSprite  (blip4, 318)
			SetBlipDisplay (blip4, 4)
			SetBlipScale   (blip4, 0.9)
			SetBlipColour  (blip4, 5)
			SetBlipAsShortRange(blip4, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Jual Hasil Tambang')
			EndTextCommandSetBlipName(blip4)
			table.insert(JobBlipsMiner, blip4)
		end
	end
end

local lokasitambang = {
	{x = 2952.52, y = 2766.6, z = 39.56, h = 189.72}, -- lok 1
	{x = 2927.28, y = 2791.48, z = 40.36, h = 328.36}, -- lok 2
}

local prosestambang = {
	{x = 1085.2, y = -2002.32, z = 31.4, h = 213.64}
}

local jualhasitambang = {
	{x = 1240.42, y = -3288.75, z = 5.53, h = 7.12},
}

local spawnmobiltambang = {
	{x = 892.36, y = -2171.92, z = 32.28, h = 353.88}
}

local nameid = 0

CreateThread(function()
	for k,v in pairs(lokasitambang) do
		nameid = nameid + 1
		exports["ox_target"]:AddBoxZone("lokasitambang" .. nameid, vector3(v.x, v.y, v.z), 4.0, 7.0, {
			name = "lokasitambang" .. nameid,
			heading = v.h,
			debugPoly = false,
			minZ = v.z - 1.0,
			maxZ = v.z + 2.0
		}, {
			options = {
			{
				event = "midp-jobs:ambilbatu",
				icon = "fas fa-tools",
				label = "Ambil Batu",
				job = {
					["miner"] = 0,
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

	for k,v in pairs(jualhasitambang) do
		exports["ox_target"]:AddBoxZone("jualhasitambang", vector3(v.x, v.y, v.z), 5.0, 5.0, {
		  name = "jualhasitambang",
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "midp-jobs:jualcopper",
			icon = "fas fa-gem",
			label = "Tembaga",
			job = {
				["miner"] = 0,
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
			event = "midp-jobs:jualiron",
			icon = "fas fa-gem",
			label = "Besi",
			job = {
				["miner"] = 0,
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
			event = "midp-jobs:jualgold",
			icon = "fas fa-gem",
			label = "Emas",
			job = {
				["miner"] = 0,
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
			event = "midp-jobs:jualdiamond",
			icon = "fas fa-gem",
			label = "Diamond",
			job = {
				["miner"] = 0,
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

	for k,v in pairs(prosestambang) do
		exports["ox_target"]:AddBoxZone("prosestambang", vector3(v.x, v.y, v.z), 2.0, 4.5, {
		  name = "prosestambang",
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "midp-jobs:prosestambang",
			icon = "fas fa-box-open",
			label = "Peleburan",
			job = {
				["miner"] = 0,
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

	for k,v in pairs(spawnmobiltambang) do
		exports["ox_target"]:AddBoxZone("mobiljahit", vector3(v.x, v.y, v.z), 1.2, 2.5, {
		  name = "mobiljahit",
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
			{
				event = "midp-jobs:pakaiantambang",
				icon = "fas fa-tshirt",
				label = "Ganti Pakaian",
				job = {
					["miner"] = 0,
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
			event = "midp-jobs:spawnmobiltambang",
			icon = "fas fa-car",
			label = "Ambil Truk",
			job = {
				["miner"] = 0,
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
			label = "Simpan Truk",
			job = {
				["miner"] = 0,
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

RegisterNetEvent('midp-jobs:ambilbatu')
AddEventHandler('midp-jobs:ambilbatu', function()
	if OnDuty == 0 then
		exports['midp-tasknotify']:DoHudText('error', 'Ganti Baju Terlebih Dahulu')
	else
		ESX.TriggerServerCallback('midp-jobs:canPickUp', function(canPickUp)
			if canPickUp then
				if not sibuk then
				sibuk = true
				exports.ox_inventory:Progress({
					duration = 5000,
					label = 'Mengambil Batu',
					useWhileDead = false,
					canCancel = false,
					disable = {
						move = true,
						car = true,
						combat = true,
						mouse = false
					},
					anim = { dict = 'amb@world_human_const_drill@male@drill@base', clip = 'base' },
				}, function(onComplete)
					if onComplete then

					end
				end)
				TriggerServerEvent('midp-core:NambahItems', 'stone', 1)
				sibuk = false
			end
		else
			exports['midp-tasknotify']:DoHudText('error', 'Melebihi Batas!')
			end
		end, 'stone')
	end
end)

RegisterNetEvent('midp-jobs:prosestambang')
AddEventHandler('midp-jobs:prosestambang', function()
	if OnDuty == 0 then
		exports['midp-tasknotify']:DoHudText('error', 'Ganti Baju Terlebih Dahulu')
	else
		ESX.TriggerServerCallback('midp-jobs:cekItem', function(items)
			if items >= 2 then
				if not sibuk then
				sibuk = true
				exports.ox_inventory:Progress({
					duration = 10000,
					label = 'Melebur Batu...',
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
				TriggerServerEvent('midp-jobs:lebur')
				sibuk = false
			end 
		else
			exports['midp-tasknotify']:DoHudText('error', 'Tidak Memiliki Cukup Batu Bersih!')
			end
		end, 'washed_stone')
	end
end)

CreateThread(function()
    exports["midp-nui"]:AddBoxZone("cucibatu", vector3(1610.79, 3873.94, 32.31), 25, 25, {
        name="cucibatu",
		heading = 335,
		debugPoly = false,
		minZ = 29.64,
		maxZ = 33.64
    })

    RegisterNetEvent('polyzonecuy:enter')
    AddEventHandler('polyzonecuy:enter', function(name)
		local ped = PlayerPedId()
		if OnDuty == 0 then
		elseif IsPedInAnyVehicle(ped) or IsPedDeadOrDying(ped) then
			exports['midp-tasknotify']:DoHudText('error', 'Harap Turun Dari Kendaraan')
		else
        if name == 'cucibatu' then
            AreaCuciB = true
            CreateThread(function()
                while true do
                        if AreaCuciB then
                            exports['midp-tasknotify']:Open('[E] Cuci Batu', 'darkblue', 'right')
                            if IsControlJustReleased(1, 51) then
								ESX.TriggerServerCallback('midp-jobs:cekItem', function(items)
									if items >= 1 then
										if not sibuk then
										sibuk = true
										TriggerServerEvent('midp-core:delItem', 'stone', 1)
										exports.ox_inventory:Progress({
											duration = 5000,
											label = 'Mencuci Batu...',
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
										TriggerServerEvent('midp-core:NambahItems', 'washed_stone', 1)
										sibuk = false
									end 
								else
									exports['midp-tasknotify']:DoHudText('error', 'Tidak Memiliki Cukup Batu!')
									end
								end, 'stone')
                            end
                        else
                            break
                        end
                    Wait(0)
                end
            end)
        end
	end
    end)

    RegisterNetEvent('polyzonecuy:exit')
    AddEventHandler('polyzonecuy:exit', function(name)
            if name == 'cucibatu' then
                AreaCuciB = false
                exports['midp-tasknotify']:Close()
            end
    end)
end)

RegisterNetEvent('midp-jobs:spawnmobiltambang')
AddEventHandler('midp-jobs:spawnmobiltambang', function()
	if OnDuty == 0 then
		exports['midp-tasknotify']:DoHudText('error', 'Ganti Baju Terlebih Dahulu')
	else
		ESX.Game.SpawnVehicle('hino', {x = 880.04, y = -2188.44, z = 30.52}, 86.8, function(callback_vehicle)
			TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
			exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
			exports["dl-bensin"]:SetFuel(callback_vehicle, 100)
		end)
	end
end)

RegisterNetEvent('midp-jobs:jualcopper')
AddEventHandler('midp-jobs:jualcopper', function()
	if onambil then
	else
		exports.ox_inventory:Progress({
			duration = 5000,
			label = 'Menjual Tembaga',
			useWhileDead = false,
			canCancel = false,
			disable = {
				move = true,
				car = true,
				combat = true,
				mouse = false
			},
			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			DisableControls = {
				Mouse = false,
				Player = true,
				Vehicle = true,
				Combat = true,
			},  
		}, function(onComplete)
			if onComplete then

			end
		end)
		onambil = true
		Wait(500)
		onambil = false
		TriggerServerEvent('midp-jobs:jualTembaga', irham.t())
	end
end)

RegisterNetEvent('midp-jobs:jualiron')
AddEventHandler('midp-jobs:jualiron', function()
	if onambil then
	else
		exports.ox_inventory:Progress({
			duration = 5000,
			label = 'Menjual Besi',
			useWhileDead = false,
			canCancel = false,
			disable = {
				move = true,
				car = true,
				combat = true,
				mouse = false
			},
			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			DisableControls = {
				Mouse = false,
				Player = true,
				Vehicle = true,
				Combat = true,
			},  
		}, function(onComplete)
			if onComplete then

			end
		end)
		onambil = true
		Wait(500)
		onambil = false
		TriggerServerEvent('midp-jobs:jualIron', irham.t())
	end
end)

RegisterNetEvent('midp-jobs:jualgold')
AddEventHandler('midp-jobs:jualgold', function()
	if onambil then
	else
		exports.ox_inventory:Progress({
			duration = 5000,
			label = 'Menjual Emas',
			useWhileDead = false,
			canCancel = false,
			disable = {
				move = true,
				car = true,
				combat = true,
				mouse = false
			},
			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			DisableControls = {
				Mouse = false,
				Player = true,
				Vehicle = true,
				Combat = true,
			},  
		}, function(onComplete)
			if onComplete then

			end
		end)
		onambil = true
		Wait(500)
		onambil = false
		TriggerServerEvent('midp-jobs:jualGold', irham.t())
	end
end)

RegisterNetEvent('midp-jobs:jualdiamond')
AddEventHandler('midp-jobs:jualdiamond', function()
	if onambil then
	else
		exports.ox_inventory:Progress({
			duration = 5000,
			label = 'Menjual Diamond',
			useWhileDead = false,
			canCancel = false,
			disable = {
				move = true,
				car = true,
				combat = true,
				mouse = false
			},
			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			DisableControls = {
				Mouse = false,
				Player = true,
				Vehicle = true,
				Combat = true,
			},    
		}, function(onComplete)
			if onComplete then

			end
		end)
		onambil = true
		Wait(5000)
		onambil = false
		TriggerServerEvent('midp-jobs:jualDiamond', irham.t())
	end
end)

RegisterNetEvent('midp-jobs:pakaiantambang')
AddEventHandler('midp-jobs:pakaiantambang', function()
	OnDuty = OnDuty + 1
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
		else
			TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
		end
	end)
end)