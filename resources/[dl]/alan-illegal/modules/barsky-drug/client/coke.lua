local spawnedCoke = 0
local CokePlants = {}
local isPickingUp, isProcessing = false, false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CokeField.coords, true) < 50 then
			SpawnCokePlants()
			Citizen.Wait(500)
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('dl-drugs:prosescoke', function()
	ProcessCoke()
end)

function ProcessCoke()
	isProcessing = true

	exports['alan-tasknotify']:SendAlert('inform', 'Proses Coke > Coke Powder...')
	exports['mythic_progbar']:Progress({
		name = "weed_farm",
		duration = 5000,
		label = 'Memproses Coke',
		useWhileDead = false,
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
		TriggerServerEvent('jn-drugs:processCoke')
	end)

	local timeLeft = Config.Delays.CokeProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.CokeProcessing.coords, false) > 2 then
			exports['alan-tasknotify']:SendAlert('inform', 'Proses gagal karena anda keluar area tersebut!')
			TriggerServerEvent('jn-drugs:cancelProcessing')
			break
		end
	end

	isProcessing = false
end

exports.ox_target:AddTargetModel({`bkr_prop_coke_tablepowder`}, {
	options = {
		{
			action = function(entity) CabutCoke(entity) end,
			icon = "fas fa-cannabis",
			label = "Ambil Coke",
		},
	},
	distance = 3.5
})

--[[ exports.ox_target:AddBoxZone("prosescoke", vector3(1077.25, -2330.35, 30.25), 5, 5, {
	name = "prosescoke",
	heading = 345,
	--debugPoly = true,
	minZ = 29.25,
	maxZ = 33.25
	}, {
		options = {
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
}) ]]

CabutCoke = function(entity)
	local DoesCokeLegal, CokeID = false

	for k, v in pairs(CokePlants) do
		if v == entity then
			CokeID = k
			DoesCokeLegal = true
		end
	end

	if DoesCokeLegal and not isPickingUp then
		ESX.TriggerServerCallback('alan-core:cekJob', function(jumlah)
			if jumlah > 2 then
				ESX.TriggerServerCallback('jn-drugs:canPickUp', function(canPickUp)
					if canPickUp then
						isPickingUp = true
						exports['mythic_progbar']:Progress({
							name = "weed_farm",
							duration = 6000,
							label = 'Mencabut Coke...',
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
								table.remove(CokePlants, CokeID)
								spawnedCoke = spawnedCoke - 1
								TriggerServerEvent('jn-drugs:pickedUpCoke')
								isPickingUp = false
							end
						end)
						isPickingUp = false
					else
						isPickingUp = false
					end
					isPickingUp = false
				end, 'coke')
			else
				exports['alan-tasknotify']:DoHudText('error', 'Tidak Cukup Polisi! (minimal 3)')
			end
		end, 'police')
	end
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(CokePlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnCokePlants()
	while spawnedCoke < 15 do
		Citizen.Wait(0)
		local cokeCoords = GenerateCokeCoords()

		ESX.Game.SpawnLocalObject('bkr_prop_coke_tablepowder', cokeCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(CokePlants, obj)
			spawnedCoke = spawnedCoke + 1
		end)
	end
end

function ValidateCokeCoord(plantCoord)
	if spawnedCoke > 0 then
		local validate = true

		for k, v in pairs(CokePlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.CokeField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateCokeCoords()
	while true do
		Citizen.Wait(1)

		local cokeCoordX, cokeCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		cokeCoordX = Config.CircleZones.CokeField.coords.x + modX
		cokeCoordY = Config.CircleZones.CokeField.coords.y + modY

		local coordZ = GetCoordZCoke(cokeCoordX, cokeCoordY)
		local coord = vector3(cokeCoordX, cokeCoordY, coordZ)

		if ValidateCokeCoord(coord) then
			return coord
		end
	end
end

function GetCoordZCoke(x, y)
	local groundCheckHeights = { 70.0, 71.0, 72.0, 73.0, 74.0, 75.0, 76.0, 77.0, 78.0, 79.0, 80.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 77
end