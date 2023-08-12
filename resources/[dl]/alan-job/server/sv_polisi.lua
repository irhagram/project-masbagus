ESX = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.PolisiMaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'police', Config.PolisiMaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'police', _U('alert_police'), true, true)
TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})

-- These stashes are all created on resource start
local stashes = {
	{
		-- Police stash
		id = 'brankas_polisi',
		label = 'BRANKAS POLISI',
		slots = 500,
		weight = 10000000,
		owner = false,
		jobs = 'police'
	},
	{
		-- Police stash
		id = 'brankas_trans',
		label = 'BRANKAS TRANS',
		slots = 200,
		weight = 10000000,
		owner = false,
		jobs = 'taxi'
	},
}

AddEventHandler('onServerResourceStart', function(resourceName)
	local GetCurrentResourceName = GetCurrentResourceName()
	local ox_inventory = exports.ox_inventory
	if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName then
		for i=1, #stashes do
			local stash = stashes[i]
			ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight, stash.owner, stash.jobs)
		end
	end
end)

RegisterServerEvent('dl-job:confiscatePlayerItem')
AddEventHandler('dl-job:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.name ~= 'police' then
		
		return
	end

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		-- does the target player have enough in their inventory?
		if targetItem.count > 0 and targetItem.count <= amount then

			-- can the player carry the said amount of x item?
			if sourceItem.weight ~= -1 and (sourceItem.count + amount) > sourceItem.weight then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end

	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
	end
end)

RegisterServerEvent('dl-job:handcuff')
AddEventHandler('dl-job:handcuff', function(target)
	TriggerClientEvent('dl-job:handcuff', target)
end)

RegisterServerEvent('dl-job:drag')
AddEventHandler('dl-job:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'mafia' or xPlayer.job.name == 'biker' or xPlayer.job.name == 'yakuza' or xPlayer.job.name == 'ormas' or xPlayer.job.name == 'gang' or xPlayer.job.name == 'badside7' or xPlayer.job.name == 'cartel' or xPlayer.job.name == 'badside8' or xPlayer.job.name == 'badside9' or xPlayer.job.name == 'badside10' or xPlayer.job.name == 'badside11' or xPlayer.job.name == 'badside12' or xPlayer.job.name == 'badside13' or xPlayer.job.name == 'badside14' then
		TriggerClientEvent('dl-job:dragger', target, source)
	else
		print(('dl-job: %s attempted to drag (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterNetEvent('dl-job:putInVehicle')
AddEventHandler('dl-job:putInVehicle', function(target)
	TriggerClientEvent('dl-job:putInVehicle', target)
end)

RegisterServerEvent('dl-job:OutVehicle')
AddEventHandler('dl-job:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		TriggerClientEvent('dl-job:OutVehicle', target)
	else
		print(('dl-job: %s attempted to drag out from vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

ESX.RegisterServerCallback('dl-job:getPolice', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local police = {}
	local players = ESX.GetPlayers()
  if xPlayer ~= nil then
	if xPlayer.job.name == 'police' then
		for a,b in pairs(players) do
			local target = ESX.GetPlayerFromId(b)

			if target and target.job.name == 'police' then
				local data = {source=target.source,name=target.getName(),grade=target.job.grade_name}
				table.insert(police,data)
			end
		end
	end
   end
	cb(police)
end)

ESX.RegisterServerCallback('dl-job:getOtherPlayerData', function(source, cb, target)
	if Config.PolisiEnableESXIdentity then
		local xPlayer = ESX.GetPlayerFromId(target)
		local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex, dateofbirth, height FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		})

		local firstname = result[1].firstname
		local lastname  = result[1].lastname
		local sex       = result[1].sex
		local dob       = result[1].dateofbirth
		local height    = result[1].height

		local data = {
			name      = GetPlayerName(target),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			weapons   = xPlayer.loadout,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height
		}

		

		if Config.PolisiEnableLicenses then
			TriggerEvent('esx_license:getLicenses', target, function(licenses)
				data.licenses = licenses
				cb(data)
			end)
		else
			cb(data)
		end
	else
		local xPlayer = ESX.GetPlayerFromId(target)

		local data = {
			name       = GetPlayerName(target),
			job        = xPlayer.job,
			inventory  = xPlayer.inventory,
			accounts   = xPlayer.accounts,
			weapons    = xPlayer.loadout
		}

		

		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			data.licenses = licenses
		end)

		cb(data)
	end
end)

ESX.RegisterServerCallback('dl-job:getFineList', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM fine_types WHERE category = @category', {
		['@category'] = category
	}, function(fines)
		cb(fines)
	end)
end)


ESX.RegisterServerCallback('dl-job:getVehicleInfos', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		local retrivedInfo = {plate = plate}

		if result[1] then
			local xPlayer = ESX.GetPlayerFromIdentifier(result[1].owner)

			-- is the owner online?
			if xPlayer then
				retrivedInfo.owner = xPlayer.getName()
				cb(retrivedInfo)
			elseif Config.PolisiEnableESXIdentity then
				MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier',  {
					['@identifier'] = result[1].owner
				}, function(result2)
					if result2[1] then
						retrivedInfo.owner = ('%s %s'):format(result2[1].firstname, result2[1].lastname)
						cb(retrivedInfo)
					else
						cb(retrivedInfo)
					end
				end)
			else
				cb(retrivedInfo)
			end
		else
			cb(retrivedInfo)
		end
	end)
end)

ESX.RegisterServerCallback('dl-job:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config.PolisiEnableESXIdentity then
					cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)
				else
					cb(result2[1].name, true)
				end

			end)
		else
			cb(_U('unknown'), false)
		end
	end)
end)

ESX.RegisterServerCallback('dl-job:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

	-- vehicle model not found
	if price == 0 then
		print(('dl-job: %s attempted to exploit the shop! (invalid vehicle model)'):format(xPlayer.identifier))
		cb(false)
	else
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)

			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @type, @job, @stored)', {
				['@owner'] = xPlayer.identifier,
				['@vehicle'] = json.encode(vehicleProps),
				['@plate'] = vehicleProps.plate,
				['@type'] = type,
				['@job'] = xPlayer.job.name,
				['@stored'] = true
			}, function (rowsChanged)
				cb(true)
			end)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('dl-job:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = v.plate,
			['@job'] = xPlayer.job.name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plate, k
			break
		end
	end

	if not foundPlate then
		cb(false)
	else
		MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				print(('dl-job: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end

end)

function getPriceFromHash(hashKey, jobGrade, type)
	if type == 'helicopter' then
		local vehicles = Config.PolisiAuthorizedHelicopters[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	elseif type == 'car' then
		local vehicles = Config.PolisiAuthorizedVehicles[jobGrade]
		local shared = Config.PolisiAuthorizedVehicles['Shared']

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end

		for k,v in ipairs(shared) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	end

	return 0
end

AddEventHandler('playerDropped', function()
	-- Save the source in case we lose it (which happens a lot)
	local _source = source

	-- Did the player ever join?
	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)

		-- Is it worth telling all clients to refresh?
		if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
			Citizen.Wait(5000)
			TriggerClientEvent('dl-job:updateBlip', -1)
		end
	end
end)

ESX.RegisterServerCallback('dl-job:player', function(source, cb, id)
    local xPlayer = ESX.GetPlayerFromId(id)
    local playerName = "NULL"
    local info = {job = xPlayer.job.grade_label, name = playerName}

    MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier',  {
        ['@identifier'] = xPlayer.identifier
    }, function(result2)
        if result2[1] then
            info.name = ('%s %s'):format(result2[1].firstname, result2[1].lastname)
            cb(info)
        else
            cb(info)
        end
    end)
end)

RegisterNetEvent('dl-job:spawned')
AddEventHandler('dl-job:spawned', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer and xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'pemerintah' then
		Citizen.Wait(5000)
		TriggerClientEvent('dl-job:updateBlip', -1)
	end
end)

RegisterNetEvent('dl-job:forceBlip')
AddEventHandler('dl-job:forceBlip', function()
	TriggerClientEvent('dl-job:updateBlip', -1)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('dl-job:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'police')
	end
end)

RegisterServerEvent('dl-job:message')
AddEventHandler('dl-job:message', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)

RegisterServerEvent('dl-job:requestarrest')
AddEventHandler('dl-job:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
    TriggerClientEvent('dl-job:getarrested', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('dl-job:doarrested', _source)
end)

RegisterServerEvent('dl-job:requestrelease')
AddEventHandler('dl-job:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
    TriggerClientEvent('dl-job:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('dl-job:douncuffing', _source)
end)

RegisterCommand('bisik', function(source, args, rawCommand)
	if source == 0 then
		return
	end

	args = table.concat(args, ' ')
	local name = GetPlayerName(source)
	if Config.PolisiEnableESXIdentity then name = GetCharacterName(source) end

	TriggerClientEvent('3ddo:sendProximityMessage', -1, source, name, _U('do_prefix', args), { 255, 255, 255 })
	--print(('%s: %s'):format(name, args))
end, false)

RegisterServerEvent('dl-job:BeriLsenJata')
AddEventHandler('dl-job:BeriLsenJata', function (target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(target)
    if xPlayer and xTarget then
        if xPlayer.job.name == 'police' then
            TriggerEvent('esx_license:checkLicense',xTarget.source,'weapon',function(ret)
                if ret == true then
					TriggerClientEvent('alan-tasknotify:Alert', _source, "Alert", "Orang ini sudah memiliki lisensi senjata!", 2000, 'error')
                else
                    TriggerEvent('esx_license:addLicense', xTarget.source, 'weapon', function()
						TriggerClientEvent('alan-tasknotify:Alert', _source, "Alert", "Berhasil memberikan lisensi senjata", 2000, 'info')
						TriggerClientEvent('alan-tasknotify:Alert', xTarget.source, "Alert", "Mendapatkan lisensi senjata!", 2000, 'info')
                    end)
                end
            end)
        end
    end
end)

RegisterServerEvent('dl-job:beriSimA')
AddEventHandler('dl-job:beriSimA', function (target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(target)
    if xPlayer and xTarget then
        if xPlayer.job.name == 'police' then
            TriggerEvent('esx_license:checkLicense',xTarget.source,'drive',function(ret)
                if ret == true then
					TriggerClientEvent('alan-tasknotify:Alert', _source, "Alert", "Orang ini sudah memiliki Sim A!", 2000, 'error')
                else
                    TriggerEvent('esx_license:addLicense', xTarget.source, 'drive', function()
						TriggerClientEvent('alan-tasknotify:Alert', _source, "Alert", "Berhasil memberikan Sim A", 2000, 'info')
						TriggerClientEvent('alan-tasknotify:Alert', xTarget.source, "Alert", "Mendapatkan Sim A!", 2000, 'info')
                    end)
                end
            end)
        end
    end
end)

RegisterServerEvent('dl-job:beriSimB')
AddEventHandler('dl-job:beriSimB', function (target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(target)
    if xPlayer and xTarget then
        if xPlayer.job.name == 'police' then
            TriggerEvent('esx_license:checkLicense',xTarget.source,'drive_bike',function(ret)
                if ret == true then
					TriggerClientEvent('alan-tasknotify:Alert', _source, "Alert", "Orang ini sudah memiliki Sim B!", 2000, 'error')
                else
                    TriggerEvent('esx_license:addLicense', xTarget.source, 'drive_bike', function()
						TriggerClientEvent('alan-tasknotify:Alert', _source, "Alert", "Berhasil memberikan Sim B", 2000, 'info')
						TriggerClientEvent('alan-tasknotify:Alert', xTarget.source, "Alert", "Mendapatkan Sim B!", 2000, 'info')
                    end)
                end
            end)
        end
    end
end)

RegisterServerEvent('dl-job:beriSimC')
AddEventHandler('dl-job:beriSimC', function (target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(target)
    if xPlayer and xTarget then
        if xPlayer.job.name == 'police' then
            TriggerEvent('esx_license:checkLicense',xTarget.source,'drive_truck',function(ret)
                if ret == true then
					TriggerClientEvent('alan-tasknotify:Alert', _source, "Alert", "Orang ini sudah memiliki Sim C!", 2000, 'error')
                else
                    TriggerEvent('esx_license:addLicense', xTarget.source, 'drive_truck', function()
						TriggerClientEvent('alan-tasknotify:Alert', _source, "Alert", "Berhasil memberikan Sim C", 2000, 'info')
						TriggerClientEvent('alan-tasknotify:Alert', xTarget.source, "Alert", "Mendapatkan Sim C!", 2000, 'info')
                    end)
                end
            end)
        end
    end
end)

RegisterServerEvent('dl-job:revokeWeaponLicense')
AddEventHandler('dl-job:revokeWeaponLicense', function (target)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(target)
    if xPlayer and xTarget then
        if xPlayer.job.name == 'police' then
            TriggerEvent('esx_license:checkLicense',xTarget.source,'weapon',function(ret)
                if ret == true then
                    TriggerEvent('esx_license:removeLicense', xTarget.source, 'weapon', function()
						TriggerClientEvent('alan-tasknotify:Alert', _source, "Alert", "Berhasil mencabut lisensi senjata", 2000, 'success')
						TriggerClientEvent('alan-tasknotify:Alert', xTarget.source, "Alert", "Lisensi senjata anda dicabut!", 2000, 'error')
                    end)
                    
                else
					TriggerClientEvent('alan-tasknotify:Alert', _source, "Alert", "Orang ini tidak memiliki lisensi senjata!", 2000, 'error')
                end
            end)
        end
    end
end)

function GetCharacterName(source)
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] and result[1].firstname and result[1].lastname then
		if Config.PolisiOnlyFirstname then
			return result[1].firstname
		else
			return ('%s %s'):format(result[1].firstname, result[1].lastname)
		end
	else
		return GetPlayerName(source)
	end
end