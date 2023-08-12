

local isNearPump = false
local isFueling = false
local currentFuel = 0.0
local currentCost = 0.0
local currentCash = 1000
local fuelSynced = false
local inBlacklisted = false

function ManageFuelUsage(vehicle)
	if not DecorExistOn(vehicle, Config.FuelDecor) then
		SetFuel(vehicle, math.random(200, 800) / 10)
	elseif not fuelSynced then
		SetFuel(vehicle, GetFuel(vehicle))

		fuelSynced = true
	end

	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
	end
end

function GetFuel(vehicle)
	return DecorGetFloat(vehicle, Config.FuelDecor)
end

function SetFuel(vehicle, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, Config.FuelDecor, GetVehicleFuelLevel(vehicle))
	end
end

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end
	end
end

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)

	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end

function Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)

	return math.floor(num * mult + 0.5) / mult
end

function CreateBlip(coords)
	local blip = AddBlipForCoord(coords)

	SetBlipSprite(blip, 361)
	SetBlipScale(blip, 0.5)
	SetBlipColour(blip, 1)
	SetBlipDisplay(blip, 2)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Pom Bensin")
	EndTextCommandSetBlipName(blip)

	return blip
end

function FindNearestFuelPump()
	local coords = GetEntityCoords(PlayerPedId())
	local fuelPumps = {}
	local handle, object = FindFirstObject()
	local success

	repeat
		if Config.PumpModels[GetEntityModel(object)] then
			table.insert(fuelPumps, object)
		end

		success, object = FindNextObject(handle, object)
	until not success

	EndFindObject(handle)

	local pumpObject = 0
	local pumpDistance = 1000

	for _, fuelPumpObject in pairs(fuelPumps) do
		local dstcheck = GetDistanceBetweenCoords(coords, GetEntityCoords(fuelPumpObject))

		if dstcheck < pumpDistance then
			pumpDistance = dstcheck
			pumpObject = fuelPumpObject
		end
	end

	return pumpObject, pumpDistance
end

Citizen.CreateThread(function()
	DecorRegister(Config.FuelDecor, 1)

	for index = 1, #Config.Blacklist do
		if type(Config.Blacklist[index]) == 'string' then
			Config.Blacklist[GetHashKey(Config.Blacklist[index])] = true
		else
			Config.Blacklist[Config.Blacklist[index]] = true
		end
	end

	for index = #Config.Blacklist, 1, -1 do
		table.remove(Config.Blacklist, index)
	end

	while true do
		Citizen.Wait(1000)

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)

			if Config.Blacklist[GetEntityModel(vehicle)] then
				inBlacklisted = true
			else
				inBlacklisted = false
			end

			if not inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == ped then
				ManageFuelUsage(vehicle)
			end
		else
			if fuelSynced then
				fuelSynced = false
			end

			if inBlacklisted then
				inBlacklisted = false
			end
			Wait(5000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(250)

		local pumpObject, pumpDistance = FindNearestFuelPump()

		if pumpDistance < 2.5 then
			isNearPump = pumpObject

			if Config.UseESX then
				local playerData = ESX.GetPlayerData()
				for i=1, #playerData.accounts, 1 do
					if playerData.accounts[i].name == 'money' then
						currentCash = playerData.accounts[i].money
						break
					end
				end
			end
		else
			isNearPump = false

			Citizen.Wait(math.ceil(pumpDistance * 20))
			-- Wait(1250)
		end
	end
end)

AddEventHandler('fuel:startFuelUpTick', function(pumpObject, ped, vehicle)
	currentFuel = GetVehicleFuelLevel(vehicle)

	while isFueling do
		Citizen.Wait(500)

		local oldFuel = DecorGetFloat(vehicle, Config.FuelDecor)
		local fuelToAdd = math.random(10, 20) / 10.0
		local extraCost = fuelToAdd / 1.5

		if not pumpObject then
			if GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100 >= 0 then
				currentFuel = oldFuel + fuelToAdd

				SetPedAmmo(ped, 883325847, math.floor(GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100))
			else
				isFueling = false
			end
		else
			currentFuel = oldFuel + fuelToAdd
		end

		if currentFuel > 100.0 then
			currentFuel = 100.0
			isFueling = false
		end

		local vehFront = VehicleInFront()
		local class = GetVehicleClass(vehFront)
		--print(class)

		if class == 0 then
			currentCost = currentCost + extraCost * 100.3 * 1.2
		elseif class == 2 then
			currentCost = currentCost + extraCost * 100.3 * 1.3
		elseif class == 3 then
			currentCost = currentCost + extraCost * 100.3 * 1.3
		elseif class == 6 then
			currentCost = currentCost + extraCost * 100.3 * 1.9
		elseif class == 7 then
			currentCost = currentCost + extraCost * 100.3 * 2.2
		elseif class == 8 then
			currentCost = currentCost + extraCost * 100.3 * 1.2
		elseif class == 9 then
			currentCost = currentCost + extraCost * 100.3 * 1.5
		elseif class == 10 then
			currentCost = currentCost + extraCost * 100.3 * 1.5
		else
			currentCost = currentCost + extraCost * 100.3 * 1.2
		end

		if currentCash >= currentCost then
			SetFuel(vehicle, currentFuel)
		else
			isFueling = false
		end
	end

	if pumpObject then
		TriggerServerEvent('fuel:pay', currentCost)
	end

	currentCost = 0.0
end)

AddEventHandler('fuel:refuelFromPump', function(pumpObject, ped, vehicle)
	TaskTurnPedToFaceEntity(ped, vehicle, 1000)
	Citizen.Wait(1000)
	SetCurrentPedWeapon(ped, -1569615261, true)
	LoadAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)

	TriggerEvent('fuel:startFuelUpTick', pumpObject, ped, vehicle)

	while isFueling do
		for _, controlIndex in pairs(Config.DisableKeys) do
			DisableControlAction(0, controlIndex)
		end

		local vehicleCoords = GetEntityCoords(vehicle)

		if pumpObject then
			local stringCoords = GetEntityCoords(pumpObject)
			local extraString = ""

			if Config.UseESX then
				extraString = "\n" .. Config.Strings.TotalCost .. ": ~g~$DL" .. Round(currentCost, 1)
			end

			DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.CancelFuelingPump .. extraString)
			DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, Round(currentFuel, 1) .. "%")
		else
			DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, Config.Strings.CancelFuelingJerryCan .. "\nGas can: ~g~" .. Round(GetAmmoInPedWeapon(ped, 883325847) / 4500 * 100, 1) .. "% | Vehicle: " .. Round(currentFuel, 1) .. "%")
		end

		if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
			TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
		end

		if IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) or (isNearPump and GetEntityHealth(pumpObject) <= 0) then
			isFueling = false
		end

		Citizen.Wait(0)
	end

	ClearPedTasks(ped)
	RemoveAnimDict("timetable@gardener@filling_can")
end)

if Config.ShowNearestGasStationOnly then
	Citizen.CreateThread(function()
		local currentGasBlip = 0

		while true do
			local coords = GetEntityCoords(PlayerPedId())
			local closest = 1000
			local closestCoords

			for _, gasStationCoords in pairs(Config.GasStations) do
				local dstcheck = GetDistanceBetweenCoords(coords, gasStationCoords)

				if dstcheck < closest then
					closest = dstcheck
					closestCoords = gasStationCoords
				end
			end

			if DoesBlipExist(currentGasBlip) then
				RemoveBlip(currentGasBlip)
			end

			currentGasBlip = CreateBlip(closestCoords)

			Citizen.Wait(10000)
		end
	end)
elseif Config.ShowAllGasStations then
	Citizen.CreateThread(function()
		for _, gasStationCoords in pairs(Config.GasStations) do
			CreateBlip(gasStationCoords)
		end
	end)
end

function getveh()
    local ped = PlayerPedId()
	local v = GetVehiclePedIsIn(PlayerPedId(), false)
	lastveh = GetVehiclePedIsIn(PlayerPedId(), true)
	local mycoord = GetEntityCoords(ped)
	local dis = -1
	if v == 0 then
		if #(mycoord - GetEntityCoords(lastveh)) < 5 then
			v = lastveh
		end
		dis = #(mycoord - GetEntityCoords(lastveh))
	end
	if dis > 3 then
		v = 0
	end
	if v == 0 then
		local count = 5
		v = GetClosestVehicle(mycoord, 8.000, 0, 70)
		while #(mycoord - GetEntityCoords(v)) > 10 and count >= 0 do
			v = GetClosestVehicle(mycoord,8.000, 0, 70)
			count = count - 1
			Wait(1)
		end
        if v == 0 then
            local temp = {}
            for k,v in pairs(GetGamePool('CVehicle')) do
                local dist = #(mycoord - GetEntityCoords(v))
                temp[k] = {}
                temp[k].dist = dist
                temp[k].entity = v
            end
            local dist = -1
            local nearestveh = nil
            for k,v in pairs(temp) do
                if dist == -1 or dist > v.dist then
                    dist = v.dist
                    nearestveh = v.entity
                end
            end
            v = nearestveh
        end
	end
	return tonumber(v)
end

function CreateBlip(coords)
	local blip = AddBlipForCoord(coords)

	SetBlipSprite(blip, 361)
	SetBlipScale(blip, 0.5)
	SetBlipColour(blip, 1)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("SPBU")
	EndTextCommandSetBlipName(blip)

	return blip
end

Citizen.CreateThread(function()
	exports["ox_target"]:AddTargetModel({-164877493, -469694731, -462817101, 1933174915, 1694452750, 1339433404, -2007231801}, {
		options = {
			{
				event = "midp-bensin:isibensin",
				icon = "fas fa-gas-pump",
				label = "ISI BBM"
			},
			{
				event = "midp-bensin:isiminyak",
				icon = "fas fa-gas-pump",
				label = "BELI JERIGEN $DL20.000"
			},
		},
		distance = 2
	})
	while true do
		if GetCurrentPedWeapon(PlayerPedId(), 883325847, true) then
			exports["ox_target"]:Vehicle({
				options = {
					{
						event = "midp-bensin:isivehjer",
						icon = "fas fa-gas-pump",
						label = "Isi BBM (Pakai Jerigen)",
						num = 1
					},
				},
				distance = 2
			})
		else
			exports["ox_target"]:RemoveVehicle({
				'Isi BBM (Pakai Jerigen)'
			})
		end
		Citizen.Wait(1000)
	end
end)

RegisterNetEvent('midp-bensin:isibensin')
AddEventHandler('midp-bensin:isibensin', function()
	local ped = PlayerPedId()
	local vehicle = GetPlayersLastVehicle()
	local dstCheck = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehicle), true)
	
	if IsPedInAnyVehicle(ped) then
		 exports["midp-tasknotify"]:DoHudText("error", "Harap turun dari kendaraan")
	elseif dstCheck < 5.0 then
		isFueling = true
		TriggerEvent('fuel:refuelFromPump', isNearPump, ped, vehicle)
		LoadAnimDict("timetable@gardener@filling_can")
	else 
	exports["midp-tasknotify"]:DoHudText("error", "Kendaraan terlalu jauh")
	end
end)

RegisterNetEvent('midp-bensin:isiminyak')
AddEventHandler('midp-bensin:isiminyak', function()
	if currentCash >= 20000 then
		TriggerServerEvent('midp-bensin:getbensin', GetPlayerServerId(PlayerId()))
		TriggerServerEvent('fuel:pay', 20000)
	end
end)

AddEventHandler('midp-bensin:isivehjer', function()
	local ped = PlayerPedId()
	local vehicle = getveh()
	TaskTurnPedToFaceEntity(ped, vehicle, 1000)
	Citizen.Wait(1000)
	SetCurrentPedWeapon(ped, -1569615261, true)
	LoadAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
	if Config.SistemLama then
	isFueling = true

	TriggerEvent('midp-bensin:isijerigenc')

	while isFueling do
		Citizen.Wait(1)

		for k,v in pairs(Config.DisableKeys) do
			DisableControlAction(0, v)
		end

		local vehicleCoords = GetEntityCoords(vehicle)
		DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, Config.Strings.CancelFuelingJerryCan .. "\nGas can: ~g~" .. Round(GetAmmoInPedWeapon(ped, 883325847) / 4500 * 100, 1) .. "% | Vehicle: " .. Round(currentFuel, 1) .. "%")

		if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
			TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
		end

		if IsControlJustReleased(0, 38) then
			isFueling = false
		end
	end

	ClearPedTasks(ped)
	RemoveAnimDict("timetable@gardener@filling_can")
	else
		TriggerEvent('midp-bensin:isijerigenc')
	end
end)

AddEventHandler('midp-bensin:isijerigenc', function()
	local ped = PlayerPedId()
	local vehicle = getveh()
	currentFuel = GetVehicleFuelLevel(vehicle)

	-- isFueling = true
	if Config.SistemLama then
		while isFueling do
			Citizen.Wait(500)

			local oldFuel = DecorGetFloat(vehicle, Config.FuelDecor)
			local fuelToAdd = 2.0

				if GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd >= 0 then
					currentFuel = oldFuel + (fuelToAdd * 1.0)
					print(currentFuel)
					SetFuel(vehicle, currentFuel)
					SetPedAmmo(ped, 883325847, math.floor(GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 10.0))
				else
					print('ammo: '..GetAmmoInPedWeapon(ped, 883325847))
					isFueling = false
				end

			if currentFuel > 100.0 then
				print('fuel: '..currentFuel)
				currentFuel = 100.0
				isFueling = false
			end
		end
	elseif not Config.SistemLama then
		if GetAmmoInPedWeapon(ped, 883325847) >= 1.0 then
			TriggerEvent("mythic_progbar:client:progress", {
				name = "unique_action_name",
				duration = (100 - currentFuel) * 100,
				label = "Mengisi BBM",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "timetable@gardener@filling_can",
					anim = "gar_ig_5_filling_can",
				}
			}, function(status)
				if not status then
					-- Do Something If Event Wasn't Cancelled
					currentFuel = 100.0
					SetFuel(vehicle, 100.0)
					-- print(currentFuel)
					ClearPedTasks(PlayerPedId())
					if not Config.UseLegacy then
						SetPedAmmo(ped, 883325847, math.floor(GetAmmoInPedWeapon(ped, 883325847), 0.0))
					else
						TriggerServerEvent('midp-bensin:delbensin', GetPlayerServerId(PlayerId()))
					end
				end
			end)
		end
	end
end)

function VehicleInFront()
	local pos = GetEntityCoords(PlayerPedId())
	local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 4.0, 0.0)
	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
	local a, b, c, d, result = GetRaycastResult(rayHandle)
	return result
  end

--HUD
local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }
local directions = {
    [0] = 'North Bound',
    [45] = 'West Bound',
    [90] = 'West Bound',
    [135] = 'South Bound',
    [180] = 'South Bound',
    [225] = 'East Bound',
    [270] = 'East Bound',
    [315] = 'North Bound',
    [360] = 'North Bound'
}

local direction = "North Bound"
local bensin = 100
local nos = 0
local uiopen = false
local nosEnabled = false
local colorblind = false
local seatbelt = false
local cruise = false
local atl = false
local engine = false
local GasTank = false
local isCompass = false

local isVehOn = false
local isMotor = false
local namaJalan = ""
local angkakmh = 0
local isSupir = false

RegisterNetEvent('midp-bensin:compass')
AddEventHandler('midp-bensin:compass', function(status)
    isCompass = not isCompass
    if status == false then
    	isCompass = false
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        bensin = math.ceil(GetFuel(GetVehiclePedIsIn(PlayerPedId(), false)))
        isVehOn = IsVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(), false))

        if GetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId(), false)) < 400.0 then
            engine = true
        else
        	engine = false
        end

        if bensin < 20 then
            GasTank = true
        else
        	GasTank = false
        end

        if (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()) then
            isSupir = true
        else
        	isSupir = false
        end

        if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) == 8 then
        	isMotor = true
        else
        	isMotor = false
        end

        if IsPedInAnyPlane(PlayerPedId()) or IsPedInAnyHeli(PlayerPedId()) then
            atl = string.format("%.1f", GetEntityHeightAboveGround(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.28084)
        end

        Citizen.Wait(5000)
    end
end)

local time = "12:00"

RegisterNetEvent("timeheader")
AddEventHandler("timeheader", function(h, m)
    if h < 10 then
        h = "0"..h
    end
    if m < 10 then
        m = "0"..m
    end
    time = h .. ":" .. m
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if isVehOn then
            if not uiopen then uiopen = true SendNUIMessage({ open = 1 }) end
            SendNUIMessage({ open = 5 })
            angkakmh = math.ceil(GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6)    

            if isMotor then
                SendNUIMessage({
                  open = 2,
                  mph = angkakmh,
                  fuel = bensin,
                  street = namaJalan,
                  belt = true,
                  cruise = cruise,
                  nos = nos,
                  nosEnabled = nosEnabled,
                  time = time,
                  colorblind = colorblind,
                  atl = atl,
                  engine = engine,
                  GasTank = GasTank,
                })
            else
                SendNUIMessage({
                  open = 2,
                  mph = angkakmh,
                  fuel = bensin,
                  street = namaJalan,
                  belt = seatbelt,
                  cruise = cruise,
                  nos = nos,
                  nosEnabled = nosEnabled,
                  time = time,
                  colorblind = colorblind,
                  atl = atl,
                  engine = engine,
                  GasTank = GasTank,
                })
            end
        else
            if uiopen then
            	if not isCompass then
            		SendNUIMessage({ open = 3, }) 
                	uiopen = false
                end
                cruise = false
                seatbelt = false
                isSupir = false
                atl = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        if isVehOn then
        	local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
        	local current_zone = zones[GetNameOfZone(x, y, z)]
        	local var1, var2 = GetStreetNameAtCoord(x, y, z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())

        	if direction then
        		if tostring(GetStreetNameFromHashKey(var2)) == "" then
        			namaJalan = direction .. " | ".. tostring(GetStreetNameFromHashKey(var1)) .." | " .. current_zone
        		else
        			namaJalan = direction .. " | ".. tostring(GetStreetNameFromHashKey(var1)) .." | " .. tostring(GetStreetNameFromHashKey(var2)).." | ".. current_zone
        		end
        	end

            for k,v in pairs(directions)do
                direction = GetEntityHeading(GetPlayerPed(-1))
                if (math.abs(direction - k) < 22.5) then
                    direction = v
                    break
                end
            end
        end    
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 29) and IsPedInAnyVehicle(PlayerPedId()) and GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) ~= 8 then
             if seatbelt == false then
                PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                exports['midp-tasknotify']:SendAlert('inform', 'Seat Belt Enabled', 10000)
            else
                PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                exports['midp-tasknotify']:SendAlert('inform', 'Seat Belt Disabled', 10000)
            end
            seatbelt = not seatbelt
        end

        if IsControlJustReleased(0, 137) and isSupir then
             if cruise == false then
                local asu = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false))
                local kmh = tostring(math.ceil(asu * 3.6))
                PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                exports['midp-tasknotify']:SendAlert('inform', 'Cruise Active at ' .. kmh ..  '/kmh', 10000)
            else
                PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                exports['midp-tasknotify']:SendAlert('inform', 'Cruise Inactive', 10000)
            end
            cruise = not cruise

            local currSpeed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false))
            local maxSpeed = cruise and currSpeed or GetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false),"CHandlingData","fInitialDriveMaxFlatVel")
            SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), maxSpeed)
        end     
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        if not isVehOn and isCompass then
        	if not uiopen then
                uiopen = true
                SendNUIMessage({
                  open = 1,
                })
            end
        	SendNUIMessage({
                open = 4,
                time = time,
                direction = math.floor(calcHeading(-GetFinalRenderedCamRot(0).z % 360)),
            })
        end
    end
end)

---------------------------------
-- Compass shit
---------------------------------

--[[
    Heavy Math Calcs
 ]]--

 local imageWidth = 100 -- leave this variable, related to pixel size of the directions
 local containerWidth = 100 -- width of the image container
 
 -- local width =  (imageWidth / containerWidth) * 100; -- used to convert image width if changed
 local width =  0;
 local south = (-imageWidth) + width
 local west = (-imageWidth * 2) + width
 local north = (-imageWidth * 3) + width
 local east = (-imageWidth * 4) + width
 local south2 = (-imageWidth * 5) + width
 
 function calcHeading(direction)
     if (direction < 90) then
         return lerp(north, east, direction / 90)
     elseif (direction < 180) then
         return lerp(east, south2, rangePercent(90, 180, direction))
     elseif (direction < 270) then
         return lerp(south, west, rangePercent(180, 270, direction))
     elseif (direction <= 360) then
         return lerp(west, north, rangePercent(270, 360, direction))
     end
 end
 
 
 function rangePercent(min, max, amt)
     return (((amt - min) * 100) / (max - min)) / 100
 end
 
 function lerp(min, max, amt)
     return (1 - amt) * min + amt * max
 end
 
--BARHUD
local EVHud = true

local hunger = 100
local thirst = 100
local tension = 0
local drunk = 0

Citizen.CreateThread(
    function()
    Citizen.Wait(500)
    while true do 
        if ESX ~= nil and EVHud then
            local PedId = PlayerPedId()
            local playerTalking = NetworkIsPlayerTalking(PlayerId())
			if GetEntityMaxHealth(PedId) ~= 200 then
				SetEntityMaxHealth(PedId, 200)
				SetEntityHealth(PedId, 200)
			end
                SendNUIMessage({
                    action = "hudtick",
                    show = IsPauseMenuActive(),
                    health = GetEntityHealth(PedId),
                    armor = GetPedArmour(PedId),
                    thirst = thirst,
                    hunger = hunger,
                    drunk = drunk,
					tension = tension,
					voice = playerTalking,
                })
            end  
            Citizen.Wait(1000)
    end
end)

RegisterNetEvent("dl-status:onTick") 
AddEventHandler("dl-status:onTick", function(Status)
    TriggerEvent('esx_status:getStatus', 'hunger', function(status)
        hunger = status.val / 10000  
    end)
    
    TriggerEvent('esx_status:getStatus', 'thirst', function(status)   
        thirst = status.val / 10000  
    end)

	TriggerEvent('esx_status:getStatus', 'drunk', function(status)   
        drunk = status.val / 10000  
    end)

	TriggerEvent('esx_status:getStatus', 'stress', function(status)   
        tension = status.val / 10000  
    end)
end)

RegisterNetEvent('pma-voice:setTalkingMode')
AddEventHandler('pma-voice:setTalkingMode', function(newTalkingRange)
    SendNUIMessage({
        action = "proximity",
        prox = newTalkingRange
    })
end)