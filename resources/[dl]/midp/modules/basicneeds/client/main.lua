local IsDead = false
local IsAnimated = false

AddEventHandler('esx_basicneeds:resetStatus', function()
	TriggerEvent('esx_status:set', 'hunger', 500000)
	TriggerEvent('esx_status:set', 'thirst', 500000)
end)


RegisterNetEvent('esx_basicneeds:healPlayer')
AddEventHandler('esx_basicneeds:healPlayer', function()
	-- restore hunger & thirst
	TriggerEvent('esx_status:set', 'hunger', 1000000)
	TriggerEvent('esx_status:set', 'thirst', 1000000)

	-- restore hp
	local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('esx:onPlayerSpawn', function(spawn)
	if IsDead then
		TriggerEvent('esx_basicneeds:resetStatus')
	end

	IsDead = false
end)

AddEventHandler('esx_status:loaded', function(status)

	TriggerEvent('esx_status:registerStatus', 'hunger', 1000000, '#CFAD0F', function(status)
		return false
	end, function(status)
		status.remove(math.random(300, 400))
	end)

	TriggerEvent('esx_status:registerStatus', 'thirst', 1000000, '#0C98F1', function(status)
		return false
	end, function(status)
		status.remove(math.random(350, 450))
	end)

	TriggerEvent('esx_status:registerStatus', 'drunk', 0, '#8F15A5', function(status)
		return false
	end, function(status)
		status.remove(math.random(350, 450))
	end)

	TriggerEvent('esx_status:registerStatus', 'stress', 10000, '#cadfff', function(status)
		return false
	end, function(status)
		status.add(math.random(5, 10))
	end)

end)

AddEventHandler('dl-status:onTick', function(data)
	local playerPed  = PlayerPedId()
	local prevHealth = GetEntityHealth(playerPed)
	local health     = prevHealth
	
	for k, v in pairs(data) do
		if v.name == 'hunger' and v.percent == 0 then
			if prevHealth <= 150 then
				health = health - 5
			else
				health = health - 1
			end
		elseif v.name == 'thirst' and v.percent == 0 then
			if prevHealth <= 150 then
				health = health - 5
			else
				health = health - 1
			end
		end
	end
	
	if health ~= prevHealth then SetEntityHealth(playerPed, health) end
end)

AddEventHandler('esx_basicneeds:isEating', function(cb)
	cb(IsAnimated)
end)

RegisterNetEvent('esx_basicneeds:onEat')
AddEventHandler('esx_basicneeds:onEat', function()
	TriggerEvent("mythic_progbar:client:progress", {
        name = "makan",
		duration = 3000,
		label = 'Makan',
		useWhileDead = true,
		canCancel = false,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "mp_player_inteat@burger",
			anim = "mp_player_int_eat_burger_fp",
			flags = 49,
		},
		prop = {

		},
		propTwo = {

		},
    }, function(status)
        if not status then
            -- Do Something If Event Wasn't Cancelled
        end
    end)
end)

RegisterNetEvent('esx_basicneeds:onDrink')
AddEventHandler('esx_basicneeds:onDrink', function()
	TriggerEvent("mythic_progbar:client:progress", {
        name = "minum",
		duration = 3000,
		label = 'Minum',
		useWhileDead = true,
		canCancel = false,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "mp_player_intdrink",
			anim = "loop_bottle",
			flags = 49,
		},
		prop = {
			
		},
		propTwo = {

		},
    }, function(status)
        if not status then

        end
    end)
end)

function Drunk(level, start)
  	CreateThread(function()
		local playerPed = PlayerPedId()
		if start then
			DoScreenFadeOut(800)
			Wait(1000)
		end
     	if level == 0 then
			RequestAnimSet("move_m@drunk@slightlydrunk")
			
			while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
				Wait(0)
			end
			SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)
		elseif level == 1 then
			RequestAnimSet("move_m@drunk@moderatedrunk")
			
			while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
				Wait(0)
			end
			SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)
		elseif level == 2 then
			RequestAnimSet("move_m@drunk@verydrunk")
			
			while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
				Wait(0)
			end
			SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)
		end
		SetTimecycleModifier("spectator5")
		SetPedMotionBlur(playerPed, true)
		SetPedIsDrunk(playerPed, true)
     	if start then
      		DoScreenFadeIn(800)
    	end
   end)
end

function Reality()
   CreateThread(function()
		local playerPed = PlayerPedId()
		DoScreenFadeOut(800)
		Wait(1000)
		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(playerPed, 0)
		SetPedIsDrunk(playerPed, false)
		SetPedMotionBlur(playerPed, false)
     	DoScreenFadeIn(800)
   	end)
end

RegisterNetEvent('esx_optionalneeds:onDrinkMabuk')
AddEventHandler('esx_optionalneeds:onDrinkMabuk', function()
  	local playerPed = PlayerPedId()
  
  	TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_DRINKING", 0, 1)
  	Wait(1000)
  	ClearPedTasksImmediately(playerPed)
end)

CreateThread(function()
	while true do
		Wait(1)
		local ped = PlayerPedId()

		TriggerEvent('esx_status:getStatus', 'stress', function(status)
			StressVal = status.val
		end)

		TriggerEvent('esx_status:getStatus', 'drunk', function(status)
			if status.val > 0 then
				local start = true
				if IsAlreadyDrunk then
					start = false
				end
				local level = 0
				if status.val <= 250000 then
					level = 0
				elseif status.val <= 500000 then
					level = 1
				else
					level = 2
				end
				if level ~= DrunkLevel then
					Drunk(level, start)
				end
				IsAlreadyDrunk = true
				DrunkLevel     = level
			end
			 if status.val == 0 then
				if IsAlreadyDrunk then
					Reality()
				end
				IsAlreadyDrunk = false
				DrunkLevel     = -1
			end
		 end)

		if StressVal == 1000000 then -- max StressVal
			SetTimecycleModifier("WATER_silty") --a bit blur and vision distance reduce
			SetTimecycleModifierStrength(1)
		else
			ClearExtraTimecycleModifier()
		end

		if StressVal >= 750000 then
			local veh = GetVehiclePedIsUsing(ped)
			  if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(veh, -1) == ped then
				Wait(2000)
				ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.05)
				TaskVehicleTempAction(ped, veh, 7, 150)
				Wait(1000)
				TaskVehicleTempAction(ped, veh, 8, 150)
				ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.05)
				Wait(1000)
				ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.05)
			  else
				Wait(3500)
				ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.05)
			  end
		elseif StressVal >= 500000 then
			local veh = GetVehiclePedIsUsing(ped)
			  if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(veh, -1) == ped then
				Wait(2000)
				ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
				TaskVehicleTempAction(ped, veh, 7, 100)
				Wait(1000)
				TaskVehicleTempAction(ped, veh, 8, 100)
				ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
				Wait(1000)
				ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
			  else
				Wait(4000)
				ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.07)
			  end
		else
			Wait(3000)
		end
	end
end)

function AddStress(method, value, seconds)
    if method:lower() == "instant" then
        TriggerServerEvent("stress:add", value)
    elseif method:lower() == "slow" then
        local count = 0
        repeat
            TriggerServerEvent("stress:add", value/seconds)
            count = count + 1
            Wait(1000)
        until count == seconds
    end
end

RegisterNetEvent('midp-core:Instan')
AddEventHandler('midp-core:Instan', function()
	exports['midp']:RemoveStress('instant', 300000)
end)

function RemoveStress(method, value, seconds)
    if method:lower() == "instant" then
        TriggerServerEvent("stress:remove", value)
    elseif method:lower() == "slow" then
        local count = 0
        repeat
            TriggerServerEvent("stress:remove", value/seconds)
            count = count + 1
            Wait(1000)
        until count == seconds
    end
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()

        local nembak = IsPedShooting(ped)
        local bawas = IsPedArmed(ped, 4)
		local status_v = IsPedInAnyVehicle(ped, false)

        if nembak then -- NEMBAK
            TriggerServerEvent("stress:add", 5000)
            Wait(2000)
        elseif bawas then --BAWA SENJATA
            TriggerServerEvent("stress:add", 1000)
            Wait(15000)
        else
            Wait(1)
        end
    end
end)