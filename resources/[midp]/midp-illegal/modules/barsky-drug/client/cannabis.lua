local spawnedCannabis = 0
local cannabisPlants = {}
local isPickingUp, isProcessing = false, false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CannabisField.coords, true) < 50 then
			SpawncannabisPlants()
			Citizen.Wait(500)
		else
			Citizen.Wait(500)
		end
	end
end)

exports.ox_target:AddTargetModel({`prop_weed_02`}, {
	options = {
		{
			action = function(entity) CabutKecubung(entity) end,
			icon = "fas fa-cannabis",
			label = "Ambil Kecubung",
		},
	},
	distance = 3.5
})  

exports.ox_target:AddBoxZone("proseskecubung", vector3(-1072.66, 4897.8, 214.27), 2, 2, {
	name = "proseskecubung",
	heading = 320,
	debugPoly = false,
	minZ = 213.27,
	maxZ = 217.27
	}, {
		options = {
			{
				event = "midp-illegal:proKCB",
				icon = "fas fa-sign-in-alt",
				label = "Proses Kecubung",
				job = {
					["mafia"] = 0,
					["biker"] = 0,
					["cartel"] = 0,
					["yakuza"] = 0,
					["gang"] = 0,
					["ormas"] = 0,
					["badside7"] = 0,
					["badside8"] = 0,
					["badside9"] = 0,
					["badside10"] = 0,
					["badside11"] = 0,
					["badside12"] = 0,
					["badside13"] = 0,
					["badside14"] = 0,
				}
			},
			{
				event = "dl-drugs:prosescoke",
				icon = "fas fa-sign-in-alt",
				label = "Proses Coke",
				job = {
					["mafia"] = 0,
					["biker"] = 0,
					["cartel"] = 0,
					["yakuza"] = 0,
					["gang"] = 0,
					["ormas"] = 0,
					["badside7"] = 0,
					["badside8"] = 0,
					["badside9"] = 0,
					["badside10"] = 0,
					["badside11"] = 0,
					["badside12"] = 0,
					["badside13"] = 0,
					["badside14"] = 0,
				}
			},
		},
		distance = 2
})

CabutKecubung = function(entity)
	local DoesWeedLegal, WeedID = false

	for k, v in pairs(cannabisPlants) do
		if v == entity then
			WeedID = k
			DoesWeedLegal = true
		end
	end

	if DoesWeedLegal and not isPickingUp then
		ESX.TriggerServerCallback('midp-core:cekJob', function(jumlah)
			if jumlah > 2 then
				ESX.TriggerServerCallback('jn-drugs:canPickUp', function(canPickUp)
					if canPickUp then
						isPickingUp = true
						exports['mythic_progbar']:Progress({
							name = "weed_farm",
							duration = 6000,
							label = 'Mencabut Kecubung...',
							useWhileDead = true,
							canCancel = false,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,

							},
							animation = {
								animDict = "creatures@rottweiler@tricks@",
								anim = "petting_franklin",
								flags = 49,
							},
							prop = {
							},
							propTwo = {
							},
						}, function(cancelled)
							if not cancelled then
								ESX.Game.DeleteObject(entity)
								table.remove(cannabisPlants, WeedID)
								spawnedCannabis = spawnedCannabis - 1
								TriggerServerEvent('jn-drugs:pickedUpCannabis')
								isPickingUp = false
							end
						end)
						isPickingUp = false
					else
						isPickingUp = false
					end
					isPickingUp = false
				end, 'weed')
			else
				exports['midp-tasknotify']:DoHudText('error', 'Tidak Cukup Polisi! (minimal 3)')
			end
		end, 'police')
	end
end

AddEventHandler('midp-illegal:proKCB', function()
	ProcessCannabis()
end)

function ProcessCannabis()
	isProcessing = true

	exports['midp-tasknotify']:SendAlert('inform', 'Proses Kecubung > Olahan Kecubung...')
	exports['mythic_progbar']:Progress({
		name = "weed_farm",
		duration = 5000,
		label = 'Proses Kecubung',
		useWhileDead = true,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "missheistdockssetup1clipboard@base",
			anim = "base",
			flags = 49,
		},
        prop = {
           
        },
		propTwo = {

		},
	}, function(cancelled)
		if not cancelled then
		end
		TriggerServerEvent('jn-drugs:processCannabis')
	end)

	local timeLeft = Config.Delays.CannabisProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.CannabisProcessing.coords, false) > 5 then
			exports['midp-tasknotify']:SendAlert('inform', 'Proses gagal karena anda keluar area tersebut!')
			TriggerServerEvent('jn-drugs:cancelProcessing')
			break
		end
	end

	isProcessing = false
end
		
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(cannabisPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawncannabisPlants()
	while spawnedCannabis < 15 do
		Citizen.Wait(0)
		local cannabisCoords = GenerateCannabisCoords()

		ESX.Game.SpawnLocalObject('prop_weed_02', cannabisCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(cannabisPlants, obj)
			spawnedCannabis = spawnedCannabis + 1
		end)
	end
end

function ValidateCannabisCoord(plantCoord)
	if spawnedCannabis > 0 then
		local validate = true

		for k, v in pairs(cannabisPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.CannabisField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateCannabisCoords()
	while true do
		Citizen.Wait(1)

		local cannabisCoordX, cannabisCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		cannabisCoordX = Config.CircleZones.CannabisField.coords.x + modX
		cannabisCoordY = Config.CircleZones.CannabisField.coords.y + modY

		local coordZ = GetCoordZCannabis(cannabisCoordX, cannabisCoordY)
		local coord = vector3(cannabisCoordX, cannabisCoordY, coordZ)

		if ValidateCannabisCoord(coord) then
			return coord
		end
	end
end

function GetCoordZCannabis(x, y)
	local groundCheckHeights = { 50, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0, 59.0, 60.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 53.85
end