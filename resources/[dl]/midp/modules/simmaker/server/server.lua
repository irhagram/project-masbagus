ESX = nil
local Licenses = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getInGameName(identifier)
    local name
    MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier LIMIT 1', {
        ['@identifier'] = identifier
    }, function(result)
        if result[1] then
            name = result[1].firstname..' '..result[1].lastname
        else
            name = 'NULL'
        end
    end)
    Citizen.Wait(300)
    return name
end

function getPlayerData(identifier)
    local data = {}
    MySQL.Async.fetchAll('SELECT dateofbirth, sex, height FROM users WHERE identifier = @identifier LIMIT 1', {
        ['@identifier'] = identifier
    }, function(result)
        if result[1] then
            data.dob = result[1].dateofbirth
            data.sex = result[1].sex
            data.height = result[1].height
        else
            data = {}
        end
    end)
    Citizen.Wait(300)
    return data
end

function stringsplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function getPlayerLicenses(identifier)
    local table
    MySQL.Async.fetchAll('SELECT u.type, l.label FROM user_licenses u LEFT JOIN licenses l ON u.type = l.type WHERE owner = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        table = result
    end)
    Citizen.Wait(100)
    return table
end

Citizen.CreateThread(function()
    TriggerEvent('esx_license:getLicensesList', function(list)
        Licenses = list
    end)
    while true do
        Citizen.Wait(60*1000*15)
    end
end)

function getLicenseLabel(type)
    for k,v in pairs(Licenses) do
        if type == v.type then
            return v.label
        end
    end
end

ESX.RegisterServerCallback('simmaker:add', function(source, cb, target, type, date_expired)
	local xPlayer = ESX.GetPlayerFromId(target)
	local card_metadata = {}
	card_metadata.type = xPlayer.name
	card_metadata.citizenid = xPlayer[ID.CitizenID]:sub(-5)
	card_metadata.firstName = xPlayer.variables.firstName
	card_metadata.lastName = xPlayer.variables.lastName
	card_metadata.dateofbirth = xPlayer.variables.dateofbirth
	card_metadata.sex = xPlayer.variables.sex
	card_metadata.height = xPlayer.variables.height
	card_metadata.mugshoturl = url
	card_metadata.cardtype = type
	local curtime = os.time(os.date("!*t"))
	local diftime = curtime + 2629746
	card_metadata.issuedon = date_expired
	if type == "drivers_license" then 
		MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = xPlayer.identifier},
		function (licenses)
			for i=1, #licenses, 1 do
				if licenses[i].type == 'drive' or licenses[i].type == 'drive_bike' or licenses[i].type == 'drive_truck' then
					card_metadata.licenses = licenses
				end
			end
		end)
		TriggerEvent('esx_license:addLicense', source, 'drive', function()
		end)
	elseif type == "firearms_license" then 
		MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = xPlayer.identifier},
		function (licenses)
			for i=1, #licenses, 1 do
				if licenses[i].type == 'weapon' then
					card_metadata.licenses = licenses
				end
			end
		end)
			TriggerEvent('esx_license:addLicense', source, 'weapon', function()
		end)
    end
    xPlayer.addInventoryItem(type, 1, card_metadata)
end)

ESX.RegisterServerCallback('bikinsim:name', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local name = getInGameName(xPlayer.identifier)
    cb(name)
end)


ESX.RegisterServerCallback('bikinsim:getLicensePlayers', function(source, cb)
    MySQL.Async.fetchAll('SELECT identifier, firstname, lastname, COUNT(type) AS `total` FROM users LEFT JOIN user_licenses ON users.identifier = user_licenses.owner GROUP BY identifier HAVING COUNT(TYPE) > 0', {},
    function(result)
        for k,v in pairs(result) do
            if v.total == 0 then
                table.remove(result, k)
            end
        end
        cb(result)
    end)
end)

ESX.RegisterServerCallback('bikinsim:manageplayer', function(source, cb, identifier)
    if identifier then
        local name = getInGameName(identifier)
        local data = getPlayerData(identifier)
        local licenses = getPlayerLicenses(identifier)
        cb({
            identifier = identifier,
            fname = stringsplit(name)[1],
            lname = stringsplit(name)[2],
            dob = data.dob,
            sex = data.sex,
            height = data.height,
            licenses = licenses
        })
    else
        cb({})
    end
end)

ESX.RegisterServerCallback('simmaker:cancel', function(source, cb, playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer == nil then
        return
    end
    MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, job FROM users WHERE identifier = @identifier LIMIT 1', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        cb(result)
    end)
end)


RegisterNetEvent('esx:addLicense')
AddEventHandler('esx:addLicense', function(type)
	local _source = source
    
end)