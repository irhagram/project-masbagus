-- Carry
local carryingBackInProgress = false
local carryAnimNamePlaying = ""
local carryAnimDictPlaying = ""
local carryControlFlagPlaying = 0


-- Main Thread
Citizen.CreateThread(function()
        
  exports.ox_target:Player({
    options = {
        {
			event = "carry",
			icon = "fas fa-user-circle",
			label = "Carry 1",
		},
		{
			event = "carry2",
			icon = "fas fa-user-circle",
			label = "Carry 2",
		},
		{
			event = "carry3",
			icon = "fas fa-user-circle",
			label = "Carry 3",
		},
    },
    distance = 1.5
})
        
	SetPedHelmet(PlayerPedId(), false)

    while true do
        Citizen.Wait(10)
        local playerPed = PlayerPedId()
        local car = GetVehiclePedIsIn(playerPed, false)
		local PlayerrVeh = GetVehiclePedIsUsing(playerPed)
		-- Disable Helm Motor
		if PlayerrVeh ~= 0 then SetPedConfigFlag(playerPed, 35, false) end
 			SetPedConfigFlag(playerPed, 35, false)
		
		-- Carry Thread
		if carryingBackInProgress then 
			while not IsEntityPlayingAnim(PlayerPedId(), carryAnimDictPlaying, carryAnimNamePlaying, 3) do
				TaskPlayAnim(PlayerPedId(), carryAnimDictPlaying, carryAnimNamePlaying, 8.0, -8.0, 100000, carryControlFlagPlaying, 0, false, false, false)
				Citizen.Wait(0)
			end
		else
			Citizen.Wait(3000)
		end

		-- Shuff Thread
		if (stopPassengerShuffle) then
			if (not GetPedConfigFlag(playerPed, 184, 1)) then SetPedConfigFlag(playerPed, 184, true) end
				if (IsPedInAnyVehicle(playerPed, false)) then
					local v = GetVehiclePedIsIn(playerPed, 0)
					if (GetIsTaskActive(playerPed, 165)) then
						isShuffling = true
						if (not allowEntrySlide) then
							if (GetSeatPedIsTryingToEnter(playerPed) == -1) then
								if (GetPedConfigFlag(playerPed, 184, 1)) then
									SetPedIntoVehicle(playerPed, v, 0)
									SetVehicleCloseDoorDeferedAction(v, 0)
								end
							end
						end
					else
						isShuffling = false
					end
				end
			else
				if (GetPedConfigFlag(playerPed, 184, 1)) then SetPedConfigFlag(playerPed, 184, false) end
			end
    	end
end)

-- Carry Command
RegisterNetEvent("carry",function(data)
	if not carryingBackInProgress then
		local player = PlayerPedId()	
		lib = 'missfinale_c2mcs_1'
		anim1 = 'fin_c2_mcs_1_camman'
		lib2 = 'nm'
		anim2 = 'firemans_carry'
		distans = 0.15
		distans2 = 0.27
		height = 0.63
		spin = 0.0		
		length = 100000
		controlFlagMe = 49
		controlFlagTarget = 33
		animFlagTarget = 1
		local closestPlayer = ESX.Game.GetClosestPlayer()
		
		target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
		if closestPlayer ~= -1 and closestPlayer ~= nil then
			carryingBackInProgress = true
			TriggerServerEvent('CarryPeople:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
		else
			exports['alan-tasknotify']:SendAlert("error", "No One Nearby to Carry")
		end
	end
end)

RegisterCommand('carry', function()
	carryingBackInProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
	local closestPlayer = ESX.Game.GetClosestPlayer()
	target = GetPlayerServerId(closestPlayer)
	if target ~= 0 then 
		TriggerServerEvent("CarryPeople:stop",target)
	end
end)

RegisterNetEvent("carry2",function(data)
	local player = PlayerPedId()	
	lib = 'timetable@amanda@ig_3'
	anim1 = 'ig_3_base_tracy'
	lib2 = 'timetable@ron@ig_3_couch'
	anim2 = 'base'
	distans = 0.1
	distans2 = 0.05
	height = 0.8
	spin = 0.0		
	length = 100000
	controlFlagMe = 49
	controlFlagTarget = 33
	animFlagTarget = 1
	local closestPlayer = ESX.Game.GetClosestPlayer()
	target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
	if closestPlayer ~= -1 and closestPlayer ~= nil then
		carryingBackInProgress = true
		TriggerServerEvent('CarryPeople:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
	else
		exports['alan-tasknotify']:SendAlert("error", "No One Nearby to Carry")
	end
end)

RegisterNetEvent("carry3",function(data)
	local player = PlayerPedId()	
	lib = 'anim@heists@box_carry@'
	anim1 = 'idle'
	lib2 = 'timetable@reunited@ig_10'
	anim2 = 'base_amanda'
	distans = 0.5
	distans2 = -0.65
	height = 0.5
	spin = 90.0		
	length = 100000
	controlFlagMe = 49
	controlFlagTarget = 33
	animFlagTarget = 1
	local closestPlayer = ESX.Game.GetClosestPlayer()
	target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
	if closestPlayer ~= -1 and closestPlayer ~= nil then
		carryingBackInProgress = true
		TriggerServerEvent('CarryPeople:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
	else
		exports['alan-tasknotify']:SendAlert("error", "No One Nearby to Carry")
	end
end)

RegisterCommand("carrybocil",function(source, args)
	if not carryingBackInProgress then
		local player = PlayerPedId()	
	lib = 'anim@heists@box_carry@'
		anim1 = 'idle'
		lib2 = 'timetable@reunited@ig_10'
		anim2 = 'base_amanda'
		distans = 0.5
		distans2 = -0.25
		height = 1.1
		spin = 90.0		
		length = 100000
		controlFlagMe = 49
		controlFlagTarget = 33
		animFlagTarget = 1
		local closestPlayer = ESX.Game.GetClosestPlayer()
		target = GetPlayerServerId(closestPlayer)
		if closestPlayer ~= -1 and closestPlayer ~= nil then
			carryingBackInProgress = true
			TriggerServerEvent('CarryPeople:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
		else
			exports['alan-tasknotify']:SendAlert("error", "No One Nearby to Carry")
		end
	else
		carryingBackInProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		local closestPlayer = GetClosestPlayer(3)
		target = GetPlayerServerId(closestPlayer)
		if target ~= 0 then 
			TriggerServerEvent("CarryPeople:stop",target)
		end
	end
end,false)

RegisterCommand("carrybocil2",function(source, args)
	if not carryingBackInProgress then
		local player = PlayerPedId()	
		lib = 'timetable@amanda@ig_3'
		anim1 = 'ig_3_base_tracy'
		lib2 = 'timetable@ron@ig_3_couch'
		anim2 = 'base'
		distans = 0.3
		distans2 = 0.00
		height = 1.8
		spin = 0.0		
		length = 100000
		controlFlagMe = 49
		controlFlagTarget = 33
		animFlagTarget = 1
		local closestPlayer = GetClosestPlayer(3)
		target = GetPlayerServerId(closestPlayer)
		if closestPlayer ~= -1 and closestPlayer ~= nil then
			carryingBackInProgress = true
			TriggerServerEvent('CarryPeople:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
		else
			exports['alan-tasknotify']:SendAlert("error", "No One Nearby to Carry")
		end
	else
		carryingBackInProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		local closestPlayer = GetClosestPlayer(3)
		target = GetPlayerServerId(closestPlayer)
		if target ~= 0 then 
			TriggerServerEvent("CarryPeople:stop",target)
		end
	end
end,false)

-- End Of Command Carry

-- Event Carry
RegisterNetEvent('CarryPeople:syncTarget')
AddEventHandler('CarryPeople:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	carryingBackInProgress = true
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	AttachEntityToEntity(PlayerPedId(), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	carryAnimNamePlaying = animation2
	carryAnimDictPlaying = animationLib
	carryControlFlagPlaying = controlFlag
end)

RegisterNetEvent('CarryPeople:syncMe')
AddEventHandler('CarryPeople:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = PlayerPedId()
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	Wait(500)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	carryAnimNamePlaying = animation
	carryAnimDictPlaying = animationLib
	carryControlFlagPlaying = controlFlag
end)

RegisterNetEvent('CarryPeople:cl_stop')
AddEventHandler('CarryPeople:cl_stop', function()
	carryingBackInProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)
-- End Of Event Carry

-- Function Carry
function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function GetClosestPlayer(radius)
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
	if closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end
-- End Of Function Carry