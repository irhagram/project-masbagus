local CurrentAction             = nil
local GUI                       = {}
GUI.Time                        = 0
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local times                     = 0
local this_Garage               = {}
local Vehicles 			        = nil
local BlipList = {}
local userProperties, userProperties1 = {}, {}
local PrivateBlips = {}
local PrivateBlips1 = {}
local vehicles1 = {}
local garage_position = 'Garkot'

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    Wait(10000)

    ESX.TriggerServerCallback('midp-garasi:getOwnedProperties', function(properties)
		userProperties = properties
        DeletePrivateBlips()
        RefreshPrivateBlips()
	end)
    ESX.TriggerServerCallback('midp-garasi:getOwnedProperties1', function(properties)
		userProperties1 = properties
        DeletePrivateBlips()
        RefreshPrivateBlips()
	end)

   ESX.PlayerLoaded = true
   DeleteJobBlips()
   createBlips()
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	PlayerData = {}
end)

function has_value(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end
function DeleteJobBlips()
	if BlipList[1] ~= nil then
		for i=1, #BlipList, 1 do
			RemoveBlip(BlipList[i])
			BlipList[i] = nil
		end
	end
end

function createBlips()
    local zones = {}
    local blipInfo = {}

    for zoneKey, zoneValues in pairs(Config.Garages) do
        if zoneValues.SpawnPoint then
            local blip = AddBlipForCoord(zoneValues.SpawnPoint.Pos.x, zoneValues.SpawnPoint.Pos.y, zoneValues.SpawnPoint.Pos.z)

            SetBlipSprite(blip, Config.BlipInfos.Sprite)
			SetBlipColour(blip, Config.BlipInfos.Color)
			SetBlipDisplay(blip, 2)
			SetBlipScale(blip, 0.55)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
            SetBlipCategory(blip, 255)
			AddTextComponentString(zoneValues.Nomor)
			EndTextCommandSetBlipName(blip)
			table.insert(BlipList, blip)
        end


        if zoneValues.MunicipalPoundPoint then
			local blip = AddBlipForCoord(zoneValues.MunicipalPoundPoint.Pos.x, zoneValues.MunicipalPoundPoint.Pos.y, zoneValues.MunicipalPoundPoint.Pos.z)
            SetBlipSprite(blip, Config.BlipPound.Sprite)
			SetBlipColour(blip, Config.BlipPound.Color)
			SetBlipDisplay(blip, 2)
			SetBlipScale(blip, 0.55)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString('Asuransi')
			EndTextCommandSetBlipName(blip)
			table.insert(BlipList, blip)
		end
    end
end

function DeletePrivateBlips()
	if PrivateBlips[1] ~= nil then
		for i=1, #PrivateBlips, 1 do
			RemoveBlip(PrivateBlips[i])
			PrivateBlips[i] = nil
		end
	end

    if PrivateBlips1[1] ~= nil then
		for i=1, #PrivateBlips1, 1 do
			RemoveBlip(PrivateBlips1[i])
			PrivateBlips1[i] = nil
		end
	end
end

function RefreshPrivateBlips()
	for zoneKey,zoneValues in pairs(Config.PrivateGarages) do
		if zoneValues.Private and has_value(userProperties, zoneValues.Private) then
			local blip = AddBlipForCoord(zoneValues.SpawnPoint.Pos.x, zoneValues.SpawnPoint.Pos.y, zoneValues.SpawnPoint.Pos.z)

			SetBlipSprite(blip, Config.BlipInfos.Sprite)
			SetBlipColour(blip, Config.BlipInfos.Color)
			SetBlipDisplay(blip, 2)
			SetBlipScale(blip, 0.55)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString('Garasi ' .. zoneValues.Nomor)
			EndTextCommandSetBlipName(blip)
			table.insert(PrivateBlips, blip)
		end
            if zoneValues.Private and has_value(userProperties1, zoneValues.Private) then
                local blip = AddBlipForCoord(zoneValues.SpawnPoint.Pos.x, zoneValues.SpawnPoint.Pos.y, zoneValues.SpawnPoint.Pos.z)
    
                SetBlipSprite(blip, Config.BlipInfos.Sprite)
                SetBlipColour(blip, Config.BlipInfos.Color)
                SetBlipDisplay(blip, 2)
                SetBlipScale(blip, 0.55)
                SetBlipAsShortRange(blip, true)
    
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString('Garasi ' .. zoneValues.Nomor)
                EndTextCommandSetBlipName(blip)
                table.insert(PrivateBlips1, blip)
            end
	end
end

function OpenMenuGarage(PointType, garage)
    ESX.UI.Menu.CloseAll()
    local elements = {}

    if PointType == 'spawn' then
        table.insert(elements, {
            label = 'List Kendaraan',
            value = 'list_vehicles'
        })
    end

    if PointType == 'delete' then
        table.insert(elements, {
            label = 'List Kendaraan',
            value = 'stock_vehicle'
        })
    end

    if PointType == 'pound' then
        table.insert(elements, {
            label = 'Ambil Kendaraan',
            value = 'return_vehicle'
        })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage_menu', {
        title = 'Garasi',
        align = 'left',
        elements = elements
    }, function(data, menu)
        menu.close()

        if (data.current.value == 'list_vehicles') then
            ListVehiclesMenu()
        end

        if (data.current.value == 'stock_vehicle') then
            StockVehicleMenu()
        end

        if (data.current.value == 'return_vehicle') then
            ReturnVehicleMenu()
        end

        local playerPed = PlayerPedId()
        SpawnVehicle(data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end

function ListVehiclesMenu(garage)
    local elements = {}
    local garage = garage

    local namagarasi = garage
    
    if namagarasi == 'Garkot' then
        namagarasi = 'Garasi: A'
    elseif namagarasi == 'Garasi_Rusun' then
        namagarasi = 'Garasi: B'
    elseif namagarasi == 'Garasi_Perumahan' then
        namagarasi = 'Garasi: C'
    elseif namagarasi == 'Garasi_SandyS' then
        namagarasi = 'Garasi: D'
    elseif namagarasi == 'Garasi_Tobaco' then
        namagarasi = 'Garasi: E'
    elseif namagarasi == 'Paleto_Bay' then
        namagarasi = 'Garasi: F'
    elseif namagarasi == 'Garasi_Walkot' then
        namagarasi = 'Garasi: G'
    elseif namagarasi == 'Garasi_Kanpol' then
        namagarasi = 'Garasi: H'
    elseif namagarasi == 'Garasi_RS' then
        namagarasi = 'Garasi: I'
    else
        namagarasi = 'Garasi'
    end

    ESX.TriggerServerCallback('midp-garasi:getVehicles', function(vehicles)
        local type = nil
        local options = {}

        if not vehicles then
            lib.registerContext({
                id = 'midp-garasi:MenuGarasi',
                title = namagarasi,
                options = {
                    ['Tidak Ada Kendaraan'] = {}
                }
            })
    
            return lib.showContext('midp-garasi:MenuGarasi')
        end

        if vehicles ~= nil then
            for i = 1, #vehicles do
                local data = vehicles[i]
                local hashVehicule = data.vehicle.model
                local modelname = data.model
                local plate = data.plate
                local posisi = data.garage

                local vehMake = GetLabelText(GetMakeNameFromVehicleModel(hashVehicule))
                local vehName = GetLabelText(GetDisplayNameFromVehicleModel(hashVehicule))
                options[i] = {
                    title = vehName,
                    event = 'midp-garasi:spawnVeh',
                    arrow = false,
                    args = {name = data.model, plate = data.plate, model = hashVehicule, vehicle = data.vehicle},
                    metadata = {
                        data.plate
                    }
                }
            end
        end

        lib.registerContext({
            id = 'midp-garasi:MenuGarasi',
            title = namagarasi,
            options = options
        })
        
        lib.showContext('midp-garasi:MenuGarasi')
    end, garage)
end

function StockVehicleMenu(garage)
    local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, false) then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
        local current = GetPlayersLastVehicle(PlayerPedId(), true)
        local engineHealth = GetVehicleEngineHealth(current)
        local plate 		= vehicleProps.plate
		local garage   = garage

		local vehicleFuel = GetVehicleFuelLevel(GetVehiclePedIsUsing(PlayerPedId()))
		local vehicleEngine = GetVehicleEngineHealth(GetVehiclePedIsUsing(PlayerPedId()))
		local vehicleBody = GetVehicleBodyHealth(GetVehiclePedIsUsing(PlayerPedId()))
		local vehicleDirt = GetVehicleDirtLevel(GetVehiclePedIsUsing(PlayerPedId()))

        ESX.TriggerServerCallback('midp-garasi:stockv', function(valid)
            if valid then
                TriggerServerEvent('midp-garasi:modifystate', vehicleProps, true, garage)
                ESX.Game.DeleteVehicle(vehicle)

            else
                exports['midp-tasknotify']:SendAlert('error', 'Kendaraan Disimpan!', 10000)
            end
        end, vehicleProps)
    else
        exports['midp-tasknotify']:SendAlert('error', 'ayonima sekali ente!', 10000)
    end
end


RegisterNetEvent('midp-garasi:spawnVeh')
AddEventHandler('midp-garasi:spawnVeh', function(data)
    local vehicle = data.vehicle
    ESX.Game.SpawnVehicle(vehicle.model, {
        x = this_Garage.SpawnPoint.Pos.x,
        y = this_Garage.SpawnPoint.Pos.y,
        z = this_Garage.SpawnPoint.Pos.z + 1
    }, this_Garage.SpawnPoint.Heading, function(callback_vehicle)
        exports["midp-bensin"]:SetFuel(callback_vehicle, vehicle.fuelLevel)
        SetVehicleProperties(callback_vehicle, vehicle)

        SetVehRadioStation(callback_vehicle, 'OFF')
        TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
        exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        SetVehicleEngineOn(callback_vehicle, false)
    end)

    TriggerServerEvent('midp-garasi:modifystate', vehicle, false)
end)

function SpawnVehicle(vehicle)
    ESX.Game.SpawnVehicle(vehicle.model, {
        x = this_Garage.SpawnPoint.Pos.x,
        y = this_Garage.SpawnPoint.Pos.y,
        z = this_Garage.SpawnPoint.Pos.z + 1
    }, this_Garage.SpawnPoint.Heading, function(callback_vehicle)
        exports["midp-bensin"]:SetFuel(callback_vehicle, vehicle.fuelLevel)
        SetVehicleProperties(callback_vehicle, vehicle)

        SetVehRadioStation(callback_vehicle, 'OFF')
        TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
        exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
    end)

    TriggerServerEvent('midp-garasi:modifystate', vehicle, false)
end

RegisterNetEvent('midp-garasi:spawnVehPound')
AddEventHandler('midp-garasi:spawnVehPound', function(data)
    ESX.TriggerServerCallback('midp-garasi:checkMoney', function(hasEnoughMoney)
        if hasEnoughMoney then
            TriggerServerEvent('midp-garasi:pay', data.price)
            SpawnPoundedVehicle(data.vehicle)
        else
            exports['midp-tasknotify']:SendAlert('error', 'Uang Tidak Cukup!', 5000)
        end
    end, data.price)
end)

function SpawnPoundedVehicle(vehicle)
    ESX.Game.SpawnVehicle(vehicle.model, {
        x = this_Garage.SpawnMunicipalPoundPoint.Pos.x,
        y = this_Garage.SpawnMunicipalPoundPoint.Pos.y,
        z = this_Garage.SpawnMunicipalPoundPoint.Pos.z + 1
    }, this_Garage.SpawnMunicipalPoundPoint.Heading, function(callback_vehicle)
        exports["midp-bensin"]:SetFuel(callback_vehicle, vehicle.fuelLevel)
        ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)

        SetVehRadioStation(callback_vehicle, "OFF")
        TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
        exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
    end)
end

function SetVehicleProperties(vehicle, vehicleProps)
    ESX.Game.SetVehicleProperties(vehicle, vehicleProps)

    SetVehicleEngineHealth(vehicle, vehicleProps.engineHealth and vehicleProps.engineHealth + 0.0 or 1000.0)
    SetVehicleBodyHealth(vehicle, vehicleProps.bodyHealth and vehicleProps.bodyHealth + 0.0 or 1000.0)
    SetVehicleFuelLevel(vehicle, vehicleProps.fuelLevel and vehicleProps.fuelLevel + 0.0 or 1000.0)
    if vehicleProps.windows then
        for windowId = 1, 13, 1 do
            if vehicleProps.windows[windowId] == false then
                SmashVehicleWindow(vehicle, windowId)
            end
        end
    end

    if vehicleProps.tyres then
        for tyreId = 1, 7, 1 do
            if vehicleProps.tyres[tyreId] ~= false then
                SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
            end
        end
    end

    if vehicleProps.doors then
        for doorId = 0, 5, 1 do
            if vehicleProps.doors[doorId] ~= false then
                SetVehicleDoorBroken(vehicle, doorId - 1, true)
            end
        end
    end
end

AddEventHandler('midp-garasi:hasEnteredMarker', function(zone)
    if zone == 'spawn' then
        CurrentAction = 'spawn'
        CurrentActionMsg = 'Garasi'
        CurrentActionData = {}
    end

    if zone == 'delete' then
        CurrentAction = 'delete'
        CurrentActionMsg = 'Simpan'
        CurrentActionData = {}
    end

    if zone == 'pound' then
        CurrentAction = 'pound_action_menu'
        CurrentActionMsg = 'Asuransi'
        CurrentActionData = {}
    end
end)

AddEventHandler('midp-garasi:hasExitedMarker', function(zone)
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)

function ReturnVehicleMenu()
    ESX.TriggerServerCallback('midp-garasi:loadPrice', function(data)
        vehicles1 = data
    end)

    ESX.TriggerServerCallback('midp-garasi:loadVehicles', function(vehicles)
        local menupound = {}
        local type = nil

        if not vehicles then
            lib.registerContext({
                id = 'midp-garasi:Asuransi',
                title = 'Asuransi',
                options = {
                    ['Tidak Ada Kendaraan'] = {}
                }
            })
    
            return lib.showContext('midp-garasi:Asuransi')
        end

        local elements = {}
        for key,value in pairs(vehicles) do
            local props = json.decode(value.vehicle)
            local price 	= 3000

            for k, v in pairs(vehicles1) do
                if props.model == GetHashKey(v.model) then
                    if v.price >= 1000000 then
                        price = v.price * 0.005
                    elseif v.price >= 100000 then
                        price = v.price * 0.02
                    else
                        price = v.price * 0.1
                    end
                end
            end
            
            local hashVehicule = props.model
            local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(hashVehicule))
            local labelvehicle

            local prices = math.floor(price)
    
            labelvehicle = vehicleName .. ' (' .. props.plate .. ') - $DL ' .. ESX.Math.GroupDigits(prices)

            menupound[key] = {
                title = vehicleName,
                event = 'midp-garasi:spawnVehPound',
                arrow = false,
                args = {vehicle = props, price = price},
                metadata = {props.plate .. ' - $DL '..ESX.Math.GroupDigits(prices)}
            }
        end

        lib.registerContext({
            id = 'midp-garasi:Asuransi',
            title = 'Asuransi',
            options = menupound
        })

        lib.showContext('midp-garasi:Asuransi')
    end)
end

function ReturnVehiclePrime()
    ESX.TriggerServerCallback('midp-garasi:loadPrice', function(data)
        vehicles1 = data
    end)

    ESX.TriggerServerCallback('midp-garasi:loadVehicles', function(vehicles)
        local menupoundprime = {}
        local type = nil

        if not vehicles then
            lib.registerContext({
                id = 'midp-garasi:AsuransiPrime',
                title = 'Asuransi Prime',
                options = {
                    ['Tidak Ada Kendaraan'] = {}
                }
            })
    
            return lib.showContext('midp-garasi:AsuransiPrime')
        end

        local elements = {}
        for key,value in pairs(vehicles) do
            local props = json.decode(value.vehicle)
            local price 	= 3000

            for k, v in pairs(vehicles1) do
                if props.model == GetHashKey(v.model) then
                    if v.price >= 1000000 then
                        price = v.price * 0.004
                    elseif v.price >= 100000 then
                        price = v.price * 0.01
                    else
                        price = v.price * 0.1
                    end
                end
            end
            
            local hashVehicule = props.model
            local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(hashVehicule))
            local labelvehicle

            local prices = math.floor(price)
    
            labelvehicle = vehicleName .. ' (' .. props.plate .. ') - $DL ' .. ESX.Math.GroupDigits(prices)

            menupoundprime[key] = {
                title = vehicleName,
                event = 'midp-garasi:spawnVehPound',
                arrow = false,
                args = {vehicle = props, price = price},
                metadata = {props.plate .. ' - $DL '..ESX.Math.GroupDigits(prices)}
            }
        end

        lib.registerContext({
            id = 'midp-garasi:AsuransiPrime',
            title = 'Asuransi',
            options = menupoundprime
        })

        lib.showContext('midp-garasi:AsuransiPrime')
    end)
end

CreateThread(function()
    while true do
        local sleepThread = 1000
        local coords = GetEntityCoords(PlayerPedId())
        local playerPed = PlayerPedId()

        for k, v in pairs(Config.Garages) do
            if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 10.0) then
                if not IsPedInAnyVehicle(playerPed,  false) then
                    DrawMarker(v.SpawnPoint.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.SpawnPoint.Size.x, v.SpawnPoint.Size.y, v.SpawnPoint.Size.z, v.SpawnPoint.Color.r, v.SpawnPoint.Color.g, v.SpawnPoint.Color.b, 100, true, true, 2, false, false, false, false)
                    sleepThread = 5
                end
            end

            if (GetDistanceBetweenCoords(coords, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, true) < 10.0) then
                if IsPedInAnyVehicle(playerPed,  false) then
                    DrawMarker(v.DeletePoint.Marker, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.DeletePoint.Size.x, v.DeletePoint.Size.y, v.DeletePoint.Size.z, v.DeletePoint.Color.r, v.DeletePoint.Color.g, v.DeletePoint.Color.b, 100, true, true, 2, false, false, false, false)
                    sleepThread = 2
                end
            end

            if(v.MunicipalPoundPoint and GetDistanceBetweenCoords(coords, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, true) < 10) then
                if not IsPedInAnyVehicle(playerPed,  false) then
                    DrawMarker(v.MunicipalPoundPoint.Marker, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.MunicipalPoundPoint.Size.x, v.MunicipalPoundPoint.Size.y, v.MunicipalPoundPoint.Size.z, v.MunicipalPoundPoint.Color.r, v.MunicipalPoundPoint.Color.g, v.MunicipalPoundPoint.Color.b, 100, true, true, 2, false, false, false, false)
                    sleepThread = 5
                end
            end
        end

        for k, v in pairs(Config.PrivateGarages) do
			if not v.Private or has_value(userProperties, v.Private) or has_value(userProperties1, v.Private) then
                if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 10.0) then
                    if not IsPedInAnyVehicle(playerPed,  false) then
                        DrawMarker(v.SpawnPoint.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.SpawnPoint.Size.x, v.SpawnPoint.Size.y, v.SpawnPoint.Size.z, v.SpawnPoint.Color.r, v.SpawnPoint.Color.g, v.SpawnPoint.Color.b, 100, true, true, 2, false, false, false, false)
                        sleepThread = 5
                    end
                end

                if (GetDistanceBetweenCoords(coords, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, true) < 10.0) then
                    if IsPedInAnyVehicle(playerPed,  false) then
                        DrawMarker(v.DeletePoint.Marker, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.DeletePoint.Size.x, v.DeletePoint.Size.y, v.DeletePoint.Size.z, v.DeletePoint.Color.r, v.DeletePoint.Color.g, v.DeletePoint.Color.b, 100, true, true, 2, false, false, false, false)
                        sleepThread = 2
                    end
                end
            end
        end
        Wait(sleepThread)
    end
end)

CreateThread(function()
    local currentZone = 'garage'

    while true do
        local sleepThread = 1000
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(PlayerPedId())
        local isInMarker = false

        for k, v in pairs(Config.Garages) do
            if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                if not IsPedInAnyVehicle(playerPed,  false) then
                    isInMarker = true
                    this_Garage = v
                    garage_position = k
                    currentZone = 'spawn'
                    sleepThread = 5
                end
            end
            if (GetDistanceBetweenCoords(coords, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, true) < 3.0) then
                if IsPedInAnyVehicle(playerPed) then
                    isInMarker = true
                    this_Garage = v
                    garage_position = k
                    currentZone = 'delete'
                    sleepThread = 1
                end
            end

            if v.MunicipalPoundPoint and GetDistanceBetweenCoords(coords, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, true) < v.Size.x then
                isInMarker = true
                this_Garage = v
                garage_position = k
                currentZone = 'pound'
                sleepThread = 5
            end
        end

        for k, v in pairs(Config.PrivateGarages) do
			if not v.Private or has_value(userProperties, v.Private) or has_value(userProperties1, v.Private) then
                if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                    if not IsPedInAnyVehicle(playerPed,  false) then
                        isInMarker = true
                        this_Garage = v
                        garage_position = k
                        currentZone = 'spawn'
                        sleepThread = 5
                    end
                end
                if (GetDistanceBetweenCoords(coords, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, true) < 3.0) then
                    if IsPedInAnyVehicle(playerPed) then
                        isInMarker = true
                        this_Garage = v
                        garage_position = k
                        currentZone = 'delete'
                        sleepThread = 1
                    end
                end
            end
        end

        if isInMarker and not hasAlreadyEnteredMarker then
            hasAlreadyEnteredMarker = true
            LastZone = currentZone
            TriggerEvent('midp-garasi:hasEnteredMarker', currentZone)
            exports['midp-tasknotify']:Open('[E] - ' .. CurrentActionMsg, 'darkblue', 'left')
            sleepThread = 5
        end

        if not isInMarker and hasAlreadyEnteredMarker then
            hasAlreadyEnteredMarker = false
            TriggerEvent('midp-garasi:hasExitedMarker', LastZone)
            exports['midp-tasknotify']:Close()
            sleepThread = 5
        end
        Wait(sleepThread)
    end
end)

CreateThread(function()
    while true do
        local sleepo = 1000

        if CurrentAction ~= nil then
            sleepo = 1
            local garage = garage_position

            if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 150 then
                if CurrentAction == 'pound_action_menu' then
                    if exports['midp-core']:Level() > 0 then
                        ReturnVehiclePrime()
                    else
                        ReturnVehicleMenu()
                    end
                    exports['midp-tasknotify']:Close()
                end

                if CurrentAction == 'spawn' then
                    ListVehiclesMenu(garage)
                    exports['midp-tasknotify']:Close()
                end

                if CurrentAction == 'delete' then
                    StockVehicleMenu(garage)
                end

                CurrentAction = nil
                GUI.Time = GetGameTimer()
            end
        end
        Wait(sleepo)
    end
end)