local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local CurrentlyTowedVehicle, Blips, NPCOnJob, NPCTargetTowable, NPCTargetTowableZone = nil, {}, false, nil, nil
local NPCHasSpawnedTowable, NPCLastCancel, NPCHasBeenNextToTowable, NPCTargetDeleterZone = false, GetGameTimer() - 5 * 60000, false, false
local isDead, isBusy = false, false

ESX = nil

ObjectInFront = function(ped, pos)
	local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.5, 0.0)
	local car = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 30, ped, 0)
	local _, _, _, _, result = GetRaycastResult(car)
	return result
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

function SelectRandomTowable()
	local index = GetRandomIntInRange(1,  #Config.MekanikTowables)

	for k,v in pairs(Config.MekanikZones) do
		if v.Pos.x == Config.MekanikTowables[index].x and v.Pos.y == Config.MekanikTowables[index].y and v.Pos.z == Config.MekanikTowables[index].z then
			return k
		end
	end
end

function StartNPCJob()
	NPCOnJob = true

	NPCTargetTowableZone = SelectRandomTowable()
	local zone       = Config.Zones[NPCTargetTowableZone]

	Blips['NPCTargetTowableZone'] = AddBlipForCoord(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)
	SetBlipRoute(Blips['NPCTargetTowableZone'], true)

	ESX.ShowNotification(_U('drive_to_indicated'))
end

function StopNPCJob(cancel)
	if Blips['NPCTargetTowableZone'] then
		RemoveBlip(Blips['NPCTargetTowableZone'])
		Blips['NPCTargetTowableZone'] = nil
	end

	if Blips['NPCDelivery'] then
		RemoveBlip(Blips['NPCDelivery'])
		Blips['NPCDelivery'] = nil
	end

	Config.MekanikZones.VehicleDelivery.Type = -1

	NPCOnJob                = false
	NPCTargetTowable        = nil
	NPCTargetTowableZone    = nil
	NPCHasSpawnedTowable    = false
	NPCHasBeenNextToTowable = false

	if cancel then
		ESX.ShowNotification(_U('mission_canceled'))
	else
		--TriggerServerEvent('jn-mekanik:onNPCJobCompleted')
	end
end

RegisterNetEvent('jn-mekanik:bukacok')
AddEventHandler('jn-mekanik:bukacok', function()
	OpenMechanicActionsMenu()
end)

RegisterNetEvent('jn-mekanik:brankas')
AddEventHandler('jn-mekanik:brankas', function()
	local ox_inventory = exports.ox_inventory
	ox_inventory:openInventory('stash', 'brankas_mekanik')
end)

function OpenMechanicActionsMenu()
	local elements = {
		--{label = "Berangkas",   value = 'inv'},
		{label = _U('vehicle_list'),   value = 'vehicle_list'},
		{label = _U('work_wear'),      value = 'cloakroom'},
		{label = _U('civ_wear'),       value = 'cloakroom2'},
		--{label = 'Brankas Naruh',  value = 'put_stock'},
		--{label = 'Brankas Ambil', value = 'get_stock'},
		--{label = 'TOOLKIT <span style="color:green;">$ID1190</span>', value = 'belitoolkit'},
		--{label = 'KANEBO <span style="color:green;">$ID3.000</span>', value = 'belikanebo'},
		--{label = 'STANCER KIT <span style="color:green;">$ID500.000</span>', value = 'stancerkit'}
	}

	if Config.MekanikEnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' then
	--	table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_actions', {
		title    = _U('mechanic'),
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'inv' then
            TriggerEvent("esx_inventoryhud:openStorageInventory", "society_mechanic")
		elseif data.current.value == 'belirepairkit' then
            TriggerServerEvent('jn-mekanik:belirepairkit')
		elseif data.current.value == 'stancerkit' then
            TriggerServerEvent('jn-mekanik:stancerkit')
        elseif data.current.value == 'belitoolkit' then
            TriggerServerEvent('jn-mekanik:belitoolkit')
		elseif data.current.value == 'belikanebo' then
            TriggerServerEvent('jn-mekanik:belikanebo')
		elseif data.current.value == 'vehicle_list' then
			if Config.MekanikEnableSocietyOwnedVehicles then

				local elements = {}

				ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(vehicles)
					for i=1, #vehicles, 1 do
						table.insert(elements, {
							label = GetDisplayNameFromVehicleModel(vehicles[i].model) .. ' [' .. vehicles[i].plate .. ']',
							value = vehicles[i]
						})
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
						title    = _U('service_vehicle'),
						align    = 'top-right',
						elements = elements
					}, function(data, menu)
						menu.close()
						local vehicleProps = data.current.value

						ESX.Game.SpawnVehicle(vehicleProps.model, Config.MekanikZones.VehicleSpawnPoint.Pos, 270.0, function(vehicle)
							ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
							local playerPed = PlayerPedId()
							TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
							--exports["jn-kunci"]:givePlayerKeys(data.current.vehicleProps.plate)
						end)

						TriggerServerEvent('esx_society:removeVehicleFromGarage', 'mechanic', vehicleProps)
					end, function(data, menu)
						menu.close()
					end)
				end, 'mechanic')

			else

				local elements = {
					{label = _U('flat_bed'),  value = 'mechanic1'},
					{label = 'motor',  value = 'manchez'},
					--{label = _U('tow_truck'), value = 'hilux1'}
				}

				if Config.MekanikEnablePlayerManagement and ESX.PlayerData.job and (ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'amatir' or ESX.PlayerData.job.grade_name == 'ketua' or ESX.PlayerData.job.grade_name == 'ahli') then
					table.insert(elements, {label = 'Mobil Mekanik', value = 'f1501'})
					--table.insert(elements, {label = 'motor', value = 'manchez'})
				end

				ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle', {
					title    = _U('service_vehicle'),
					align    = 'top-right',
					elements = elements
				}, function(data, menu)
					if Config.MekanikMaxInService == -1 then
						ESX.Game.SpawnVehicle(data.current.value, Config.MekanikZones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
							local playerPed = PlayerPedId()
							TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
						end)
					else
						ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
							if canTakeService then
								ESX.Game.SpawnVehicle(data.current.value, Config.MekanikZones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
									local playerPed = PlayerPedId()
									TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
								end)
							else
								ESX.ShowNotification(_U('service_full') .. inServiceCount .. '/' .. maxInService)
							end
						end, 'mechanic')
					end

					menu.close()
				end, function(data, menu)
					menu.close()
					OpenMechanicActionsMenu()
				end)

			end
		elseif data.current.value == 'cloakroom' then
			menu.close()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		elseif data.current.value == 'cloakroom2' then
			menu.close()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'mechanic', function(data, menu)
				menu.close()
			end)
		end
	end, function(data, menu)
		menu.close()

		--CurrentAction     = 'mechanic_actions_menu'
		--CurrentActionMsg  = _U('open_actions')
		--CurrentActionData = {}
	end)
end

function OpenMechanicActionsMenu1()
	local elements = {
		{label = _U('vehicle_list'),   value = 'vehicle_list'},
		{label = _U('work_wear'),      value = 'cloakroom'},
		{label = _U('civ_wear'),       value = 'cloakroom2'},
		{label = 'Brankas Naruh',  value = 'put_stock'},
		{label = 'Brankas Ambil', value = 'get_stock'}
	}

	if Config.MekanikEnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_actions', {
		title    = _U('mechanic'),
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'vehicle_list' then
			if Config.MekanikEnableSocietyOwnedVehicles then

				local elements = {}

				ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(vehicles)
					for i=1, #vehicles, 1 do
						table.insert(elements, {
							label = GetDisplayNameFromVehicleModel(vehicles[i].model) .. ' [' .. vehicles[i].plate .. ']',
							value = vehicles[i]
						})
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
						title    = _U('service_vehicle'),
						align    = 'top-right',
						elements = elements
					}, function(data, menu)
						menu.close()
						local vehicleProps = data.current.value

						ESX.Game.SpawnVehicle(vehicleProps.model, Config.MekanikZones.VehicleSpawnPoint.Pos, 270.0, function(vehicle)
							ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
							local playerPed = PlayerPedId()
							TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
						end)

						TriggerServerEvent('esx_society:removeVehicleFromGarage', 'mechanic', vehicleProps)
					end, function(data, menu)
						menu.close()
					end)
				end, 'mechanic')

			else

				local elements = {
					{label = _U('flat_bed'),  value = 'kingranch17'},
					{label = _U('tow_truck'), value = 'raptortow'}
				}

				if Config.MekanikEnablePlayerManagement and ESX.PlayerData.job and (ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'chief' or ESX.PlayerData.job.grade_name == 'experimente') then
					table.insert(elements, {label = 'derek', value = 'cotrailer'})
					table.insert(elements, {label = 'motor', value = 'sanchez2'})
				end

				ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle', {
					title    = _U('service_vehicle'),
					align    = 'top-right',
					elements = elements
				}, function(data, menu)
					if Config.MekanikMaxInService == -1 then
						ESX.Game.SpawnVehicle(data.current.value, Config.MekanikZones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
							local playerPed = PlayerPedId()
							TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
						end)
					else
						ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
							if canTakeService then
								ESX.Game.SpawnVehicle(data.current.value, Config.MekanikZones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
									local playerPed = PlayerPedId()
									TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
								end)
							else
								ESX.ShowNotification(_U('service_full') .. inServiceCount .. '/' .. maxInService)
							end
						end, 'mechanic')
					end

					menu.close()
				end, function(data, menu)
					menu.close()
					OpenMechanicActionsMenu()
				end)

			end
		elseif data.current.value == 'cloakroom' then
			menu.close()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		elseif data.current.value == 'cloakroom2' then
			menu.close()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'mechanic', function(data, menu)
				menu.close()
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'mechanic_actions_menu1'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
	end)
end


function OpenMechanicHarvestMenu()
	if Config.MekanikEnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name ~= 'recrue' then
		local elements = {
			{label = _U('gas_can'), value = 'gaz_bottle'},
			{label = _U('repair_tools'), value = 'fix_tool'},
			{label = _U('body_work_tools'), value = 'caro_tool'}
		}

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_harvest', {
			title    = _U('harvest'),
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			menu.close()

			if data.current.value == 'gaz_bottle' then
				TriggerServerEvent('jn-mekanik:startHarvest')
			elseif data.current.value == 'fix_tool' then
				TriggerServerEvent('jn-mekanik:startHarvest2')
			elseif data.current.value == 'caro_tool' then
				TriggerServerEvent('jn-mekanik:startHarvest3')
			end
		end, function(data, menu)
			menu.close()
			CurrentAction     = 'mechanic_harvest_menu'
			CurrentActionMsg  = _U('harvest_menu')
			CurrentActionData = {}
		end)
	else
		ESX.ShowNotification(_U('not_experienced_enough'))
	end
end

function OpenMechanicCraftMenu()
	if Config.MekanikEnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name ~= 'recrue' then
		local elements = {
			{label = _U('nitro_no5'),  value = 'nitro'},
			{label = _U('repair_kit'), value = 'fix_kit'},
			-- {label = _U('body_kit'),   value = 'caro_kit'}
		}

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_craft', {
			title    = _U('craft'),
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			menu.close()

			if data.current.value == 'nitro' then
				TriggerServerEvent('jn-mekanik:startCraft')
			elseif data.current.value == 'fix_kit' then
				TriggerServerEvent('jn-mekanik:startCraft2')
			elseif data.current.value == 'caro_kit' then
				TriggerServerEvent('jn-mekanik:startCraft3')
			end
		end, function(data, menu)
			menu.close()

			CurrentAction     = 'mechanic_craft_menu'
			CurrentActionMsg  = _U('craft_menu')
			CurrentActionData = {}
		end)
	else
		ESX.ShowNotification(_U('not_experienced_enough'))
	end
end

--RegisterCommand('OpenMobileMechanicActionsMenu', function()
--	if not isDead and ESX.PlayerData ~= nil and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'mechanic' then
--		OpenMobileMechanicActionsMenu()
--	end
--end, false)

function OpenMobileMechanicActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mechanic_actions', {
		title    = _U('mechanic'),
		align    = 'bottom-right',
		elements = {
			{label = _U('billing'),       value = 'billing'},
			{label = _U('hijack'),        value = 'hijack_vehicle'},
			{label = _U('repair'),        value = 'fix_vehicle'},
			{label = _U('clean'),         value = 'clean_vehicle'},
			{label = _U('imp_veh'),       value = 'del_vehicle'},
			{label = _U('flat_bed'),      value = 'dep_vehicle'},
			{label = _U('place_objects'), value = 'object_spawner'}
		}
	}, function(data, menu)
		if isBusy then return end

		if data.current.value == 'billing' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				title = _U('invoice_amount')
			}, function(data, menu)
				local amount = tonumber(data.value)

				if amount == nil or amount < 0 then
					ESX.ShowNotification(_U('amount_invalid'))
				else
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('no_players_nearby'))
					else
						menu.close()
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mechanic', _U('mechanic'), amount)
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'hijack_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
				Citizen.CreateThread(function()
					--exports['progressBars']:startUI(15000, "MEMBUKA PAKSA KENDARAAN")
					Citizen.Wait(10000)

					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(_U('vehicle_unlocked'))
					isBusy = false
					--exports['progressBars']:closeUI()
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif data.current.value == 'fix_vehicle' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mechanic_fix_vehicle', {
				title    = _U('mechanic'),
				align    = 'bottom-right',
				elements = {
					{label = 'Bagian Depan',        value = 'depan'},
					{label = 'Bagian Bawah',       value = 'bawah'}
				}
			}, function(data1, menu1)
				local playerPed = PlayerPedId()
				local vehicle   = ESX.Game.GetVehicleInDirection()
				local coords    = GetEntityCoords(playerPed)
			
				if data1.current.value == 'depan' then
					if IsPedSittingInAnyVehicle(playerPed) then
						ESX.ShowNotification(_U('inside_vehicle'))
						return
					end
					
					if DoesEntityExist(vehicle) then
						isBusy = true
						TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
						Citizen.CreateThread(function()
						--	exports['pogressBar']:drawBar(25000, 'MEMPERBAIKI KENDARAAN')
						--	exports['progressBars']:startUI(25000, "MEMPERBAIKI KENDARAAN")
							Citizen.Wait(20000)

							SetVehicleFixed(vehicle)
							SetVehicleDeformationFixed(vehicle)
							SetVehicleUndriveable(vehicle, false)
							SetVehicleEngineOn(vehicle, true, true)
							ClearPedTasksImmediately(playerPed)
							
						--	exports['progressBars']:closeUI()

							ESX.ShowNotification(_U('vehicle_repaired'))
							isBusy = false
						end)
						ESX.UI.Menu.CloseAll()
					else
						ESX.ShowNotification(_U('no_vehicle_nearby'))
					end
				else
					if IsPedSittingInAnyVehicle(playerPed) then
						ESX.ShowNotification(_U('inside_vehicle'))
						return
					end
					
					if DoesEntityExist(vehicle) then
						SetEntityAsMissionEntity(veh, true, true)
						--TriggerServerEvent('jn-mekanik:RimuoviItem', playerPed, coords, vehicle)
						TriggerEvent('jn-mekanik:MettiCrick', playerPed, coords, vehicle)
						ESX.UI.Menu.CloseAll()
					else
						ESX.ShowNotification(_U('no_vehicle_nearby'))
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'clean_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
				Citizen.CreateThread(function()
				--	exports['progressBars']:startUI(15000, "MEMBERSIHKAN KENDARAAN")
					Citizen.Wait(10000)

					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowNotification(_U('vehicle_cleaned'))
					isBusy = false
				--	exports['progressBars']:closeUI()
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif data.current.value == 'del_vehicle' then
			local playerPed = PlayerPedId()

			if IsPedSittingInAnyVehicle(playerPed) then
				local vehicle = GetVehiclePedIsIn(playerPed, false)

				if GetPedInVehicleSeat(vehicle, -1) == playerPed then
					ESX.ShowNotification(_U('vehicle_impounded'))
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowNotification(_U('must_seat_driver'))
				end
			else
				local vehicle = ESX.Game.GetVehicleInDirection()

				if DoesEntityExist(vehicle) then
					ESX.ShowNotification(_U('vehicle_impounded'))
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowNotification(_U('must_near'))
				end
			end
		elseif data.current.value == 'dep_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(playerPed, true)

			local towmodel = GetHashKey('mechanic1')
			local isVehicleTow = IsVehicleModel(vehicle, towmodel)

			if isVehicleTow then
				local targetVehicle = ESX.Game.GetVehicleInDirection()

				if CurrentlyTowedVehicle == nil then
					if targetVehicle ~= 0 then
						if not IsPedInAnyVehicle(playerPed, true) then
							if vehicle ~= targetVehicle then
								AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
								CurrentlyTowedVehicle = targetVehicle
								ESX.ShowNotification(_U('vehicle_success_attached'))

								if NPCOnJob then
									if NPCTargetTowable == targetVehicle then
										ESX.ShowNotification(_U('please_drop_off'))
										Config.MekanikZones.VehicleDelivery.Type = 1

										if Blips['NPCTargetTowableZone'] then
											RemoveBlip(Blips['NPCTargetTowableZone'])
											Blips['NPCTargetTowableZone'] = nil
										end

										Blips['NPCDelivery'] = AddBlipForCoord(Config.MekanikZones.VehicleDelivery.Pos.x, Config.MekanikZones.VehicleDelivery.Pos.y, Config.MekanikZones.VehicleDelivery.Pos.z)
										SetBlipRoute(Blips['NPCDelivery'], true)
									end
								end
							else
								ESX.ShowNotification(_U('cant_attach_own_tt'))
							end
						end
					else
						ESX.ShowNotification(_U('no_veh_att'))
					end
				else
					AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
					DetachEntity(CurrentlyTowedVehicle, true, true)

					if NPCOnJob then
						if NPCTargetDeleterZone then

							if CurrentlyTowedVehicle == NPCTargetTowable then
								ESX.Game.DeleteVehicle(NPCTargetTowable)
								TriggerServerEvent('jn-mekanik:onNPCJobMissionCompleted')
								StopNPCJob()
								NPCTargetDeleterZone = false
							else
								ESX.ShowNotification(_U('not_right_veh'))
							end

						else
							ESX.ShowNotification(_U('not_right_place'))
						end
					end

					CurrentlyTowedVehicle = nil
					ESX.ShowNotification(_U('veh_det_succ'))
				end
			else
				ESX.ShowNotification(_U('imp_flatbed'))
			end
		elseif data.current.value == 'object_spawner' then
			local playerPed = PlayerPedId()

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mechanic_actions_spawn', {
				title    = _U('objects'),
				align    = 'top-right',
				elements = {
					{label = _U('roadcone'), value = 'prop_roadcone02a'},
					{label = _U('toolbox'),  value = 'prop_toolchest_01'}
			}}, function(data2, menu2)
				local model   = data2.current.value
				local coords  = GetEntityCoords(playerPed)
				local forward = GetEntityForwardVector(playerPed)
				local x, y, z = table.unpack(coords + forward * 1.0)

				if model == 'prop_roadcone02a' then
					z = z - 2.0
				elseif model == 'prop_toolchest_01' then
					z = z - 2.0
				end

				ESX.Game.SpawnObject(model, {x = x, y = y, z = z}, function(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))
					PlaceObjectOnGroundProperly(obj)
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('jn-mekanik:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			--print(string.format('%s: [%s]', items[i].name, items[i].label)) 
			if items[i].label ~= nil then
				table.insert(elements, {
					label = 'x' .. items[i].count .. ' ' .. items[i].label,
					value = items[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('mechanic_stock'),
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('invalid_quantity'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('jn-mekanik:getStockItem', itemName, count)

					Citizen.Wait(1000)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('jn-mekanik:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type  = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('inventory'),
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('invalid_quantity'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('jn-mekanik:putStockItems', itemName, count)

					Citizen.Wait(1000)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('jn-mekanik:kanebo')
AddEventHandler('jn-mekanik:kanebo', function()
	local playerPed = PlayerPedId()
	local vehicle   = ESX.Game.GetVehicleInDirection()
	local coords    = GetEntityCoords(playerPed)

	if IsPedSittingInAnyVehicle(playerPed) then
		ESX.ShowNotification(_U('inside_vehicle'))
		return
	end

	if DoesEntityExist(vehicle) then
		isBusy = true
		TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
		Citizen.CreateThread(function()
		--	exports['progressBars']:startUI(15000, "MEMBERSIHKAN KENDARAAN")
			Citizen.Wait(10000)

			SetVehicleDirtLevel(vehicle, 0)
			ClearPedTasksImmediately(playerPed)

			ESX.ShowNotification(_U('vehicle_cleaned'))
			isBusy = false
		--	exports['progressBars']:closeUI()
		end)
	else
		ESX.ShowNotification(_U('no_vehicle_nearby'))
	end
end)

RegisterNetEvent('jn-mekanik:onHijack')
AddEventHandler('jn-mekanik:onHijack', function()
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
		local alarm  = math.random(100)

		if DoesEntityExist(vehicle) then
			if alarm <= 33 then
				SetVehicleAlarm(vehicle, true)
				StartVehicleAlarm(vehicle)
			end

			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)

			Citizen.CreateThread(function()
			--	exports['progressBars']:startUI(15000, "MEMBUKA PAKSA KENDARAAN")
				Citizen.Wait(10000)
				if chance <= 66 then
					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)
					ESX.ShowNotification(_U('veh_unlocked'))
				else
					ESX.ShowNotification(_U('hijack_failed'))
					ClearPedTasksImmediately(playerPed)
				end
			--	exports['progressBars']:closeUI()
			end)
		end
	end
end)

RegisterNetEvent('jn-mekanik:onCarokit')
AddEventHandler('jn-mekanik:onCarokit', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_HAMMERING', 0, true)
			Citizen.CreateThread(function()
			--	exports['progressBars']:startUI(15000, "MEMPERBAIKI KENDARAAN")
				Citizen.Wait(10000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				ClearPedTasksImmediately(playerPed)
			--	exports['progressBars']:closeUI()
				ESX.ShowNotification(_U('body_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('jn-mekanik:onFixkit')
AddEventHandler('jn-mekanik:onFixkit', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
			Citizen.CreateThread(function()
			--	exports['progressBars']:startUI(25000, "MEMPERBAIKI KENDARAAN")

				Citizen.Wait(20000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				ClearPedTasksImmediately(playerPed)

			--	exports['progressBars']:closeUI()

				ESX.ShowNotification(_U('veh_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

AddEventHandler('jn-mekanik:hasEnteredMarker', function(zone)
	if zone == 'NPCJobTargetTowable' then

	elseif zone =='VehicleDelivery' then
		NPCTargetDeleterZone = true
	elseif zone == 'MechanicActions' then
		CurrentAction     = 'mechanic_actions_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
	--[[elseif zone == 'Garage' then
		CurrentAction     = 'mechanic_harvest_menu'
		CurrentActionMsg  = _U('harvest_menu')
		CurrentActionData = {}]]
	elseif zone == 'Craft' then
		CurrentAction     = 'mechanic_craft_menu'
		CurrentActionMsg  = _U('craft_menu')
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed,  false)

			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('veh_stored')
			CurrentActionData = {vehicle = vehicle}
		end
	elseif zone == 'MechanicActions1' then
		CurrentAction     = 'mechanic_actions_menu1'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
	--[[elseif zone == 'Garage1' then
		CurrentAction     = 'mechanic_harvest_menu'
		CurrentActionMsg  = _U('harvest_menu')
		CurrentActionData = {}]]
	elseif zone == 'Craft1' then
		CurrentAction     = 'mechanic_craft_menu'
		CurrentActionMsg  = _U('craft_menu')
		CurrentActionData = {}
	--[[elseif zone == 'Craft1' then
		CurrentAction     = 'mechanic_harvest_menu'
		CurrentActionMsg  = _U('harvest_menu')
		CurrentActionData = {}]]
	elseif zone == 'VehicleDeleter1' then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed,  false)

			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('veh_stored')
			CurrentActionData = {vehicle = vehicle}
		end
	end
end)

AddEventHandler('jn-mekanik:hasExitedMarker', function(zone)
	if zone =='VehicleDelivery' then
		NPCTargetDeleterZone = false
	elseif zone == 'Craft' then
		TriggerServerEvent('jn-mekanik:stopCraft')
		TriggerServerEvent('jn-mekanik:stopCraft2')
		TriggerServerEvent('jn-mekanik:stopCraft3')
	elseif zone == 'Garage' then
		TriggerServerEvent('jn-mekanik:stopHarvest')
		TriggerServerEvent('jn-mekanik:stopHarvest2')
		TriggerServerEvent('jn-mekanik:stopHarvest3')
	end

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('jn-mekanik:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' and not IsPedInAnyVehicle(playerPed, false) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('press_remove_obj')
		CurrentActionData = {entity = entity}
	end
end)

AddEventHandler('jn-mekanik:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('mechanic'),
		number     = 'mechanic',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEwAACxMBAJqcGAAAA4BJREFUWIXtll9oU3cUx7/nJA02aSSlFouWMnXVB0ejU3wcRteHjv1puoc9rA978cUi2IqgRYWIZkMwrahUGfgkFMEZUdg6C+u21z1o3fbgqigVi7NzUtNcmsac40Npltz7S3rvUHzxQODec87vfD+/e0/O/QFv7Q0beV3QeXqmgV74/7H7fZJvuLwv8q/Xeux1gUrNBpN/nmtavdaqDqBK8VT2RDyV2VHmF1lvLERSBtCVynzYmcp+A9WqT9kcVKX4gHUehF0CEVY+1jYTTIwvt7YSIQnCTvsSUYz6gX5uDt7MP7KOKuQAgxmqQ+neUA+I1B1AiXi5X6ZAvKrabirmVYFwAMRT2RMg7F9SyKspvk73hfrtbkMPyIhA5FVqi0iBiEZMMQdAui/8E4GPv0oAJkpc6Q3+6goAAGpWBxNQmTLFmgL3jSJNgQdGv4pMts2EKm7ICJB/aG0xNdz74VEk13UYCx1/twPR8JjDT8wttyLZtkoAxSb8ZDCz0gdfKxWkFURf2v9qTYH7SK7rQIDn0P3nA0ehixvfwZwE0X9vBE/mW8piohhl1WH18UQBhYnre8N/L8b8xQvlx4ACbB4NnzaeRYDnKm0EALCMLXy84hwuTCXL/ExoB1E7qcK/8NCLIq5HcTT0i6u8TYbXUM1cAyyveVq8Xls7XhYrvY/4n3gC8C+dsmAzL1YUiyfWxvHzsy/w/dNd+KjhW2yvv/RfXr7x9QDcmo1he2RBiCCI1Q8jVj9szPNixVfgz+UiIGyDSrcoRu2J16d3I6e1VYvNSQjXpnucAcEPUOkGYZs/l4uUhowt/3kqu1UIv9n90fAY9jT3YBlbRvFTD4fw++wHjhiTRL/bG75t0jI2ITcHb5om4Xgmhv57xpGOg3d/NIqryOR7z+r+MC6qBJB/ZB2t9Om1D5lFm843G/3E3HI7Yh1xDRAfzLQr5EClBf/HBHK462TG2J0OABXeyWDPZ8VqxmBWYscpyghwtTd4EKpDTjCZdCNmzFM9k+4LHXIFACJN94Z6FiFEpKDQw9HndWsEuhnADVMhAUaYJBp9XrcGQKJ4qFE9k+6r2+MG3k5N8VQ22TVglbX2ZwOzX2VvNKr91zmY6S7N6zqZicVT2WNLyVSehESaBhxnOALfMeYX+K/S2yv7wmMAlvwyuR7FxQUyf0fgc/jztfkJr7XeGgC8BJJgWNV8ImT+AAAAAElFTkSuQmCC'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- Pop NPC mission vehicle when inside area
--[[
	Citizen.CreateThread(function()
		Citizen.Wait(500)
		while true do
			Citizen.Wait(10)

			if NPCTargetTowableZone and not NPCHasSpawnedTowable then
				local coords = GetEntityCoords(PlayerPedId())
				local zone   = Config.Mechanic.Zones[NPCTargetTowableZone]

				if GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < Config.Mechanic.NPCSpawnDistance then
					local model = Config.Mechanic.Vehicles[GetRandomIntInRange(1,  #Config.Mechanic.Vehicles)]

					ESX.Game.SpawnVehicle(model, zone.Pos, 0, function(vehicle)
						NPCTargetTowable = vehicle
					end)

					NPCHasSpawnedTowable = true
				end
			end

			if NPCTargetTowableZone and NPCHasSpawnedTowable and not NPCHasBeenNextToTowable then
				local coords = GetEntityCoords(PlayerPedId())
				local zone   = Config.Mechanic.Zones[NPCTargetTowableZone]

				if GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < Config.Mechanic.NPCNextToDistance then
					ESX.ShowNotification(_U('please_tow'))
					NPCHasBeenNextToTowable = true
				end
			end
		end
	end)
]]

-- Create Blips
--[[Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Mechanic.Zones.MechanicActions.Pos.x, Config.Mechanic.Zones.MechanicActions.Pos.y, Config.Mechanic.Zones.MechanicActions.Pos.z)

	SetBlipSprite (blip, 446)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.5)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('mechanic'))
	EndTextCommandSetBlipName(blip)
	
	
	local blips = {
		{x= 119.24, y= 6611.2, z= 31.9},
		{x = 1770.52, y = 3319.69, z = 40.67}
	}
	
	for _, info in pairs(blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite (info.blip, 446)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale  (info.blip, 1.5)
		SetBlipColour (info.blip, 5)
		SetBlipAsShortRange(info.blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('mechanic'))
		EndTextCommandSetBlipName(info.blip)
    end
end)]]

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			local coords      = GetEntityCoords(PlayerPedId())
			local sleep 	  = true
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.MekanikZones) do
				local distance = GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true)

				if v.Type ~= -1 and distance < Config.MekanikDrawDistance then
					sleep = false
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, nil, nil, false)
					if(distance < v.Size.x) then
						isInMarker  = true
						currentZone = k
						break
					end
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('jn-mekanik:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('jn-mekanik:hasExitedMarker', LastZone)
			end

			if sleep then
				Wait(1000)
			end
		else
			Wait(5000)
		end
	end
end)

Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_toolchest_01'
	}

	Citizen.Wait(500)

	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
		local sleep		= true

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(coords, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				sleep = false
				local objCoords = GetEntityCoords(object)
				local distance  = GetDistanceBetweenCoords(coords, objCoords, true)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
					break
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('jn-mekanik:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity then
				TriggerEvent('jn-mekanik:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end

		if sleep then
			Wait(3000)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	
	Citizen.Wait(500)

	while true do
		Citizen.Wait(10)

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			if not isDead then
				-- if IsControlJustReleased(0, 167) then
				-- 	OpenMobileMechanicActionsMenu()
				-- else
				if IsControlJustReleased(0, 178) then
					if NPCOnJob then
						if GetGameTimer() - NPCLastCancel > 5 * 60000 then
							StopNPCJob(true)
							NPCLastCancel = GetGameTimer()
						else
							ESX.ShowNotification(_U('wait_five'))
						end
					else
						local playerPed = PlayerPedId()
		
						if IsPedInAnyVehicle(playerPed, false) and IsVehicleModel(GetVehiclePedIsIn(playerPed, false), GetHashKey('mechanic1')) then
							StartNPCJob()
						else
							ESX.ShowNotification(_U('must_in_flatbed'))
						end
					end
				elseif CurrentAction then
					ESX.ShowHelpNotification(CurrentActionMsg)
		
					if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
		
						if CurrentAction == 'mechanic_actions_menu' then
							OpenMechanicActionsMenu()
						elseif CurrentAction == 'mechanic_actions_menu1' then
							OpenMechanicActionsMenu1()
						elseif CurrentAction == 'mechanic_harvest_menu' then
							OpenMechanicHarvestMenu()
						elseif CurrentAction == 'mechanic_craft_menu' then
							OpenMechanicCraftMenu()
						elseif CurrentAction == 'delete_vehicle' then
		
							if Config.MekanikEnableSocietyOwnedVehicles then
		
								local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
								TriggerServerEvent('esx_society:putVehicleInGarage', 'mechanic', vehicleProps)
		
							else
		
								if
									GetEntityModel(vehicle) == GetHashKey('mechanic1')   or
									GetEntityModel(vehicle) == GetHashKey('towtruck2') or
									GetEntityModel(vehicle) == GetHashKey('manchez') or
									GetEntityModel(vehicle) == GetHashKey('f1501')
								then
									TriggerServerEvent('esx_service:disableService', 'mechanic')
								end
		
							end
		
							ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
		
						elseif CurrentAction == 'remove_entity' then
							DeleteEntity(CurrentActionData.entity)
						end
		
						CurrentAction = nil
					end
				else
					-- Wait(500)
				end
			else
				Wait(1000)
			end
		else
			Wait(5000)
		end

	end
end)

RegisterNetEvent('jn-mekanik:MettiCrick')
AddEventHandler('jn-mekanik:MettiCrick', function(ped, coords, veh)
	local dict
	local model = 'prop_carjack'
	local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, -2.0, 0.0)
	local headin = GetEntityHeading(ped)
	local vehicle   = ESX.Game.GetVehicleInDirection()
	FreezeEntityPosition(veh, true)
	local vehpos = GetEntityCoords(veh)
	dict = 'mp_car_bomb'
	RequestAnimDict(dict)
	RequestModel(model)
	while not HasAnimDictLoaded(dict) or not HasModelLoaded(model) do
		Citizen.Wait(1)
	end
	local vehjack = CreateObject(GetHashKey(model), vehpos.x, vehpos.y, vehpos.z - 0.5, true, true, true)
--	exports['progressBars']:startUI(9250, "DONGKRAK KENDARAAN") -- TRANSLATE THIS, THAT SAY WHEN YOU PUT THE CRIC
	AttachEntityToEntity(vehjack, veh, 0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1250, 1, 0.0, 1, 1)
	Citizen.Wait(1250)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.01, true, true, true)
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
	Citizen.Wait(1000)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.025, true, true, true)
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
	Citizen.Wait(1000)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.05, true, true, true)
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
	Citizen.Wait(1000)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.1, true, true, true)
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
	Citizen.Wait(1000)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.15, true, true, true)
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
	Citizen.Wait(1000)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.2, true, true, true)
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
	Citizen.Wait(1000)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.3, true, true, true)
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
	dict = 'move_crawl'
	Citizen.Wait(1000)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.4, true, true, true)
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.5, true, true, true)
	SetEntityCollision(veh, false, false)
	TaskPedSlideToCoord(ped, offset, headin, 1000)
	Citizen.Wait(1000)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
	Citizen.Wait(100)
--	exports['progressBars']:startUI(11000, "MEMPERBAIKI KENDARAAN") -- TRANSLATE THIS - THAT SAY WHEN YOU REPAIR THE VEHICLE
	TaskPlayAnimAdvanced(ped, dict, 'onback_bwd', coords, 0.0, 0.0, headin - 180, 1.0, 0.5, 3000, 1, 0.0, 1, 1)
	dict = 'amb@world_human_vehicle_mechanic@male@base'
	Citizen.Wait(3000)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(1)
	end
	TaskPlayAnim(ped, dict, 'base', 8.0, -8.0, 5000, 1, 0, false, false, false)
	dict = 'move_crawl'
	Citizen.Wait(5000)
	local coords2 = GetEntityCoords(ped)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(1)
	end
	TaskPlayAnimAdvanced(ped, dict, 'onback_fwd', coords2, 0.0, 0.0, headin - 180, 1.0, 0.5, 2000, 1, 0.0, 1, 1)
	Citizen.Wait(3000)
	dict = 'mp_car_bomb'
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(1)
	end
	SetVehicleFixed(vehicle)
	SetVehicleDeformationFixed(vehicle)
	SetVehicleUndriveable(vehicle, false)
	SetVehicleEngineOn(vehicle, true, true)
	ClearPedTasksImmediately(playerPed)
	Citizen.Wait(100)
--	exports['progressBars']:startUI(8250, "MENCOPOT DONGKRAK") -- TLANSTALE THIS - THAT SAY WHEN YOU LEAVE THE CRIC
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1250, 1, 0.0, 1, 1)
	Citizen.Wait(1250)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.4, true, true, true)
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
	Citizen.Wait(1000)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.3, true, true, true)
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
	Citizen.Wait(1000)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.2, true, true, true)
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
	Citizen.Wait(1000)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.15, true, true, true)
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
	Citizen.Wait(1000)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.1, true, true, true)
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
	Citizen.Wait(1000)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.05, true, true, true)
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
	Citizen.Wait(1000)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.025, true, true, true)
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
	dict = 'move_crawl'
	Citizen.Wait(1000)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.01, true, true, true)
	TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, headin, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
	SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z, true, true, true)
	FreezeEntityPosition(veh, false)
	DeleteObject(vehjack)
	SetEntityCollision(veh, true, true)
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

RegisterNetEvent('startProgbar')
AddEventHandler('startProgbar', function(dur, text)
--	exports['progressBars']:startUI(dur, text)
end)

RegisterNetEvent('stopProgbar')
AddEventHandler('stopProgbar', function(dur, text)
--	exports['progressBars']:closeUI()
end)

RegisterCommand('menumeka', function(source, args)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
	 	TriggerEvent('jn-mekanik:actmenu', args[1])
	end
end)

RegisterNetEvent('jn-mekanik:actmenu')
AddEventHandler('jn-mekanik:actmenu', function(type)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
		if type == 'repair' then
			local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end
			if DoesEntityExist(vehicle) then
				ESX.TriggerServerCallback("jn-mekanik:checktoolkit" , function(result)
					if result then
						SetVehicleDoorOpen(vehicle, 4, false, false)
						isBusy = true
						TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
						Citizen.CreateThread(function()
							local finished = exports["jn-taskbarskill"]:taskBar(12000,math.random(5,8))
							if finished ~= 100 then
								ClearPedTasksImmediately(playerPed)
								exports['alan-tasknotify']:DoHudText('error', "Gagal Di Repair")
								isBusy = false
								SetVehicleDoorShut(vehicle, 4, false)
								return
							end
							if finished == 100 then
								local finished2 = exports["jn-taskbarskill"]:taskBar(9000,math.random(4,7))
								if finished2 ~= 100 then
									ClearPedTasksImmediately(playerPed)
									exports['alan-tasknotify']:DoHudText('error', "Gagal Di Repair")
									isBusy = false
									SetVehicleDoorShut(vehicle, 4, false)
									return
								end
								if finished2 == 100 then
									local finished3 = exports["jn-taskbarskill"]:taskBar(9000,math.random(3,5))
									if finished3 ~= 100 then
										ClearPedTasksImmediately(playerPed)
										exports['alan-tasknotify']:DoHudText('error', "Gagal DI Repair")
										isBusy = false
										SetVehicleDoorShut(vehicle, 4, false)
										return
									end
									if finished3 == 100 then
										SetVehicleFixed(vehicle)
										SetVehicleDeformationFixed(vehicle)
										SetVehicleUndriveable(vehicle, false)
										SetVehicleEngineOn(vehicle, true, true)
										ClearPedTasksImmediately(playerPed)
										ESX.ShowNotification(_U('vehicle_repaired'))
										isBusy = false
										SetVehicleDoorShut(vehicle, 4, false)
									end
								end
							end
						end)
					else
						exports['alan-tasknotify']:DoHudText('error', "Tidak Punya Toolkit")
					end
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif type == 'hijack' then
			TriggerEvent('jn-mekanik:onHijack')
		elseif type == 'tow' then
			local playerPed = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(playerPed, true)

			local towmodel = GetHashKey('mechanic1')
			local isVehicleTow = IsVehicleModel(vehicle, towmodel)

			if isVehicleTow then
				local targetVehicle = ESX.Game.GetVehicleInDirection()

				if CurrentlyTowedVehicle == nil then
					if targetVehicle ~= 0 then
						if not IsPedInAnyVehicle(playerPed, true) then
							if vehicle ~= targetVehicle then
								AttachEntityToEntity(targetVehicle, vehicle, 20, 0.2, -6.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
								CurrentlyTowedVehicle = targetVehicle
								ESX.ShowNotification(_U('vehicle_success_attached'))

								if NPCOnJob then
									if NPCTargetTowable == targetVehicle then
										ESX.ShowNotification(_U('please_drop_off'))
										Config.MekanikZones.VehicleDelivery.Type = 1

										if Blips['NPCTargetTowableZone'] then
											RemoveBlip(Blips['NPCTargetTowableZone'])
											Blips['NPCTargetTowableZone'] = nil
										end

										Blips['NPCDelivery'] = AddBlipForCoord(Config.MekanikZones.VehicleDelivery.Pos.x, Config.MekanikZones.VehicleDelivery.Pos.y, Config.MekanikZones.VehicleDelivery.Pos.z)
										SetBlipRoute(Blips['NPCDelivery'], true)
									end
								end
							else
								ESX.ShowNotification(_U('cant_attach_own_tt'))
							end
						end
					else
						ESX.ShowNotification(_U('no_veh_att'))
					end
				else
					AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, 0.2, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
					DetachEntity(CurrentlyTowedVehicle, true, true)

					if NPCOnJob then
						if NPCTargetDeleterZone then

							if CurrentlyTowedVehicle == NPCTargetTowable then
								ESX.Game.DeleteVehicle(NPCTargetTowable)
								TriggerServerEvent('jn-mekanik:onNPCJobMissionCompleted')
								StopNPCJob()
								NPCTargetDeleterZone = false
							else
								ESX.ShowNotification(_U('not_right_veh'))
							end

						else
							ESX.ShowNotification(_U('not_right_place'))
						end
					end

					CurrentlyTowedVehicle = nil
					ESX.ShowNotification(_U('veh_det_succ'))
				end
			else
				ESX.ShowNotification(_U('imp_flatbed'))
			end
		elseif type == 'clean' then
			local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)
		
			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end
		
			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
				Citizen.CreateThread(function()
				--	exports['progressBars']:startUI(15000, "MEMBERSIHKAN KENDARAAN")
					Citizen.Wait(10000)
		
					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)
		
					ESX.ShowNotification(_U('vehicle_cleaned'))
					isBusy = false
				--	exports['progressBars']:closeUI()
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif type == 'pound' then
			local playerPed = PlayerPedId()

			if IsPedSittingInAnyVehicle(playerPed) then
				local vehicle = GetVehiclePedIsIn(playerPed, false)

				if GetPedInVehicleSeat(vehicle, -1) == playerPed then
					ESX.ShowNotification(_U('vehicle_impounded'))
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowNotification(_U('must_seat_driver'))
				end
			else
				local vehicle = ESX.Game.GetVehicleInDirection()

				if DoesEntityExist(vehicle) then
					ESX.ShowNotification(_U('vehicle_impounded'))
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowNotification(_U('must_near'))
				end
			end
		elseif type == 'invoice' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				title = _U('invoice_amount')
			}, function(data, menu)
				local amount = tonumber(data.value)
			
				if amount == nil or amount < 0 then
					ESX.ShowNotification(_U('amount_invalid'))
				else
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('no_players_nearby'))
					else
						menu.close()
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mechanic', _U('mechanic'), amount)
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		end
	end
end)

-- TODO RADIAL MENU EVENT 
RegisterNetEvent('bobolmecha')
AddEventHandler('bobolmecha', function ()
	local playerPed = PlayerPedId()
	local vehicle   = ESX.Game.GetVehicleInDirection()
	local coords    = GetEntityCoords(playerPed)
	if IsPedSittingInAnyVehicle(playerPed) then
		ESX.ShowNotification(_U('inside_vehicle'))
		return
	end
	if DoesEntityExist(vehicle) then
			isBusy = true
			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
			
			ExecuteCommand("me Membobol Kendaraan")
			exports.rprogress:Custom({
				Label = "",
				Duration = 10000,
				DisableControls = {
					Mouse = false,
					Player = true,
					Vehicle = true
				},
			})
			Citizen.CreateThread(function()
				Citizen.Wait(10000)

				SetVehicleDoorsLocked(vehicle, 1)
				SetVehicleDoorsLockedForAllPlayers(vehicle, false)
				ClearPedTasksImmediately(playerPed)

				ESX.ShowNotification(_U('vehicle_unlocked'))
				isBusy = false
			end)
	else
		ESX.ShowNotification(_U('no_vehicle_nearby'))
	end
end)

RegisterNetEvent('repairmech')
AddEventHandler('repairmech', function ()
	local playerPed = PlayerPedId()
	local vehicle   = ESX.Game.GetVehicleInDirection()
	local coords    = GetEntityCoords(playerPed)
	if IsPedSittingInAnyVehicle(playerPed) then
		local vehiclein = GetVehiclePedIsIn(playerPed, false)
		ESX.ShowNotification(_U('inside_vehicle'))
		TaskLeaveVehicle(PlayerPedId(), vehiclein, 0)
		return
	end
	if exports['alan-core']:itemCount('toolkit') > 0 then
	if DoesEntityExist(vehicle) then
			if not sibuk then
				sibuk = true
				TriggerServerEvent('alan-core:delItem', 'toolkit', 1)
				exports.ox_inventory:Progress({
					duration = 10000,
					label = 'Memperbaiki Kendaraan...',
					useWhileDead = false,
					canCancel = true,
					disable = {
						move = true,
						car = false,
						combat = true,
						mouse = false
					},
					anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
				}, function(cancel)
					if not cancel then
						SetVehicleFixed(vehicle)
						SetVehicleDeformationFixed(vehicle)
						SetVehicleUndriveable(vehicle, false)
						SetVehicleEngineOn(vehicle, true, true)
						ClearPedSecondaryTask(playerPed)
						exports['alan-tasknotify']:DoHudText('inform', 'Kendaraan Telah Diperbaiki!')
						sibuk = false
					else
						TriggerServerEvent('alan-core:NambahItems', 'toolkit', 1)
						sibuk = false
						exports['alan-tasknotify']:DoHudText('error', 'Perbaikan Dibatalkan!')
					end
				end)
			end
		else
			exports['alan-tasknotify']:DoHudText('error', 'Tidak Ada Kendaraan Disekitar!')
	end
	else
		exports['alan-tasknotify']:DoHudText('error', 'Tidak Memiliki toolkit!')
	end
end)

RegisterNetEvent('cleanmech')
AddEventHandler('cleanmech', function ()
	local playerPed = PlayerPedId()
	local vehicle   = ESX.Game.GetVehicleInDirection()
	local coords    = GetEntityCoords(playerPed)
	if IsPedSittingInAnyVehicle(playerPed) then
		ESX.ShowNotification(_U('inside_vehicle'))
		return
	end
	if exports['alan-core']:itemCount('kanebo') > 0 then
	if DoesEntityExist(vehicle) then
		if not sibuk then
            sibuk = true
			TriggerServerEvent('alan-core:delItem', 'kanebo', 1)
            exports.ox_inventory:Progress({
                duration = 5000,
                label = 'Mencuci Kendaraan...',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    move = true,
                    car = true,
                    combat = true,
                    mouse = false
                },
                anim = {
                    scenario = "WORLD_HUMAN_MAID_CLEAN",
                },
            }, function(cancel)
                if not cancel then
					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)
					exports['alan-tasknotify']:DoHudText('error', 'Kendaraan Telah Di Cuci!')
                    sibuk = false
                else
                    sibuk = false
					TriggerServerEvent('alan-core:NambahItems', 'kanebo', 1)
                    exports['alan-tasknotify']:DoHudText('error', 'Cuci Dibatalkan!')
                end
            end)
        end
	else
		exports['alan-tasknotify']:DoHudText('error', 'Tidak Ada Kendaraan Disekitar!')
	end
	else
		exports['alan-tasknotify']:DoHudText('error', 'Tidak memiliki kanebo!')
	end
end)

RegisterNetEvent('sitamech')
AddEventHandler('sitamech', function ()
	local playerPed = PlayerPedId()
	local vehicle = ESX.Game.GetVehicleInDirection()
	if IsPedSittingInAnyVehicle(playerPed) then
		local vehiclein = GetVehiclePedIsIn(playerPed, false)
		ESX.ShowNotification(_U('inside_vehicle'))
		TaskLeaveVehicle(PlayerPedId(), vehiclein, 0)
		return
	end
	if DoesEntityExist(vehicle) then
		local vehicle = ESX.Game.GetVehicleInDirection()
		ExecuteCommand("me Mengasuransikan Kendaraan")
		exports.rprogress:Custom({
			Label = "",
			Duration = 10000,
			DisableControls = {
				Mouse = false,
				Player = true,
				Vehicle = true
			},
		})
		TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
		Citizen.Wait(10000)
		ClearPedTasks(playerPed)
		ESX.ShowNotification(_U('vehicle_impounded'))
		ESX.Game.DeleteVehicle(vehicle)
	else
		ESX.ShowNotification(_U('must_near'))
	end
end)

RegisterNetEvent('towing')
AddEventHandler('towing', function ()
	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, true)

	local towmodel = GetHashKey('mechanic1')
	local isVehicleTow = IsVehicleModel(vehicle, towmodel)

	if isVehicleTow then
		local targetVehicle = ESX.Game.GetVehicleInDirection()

		if CurrentlyTowedVehicle == nil then
			if targetVehicle ~= 0 then
				if not IsPedInAnyVehicle(playerPed, true) then
					if vehicle ~= targetVehicle then
						AttachEntityToEntity(targetVehicle, vehicle, 20, 0.2, -6.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
						CurrentlyTowedVehicle = targetVehicle
						ESX.ShowNotification(_U('vehicle_success_attached'))

						if NPCOnJob then
							if NPCTargetTowable == targetVehicle then
								ESX.ShowNotification(_U('please_drop_off'))
								Config.MekanikZones.VehicleDelivery.Type = 1

								if Blips['NPCTargetTowableZone'] then
									RemoveBlip(Blips['NPCTargetTowableZone'])
									Blips['NPCTargetTowableZone'] = nil
								end

								Blips['NPCDelivery'] = AddBlipForCoord(Config.MekanikZones.VehicleDelivery.Pos.x, Config.MekanikZones.VehicleDelivery.Pos.y, Config.MekanikZones.VehicleDelivery.Pos.z)
								SetBlipRoute(Blips['NPCDelivery'], true)
							end
						end
					else
						ESX.ShowNotification(_U('cant_attach_own_tt'))
					end
				end
			else
				ESX.ShowNotification(_U('no_veh_att'))
			end
		else
			AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, 0.2, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
			DetachEntity(CurrentlyTowedVehicle, true, true)

			if NPCOnJob then
				if NPCTargetDeleterZone then

					if CurrentlyTowedVehicle == NPCTargetTowable then
						ESX.Game.DeleteVehicle(NPCTargetTowable)
						TriggerServerEvent('jn-mekanik:onNPCJobMissionCompleted')
						StopNPCJob()
						NPCTargetDeleterZone = false
					else
						ESX.ShowNotification(_U('not_right_veh'))
					end

				else
					ESX.ShowNotification(_U('not_right_place'))
				end
			end

			CurrentlyTowedVehicle = nil
			ESX.ShowNotification(_U('veh_det_succ'))
		end
	else
		ESX.ShowNotification(_U('imp_flatbed'))
	end
end)

RegisterNetEvent('dl-job:billingmecha')
AddEventHandler('dl-job:billingmecha', function()
	local input = lib.inputDialog('BILLING MEKANIK', {'ID PLAYER: ', 'JUMLAH: '})

	if input then
		local idplayer = tonumber(input[1])
		local jumlah = input[2]
		TriggerServerEvent('esx_billing:sendBill', idplayer, 'society_mechanic', 'MEKANIK', jumlah)
	end
end)

RegisterNetEvent('dl-mech:bossmenu')
AddEventHandler('dl-mech:bossmenu', function(data, menu)
	ESX.UI.Menu.CloseAll()
	TriggerEvent('esx_society:openBossMenu', 'mechanic', function(data, menu)
		menu.close()
	end, { wash = false }) -- disable washing money
end)

RegisterNetEvent('alan-context:DutyMecha', function()
	TriggerEvent('alan-context:sendMenu', {
		{
			id = 1,
			header = "Mechanic Duty",
			txt = ""
		},
		{
			id = 2,
			header = "⚠️On Duty",
			txt = "ON DUTY MECHANIC",
			params = {
				event = "dl-duty:onoff",
				args = {
					number = 1,
					id = 2
				}
			}
		},
		{
			id = 3,
			header = "⚠️Off Duty",
			txt = "OFF DUTY MECHANIC",
			params = {
				event = "dl-duty:onoff",
				args = {
					number = 1,
					id = 3
				}
			}
		},
	})
  end)

  exports.ox_target:AddBoxZone("bosme", vector3(56.18, 6563.03, 31.75), 1, 1, {
	name = "bosme",
	heading = 310,
	debugPoly = false,
	minZ = 30.75,
	maxZ = 34.75
	}, {
		options = {
			{
				event = "alan-context:DutyMecha",
				icon = "fas fa-sign-in-alt",
				label = "Duty Management",
                job = {
					["mechanic"] = 0,
					["offmechanic"] = 0,
				}
			},
            {
                event = "documents:open",
                icon = "fas fa-clipboard",
                label = "Buat Dokumen",
                job = {
					["mechanic"] = 1,
				}
            },
			{
				event = "dl-mech:bossmenu",
				icon = "fas fa-sign-in-alt",
				label = "Employee List!",
                job = {
					["mechanic"] = 3,
				}
			},
		},
		distance = 2
})

  exports.ox_target:AddBoxZone("dutymeckota", vector3(-215.9, -1334.68, 30.89), 1, 1, {
	name = "dutymeckota",
	heading = 0,
	debugPoly = false,
	minZ = 29.89,
	maxZ = 33.89
	}, {
		options = {
			{
				event = "alan-context:DutyMecha",
				icon = "fas fa-sign-in-alt",
				label = "Duty Management",
                job = {
					["mechanic"] = 0,
					["offmechanic"] = 0,
				}
			},
		},
		distance = 2
})

local alan = 0

local coordsberangkasMechanic = {
	{x = 47.33, y = 6559.13, z = 37.76, h = 65},
}

local BossMecha = {
	{x = 60.982475280762, y = 6545.4033203125, z = 38.398662567139, h = 25}
}

Citizen.CreateThread(function()
	for k,v in pairs(coordsberangkasMechanic) do
		alan = alan + 1
		exports["ox_target"]:AddBoxZone("coordsberangkasMechanic" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
			name = "coordsberangkasMechanic" .. alan,
			heading = v.h,
			debugPoly = false,
			minZ = v.z - 1.0,
			maxZ = v.z + 2.0
		}, {
			options = {
			{
			event = "jn-mekanik:bukacok",
			icon = "fas fa-suitcase",
			label = "Menu Mechanic",
			job = {
				["mechanic"] = 0,
			}
			},
			{
				event = "jn-mekanik:brankas",
				icon = "fas fa-suitcase",
				label = "INVENTORY",
				job = {
					["mechanic"] = 0,
				}
			},
			{
			event = " ",
			icon = "fas fa-times-circle",
			label = "Cancel",
			job = {
				["mechanic"] = 0,
			}
			},
			},
			distance = 2.0
		})
	end
	for k,v in pairs(BossMecha) do
		alan = alan + 1
		exports["ox_target"]:AddBoxZone("BossMecha" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
			name = "BossMecha" .. alan,
			heading = v.h,
			debugPoly = false,
			minZ = v.z - 1.0,
			maxZ = v.z + 2.0
		}, {
			options = {
				{
					event = "dl-mech:bossmenu",
					icon = "fas fa-sign-in-alt",
					label = "Employee List!",
					job = {
						["mechanic"] = 3,
					}
				},
				{
					event = "alan-context:DutyMecha",
					icon = "fas fa-sign-in-alt",
					label = "Duty Management",
					job = {
						["mechanic"] = 0,
						["offmechanic"] = 0,
					}
				},
			},
			distance = 2.0
		})
	end
end)