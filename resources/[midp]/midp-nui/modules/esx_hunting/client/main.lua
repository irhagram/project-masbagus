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

ESX                             = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	ScriptLoaded()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

function ScriptLoaded()
	Citizen.Wait(1000)
	LoadMarkers()
end

local AnimalPositions = {
	{ x = -1505.2, y = 4887.39, z = 78.38 },
	{ x = -1164.68, y = 4806.76, z = 223.11 },
	{ x = -1410.63, y = 4730.94, z = 44.0369 },
	{ x = -1377.29, y = 4864.31, z = 134.162 },
	{ x = -1697.63, y = 4652.71, z = 22.2442 },
	{ x = -1259.99, y = 5002.75, z = 151.36 },
	{ x = -960.91, y = 5001.16, z = 183.0 },
}

local AnimalsInSession = {}
local AnimalDataId = {}

local Positions = {
	['StartHunting'] = { ['hint'] = '[E] Start Hunting', ['x'] = -769.23773193359, ['y'] = 5595.6215820313, ['z'] = 33.48571395874 },
	['Sell'] = { ['hint'] = '[E] Sell', ['x'] = 969.16375732422, ['y'] = -2107.9033203125, ['z'] = 31.475671768188 },
	['SpawnATV'] = { ['x'] = -769.63067626953, ['y'] = 5592.7573242188, ['z'] = 33.48571395874 }
}

local OnGoingHuntSession = false
local HuntCar = nil


Citizen.CreateThread(function()
	local blip = AddBlipForCoord(-769.23773193359, 5595.6215820313, 33.48571395874)

	SetBlipSprite (blip, 463)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.0)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 14)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Hunting Location')
	EndTextCommandSetBlipName(blip)

	local blip2 = AddBlipForCoord(930.9, -1807.66, 31.38)

	SetBlipSprite (blip2, 463)
	SetBlipDisplay(blip2, 4)
	SetBlipScale  (blip2, 1.0)
	SetBlipAsShortRange(blip2, true)
	SetBlipColour(blip2, 14)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Hunting Sell')
	EndTextCommandSetBlipName(blip2)

end)

function LoadMarkers()

	Citizen.CreateThread(function()
		for index, v in ipairs(Positions) do
			if index ~= 'SpawnATV' then
				local StartBlip = AddBlipForCoord(v.x, v.y, v.z)
				SetBlipSprite(StartBlip, 442)
				SetBlipColour(StartBlip, 75)
				SetBlipScale(StartBlip, 0.7)
				SetBlipAsShortRange(StartBlip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('Hunting Spot')
				EndTextCommandSetBlipName(StartBlip)
			end
		end
	end)

	LoadModel('sanchez')
	LoadModel('a_c_deer')
	LoadAnimDict('amb@medic@standing@kneel@base')
	LoadAnimDict('anim@gangops@facility@servers@bodysearch@')
end

RegisterNetEvent('alan-hunting:starthunting')
AddEventHandler('alan-hunting:starthunting', function()
	StartHuntingSession()
end)

RegisterNetEvent('alan-hunting:stophunting')
AddEventHandler('alan-hunting:stophunting', function()
	StopHuntingSession()
end)

RegisterNetEvent('alan-hunting:slaugther')
AddEventHandler('alan-hunting:slaugther', function(AnimalId)
	if OnGoingHuntSession then
		for index, value in ipairs(AnimalsInSession) do
			if DoesEntityExist(value.id) then
				local AnimalCoords = GetEntityCoords(value.id)
				local PlyCoords = GetEntityCoords(PlayerPedId())
				local AnimalHealth = GetEntityHealth(value.id)

				local PlyToAnimal = GetDistanceBetweenCoords(PlyCoords, AnimalCoords, true)

				if AnimalHealth <= 0 then
					SetBlipColour(value.Blipid, 3)

					if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_KNIFE')  then
						if DoesEntityExist(value.id) then
							table.remove(AnimalsInSession, index)
							SlaughterAnimal(value.id)
						end
					else
						ESX.ShowNotification('You need to use the knife!')
					end
				end
			end
		end
	end
end)

RegisterNetEvent('alan-hunting:huntingsell')
AddEventHandler('alan-hunting:huntingsell', function()
	SellItems()
end)

-- TODO : NEW MARKER HUNTING
local position = {x = -768.83, y = 5597.02, z = 33.6, h = 171.5}
local pedshophash = GetHashKey('a_m_y_soucent_02')
local pedsanimalhash = GetHashKey('a_c_deer')
local pedshop = {
	pedshophash
}
local pedsanimal = {
	pedsanimalhash
}

Citizen.CreateThread(function()
	Citizen.CreateThread(function()
		-- TODO : CREATE PED
		RequestModel(GetHashKey('a_m_y_soucent_02'))
		while not HasModelLoaded(GetHashKey('a_m_y_soucent_02')) do
			Wait(5)
		end
		local ped  = CreatePed(19, pedshophash, position.x, position.y, position.z-1.0, position.h, false, false)
		SetEntityInvincible(ped, true)
		SetEntityAsMissionEntity(ped, true, true)
		SetPedHearingRange(ped, 0.0)
		SetPedSeeingRange(ped, 0.0)
		SetPedAlertness(ped, 0.0)
		SetPedFleeAttributes(ped, 0, 0)
		SetBlockingOfNonTemporaryEvents(ped, true)
		SetPedCombatAttributes(ped, 46, true)
		SetPedFleeAttributes(ped, 0, 0)
		SetModelAsNoLongerNeeded(ped)
		DecorSetInt(ped,"GamemodeCar",955)
		Citizen.Wait(1000)
		FreezeEntityPosition(ped , true)
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_SMOKING", 0, true)
		exports['ox_target']:AddTargetModel(pedshop, {
			options = {
				{
					event = "alan-hunting:starthunting",
					icon = "fas fa-bullseye",
					label = "Start Hunting",
				},
				{
					event = "alan-hunting:stophunting",
					icon = "fas fa-bullseye",
					label = "Stop Hunting",
				},
				{
					event = "cancel",
					icon = "fas fa-times-circle",
					label = "Cancel",
				}
			},
			job = {"all"},
			distance = 3.0
		})
		exports['ox_target']:AddTargetModel(pedsanimal, {
			options = {
				{
					event = "alan-hunting:slaugther",
					icon = "fas fa-bullseye",
					label = "Slaugther The Animal",
				},
				{
					event = "cancel",
					icon = "fas fa-times-circle",
					label = "Cancel",
				}
			},
			job = {"all"},
			distance = 3.0
		})
		exports['ox_target']:AddBoxZone("sellhunt", vector3(929.74, -1807.56, 31.31), 1, 2.2, {
			name="sellhunt",
			heading=265,
			--debugPoly=true,
			minZ=29.11,
			maxZ=33.11
		}, {
			options = {
				{
					event = "alan-hunting:huntingsell",
					icon = "fas fa-dollar-sign",
					label = "Selling Goods",
				},
				{
					event = "cancel",
					icon = "fas fa-times-circle",
					label = "Cancel",
				}
			},
			job = {"all"},
			distance = 3.0
		})
	end)
end)

function StartHuntingSession()
	AnimalDataId = {}
	if OnGoingHuntSession == true then
		exports['midp-tasknotify']:DoHudText('error', 'you already in this job!' )
	else
		OnGoingHuntSession = true

		--Car
		HuntCar = CreateVehicle(GetHashKey('sanchez'), Positions['SpawnATV'].x, Positions['SpawnATV'].y, Positions['SpawnATV'].z, 169.79, true, false)
		exports["dl-bensin"]:SetFuel(HuntCar, 100)
		DecorSetInt(HuntCar,"GamemodeCar",955)
		SetVehicleHasBeenOwnedByPlayer(HuntCar, true)
		--TriggerEvent('persistent-vehicles/register-vehicle', HuntCar )
		--Animals
		Citizen.CreateThread(function()


			for index, value in pairs(AnimalPositions) do
				local Animal = CreatePed(5, GetHashKey('a_c_deer'), value.x, value.y, value.z, 0.0, false, false)
				DecorSetInt(Animal,"GamemodeCar",955)
				TaskWanderStandard(Animal, true, true)
				SetEntityAsMissionEntity(Animal, true, true)
				--Blips

				local AnimalBlip = AddBlipForEntity(Animal)
				SetBlipSprite(AnimalBlip, 153)
				SetBlipColour(AnimalBlip, 1)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('Deer - Animal')
				EndTextCommandSetBlipName(AnimalBlip)

				table.insert(AnimalDataId, {
					id = Animal
				})
				table.insert(AnimalsInSession, {id = Animal, x = value.x, y = value.y, z = value.z, Blipid = AnimalBlip})
			end
		end)
	end
end

function StopHuntingSession()
	if OnGoingHuntSession then

		OnGoingHuntSession = false

		RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_KNIFE"), true, true)
		--TriggerEvent('persistent-vehicles/forget-vehicle', HuntCar)
		DeleteEntity(HuntCar)

		for index, value in pairs(AnimalsInSession) do
			if DoesEntityExist(value.id) then
				DeleteEntity(value.id)
			end
		end
	end
end

function SlaughterAnimal(AnimalId)

	TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
	TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
	exports['rprogress']:Start("Menguliti Hewan", 5000)
	Citizen.Wait(10)

	ClearPedTasksImmediately(PlayerPedId())

	local AnimalWeight = math.random(10, 160) / 10

	ESX.ShowNotification('You slaughtered the animal and recieved an meat of ' ..AnimalWeight.. 'kg')
	local data1 = AnimalId
	local data2 = AnimalDataId
	TriggerServerEvent('esx-qalle-hunting:reward', AnimalWeight, data1, data2)

	DeleteEntity(AnimalId)
end

function SellItems()
	TriggerServerEvent('esx-qalle-hunting:sell')
end

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

function LoadModel(model)
    while not HasModelLoaded(model) do
          RequestModel(model)
          Citizen.Wait(10)
    end
end

function DrawM(hint, type, x, y, z)
	ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 0.4)
	DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, 2, false, false, false, false)
end