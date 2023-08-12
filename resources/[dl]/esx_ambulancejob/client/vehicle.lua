local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
local IsBusy = false
local spawnedVehicles, isInShopMenu = {}, false

function OpenVehicleSpawnerMenu(hospital, partNum)
	local playerCoords = GetEntityCoords(PlayerPedId())
	local elements = {
		{label = _U('garage_storeditem'), action = 'garage'},
		{label = _U('garage_storeitem'), action = 'store_garage'},
		{label = _U('garage_buyitem'), action = 'buy_vehicle'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle', {
		title    = _U('garage_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.action == 'buy_vehicle' then
			local shopCoords = Config.Hospitals[hospital].Vehicles[partNum].InsideShop
			local shopElements = {}

			local authorizedVehicles = Config.AuthorizedVehicles[ESX.PlayerData.job.grade_name]

			if #authorizedVehicles > 0 then
				for k,vehicle in ipairs(authorizedVehicles) do
					table.insert(shopElements, {
						label = ('%s - <span style="color:green;">%s</span>'):format(vehicle.label, _U('shop_item', ESX.Math.GroupDigits(vehicle.price))),
						name  = vehicle.label,
						model = vehicle.model,
						price = vehicle.price,
						type  = 'car'
					})
				end
			else
				return
			end

			OpenShopMenu(shopElements, playerCoords, shopCoords)
		elseif data.current.action == 'garage' then
			local garage = {}

			ESX.TriggerServerCallback('esx_vehicleshop:retrieveJobVehicles', function(jobVehicles)
				if #jobVehicles > 0 then
					for k,v in ipairs(jobVehicles) do
						local props = json.decode(v.vehicle)
						local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(props.model))
						local label = ('%s - <span style="color:darkgoldenrod;">%s</span>: '):format(vehicleName, props.plate)

						if v.stored then
							label = label .. ('<span style="color:green;">%s</span>'):format(_U('garage_stored'))
						else
							label = label .. ('<span style="color:darkred;">%s</span>'):format(_U('garage_notstored'))
						end

						table.insert(garage, {
							label = label,
							stored = v.stored,
							model = props.model,
							vehicleProps = props
						})
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_garage', {
						title    = _U('garage_title'),
						align    = 'top-left',
						elements = garage
					}, function(data2, menu2)
						if data2.current.stored then
							local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(hospital, 'Vehicles', partNum)

							if foundSpawn then
								menu2.close()

								ESX.Game.SpawnVehicle(data2.current.model, spawnPoint.coords, spawnPoint.heading, function(vehicle)
									ESX.Game.SetVehicleProperties(vehicle, data2.current.vehicleProps)
									exports["dl-bensin"]:SetFuel(vehicle, 100)
									exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(vehicle), true)
									TriggerServerEvent('esx_vehicleshop:setJobVehicleState', data2.current.vehicleProps.plate, false)
									ESX.ShowNotification(_U('garage_released'))
								end)
							end
						else
							ESX.ShowNotification(_U('garage_notavailable'))
						end
					end, function(data2, menu2)
						menu2.close()
					end)

				else
					ESX.ShowNotification(_U('garage_empty'))
				end
			end, 'car')

		elseif data.current.action == 'store_garage' then
			StoreNearbyVehicle(playerCoords)
		end

	end, function(data, menu)
		menu.close()
	end)

end


function StoreNearbyVehicle(playerCoords)
	local vehicles, vehiclePlates = ESX.Game.GetVehiclesInArea(playerCoords, 30.0), {}

	if #vehicles > 0 then
		for k,v in ipairs(vehicles) do

			-- Make sure the vehicle we're saving is empty, or else it wont be deleted
			if GetVehicleNumberOfPassengers(v) == 0 and IsVehicleSeatFree(v, -1) then
				table.insert(vehiclePlates, {
					vehicle = v,
					plate = ESX.Math.Trim(GetVehicleNumberPlateText(v))
				})
			end
		end
	else
		ESX.ShowNotification(_U('garage_store_nearby'))
		return
	end

	ESX.TriggerServerCallback('esx_ambulancejob:storeNearbyVehicle', function(storeSuccess, foundNum)
		if storeSuccess then
			local vehicleId = vehiclePlates[foundNum]
			local attempts = 0
			ESX.Game.DeleteVehicle(vehicleId.vehicle)
			IsBusy = true

			Citizen.CreateThread(function()
				while IsBusy do
					Citizen.Wait(0)
					drawLoadingText(_U('garage_storing'), 255, 255, 255, 255)
				end
			end)

			-- Workaround for vehicle not deleting when other players are near it.
			while DoesEntityExist(vehicleId.vehicle) do
				Citizen.Wait(500)
				attempts = attempts + 1

				-- Give up
				if attempts > 30 then
					break
				end

				vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 30.0)
				if #vehicles > 0 then
					for k,v in ipairs(vehicles) do
						if ESX.Math.Trim(GetVehicleNumberPlateText(v)) == vehicleId.plate then
							ESX.Game.DeleteVehicle(v)
							break
						end
					end
				end
			end

			IsBusy = false
			ESX.ShowNotification(_U('garage_has_stored'))
		else
			ESX.ShowNotification(_U('garage_has_notstored'))
		end
	end, vehiclePlates)
end

function GetAvailableVehicleSpawnPoint(hospital, part, partNum)
	local spawnPoints = Config.Hospitals[hospital][part][partNum].SpawnPoints
	local found, foundSpawnPoint = false, nil

	for i=1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
			found, foundSpawnPoint = true, spawnPoints[i]
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		ESX.ShowNotification(_U('garage_blocked'))
		return false
	end
end

function OpenHelicopterSpawnerMenu(hospital, partNum)
	local playerCoords = GetEntityCoords(PlayerPedId())
	ESX.PlayerData = ESX.GetPlayerData()
	local elements = {
		{label = 'Garasi', action = 'garage'},
		{label = 'Simpan', action = 'store_garage'},
		{label = 'Beli', action = 'buy_helicopter'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'helicopter_spawner', {
		title    = _U('helicopter_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.action == 'buy_helicopter' then
			local shopCoords = Config.Hospitals[hospital].Helicopters[partNum].InsideShop
			local shopElements = {}

			local authorizedHelicopters = Config.AuthorizedHelicopters[ESX.PlayerData.job.grade_name]

			if #authorizedHelicopters > 0 then
				for k,helicopter in ipairs(authorizedHelicopters) do
					table.insert(shopElements, {
						label = ('%s - <span style="color:green;">%s</span>'):format(helicopter.label, _U('shop_item', ESX.Math.GroupDigits(helicopter.price))),
						name  = helicopter.label,
						model = helicopter.model,
						price = helicopter.price,
						type  = 'helicopter'
					})
				end
			else
				ESX.ShowNotification(_U('helicopter_notauthorized'))
				return
			end

			OpenShopMenu(shopElements, playerCoords, shopCoords)
		elseif data.current.action == 'garage' then
			local garage = {}

			ESX.TriggerServerCallback('esx_vehicleshop:retrieveJobVehicles', function(jobVehicles)
				if #jobVehicles > 0 then
					for k,v in ipairs(jobVehicles) do
						local props = json.decode(v.vehicle)
						local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(props.model))
						local label = ('%s - <span style="color:darkgoldenrod;">%s</span>: '):format(vehicleName, props.plate)

						if v.stored then
							label = label .. ('<span style="color:green;">%s</span>'):format(_U('garage_stored'))
						else
							label = label .. ('<span style="color:darkred;">%s</span>'):format(_U('garage_notstored'))
						end

						table.insert(garage, {
							label = label,
							stored = v.stored,
							model = props.model,
							vehicleProps = props
						})
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'helicopter_garage', {
						title    = _U('helicopter_garage_title'),
						align    = 'top-left',
						elements = garage
					}, function(data2, menu2)
						if data2.current.stored then
							local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(hospital, 'Helicopters', partNum)

							if foundSpawn then
								menu2.close()

								ESX.Game.SpawnVehicle(data2.current.model, spawnPoint.coords, spawnPoint.heading, function(vehicle)
									ESX.Game.SetVehicleProperties(vehicle, data2.current.vehicleProps)
									exports["dl-bensin"]:SetFuel(vehicle, 100)
									exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(vehicle), true)
									TriggerServerEvent('esx_vehicleshop:setJobVehicleState', data2.current.vehicleProps.plate, false)
									ESX.ShowNotification(_U('garage_released'))
								end)
							end
						else
							ESX.ShowNotification(_U('garage_notavailable'))
						end
					end, function(data2, menu2)
						menu2.close()
					end)

				else
					ESX.ShowNotification(_U('garage_empty'))
				end
			end, 'helicopter')

		elseif data.current.action == 'store_garage' then
			StoreNearbyVehicle(playerCoords)
		end

	end, function(data, menu)
		menu.close()
	end)

end

function OpenShopMenu(elements, restoreCoords, shopCoords)
	local playerPed = PlayerPedId()
	isInShopMenu = true

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title    = _U('vehicleshop_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm', {
			title    = _U('vehicleshop_confirm', data.current.name, data.current.price),
			align    = 'top-left',
			elements = {
				{ label = _U('confirm_no'), value = 'no' },
				{ label = _U('confirm_yes'), value = 'yes' }
			}
		}, function(data2, menu2)

			if data2.current.value == 'yes' then
				local newPlate = exports['esx_vehicleshop']:GeneratePlate()
				local vehicle  = GetVehiclePedIsIn(playerPed, false)
				local props    = ESX.Game.GetVehicleProperties(vehicle)
				props.plate    = newPlate

				ESX.TriggerServerCallback('esx_ambulancejob:buyJobVehicle', function (bought)
					if bought then
						ESX.ShowNotification(_U('vehicleshop_bought', data.current.name, ESX.Math.GroupDigits(data.current.price)))

						isInShopMenu = false
						ESX.UI.Menu.CloseAll()
				
						DeleteSpawnedVehicles()
						FreezeEntityPosition(playerPed, false)
						SetEntityVisible(playerPed, true)
				
						ESX.Game.Teleport(playerPed, restoreCoords)
					else
						ESX.ShowNotification(_U('vehicleshop_money'))
						menu2.close()
					end
				end, props, data.current.type)
			else
				menu2.close()
			end

		end, function(data2, menu2)
			menu2.close()
		end)

		end, function(data, menu)
		isInShopMenu = false
		ESX.UI.Menu.CloseAll()

		DeleteSpawnedVehicles()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)

		ESX.Game.Teleport(playerPed, restoreCoords)
	end, function(data, menu)
		DeleteSpawnedVehicles()

		WaitForVehicleToLoad(data.current.model)
		ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)
			table.insert(spawnedVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
		end)
	end)

	WaitForVehicleToLoad(elements[1].model)
	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)
		table.insert(spawnedVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isInShopMenu then
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

function DeleteSpawnedVehicles()
	while #spawnedVehicles > 0 do
		local vehicle = spawnedVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(spawnedVehicles, 1)
	end
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or joaat(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName(_U('vehicleshop_awaiting_model'))
		EndTextCommandBusyspinnerOn(4)

		while not HasModelLoaded(modelHash) do
			Wait(0)
			DisableAllControlActions(0)
		end

		BusyspinnerOff()
	end
end

function WarpPedInClosestVehicle(ped)
	local coords = GetEntityCoords(ped)

	local vehicle, distance = ESX.Game.GetClosestVehicle(coords)

	if distance ~= -1 and distance <= 5.0 then
		local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

		for i=maxSeats - 1, 0, -1 do
			if IsVehicleSeatFree(vehicle, i) then
				freeSeat = i
				break
			end
		end

		if freeSeat then
			TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)
		end
	else
		ESX.ShowNotification(_U('no_vehicles'))
	end
end

--- TODO : SPAWNER MENU EMS
local propgarasi = {
	{x = -1865.591187, y = -341.287903, z = 49.381714, h = 150.236221, name = 'ems:vehiclepillbox'},
	{x = 1836.29, y = 3669.03, z = 33.68, h = 209.9, name = 'ems:vehicleshandy'},
	{x = -256.9, y = 6351.98, z = 32.35, h = 224.52, name = 'ems:vehiclepaleto'}
}

Citizen.CreateThread(function()

	RequestModel(GetHashKey('prop_parkingpay'))
	while not HasModelLoaded(GetHashKey('prop_parkingpay')) do
		Wait(5)
	end

	for k,v in pairs (propgarasi) do
		local ticketGarage = CreateObject(GetHashKey('prop_parkingpay'), v.x, v.y, v.z-1.0, false, false, false)
		FreezeEntityPosition(ticketGarage, true)
		DecorSetInt(ticketGarage,"GamemodeCar",955)
		SetEntityHeading(ticketGarage, v.h - 180.0)

		exports.ox_target:AddBoxZone(v.name, vector3(v.x, v.y, v.z), 1.2, 1.0 ,{
			name=v.name,
			heading=v.h,
			debugPoly=false,
			minZ=v.z-1.2,
			maxZ=v.z+1.5
		}, {
			options = {
				{
					event = "dl-job:"..v.name,
					icon = "fas fa-briefcase",
					label = "Aksess Garasi",
					job = "ambulance",
				}
			},
			distance = 3.0
		})
		RegisterNetEvent('dl-job:'..v.name)
		AddEventHandler('dl-job:'..v.name, function()
				if v.name == 'ems:vehiclepillbox' then
					OpenVehicleSpawnerMenu('CentralLosSantos', 1)
				elseif v.name == 'ems:vehicleshandy' then
					OpenVehicleSpawnerMenu('ShandyShours', 1)
				elseif v.name == 'ems:vehiclepaleto' then
					OpenVehicleSpawnerMenu('Paleto', 1)
				end
		end)
	end
end)

-- TODO : NEW MARKER GARAGE HELI EMS
local propheli = {
	{x = -1853.024170, y = -352.549438, z = 58.042480, h = 121.889763, name = 'ems:helipillbox'},
	--[[ {x = 1840.53, y = 3643.11, z = 35.64, h = 195.38, name = 'ems:helisandy'}, ]]
}
Citizen.CreateThread(function()

	local tableEvent = {}
	local Showing = false
	local exiting = false

	RequestModel(GetHashKey('prop_parkingpay'))
	while not HasModelLoaded(GetHashKey('prop_parkingpay')) do
		Wait(5)
	end
	for k,v in pairs (propheli) do
		local ticketGarage = CreateObject(GetHashKey('prop_parkingpay'), v.x, v.y, v.z-1.0, false, false, false)
		FreezeEntityPosition(ticketGarage, true)
		DecorSetInt(ticketGarage,"GamemodeCar",955)
		SetEntityHeading(ticketGarage, v.h - 180.0)

		exports.ox_target:AddBoxZone(v.name, vector3(v.x, v.y, v.z), 1.0, 1.0 ,{
			name=v.name,
			heading=v.h,
			debugPoly=false,
			minZ=v.z-1.2,
			maxZ=v.z+1.5
		}, {
			options = {
				{
					event = "dl-job:"..v.name,
					icon = "fas fa-briefcase",
					label = "Aksess Garasi",
					job = "ambulance",
				}
			},
			distance = 3.0
		})
		RegisterNetEvent('dl-job:'..v.name)
		AddEventHandler('dl-job:'..v.name, function()
			if v.name == 'ems:helipillbox' then
				OpenHelicopterSpawnerMenu('CentralLosSantos', 1)
			--elseif v.name == 'ems:helisandy' then
				--OpenHelicopterSpawnerMenu('ShandyShours', 1)
			--elseif v.name == 'ems:helilsmedical' then
				--OpenHelicopterSpawnerMenu('CentralLosSantos', 3)
			end
		end)


		-- TODO : FUNCTION FAST TRAVEL
		function FastTravel(coords, heading)
			local playerPed = PlayerPedId()
			DoScreenFadeOut(800)
			while not IsScreenFadedOut() do
				Citizen.Wait(500)
			end
			ESX.Game.Teleport(playerPed, coords, function()
				DoScreenFadeIn(800)

				if heading then
					SetEntityHeading(playerPed, heading)
				end
			end)
		end

			-- TODO : FAST TRAVEL
			for k , v in pairs(Config.Hospitals['CentralLosSantos']['FastTravelsPrompt']) do
				exports["midp-nui"]:AddBoxZone("ems:fastlift"..k, vector3(v['From'].x, v['From'].y, v['From'].z), 1.5, 1.5, {
					name="ems:fastlift"..k,
					heading=169.5,
					debugPoly=false,
					minZ=v['From'].z-1.2,
					maxZ=v['From'].z+1.8
				})
				table.insert(tableEvent, {
					event = "ems:fastlift"..k,
					index = k,
					to = vector3( v['To']['coords'].x, v['To']['coords'].y,  v['To']['coords'].z),
					heading = v['To']['heading']
				})
			end
			-- TODO : EVENT FAST TRAVEL
			RegisterNetEvent('polyzonecuy:enter')
			AddEventHandler('polyzonecuy:enter', function(name)
				for k , v in pairs(tableEvent) do
					if name == v.event then
						if not Showing then
							exports['midp-tasknotify']:Open('[E] Masuk', 'darkblue', 'right')
							Showing = true
						end
						Citizen.CreateThread(function()
							while true do
								Citizen.Wait(5)
								if IsControlJustReleased(0, 184) then
									FastTravel(v.to, v.heading)
								end
								if exiting then
									exiting = false
									break
								end
							end
						end)

					end
				end
			end)

			RegisterNetEvent('polyzonecuy:exit')
			AddEventHandler('polyzonecuy:exit', function(name)
				for k , v in pairs(tableEvent) do
					if name == v.event then
						if Showing then
							exports['midp-tasknotify']:Close()
							Showing = false
							exiting = true
						end
					end
				end
			end)
		end
	end)