Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local menuOpen = false
local wasOpen = false
local coke_poochQTE = 0
local weed_poochQTE = 0
local myJob = nil
local PlayerData = {}

Citizen.CreateThread(function()


	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
	Citizen.Wait(10000)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
	Citizen.Wait(10000)
end)

RegisterNetEvent('jn-drugs:notifyharam')
AddEventHandler('jn-drugs:notifyharam', function()
    local playerPed 	= PlayerPedId()
	local playerCoords	= GetEntityCoords(playerPed)
	if ESX.PlayerData.job.name == 'police' then
		TriggerServerEvent('jn-drugs:jualinprogress', {
			x = ESX.Math.Round(playerCoords.x, 1),
			y = ESX.Math.Round(playerCoords.y, 1),
			z = ESX.Math.Round(playerCoords.z, 1)}
		)
	end
end)

RegisterNetEvent('jn-drugs:jualinprogress')
AddEventHandler('jn-drugs:jualinprogress', function(targetCoords)
		local alpha = 250
		local jualharamblip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, 50.0)

		SetBlipHighDetail(jualharamblip, true)
		SetBlipColour(jualharamblip, 5)
		SetBlipAlpha(jualharamblip, alpha)
		SetBlipAsShortRange(jualharamblip, true)

		while alpha ~= 0 do
			Citizen.Wait(100)
			alpha = alpha - 1
			SetBlipAlpha(jualharamblip, alpha)

			if alpha == 0 then
				RemoveBlip(jualharamblip)
				return
			end
		end
end)

--FUNCTION PENJUALAN--
RegisterNetEvent('jn-drugs:ReturnInventory')
AddEventHandler('jn-drugs:ReturnInventory', function(cokepNbr, weedpNbr, jobName, currentZone)
	coke_poochQTE = cokepNbr
	weed_poochQTE = weedpNbr
	myJob		 = jobName
end)

RegisterNetEvent('jn-drugs:jualgenjer')
AddEventHandler('jn-drugs:jualgenjer', function()
	TriggerServerEvent('jn-drugs:startSellWeed',  irham.t())
	TriggerEvent("mythic_progbar:client:progress", {
		name = "unique_action_name",
		duration = 31500,
		label = "Menjual Genjer",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}
	})
end)

RegisterNetEvent('jn-drugs:jualsianida')
AddEventHandler('jn-drugs:jualsianida', function()
	TriggerServerEvent('jn-drugs:startSellCoke', irham.t())
	TriggerEvent("mythic_progbar:client:progress", {
		name = "unique_action_name",
		duration = 31500,
		label = "Menjual Sianida",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}
	})
end)

RegisterNetEvent('midp-illegal:Ngumbah', function()
    ESX.TriggerServerCallback('dl-jobs:cekItem', function(items)
        if items >= 500000 then
            if not sibuk then
            sibuk = true
            TriggerServerEvent('midp-core:delItem', 'black_money', 500000)
            exports.ox_inventory:Progress({
                duration = 10000,
                label = 'Mencuci uang...',
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
                    TriggerServerEvent('midp-core:NambahItems', 'money', 500000)
                    sibuk = false
                else
                    TriggerServerEvent('midp-core:NambahItems', 'black_money', 500000)
                    sibuk = false
                    exports['midp-tasknotify']:DoHudText('error', 'Proses Dibatalkan!')
                end
            end)
        end 
            else
            exports['midp-tasknotify']:DoHudText('error', 'Minimal cuci uang merah $DL 500.000')
        end
    end, 'black_money')
end)

--REPAIR SENJATA--
local ox_inventory = exports.ox_inventory
local weapon = {}
local weapons = {'WEAPON_ADVANCEDRIFLE','WEAPON_APPISTOL','WEAPON_ASSAULTRIFLE','WEAPON_ASSAULTSHOTGUN','WEAPON_BULLPUPRIFLE','WEAPON_CARBINERIFLE','WEAPON_COMBATMG','WEAPON_COMBATPISTOL','WEAPON_COMBATPDW','WEAPON_COMBATSHOTGUN','WEAPON_HEAVYSNIPER','WEAPON_HEAVYSNIPER_MK2','WEAPON_MARKSMANRIFLE','WEAPON_MARKSMANRIFLE_MK2','WEAPON_MG','WEAPON_MICROSMG','WEAPON_MINIGUN','WEAPON_MOLOTOV','WEAPON_MUSKET','WEAPON_PETROLCAN','WEAPON_PISTOL','WEAPON_PISTOL50','WEAPON_PROXMINE','WEAPON_PUMPSHOTGUN','WEAPON_REVOLVER','WEAPON_RPG','WEAPON_SAWNOFFSHOTGUN','WEAPON_SMG','WEAPON_SMG_MK2','WEAPON_SNIPERRIFLE','WEAPON_SNIPERRIFLE_MK2','WEAPON_SWITCHBLADE','WEAPON_VINTAGEPISTOL','WEAPON_ASSAULTRIFLE_MK2','WEAPON_ASSAULTSMG','WEAPON_BAT','WEAPON_BATTLEAXE','WEAPON_BULLPUPSHOTGUN','WEAPON_CARBINERIFLE_MK2','WEAPON_CERAMICPISTOL','WEAPON_COMBATMG_MK2','WEAPON_COMPACTRIFLE','WEAPON_CROWBAR','WEAPON_DAGGER','WEAPON_DBSHOTGUN','WEAPON_DOUBLEACTION','WEAPON_FIREWORK','WEAPON_FLAREGUN','WEAPON_FLASHLIGHT','WEAPON_GOLFCLUB','WEAPON_GUSENBERG','WEAPON_HAMMER','WEAPON_HATCHET','WEAPON_HEAVYPISTOL','WEAPON_HEAVYSHOTGUN','WEAPON_KNIFE','WEAPON_KNUCKLE','WEAPON_MACHETE','WEAPON_MACHINEPISTOL','WEAPON_MARKSMANPISTOL','WEAPON_MILITARYRIFLE','WEAPON_MINISMG','WEAPON_NAVYREVOLVER','WEAPON_NIGHTSTICK','WEAPON_PISTOL_MK2','WEAPON_POOLCUE','WEAPON_PUMPSHOTGUN_MK2','WEAPON_REVOLVER_MK2','WEAPON_SNSPISTOL','WEAPON_SNSPISTOL_MK2','WEAPON_SPECIALCARBINE','WEAPON_SPECIALCARBINE_MK2','WEAPON_STONE_HATCHET','WEAPON_STUNGUN','WEAPON_SWEEPERSHOTGUN','WEAPON_WRENCH'}

function openContext()
    local inventory = ox_inventory:Search('count', weapons)
    local options = {}
    if inventory then
        for name, count in pairs(inventory) do
            if count >= 1 then
                local curweapon = name
                local weapon = ESX.GetWeaponLabel(name)
                options[weapon] = {
                    event = 'dl-wrepair:fixSenjata',
                    args = {selweapon = curweapon}
                }
            end
        end
    end

    lib.registerContext({
        id = 'weapon_menu',
        title = 'Perbaikan Senjata',
        options = options
    })
    lib.showContext('weapon_menu')
end

function openContextItem()
    local inventory = ox_inventory:Search('count', weapons)
    local options = {}
    if inventory then
        for name, count in pairs(inventory) do
            if count >= 1 then
                local curweapon = name
                local weapon = ESX.GetWeaponLabel(curweapon)
                options[weapon] = {
                    event = 'dl-wrepair:useitem',
                    args = {selweapon = curweapon}
                }
            end
        end
    end

    lib.registerContext({
        id = 'weapon_menu',
        title = 'Perbaikan Senjata',
        options = options
    })
    lib.showContext('weapon_menu')
end

RegisterNetEvent('dl-wrepair:context', function(data)
    openContextItem()
end)

RegisterNetEvent('dl-wrepair:RepairBlog', function(data)
    openContext()
end)

RegisterNetEvent('dl-wrepair:fixSenjata', function(data)
    local rcount = ox_inventory:Search('count', 'repairkit_senjata')
    if rcount > 0 then
        if not sibuk then
            sibuk = true
            TriggerServerEvent('dl-wrepair:delItem')
            exports.ox_inventory:Progress({
                duration = 30000,
                label = 'Memperbaiki Senjata...',
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
                    TriggerServerEvent('dl-wrepair:perbaiki', data)
                    exports['midp-tasknotify']:DoHudText('error', 'Perbaikan Senjata Berhasil!')
                    sibuk = false
                else
                    sibuk = false
                    TriggerServerEvent('midp-core:NambahItems', 'repairkit_senjata', 1)
                    exports['midp-tasknotify']:DoHudText('error', 'Perbaikan Senjata Dibatalkan!')
                end
            end)
        end
    else
        exports['midp-tasknotify']:DoHudText('error', 'Tidak Memiliki Repairkit Senjata!')
    end
end)

RegisterNetEvent('dl-wrepair:useitem', function(data)
    local rcount = ox_inventory:Search('count', 'toolkit_senjata')
    if rcount > 0 then
        TriggerServerEvent('dl-wrepair:useitem', data)
                lib.notify({
                    title = 'Success',
                    description = 'You have repaired your weapon!',
                    position = 'top',
                    duration = 3500,
                    style = {
                        backgroundColor = 'darkseagreen',
                        color = 'white'
                    },
                    icon = 'gun',
                    iconColor = 'white'
                })       
    else
        lib.notify({
            title = 'Error',
            description = 'You have repaired your weapon!',
            position = 'top',
            duration = 3500,
            style = {
                backgroundColor = 'lightcoral',
                color = 'white'
            },
            icon = 'gun',
            iconColor = 'white'
        })
    end
end)

local name = 0

--[[ local jualgenjer = {
    { x = 1272.25, y = -1711.28, z = 54.77, h = 50 }, 
} ]]

local jualsianida = {
    { x = 778.85, y = 4184.12, z = 41.79 },
}

local cuciwang = {
    { x = 1470.19, y = 6549.97, z = 14.9 },
}

Citizen.CreateThread(function()
--[[ 	for k,v in pairs(jualgenjer) do
		name = name + 1
		exports["ox_target"]:AddBoxZone("jualgenjer" .. name, vector3(v.x, v.y, v.z), 2.0, 2.0, {
		  name = "jualgenjer" .. name,
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
		  event = "jn-drugs:jualgenjer",
		  icon = "fas fa-suitcase",
		  label = "Jual Kecubung",
		  item = "proses_card",
		  job = {
			["mafia"] = 0,
			["biker"] = 0,
			["cartel"] = 0,
			["yakuza"] = 0,
			["gang"] = 0,
			["ormas"] = 0,
			["badside7"] = 0,
			["badside8"] = 0,
			["badside9"] = 0,
			["badside10"] = 0,
			["badside11"] = 0,
			["badside12"] = 0,
			["badside13"] = 0,
			["badside14"] = 0,
		}
		  },
		  },
		  distance = 2.0
		})
	  end ]]
	for k,v in pairs(jualsianida) do
        name = name + 1
        exports["ox_target"]:AddBoxZone(name, vector3(v.x, v.y, v.z), 2.0, 2.0, {
            name = name,
            heading = 91,
            debugPoly = false,
            minZ = v.z - 1.0,
            maxZ = v.z + 1.5
        }, {
            options = {
                {
                    event = "jn-drugs:jualsianida",
                    icon = "fas fa-cash-register",
                    label = "Jual Coke",
					item = "proses_card",
					job = {
						["mafia"] = 0,
						["biker"] = 0,
						["cartel"] = 0,
						["yakuza"] = 0,
						["gang"] = 0,
						["ormas"] = 0,
						["badside7"] = 0,
						["badside8"] = 0,
						["badside9"] = 0,
						["badside10"] = 0,
						["badside11"] = 0,
						["badside12"] = 0,
						["badside13"] = 0,
						["badside14"] = 0,
					}
                },
				{
                    event = "jn-drugs:jualgenjer",
                    icon = "fas fa-cash-register",
                    label = "Jual Kecubung",
					item = "proses_card",
					job = {
						["mafia"] = 0,
						["biker"] = 0,
						["cartel"] = 0,
						["yakuza"] = 0,
						["gang"] = 0,
						["ormas"] = 0,
						["badside7"] = 0,
						["badside8"] = 0,
						["badside9"] = 0,
						["badside10"] = 0,
						["badside11"] = 0,
						["badside12"] = 0,
						["badside13"] = 0,
						["badside14"] = 0,
					}
                },
            },
            distance = 2.5
        })
    end
	for k,v in pairs(cuciwang) do
        name = name + 1
        exports["ox_target"]:AddBoxZone(name, vector3(v.x, v.y, v.z), 2.0, 2.0, {
            name = name,
            heading = 91,
            debugPoly = false,
            minZ = v.z - 1.0,
            maxZ = v.z + 1.5
        }, {
            options = {
                {
                    event = "midp-illegal:Ngumbah",
                    icon = "fas fa-cash-register",
                    label = "Cuci Uang",
					item = "moneywash_card",
					job = {
						["mafia"] = 0,
						["biker"] = 0,
						["cartel"] = 0,
						["yakuza"] = 0,
						["gang"] = 0,
						["ormas"] = 0,
						["badside7"] = 0,
						["badside8"] = 0,
						["badside9"] = 0,
						["badside10"] = 0,
						["badside11"] = 0,
						["badside12"] = 0,
						["badside13"] = 0,
						["badside14"] = 0,
					}
                },
            },
            distance = 2.5
        })
    end
end)