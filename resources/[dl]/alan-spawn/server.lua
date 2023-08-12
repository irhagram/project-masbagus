local ExpiredTime = 60 * 60

RegisterServerEvent("alan-spawn:LastLocation")
AddEventHandler('alan-spawn:LastLocation', function()
    local src = source
    local spawn = {}
    spawn = GetSpawnPos(src)

    if spawn == nil then
        TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Silahkan Pilih Bandara/Pelabuhan!'})
    else
        TriggerClientEvent("alan-spawn:LastLocationSpawn", src, spawn)
    end
end)

ESX.RegisterServerCallback("alan-spawn:showLastLocation", function(source, cb)
    local LastLocation = GetSpawnPos(source)
    local LastTime = GetLastTime(source)
    local Now = os.time()

    if LastLocation ~= nil and LastTime ~= nil then
        local Expired = LastTime + ExpiredTime
        if Now < Expired then
            cb(true)
        end
    end

    cb(false)
end)

ESX.RegisterServerCallback('alan-spawn:getOwnedProperties', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT * FROM properties WHERE name IN (SELECT name FROM owned_properties WHERE owner = @owner)', {
		['@owner'] = xPlayer.identifier
	}, function(result)
        if result[1] then
            local properties = {}
            for k,v in pairs(result) do
                if v.gateway ~= nil then
                    local gateway = MySQL.Sync.fetchAll('SELECT * FROM properties WHERE name = @name', {
                        ['@name'] = v.gateway
                    })
                    if gateway[1] then
                        table.insert(properties, {
                            name = v.name,
                            label = v.label,
                            coords = gateway.entering
                        })
                    end
                else
                    table.insert(properties, {
                        name = v.name,
                        label = v.label,
                        coords = v.entering
                    })
                end
            end

            if properties[1] then
                cb(properties)
            else
                cb(nil)
            end
        else
            cb(nil)
        end
	end)
end)

ESX.RegisterServerCallback('alan-spawn:getOwnedRumah', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT * FROM rumah WHERE name IN (SELECT name FROM rumah_owned WHERE owner = @owner)', {
		['@owner'] = xPlayer.identifier
	}, function(result)
        if result[1] then
            local rumah = {}
            for k,v in pairs(result) do
                if v.gateway ~= nil then
                    local gateway = MySQL.Sync.fetchAll('SELECT * FROM rumah WHERE name = @name', {
                        ['@name'] = v.gateway
                    })
                    if gateway[1] then
                        table.insert(rumah, {
                            name = v.name,
                            label = v.label,
                            coords = gateway.entering
                        })
                    end
                else
                    table.insert(rumah, {
                        name = v.name,
                        label = v.label,
                        coords = v.entering
                    })
                end
            end

            if rumah[1] then
                cb(rumah)
            else
                cb(nil)
            end
        else
            cb(nil)
        end
	end)
end)

function GetSpawnPos(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    local result = MySQL.Sync.fetchAll("SELECT `position` FROM `users` WHERE `identifier` = @identifier", {
        ["@identifier"] = xPlayer.identifier
    })
    if result[1].position ~= nil then
        return json.decode(result[1].position)
    end
    return nil
end

function GetLastTime(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    local result = MySQL.Sync.fetchAll("SELECT `position_time` FROM `users` WHERE `identifier` = @identifier", {
        ["@identifier"] = xPlayer.identifier
    })
    if result[1].position_time ~= nil then
        return result[1].position_time
    end
    return nil
end

function MySQLAsyncExecute(query)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll(query, {}, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end

AddEventHandler('onResourceStart', function(resource)
 	MySQL.Async.execute('UPDATE users SET position = @position', {
        ['@position'] = ""
    }, function(rowsChanged)
    end)
end)

AddEventHandler('playerDropped', function(reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Now = os.time()
    MySQL.Async.execute('UPDATE `users` SET `position_time` = @position_time WHERE `identifier` = @identifier',{
        ["@position_time"] = Now,
        ["@identifier"] = xPlayer.identifier
    }, function(affectedRows)
    end
    )
end)