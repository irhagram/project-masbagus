-- This entire file is a modified ped spawner that we 
-- use in many resources to create and manage peds. 
-- They're spawned in when you're close, and removed 
-- when you leave the area, reducing overhead on your server.

-- I wouldn't touch this unless you know what you're doing.


local spawnedPeds = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		for k,v in pairs(Kartu.NPCList) do
			local playerCoords = GetEntityCoords(PlayerPedId())
			local distance = #(playerCoords - v.coords.xyz)
			if distance < Kartu.DistanceSpawn and not spawnedPeds[k] then
				local spawnedPed = NearPed(v.model, v.coords, v.gender, v.animDict, v.animName, v.scenario)
				spawnedPeds[k] = { spawnedPed = spawnedPed }
				-- the "role" defined in Config is checked here, and then we apply a ox_target to it to open the menu to request an id
				if v.role == 'license' then 
					exports['ox_target']:AddTargetModel("license", spawnedPed, {
						name="license",
						heading=GetEntityHeading(spawnedPed),
						debugPoly=false,
					}, {
						options = {
							{
								event = "dl-jobs:pilihkerja",
								icon = "fa-solid fa-id-card",
								label = "Ambil Jobs",
							},
						},
						distance = 2.5 
					})
				end
			end
			if distance >= Kartu.DistanceSpawn and spawnedPeds[k] then
				if Kartu.FadeIn then
					for i = 255, 0, -51 do
						Citizen.Wait(50)
						SetEntityAlpha(spawnedPeds[k].spawnedPed, i, false)
					end
				end
				SetEntityAsNoLongerNeeded(spawnedPeds[k].spawnedPed)
				DeletePed(spawnedPeds[k].spawnedPed)
				spawnedPeds[k] = nil
			end
		end
	end
end)

function NearPed(model, coords, gender, animDict, animName, scenario)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(50)
	end
	if Kartu.MinusOne then
		spawnedPed = CreatePed(Kartu.GenderNumbers[gender], model, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
	else
		spawnedPed = CreatePed(Kartu.GenderNumbers[gender], model, coords.x, coords.y, coords.z, coords.w, false, true)
	end
	SetEntityAlpha(spawnedPed, 0, false)
	if Kartu.Frozen then
		FreezeEntityPosition(spawnedPed, true)
	end
	if Kartu.Invincible then
		SetEntityInvincible(spawnedPed, true)
	end
	if Kartu.Stoic then
		SetBlockingOfNonTemporaryEvents(spawnedPed, true)
	end
	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(50)
		end
		TaskPlayAnim(spawnedPed, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end
	if scenario then
		TaskStartScenarioInPlace(spawnedPed, scenario, 0, true)
	end
	if Kartu.FadeIn then
		for i = 0, 255, 51 do
			Citizen.Wait(50)
			SetEntityAlpha(spawnedPed, i, false)
		end
	end
	SetEntityAsMissionEntity(spawnedPed, true, true)
	return spawnedPed
end
