ESX	= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

--[[ QUESTION ANTI RP -- @DiiiaZoTe EDITED AND UPDATED BY MASBAGUS ]]
-- ***************** NUI Variables
local questionOpen = false

-- ***************** Spawning
--[[RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
  TriggerServerEvent('antirpquestion:didQuestion')
end)]]

RegisterNetEvent('antirpquestion:notMade')
AddEventHandler('antirpquestion:notMade', function()
	openGui()
	questionOpen = true
end)

-- ***************** Player Reward
RegisterNetEvent('masbagus:giveRewards')
AddEventHandler('masbagus:giveRewards', function()
  local generatedPlate = GeneratePlate()
  local playerPed = PlayerPedId()

  TriggerServerEvent('antirpquestion:success', generatedPlate)

  ESX.Game.SpawnVehicle(Config.vehicleModel, Config.Zones.CarSpawn.Pos, Config.Zones.CarSpawn.Heading, function(vehicle)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    SetVehicleNumberPlateText(vehicle, generatedPlate)
	exports['alan-kunci']:givePlayerKeys(GetVehicleNumberPlateText(vehicle), true)
    FreezeEntityPosition(playerPed, false)
    SetEntityVisible(playerPed, true)
  end)
end)

-- ***************** Open Gui and Focus NUI
function openGui()
  SetNuiFocus(true)
  SendNUIMessage({openQuestion = true})
end

-- ***************** Close Gui and disable NUI
function closeGui()
  questionOpen = false
  SetNuiFocus(false)
  SendNUIMessage({openQuestion = false})
end

-- ***************** Disable controls while GUI open
Citizen.CreateThread(function()
  while true do
    if questionOpen then
      local ply = GetPlayerPed(-1)
      local active = true
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
      if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
        SendNUIMessage({type = "click"})
      end
    end
    Citizen.Wait(0)
  end
end)

-- ***************** NUI Callback Methods
-- Callbacks pages opening

RegisterNUICallback('question', function(data, cb)
  SendNUIMessage({openSection = "question"})
  cb('ok')
end)

-- Callback actions triggering server events
RegisterNUICallback('close', function(data, cb)
  -- if question success
  closeGui()
  TriggerEvent('masbagus:giveRewards')
  cb('ok')
end)

RegisterNUICallback('kick', function(data, cb)
  closeGui()
  cb('ok')
end)

-- Generate random plate number
local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		if Config.PlateUseSpace then
			generatedPlate = string.upper(GetRandomLetter(1) .. ' ' .. GetRandomNumber(3) .. ' ' .. GetRandomLetter(2))
		else
			generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers))
		end

		ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function(isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end

-- mixing async with sync tasks
function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Citizen.Wait(0)
	end

	return callback
end

function GetRandomNumber(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

--[[Citizen.CreateThread(function()

	while true do 
		Citizen.Wait(0)

		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local dist = #(coords - Config.Zones.MarkerCoords)
		local letSleep = true

		if dist < 100 then
			letSleep = false
			DrawMarker(20, Config.Zones.MarkerCoords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 140, 255, 100, false, true, 2, true, false, false, false)
		elseif letSleep then
			Citizen.Wait(500)
		end

		if dist <= 2 then
			ESX.ShowHelpNotification('Test Tekan ~INPUT_CONTEXT~')
			if IsControlJustReleased(0, 38) then
				TriggerServerEvent('antirpquestion:didQuestion')
			end
		end
	end
end)]]

RegisterNetEvent('ujian')
AddEventHandler('ujian', function()
	TriggerServerEvent('antirpquestion:didQuestion')
end)