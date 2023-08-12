local PoliceJob 				= 'police'

local isTackling				= false
local isGettingTackled			= false

local tackleLib					= 'missmic2ig_11'
local tackleAnim 				= 'mic_2_ig_11_intro_goon'
local tackleVictimAnim			= 'mic_2_ig_11_intro_p_one'

local lastTackleTime			= 0
local isRagdoll					= false

CreateThread(function()
	while true do
		Wait(0)
		
		if isRagdoll then
			SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
		else
			Wait(500)
		end
	end
end)

RegisterNetEvent('esx_kekke_tackle:getTackled')
AddEventHandler('esx_kekke_tackle:getTackled', function(target)
	isGettingTackled = true

	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	RequestAnimDict(tackleLib)

	while not HasAnimDictLoaded(tackleLib) do
		Wait(10)
	end

	AttachEntityToEntity(playerPed, targetPed, 11816, 0.25, 0.5, 0.0, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
	TaskPlayAnim(playerPed, tackleLib, tackleVictimAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

	Wait(3000)
	DetachEntity(playerPed, true, false)

	isRagdoll = true
	Wait(3000)
	isRagdoll = false

	isGettingTackled = false
end)

RegisterNetEvent('esx_kekke_tackle:playTackle')
AddEventHandler('esx_kekke_tackle:playTackle', function()
	local playerPed = PlayerPedId()
	RequestAnimDict(tackleLib)
	while not HasAnimDictLoaded(tackleLib) do
		Wait(10)
	end

	TaskPlayAnim(playerPed, tackleLib, tackleAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)
	Wait(3000)
	isTackling = false
end)

-- Main thread
CreateThread(function()
	while true do
		Wait(0)

		if IsControlPressed(0, Keys['LEFTSHIFT']) and IsControlPressed(0, Keys['G']) and not isTackling and GetGameTimer() - lastTackleTime > 10 * 1000 and ESX.PlayerData.job.name == PoliceJob then
			Wait(10)
			local closestPlayer, distance = ESX.Game.GetClosestPlayer()

			if distance ~= -1 and distance <= Config.TackleDistance and not isTackling and not isGettingTackled and not IsPedInAnyVehicle(PlayerPedId()) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then
				isTackling = true
				lastTackleTime = GetGameTimer()

				TriggerServerEvent('esx_kekke_tackle:tryTackle', GetPlayerServerId(closestPlayer))
			end
		end
	end
end)