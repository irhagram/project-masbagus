ESX = nil
local Foundry = false
local sibuk = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)

RegisterCommand('ck', function ()
    workclothes = true
    BlipKerjaa()
end)

local blipjob = {}
local chickendata = {}
local chickenspawned = false
local IsNearChicken = false
local IsPromptStartChicken = false

----- Tahap Kerja Pertama(gantibaju) --------

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Wait(5)
	end
end

RegisterNetEvent('midp-jobs:changeclothes')
AddEventHandler('midp-jobs:changeclothes', function()
	local playerPed = PlayerPedId()
	local grade = grades

	local elements = {
		{label = ('Civillian Clothes'),   value   = 'baju_normal'},
		{label = ('Work Clothes'),   uniform = 'work_clothes'}
	}

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'disnaker_loker', {
		title    = ('Ganti Pakaian'),
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)
		if data.current.value == 'baju_normal' then
			menu.close()
            workclothes = false
            --HapusBlipKerja()
            --BlipKerjaa()
            StopAnimTask(playerPed, 'clothingtie', 'try_tie_positive_a', 1.0)
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
		elseif data.current.uniform then
            menu.close()
            workclothes = true
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                else
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                end
            end)
		end
	end, function(data, menu)
		menu.close()
		CurrentAction     = 'work'
		CurrentActionData = {}
	end)
end)

cleanPlayer = function(playerPed)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

--KANG KAYU--
exports.ox_target:AddBoxZone("tebangKayu", vector3(-466.42, 5378.9, 80.69), 10.0, 10.0, {
  name="tebangKayu",
  heading = 340,
  --debugPoly = true,
  minZ = 79.69,
  maxZ = 83.69,
}, 
{
    options = {
        {
            event = "midp-jobs:TebangKayu",
            icon = "fas fa-wrench",
            label = "Tebang Kayu",
            canInteract = function(entity) return workclothes end
        },
    },
    distance = 5
}) 

exports.ox_target:AddBoxZone("potongkayu", vector3(-594.23, 5328.82, 70.32), 2.0, 3.8, {
    name="potongkayu",
  heading=340,
  --debugPoly=true,
  minZ=67.32,
  maxZ=71.32,
}, 
{
    options = {
        {
            event = "midp-jobs:proseskayu",
            icon = "fas fa-wrench",
            label = "Proses Kayu",
            canInteract = function(entity) return workclothes end
        },
    },
    distance = 3
}) 

exports.ox_target:AddBoxZone("kemas", vector3(-574.1, 5364.27, 70.22), 2.2, 4.2, {
    name="kemas",
    heading=340,
    --debugPoly=true,
    minZ=67.02,
    maxZ=71.02,
}, 
{
    options = {
        {
            event = "midp-jobs:KemasKayu",
            icon = "fas fa-boxes",
            label = "Kemas Kayu",
            canInteract = function(entity) return workclothes end
        },
    },
    distance = 3
})

exports.ox_target:AddBoxZone("jualkayu", vector3(1205.76, -1336.04, 35.23), 10.0, 10.0, {
    name="jualkayu",
    heading = 0,
    --debugPoly = true,
    minZ = 34.23,
    maxZ = 38.23,
}, 
{
    options = {
        {
            event = "midp-jobs:JualKayu",
            icon = "fas fa-boxes",
            label = "Jual Kayu",
            canInteract = function(entity) return workclothes end
        },
    },
    distance = 3
})

exports.ox_target:AddBoxZone("gantikayu", vector3(1200.5, -1277.7, 35.22), 2, 2, {
    name="gantikayu",
    heading=355,
    --debugPoly=true,
    minZ = 34.22,
    maxZ = 38.22,
}, 
{
    options = {
        {
            event = "midp-jobs:changeclothes",
            icon = "fas fa-tshirt",
            label = "Ganti Pakaian",
            job = {
                ["lumberjack"] = 0,
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
            event = "midp-jobs:SpawnKkaYu",
            icon = "fas fa-car",
            label = "Sewa Kendaraan",
            job = {
                ["lumberjack"] = 0,
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
            label = "Simpan Kendaraan",
            job = {
                ["lumberjack"] = 0,
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
    distance = 3
})
--END KANG KAYU--
-- Nelayan --
exports.ox_target:AddBoxZone("NpcKapal", vector3(3866.97, 4463.75, 2.74), 1, 1, {
    name="NpcKapal",
    heading=0,
    --debugPoly=true,
    minZ=-0.06,
    maxZ=3.94       
}, 
{
    options = {
        {
            event = "sewakapal",
            icon = "fas fa-car",
            label = "Sewa Kapal",
            canInteract = function(entity) return workclothes end
        },
        {
            event = "midp-jobs:hapusmobil",
            icon = "fas fa-sign-out-alt",
            label = "Simpan Kapal",
            canInteract = function(entity) return workclothes end
        },
    },
    distance = 3
})

exports.ox_target:AddBoxZone("jualIkan", vector3(-1040.86, -1355.15, 5.55), 10, 5, {
    name="jualIkan",
    heading = 325,
    --debugPoly = true,
    minZ = 4.55,
    maxZ = 8.55      
}, 
{
    options = {
        {
            event = "midp-jobs:JualIkan",
            icon = "fas fa-box",
            label = "Jual Ikan",
            canInteract = function(entity) return workclothes end
        },
    },
    distance = 3
})

exports.ox_target:AddBoxZone("gantinelayan", vector3(869.11, -1639.85, 30.19), 2, 2, {
    name="gantinelayan",
    heading=0,
    --debugPoly=true,
    minZ = 29.19,
    maxZ = 33.19,
}, 
{
    options = {
        {
            event = "midp-jobs:changeclothes",
            icon = "fas fa-tshirt",
            label = "Ganti Pakaian",
            job = {
                ["fisherman"] = 0,
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
            event = "midp-jobs:vehNelayan",
            icon = "fas fa-car",
            label = "Sewa Kendaraan",
            job = {
                ["fisherman"] = 0,
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
            label = "Simpan Kendaraan",
            job = {
                ["fisherman"] = 0,
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
    distance = 3
})
--END-NELAYAN--
-- TODO : FUELER JOB
exports.ox_target:AddBoxZone("takepetrol", vector3(582.53, 2935.29, 40.98), 10, 10, {
	name="takepetrol",
    heading=347,
    --debugPoly=true,
    minZ=38.18,
    maxZ=42.18
	}, {
		options = {
			{
				event = "midp-jobs:miningoil",
				icon = "fas fa-sign-in-alt",
				label = "Mengebor Minyak!",
                canInteract = function(entity) return workclothes end
			},
		},
		distance = 2
})

exports.ox_target:AddBoxZone("prosespetrol", vector3(2761.1, 1489.34, 30.79), 2.0, 2.2, {
	name="prosespetrol",
    heading=345,
    --debugPoly=true,
    minZ=28.39,
    maxZ=32.39
	}, {
		options = {
			{
				event = "midp-jobs:ConvOil",
				icon = "fas fa-sign-in-alt",
				label = "Proses Minyak",
                canInteract = function(entity) return workclothes end
			},
		},
		distance = 2
})

exports.ox_target:AddBoxZone("prosessraffin", vector3(2674.75, 1554.07, 24.5), 3.0, 3.2, {
	name="prosesraffin",
    heading=0,
    --debugPoly=true,
    minZ=22.9,
    maxZ=26.9
	}, {
		options = {
			{
				event = "midp-jobs:extogas",
				icon = "fas fa-sign-in-alt",
				label = "Proses Raffin",
                canInteract = function(entity) return workclothes end
			},
		},
		distance = 2
})

exports.ox_target:AddBoxZone("jualminyak", vector3(515.9, -2110.47, 5.96), 10, 10, {
	name="jualminyak",
    heading = 0,
    --debugPoly = true,
    minZ = 4.96,
    maxZ = 8.96,
	}, {
		options = {
			{
				event = "midp-jobs:JualMinyak",
				icon = "fas fa-sign-in-alt",
				label = "Jual Minyak",
                canInteract = function(entity) return workclothes end
			},
		},
		distance = 2
})

exports.ox_target:AddBoxZone("gantifuel", vector3(556.69, -2328.04, 5.85), 2, 3, {
    name="gantifuel",
    heading=295,
    --debugPoly=true,
    minZ = 4.25,
    maxZ = 8.25,
}, 
{
    options = {
        {
            event = "midp-jobs:changeclothes",
            icon = "fas fa-tshirt",
            label = "Ganti Pakaian",
            job = {
                ["fueler"] = 0,
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
            event = "midp-jobs:VehFueler",
            icon = "fas fa-car",
            label = "Sewa Kendaraan",
            job = {
                ["fueler"] = 0,
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
            label = "Simpan Kendaraan",
            job = {
                ["fueler"] = 0,
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
    distance = 3
})
--END TARGET--
-- BLIP KERJA
BlipKerjaa = function()
   local PlayerData = ESX.GetPlayerData()
		if PlayerData.job and PlayerData.job.name == 'lumberjack' then
         local blip3 = AddBlipForCoord(-469.92, 5377.0, 80.8)
         SetBlipSprite (blip3, 237)
         SetBlipDisplay(blip3, 4)
         SetBlipScale  (blip3, 0.8)
         SetBlipColour (blip3, 4)
         SetBlipAsShortRange(blip3, true)
         BeginTextCommandSetBlipName("STRING")
         AddTextComponentString("Tukang Kayu | Ambil Kayu Dan Kemas Kayu")
         EndTextCommandSetBlipName(blip3)
         table.insert(blipjob, blip3)

         local blipkayu = AddBlipForCoord(-593.82, 5327.24, 70.27)
         SetBlipSprite (blipkayu, 237)
         SetBlipDisplay(blipkayu, 4)
         SetBlipScale  (blipkayu, 0.8)
         SetBlipColour (blipkayu, 4)
         SetBlipAsShortRange(blipkayu, true)
         BeginTextCommandSetBlipName("STRING")
         AddTextComponentString("Tukang Kayu | Potong Kayu")
         EndTextCommandSetBlipName(blipkayu)
         table.insert(blipjob, blipkayu)

         local jualkayub = AddBlipForCoord(1205.76, -1336.04, 35.23)
         SetBlipSprite (jualkayub, 237)
         SetBlipDisplay(jualkayub, 4)
         SetBlipScale  (jualkayub, 0.8)
         SetBlipColour (jualkayub, 4)
         SetBlipAsShortRange(jualkayub, true)
         BeginTextCommandSetBlipName("STRING")
         AddTextComponentString("Tukang Kayu | Jual Kayu")
         EndTextCommandSetBlipName(jualkayub)
         table.insert(blipjob, jualkayub)
        end
        if PlayerData.job and PlayerData.job.name == 'fisherman' then
         local blip6 = AddBlipForCoord(3866.97, 4463.75, 2.74)
         SetBlipSprite (blip6, 68)
         SetBlipDisplay(blip6, 4)
         SetBlipScale  (blip6, 0.8)
         SetBlipColour (blip6, 38)
         SetBlipAsShortRange(blip6, true)
         BeginTextCommandSetBlipName("STRING")
         AddTextComponentString("Nelayan | Dermaga")
         EndTextCommandSetBlipName(blip6)
         table.insert(blipjob, blip6)

         local blip7 = AddBlipForCoord(4435.21, 4829.60, 0.34)
         SetBlipSprite (blip7, 68)
         SetBlipDisplay(blip7, 4)
         SetBlipScale  (blip7, 0.8)
         SetBlipColour (blip7, 38)
         SetBlipAsShortRange(blip7, true)
         BeginTextCommandSetBlipName("STRING")
         AddTextComponentString("Nelayan | Dermaga")
         EndTextCommandSetBlipName(blip7)
         table.insert(blipjob, blip7)

         local ikanjual = AddBlipForCoord(-1040.86, -1355.15, 5.55)
         SetBlipSprite (ikanjual, 68)
         SetBlipDisplay(ikanjual, 4)
         SetBlipScale  (ikanjual, 0.8)
         SetBlipColour (ikanjual, 38)
         SetBlipAsShortRange(ikanjual, true)
         BeginTextCommandSetBlipName("STRING")
         AddTextComponentString("Nelayan | Jual Ikan")
         EndTextCommandSetBlipName(ikanjual)
         table.insert(blipjob, ikanjual)
        end
        if PlayerData.job and PlayerData.job.name == 'fueler' then
         local blip8 = AddBlipForCoord(582.53, 2935.29, 40.98)
         SetBlipSprite (blip8, 436)
         SetBlipDisplay(blip8, 4)
         SetBlipScale  (blip8, 0.8)
         SetBlipColour (blip8, 5)
         SetBlipAsShortRange(blip8, true)
         BeginTextCommandSetBlipName("STRING")
         AddTextComponentString("Tukang Minyak | Bor Minyak")
         EndTextCommandSetBlipName(blip8)
         table.insert(blipjob, blip8)

         local blippr = AddBlipForCoord(2761.1, 1489.34, 30.79)
         SetBlipSprite (blippr, 436)
         SetBlipDisplay(blippr, 4)
         SetBlipScale  (blippr, 0.8)
         SetBlipColour (blippr, 5)
         SetBlipAsShortRange(blippr, true)
         BeginTextCommandSetBlipName("STRING")
         AddTextComponentString("Tukang Minyak | Proses Petrol")
         EndTextCommandSetBlipName(blippr)
         table.insert(blipjob, blippr)

         local blipcok = AddBlipForCoord(2674.75, 1554.07, 24.5)
         SetBlipSprite (blipcok, 436)
         SetBlipDisplay(blipcok, 4)
         SetBlipScale  (blipcok, 0.8)
         SetBlipColour (blipcok, 5)
         SetBlipAsShortRange(blipcok, true)
         BeginTextCommandSetBlipName("STRING")
         AddTextComponentString("Tukang Minyak | Proses Raffin")
         EndTextCommandSetBlipName(blipcok)
         table.insert(blipjob, blipcok)

         local jualminyakb = AddBlipForCoord(515.9, -2110.47, 5.96)
         SetBlipSprite (jualminyakb, 436)
         SetBlipDisplay(jualminyakb, 4)
         SetBlipScale  (jualminyakb, 0.8)
         SetBlipColour (jualminyakb, 5)
         SetBlipAsShortRange(jualminyakb, true)
         BeginTextCommandSetBlipName("STRING")
         AddTextComponentString("Tukang Minyak | Jual Minyak")
         EndTextCommandSetBlipName(jualminyakb)
         table.insert(blipjob, jualminyakb)

         local gantib = AddBlipForCoord(556.69, -2328.04, 5.85)
         SetBlipSprite (gantib, 436)
         SetBlipDisplay(gantib, 4)
         SetBlipScale  (gantib, 0.8)
         SetBlipColour (gantib, 5)
         SetBlipAsShortRange(gantib, true)
         BeginTextCommandSetBlipName("STRING")
         AddTextComponentString("kantor T.Minyak")
         EndTextCommandSetBlipName(gantib)
         table.insert(blipjob, gantib)
    end
end

CreateThread(function()
    RequestModel(GetHashKey('s_m_y_baywatch_01'))
    while not HasModelLoaded(GetHashKey('s_m_y_baywatch_01')) do
        Wait(5)
    end
    local pedkapal  = CreatePed(19, GetHashKey('s_m_y_baywatch_01'), 3866.92, 4463.76, 2.73 - 1.0, 94.18, false, false)
    SetEntityInvincible(pedkapal, true)
    SetEntityAsMissionEntity(ped3, true, true)
    SetPedHearingRange(pedkapal, 0.0)
    SetPedSeeingRange(pedkapal, 0.0)
    SetPedAlertness(pedkapal, 0.0)
    SetPedFleeAttributes(pedkapal, 0, 0)
    SetBlockingOfNonTemporaryEvents(pedkapal, true)
    SetPedCombatAttributes(pedkapal, 46, true)
    SetPedFleeAttributes(pedkapal, 0, 0)
    SetModelAsNoLongerNeeded(pedkapal)
    DecorSetInt(pedkapal,"GamemodeCar",955)
    Wait(1000)
    FreezeEntityPosition(pedkapal , true)
    
    RequestModel(GetHashKey('a_m_o_acult_02'))
    while not HasModelLoaded(GetHashKey('a_m_o_acult_02')) do
        Wait(5)
    end
    local pedrentveh  = CreatePed(19, GetHashKey('a_m_o_acult_02'), -1038.7601318359, -2731.0529785156, 19.169290542603 - 1.0, 274.91, false, false) --ariport
    SetEntityInvincible(pedrentveh, true)
    SetEntityAsMissionEntity(ped3, true, true)
    SetPedHearingRange(pedrentveh, 0.0)
    SetPedSeeingRange(pedrentveh, 0.0)
    SetPedAlertness(pedrentveh, 0.0)
    SetPedFleeAttributes(pedrentveh, 0, 0)
    SetBlockingOfNonTemporaryEvents(pedrentveh, true)
    SetPedCombatAttributes(pedrentveh, 46, true)
    SetPedFleeAttributes(pedrentveh, 0, 0)
    SetModelAsNoLongerNeeded(pedrentveh)
    DecorSetInt(pedrentveh,"GamemodeCar",955)
    Wait(1000)
    FreezeEntityPosition(pedrentveh , true)

    RequestModel(GetHashKey('a_m_m_farmer_01'))
    while not HasModelLoaded(GetHashKey('a_m_m_farmer_01')) do
        Wait(5)
    end
    local pedrentlab  = CreatePed(19, GetHashKey('a_m_m_farmer_01'), -727.74, -1307.65,5.0 - 1.0, 49.93, false, false) --labuh
    SetEntityInvincible(pedrentlab, true)
    SetEntityAsMissionEntity(ped3, true, true)
    SetPedHearingRange(pedrentlab, 0.0)
    SetPedSeeingRange(pedrentlab, 0.0)
    SetPedAlertness(pedrentlab, 0.0)
    SetPedFleeAttributes(pedrentlab, 0, 0)
    SetBlockingOfNonTemporaryEvents(pedrentlab, true)
    SetPedCombatAttributes(pedrentlab, 46, true)
    SetPedFleeAttributes(pedrentlab, 0, 0)
    SetModelAsNoLongerNeeded(pedrentlab)
    DecorSetInt(pedrentlab,"GamemodeCar",955)
    Wait(1000)
    FreezeEntityPosition(pedrentlab , true)

    RequestModel(GetHashKey('cs_movpremmale'))
    while not HasModelLoaded(GetHashKey('cs_movpremmale')) do
        Wait(5)
    end
    local pedrentlab  = CreatePed(19, GetHashKey('cs_movpremmale'), -139.226379, -633.969238,168.813232 - 1.0, 5.669291, false, false) --labuh
    SetEntityInvincible(pedrentlab, true)
    SetEntityAsMissionEntity(ped3, true, true)
    SetPedHearingRange(pedrentlab, 0.0)
    SetPedSeeingRange(pedrentlab, 0.0)
    SetPedAlertness(pedrentlab, 0.0)
    SetPedFleeAttributes(pedrentlab, 0, 0)
    SetBlockingOfNonTemporaryEvents(pedrentlab, true)
    SetPedCombatAttributes(pedrentlab, 46, true)
    SetPedFleeAttributes(pedrentlab, 0, 0)
    SetModelAsNoLongerNeeded(pedrentlab)
    DecorSetInt(pedrentlab,"GamemodeCar",955)
    Wait(1000)
    FreezeEntityPosition(pedrentlab , true)
end)

function HapusBlipKerja()
	for k,v in ipairs(JobBlips) do
		RemoveBlip(v)
		JobBlips[k] = nil
	end
end

RegisterNetEvent('midp-jobs:TebangKayu')
AddEventHandler('midp-jobs:TebangKayu', function()
    ESX.TriggerServerCallback('midp-jobs:canPickUp', function(canPickUp)
        if canPickUp then
            if not sibuk then
            sibuk = true
            exports.ox_inventory:Progress({
                duration = 5000,
                label = 'Menebang Kayu...',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    move = true,
                    car = true,
                    combat = true,
                    mouse = false
                },
                anim = { dict = 'melee@hatchet@streamed_core', clip = 'plyr_rear_takedown_b' },
            }, function(cancel)
                if not cancel then
                    TriggerServerEvent('midp-core:NambahItems', 'wood', 5)
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
    end, 'wood')
end)

RegisterNetEvent('midp-jobs:proseskayu')
AddEventHandler('midp-jobs:proseskayu', function()
    ESX.TriggerServerCallback('midp-jobs:cekItem', function(items)
        if items >= 10 then
            TriggerServerEvent('midp-core:delItem', 'wood', 10)
            if not sibuk then
            sibuk = true
            exports.ox_inventory:Progress({
                duration = 5000,
                label = 'Memotong Kayu...',
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
                    TriggerServerEvent('midp-core:NambahItems', 'cutted_wood', 5)
                    sibuk = false
                else
                    TriggerServerEvent('midp-core:NambahItems', 'wood', 10)
                    sibuk = false
                    exports['midp-tasknotify']:DoHudText('error', 'Proses Dibatalkan!')
                end
            end)
        end
            else
            exports['midp-tasknotify']:DoHudText('error', 'Tidak Memiliki Cukup Kayu!')
        end
    end, 'wood')
end)

RegisterNetEvent('midp-jobs:KemasKayu')
AddEventHandler('midp-jobs:KemasKayu', function()
    ESX.TriggerServerCallback('midp-jobs:cekItem', function(items)
        if items >= 1 then
            if not sibuk then
            sibuk = true
            TriggerServerEvent('midp-core:delItem', 'cutted_wood', 1)
            exports.ox_inventory:Progress({
                duration = 10000,
                label = 'Mengemas kayu...',
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
                    TriggerServerEvent('midp-core:NambahItems', 'packaged_plank', 4)
                    sibuk = false
                else
                    TriggerServerEvent('midp-core:NambahItems', 'cutted_wood', 1)
                    sibuk = false
                    exports['midp-tasknotify']:DoHudText('error', 'Proses Dibatalkan!')
                end
            end)
        end 
            else
            exports['midp-tasknotify']:DoHudText('error', 'Tidak Memiliki Cukup Kayu Potong!')
        end
    end, 'cutted_wood')
end)

RegisterNetEvent('midp-jobs:JualKayu')
AddEventHandler('midp-jobs:JualKayu', function()
    if not sibuk then
        sibuk = true
        exports.ox_inventory:Progress({
            duration = 5000,
            label = 'Menjual Kayu...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = true,
                combat = true,
                mouse = false
            },
            anim = {
                anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
            },
        }, function(cancel)
            if not cancel then
                TriggerServerEvent('midp-jobs:JualinKayu', irham.t())
                sibuk = false
            else 
                sibuk = false
                exports['midp-tasknotify']:DoHudText('error', 'Proses Dibatalkan!')
            end
        end)
    end
end)


-- Fisherman/Nelayan
RegisterNetEvent("sewakapal")
AddEventHandler("sewakapal", function()
    local jobname = ESX.GetPlayerData().job.name
    ESX.Game.SpawnVehicle('Dinghy', vector3(3862.81, 4474.49, -0.47) , 37.84, function(vehicle)
        exports["dl-bensin"]:SetFuel(vehicle, 100)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleModKit(vehicle, 0)
        SetVehicleMod(vehicle, 11, 3, false)
        SetVehicleMod(vehicle, 12, 2, false)
        SetVehicleMod(vehicle, 13, 2, false)
        SetVehicleMod(vehicle, 15, 3, false)
        SetVehicleMod(vehicle, 16, 4, false)
        ToggleVehicleMod(vehicle, 18, true)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        SetVehicleColours(vehicle, 39, 39)
    end)
end)

CreateThread(function()
    exports["midp-nui"]:AddBoxZone("fishermanfishspot", vector3(4435.21, 4829.60, 0.34), 250.0, 250.0, {
        name="fishermanfishspot",
        heading    = 85.5,
        debugPoly  = false,
        minZ       = 0.34 - 1.2,
        maxZ       = 0.34 + 15.0
    })

    RegisterNetEvent('polyzonecuy:enter')
    AddEventHandler('polyzonecuy:enter', function(name)
        if name == 'fishermanfishspot' then
            AreaMancing = true
            CreateThread(function()
                while true do
                        if AreaMancing then
                            exports['midp-tasknotify']:Open('[E] Mulai Ambil', 'darkblue', 'right')
                            if IsControlJustReleased(1, 51) then
                                local time = math.random(10,15)
                                local circles = math.random(1,2)
                                local success = exports['midp-lockpick']:StartLockPickCircle(circles, time, success)
                                if success then
                                    if not sibuk then
                                        sibuk = true
                                        exports.ox_inventory:Progress({
                                            duration = 5000,
                                            label = 'Memancing...',
                                            useWhileDead = false,
                                            canCancel = true,
                                            disable = {
                                                move = false,
                                                car = true,
                                                combat = true,
                                                mouse = false
                                            },
                                            anim = {
                                                scenario = "WORLD_HUMAN_STAND_FISHING",
                                            },
                                        }, function(cancel)
                                            if not cancel then
                                                TriggerServerEvent('midp-core:NambahItems', 'fish', math.random(3, 5))
                                                sibuk = false
                                            else 
                                                sibuk = false
                                                exports['midp-tasknotify']:DoHudText('error', 'Proses Dibatalkan!')
                                            end
                                        end)
                                    end
                                else
                                    exports['midp-tasknotify']:DoHudText('error', 'Ikan Lepas, Silahlkan tangkap Lagi!') 
                                end
                            end
                        else
                            break
                        end
                    Wait(0)
                end
            end)
        end
    end)

    RegisterNetEvent('polyzonecuy:exit')
    AddEventHandler('polyzonecuy:exit', function(name)
            if name == 'fishermanfishspot' then
                AreaMancing = false
                exports['midp-tasknotify']:Close()
            end
    end)
end)

RegisterNetEvent('midp-jobs:JualIkan')
AddEventHandler('midp-jobs:JualIkan', function()
    if not sibuk then
        sibuk = true
        exports.ox_inventory:Progress({
            duration = 5000,
            label = 'Menjual Ikan...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = true,
                combat = true,
                mouse = false
            },
            anim = {
                anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
            },
        }, function(cancel)
            if not cancel then
                TriggerServerEvent('midp-jobs:JualanIkan', irham.t())
                sibuk = false
            else 
                sibuk = false
                exports['midp-tasknotify']:DoHudText('error', 'Proses Dibatalkan!')
            end
        end)
    end
end)

-- TODO : EVENT AND FUNCTION
RegisterNetEvent('midp-jobs:miningoil')
AddEventHandler('midp-jobs:miningoil', function()
    ESX.TriggerServerCallback('midp-jobs:canPickUp', function(canPickUp)
        if canPickUp then
            if not sibuk then
            sibuk = true
            exports.ox_inventory:Progress({
                duration = 5000,
                label = 'Mengebor Minyak...',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    move = false,
                    car = true,
                    combat = true,
                    mouse = false
                },
                anim = {
                    scenario = "WORLD_HUMAN_CONST_DRILL",
                },
            }, function(cancel)
                if not cancel then
                    ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 50.0, 0)
                    TriggerServerEvent('midp-core:NambahItems', 'petrol', 5)
                    sibuk = false
                else
                    sibuk = false
                    exports['midp-tasknotify']:DoHudText('error', 'Proses Dibatalkan!')
                    ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 50.0, 0)
                end
            end)
        end 
            else
            exports['midp-tasknotify']:DoHudText('error', 'Melebihi Batas!')
        end
    end, 'petrol')
end)

RegisterNetEvent('midp-jobs:ConvOil')
AddEventHandler('midp-jobs:ConvOil', function()
    ESX.TriggerServerCallback('midp-jobs:cekItem', function(items)
        if items >= 5 then
            if not sibuk then
            sibuk = true
            TriggerServerEvent('midp-core:delItem', 'petrol', 5)
            exports.ox_inventory:Progress({
                duration = 7000,
                label = 'Mengextrak Minyak...',
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
                    TriggerServerEvent('midp-core:NambahItems', 'petrol_raffin', 2)
                    sibuk = false
                else
                    TriggerServerEvent('midp-core:NambahItems', 'petrol', 5)
                    sibuk = false
                    exports['midp-tasknotify']:DoHudText('error', 'Proses Dibatalkan!')
                end
            end)
        end 
            else
            exports['midp-tasknotify']:DoHudText('error', 'Tidak Memiliki Cukup Petrol!')
        end
    end, 'petrol')
end)

RegisterNetEvent('midp-jobs:extogas')
AddEventHandler('midp-jobs:extogas', function()
    ESX.TriggerServerCallback('midp-jobs:cekItem', function(items)
        if items >= 2 then
            if not sibuk then
            sibuk = true
            TriggerServerEvent('midp-core:delItem', 'petrol_raffin', 2)
            exports.ox_inventory:Progress({
                duration = 10000,
                label = 'Mengubah Ke Gas...',
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
                    TriggerServerEvent('midp-core:NambahItems', 'essence', 2)
                    sibuk = false
                else
                    TriggerServerEvent('midp-core:NambahItems', 'petrol_raffin', 2)
                    sibuk = false
                    exports['midp-tasknotify']:DoHudText('error', 'Proses Dibatalkan!')
                end
            end)
        end 
            else
            exports['midp-tasknotify']:DoHudText('error', 'Tidak Memiliki Cukup Petrol Raffin!')
        end
    end, 'petrol_raffin')
end)

RegisterNetEvent('midp-jobs:JualMinyak')
AddEventHandler('midp-jobs:JualMinyak', function()
    if not sibuk then
        sibuk = true
        exports.ox_inventory:Progress({
            duration = 5000,
            label = 'Menjual Gas...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = true,
                combat = true,
                mouse = false
            },
            anim = {
                anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
            },
        }, function(cancel)
            if not cancel then
                TriggerServerEvent('midp-jobs:JualinMinyak', irham.t())
                sibuk = false
            else 
                sibuk = false
                exports['midp-tasknotify']:DoHudText('error', 'Proses Dibatalkan!')
            end
        end)
    end
end)

RegisterNetEvent('midp-jobs:SpawnKkaYu')
AddEventHandler('midp-jobs:SpawnKkaYu', function()
	ESX.Game.SpawnVehicle('canter', {x = 1205.2889404297, y = -1265.9328613281, z = 35.226760864258}, 173.43, function(callback_vehicle)
		TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
		exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
		exports["dl-bensin"]:SetFuel(callback_vehicle, 100)
	end)
end)

RegisterNetEvent('midp-jobs:vehNelayan')
AddEventHandler('midp-jobs:vehNelayan', function()
	ESX.Game.SpawnVehicle('canter', {x = 873.24407958984, y = -1657.4841308594, z = 30.298006057739}, 83.76, function(callback_vehicle)
		TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
		exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
		exports["dl-bensin"]:SetFuel(callback_vehicle, 100)
	end)
end)

RegisterNetEvent('midp-jobs:VehFueler')
AddEventHandler('midp-jobs:VehFueler', function()
	ESX.Game.SpawnVehicle('canter', {x = 569.73522949219, y = -2324.5415039063, z = 5.9113283157349}, 350.7, function(callback_vehicle)
		TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
		exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
		exports["dl-bensin"]:SetFuel(callback_vehicle, 100)
	end)
end)

--jobcenter--
RegisterNetEvent('midp-jobs:pilihkerja')
AddEventHandler('midp-jobs:pilihkerja', function()
	local jobs = {}
    for k,v in pairs(Config.jobs) do
        table.insert(jobs, {
            id = k,
            header = v.label,
            txt = '',
            params = {
                event = 'Night:jobCenter2',
                args = {
                    nombre = v.nombre,
                    grado = v.grado
                }
            }
        })
    end
    TriggerEvent('midp-context:sendMenu', jobs)      

   
end)

RegisterNetEvent('Night:jobCenter2')
AddEventHandler('Night:jobCenter2', function(data)

    TriggerServerEvent('Night:setjob', data.nombre, data.grado)

    for k,v in pairs (Config.Blacklistedjobs) do
        print(v)
        if data.nombre == v then 
            TriggerServerEvent('Night:drop','good luck next time bud') 
        end
    end

    if data.nombre == 'pizza' then
        notify('you are hired as a pizza man!')
    elseif data.nombre == 'burgershot' then
        notify('you are hired as a burger man!') 
    else
        notify('you are hired my friend!') 
    end 

    


end)

function notify(mensaje)

    if Config.notitype == 'esx' then
        ESX.ShowNotification(mensaje)
    elseif Config.notitype == 'mythic' then
        exports['midp-tasknotify']:SendAlert('inform', mensaje, 10000)
    end

end

local jangkar = false
local boat = nil

CreateThread(function()
	while true do
		Wait(500)
		local ped = GetPlayerPed(-1)
		if IsPedInAnyBoat(ped) then
			boat  = GetVehiclePedIsIn(ped, true)
		end

		if IsVehicleEngineOn(boat) then
			jangkar = false
		end
	end
end)

RegisterCommand("jangkar", function()
    local ped = GetPlayerPed(-1)

	if not IsPedInAnyVehicle(ped) and boat ~= nil then
		if not jangkar then
			SetBoatAnchor(boat, true)
			TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
			Wait(10000)
			exports['midp-tasknotify']:SendAlert('inform', 'Jangkar dipasang', 10000)
			ClearPedTasks(ped)
		else
			TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
			Wait(10000)
			SetBoatAnchor(boat, false)
			exports['midp-tasknotify']:SendAlert('inform', 'Jangkar diambil', 10000)
			ClearPedTasks(ped)
		end
		jangkar = not jangkar
	end
end)