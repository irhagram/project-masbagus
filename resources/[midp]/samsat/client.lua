----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------

local PlayerData = nil
local OwnPlayerData = nil
local DependenciesLoaded = false

local Impound = Config.Impound

local GuiEnabled = false

local VehicleAndOwner = nil

local ImpoundedVehicles = nil

----------------------------------------------------------------------------------------------------
-- Setup & Initialization
----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function ()


	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	DependenciesLoaded = true
	PlayerData = ESX.GetPlayerData()
end)

function ActivateBlips()
	local blip = AddBlipForCoord(Impound.RetrieveLocation.X, Impound.RetrieveLocation.Y, Impound.RetrieveLocation.Z)
	SetBlipScale(blip, 0.7)
	SetBlipDisplay(blip, 4)
	SetBlipSprite(blip, 524)
	SetBlipColour(blip, 3)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Samsat")
    EndTextCommandSetBlipName(blip)
end

ActivateBlips()

----------------------------------------------------------------------------------------------------
-- Helper functions
----------------------------------------------------------------------------------------------------

function ShowHelpNotification(text)
    ClearAllHelpMessages()
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, false, true, 5000)
end

RegisterNetEvent('HRP:ESX:SetCharacter')
AddEventHandler('HRP:ESX:SetCharacter', function (playerData)
	OwnPlayerData = playerData
end)

RegisterNetEvent('HRP:ESX:SetVehicleAndOwner')
AddEventHandler('HRP:ESX:SetVehicleAndOwner', function (vehicleAndOwner)
	VehicleAndOwner = vehicleAndOwner
end)

RegisterNetEvent('HRP:Impound:SetImpoundedVehicles')
AddEventHandler('HRP:Impound:SetImpoundedVehicles', function (impoundedVehicles)
	ImpoundedVehicles = impoundedVehicles
end)

RegisterNetEvent('HRP:Impound:VehicleUnimpounded')
AddEventHandler('HRP:Impound:VehicleUnimpounded', function (data, index)
	local spawnLocationIndex = index % 3 + 1
	local localVehicle = json.decode(data.vehicle)
	print(localVehicle.health)
	ESX.Game.SpawnVehicle(localVehicle.model, Impound.SpawnLocations[spawnLocationIndex],
		Impound.SpawnLocations[spawnLocationIndex].h, function (spawnedVehicle)
		ESX.Game.SetVehicleProperties(spawnedVehicle, localVehicle)

		SetVehicleEngineHealth(spawnedVehicle, localVehicle.engineHealth)
		SetVehicleBodyHealth(spawnedVehicle, localVehicle.bodyHealth)
		SetVehicleFuelLevel(spawnedVehicle, localVehicle.fuelLevel)
		SetVehiclePetrolTankHealth(spawnedVehicle, localVehicle.petrolTankHealth)
		SetVehicleOilLevel(spawnedVehicle, localVehicle.oilLevel)
		SetVehicleDirtLevel(spawnedVehicle, localVehicle.dirtLevel)

		for windowIndex = 1, 13, 1 do
			Citizen.Trace("Smashing window! ")
			if(localVehicle.windows[windowIndex] == false) then
				SmashVehicleWindow(spawnedVehicle, windowIndex)
			end
		end

		for tyreIndex = 1, 7, 1 do
			Citizen.Trace("Pooppiiiin! ")
			if(localVehicle.tyresburst[tyreIndex] ~= false) then
				SetVehicleTyreBurst(spawnedVehicle, tyreIndex, true, 1000)
			end
		end

	end)
	exports['midp-tasknotify']:Alert("INFO", "Kendaraan dengan plate: " .. data.plate .. " berhasil di keluarkan!", 5000, 'error')
	SetNewWaypoint(Impound.SpawnLocations[spawnLocationIndex].x, Impound.SpawnLocations[spawnLocationIndex].y)
end)

RegisterNetEvent('HRP:Impound:CannotUnimpound')
AddEventHandler('HRP:Impound:CannotUnimpound', function ()
	exports['midp-tasknotify']:Alert("INFO", "Tidak cukup uang", 5000, 'error')
end)

----------------------------------------------------------------------------------------------------
-- NUI bs
----------------------------------------------------------------------------------------------------

RegisterNetEvent('dl-job:samsat')
AddEventHandler('dl-job:samsat', function()
	ShowImpoundMenu("store")
end)

function ShowImpoundMenu(action)

	local pos = GetEntityCoords(GetPlayerPed(PlayerId()))
	local vehicle = GetClosestVehicle(pos.x, pos.y, pos.z, 5.0, 0, 71)

	if (vehicle ~= nil) then
		local v = ESX.Game.GetVehicleProperties(vehicle)
		local data = {}

		TriggerServerEvent('HRP:ESX:GetCharacter', PlayerData.identifier)
		TriggerServerEvent('HRP:ESX:GetVehicleAndOwner', v.plate)
		Citizen.Wait(500)

		if(Config.NoPlateColumn == true) then
			Citizen.Wait(Config.WaitTime)
		end

		if(VehicleAndOwner == nil) then
			exports['midp-tasknotify']:Alert("INFO", "Kendaraan tidak di ketahui, gagal menyita!", 5000, 'error')
			return
		end

		data.action = "open"
		data.form 	= "impound"
		data.rules  = Config.Rules
		data.vehicle = {
			plate = VehicleAndOwner.plate,
			owner = VehicleAndOwner.firstname .. ' ' .. VehicleAndOwner.lastname
			}

		if (PlayerData.job.name == 'police') then
			data.officer = OwnPlayerData.firstname .. ' ' .. OwnPlayerData.lastname
			GuiEnabled = true
			SetNuiFocus(true, true)
			SendNuiMessage(json.encode(data))
		end
	else
		exports['midp-tasknotify']:Alert("INFO", "tidak ada kendaraan", 5000, 'error')
	end

end

function ShowAdminTerminal ()
	PlayerData = ESX.GetPlayerData()
	GuiEnabled = true

	TriggerServerEvent('HRP:Impound:GetVehicles')
	Citizen.Wait(500)

	SetNuiFocus(true, true)
	local data = {
		action = "open",
		form = "admin",
		user = OwnPlayerData,
		job = PlayerData.job,
		vehicles = ImpoundedVehicles
	}

	SendNuiMessage(json.encode(data))
end

function DisableImpoundMenu ()
	GuiEnabled = false
	SetNuiFocus(false)
	SendNuiMessage("{\"action\": \"close\", \"form\": \"none\"}")
	OwnPlayerData = nil
	VehicleAndOwner = nil
	ImpoundedVehicles = nil
end

function ShowRetrievalMenu ()

	PlayerData = ESX.GetPlayerData()

	TriggerServerEvent('HRP:ESX:GetCharacter', PlayerData.identifier)
	TriggerServerEvent('HRP:Impound:GetImpoundedVehicles', PlayerData.identifier)
	Citizen.Wait(500)

	GuiEnabled = true
	SetNuiFocus(true, true)
	local data = {
		action = "open",
		form = "retrieve",
		user = OwnPlayerData,
		job = PlayerData.job,
		vehicles = ImpoundedVehicles
	}

	SendNuiMessage(json.encode(data))
end

local positionsamsat = {
	{x = 409.0, y = -1622.8, z = 29.28, h = 54.84}
}

local nameid = 0

Citizen.CreateThread(function()
	for k,v in pairs(positionsamsat) do
		nameid = nameid + 1
		exports["ox_target"]:AddBoxZone("positionsamsat" .. nameid, vector3(v.x, v.y, v.z), 2.0, 2.0, {
			name = "positionsamsat" .. nameid,
			heading = v.h,
			debugPoly = false,
			minZ = v.z - 1.0,
			maxZ = v.z + 2.0
		}, {
			options = {
			{
				event = "dl-impound:openmenubiasa",
				icon = "fas fa-car",
				label = "Cek Sitaan",
			},
			{
				event = "dl-impound:openmenuadmin",
				icon = "fas fa-screwdriver",
				label = "Sitaan",
				job = "police",
			},
			},
			distance = 2.0
		})
	end
end)

RegisterNetEvent('dl-impound:openmenubiasa')
AddEventHandler('dl-impound:openmenubiasa', function()
	ShowRetrievalMenu()
end)

RegisterNetEvent('dl-impound:openmenuadmin')
AddEventHandler('dl-impound:openmenuadmin', function()
--[[ 	local Data = ESX.GetPlayerData()
	if Data.job.name == 'police' then ]]
		ShowAdminTerminal("admin")
--[[ 	else
		exports['midp-tasknotify']:SendAlert('error', 'Tidak Ada Aksess')
	end ]]
end)


RegisterNUICallback('escape', function(data, cb)
	DisableImpoundMenu()

    -- cb('ok')
end)

RegisterNUICallback('impound', function(data, cb)
	local v = ESX.Game.GetClosestVehicle()
	local veh = ESX.Game.GetVehicleProperties(v)

	veh.engineHealth = GetVehicleEngineHealth(v)
	veh.bodyHealth = GetVehicleBodyHealth(v)
	veh.fuelLevel = GetVehicleFuelLevel(v)
	veh.oilLevel = GetVehicleOilLevel(v)
	veh.petrolTankHealth = GetVehiclePetrolTankHealth(v)
	veh.tyresburst = {}
	for i = 1, 7 do
		res = IsVehicleTyreBurst(v, i, false)
		if res ~= nil then
			veh.tyresburst[#veh.tyresburst+1] = res
			if res == false then
				res = IsVehicleTyreBurst(v, i, true)
				veh.tyresburst[#veh.tyresburst] = res
			end
		else
			veh.tyresburst[#veh.tyresburst+1] = false
		end
	end

	veh.windows = {}
	for i = 1, 13 do
		res = IsVehicleWindowIntact(v, i)
		if res ~= nil then
			veh.windows[#veh.windows+1] = res
		else
			veh.windows[#veh.windows+1] = true
		end
	end

	if (veh.plate:gsub("%s+", "") ~= data.plate:gsub("%s+", "")) then
		exports['midp-tasknotify']:Alert("INFO", "kendaraan tidak cocok", 5000, 'error')
		return
	end

	data.vehicle = json.encode(veh)
	data.identifier = VehicleAndOwner.identifier

	TriggerServerEvent('HRP:Impound:ImpoundVehicle', data)

	ESX.Game.DeleteVehicle(ESX.Game.GetClosestVehicle())

	DisableImpoundMenu()
    -- cb('ok')
end)

RegisterNUICallback('unimpound', function(plate, cb)
	Citizen.Trace("Unimpounding:" .. plate)
	TriggerServerEvent('HRP:Impound:UnimpoundVehicle', plate)
	DisableImpoundMenu()
end)

RegisterNUICallback('unlock', function(plate, cb)
	TriggerServerEvent('HRP:Impound:UnlockVehicle', plate)
end)

--[[Citizen.CreateThread(function()
	while true do
		Wait(0)
		DrawMarker(36, 409.96, -1622.75, 29.29, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 191, 255, 100, false, true, 2, false, false, false, false)
	end
end)]]
----------------------------------------------------------------------------------------------------
-- Background tasks
----------------------------------------------------------------------------------------------------

-- Decide what the player is currently doing and showing a help notification.
--[[Citizen.CreateThread(function ()

	while true do
		inZone = false;
		Citizen.Wait(500)
		if(DependenciesLoaded) then
			local PlayerPed = GetPlayerPed(PlayerId())
			local PlayerPedCoords = GetEntityCoords(PlayerPed)

			if (GetDistanceBetweenCoords(Impound.RetrieveLocation.X, Impound.RetrieveLocation.Y, Impound.RetrieveLocation.Z,
				PlayerPedCoords.x, PlayerPedCoords.y, PlayerPedCoords.z, false) < 3) then

				inZone = true;

				if (CurrentAction ~= "retrieve") then

					CurrentAction = "retrieve"
					ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ To unimpound a vehicle");

				end

			elseif (GetDistanceBetweenCoords(Impound.StoreLocation.X, Impound.StoreLocation.Y, Impound.StoreLocation.Z,
				PlayerPedCoords.x, PlayerPedCoords.y, PlayerPedCoords.z, false) < 3) then

				inZone = true;

				if (CurrentAction ~= "store" and (PlayerData.job.name == "police" or PlayerData.job.name == "mecano")) then

					CurrentAction = "store"
					ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ To impound this vehicle");

				end

			else
				for i, location in ipairs(Impound.AdminTerminalLocations) do
					if (GetDistanceBetweenCoords(location.x, location.y, location.z,
					PlayerPedCoords.x, PlayerPedCoords.y, PlayerPedCoords.z, false) < 3) then

						inZone = true;

						if (CurrentAction ~= "admin" and (PlayerData.job.name == "police" or PlayerData.job.name == "mecano")) then

							CurrentAction = "admin"
							ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ To open the admin terminal");
						end

						break;
					end
				end
			end
		end

		if not inZone then
			CurrentAction = nil;
		end
	end
end)--]]

--[[Citizen.CreateThread(function ()

	while true do
		Citizen.Wait(0)

		local letSleep = true

		if DependenciesLoaded then
			local PlayerPed = PlayerPedId()
			local PlayerPedCoords = GetEntityCoords(PlayerPed)

			if (GetDistanceBetweenCoords(Impound.RetrieveLocation.X, Impound.RetrieveLocation.Y, Impound.RetrieveLocation.Z, PlayerPedCoords.x, PlayerPedCoords.y, PlayerPedCoords.z, false) < 3) then

				letSleep = false

				if (CurrentAction ~= "retrieve") then
					CurrentAction = "retrieve"
					ESX.ShowHelpNotification("Tekan ~INPUT_CONTEXT~ untuk mengecek sitaan")
				end
			elseif (GetDistanceBetweenCoords(Impound.StoreLocation.X, Impound.StoreLocation.Y, Impound.StoreLocation.Z, PlayerPedCoords.x, PlayerPedCoords.y, PlayerPedCoords.z, false) < 3) then
			
				letSleep = false

				if (CurrentAction ~= "store" and (PlayerData.job.name == "police" or PlayerData.job.name == "mechanic")) then
					CurrentAction = "store"
					ESX.ShowHelpNotification("Tekan ~INPUT_CONTEXT~ untuk menyita kendaraan")
				end
			else
				for i, location in ipairs(Impound.AdminTerminalLocations) do
					if (GetDistanceBetweenCoords(location.x, location.y, location.z,
						PlayerPedCoords.x, PlayerPedCoords.y, PlayerPedCoords.z, false) < 3) then

						letSleep = false

						if (CurrentAction ~= "admin" and (PlayerData.job.name == "police" or PlayerData.job.name == "mechanic")) then

							CurrentAction = "admin"
							ESX.ShowHelpNotification("Tekan ~INPUT_CONTEXT~ membuka")
						end
					end
				end
			end

			if letSleep then
				CurrentAction = nil
				Citizen.Wait(500)
			end
		end
	end
end)

--[[Citizen.CreateThread(function ()

	while true do
		Citizen.Wait(0)
		if (IsControlJustReleased(0, 38)) then
			if (CurrentAction == "retrieve") then
				ShowRetrievalMenu()
			elseif (CurrentAction == "store") then
				ShowImpoundMenu("store")
			elseif (CurrentAction == "admin") then
				ShowAdminTerminal("admin")
			end
		end
	end
end)]]

-- Disable background actions if the player is currently in a menu
Citizen.CreateThread(function()
  while true do
    if GuiEnabled then
      local ply = GetPlayerPed(-1)
      local active = true
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisableControlAction(0, 24, active) -- Attack
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
      if IsDisabledControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
        SendNUIMessage({type = "click"})
      end
    end
    Citizen.Wait(0)
  end
end)

function dump(o)
	if type(o) == 'table' then
	   local s = '{ '
	   for k,v in pairs(o) do
		  if type(k) ~= 'number' then k = '"'..k..'"' end
		  s = s .. '['..k..'] = ' .. dump(v) .. ','
	   end
	   return s .. '} '
	else
	   return tostring(o)
	end
 end
