ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while not ESX.GetPlayerData().job do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	-- Update the door list
	ESX.TriggerServerCallback('esx_doorlock:getDoorState', function(doorState)
		for index,state in pairs(doorState) do
			Config.DoorList[index].locked = state
		end
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job) ESX.PlayerData.job = job end)

RegisterNetEvent('esx_doorlock:setDoorState')
AddEventHandler('esx_doorlock:setDoorState', function(index, state) Config.DoorList[index].locked = state end)

-- Get objects every second, instead of every frame
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _,doorID in ipairs(Config.DoorList) do
			if doorID.doors then
				for k,v in ipairs(doorID.doors) do
					if not v.object or not DoesEntityExist(v.object) then
						v.object = GetClosestObjectOfType(v.objCoords, 1.0, GetHashKey(v.objName), false, false, false)
					end
				end
			else
				if not doorID.object or not DoesEntityExist(doorID.object) then
					doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, GetHashKey(doorID.objName), false, false, false)
				end
			end
		end

		Citizen.Wait(10000)
	end
end)

Citizen.CreateThread(function()
	local inZone = false
	local locked = true
	local hasAuth = false
	local shown = false
	while true do
		Citizen.Wait(10)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local sleep = true
		inZone = false

		for k,doorID in ipairs(Config.DoorList) do
			local distance

			if doorID.doors then
				distance = #(playerCoords - doorID.doors[1].objCoords)
			else
				distance = #(playerCoords - doorID.objCoords)
			end

			local isAuthorized = IsAuthorized(doorID)
			local maxDistance, size, displayText = 1.25, 1, _U('unlocked')

			if doorID.distance then
				maxDistance = doorID.distance
			end

			if distance < maxDistance then
				if doorID.doors then
					for _,v in ipairs(doorID.doors) do
						FreezeEntityPosition(v.object, doorID.locked)
						if doorID.locked and v.objYaw and GetEntityRotation(v.object).z ~= v.objYaw then
							SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
						end
						sleep = false
					end
				else
					FreezeEntityPosition(doorID.object, doorID.locked)
					if doorID.locked and doorID.objYaw and GetEntityRotation(doorID.object).z ~= doorID.objYaw then
						SetEntityRotation(doorID.object, 0.0, 0.0, doorID.objYaw, 2, true)
					end
					sleep = false
				end
			end

			if distance < maxDistance then
				inZone = true
				if doorID.size then
					size = doorID.size
				end

				if doorID.locked then
					hasAuth = true
					--displayText = _U('locked')
				else
					hasAuth = false
				end

				if isAuthorized then
					--displayText = _U('press_button', displayText)
				end

				if IsControlJustReleased(0, 38) then
					if isAuthorized then
						doorID.locked = not doorID.locked
						shown = false
						TriggerEvent("dooranim")

						TriggerServerEvent('esx_doorlock:updateState', k, doorID.locked) -- Broadcast new state of the door to everyone
					end
				end
			end
		end

		if inZone and not shown then
			shown = true
			if hasAuth then
				exports['alan-tasknotify']:Open('[E] - Locked', 'darkred', 'left')
			elseif not hasAuth then
				exports['alan-tasknotify']:Open('[E] - Unlocked', 'lightgreen', 'left')
			end
		elseif not inZone and shown then
			exports['alan-tasknotify']:Close()
			shown = false
		end

		if sleep then
			Citizen.Wait(1000)
		end
	end
end)

function IsAuthorized(doorID)
	if ESX.PlayerData.job == nil then
		return false
	end

	for _,job in pairs(doorID.authorizedJobs) do
		if job == ESX.PlayerData.job.name then
			return true
		end
	end

	return false
end

RegisterNetEvent( 'dooranim' )
AddEventHandler( 'dooranim', function()
    ClearPedSecondaryTask(GetPlayerPed(-1))
    loadAnimDict( "anim@heists@keycard@" ) 
    TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(850)
    ClearPedTasks(PlayerPedId())
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end
