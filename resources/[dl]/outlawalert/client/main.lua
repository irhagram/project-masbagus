notLoaded, currentStreetName, intersectStreetName, lastStreet, nearbyPeds, isPlayerWhitelisted, playerPed, playerCoords, job, rank, firstname, lastname = true
playerIsDead = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData
	GetPlayerInfo()
end)

RegisterCommand('cooba', function()
	GetPlayerInfo()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData = ESX.GetPlayerData()
    job = ESX.PlayerData.job.name
    rank = ESX.PlayerData.job.grade_label
    isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

function GetPlayerInfo()
	ESX.TriggerServerCallback('linden_outlawalert:getCharData', function(chardata)
        firstname = chardata.firstname
        lastname = chardata.lastname
        if firstname == nil then Wait(1000) end
    end)
	job = ESX.PlayerData.job.name
    rank = ESX.PlayerData.job.grade_label
    isPlayerWhitelisted = refreshPlayerWhitelisted()
end

AddEventHandler('esx:onPlayerDeath', function(data)
	playerIsDead = true
end)

AddEventHandler('esx:onPlayerSpawn', function(data)
	playerIsDead = false
end)

function getStreet() return currentStreetName end
function getStreetandZone(coords)
	local currentStreetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
	currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
	playerStreetsLocation = currentStreetName
	return playerStreetsLocation
end

function refreshPlayerWhitelisted()
	if not ESX.PlayerData then return false end
	if not ESX.PlayerData.job then return false end
	if Config.Debug then return true end
	for k,v in ipairs({'police'}) do
		if v == ESX.PlayerData.job.name then
			return true
		end
	end
	return false
end

function BlacklistedWeapon(playerPed)
	for i = 1, #Config.WeaponBlacklist do
		local weaponHash = GetHashKey(Config.WeaponBlacklist[i])
		if GetSelectedPedWeapon(playerPed) == weaponHash then
			return true -- Is a blacklisted weapon
		end
	end
	return false -- Is not a blacklisted weapon
end

function GetAllPeds()
	local getPeds = {}
	local findHandle, foundPed = FindFirstPed()
	local continueFind = (foundPed and true or false)
	local count = 0
	while continueFind do
		local pedCoords = GetEntityCoords(foundPed)
		if GetPedType(foundPed) ~= 28 and not IsEntityDead(foundPed) and not IsPedAPlayer(foundPed) and #(playerCoords - pedCoords) < 80.0 then
			getPeds[#getPeds + 1] = foundPed
			count = count + 1
		end
		continueFind, foundPed = FindNextPed(findHandle)
	end
	EndFindPed(findHandle)
	return count
end

function zoneChance(type, zoneMod, street)
	if Config.DebugChance then return true end
	if not street then street = currentStreetName end
	playerCoords = GetEntityCoords(PlayerPedId())
	local zone, sendit = GetLabelText(GetNameOfZone(playerCoords.x, playerCoords.y, playerCoords.z)), false
	if not nearbyPeds then
		nearbyPeds = GetAllPeds()
	elseif nearbyPeds < 1 then if Config.Debug then print(('^1[%s] Nobody is nearby to send a report^7'):format(type)) end
		return false
	end
	if zoneMod == nil then zoneMod = 1 end
	zoneMod = (math.ceil(zoneMod+0.5))
	local hour = GetClockHours()
	if hour >= 21 or hour <= 4 then
		zoneMod = zoneMod * 1.6
		zoneMod = math.ceil(zoneMod+0.5)
	end
	zoneMod = zoneMod / (nearbyPeds / 3)
	zoneMod = (math.ceil(zoneMod+0.5))
	local sum = math.random(1, zoneMod)
	local chance = string.format('%.2f',(1 / zoneMod) * 100)..'%'

	if sum > 1 then
		if Config.Debug then print(('^1[%s] %s (%s) - %s nearby peds^7'):format(type, zone, chance, nearbyPeds)) end
		sendit = false
	else
		if Config.Debug then print(('^2[%s] %s (%s) - %s nearby peds^7'):format(type, zone, chance, nearbyPeds)) end
		sendit = true
	end
	return sendit
end

function createBlip(data)
	CreateThread(function()
		local alpha, blip = 255
		local sprite, colour = 161, 1
		if data.sprite then sprite = data.sprite end
		if data.colour then colour = data.colour end
		local entId = NetworkGetEntityFromNetworkId(data.netId)
		if data.netId and entId > 0 then
			blip = AddBlipForEntity(entId)
			SetBlipSprite(blip, sprite)
			SetBlipHighDetail(blip, true)
			SetBlipScale(blip, 1.0)
			SetBlipColour(blip, colour)
			SetBlipAlpha(blip, alpha)
			SetBlipAsShortRange(blip, false)
			SetBlipCategory(blip, 2)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(data.displayCode..' - '..data.dispatchMessage)
			EndTextCommandSetBlipName(blip)
			Wait(data.length)
			RemoveBlip(blip)
			Wait(0)
			blip = AddBlipForCoord(GetEntityCoords(entId))
		else
			data.netId = nil
			blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
		end
		
		SetBlipSprite(blip, sprite)
		SetBlipHighDetail(blip, true)
		SetBlipScale(blip, 1.0)
		SetBlipColour(blip, colour)
		SetBlipAlpha(blip, alpha)
		SetBlipAsShortRange(blip, true)
		SetBlipCategory(blip, 2)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(data.displayCode..' - '..data.dispatchMessage)
		EndTextCommandSetBlipName(blip)
		while alpha ~= 0 do
			if data.netId then Wait((data.length / 1000) * 5) else Wait((data.length / 1000) * 20) end
			alpha = alpha - 1
			SetBlipAlpha(blip, alpha)
			if alpha == 0 then
				RemoveBlip(blip)
				return
			end
		end
	end)
end

RegisterNetEvent('wf-alerts:clNotify', function(pData)
	if pData ~= nil then
		local sendit = false
		local pldata = ESX.GetPlayerData()
		for i=1, #pData.recipientList do
			if pData.recipientList[i] == ESX.PlayerData.job.name then 
				sendit = true break 
			end
		end
		if sendit and pldata ~= nil then
			Wait(1500)
			if not pData.length then pData.length = 4000 end
			pData.street = getStreetandZone(vector3(pData.coords.x, pData.coords.y, pData.coords.z))
			SendNUIMessage({action = 'display', info = pData, job = ESX.PlayerData.job.name, length = pData.length})
			PlaySound(-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 0, 0, 1)
			waypoint = vector2(pData.coords.x, pData.coords.y)
			createBlip(pData)
			Wait(pData.length+2000)
			waypoint = nil
		end
	end
end)

CreateThread(function()
	while notLoaded do Wait(0) end
	while true do
		Wait(0)
		playerCoords = GetEntityCoords(PlayerPedId())
		if currentStreetName then lastStreet = currentStreetName end
		local currentStreetHash = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
		currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
		nearbyPeds = GetAllPeds()
		Wait(500)
	end
end)

CreateThread(function()
	local vehicleWhitelist = {[0]=true,[1]=true,[2]=true,[3]=true,[4]=true,[5]=true,[6]=true,[7]=true,[8]=true,[9]=true,[10]=true,[11]=true,[12]=true,[17]=true,[19]=true,[20]=true}
	local sleep = 100
	while true do
		if not notLoaded then
			playerPed = PlayerPedId()
			if (not isPlayerWhitelisted or Config.Debug) then
				for k, v in pairs(Config.Timer) do
					if v > 0 then Config.Timer[k] = v - 1 end
				end

				if Config.Timer['Shooting'] == 0 and not BlacklistedWeapon(playerPed) and not IsPedCurrentWeaponSilenced(playerPed) and IsPedArmed(playerPed, 4) then
					sleep = 10
					if IsPedShooting(playerPed)--[[  and getStreet('Shooting', 2, currentStreetName) ]] then
						data = {dispatchCode = 'shooting', caller = 'Local', coords = playerCoords, netId = NetworkGetNetworkIdFromEntity(playerPed), length = 6000}
						TriggerServerEvent('wf-alerts:svNotify', data)
						Config.Timer['Shooting'] = Config.Shooting.Success
					else
						Config.Timer['Shooting'] = Config.Shooting.Fail
					end
				else 
					sleep = 100
				end
			end
		end
		
		Wait(sleep)
	end
end)