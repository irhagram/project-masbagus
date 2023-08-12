local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local PlayerData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, IsHandcuffed, hasAlreadyJoined, playerInService, isInShopMenu = false, false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity


dragStatus.isDragged = false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    Citizen.Wait(5000)
	TriggerServerEvent('dl-job:forceBlip')
end)

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[job].male then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

			if job == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end

			if job == 'gegana' then
				SetPedArmour(playerPed, 100)
			end
		else
			if Config.Uniforms[job].female then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

			if job == 'bullet_wear' then 
				SetPedArmour(playerPed, 100)
			end
			
			if job == 'gegana' then
				SetPedArmour(playerPed, 100)
			end
		end
	end)
end

RegisterNetEvent('jn-job:bajus')
AddEventHandler('jn-job:bajus', function()
  TriggerEvent('midp-context:sendMenu', {
    {
      id = 1,
      header = "LOKER POLISI",
      txt = ""
    },
    {
      id = 2,
      header = "Baju Bebas",
      txt = " ",
      params = {
        event = "jn-job:bajubiasa",
        args = {}
      }
    },
    {
      id = 3,
      header = "Baju Dinas",
      txt = " ",
      params = {
        event = "jn-job:bajudinas",
        args = {}
      }
    },
	{
      id = 4,
      header = "Rompi",
      txt = " ",
      params = {
        event = "jn-job:rompi",
        args = {}
      }
    },
	{
		id = 5,
		header = "List Baju(Toko Baju)",
		txt = " ",
		params = {
		  event = "fivem-appearance:browseOutfits",
		  args = {}
		}
	  },
  })
  TriggerEvent('midp-context:sendMenu', {
    {
        id = 0,
        header = "< Kembali",
        txt = "",
        params = {
            event = " "
        }
    },
  })
end)

RegisterNetEvent('jn-job:bajubiasa')
AddEventHandler('jn-job:bajubiasa', function()
	if Config.EnableNonFreemodePeds then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			local isMale = skin.sex == 0

			TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('esx:restoreLoadout')
				end)
			end)

		end)
	else
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
	end
end)

RegisterNetEvent('jn-job:bajudinas')
AddEventHandler('jn-job:bajudinas', function()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
		else
			TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
		end
	end)
end)

RegisterNetEvent('jn-job:rompi')
AddEventHandler('jn-job:rompi', function()
	local playerPed = PlayerPedId()
	setUniform('bullet_wear', playerPed)
end)

function PolisiOpenVehicleSpawnerMenu(type, station, part, partNum)
	local playerCoords = GetEntityCoords(PlayerPedId())
	PlayerData = ESX.GetPlayerData()
	local elements = {
		{label = _U('garage_storeditem'), action = 'garage'},
		--{label = _U('garage_storeitem'), action = 'store_garage'},
		{label = _U('garage_buyitem'), action = 'buy_vehicle'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle', {
		title    = _U('garage_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.action == 'buy_vehicle' then
			local shopElements, shopCoords = {}

			if type == 'car' then
				shopCoords = Config.PoliceStations[station].Vehicles[partNum].InsideShop
				local authorizedVehicles = Config.PolisiAuthorizedVehicles[PlayerData.job.grade_name]

				if #Config.PolisiAuthorizedVehicles.Shared > 0 then
					for k,vehicle in ipairs(Config.PolisiAuthorizedVehicles.Shared) do
						table.insert(shopElements, {
							label = ('%s - <span style="color:green;">%s</span>'):format(vehicle.label, _U('shop_item', ESX.Math.GroupDigits(vehicle.price))),
							name  = vehicle.label,
							model = vehicle.model,
							price = vehicle.price,
							type  = 'car'
						})
					end
				end

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
					if #Config.PolisiAuthorizedVehicles.Shared == 0 then
						return
					end
				end
			elseif type == 'helicopter' then
				shopCoords = Config.PoliceStations[station].Helicopters[partNum].InsideShop
				local authorizedHelicopters = Config.PolisiAuthorizedHelicopters[PlayerData.job.grade_name]

				if #authorizedHelicopters > 0 then
					for k,vehicle in ipairs(authorizedHelicopters) do
						table.insert(shopElements, {
							label = ('%s - <span style="color:green;">%s</span>'):format(vehicle.label, _U('shop_item', ESX.Math.GroupDigits(vehicle.price))),
							name  = vehicle.label,
							model = vehicle.model,
							price = vehicle.price,
							livery = vehicle.livery or nil,
							type  = 'helicopter'
						})
					end
				else
					ESX.ShowNotification(_U('helicopter_notauthorized'))
					return
				end
			end

			OpenShopMenu(shopElements, playerCoords, shopCoords)
		elseif data.current.action == 'garage' then
			local garage = {}

			ESX.TriggerServerCallback('esx_vehicleshop:retrieveJobVehicles', function(jobVehicles)
				if #jobVehicles > 0 then
					for k,v in ipairs(jobVehicles) do
						local props = json.decode(v.vehicle)
						local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(props.model))
						local label = ('%s - <span style="color:darkrod;">%s</span>: '):format(vehicleName, props.plate)

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
							local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(station, part, partNum)

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
			end, type)
		elseif data.current.action == 'store_garage' then
			PolisiStoreNearbyVehicle(playerCoords)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function PolisiStoreNearbyVehicle(playerCoords)
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

	ESX.TriggerServerCallback('dl-job:storeNearbyVehicle', function(storeSuccess, foundNum)
		if storeSuccess then
			local vehicleId = vehiclePlates[foundNum]
			local attempts = 0
			ESX.Game.DeleteVehicle(vehicleId.vehicle)
			IsBusy = true

			Citizen.CreateThread(function()
				BeginTextCommandBusyString('STRING')
				AddTextComponentSubstringPlayerName(_U('garage_storing'))
				EndTextCommandBusyString(4)

				while IsBusy do
					Citizen.Wait(100)
				end

				RemoveLoadingPrompt()
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

function GetAvailableVehicleSpawnPoint(station, part, partNum)
	local spawnPoints = Config.PoliceStations[station][part][partNum].SpawnPoints
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
		ESX.ShowNotification(_U('vehicle_blocked'))
		return false
	end
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
				{label = _U('confirm_no'), value = 'no'},
				{label = _U('confirm_yes'), value = 'yes'}
		}}, function(data2, menu2)
			if data2.current.value == 'yes' then
				local newPlate = exports['esx_vehicleshop']:GeneratePlate()
				local vehicle  = GetVehiclePedIsIn(playerPed, false)
				local props    = ESX.Game.GetVehicleProperties(vehicle)
				props.plate    = newPlate

				ESX.TriggerServerCallback('dl-job:buyJobVehicle', function (bought)
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
			SetModelAsNoLongerNeeded(data.current.model)

			if data.current.livery then
				SetVehicleModKit(vehicle, 0)
				SetVehicleLivery(vehicle, data.current.livery)
			end
		end)
	end)

	WaitForVehicleToLoad(elements[1].model)
	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)
		table.insert(spawnedVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
		SetModelAsNoLongerNeeded(elements[1].model)

		if elements[1].livery then
			SetVehicleModKit(vehicle, 0)
			SetVehicleLivery(vehicle, elements[1].livery)
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local canSleep = true
        local playerped = PlayerPedId()	
        if IsPedInAnyVehicle(playerped, false) then	
           canSleep = false
            if isInShopMenu then
                DisableControlAction(0, 75, true)  -- Disable exit vehicle
                DisableControlAction(27, 75, true) -- Disable exit vehicle
            end
         end
             if canSleep then
			Citizen.Wait(1000)
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
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName(_U('vehicleshop_awaiting_model'))
		EndTextCommandBusyString(4)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end

		RemoveLoadingPrompt()
	end
end

function CanDoJob()
    for k, v in pairs(Config.PolisiJobs.AllowedJobs) do
        if v == ESX.PlayerData.job.name then
            return true
        end
    end
    return false
end

function CanDoWhileDead(targetPed)
    if Config.PolisiOnlyWhileDead then
        return IsPedDeadOrDying(targetPed)
    else
        return true
    end
end

function OpenIdentityCardMenu(player)
	ESX.TriggerServerCallback('dl-job:getOtherPlayerData', function(data)
		local elements = {}
		local nameLabel = _U('name', data.name)
		local jobLabel, sexLabel, dobLabel, heightLabel, idLabel

		if data.job.grade_label and  data.job.grade_label ~= '' then
			jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
		else
			jobLabel = _U('job', data.job.label)
		end

		if Config.PolisiEnableESXIdentity then
			nameLabel = _U('name', data.firstname .. ' ' .. data.lastname)

			if data.sex then
				if string.lower(data.sex) == 'm' then
					sexLabel = _U('sex', _U('male'))
				else
					sexLabel = _U('sex', _U('female'))
				end
			else
				sexLabel = _U('sex', _U('unknown'))
			end

			if data.dob then
				dobLabel = _U('dob', data.dob)
			else
				dobLabel = _U('dob', _U('unknown'))
			end

			if data.height then
				heightLabel = _U('height', data.height)
			else
				heightLabel = _U('height', _U('unknown'))
			end

			if data.name then
				idLabel = _U('id', data.name)
			else
				idLabel = _U('id', _U('unknown'))
			end
		end

		local elements = {
			{label = nameLabel},
			{label = jobLabel}
		}

		if Config.PolisiEnableESXIdentity then
			table.insert(elements, {label = sexLabel})
			table.insert(elements, {label = dobLabel})
			table.insert(elements, {label = heightLabel})
			table.insert(elements, {label = idLabel})
		end

		if data.drunk then
			table.insert(elements, {label = _U('bac', data.drunk)})
		end

		if data.licenses then
			table.insert(elements, {label = _U('license_label')})

			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
			title    = _U('citizen_interaction'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function SendToCommunityService(player)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'Community Service Menu', {
		title = "Community Service Menu",
	}, function (data2, menu)
		local community_services_count = tonumber(data2.value)
		
		if community_services_count == nil then
			ESX.ShowNotification('Invalid services count.')
		else
			TriggerServerEvent("esx_communityservice:sendToCommunityService", player, community_services_count)
			menu.close()
		end
	end, function (data2, menu)
		menu.close()
	end)
end

function OpenFineMenu(player)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine', {
		title    = _U('fine'),
		align    = 'top-left',
		elements = {
			{label = _U('traffic_offense'), value = 0},
			{label = _U('minor_offense'),   value = 1},
			{label = _U('average_offense'), value = 2},
			{label = _U('major_offense'),   value = 3}
	}}, function(data, menu)
		OpenFineCategoryMenu(player, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenFineCategoryMenu(player, category)
	ESX.TriggerServerCallback('dl-job:getFineList', function(fines)
		local elements = {}

		for k,fine in ipairs(fines) do
			table.insert(elements, {
				label     = ('%s <span style="color:green;">%s</span>'):format(fine.label, _U('armory_item', ESX.Math.GroupDigits(fine.amount))),
				value     = fine.id,
				amount    = fine.amount,
				fineLabel = fine.label
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category', {
			title    = _U('fine'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()

			if Config.PolisiEnablePlayerManagement then
				TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', _U('fine_total', data.current.fineLabel), data.current.amount)
			else
				TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', _U('fine_total', data.current.fineLabel), data.current.amount)
			end

			ESX.SetTimeout(300, function()
				OpenFineCategoryMenu(player, category)
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, category)
end

function LookupVehicle()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle',
	{
		title = _U('search_database_title'),
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 2 or length > 13 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('dl-job:getVehicleFromPlate', function(owner, found)
				if found then
					ESX.ShowNotification(_U('search_database_found', owner))
				else
					ESX.ShowNotification(_U('search_database_error_not_found'))
				end
			end, data.value)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function ShowPlayerLicense(player)
	local elements, targetName = {}

	ESX.TriggerServerCallback('dl-job:getOtherPlayerData', function(data)
		if data.licenses then
			for i=1, #data.licenses, 1 do
				if data.licenses[i].label and data.licenses[i].type then
					table.insert(elements, {
						label = data.licenses[i].label,
						type = data.licenses[i].type
					})
				end
			end
		end

		if Config.PolisiEnableESXIdentity then
			targetName = data.firstname .. ' ' .. data.lastname
		else
			targetName = data.name
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license', {
			title    = _U('license_revoke'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, targetName))
			TriggerServerEvent('dl-job:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))

			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.type)

			ESX.SetTimeout(300, function()
				ShowPlayerLicense(player)
			end)
		end, function(data, menu)
			menu.close()
		end)

	end, GetPlayerServerId(player))
end

function OpenUnpaidBillsMenu(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
		for k,bill in ipairs(bills) do
			table.insert(elements, {
				label = ('%s - <span style="color:red;">%s</span>'):format(bill.label, _U('armory_item', ESX.Math.GroupDigits(bill.amount))),
				billId = bill.id
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing', {
			title    = _U('unpaid_bills'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenVehicleInfosMenu(vehicleData)
	ESX.TriggerServerCallback('dl-job:getVehicleInfos', function(retrivedInfo)
		local elements = {{label = _U('plate', retrivedInfo.plate)}}

		if retrivedInfo.owner == nil then
			table.insert(elements, {label = _U('owner_unknown')})
		else
			table.insert(elements, {label = _U('owner', retrivedInfo.owner)})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
			title    = _U('vehicle_info'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, vehicleData.plate)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job

	Citizen.Wait(5000)
	TriggerServerEvent('dl-job:forceBlip')
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('phone_police'),
		number     = 'police',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTV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'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- don't show dispatches if the player isn't in service
AddEventHandler('esx_phone:cancelMessage', function(dispatchNumber)
	if PlayerData.job and PlayerData.job.name == 'police' and PlayerData.job.name == dispatchNumber then
		-- if esx_service is enabled
		if Config.PolisiMaxInService ~= -1 and not playerInService then
			CancelEvent()
		end
	end
end)

AddEventHandler('dl-job:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if PlayerData.job and PlayerData.job.name == 'police' and IsPedOnFoot(playerPed) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('remove_prop')
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end)

AddEventHandler('dl-job:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

RegisterNetEvent('dl-job:handcuff')
AddEventHandler('dl-job:handcuff', function()
	local playerPed = PlayerPedId()	

	Citizen.CreateThread(function()
		if IsHandcuffed then

			if Config.PolisiEnableHandcuffTimer then
				if handcuffTimer.active then
					ESX.ClearTimeout(handcuffTimer.task)
				end

				StartHandcuffTimer()
			end
		else
			if Config.PolisiEnableHandcuffTimer and handcuffTimer.active then
				ESX.ClearTimeout(handcuffTimer.task)
			end

		end
	end)
end)

RegisterNetEvent('dl-job:unrestrain')
AddEventHandler('dl-job:unrestrain', function()
if IsHandcuffed then
		local playerPed = PlayerPedId()
		IsHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		DisplayRadar(false)

		-- end timer
		if Config.PolisiEnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

local Drag = {
	Distance = 3,
	Dragging = false,
	Dragger = -1,
	Dragged = false,
}

function Drag:GetPlayers()
	local Players = {}

	for _, Index in ipairs(GetActivePlayers()) do
		table.insert(Players, Index)
	end

    return Players
end

function GetPlayers2()
	local Players = {}

	for _, Index in ipairs(GetActivePlayers()) do
		table.insert(Players, Index)
	end

    return Players
end

function Drag:GetClosestPlayer()
    local Players = self:GetPlayers()
    local ClosestDistance = -1
    local ClosestPlayer = -1
    local PlayerPed = PlayerPedId()
    local PlayerPosition = GetEntityCoords(PlayerPed, false)
    
    for Index = 1, #Players do
    	local TargetPed = GetPlayerPed(Players[Index])
    	if PlayerPed ~= TargetPed then
    		local TargetCoords = GetEntityCoords(TargetPed, false)
    		local Distance = #(PlayerPosition - TargetCoords)

    		if ClosestDistance == -1 or ClosestDistance > Distance then
    			ClosestPlayer = Players[Index]
    			ClosestDistance = Distance
    		end
    	end
    end
    
    return ClosestPlayer, ClosestDistance
end

RegisterNetEvent('dl-job:dragger')
AddEventHandler('dl-job:dragger', function(Dragger)
	Drag.Dragging = not Drag.Dragging
	Drag.Dragger = Dragger
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if Drag.Dragging then
			local PlayerPed = PlayerPedId()

			Drag.Dragged = true
			AttachEntityToEntity(PlayerPed, GetPlayerPed(GetPlayerFromServerId(Drag.Dragger)), 11816, 0.54, 0.44, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		else
			if Drag.Dragged then
				local PlayerPed = PlayerPedId()

				if not IsPedInParachuteFreeFall(PlayerPed) then
					Drag.Dragged = false
					DetachEntity(PlayerPed, true, false)    
				end
			end
		end
	end
end)

RegisterNetEvent('dl-job:drag')
AddEventHandler('dl-job:drag', function(copId)
	if not IsHandcuffed then
		return
	end

	dragStatus.isDragged = not dragStatus.isDragged
	dragStatus.CopId = copId
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		Citizen.Wait(1)

		if IsHandcuffed then
			playerPed = PlayerPedId()

			if DragStatus.IsDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))

				-- undrag if target is in an vehicle
				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					DragStatus.IsDragged = false
					DetachEntity(playerPed, true, false)
				end

				if IsPedDeadOrDying(targetPed, true) then
					DragStatus.IsDragged = false
					DetachEntity(playerPed, true, false)
				end

			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('dl-job:putInVehicle')
AddEventHandler('dl-job:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if not IsHandcuffed then
		return
	end

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				dragStatus.isDragged = false
			end
		end
	end
end)

RegisterNetEvent('dl-job:OutVehicle')
AddEventHandler('dl-job:OutVehicle', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)

RegisterNetEvent('dl-job:getarrested')
AddEventHandler('dl-job:getarrested', function(playerheading, playercoords, playerlocation)
	playerPed = GetPlayerPed(-1)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	IsHandcuffed = true
	TriggerEvent('dl-job:handcuff')
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	TriggerEvent('radio:closeAllChannel')
end)

RegisterNetEvent('dl-job:doarrested')
AddEventHandler('dl-job:doarrested', function()
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Citizen.Wait(3000)
end) 

RegisterNetEvent('dl-job:douncuffing')
AddEventHandler('dl-job:douncuffing', function()
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('dl-job:getuncuffed')
AddEventHandler('dl-job:getuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	IsHandcuffed = false
	TriggerEvent('dl-job:handcuff')
	ClearPedTasks(GetPlayerPed(-1))
end)	

RegisterNetEvent("kejini:toggleVisibilty")
AddEventHandler("kejini:toggleVisibilty", function(source)
    local playerPed = PlayerPedId()
    if not isVisible then
        local dict = "mp_missheist_countrybank@nervous"
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
        if not IsEntityPlayingAnim(playerPed, dict, 'nervous_idle', 3) then
            TaskPlayAnim(playerPed, dict, "nervous_idle", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
        end
    else
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent("dl-job:s13")
AddEventHandler("dl-job:s13", function()
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local job = ESX.PlayerData.job.name 
	local time = GetClockHours() .. ':' .. GetClockMinutes()

	TriggerServerEvent('dl-phone:addsms', playerCoords, 'S13!', 'police', time)
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        local canSleep = true
		local playerPed = PlayerPedId()

        if IsHandcuffed then
            canSleep = false
			--DisableControlAction(0, 1, true) -- Disable pan
			--DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			--DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			--DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 244, true)  -- Disable Radio
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle

			if IsPedInAnyVehicle(PlayerPedId()) then
                canSleep = false
				DisableControlAction(0, 23, true)
				DisableControlAction(0, 75, true)
				DisableControlAction(0, 49, true)
			else
			end

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
                canSleep = false
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		end
        if canSleep then
            Citizen.Wait(500)
        end
	end
end)

BuatSimAlan = function()
	local elements = {
		{label = 'Lisensi SIM A', value = 'ls_sima'},
		{label = 'Lisensi SIM B', value = 'ls_simb'},
		{label = 'Lisensi SIM C', value = 'ls_simc'},
		{label = 'Lisensi Menembak', value = 'ls_gun'},
	}

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		title    = 'Menu Lisensi',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		local playerped = PlayerPedId()
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		if closestPlayer ~= -1 and closestDistance <= 2.0 then
			local action = data.current.value
			if action == 'ls_sima' then
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('dl-job:beriSimA', GetPlayerServerId(closestPlayer))
                else
					exports['midp-tasknotify']:Alert("SYSTEM", "Tidak ada orang di sekitar!", 1500, 'error')
                end
			elseif action== 'ls_simb' then
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('dl-job:beriSimB', GetPlayerServerId(closestPlayer))
                else
					exports['midp-tasknotify']:Alert("SYSTEM", "Tidak ada orang di sekitar!", 1500, 'error')
                end
			elseif action == 'ls_simc' then
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('dl-job:beriSimC', GetPlayerServerId(closestPlayer))
                else
					exports['midp-tasknotify']:Alert("SYSTEM", "Tidak ada orang di sekitar!", 1500, 'error')
                end
			elseif action == 'ls_gun' then
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('dl-job:BeriLsenJata', GetPlayerServerId(closestPlayer))
                else
					exports['midp-tasknotify']:Alert("SYSTEM", "Tidak ada orang di sekitar!", 1500, 'error')
                end
			end
		else
			ClearPedTasks(playerped)
			exports['midp-tasknotify']:Alert('LISENSI', 'Tidak Ada Orang di Sekitar', 5000, 'error')
		end
		ClearPedTasks(playerped)
		menu.close()
	end, function(data, menu)
		ClearPedTasks(playerped)
		menu.close()
		CurrentAction     = 'alan_ganteng_cok'
		CurrentActionData = {station = station}
	end)
end

--Enter / Exit entity zone events
CreateThread(function()
	local trackedEntities = {
		`prop_roadcone02a`,
		`prop_barrier_work05`,
		`p_ld_stinger_s`,
		`prop_boxpile_07d`,
		`hei_prop_cash_crate_half_full`
	}

	while true do
		local Sleep = 1500

			local GetEntityCoords = GetEntityCoords
			local GetClosestObjectOfType = GetClosestObjectOfType
			local DoesEntityExist = DoesEntityExist
			local playerCoords = GetEntityCoords(ESX.PlayerData.ped)
	
			local closestDistance = -1
			local closestEntity   = nil

			for i=1, #trackedEntities, 1 do
				local object = GetClosestObjectOfType(playerCoords, 3.0, trackedEntities[i], false, false, false)

				if DoesEntityExist(object) then
					Sleep = 500
					local objCoords = GetEntityCoords(object)
					local distance = #(playerCoords - objCoords)

					if closestDistance == -1 or closestDistance > distance then
						closestDistance = distance
						closestEntity   = object
					end
				end
			end

			if closestDistance ~= -1 and closestDistance <= 3.0 then
				if LastEntity ~= closestEntity then
					TriggerEvent('dl-job:hasEnteredEntityZone', closestEntity)
					LastEntity = closestEntity
				end
			else
				if LastEntity then
					TriggerEvent('dl-job:hasExitedEntityZone', LastEntity)
					LastEntity = nil
				end
			end
		Wait(Sleep)
	end
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('dl-job:unrestrain')

	if not hasAlreadyJoined then
		TriggerServerEvent('dl-job:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('dl-job:unrestrain')
		TriggerEvent('esx_phone:removeSpecialContact', 'police')

		if Config.PolisiMaxInService ~= -1 then
			TriggerServerEvent('esx_service:disableService', 'police')
		end

		if Config.PolisiEnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

-- handcuff timer, unrestrain the player after an certain amount of time
function StartHandcuffTimer()
	if Config.PolisiEnableHandcuffTimer and handcuffTimer.active then
		ESX.ClearTimeout(handcuffTimer.task)
	end

	handcuffTimer.active = true

	handcuffTimer.task = ESX.SetTimeout(Config.PolisihandcuffTimer, function()
		ESX.ShowNotification(_U('unrestrained_timer'))
		TriggerEvent('dl-job:unrestrain')
		handcuffTimer.active = false
	end)
end

-- TODO
--   - return to garage if owned
--   - message owner that his vehicle has been impounded
function ImpoundVehicle(vehicle)
	--local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
	ESX.Game.DeleteVehicle(vehicle)
	ESX.ShowNotification(_U('impound_successful'))
	currentTask.busy = false
end

function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end

RegisterNetEvent('dl-job:hijack')
AddEventHandler('dl-job:hijack', function()
if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
	TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
	Citizen.Wait(20000)
	ClearPedTasksImmediately(playerPed)

	SetVehicleDoorsLocked(vehicle, 1)
	SetVehicleDoorsLockedForAllPlayers(vehicle, false)
	ESX.ShowNotification(_U('vehicle_unlocked'))
end
end)

RegisterNetEvent('dl-job:impndnya')
AddEventHandler('dl-job:impndnya', function()
	local playerPed = PlayerPedId()
	local vehicle = ESX.Game.GetVehicleInDirection()
	local coords  = GetEntityCoords(playerPed)
	vehicle = ESX.Game.GetVehicleInDirection()

	if DoesEntityExist(vehicle) then
		if currentTask.busy then
			return
		end

		ESX.ShowHelpNotification('E - Batal')
		TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
		currentTask.busy = true
		currentTask.task = ESX.SetTimeout(10000, function()
			ClearPedTasks(playerPed)
			ImpoundVehicle(vehicle)
			Citizen.Wait(100) -- sleep the entire script to let stuff sink back to reality
		end)

		-- keep track of that vehicle!
		Citizen.CreateThread(function()
			while currentTask.busy do
				Citizen.Wait(1000)

				vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
				if not DoesEntityExist(vehicle) and currentTask.busy then
					--ESX.ShowNotification(_U('impound_canceled_moved'))
					ESX.ClearTimeout(currentTask.task)
					ClearPedTasks(playerPed)
					currentTask.busy = false
					break
				end
			end
		end)
	end
end)

---- START OF EVENT FOR RADIAL MENU ACTION ----
RegisterNetEvent('dl-job:anim')
AddEventHandler('dl-job:anim', function()
  local pid = PlayerPedId()
  RequestAnimDict("melee@unarmed@streamed_variations")
  while (not HasAnimDictLoaded("melee@unarmed@streamed_variations")) do Citizen.Wait(0) end
        TaskPlayAnim(pid,"melee@unarmed@streamed_variations","plyr_takedown_front_slap",-1, -1, -1, 120, 1, 0, 0, 0)
end)


RegisterNetEvent('dl-job:anim2')
AddEventHandler('dl-job:anim2', function()
  local yesusped = PlayerPedId()
  RequestAnimDict("mp_missheist_countrybank@nervous")
  	while (not HasAnimDictLoaded("mp_missheist_countrybank@nervous")) do 
		Citizen.Wait(0) 
	end
    TaskPlayAnim(yesusped,"mp_missheist_countrybank@nervous","nervous_idle",-1, -1, -1, 120, 1, 0, 0, 0)
end)

RegisterNetEvent('dl-job:fine')
AddEventHandler('dl-job:fine', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    OpenFineMenu(closestPlayer)
end)

RegisterNetEvent('dl-job:cekbilling')
AddEventHandler('dl-job:cekbilling',function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	OpenUnpaidBillsMenu(closestPlayer)
end)

RegisterNetEvent('dl-job:geledah')
AddEventHandler('dl-job:geledah',function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	TriggerServerEvent('dl-job:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
    exports.ox_inventory:openNearbyInventory()
end)

RegisterNetEvent('dl-job:checkstnk')
AddEventHandler('dl-job:checkstnk',function()
	local playerPed = PlayerPedId()
	local vehicle = ESX.Game.GetVehicleInDirection()
	local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
	OpenVehicleInfosMenu(vehicleData)
	ExecuteCommand("me Mengecek Info Kendaraan")
end)

RegisterNetEvent('dl-job:bobol')
AddEventHandler('dl-job:bobol',function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		local chance = math.random(100)
		local alarm  = math.random(50)

		if DoesEntityExist(vehicle) then
			if alarm <= 33 then
				SetVehicleAlarm(vehicle, true)
				StartVehicleAlarm(vehicle)
			end

			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)

			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				if chance <= 50 then
					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)
					--exports['midp-tasknotify']:SendAlert('success', 'Successfully break into the vehicle')
					exports['midp-tasknotify']:Alert("Vehicle Action", "Successfully break into the vehicle", 3000, 'success')
				else
					--exports['midp-tasknotify']:SendAlert('error', 'Failed to break into the vehicle')
					exports['midp-tasknotify']:Alert("Vehicle Action", "Failed to break into the vehicle", 3000, 'error')
					ClearPedTasksImmediately(playerPed)
				end
			end)
		end
	end
end)

RegisterNetEvent('dl-job:penjara')
AddEventHandler('dl-job:penjara',function()
	TriggerEvent("esx-qalle-jail:openJailMenu")
end)

RegisterNetEvent('dl-job:sendtoinsurance')
AddEventHandler('dl-job:sendtoinsurance',function()
	local timeout = 20
	local playerPed = PlayerPedId()
	local vehicle = ESX.Game.GetVehicleInDirection()
	if IsPedSittingInAnyVehicle(playerPed) then
		--exports.pNotify:SendNotification({text = "Jangan ada yang di dalam kendaraan", type = "error", timeout = 200, layout = "centerLeft", queue = "left"})
	else
		NetworkRequestControlOfEntity(vehicle)
		while not NetworkHasControlOfEntity(vehicle) and timeout > 0 do 
			NetworkRequestControlOfEntity(vehicle)
			Citizen.Wait(100)
			timeout = timeout -1
		end
		exports['mythic_progbar']:Progress({
			name = "impound",
			duration = 10000,
			label = 'Mengirim Keasuransi',
			useWhileDead = true,
			canCancel = false,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				task = "CODE_HUMAN_MEDIC_TEND_TO_DEAD",
			},
		}, function(cancelled)
			if not cancelled then
				ClearPedTasks(playerPed)
				ESX.Game.DeleteVehicle(vehicle)
			end
		end)
	end
end)

RegisterNetEvent('dl-job:borgol')
AddEventHandler('dl-job:borgol',function()
	local target, distance = ESX.Game.GetClosestPlayer()
	playerheading = GetEntityHeading(PlayerPedId())
	playerlocation = GetEntityForwardVector(PlayerPedId())
	playerCoords = GetEntityCoords(PlayerPedId())
	local target_id = GetPlayerServerId(target)
	if distance <= 1.5 then
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'handcuff', 100.35)
		TriggerServerEvent('dl-job:requestarrest', target_id, playerheading, playerCoords, playerlocation)
	else
		ESX.ShowNotification('Not Close Enough')
	end
end)

RegisterNetEvent('dl-job:lepasborgol')
AddEventHandler('dl-job:lepasborgol',function()
	ExecuteCommand('me Melepas Borgol')
	local target, distance = ESX.Game.GetClosestPlayer()
	playerheading = GetEntityHeading(PlayerPedId())
	playerlocation = GetEntityForwardVector(PlayerPedId())
	playerCoords = GetEntityCoords(PlayerPedId())
	local target_id = GetPlayerServerId(target)
	if distance <= 1.5 then
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'handcuff', 100.35)
		TriggerServerEvent('dl-job:requestrelease', target_id, playerheading, playerCoords, playerlocation)
	else
		ESX.ShowNotification('Not Close Enough')
	end
end)

RegisterNetEvent('dl-job:dragg')
AddEventHandler('dl-job:dragg',function()
	local Player, Distance = Drag:GetClosestPlayer()
	if Distance ~= -1 and Distance < Drag.Distance then
		TriggerServerEvent('dl-job:drag', GetPlayerServerId(Player))
	else
		exports['midp-tasknotify']:SendAlert('error', 'Tidak Ada Orang Disekitar')
	end
end)

RegisterNetEvent('dl-job:cekKtp')
AddEventHandler('dl-job:cekKtp',function()
    local pos = GetEntityCoords(PlayerPedId())
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		OpenIdentityCardMenu(closestPlayer)
	else
		exports['midp-tasknotify']:SendAlert('error', 'Tidak Ada Orang Disekitar')
	end
end)

RegisterNetEvent('dl-job:masukpaksa')
AddEventHandler('dl-job:masukpaksa',function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	TriggerServerEvent('3dme:shareDisplay', 'Memasukkan Paksa')
	TriggerEvent('dl-job:anim')
	Citizen.Wait(1000)
	TriggerServerEvent('dl-job:putInVehicle', GetPlayerServerId(closestPlayer))
end)

RegisterNetEvent('dl-job:objspawn')
AddEventHandler('dl-job:objspawn', function(data2, menu2)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
		title    = 'OBJECT SPAWN',
		align    = 'top-left',
		elements = {
			{label = 'cone', model = 'prop_roadcone02a'},
			{label = 'barrier', model = 'prop_barrier_work05'},
			{label = 'spikestrips', model = 'p_ld_stinger_s'},
			{label = 'box', model = 'prop_boxpile_07d'}
	}}, function(data2, menu2)
		local playerPed = PlayerPedId()
		local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
		local objectCoords = (coords + forward * 1.0)

		ESX.Game.SpawnObject(data2.current.model, objectCoords, function(obj)
			SetEntityHeading(obj, GetEntityHeading(playerPed))
			PlaceObjectOnGroundProperly(obj)
		end)
	end, function(data2, menu2)
		menu2.close()
	end)
end)

RegisterNetEvent('dl-job:keluarpaksa')
AddEventHandler('dl-job:keluarpaksa',function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	TriggerServerEvent('3dme:shareDisplay', 'Menurunkan Paksa')
	local lib = 'random@mugging4'

	local anim = 'struggle_loop_b_thief'
  
	ESX.Streaming.RequestAnimDict(lib, function()
  
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, false, false, false)
  
	end)
	Citizen.Wait(3000)					  
	TriggerServerEvent('dl-job:OutVehicle', GetPlayerServerId(closestPlayer))
end)


-- Small Thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentAction then
			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
				end
				CurrentAction = nil
			end
		end
	end
end)

RegisterCommand("s13a", function()
	TriggerEvent('dl-dispatch:tenThirteenA')
end)

RegisterCommand("s13b", function()
	TriggerEvent('dl-dispatch:tenThirteenB')
end)

RegisterNetEvent('dl-job:bossmenu')
AddEventHandler('dl-job:bossmenu', function(data, menu)
	ESX.UI.Menu.CloseAll()
	TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)
		menu.close()
	end, { wash = false })
end)

--EVENT TARGET--
RegisterNetEvent('dl-job:buatsim')
AddEventHandler('dl-job:buatsim', function()
	BuatSimAlan()
end)

RegisterNetEvent('dl-job:hapusveh')
AddEventHandler('dl-job:hapusveh', function ()
	PolisiStoreNearbyVehicle(playerCoords)
end)

RegisterNetEvent('dl-job:givearmor')
AddEventHandler('dl-job:givearmor', function ()
	local playerPed = PlayerPedId()
	SetPedArmour(playerPed, 100)
end)

RegisterNetEvent('dl-job:brnks')
AddEventHandler('dl-job:brnks', function ()
	local ox_inventory = exports.ox_inventory
	ox_inventory:openInventory('stash', 'brankas_polisi')
end)

--MENU KENDARAAN
RegisterNetEvent('dl-job:SpawnVehKota')
AddEventHandler('dl-job:SpawnVehKota', function ()
	PolisiOpenVehicleSpawnerMenu('car', 'LSPD', 'Vehicles', 1)
end)

RegisterNetEvent('dl-job:SpawnVehKota2')
AddEventHandler('dl-job:SpawnVehKota2', function()
	PolisiOpenVehicleSpawnerMenu('car', 'LSPD2', 'Vehicles', 1)
end)

RegisterNetEvent('dl-job:spawnVehFederal')
AddEventHandler('dl-job:spawnVehFederal', function()
	PolisiOpenVehicleSpawnerMenu('car', 'LSPD3', 'Vehicles', 1)
end)

RegisterNetEvent('dl-job:spawnVehSS')
AddEventHandler('dl-job:spawnVehSS', function()
	PolisiOpenVehicleSpawnerMenu('car', 'LSPD4', 'Vehicles', 1)
end)

RegisterNetEvent('dl-job:spawnVehPaleto')
AddEventHandler('dl-job:spawnVehPaleto', function()
	PolisiOpenVehicleSpawnerMenu('car', 'LSPD5', 'Vehicles', 1)
end)

RegisterNetEvent('dl-job:spawnVehPolantas')
AddEventHandler('dl-job:spawnVehPolantas', function()
	PolisiOpenVehicleSpawnerMenu('car', 'LSPD6', 'Vehicles', 1)
end)

RegisterNetEvent('dl-job:spawnHeliKota')
AddEventHandler('dl-job:spawnHeliKota', function()
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		PolisiOpenVehicleSpawnerMenu('helicopter', 'LSPD', 'Helicopters', 1)
	end
end)

RegisterNetEvent('dl-job:spawnheliPaleto')
AddEventHandler('dl-job:spawnheliPaleto', function()
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		PolisiOpenVehicleSpawnerMenu('helicopter', 'LSPD4', 'Helicopters', 1)
	end
end)

RegisterNetEvent('dl-job:blipocok')
AddEventHandler('dl-job:blipocok', function()
	local input = lib.inputDialog('BILLING POLISI', {'ID PLAYER: ', 'JUMLAH: '})

	if input then
		local idplayer = tonumber(input[1])
		local jumlah = input[2]
		TriggerServerEvent('esx_billing:sendBill', idplayer, 'society_police', 'POLISI', jumlah)
	end
end)

RegisterNetEvent('dl-job:billpeda')
AddEventHandler('dl-job:billpeda', function()
	local input = lib.inputDialog('BILLING PEDAGANG', {'ID PLAYER: ', 'JUMLAH: '})

	if input then
		local idplayer = tonumber(input[1])
		local jumlah = input[2]
		TriggerServerEvent('esx_billing:sendBill', idplayer, 'society_pedagang', 'TAGIHAN PEDAGANG', jumlah)
	end
end)

--TARGET--
local nameid = 0

local coordebrankas = {
	{x = 482.52, y = -994.77,  z = 30.69, h = 270.0}, -- KOTA
	{x = -450.48248291016, y = 6010.8198242188, z = 31.716136932373, h = 233.25}, -- PALETO
	{x = 1844.17, y = 2574.25, z = 46.01, h = 94.96}, -- FEDERAL  
	{x = 370.50, y = -1602.70, z = 29.28, h = 230.0}, -- POLANTAS
	{x = 1862.6, y = 3690.2, z = 34.22, h = 47.92}, -- SS
}

local coordebaju = {
	{x = 462.36, y = -998.16, z = 31.12, h = 269.8, z1 = 5.1, z2 = 6.0, dis = 2.0}, -- KOTA
	{x = -453.62, y = 6013.81, z = 31.72, h = 46.62, z1 = 6.0, z2 = 7.0, dis = 2.0}, -- PALETO
	{x = 1834.91, y =2570.51, z = 46.01, h = 135.72, z1 = 1.7, z2 = 2.8, dis = 2.0}, -- FEDERAL  
	{x = 1853.28, y = 3689.41, z = 29.82, h = 212.25, z1 = 4.8,z2 = 4.5, dis = 2.0}, -- SS
	{x = 381.84, y = -1609.90, z = 29.28, h = 140.88,z1 = 2.8,z2 = 3.5, dis = 2.0}, -- POLANTAS
}

local coordsvehPoliceKota1 = { -- KOTA
	{x = 458.29400634766, y = -1017.4676513672, z = 28.236070632935, h = 91.4},
}

local coordsvehPoliceKota2 = { -- KOTA 2
	{x = 383.07125854492, y = -1611.8110351563, z = 29.292055130005, h = 178.16},
}

local coordsvehPoliceFederal = { -- FEDERAL
	{x = 1852.79, y = 2590.37, z = 45.67, h = 282.2},
}

local coordsvehPolicePaleto = {	-- PALETO
	{x = -457.76773071289, y = 6019.4619140625, z = 31.489994049072, h = 39.08},
}

local coordsvehPolicePolantas = { -- POLANTAS
	{x = 383.51, y = -1612.61, z = 29.29, h = 238.76},
}

local coordsvehPoliceSS = { -- SANDYSHORE
	{x = 1869.3919677734, y = 3688.2370605469, z = 33.73267364502, h = 322.76}
}

local bossmenucoords = {
	{x = 460.760437, y = -985.595581, z = 30.712036, h = 191},
	{x = 1848.02, y = 3694.94, z = 38.22, h = 191} 
}

local buatsimcoh = {
	{x = 359.26220703125, y = -1589.5623779297, z = 0.29, h = 191}
}


local helikota = {
	{x = 463.84, y = -982.48, z = 43.68, h = 267.16}
}

local heliPaleto = {
	{x = -494.99575805664, y = 5992.0478515625, z = 31.302331924438, h = 267.16}
}

Citizen.CreateThread(function()
	for k,v in pairs(coordebrankas) do
		nameid = nameid + 1
		exports["ox_target"]:AddBoxZone("Police_Brangkas" .. nameid, vector3(v.x, v.y, v.z), 2.0, 2.5, {
			name = "Police_Brangkas" .. nameid,
			heading = v.h,
			debugPoly = false,
			minZ = v.z - 1.0,
			maxZ = v.z + 2.0
			}, {
			options = {
				{
					event = "dl-job:brnks",
					icon = "fas fa-suitcase",
					label = "Brankas",
					job = {
						["police"] = 12,
					}
				},
				{
					event = "dl-job:givearmor",
					icon = "fas fa-suitcase",
					label = "Armor",
					job = "police",
				},
				{
					event = "dl-wrepair:RepairBlog",
					icon = "fa-solid fa-screwdriver-wrench",
					label = "Repair Senjata",
					job = "police",
				},
			},
			distance = 2.0
		})
	end

	for k,v in pairs(coordebaju) do
		nameid = nameid + 1
		exports["ox_target"]:AddBoxZone("Police_Pakaian" .. nameid, vector3(v.x, v.y, v.z), v.z1, v.z2, {
			name = "Police_Pakaian" .. nameid,
			heading = v.h,
			debugPoly = false,
			minZ = v.z - 1.0,
			maxZ = v.z + 2.0
		}, {
			options = {
			{
				event = "jn-job:bajus",
				icon = "fas fa-tshirt",
				label = "Pakaian",
				job = "police",
			},
			},
			distance = v.dis
		})
	end

	for k,v in pairs(coordsvehPoliceKota1) do
		exports["ox_target"]:AddBoxZone("coordsvehPoliceKota1", vector3(v.x, v.y, v.z), 2.0, 2.0, {
		  name = "coordsvehPoliceKota1",
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "dl-job:SpawnVehKota",
			icon = "fas fa-warehouse",
			label = "GARASI",
			job = "police",
		  },
		  {
			event = "dl-job:hapusveh",
			icon = "fas fa-warehouse",
			label = "MASUKKAN KENDARAAN",
			job = "police",
		  },
		  },
		  distance = 2.0
		})
	end

	for k,v in pairs(coordsvehPoliceKota2) do
		exports["ox_target"]:AddBoxZone("coordsvehPoliceKota2", vector3(v.x, v.y, v.z), 2.0, 2.0, {
		  name = "coordsvehPoliceKota2",
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "dl-job:SpawnVehKota2",
			icon = "fas fa-warehouse",
			label = "Garasi",
			job = "police",
		  },
		  {
			event = "dl-job:hapusveh",
			icon = "fas fa-warehouse",
			label = "Masukkan Kendaraan",
			job = "police",
		  },
		  },
		  distance = 2.0
		})
	end

	for k,v in pairs(coordsvehPoliceFederal) do
		exports["ox_target"]:AddBoxZone("coordsvehPoliceFederal", vector3(v.x, v.y, v.z), 2.0, 2.0, {
		  name = "coordsvehPoliceFederal",
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "dl-job:spawnVehFederal",
			icon = "fas fa-warehouse",
			label = "Garasi",
			job = "police",
		  },
		  {
			event = "dl-job:hapusveh",
			icon = "fas fa-warehouse",
			label = "Masukkan Kendaraan",
			job = "police",
		  },
		  },
		  distance = 2.0
		})
	end

	for k,v in pairs(coordsvehPolicePaleto) do
		exports["ox_target"]:AddBoxZone("coordsvehPolicePaleto", vector3(v.x, v.y, v.z), 2.0, 2.0, {
		  name = "coordsvehPolicePaleto",
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "dl-job:spawnVehPaleto",
			icon = "fas fa-warehouse",
			label = "Garasi",
			job = "police",
		  },
		  {
			event = "dl-job:hapusveh",
			icon = "fas fa-warehouse",
			label = "Masukkan Kendaraan",
			job = "police",
		  },
		  },
		  distance = 2.0
		})
	end

	for k,v in pairs(coordsvehPolicePolantas) do
		exports["ox_target"]:AddBoxZone("coordsvehPolicePolantas", vector3(v.x, v.y, v.z), 2.0, 2.0, {
		  name = "coordsvehPolicePolantas",
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "dl-job:spawnVehPolantas",
			icon = "fas fa-warehouse",
			label = "Garasi",
			job = "police",
		  },
		  {
			event = "dl-job:hapusveh",
			icon = "fas fa-warehouse",
			label = "Masukkan Kendaraan",
			job = "police",
		  },
		  },
		  distance = 2.0
		})
	end

	for k,v in pairs(coordsvehPoliceSS) do
		exports["ox_target"]:AddBoxZone("coordsvehPolicePolantas", vector3(v.x, v.y, v.z), 2.0, 2.0, {
		  name = "coordsvehPolicePolantas",
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "dl-job:spawnVehSS",
			icon = "fas fa-warehouse",
			label = "Garasi",
			job = "police",
		  },
		  {
			event = "dl-job:hapusveh",
			icon = "fas fa-warehouse",
			label = "Masukkan Kendaraan",
			job = "police",
		  },
		  },
		  distance = 2.0
		})
	end

	for k,v in pairs(bossmenucoords) do
		nameid = nameid + 1
		exports["ox_target"]:AddBoxZone("bossmenucoords" .. nameid, vector3(v.x, v.y, v.z), 1.7, 1.7, {
		  name = "bossmenucoords" .. nameid,
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "dl-job:bossmenu",
			icon = "far fa-clipboard",
			label = "Boss Menu",
			job = {
				["police"] = 16,
				["police"] = 15,
				["police"] = 14,
				["police"] = 13,
			}
		  },
		  },
		  distance = 2.0
		})
	end

	for k,v in pairs(buatsimcoh) do
		nameid = nameid + 1
		exports["ox_target"]:AddBoxZone("buatsimcoh" .. nameid, vector3(v.x, v.y, v.z), 1.7, 1.7, {
		  name = "buatsimcoh" .. nameid,
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "dl-job:buatsim",
			icon = "far fa-clipboard",
			label = "Buat Sim",
			job = "police",
		  },
		  },
		  distance = 2.0
		})
	end

	for k,v in pairs(heliPaleto) do
		nameid = nameid + 1
		exports["ox_target"]:AddBoxZone("heliPaleto" .. nameid, vector3(v.x, v.y, v.z), 1.7, 1.7, {
		  name = "heliPaleto" .. nameid,
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "dl-job:spawnheliPaleto",
			icon = "fas fa-helicopter",
			label = "Garasi",
			job = "police",
		  },
		  {
			event = "dl-job:hapusveh",
			icon = "fas fa-warehouse",
			label = "Masukkan Kendaraan",
			job = "police",
		  },
		  },
		  distance = 2.0
		})
	end

	for k,v in pairs(helikota) do
		nameid = nameid + 1
		exports["ox_target"]:AddBoxZone("helikota" .. nameid, vector3(v.x, v.y, v.z), 1.7, 1.7, {
		  name = "helikota" .. nameid,
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
			event = "dl-job:spawnHeliKota",
			icon = "fas fa-helicopter",
			label = "Garasi",
			job = "police",
		  },
		  {
			event = "dl-job:hapusveh",
			icon = "fas fa-warehouse",
			label = "Masukkan Kendaraan",
			job = "police",
		  },
		  },
		  distance = 2.0
		})
	end
end)

exports.ox_target:AddTargetModel({1581098148}, {
	options = {
		{
			event = "dl-job:SpawnVehKota",
			icon = "fas fa-warehouse",
			label = "BELI KENDARAAN",
			job = "police",
		  },
		  {
			event = "dl-job:hapusveh",
			icon = "fas fa-warehouse",
			label = "MASUKKAN KENDARAAN",
			job = "police",
		  },
	},
	distance = 2
})

exports['ox_target']:AddBoxZone("ambulance:documents", vector3(326.8813, -594.3829, 30.2020), 2.0, 2.0, {
	name="ambulance:documents",
	heading=101.8724,
	debugPoly=false,
	minZ=28.5,
	maxZ=31.9
	}, {
		options = {
		  {
			  event = "dl-job:tabEMS",
			  icon = "fas fa-clipboard",
			  label = "Komputer",
			  job = "ambulance",
		  },
		  {
			  event = "dl-job:buatKPasien",
			  icon = "fas fa-clipboard",
			  label = "Buat BPJS",
			  job = "ambulance",
		  },
		  {
			  event = "dl-job:buatKBPJS",
			  icon = "fas fa-clipboard",
			  label = "Buat Kartu Pasien",
			  job = "ambulance",
		  },

		},
		
		distance = 2.5
	 
	})

exports['ox_target']:AddBoxZone("police:documents", vector3(443.0, -984.35, 30.69), 0.5, 0.5, {
	name = "police:documents",
	heading = 45,
	debugPoly = false,
	minZ = 29.69,
	maxZ = 33.69
	}, {
		options = {
			{
			event = "dl-polisi:buatsim",
			icon = "fas fa-clipboard",
			label = "Buat Sim",
			job = "police",
			},
		},
	distance = 2.5
})

exports['ox_target']:AddBoxZone("police:documents", vector3(362.84, -1591.03, 29.29), 1, 1, {
		name = "police:documents",
		heading = 50,
		debugPoly = false,
		minZ = 28.29,
		maxZ = 32.29
		}, {
			options = {
				{
					event = "dl-polisi:buatsim",
					icon = "fas fa-clipboard",
					label = "Buat Sim",
					job = "police",
				  },
			  },
			  distance = 2.5
		  })

exports['ox_target']:AddBoxZone("police:documents", vector3(360.35, -1588.42, 29.29), 1, 1, {
		name = "police:documents",
		heading = 50,
		debugPoly = false,
		minZ = 28.29,
		maxZ = 32.29
			}, {
				options = {
					{
						event = "dl-polisi:buatsim",
						icon = "fas fa-clipboard",
						label = "Buat Sim",
						job = "police", 
					},
				  },
				distance = 2.5
})