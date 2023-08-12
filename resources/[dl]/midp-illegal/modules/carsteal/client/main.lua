ESX = nil
local PlayerData              	= {}
local currentZone               = ''
local LastZone                  = ''
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}

local alldeliveries             = {}
local randomdelivery            = 1
local isTaken                   = 0
local isDelivered               = 0
local car						= 0
local copblip
local deliveryblip


CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

CreateThread(function()
	local deliveryids = 1
	for k,v in pairs(CarSteal.Delivery) do
		table.insert(alldeliveries, {
				id = deliveryids,
				posx = v.Pos.x,
				posy = v.Pos.y,
				posz = v.Pos.z,
				payment = v.Payment,
				car = v.Cars,
		})
		deliveryids = deliveryids + 1  
	end
end)

CreateThread(function()
	for k,v in pairs(CarSteal.Zones1) do
		RequestModel(GetHashKey('a_m_y_salton_01'))
		while not HasModelLoaded(GetHashKey('a_m_y_salton_01')) do
			Wait(5)
		end
		local ped  = CreatePed(19, GetHashKey('a_m_y_salton_01'), v.Pos.x, v.Pos.y, v.Pos.z - 1.2, 265.0, false, false)
		SetEntityInvincible(ped, true)
		SetEntityAsMissionEntity(ped, true, true)
		SetPedHearingRange(ped, 0.0)
		SetPedSeeingRange(ped, 0.0)
		SetPedAlertness(ped, 0.0)
		SetPedFleeAttributes(ped, 0, 0)
		SetBlockingOfNonTemporaryEvents(ped, true)
		SetPedCombatAttributes(ped, 46, true)
		SetPedFleeAttributes(ped, 0, 0)
		SetModelAsNoLongerNeeded(ped)
		DecorSetInt(ped,"GamemodeCar",955)
		Wait(1000)
		FreezeEntityPosition(ped , true)
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_SMOKING", 0, true)

		exports['ox_target']:AddBoxZone("carthief1", vector3(v.Pos.x, v.Pos.y, v.Pos.z), 1.5, 1.5 ,{
			name="carthief1",
			heading=265.0,
			debugPoly=false,
			minZ=v.Pos.z-1.2,
			maxZ=v.Pos.z+1.2
		}, {
			options = {
				{
					event = "alan-carsteal:colong1",
					icon = "fas fa-car-crash",
					label = "Car Stealing",
				}
			},
			distance = 2.5
		})
	end
	for k,v in pairs(CarSteal.Zones2) do
		RequestModel(GetHashKey('a_m_y_salton_01'))
		while not HasModelLoaded(GetHashKey('a_m_y_salton_01')) do
			Wait(5)
		end
		local ped  = CreatePed(19, GetHashKey('a_m_y_salton_01'), v.Pos.x, v.Pos.y, v.Pos.z - 1.2, 265.0, false, false)
		SetEntityInvincible(ped, true)
		SetEntityAsMissionEntity(ped, true, true)
		SetPedHearingRange(ped, 0.0)
		SetPedSeeingRange(ped, 0.0)
		SetPedAlertness(ped, 0.0)
		SetPedFleeAttributes(ped, 0, 0)
		SetBlockingOfNonTemporaryEvents(ped, true)
		SetPedCombatAttributes(ped, 46, true)
		SetPedFleeAttributes(ped, 0, 0)
		SetModelAsNoLongerNeeded(ped)
		DecorSetInt(ped,"GamemodeCar",955)
		Wait(1000)
		FreezeEntityPosition(ped , true)
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_SMOKING", 0, true)

		exports['ox_target']:AddBoxZone("carthief2", vector3(v.Pos.x, v.Pos.y, v.Pos.z), 1.5, 1.5 ,{
			name="carthief2",
			heading=265.0,
			debugPoly=false,
			minZ=v.Pos.z-1.2,
			maxZ=v.Pos.z+1.2
		}, {
			options = {
				{
					event = "alan-carsteal:colong2",
					icon = "fas fa-car-crash",
					label = "Car Stealing",
				}
			},
			distance = 2.5
		})
	end
	for k,v in pairs(CarSteal.Zones3) do
		RequestModel(GetHashKey('a_m_y_salton_01'))
		while not HasModelLoaded(GetHashKey('a_m_y_salton_01')) do
			Wait(5)
		end
		local ped  = CreatePed(19, GetHashKey('a_m_y_salton_01'), v.Pos.x, v.Pos.y, v.Pos.z - 1.2, 265.0, false, false)
		SetEntityInvincible(ped, true)
		SetEntityAsMissionEntity(ped, true, true)
		SetPedHearingRange(ped, 0.0)
		SetPedSeeingRange(ped, 0.0)
		SetPedAlertness(ped, 0.0)
		SetPedFleeAttributes(ped, 0, 0)
		SetBlockingOfNonTemporaryEvents(ped, true)
		SetPedCombatAttributes(ped, 46, true)
		SetPedFleeAttributes(ped, 0, 0)
		SetModelAsNoLongerNeeded(ped)
		DecorSetInt(ped,"GamemodeCar",955)
		Wait(1000)
		FreezeEntityPosition(ped , true)
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_SMOKING", 0, true)

		exports['ox_target']:AddBoxZone("carthief3", vector3(v.Pos.x, v.Pos.y, v.Pos.z), 1.5, 1.5 ,{
			name="carthief3",
			heading=265.0,
			debugPoly=false,
			minZ=v.Pos.z-1.2,
			maxZ=v.Pos.z+1.2
		}, {
			options = {
				{
					event = "alan-carsteal:colong3",
					icon = "fas fa-car-crash",
					label = "Car Stealing",
				}
			},
			distance = 2.5
		})
	end
	for k,v in pairs(CarSteal.Zones4) do
		RequestModel(GetHashKey('a_m_y_salton_01'))
		while not HasModelLoaded(GetHashKey('a_m_y_salton_01')) do
			Wait(5)
		end
		local ped  = CreatePed(19, GetHashKey('a_m_y_salton_01'), v.Pos.x, v.Pos.y, v.Pos.z - 1.2, 265.0, false, false)
		SetEntityInvincible(ped, true)
		SetEntityAsMissionEntity(ped, true, true)
		SetPedHearingRange(ped, 0.0)
		SetPedSeeingRange(ped, 0.0)
		SetPedAlertness(ped, 0.0)
		SetPedFleeAttributes(ped, 0, 0)
		SetBlockingOfNonTemporaryEvents(ped, true)
		SetPedCombatAttributes(ped, 46, true)
		SetPedFleeAttributes(ped, 0, 0)
		SetModelAsNoLongerNeeded(ped)
		DecorSetInt(ped,"GamemodeCar",955)
		Wait(1000)
		FreezeEntityPosition(ped , true)
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_SMOKING", 0, true)

		exports['ox_target']:AddBoxZone("carthief4", vector3(v.Pos.x, v.Pos.y, v.Pos.z), 1.5, 1.5 ,{
			name="carthief4",
			heading=265.0,
			debugPoly=false,
			minZ=v.Pos.z-1.2,
			maxZ=v.Pos.z+1.2
		}, {
			options = {
				{
					event = "alan-carsteal:colong4",
					icon = "fas fa-car-crash",
					label = "Car Stealing",
				}
			},
			distance = 2.5
		})
	end
end)

AddEventHandler('alan-carsteal:colong1', function()
	SpawnCar(1)
end)

AddEventHandler('alan-carsteal:colong2', function()
	SpawnCar(2)
end)

AddEventHandler('alan-carsteal:colong3', function()
	SpawnCar(3)
end)

AddEventHandler('alan-carsteal:colong4', function()
	SpawnCar(4)
end)

function SetHandling(Vehicle, Data, Value)
    for theKey,property in pairs(CarSteal.handlingData) do
        if property == Data then
            local intfind = string.find(property, "n" )
            local floatfind = string.find(property, "f" )
            local strfind = string.find(property, "str" )
            local vecfind = string.find(property, "vec" )
            if intfind ~= nil and intfind == 1 then
                SetVehicleHandlingInt( Vehicle, "CHandlingData", Data, tonumber(Value) )
            elseif floatfind ~= nil and floatfind == 1 then
                local Value = tonumber(Value)+.0
                SetVehicleHandlingFloat( Vehicle, "CHandlingData", Data, tonumber(Value) )
            elseif strfind ~= nil and strfind == 1 then
                SetVehicleHandlingField( Vehicle, "CHandlingData", Data, Value )
            elseif vecfind ~= nil and vecfind == 1 then
                SetVehicleHandlingVector( Vehicle, "CHandlingData", Data, Value )
            else
                SetVehicleHandlingField( Vehicle, "CHandlingData", Data, Value )
            end
        end
    end
end

function setModeBalap(vehicle)
    for index, value in ipairs(CarSteal.handleMods) do
        SetHandling(vehicle, value[1], value[2])
    end
    SetHandling(vehicle, "vecCentreOfMassOffset" , CarSteal.Vec1 )
    SetHandling(vehicle, "vecInertiaMultiplier" , CarSteal.Vec2 )
    SetVehicleEnginePowerMultiplier(vehicle, 0.0)
end

function SpawnCar(zones)
	ESX.TriggerServerCallback('midp-illegal:isAktif', function(activity, cooldown)
		if activity == 0 then
			if cooldown <= 0 then
				ESX.TriggerServerCallback('alan-carsteal:anycops', function(anycops)
					if anycops >= CarSteal.CopsRequired then
						if exports['midp-core']:itemCount('lockpick') > 0 then
						local time = math.random(10,15)
						local circles = math.random(3,5) 
						local success = exports['midp-lockpick']:StartLockPickCircle(circles, time, success)
						if success then 
							TriggerServerEvent('midp-core:delItem', 'lockpick', 1)
								randomdelivery = math.random(1,#alldeliveries)
								
								if zones == 1 then
									ClearAreaOfVehicles(CarSteal.VehicleSpawnPoint1.Pos.x, CarSteal.VehicleSpawnPoint1.Pos.y, CarSteal.VehicleSpawnPoint1.Pos.z, 10.0, false, false, false, false, false)
								elseif zones == 2 then
									ClearAreaOfVehicles(CarSteal.VehicleSpawnPoint2.Pos.x, CarSteal.VehicleSpawnPoint2.Pos.y, CarSteal.VehicleSpawnPoint2.Pos.z, 10.0, false, false, false, false, false)
								elseif zones == 3 then
									ClearAreaOfVehicles(CarSteal.VehicleSpawnPoint3.Pos.x, CarSteal.VehicleSpawnPoint3.Pos.y, CarSteal.VehicleSpawnPoint3.Pos.z, 10.0, false, false, false, false, false)
								elseif zones == 4 then
									ClearAreaOfVehicles(CarSteal.VehicleSpawnPoint4.Pos.x, CarSteal.VehicleSpawnPoint4.Pos.y, CarSteal.VehicleSpawnPoint4.Pos.z, 10.0, false, false, false, false, false)
								end
								
								SetEntityAsNoLongerNeeded(car)
								DeleteVehicle(car)
								RemoveBlip(deliveryblip)
								
								randomcar = math.random(1,#alldeliveries[randomdelivery].car)

								local vehiclehash = GetHashKey(alldeliveries[randomdelivery].car[randomcar])
								RequestModel(vehiclehash)
								while not HasModelLoaded(vehiclehash) do
									RequestModel(vehiclehash)
									Wait(1)
								end
								if zones == 1 then
									car = CreateVehicle(vehiclehash, CarSteal.VehicleSpawnPoint1.Pos.x, CarSteal.VehicleSpawnPoint1.Pos.y, CarSteal.VehicleSpawnPoint1.Pos.z, 0.0, true, false)
								elseif zones == 2 then
									car = CreateVehicle(vehiclehash, CarSteal.VehicleSpawnPoint2.Pos.x, CarSteal.VehicleSpawnPoint2.Pos.y, CarSteal.VehicleSpawnPoint2.Pos.z, 0.0, true, false)
								elseif zones == 3 then
									car = CreateVehicle(vehiclehash, CarSteal.VehicleSpawnPoint3.Pos.x, CarSteal.VehicleSpawnPoint3.Pos.y, CarSteal.VehicleSpawnPoint3.Pos.z, 0.0, true, false)
								elseif zones == 4 then
									car = CreateVehicle(vehiclehash, CarSteal.VehicleSpawnPoint4.Pos.x, CarSteal.VehicleSpawnPoint4.Pos.y, CarSteal.VehicleSpawnPoint4.Pos.z, 0.0, true, false)
								end

								SetEntityAsMissionEntity(car, true, true)
								SetVehicleNumberPlateText(car, "CARSTEAL")
								setModeBalap(car)
								TaskWarpPedIntoVehicle(PlayerPedId(), car, -1)

								deliveryblip = AddBlipForCoord(alldeliveries[randomdelivery].posx, alldeliveries[randomdelivery].posy, alldeliveries[randomdelivery].posz)
								SetBlipSprite(deliveryblip, 1)
								SetBlipDisplay(deliveryblip, 4)
								SetBlipScale(deliveryblip, 1.0)
								SetBlipColour(deliveryblip, 5)
								SetBlipAsShortRange(deliveryblip, true)
								BeginTextCommandSetBlipName("STRING")
								AddTextComponentString("Delivery point")
								EndTextCommandSetBlipName(deliveryblip)
								
								SetBlipRoute(deliveryblip, true)

								TriggerServerEvent('alan-carsteal:berital')
								TriggerServerEvent('midp-illegal:aktifYaBund', 1)
--[[ 								local coords = vector3(-1, -1, -1)
								local data = {displayCode = '211', description = 'Carstealing On Progress', priority = 'high', isImportant = 1, recipientList = {'police'}, length = '10000', infoM = 'fa-info-circle', info = 'Check radar for information'}
								local dispatchData = {dispatchData = data, caller = 'Alarm', coords = coords}
								TriggerServerEvent('wf-alerts:svNotify', dispatchData) ]]
								
								isTaken = 1
								
								isDelivered = 0
							else
								exports['midp-tasknotify']:DoHudText('error', 'Gagal, Lockpick patah!')
								TriggerServerEvent('midp-core:delItem', 'lockpick', 1)
							end
						else
							exports['midp-tasknotify']:DoHudText('error', 'Tidak memiliki lockpick!') 
						end
					else
						exports['midp-tasknotify']:DoHudText('error', 'Polisi tidak cukup!') 
					end
				end)
			else
				exports['midp-tasknotify']:DoHudText('error', 'Sedang Cooldown '..math.ceil(cooldown/60000).. ' Menit') 
			end
		else
			exports['midp-tasknotify']:DoHudText('error', 'Sedang terjadi perampokan!') 
		end
	end)
end

function FinishDelivery()
	if(GetVehiclePedIsIn(PlayerPedId(), false) == car) and GetEntitySpeed(car) < 3 then
		SetEntityAsNoLongerNeeded(car)
		DeleteEntity(car)

		RemoveBlip(deliveryblip)

		local finalpayment = alldeliveries[randomdelivery].payment
		TriggerServerEvent('alan-carsteal:pay', finalpayment)
		TriggerServerEvent('midp-illegal:aktifYaBund', 0)

		isTaken = 0

		isDelivered = 1

		TriggerServerEvent('alan-carsteal:stopalertcops')
	else
		exports['midp-tasknotify']:DoHudText('error', 'Anda harus menggunakan mobil yang disediakan untuk Anda dan Anda harus berhenti sepenuhnya')
	end
end

CreateThread(function()
	local deliveryids = 1
	for k,v in pairs(CarSteal.Delivery) do
		table.insert(alldeliveries, {
			id = deliveryids,
			posx = v.Pos.x,
			posy = v.Pos.y,
			posz = v.Pos.z,
			payment = v.Payment,
			car = v.Cars,
		})
		deliveryids = deliveryids + 1
	end

	for k , v in pairs(alldeliveries) do
		exports["midp-nui"]:AddBoxZone("thiefdeliverypoint"..v.id, vector3(v.posx, v.posy, v.posz), 6.5, 6.5, {
			name="thiefdeliverypoint"..v.id,
			heading=169.5,
			debugPoly=false,
			minZ=v.posz-1.2,
			maxZ=v.posz+1.8
		})
	end

	RegisterNetEvent('polyzonecuy:enter')
	AddEventHandler('polyzonecuy:enter', function(name)
		for k , v in pairs(alldeliveries) do
			if "thiefdeliverypoint"..v.id == name then
				if isTaken == 1 then
					FinishDelivery()
					exports['midp-tasknotify']:Open('Jangan Bergerak', 'darkblue', 'right')
				end
			end
		end
	end)

	RegisterNetEvent('polyzonecuy:exit')
	AddEventHandler('polyzonecuy:exit', function(name)
		for k , v in pairs(alldeliveries) do
			if "thiefdeliverypoint"..v.id == name then
				exports['midp-tasknotify']:Close()
			end
		end
	end)
end)

function AbortDelivery()
	SetEntityAsNoLongerNeeded(car)
	DeleteEntity(car)
	RemoveBlip(deliveryblip)
	TriggerServerEvent('midp-illegal:aktifYaBund', 0)
	isTaken = 0
	isDelivered = 1
	TriggerServerEvent('alan-carsteal:stopalertcops')
end

CreateThread(function()
  while true do
    Wait(1000)
		if isTaken == 1 and isDelivered == 0 and not (GetVehiclePedIsIn(PlayerPedId(), false) == car) then
			exports['midp-tasknotify']:DoHudText('error', 'Anda punya waktu 3 menit untuk kembali ke mobil')
			Wait(50000)
			if isTaken == 1 and isDelivered == 0 and not (GetVehiclePedIsIn(PlayerPedId(), false) == car) then
				exports['midp-tasknotify']:DoHudText('error', 'Anda punya waktu 10 detik untuk kembali ke mobil')
				Wait(10000)
				exports['midp-tasknotify']:DoHudText('error', 'Misi gagal!')
				AbortDelivery()
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(CarSteal.BlipUpdateTime)
		if isTaken == 1 and IsPedInAnyVehicle(PlayerPedId()) then
			local coords = GetEntityCoords(PlayerPedId())
			TriggerServerEvent('alan-carsteal:alertcops', coords.x, coords.y, coords.z)
		elseif isTaken == 1 and not IsPedInAnyVehicle(PlayerPedId()) then
			TriggerServerEvent('alan-carsteal:stopalertcops')
		end
	end
end)

RegisterNetEvent('alan-carsteal:removecopblip')
AddEventHandler('alan-carsteal:removecopblip', function()
	RemoveBlip(copblip)
end)

RegisterNetEvent('alan-carsteal:setcopblip')
AddEventHandler('alan-carsteal:setcopblip', function(cx,cy,cz)
	RemoveBlip(copblip)
    copblip = AddBlipForCoord(cx,cy,cz)
    SetBlipSprite(copblip , 161)
    SetBlipScale(copblipy , 2.0)
	SetBlipColour(copblip, 8)
	PulseBlip(copblip)
end)

RegisterNetEvent('alan-carsteal:setcopnotification')
AddEventHandler('alan-carsteal:setcopnotification', function()
 -----
end)

CreateThread(function()
    info = CarSteal.Zones1.VehicleSpawner
    info.blip = AddBlipForCoord(info.Pos.x, info.Pos.y, info.Pos.z)
    SetBlipSprite(info.blip, info.Id)
    SetBlipDisplay(info.blip, 4)
    SetBlipScale(info.blip, 0.7)
    SetBlipColour(info.blip, info.Colour)
    SetBlipAsShortRange(info.blip, true)
    BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Robbery Kendaran')
    EndTextCommandSetBlipName(info.blip)
end)

CreateThread(function()
    info = CarSteal.Zones2.VehicleSpawner
    info.blip = AddBlipForCoord(info.Pos.x, info.Pos.y, info.Pos.z)
    SetBlipSprite(info.blip, info.Id)
    SetBlipDisplay(info.blip, 4)
    SetBlipScale(info.blip, 0.7)
    SetBlipColour(info.blip, info.Colour)
    SetBlipAsShortRange(info.blip, true)
    BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Robbery Kendaran')
    EndTextCommandSetBlipName(info.blip)
end)

CreateThread(function()
    info = CarSteal.Zones3.VehicleSpawner
    info.blip = AddBlipForCoord(info.Pos.x, info.Pos.y, info.Pos.z)
    SetBlipSprite(info.blip, info.Id)
    SetBlipScale(info.blip, 0.7)
    SetBlipColour(info.blip, info.Colour)
    SetBlipAsShortRange(info.blip, true)
    BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Robbery Kendaran')
    EndTextCommandSetBlipName(info.blip)
end)

CreateThread(function()
    info = CarSteal.Zones4.VehicleSpawner
    info.blip = AddBlipForCoord(info.Pos.x, info.Pos.y, info.Pos.z)
    SetBlipSprite(info.blip, info.Id)
    SetBlipDisplay(info.blip, 4)
    SetBlipScale(info.blip, 0.7)
    SetBlipColour(info.blip, info.Colour)
    SetBlipAsShortRange(info.blip, true)
    BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Robbery Kendaran')
    EndTextCommandSetBlipName(info.blip)
end)