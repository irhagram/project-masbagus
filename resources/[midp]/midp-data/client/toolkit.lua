local Keys = {
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

local plyCoords = GetEntityCoords(PlayerPedId())
local isWithinObject = false
local oElement = {}

-- // BASIC
local InUse = false
local IsTextInUse = false
local PlyLastPos = 0
local wheelchairused = false

-- // ANIMATION
local Anim = 'sit'
local AnimScroll = 0
--gym--
local canExercise = false
local exercising = false
local procent = 0
local motionProcent = 0
local doingMotion = false
local motionTimesDone = 0




exports.ox_target:Vehicle({
	options = {
		{
			event = "alan-utility:dorongmobildepan",
			icon = "fas fa-car",
			label = "Dorong mobil dari depan",
		},
		{
			event = "alan-utility:dorongmobilbelakang",
			icon = "fas fa-car",
			label = "Dorong mobil dari belakang",
		},
        {
            icon = "fas fa-car-crash",
            label = "Flip car",
            canInteract = function(entity)
                local roll = GetEntityRoll(entity)
                if IsVehicleStuckOnRoof(entity) or (roll > 45.0 or roll < -45.0) then
                    return true
                end
                return false
            end,
            action = function(entity)
                FlipCar(entity)
            end
        }
	},
	distance = 2.0
})

	-- Fast Thread
CreateThread(function()                
	exports['ox_target']:AddTargetModel(Config_ChairBed.seats, {
        options = {
            {
                event = "ChairBedSystem:Client:Animation",
                icon = "fas fa-clipboard",
                label = "Duduk",
                anim = "sit"
            },

        },
        distance = 1.0
    })
	
	exports['ox_target']:AddTargetModel(Config_ChairBed.beds, {
        options = {
            {
                event = "ChairBedSystem:Client:Animation",
                icon = "fas fa-clipboard",
                label = "Duduk Di Kasur",
                anim = "sit"
            },
            {
                event = "ChairBedSystem:Client:Animation",
                icon = "fas fa-clipboard",
                label = "Tidur Terlentang",
                anim = "back"
            },
            {
                event = "ChairBedSystem:Client:Animation",
                icon = "fas fa-clipboard",
                label = "Tidur Tengkurap",
                anim = "stomach"
            },

        },
        distance = 2.0
    })
    local bones = {'wheel_lf', 'wheel_rf', 'wheel_lm1', 'wheel_rm1', 'wheel_lm2', 'wheel_rm2', 'wheel_lm3', 'wheel_rm3', 'wheel_lr', 'wheel_rr'}
    exports['ox_target']:AddTargetBone(bones, {
        options = {
            {
                event = 'midp-data:Mbledos',
                icon = 'fas fa-car-burst',
                label = 'Pecahin Ban',
                num = 1
            },
        },
        distance = 1
    })
end)

exports.ox_target:AddTargetModel({GetHashKey("prop_wheelchair_01")}, {
	options = {
		{
			event = "esx_ambulancejob:wheelchairsit",
			icon = "fas fa-wheelchair",
			label = "Duduk",
			num = 1
		},
		{
			event = "esx_ambulancejob:wheelchairpush",
			icon = "fas fa-wheelchair",
			label = "Dorong",
			num = 2
		},
	},
	distance = 1.4
})

RegisterNetEvent('alan-utility:dorongmobildepan')
AddEventHandler('alan-utility:dorongmobildepan', function(data)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
    local closestVehicle = data.entity
    local dimension = GetModelDimensions(GetEntityModel(closestVehicle), First, Second)

	NetworkRequestControlOfEntity(closestVehicle)
	AttachEntityToEntity(ped, closestVehicle, GetPedBoneIndex(6286), 0.0, dimension.y * -1 + 0.1 , dimension.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
	ESX.Streaming.RequestAnimDict('missfinale_c2ig_11')
	TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
	Wait(200)

	--exports['midp-tasknotify']:SendAlert('inform', 'Kamu mulai mendorong mobil,tekan W untuk maju dan A/D untuk berbelok dan X untuk berhenti dorong', 10000)
	while true do
		Wait(5)
		if IsDisabledControlPressed(0, Keys["A"]) then
			TaskVehicleTempAction(PlayerPedId(), closestVehicle, 11, 1000)
		end
		if IsDisabledControlPressed(0, Keys["D"]) then
			TaskVehicleTempAction(PlayerPedId(), closestVehicle, 10, 1000)
		end
		if IsControlPressed(0, 71) then
			SetVehicleForwardSpeed(closestVehicle, -1.0)
		end
		if HasEntityCollidedWithAnything(closestVehicle) then
			--SetVehicleOnGroundProperly(closestVehicle)
			--exports['midp-tasknotify']:SendAlert('error', 'Kamu tidak bisa mendorong mobil yang terbalik!')
			DetachEntity(ped, false, false)
			StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
			FreezeEntityPosition(ped, false)
			break
		end
		if IsControlPressed(0, 105) then
			--exports['midp-tasknotify']:SendAlert('error', 'Kamu berhenti mendorong mobil')
			DetachEntity(ped, false, false)
			StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
			FreezeEntityPosition(ped, false)
			break
		end
	end
end)

RegisterNetEvent('alan-utility:dorongmobilbelakang')
AddEventHandler('alan-utility:dorongmobilbelakang', function(data)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
    local closestVehicle = data.entity
    local dimension = GetModelDimensions(GetEntityModel(closestVehicle), First, Second)

	NetworkRequestControlOfEntity(closestVehicle)
	AttachEntityToEntity(PlayerPedId(), closestVehicle, GetPedBoneIndex(6286), 0.0, dimension.y - 0.3, dimension.z  + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
	ESX.Streaming.RequestAnimDict('missfinale_c2ig_11')
	TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
	Wait(200)
	
	--exports['midp-tasknotify']:SendAlert('inform', 'Kamu mulai mendorong mobil,tekan W untuk maju dan A/D untuk berbelok dan X untuk berhenti dorong', 10000)
	while true do
		Wait(5)
		if IsDisabledControlPressed(0, Keys["A"]) then
			TaskVehicleTempAction(PlayerPedId(), closestVehicle, 11, 1000)
		end
		if IsDisabledControlPressed(0, Keys["D"]) then
			TaskVehicleTempAction(PlayerPedId(), closestVehicle, 10, 1000)
		end
		if IsControlPressed(0, 71) then
			SetVehicleForwardSpeed(closestVehicle, 1.0)
		end
		if HasEntityCollidedWithAnything(closestVehicle) then
			--SetVehicleOnGroundProperly(closestVehicle)
			--exports['midp-tasknotify']:SendAlert('error', 'Kamu tidak bisa mendorong mobil yang terbalik!')
			DetachEntity(ped, false, false)
			StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
			FreezeEntityPosition(ped, false)
			break
		end
		if IsControlPressed(0, 105) then
			--exports['midp-tasknotify']:SendAlert('error', 'Kamu berhenti mendorong mobil')
			DetachEntity(ped, false, false)
			StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
			FreezeEntityPosition(ped, false)
			break
		end
	end
end)

function FlipCar(entity)
    local  coords = GetEntityCoords(entity)
    local heading = GetEntityHeading(entity)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "flipcar",
        duration = 10000,
        label = "Flip Kendaraan",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "mini@repair",
            anim = "fixing_a_ped",
        },
    }, function(status)
        if not status then
            SetEntityCoords(entity, coords, false, false, false, true)
            SetEntityHeading(entity, heading)
            SetVehicleOnGroundProperly(entity)
            ClearPedTasksImmediately(PlayerPedId())
            
        end
    end)
end

--ARMOR FUNC--
RegisterNetEvent('alan-toolkit:rompik', function()
local playerPed = PlayerPedId()
TriggerEvent('ox_inventory:closeInventory')
    exports.ox_inventory:Progress({
        duration = 8000,
        label = 'Menggunakan Rompi Kulit...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            combat = false,
            mouse = false
        },
        anim = {
            dict = 'clothingtie',
            clip = 'try_tie_positive_a'
        },
    }, function(cancel)
        if not cancel then
            SetPedArmour(playerPed, 50)
        end
    end)
end)

RegisterNetEvent('alan-toollkit:bulletproof', function()
local playerPed = PlayerPedId()
TriggerEvent('ox_inventory:closeInventory')
    exports.ox_inventory:Progress({
        duration = 10000,
        label = 'Menggunakan Armor...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            combat = false,
            mouse = false
        },
        anim = {
            dict = 'clothingtie',
            clip = 'try_tie_positive_a'
        },
    }, function(cancel)
        if not cancel then
            SetPedArmour(playerPed, 75)
        end
    end)
end)

local shakecam = {
	[`WEAPON_STUNGUN`] = 0.010,
	[`WEAPON_FLAREGUN`] = 0.000,						-- admin
	[`WEAPON_SNSPISTOL`] = 0.020,
	[`WEAPON_SNSPISTOL_MK2`] = 0.000,					-- admin
	[`WEAPON_PISTOL`] = 0.150,
	[`WEAPON_PISTOL_MK2`] = 0.110,				-- polisi
	[`WEAPON_APPISTOL`] = 0.060,				-- polisi
	[`WEAPON_COMBATPISTOL`] = 0.100,			-- polisi
	[`WEAPON_PISTOL50`] = 0.130,			-- bs
	[`WEAPON_HEAVYPISTOL`] = 0.030,
	[`WEAPON_VINTAGEPISTOL`] = 0.025,
	[`WEAPON_MARKSMANPISTOL`] = 0.030,
	[`WEAPON_REVOLVER`] = 0.550,				-- polisi
	[`WEAPON_REVOLVER_MK2`] = 0.500,		-- bs
	[`WEAPON_DOUBLEACTION`] = 0.025,
	[`WEAPON_MICROSMG`] = 0.073,			-- bs
	[`WEAPON_COMBATPDW`] = 0.045,
	[`WEAPON_SMG`] = 0.071,						-- polisi
	[`WEAPON_SMG_MK2`] = 0.055,
	[`WEAPON_ASSAULTSMG`] = 0.050,
	[`WEAPON_MACHINEPISTOL`] = 0.075,		-- bs
	[`WEAPON_MINISMG`] = 0.035,
	[`WEAPON_MG`] = 0.070,
	[`WEAPON_COMBATMG`] = 0.080,
	[`WEAPON_COMBATMG_MK2`] = 0.085,
	[`WEAPON_ASSAULTRIFLE`] = 0.060,		-- bs
	[`WEAPON_ASSAULTRIFLE_MK2`] = 0.075,
	[`WEAPON_CARBINERIFLE`] = 0.055,			-- polisi
	[`WEAPON_CARBINERIFLE_MK2`] = 0.050,		-- polisi
	[`WEAPON_ADVANCEDRIFLE`] = 0.060,
	[`WEAPON_GUSENBERG`] = 0.050,
	[`WEAPON_SPECIALCARBINE`] = 0.060,
	[`WEAPON_SPECIALCARBINE_MK2`] = 0.075,
	[`WEAPON_BULLPUPRIFLE`] = 0.050,
	[`WEAPON_BULLPUPRIFLE_MK2`] = 0.065,
	[`WEAPON_COMPACTRIFLE`] = 0.050,
	[`WEAPON_PUMPSHOTGUN`] = 0.070,
	[`WEAPON_PUMPSHOTGUN_MK2`] = 0.000,					-- admin
	[`WEAPON_SAWNOFFSHOTGUN`] = 0.060,
	[`WEAPON_ASSAULTSHOTGUN`] = 0.120,
	[`WEAPON_BULLPUPSHOTGUN`] = 0.700,			-- polisi
	[`WEAPON_DBSHOTGUN`] = 0.050,  
	[`WEAPON_AUTOSHOTGUN`] = 0.080,
	[`WEAPON_MUSKET`] = 0.040,
	[`WEAPON_HEAVYSHOTGUN`] = 0.130,
	[`WEAPON_SNIPERRIFLE`] = 0.200,
	[`WEAPON_HEAVYSNIPER`] = 3.500,				-- polisi
	[`WEAPON_HEAVYSNIPER_MK2`] = 0.000,					-- admin
	[`WEAPON_MARKSMANRIFLE`] = 0.100,
	[`WEAPON_MARKSMANRIFLE_MK2`] = 0.100,
	[`WEAPON_GRENADELAUNCHER`] = 0.080,
	[`WEAPON_RPG`] = 0.900,
	[`WEAPON_HOMINGLAUNCHER`] = 0.900,
	[`WEAPON_MINIGUN`] = 0.200,
	[`WEAPON_RAILGUN`] = 1.000,
	[`WEAPON_COMPACTLAUNCHER`] = 0.080,
	[`WEAPON_FIREWORK`] = 0.000							-- admin
}

local recoils = {
	[453432689] = 0.50, -- PISTOL
	[3219281620] = 0.30, -- PISTOL MK2					POLISI
	[1593441988] = 0.20, -- COMBAT PISTOL				POLISI
	[584646201] = 0.20, -- AP PISTOL                     POLISI
	[2578377531] = 0.30, -- PISTOL .50                       BS
	[324215364] = 0.18, -- MICRO SMG                         BS
	[736523883] = 0.16, -- SMG							POLISI
	[2024373456] = 0.1, -- SMG MK2
	[4024951519] = 0.1, -- ASSAULT SMG
	[3220176749] = 0.15, -- ASSAULT RIFLE                   BS
	[961495388] = 0.2, -- ASSAULT RIFLE MK2
	[2210333304] = 0.13, -- CARBINE RIFLE				POLISI
	[4208062921] = 0.11, -- CARBINE RIFLE MK2			POLISI
	[2937143193] = 0.1, -- ADVANCED RIFLE
	[2634544996] = 0.1, -- MG
	[2144741730] = 0.1, -- COMBAT MG
	[3686625920] = 0.1, -- COMBAT MG MK2
	[487013001] = 0.4, -- PUMP SHOTGUN
	[1432025498] = 0.0, -- PUMP SHOTGUN MK2					ADMIN 0.4
	[2017895192] = 0.7, -- SAWNOFF SHOTGUN
	[3800352039] = 0.4, -- ASSAULT SHOTGUN
	[2640438543] = 1.0, -- BULLPUP SHOTGUN				POLISI
	[911657153] = 0.1, -- STUN GUN
	[100416529] = 0.5, -- SNIPER RIFLE
	[205991906] = 0.7, -- HEAVY SNIPER					POLISI
	[177293209] = 0.0, -- HEAVY SNIPER MK2					ADMIN 0.7
	[856002082] = 1.2, -- REMOTE SNIPER
	[2726580491] = 1.0, -- GRENADE LAUNCHER
	[1305664598] = 1.0, -- GRENADE LAUNCHER SMOKE
	[2982836145] = 0.0, -- RPG
	[1752584910] = 0.0, -- STINGER
	[1119849093] = 0.01, -- MINIGUN
	[3218215474] = 0.2, -- SNS PISTOL
	[2009644972] = 0.0, -- SNS PISTOL MK2					ADMIN 0.25
	[1627465347] = 0.1, -- GUSENBERG
	[3231910285] = 0.2, -- SPECIAL CARBINE
	[-1768145561] = 0.25, -- SPECIAL CARBINE MK2
	[3523564046] = 0.5, -- HEAVY PISTOL
	[2132975508] = 0.2, -- BULLPUP RIFLE
	[-2066285827] = 0.0, -- BULLPUP RIFLE MK2				ADMIN 0.25
	[137902532] = 0.4, -- VINTAGE PISTOL
	[-1746263880] = 0.4, -- DOUBLE ACTION REVOLVER
	[2828843422] = 0.7, -- MUSKET
	[984333226] = 0.2, -- HEAVY SHOTGUN
	[3342088282] = 0.3, -- MARKSMAN RIFLE
	[1785463520] = 0.35, -- MARKSMAN RIFLE MK2
	[1672152130] = 0, -- HOMING LAUNCHER
	[1198879012] = 0.0, -- FLARE GUN						ADMIN 0.9
	[171789620] = 0.2, -- COMBAT PDW
	[3696079510] = 0.9, -- MARKSMAN PISTOL
  	[1834241177] = 2.4, -- RAILGUN
	[3675956304] = 0.3, -- MACHINE PISTOL					BS
	[3249783761] = 0.65, -- REVOLVER						POLISI
	[-879347409] = 0.60, -- REVOLVER MK2					BS
	[4019527611] = 0.7, -- DOUBLE BARREL SHOTGUN
	[1649403952] = 0.3, -- COMPACT RIFLE
	[317205821] = 0.2, -- AUTO SHOTGUN
	[125959754] = 0.5, -- COMPACT LAUNCHER
	[3173288789] = 0.1, -- MINI SMG		
}

local scopedWeapons = 
{
    100416529,  -- WEAPON_SNIPERRIFLE
    205991906,  -- WEAPON_HEAVYSNIPER
    3342088282, -- WEAPON_MARKSMANRIFLE
	177293209,   -- WEAPON_HEAVYSNIPER MKII
	1785463520  -- WEAPON_MARKSMANRIFLE_MK2
}

function HashInTable( hash )
    for k, v in pairs( scopedWeapons ) do 
        if ( hash == v ) then 
            return true 
        end 
    end 

    return false 
end 

function ManageReticle()
    local ped = PlayerPedId()
    local _, hash = GetCurrentPedWeapon( ped, true )
	if not HashInTable( hash ) then 
		HideHudComponentThisFrame( 14 )
	end 
end 

CreateThread(function()
	while true do
		local letsleep = 2000
		local ped = PlayerPedId()
		
		if IsPedArmed(ped, 4) then
			letsleep = 0
			local weapon = GetSelectedPedWeapon(ped)
			ManageReticle()
			DisplayAmmoThisFrame(false)
			if shakecam[weapon] then
				if IsPedShooting(ped) then
					ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', shakecam[weapon])
				end
			end
		end
		Wait(letsleep)
	end
end)

CreateThread(function()
	while true do
		local letsleep = 2000
		local ped = PlayerPedId()
		
		if IsPedArmed(ped, 4) then
			letsleep = 0
			if IsPedShooting(ped) and not IsPedDoingDriveby(ped) then
				local _,wep = GetCurrentPedWeapon(ped)
				_,cAmmo = GetAmmoInClip(ped, wep)
				if recoils[wep] and recoils[wep] ~= 0 then
					tv = 0
					repeat 
						Wait(0)
						p = GetGameplayCamRelativePitch()
						if GetFollowPedCamViewMode() ~= 4 then
							SetGameplayCamRelativePitch(p+0.1, 0.2)
						end
						tv = tv+0.1
					until tv >= recoils[wep]
				end
			end
		end
		Wait(letsleep)
	end
end)

--DAMAGE--
local damagenya = {
    {name = 'WEAPON_UNARMED', damage = 0.6},
    {name = 'WEAPON_SMALL_DOG', damage = 0.5},
    {name = 'WEAPON_ANIMAL_RETRIEVER', damage = 0.6},
    {name = 'WEAPON_ANIMAL', damage = 0.7},
    {name = 'WEAPON_FLASHLIGHT', damage = 0.7},
    {name = 'WEAPON_NIGHTSTICK', damage = 0.8},    
    {name = 'WEAPON_BAT', damage = 0.9},
    {name = 'WEAPON_WRENCH', damage = 1.0},
    {name = 'WEAPON_KNIFE', damage = 1.1},
    {name = 'WEAPON_MACHETE', damage = 1.2},
}

CreateThread(function()
    for k,v in pairs(damagenya) do
        if v.damage ~= nil then
            N_0x4757f00bc6323cfe(GetHashKey(v.name), v.damage)
        end
    end
end)

CreateThread(function()
	while true do
		Wait(5)
		DisableControlAction(0, 140, true)
	end
end)

-- Medium Thread
CreateThread(function()
    while true do
        ply = PlayerPedId()
        plyCoords = GetEntityCoords(PlayerPedId())
        Wait(1000)
    end
end)

-- Healing Thread
CreateThread(function()
    while Config_ChairBed.Healing ~= 0 do
        Wait(Config_ChairBed.Healing * 1000)
        if InUse == true then
            if oElement.fObjectIsBed == true then
                local ply = PlayerPedId()
                local health = GetEntityHealth(ply)
                if health <= 199 then
                    SetEntityHealth(ply, health + 1)
                end
            end
        end
    end
end)

RegisterNetEvent('ChairBedSystem:Client:Animation')
AddEventHandler('ChairBedSystem:Client:Animation', function(data)
    Anim = data.anim
    local hash = GetEntityModel(data.entity)
    local closestObject = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 3.0, hash, 0, 0, 0)
    local coordsObject = GetEntityCoords(closestObject)
    local distanceDiff = #(coordsObject - plyCoords)
    if (distanceDiff < 3.0 and closestObject ~= 0) then
        if (distanceDiff < 1.5) then
            oElement = {
                fObject = closestObject,
                fObjectCoords = coordsObject,
                fObjectcX = Config_ChairBed.objects.locations[hash].verticalOffsetX,
                fObjectcY = Config_ChairBed.objects.locations[hash].verticalOffsetY,
                fObjectcZ = Config_ChairBed.objects.locations[hash].verticalOffsetZ,
                fObjectDir = Config_ChairBed.objects.locations[hash].direction,
                fObjectIsBed = Config_ChairBed.objects.locations[hash].bed
            }
        end
    end
    if oElement.fObject then
        local object = oElement.fObject
        local vertx = oElement.fObjectcX
        local verty = oElement.fObjectcY
        local vertz = oElement.fObjectcZ
        local dir = oElement.fObjectDir
        local isBed = oElement.fObjectIsBed
        local objectcoords = oElement.fObjectCoords
        
        local ped = PlayerPedId()
        PlyLastPos = GetEntityCoords(ped)
        FreezeEntityPosition(object, true)
        FreezeEntityPosition(ped, true)
        InUse = true
        if isBed == false then
            if Config_ChairBed.objects.SitAnimation.dict ~= nil then
                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
                local dict = Config_ChairBed.objects.SitAnimation.dict
                local anim = Config_ChairBed.objects.SitAnimation.anim
                
                AnimLoadDict(dict, anim, ped)
            else
                TaskStartScenarioAtPosition(ped, Config_ChairBed.objects.SitAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true)
            end
        else
            if Anim == 'back' then
                if Config_ChairBed.objects.BedBackAnimation.dict ~= nil then
                    SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                    SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
                    local dict = Config_ChairBed.objects.BedBackAnimation.dict
                    local anim = Config_ChairBed.objects.BedBackAnimation.anim
                    
                    Animation(dict, anim, ped)
                else
                    TaskStartScenarioAtPosition(ped, Config_ChairBed.objects.BedBackAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true
                )
                end
            elseif Anim == 'stomach' then
                if Config_ChairBed.objects.BedStomachAnimation.dict ~= nil then
                    SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                    SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
                    local dict = Config_ChairBed.objects.BedStomachAnimation.dict
                    local anim = Config_ChairBed.objects.BedStomachAnimation.anim
                    
                    Animation(dict, anim, ped)
                else
                    TaskStartScenarioAtPosition(ped, Config_ChairBed.objects.BedStomachAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true)
                end
            elseif Anim == 'sit' then
                if Config_ChairBed.objects.BedSitAnimation.dict ~= nil then
                    SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                    SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
                    local dict = Config_ChairBed.objects.BedSitAnimation.dict
                    local anim = Config_ChairBed.objects.BedSitAnimation.anim
                    
                    Animation(dict, anim, ped)
                else
                    TaskStartScenarioAtPosition(ped, Config_ChairBed.objects.BedSitAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + 180.0, 0, true, true)
                end
            end
        end
    end
end)

RegisterCommand('ChairBedSystem:Client:Leave', function(raw)
if InUse then
    InUse = false
    ClearPedTasksImmediately(ply)
    FreezeEntityPosition(ply, false)
    
    local x, y, z = table.unpack(PlyLastPos)
    if GetDistanceBetweenCoords(x, y, z, plyCoords) < 10 then
        SetEntityCoords(ply, PlyLastPos)
    end
    oElement = {}
end
end)

function Animation(dict, anim, ped)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
    
    TaskPlayAnim(ped, dict, anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
end

--WHHELCHAIR
RegisterNetEvent('esx_ambulancejob:wheelchairspawn')
AddEventHandler('esx_ambulancejob:wheelchairspawn', function()
	if wheelchairused then
		local wheelchair = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, GetHashKey('prop_wheelchair_01'))

		if DoesEntityExist(wheelchair) then
			DeleteEntity(wheelchair)
			wheelchairused = false
		else
			Sexports['midp-tasknotify']:SendAlert('error', 'Terlalu Jauh!')
		end
		
	else
		LoadModel('prop_wheelchair_01')

		local wheelchair = CreateObject(GetHashKey('prop_wheelchair_01'), GetEntityCoords(PlayerPedId()), true)
		wheelchairused = true
	end
end)

RegisterNetEvent('esx_ambulancejob:wheelchairsit')
AddEventHandler('esx_ambulancejob:wheelchairsit', function()
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)

	local closestObject = GetClosestObjectOfType(pedCoords, 3.0, GetHashKey("prop_wheelchair_01"), false)

	if DoesEntityExist(closestObject) then
		sleep = 5

		local wheelChairCoords = GetEntityCoords(closestObject)
		local wheelChairForward = GetEntityForwardVector(closestObject)
		
		local sitCoords = (wheelChairCoords + wheelChairForward * - 0.5)

		if GetDistanceBetweenCoords(pedCoords, sitCoords, true) <= 3.0 then
			Sit(closestObject)
		end

	end
end)

RegisterNetEvent('esx_ambulancejob:wheelchairpush')
AddEventHandler('esx_ambulancejob:wheelchairpush', function()
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)

	local closestObject = GetClosestObjectOfType(pedCoords, 3.0, GetHashKey("prop_wheelchair_01"), false)

	if DoesEntityExist(closestObject) then
		sleep = 5

		local wheelChairCoords = GetEntityCoords(closestObject)
		local wheelChairForward = GetEntityForwardVector(closestObject)
		
		local pickupCoords = (wheelChairCoords + wheelChairForward * 0.3)

		if GetDistanceBetweenCoords(pedCoords, pickupCoords, true) <= 3.0 then
			PickUp(closestObject)
		end
	end
end)


Sit = function(wheelchairObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 3) then
            exports['midp-tasknotify']:SendAlert('error', 'Ada Orang!')
			return
		end
	end

	LoadAnim("missfinale_c2leadinoutfin_c_int")

	AttachEntityToEntity(PlayerPedId(), wheelchairObject, 0, 0, 0.0, 0.4, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)

	local heading = GetEntityHeading(wheelchairObject)

	while IsEntityAttachedToEntity(PlayerPedId(), wheelchairObject) do
		Wait(5)

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(PlayerPedId(), true, true)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 3) then
			TaskPlayAnim(PlayerPedId(), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 8.0, 8.0, -1, 69, 1, false, false, false)
		end

		if IsControlPressed(0, 32) then
			local x, y, z  = table.unpack(GetEntityCoords(wheelchairObject) + GetEntityForwardVector(wheelchairObject) * -0.02)
			SetEntityCoords(wheelchairObject, x,y,z)
			PlaceObjectOnGroundProperly(wheelchairObject)
		end

		if IsControlPressed(1,  34) then
			heading = heading + 0.4

			if heading > 360 then
				heading = 0
			end

			SetEntityHeading(wheelchairObject,  heading)
		end

		if IsControlPressed(1,  9) then
			heading = heading - 0.4

			if heading < 0 then
				heading = 360
			end

			SetEntityHeading(wheelchairObject,  heading)
		end

		if IsControlJustPressed(0, 73) or IsControlJustPressed(0, 23) then
			DetachEntity(PlayerPedId(), true, true)

			local x, y, z = table.unpack(GetEntityCoords(wheelchairObject) + GetEntityForwardVector(wheelchairObject) * - 0.7)

			SetEntityCoords(PlayerPedId(), x,y,z)
		end
	end
end

PickUp = function(wheelchairObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'anim@heists@box_carry@', 'idle', 3) then
			exports['midp-tasknotify']:SendAlert('error', 'Ada Orang!')
			return
		end
	end

	NetworkRequestControlOfEntity(wheelchairObject)

	LoadAnim("anim@heists@box_carry@")

	AttachEntityToEntity(wheelchairObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.00, -0.3, -0.73, 195.0, 180.0, 180.0, 0.0, false, false, true, false, 2, true)

	while IsEntityAttachedToEntity(wheelchairObject, PlayerPedId()) do
		Wait(5)

		if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
			TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
		end

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(wheelchairObject, true, true)
		end

		if IsControlJustPressed(0, 23) or IsControlJustPressed(0, 73) then
			DetachEntity(PlayerPedId(), true, true)
			DetachEntity(wheelchairObject, true, true)

		end
	end
end

GetPlayers = function()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

GetClosestPlayer = function()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance
end

LoadAnim = function(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(1)
	end
end

LoadModel = function(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		Wait(1)
	end
end

local vehicleClassWhitelist = {0, 1, 2, 3, 4, 5, 6, 7, 9}
local keyPressed = false
local handsup = false
local disableHands = false

-- TODO : HANDLER TO STOP POINT, CROUCCH AND HANDSUP
AddEventHandler('esx:onPlayerDeath', function()
    keyPressed = false
    ResetPedMovementClipset( PlayerPedId(), 0 )
end)

RegisterNetEvent('esx_base:disHands', function(val)
    disableHands = val
end)

-- TODO : RAGDOLL(LOMPAT JATOH)
local ragdoll_chance = 0.8
CreateThread(function()
	while true do
		Wait(100)
		local ped = PlayerPedId()
		if IsPedOnFoot(ped) and not IsPedSwimming(ped) and (IsPedRunning(ped) or IsPedSprinting(ped)) and not IsPedClimbing(ped) and IsPedJumping(ped) and not IsPedRagdoll(ped) then
			local chance_result = math.random()
			if chance_result < ragdoll_chance then 
				Wait(600)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
				SetPedToRagdoll(ped, 5000, 1, 2)
			else
				Wait(2000)
			end
		end
	end
end)

-- TODO : DAMAGED WALK(<160 HEALTH)
local lastHealth
CreateThread(function()
    while true do
        Wait(100)
        local curHealth = GetEntityHealth(PlayerPedId())
        if curHealth ~= lastHealth then
          if curHealth <= 150 then 
            setHurt()
          else 
            setNotHurt() 
          end
          lastHealth = curHealth
        end
    end
end)

function setHurt()
    RequestAnimSet("move_m@injured")
    repeat Wait(100) until HasAnimSetLoaded("move_m@injured")
    SetPedMovementClipset(PlayerPedId(), "move_m@injured", true)
    RemoveAnimSet("move_m@injured")
end

function setNotHurt()
    ResetPedMovementClipset(PlayerPedId())
    ResetPedWeaponMovementClipset(PlayerPedId())
    ResetPedStrafeClipset(PlayerPedId())
end

CreateThread(function()
    while true do
      DisplayRadar(GetVehiclePedIsIn(PlayerPedId(), false) > 0)
      Wait(500)
    end
end)

-- TODO : DRIFT CONTROL
function ToggleDrift(state)
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local speed = GetEntitySpeed(vehicle) * 3.6

        if speed <= 100.0 then
            if (GetPedInVehicleSeat(vehicle, -1) == ped) and IsVehicleOnAllWheels(vehicle) and IsVehicleClassWhitelisted(GetVehicleClass(vehicle)) then
                SetVehicleReduceGrip(vehicle, state)
            elseif (GetPedInVehicleSeat(vehicle, -1) == ped) and IsVehicleClassWhitelisted(GetVehicleClass(vehicle)) and state == false then
                SetVehicleReduceGrip(vehicle, state)
            end
        end
    end
end

RegisterCommand('+drift', function() ToggleDrift(true) end)
RegisterCommand('-drift', function() ToggleDrift(false) end)

function IsVehicleClassWhitelisted(vehicleClass)
    for index, value in ipairs(vehicleClassWhitelist) do
        if value == vehicleClass then
            return true
        end
    end
    return false
end

-- TODO : HANDSUP CONTROL(NEW METHOD WITH REGISTERKEYMAP AND INTERVAL)
local hasHandsUp = false

RegisterCommand('handsup', function()
  local playerPed = PlayerPedId()
  
  if hasHandsUp == false then
      RequestAnimDict("random@mugging3")
      while not HasAnimDictLoaded("random@mugging3") do
        Wait(5)
      end

      if not IsPedInAnyVehicle(playerPed, false) 
          and not IsPedSwimming(playerPed) 
          and not IsPedShooting(playerPed) 
          and not IsPedClimbing(playerPed) 
          and not IsPedCuffed(playerPed) 
          and not IsPedDiving(playerPed) 
          and not IsPedFalling(playerPed) 
          and not IsPedJumping(playerPed) 
          and not IsPedJumpingOutOfVehicle(playerPed) 
          and IsPedOnFoot(playerPed) 
          and not IsPedUsingAnyScenario(playerPed) 
          and not IsPedInParachuteFreeFall(playerPed) then
          TaskPlayAnim(playerPed, "random@mugging3", "handsup_standing_base", 2.0, 2.0, -1, 50, 0, false, false, false)
      end
      hasHandsUp = true

      CreateThread(function()
          while hasHandsUp do
              Wait(0)
              DisablePlayerFiring(PlayerId(), true)
              DisableControlAction(0, 25, true)
              DisableControlAction(1, 140, true)
              DisableControlAction(1, 141, true)
              DisableControlAction(1, 142, true)
              SetPedPathCanUseLadders(playerPed, false)
              if IsPedInAnyVehicle(playerPed, false) then
                  DisableControlAction(0, 59, true)
              end
          end
      end)
  elseif hasHandsUp == true then
      ClearPedTasks(playerPed)
      hasHandsUp = false
  end
end, false)

-- TODO GAK BISA NEMBAK DI MOBIL
local passengerDriveBy = true
CreateThread(function()
	while true do
		Wait(1)

		playerPed = GetPlayerPed(-1)
		car = GetVehiclePedIsIn(playerPed, false)
		if car then
			if GetPedInVehicleSeat(car, -1) == playerPed then
				SetPlayerCanDoDriveBy(PlayerId(), false)
			elseif passengerDriveBy then
				SetPlayerCanDoDriveBy(PlayerId(), true)
			else
				SetPlayerCanDoDriveBy(PlayerId(), false)
			end
		end
	end
end)

--GYM--
CreateThread(function()
    exports['ox_target']:AddBoxZone("gym1", vector3(-1199.69, -1571.61, 4.61), 1, 1, {
    	name="gym1",
    	heading=-55,
    	debugPoly=false,
    	minZ=4.77834,
    	maxZ=4.87834,
    	}, {
    		options = {
    			{
    				event = "barsy-gym",
    				icon = "fas fa-sign-in-alt",
    				label = "Angkat Badan",
    			}
    		},
    		distance = 2.0
    })

    exports['ox_target']:AddBoxZone("gym2", vector3(-1205.03, -1563.92, 4.61), 1, 1, {
    	name="gym2",
    	heading=-55,
    	debugPoly=false,
    	minZ=4.77834,
    	maxZ=4.87834,
    	}, {
    		options = {
    			{
    				event = "barsy-gym",
    				icon = "fas fa-sign-in-alt",
    				label = "Angkat Badan",
    			}
    		},
    		distance = 2.0
    })

    exports['ox_target']:AddBoxZone("gymP", vector3(1775.91, 2497.39, 45.82), 0.5, 2, {
    	name="gymP",
        heading = 25,
        --debugPoly = true,
        minZ = 44.82,
        maxZ = 48.82
    	}, {
    		options = {
    			{
    				event = "barsy-gym",
    				icon = "fas fa-sign-in-alt",
    				label = "Angkat Badan",
    			}
    		},
    		distance = 2.0
    })

    exports['ox_target']:AddBoxZone("gymp", vector3(-1203.91, -1570.09, 4.61), 4, 4, {
        name = "gymp",
        heading = 35,
        --debugPoly = true,
        minZ = 3.61,
        maxZ = 7.61
    	}, {
    		options = {
    			{
    				event = "barsy-gym:pushup",
    				icon = "fas fa-sign-in-alt",
    				label = "Push UP",
    			}
    		},
    		distance = 2.5
    })

    exports['ox_target']:AddBoxZone("gymPusp", vector3(1781.71, 2497.16, 45.84), 2.5, 5, {
        name = "gymPusp",
        heading = 300,
        --debugPoly = true,
        minZ = 44.84,
        maxZ = 48.84
    	}, {
    		options = {
    			{
    				event = "barsy-gym:pushup",
    				icon = "fas fa-sign-in-alt",
    				label = "Push UP",
    			}
    		},
    		distance = 2.5
    })

    exports['ox_target']:AddBoxZone("gymjARA", vector3(1777.58, 2493.87, 45.82), 2, 4, {
        name = "gymjARA",
        heading = 30,
        --debugPoly = true,
        minZ = 44.82,
        maxZ = 48.82
    	}, {
    		options = {
    			{
    				event = "barsy-gym:situp",
    				icon = "fas fa-sign-in-alt",
    				label = "sit Up",
    			}
    		},
    		distance = 2.5
    })

    exports['ox_target']:AddBoxZone("gyms", vector3(-1203.7, -1560.76, 4.62), 4, 4, {
        name = "gyms",
        heading = 35,
        --debugPoly = true,
        minZ = 3.62,
        maxZ = 7.62
    	}, {
    		options = {
    			{
    				event = "barsy-gym:situp",
    				icon = "fas fa-sign-in-alt",
    				label = "sit Up",
    			}
    		},
    		distance = 2.0
    })
end)

RegisterNetEvent('barsy-gym', function()
    local coords = GetEntityCoords(PlayerPedId())
    for i, v in pairs(Config.Locations) do
        local pos = Config.Locations[i]
        local dist = GetDistanceBetweenCoords(pos["x"], pos["y"], pos["z"] + 0.98, coords, true)
        if dist <= 1.2 and not exercising then
            startExercise(Config.Exercises[pos["exercise"]], pos)
        end
    end
end)

RegisterNetEvent('barsy-gym:pushup', function()
    local coords = GetEntityCoords(PlayerPedId())
    for i, v in pairs(Config.Locations) do
        local pos = Config.Locations[i]
        local dist = GetDistanceBetweenCoords(pos["x"], pos["y"], pos["z"] + 0.98, coords, true)
        if dist <= 1.2 and not exercising then
            startExercise(Config.Exercises[pos["pushap"]], pos)
        end
    end
end)

RegisterNetEvent('barsy-gym:situp', function()
    local coords = GetEntityCoords(PlayerPedId())
    for i, v in pairs(Config.Locations) do
        local pos = Config.Locations[i]
        local dist = GetDistanceBetweenCoords(pos["x"], pos["y"], pos["z"] + 0.98, coords, true)
        if dist <= 1.2 and not exercising then
            startExercise(Config.Exercises[pos["situp"]], pos)
        end
    end
end)

function startExercise(animInfo, pos)
    local playerPed = PlayerPedId()
    LoadDict(animInfo["idleDict"])
    LoadDict(animInfo["enterDict"])
    LoadDict(animInfo["exitDict"])
    LoadDict(animInfo["actionDict"])

    if pos["h"] ~= nil then
        SetEntityCoords(playerPed, pos["x"], pos["y"], pos["z"])
        SetEntityHeading(playerPed, pos["h"])
    end

    TaskPlayAnim(playerPed, animInfo["enterDict"], animInfo["enterAnim"], 8.0, -8.0, animInfo["enterTime"], 0, 0.0, 0, 0, 0)
    Wait(animInfo["enterTime"])

    canExercise = true
    exercising = true

    CreateThread(function()
        while exercising do
            Wait(8)
            if procent <= 24.99 then
                color = "~r~"
            elseif procent <= 49.99 then
                color = "~o~"
            elseif procent <= 74.99 then
                color = "~b~"
            elseif procent <= 100 then
                color = "~g~"
            end
            DrawText2D(0.505, 0.925, 1.0,1.0,0.33, 'LATIHAN: ~r~' ..color..procent.. '%~w~', 255, 255, 255, 255)
            DrawText2D(0.505, 0.95, 1.0,1.0,0.33, "~g~[SPACE]~w~ untuk latihan", 255, 255, 255, 255)
            DrawText2D(0.505, 0.975, 1.0,1.0,0.33, "~r~[DELETE]~w~ untuk berhenti", 255, 255, 255, 255)
        end
    end)

    CreateThread(function()
        while canExercise do
            Wait(8)
            local playerCoords = GetEntityCoords(playerPed)
            if procent <= 99 then
                TaskPlayAnim(playerPed, animInfo["idleDict"], animInfo["idleAnim"], 8.0, -8.0, -1, 0, 0.0, 0, 0, 0)
                if IsControlJustPressed(0, Keys["SPACE"]) then -- press space to train
                    canExercise = false
                    TaskPlayAnim(playerPed, animInfo["actionDict"], animInfo["actionAnim"], 8.0, -8.0, animInfo["actionTime"], 0, 0.0, 0, 0, 0)
                    AddProcent(animInfo["actionProcent"], animInfo["actionProcentTimes"], animInfo["actionTime"] - 70)
                    canExercise = true
                end
                if IsControlJustPressed(0, Keys["DELETE"]) then -- press delete to exit training
                    ExitTraining(animInfo["exitDict"], animInfo["exitAnim"], animInfo["exitTime"])
                end
            else
                TriggerEvent('esx_status:remove', 'stress', 150000)
                --exports['alan']:RemoveStress('instant', 500000)
                ExitTraining(animInfo["exitDict"], animInfo["exitAnim"], animInfo["exitTime"])
            end
        end
    end)
end

function ExitTraining(exitDict, exitAnim, exitTime)
    TaskPlayAnim(PlayerPedId(), exitDict, exitAnim, 8.0, -8.0, exitTime, 0, 0.0, 0, 0, 0)
    Wait(exitTime)
    canExercise = false
    exercising = false
    procent = 0
end

function AddProcent(amount, amountTimes, time)
    for i=1, amountTimes do
        Wait(time/amountTimes)
        procent = procent + amount
    end
end

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Wait(10)
    end
end

function DrawText2D(x, y, width, height, scale, text, r, g, b, a, outline)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

local usingOxygenMask = false

RegisterNetEvent('midp-data:tabungo2')
AddEventHandler('midp-data:tabungo2', function()
	local playerPed = GetPlayerPed(-1)
	local coords = GetEntityCoords(playerPed)
	local boneIndex = GetPedBoneIndex(playerPed, 12844)
	local boneIndex2 = GetPedBoneIndex(playerPed, 24818)

	if not usingOxygenMask then
		TriggerServerEvent('midp-core:delItem', 'tabungoksigen', 1)
		usingOxygenMask = true

		ESX.Game.SpawnObject('p_s_scuba_mask_s', {
			x = coords.x,
			y = coords.y,
			z = coords.z - 3
		}, function(object)
			ESX.Game.SpawnObject('p_s_scuba_tank_s', {
				x = coords.x,
				y = coords.y,
				z = coords.z - 3
			}, function(object2)
				AttachEntityToEntity(object2, playerPed, boneIndex2, -0.30, -0.22, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
				AttachEntityToEntity(object, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
				SetPedDiesInWater(playerPed, false)

				ESX.ShowNotification('Memakai tabung oksigen' .. '%.')

				Wait(3 * 60000)
				ESX.ShowNotification('Udara Tabung Tersisa:', '~y~', '75' .. '%.')

				Wait(3 * 60000)
				ESX.ShowNotification('Udara Tabung Tersisa', '~o~', '50' .. '%.')

				Wait(2 * 60000)
				ESX.ShowNotification('Udara Tabung Tersisa', '~o~', '25' .. '%.')

				Wait(2 * 60000)
				ESX.ShowNotification('Udara Tabung Tersisa', '~r~', '0' .. '%.')

				SetPedDiesInWater(playerPed, true)
				DeleteObject(object)
				DeleteObject(object2)
				ClearPedSecondaryTask(playerPed)
				usingOxygenMask = false
			end)
		end)
	else
		ESX.ShowNotification('o2 habis')
	end
end)

--ANCURIN BAN--
local Senjata = {
    `WEAPON_KNIFE`,
    `WEAPON_BOTTLE`,
    `WEAPON_DAGGER`,
    `WEAPON_HATCHET`,
    `WEAPON_MACHETE`,
    `WEAPON_SWITCHBLADE`
}

RegisterNetEvent('midp-data:Mbledos', function()
    local vehicle = GetClosestVehicleToPlayer()
    if vehicle ~= 0 then
        if CanUseWeapon(Senjata) then
            local closestTire = GetClosestVehicleTire(vehicle)
            if closestTire ~= nil then
                if IsVehicleTyreBurst(vehicle, closestTire.tireIndex, 0) == false then
                    local animDict = 'melee@knife@streamed_core_fps'
                    local animName = 'ground_attack_on_spot'
                    loadDict('melee@knife@streamed_core_fps')
                    local animDuration = GetAnimDuration(animDict, animName)
                    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, animDuration, 15, 1.0, 0, 0, 0)
                    Wait((animDuration / 2) * 1000)
                    local driverId = GetDriverOfVehicle(vehicle)
                    local driverServId = GetPlayerServerId(driverId)
                    if driverServId == 0 then
                        SetEntityAsMissionEntity(vehicle, true, true)
                        SetVehicleTyreBurst(vehicle, closestTire.tireIndex, 0, 100.0)
                        SetEntityAsNoLongerNeeded(vehicle)
                    else
                        TriggerServerEvent('midp-data:sync', driverServId, closestTire.tireIndex)
                    end
                    Wait((animDuration / 2) * 1000)
                    ClearPedTasks(PlayerPedId())
                    RemoveAnimDict(animDict)
                else
                    exports['midp-tasknotify']:SendAlert('error', 'Ban Sudah Pecah!')
                end
            end
        else
            exports['midp-tasknotify']:SendAlert('error', 'Membutuhkan Senjata Tajam')
        end
    end
end)

RegisterNetEvent('midp-data:sync')
AddEventHandler('midp-data:sync', function(tireIndex)
	exports['midp-tasknotify']:SendAlert('inform', 'Seseorang Memecahkan Ban mu!')
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	SetVehicleTyreBurst(vehicle, tireIndex, 0, 100.0)
end)

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
    return dict
end

GetClosestVehicleToPlayer = function()
	local plyPed = PlayerPedId()
	local plyPos = GetEntityCoords(plyPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.0, 0.0)
	local radius = 3.0
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, radius, 10, plyPed, 7)
	local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
	return vehicle
end

CanUseWeapon = function(allowedWeapons)
	local plyPed = PlayerPedId()
	local plyCurrentWeapon = GetSelectedPedWeapon(plyPed)
	for i = 1, #allowedWeapons do
		if allowedWeapons[i] == plyCurrentWeapon then
			return true
		end
	end
	return false
end

GetDriverOfVehicle = function(vehicle)
	local driver = GetPedInVehicleSeat(vehicle, -1)
    if driver then
        if IsPedAPlayer(driver) then
            local plyId = NetworkGetPlayerIndexFromPed(driver)
            if NetworkGetPlayerIndexFromPed(driver) > 0 then
                return plyId
            else
                return -1
            end
        else
            return -1
        end
    else
        return -1
	end
end

GetClosestVehicleTire = function(vehicle)
	local tireBones = {"wheel_lf", "wheel_rf", "wheel_lm1", "wheel_rm1", "wheel_lm2", "wheel_rm2", "wheel_lm3", "wheel_rm3", "wheel_lr", "wheel_rr"}
	local tireIndex = {
		["wheel_lf"] = 0,
		["wheel_rf"] = 1,
		["wheel_lm1"] = 2,
		["wheel_rm1"] = 3,
		["wheel_lm2"] = 45,
		["wheel_rm2"] = 47,
		["wheel_lm3"] = 46,
		["wheel_rm3"] = 48,
		["wheel_lr"] = 4,
		["wheel_rr"] = 5,
	}
	local plyPed = PlayerPedId()
	local plyPos = GetEntityCoords(plyPed, false)
	local minDistance = 1.0
	local closestTire = nil
	
	for a = 1, #tireBones do
		local bonePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tireBones[a]))
		local distance = #(plyPos - vector3(bonePos.x, bonePos.y, bonePos.z))

		if closestTire == nil then
			if distance <= minDistance then
				closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			end
		else
			if distance < closestTire.boneDist then
				closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			end
		end
	end

	return closestTire
end