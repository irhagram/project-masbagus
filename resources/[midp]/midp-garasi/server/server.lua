RegisterServerEvent('midp-garasi:deletevehicle_sv')
RegisterServerEvent('midp-garasi:modifystate')
RegisterServerEvent('midp-garasi:pay')
RegisterServerEvent('midp-garasi:logging')

-- Vehicle fetch
ESX.RegisterServerCallback('midp-garasi:getVehicles', function(source, cb, garage)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicles = {}
	
	MySQL.Async.fetchAll('SELECT plate, vehicle, model, type, job, stored, garage FROM owned_vehicles WHERE owner = @identifier AND type = @type AND job = @job AND stored = @stored AND garage = @garage', {
		['@identifier']  = xPlayer.identifier,
		['@type']   = 'car',
		['@job']    = '',
		['@garage'] = garage,
		['@stored'] = true
	}, function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do

					local veh = json.decode(v.vehicle)
					table.insert(vehicles, {plate = v.plate, vehicle = veh, stored = v.stored, garage = v.garage})
				
			end
			cb(vehicles)
		else
			cb(nil)
		end
	end)
end)

-- End vehicle fetch
-- Store & update vehicle properties
ESX.RegisterServerCallback('midp-garasi:stockv', function(source, cb, vehicleProps, garage)
    local isFound = false
	local xPlayer = ESX.GetPlayerFromId(source)
    local vehicules = getPlayerVehicles(xPlayer.getIdentifier())
    local plate = vehicleProps.plate
    local garage = garage

    for _, v in pairs(vehicules) do
        if (plate == plate) then
            local vehprop = json.encode(vehicleProps)
            MySQL.Async.insert("UPDATE owned_vehicles SET vehicle=@vehicle WHERE plate = @plate AND owner = @owner", 
            {
                ['@owner'] = xPlayer.identifier,
                ['@plate'] = plate,
                ['@vehicle'] = json.encode(vehicleProps)
            })

            isFound = true
            break
        end
    end

    cb(isFound)
end)

AddEventHandler('midp-garasi:deletevehicle_sv', function(vehicle)
    TriggerClientEvent('midp-garasi:deletevehicle_cl', -1, vehicle)
end)

-- End vehicle store
-- Change state of vehicle
AddEventHandler('midp-garasi:modifystate', function(vehicle, stored, garage)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local vehicules = getPlayerVehicles(xPlayer.identifier)
    local stored = stored
    local plate = vehicle.plate
    local garage = garage

    if plate ~= nil then
        plate = plate:gsub('^%s*(.-)%s*$', '%1')
    else

    end
	

    if stored then 
        stored = 1 
		MySQL.Sync.execute('UPDATE owned_vehicles SET stored = @stored, garage=@garage WHERE plate=@plate', {
			['@stored'] = stored,
			['@plate'] = plate,
			['@garage'] = garage
        }, function(rowsChanged)
        end)


    else
		MySQL.Sync.execute('UPDATE owned_vehicles SET stored = @stored, garage=@garage WHERE plate=@plate', {
			['@stored'] = stored,
			['@plate'] = plate,
			['@garage'] = garage
        }, function(rowsChanged)
        end)
	end
end)



-- End state update
-- Function to recover plates deprecated and removed.
-- Get list of vehicles already out

-- End out list
-- Check player has funds
ESX.RegisterServerCallback('midp-garasi:checkMoney', function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= price then
        cb(true)
    else
        cb(false)
    end
end)

-- End funds check
-- Withdraw money
AddEventHandler('midp-garasi:pay', function(price)
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeMoney(price)
	TriggerClientEvent('midp-tasknotify:client:SendAlert', source, { type = 'error', text = 'Biaya asuransi $DL ' .. ESX.Math.GroupDigits(price)})
end)

-- End money withdraw
-- Find player vehicles
function getPlayerVehicles(identifier)
    local vehicles = {}

	local data = MySQL.Sync.fetchAll("SELECT owner FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = identifier})

    for _, v in pairs(data) do
        local vehicle = json.decode(v.vehicle)

        table.insert(vehicles, {
            id = v.id,
            plate = v.plate
        })
    end

    return vehicles
end

-- End debug
-- Return all vehicles to garage (state update) on server restart

--[[
AddEventHandler('onMySQLReady', function()
    MySQL.Sync.execute('UPDATE owned_vehicles SET stored=true WHERE stored=false', {})
end)
]]
-- End vehicle return
-- Pay vehicle repair cost


RegisterServerEvent('midp-garasi:setVehicle')
AddEventHandler('midp-garasi:setVehicle', function (plate, model)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, model) VALUES (@owner, @plate, @vehicle, @model)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = plate,
		['@model'] = model
	}, function (rowsChanged)
		--TriggerClientEvent('esx:showNotification', _source, _U('vehicle_belongs', vehicleProps.plate))
		--TriggerClientEvent('notification', _source, _U('vehicle_belongs', vehicleProps.plate), 1)
	end)
end)
--[[
ESX.RegisterServerCallback('midp-garasi:getVeh', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicle = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicle WHERE owner = @owner', {
		['@owner'] = xPlayer.getIdentifier(),
	}, function(data)
		for _,v in pairs(data) do
			table.insert(vehicle, v.model)
		end
		cb(vehicle)
	end)
end)]]

ESX.RegisterServerCallback('midp-garasi:getVeh', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicle = {}

	MySQL.Async.fetchAll('SELECT owner, vehicle, model FROM owned_vehicle WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier,
	}, function(data)
		for _,v in pairs(data) do
			table.insert(vehicle, v.vehicle)
		end
		cb(vehicle)
	end)
end)



ESX.RegisterServerCallback('midp-garasi:loadPrice', function(source, cb)
	MySQL.Async.fetchAll('SELECT price, model, name FROM vehicles', {
	}, function(result)
		if result then
			cb(result)
		else
			cb(nil)
		end
	end)
end)

ESX.RegisterServerCallback('midp-garasi:loadVehicles', function(source, cb)
	local s = source
	local x = ESX.GetPlayerFromId(s)
	local vehicles = {}
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND stored = 0 AND owned_vehicles.plate NOT IN (SELECT plate from h_impounded_vehicles)', {['@owner'] = x.identifier,}, function(vehicles)
		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('midp-garasi:getOwnedProperties', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local properties = {}

	MySQL.Async.fetchAll('SELECT name FROM garasi_rumah WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier,
	}, function(data)
		for _,v in pairs(data) do
			table.insert(properties, v.name)
		end
		cb(properties)
	end)
end)

ESX.RegisterServerCallback('midp-garasi:getOwnedProperties1', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local properties = {}

	MySQL.Async.fetchAll('SELECT name FROM garasi_rumah WHERE shared = @shared', {
		['@shared'] = xPlayer.identifier,
	}, function(data)
		for _,v in pairs(data) do
			table.insert(properties, v.name)
		end
		cb(properties)
	end)
end)