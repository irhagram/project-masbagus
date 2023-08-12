local playersHealing, deadPlayers = {}, {}

if GetResourceState("esx_phone") ~= 'missing' then
	TriggerEvent('esx_phone:registerNumber', 'ambulance', _U('alert_ambulance'), true, true)
end

if GetResourceState("esx_society") ~= 'missing' then
	TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})
end

RegisterServerEvent("dl-job:getAmbulancesCount")
AddEventHandler("dl-job:getAmbulancesCount", function()
    local Ambulance = ESX.GetExtendedPlayers('job', 'ambulance')
    local CountAmbulances = #Ambulance

    if CountAmbulances > 0 then
        local src = source
        local xPlayert = ESX.GetPlayerFromId(src)
        if xPlayert.job.name == "ambulance" then
            TriggerClientEvent("dl-job:autoreviveems", src)
			TriggerClientEvent('alan-tasknotify:client:SendAlert', src, { type = 'inform', text = 'FREE, KARENA ANDA EMS!', length = 5000 })
        end
    else
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)        
        TriggerClientEvent("dl-job:autorevive", src)
        xPlayer.removeAccountMoney('bank', 15000)
		TriggerClientEvent('alan-tasknotify:client:SendAlert', src, { type = 'inform', text = 'Membayar dokter lokal $DL15.000', length = 5000 })
    end
end)

local stashes = {
	{
		-- Police stash
		id = 'brankas_ems',
		label = 'BRANKAS EMS',
		slots = 50,
		weight = 100000,
		owner = false,
		jobs = 'ambulance'
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

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(playerId)
	playerId = tonumber(playerId)
	local xPlayer = source and ESX.GetPlayerFromId(source)

	if xPlayer and xPlayer.job.name == 'ambulance' then
		local xTarget = ESX.GetPlayerFromId(playerId)
		if xTarget then
			if deadPlayers[playerId] then
				if Config.ReviveReward > 0 then
					xPlayer.showNotification(_U('revive_complete_award', xTarget.name, Config.ReviveReward))
					xPlayer.addMoney(Config.ReviveReward, "Revive Reward")
					xTarget.triggerEvent('esx_ambulancejob:revive')
				else
					xPlayer.showNotification(_U('revive_complete', xTarget.name))
					xTarget.triggerEvent('esx_ambulancejob:revive')
				end
				local Ambulance = ESX.GetExtendedPlayers('job', 'ambulance')

				for _, xPlayer in pairs(Ambulance) do
					xPlayer.triggerEvent('esx_ambulancejob:PlayerNotDead', playerId)
				end
				deadPlayers[playerId] = nil
			else
				xPlayer.showNotification(_U('player_not_unconscious'))
			end
		else
			xPlayer.showNotification(_U('revive_fail_offline'))
		end
	end
end)

AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
	if GetInvokingResource() ~= "monitor" or type(eventData) ~= "table" or type(eventData.id) ~= "number" then
		return
	end
	if deadPlayers[eventData.id] then
		TriggerClientEvent('esx_ambulancejob:revive', eventData.id)
		local Ambulance = ESX.GetExtendedPlayers('job', 'ambulance')

		for _, xPlayer in pairs(Ambulance) do
			xPlayer.triggerEvent('esx_ambulancejob:PlayerNotDead', eventData.id)
		end
		deadPlayers[eventData.id] = nil
	end
end)

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	local source = source
	deadPlayers[source] = 'dead'
	local Ambulance = ESX.GetExtendedPlayers('job', 'ambulance')

	for _, xPlayer in pairs(Ambulance) do
		xPlayer.triggerEvent('esx_ambulancejob:PlayerDead', source)
	end
end)

RegisterServerEvent('esx_ambulancejob:svsearch')
AddEventHandler('esx_ambulancejob:svsearch', function()
  TriggerClientEvent('esx_ambulancejob:clsearch', -1, source)
end)

RegisterNetEvent('esx_ambulancejob:onPlayerDistress')
AddEventHandler('esx_ambulancejob:onPlayerDistress', function()
	local source = source
	if deadPlayers[source] then
		deadPlayers[source] = 'distress'
		local Ambulance = ESX.GetExtendedPlayers('job', 'ambulance')

		for _, xPlayer in pairs(Ambulance) do
			TriggerClientEvent('esx_ambulancejob:PlayerDistressed', xPlayer.source, source)
		end
	end
end)

RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
	local source = source
	if deadPlayers[source] then
		deadPlayers[source] = nil
		local Ambulance = ESX.GetExtendedPlayers('job', 'ambulance')

		for _, xPlayer in pairs(Ambulance) do
			xPlayer.triggerEvent('esx_ambulancejob:PlayerNotDead', source)
		end
	end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	if deadPlayers[playerId] then
		deadPlayers[playerId] = nil
		local Ambulance = ESX.GetExtendedPlayers('job', 'ambulance')

		for _, xPlayer in pairs(Ambulance) do
			xPlayer.triggerEvent('esx_ambulancejob:PlayerNotDead', playerId)
		end
	end
end)

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:heal', target, type)
	end
end)

RegisterNetEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:putInVehicle', target)
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local name = GetPlayerName(source)
	local namaic = xPlayer.getName()
	local steamhex = GetPlayerIdentifier(source)
	local communtiylogo = ""
	local logs = "https://discord.com/api/webhooks/1046280495102697502/N6m6cnesj5H4ZOu-6M4WE8LtINxAe_NIBEzF8VgZUhxL5tEAbcenIFrniYu-Bl0BdeNQ"
	local money = xPlayer.getMoney()
	local bank = xPlayer.getAccount('bank').money
	local black = xPlayer.getAccount('black_money').money
	local job = xPlayer.job.name
	local armorypolicelog = {
		{
			["color"] = "1942002",
				["title"] = "LOG KOMA",
				["description"] = "Nama Ic: **"..namaic.."**\nNama Steam: **"..name.."**\n Steam Hex: **"..steamhex.."**\nUang Cash : **$DL"..ESX.Math.GroupDigits(money).."**\nBank : **$DL"..ESX.Math.GroupDigits(bank).."**\nUang Kotor : **$DL"..ESX.Math.GroupDigits(black).."**\nPekerjaan : **"..job.."**",
				["footer"] = {
				["text"] = "dailyliferp.id",
				["icon_url"] = communtiylogo,
			},
		}
	}
	PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "LOG KOMA", embeds = armorypolicelog}), { ['Content-Type'] = 'application/json' })

	if Config.OxInventory and Config.RemoveItemsAfterRPDeath then
		exports.ox_inventory:ClearInventory(xPlayer.source)
		return cb()
	end

	if Config.RemoveCashAfterRPDeath then
		if xPlayer.getMoney() > 0 then
			xPlayer.removeMoney(xPlayer.getMoney(), "Death")
		end

		if xPlayer.getAccount('black_money').money > 0 then
			xPlayer.setAccountMoney('black_money', 0, "Death")
		end
	end

	if Config.RemoveItemsAfterRPDeath then
		for i=1, #xPlayer.inventory, 1 do
			if xPlayer.inventory[i].count > 0 then
				xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
			end
		end
	end

	if Config.OxInventory then return cb() end

	local playerLoadout = {}
	if Config.RemoveWeaponsAfterRPDeath then
		for i=1, #xPlayer.loadout, 1 do
			xPlayer.removeWeapon(xPlayer.loadout[i].name)
		end
	else -- save weapons & restore em' since spawnmanager removes them
		for i=1, #xPlayer.loadout, 1 do
			table.insert(playerLoadout, xPlayer.loadout[i])
		end

		-- give back wepaons after a couple of seconds
		CreateThread(function()
			Wait(5000)
			for i=1, #playerLoadout, 1 do
				if playerLoadout[i].label ~= nil then
					xPlayer.addWeapon(playerLoadout[i].name, playerLoadout[i].ammo)
				end
			end
		end)
	end

	cb()
end)

if Config.EarlyRespawnFine then
	ESX.RegisterServerCallback('esx_ambulancejob:checkBalance', function(source, cb)
		local xPlayer = ESX.GetPlayerFromId(source)
		local bankBalance = xPlayer.getAccount('bank').money

		cb(bankBalance >= Config.EarlyRespawnFineAmount)
	end)

	RegisterNetEvent('esx_ambulancejob:payFine')
	AddEventHandler('esx_ambulancejob:payFine', function()
		local xPlayer = ESX.GetPlayerFromId(source)
		local fineAmount = Config.EarlyRespawnFineAmount

		xPlayer.showNotification(_U('respawn_bleedout_fine_msg', ESX.Math.GroupDigits(fineAmount)))
		xPlayer.removeAccountMoney('bank', fineAmount, "Respawn Fine")
	end)
end

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

ESX.RegisterServerCallback('esx_ambulancejob:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

	-- vehicle model not found
	if price == 0 then
		print(('esx_ambulancejob: %s attempted to exploit the shop! (invalid vehicle model)'):format(xPlayer.identifier))
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

ESX.RegisterServerCallback('esx_ambulancejob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
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
				print(('esx_ambulancejob: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end

end)

function getPriceFromHash(hashKey, jobGrade, type)
	if type == 'helicopter' then
		local vehicles = Config.AuthorizedHelicopters[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	elseif type == 'car' then
		local vehicles = Config.AuthorizedVehicles[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	end

	return 0
end

RegisterNetEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(item, 1)

	if item == 'bandage' then
		xPlayer.showNotification(_U('used_bandage'))
	elseif item == 'medikit' then
		xPlayer.showNotification(_U('used_medikit'))
	end
end)

RegisterNetEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'ambulance' then
		print(('[^2WARNING^7] Player ^5%s^7 Tried Giving Themselves -> ^5' .. itemName ..'^7!'):format(xPlayer.source))
		return
	elseif (itemName ~= 'medikit' and itemName ~= 'bandage') then
		print(('[^2WARNING^7] Player ^5%s^7 Tried Giving Themselves -> ^5' .. itemName ..'^7!'):format(xPlayer.source))
		return
	end

	if xPlayer.canCarryItem(itemName, amount) then
		xPlayer.addInventoryItem(itemName, amount)
	else
		xPlayer.showNotification(_U('max_item'))
	end
end)

ESX.RegisterCommand('revive', 'admin', function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx_ambulancejob:revive')
end, true, {help = _U('revive_help'), validate = true, arguments = {
	{name = 'playerId', help = 'The player id', type = 'player'}
}})

ESX.RegisterCommand('reviveall', "admin", function(xPlayer, args, showError)
	TriggerClientEvent('esx_ambulancejob:revive', -1)
end, false)

ESX.RegisterUsableItem('medikit', function(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('medikit', 1)

		playersHealing[source] = true
		TriggerClientEvent('esx_ambulancejob:useItem', source, 'medikit')

		Wait(10000)
		playersHealing[source] = nil
	end
end)

ESX.RegisterUsableItem('bandage', function(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('bandage', 1)

		playersHealing[source] = true
		TriggerClientEvent('esx_ambulancejob:useItem', source, 'bandage')

		Wait(10000)
		playersHealing[source] = nil
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:getDeadPlayers', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "ambulance" then 
		cb(deadPlayers)
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.scalar('SELECT is_dead FROM users WHERE identifier = ?', {xPlayer.identifier}, function(isDead)
		cb(isDead)
	end)
end)

RegisterNetEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local xPlayer = ESX.GetPlayerFromId(source)

	if type(isDead) == 'boolean' then
		MySQL.update('UPDATE users SET is_dead = ? WHERE identifier = ?', {isDead, xPlayer.identifier})
		
		if not isDead then 
			local Ambulance = ESX.GetExtendedPlayers('job', 'ambulance')
			for _, xPlayer in pairs(Ambulance) do
				xPlayer.triggerEvent('esx_ambulancejob:PlayerNotDead', source)
			end
		end
	end
end)

RegisterServerEvent('dl-ems:hapustiket')
AddEventHandler('dl-ems:hapustiket', function(tiket)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local drill = xPlayer.getInventoryItem('tiketoplas')
	if xPlayer.getInventoryItem('tiketoplas').count >= 1 then
		xPlayer.removeInventoryItem('tiketoplas', 1)
	else
	end
end)

RegisterServerEvent('dl-job:kirimLKoma')
AddEventHandler('dl-job:kirimLKoma', function(text2, text4)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local namaic = xPlayer.getName(_source)

	if text4 == 'isi alasanmu' then
	TriggerClientEvent('alan-tasknotify:client:SendAlert', _source, { type = 'error', text = 'Isi alasan yang benar!'})
	else
		text4 = text4
	end

	local date = os.date('*t')
			
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end

    local dto = date.day .. '.' .. date.month .. '.' .. date.year


    MySQL.Async.fetchAll('SELECT `koma` FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        local koma = result[1].koma
        MySQL.Async.fetchAll("UPDATE users SET koma = @koma WHERE identifier = @identifier",
            {
                ['@identifier'] = xPlayer.identifier,
                ['@koma'] = koma + 1
            }
        )
    end)

	local embeds = { {
		['title'] = '',
		['type'] = 'rich',
		['description'] = 'Nama: ' .. namaic .. '\nPassport: ' .. xPlayer.identifier ..  '\nPekerjaan: ' ..text2 .. '\nAlasan: ' .. text4,
		['color'] = 1942002, 
		['footer'] = {
			['text'] = dto,
		}, }
	}

	PerformHttpRequest("https://discord.com/api/webhooks/1005383081202548776/_H1d3NnInLVLBYgjgFDL4lRfqZRELJvZfhu49P7M3T9heRlewddcpE6nbbMW3pb7YevS", function(err, text, headers) end, 'POST', json.encode({ embeds = embeds}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('dl-job:terbuatpasien')
AddEventHandler('dl-job:terbuatpasien', function(targetSrc, url, habis)
	local src = source
	local targetSrc = ESX.GetPlayerFromId(targetSrc)
	local xPlayer = ESX.GetPlayerFromId(src)
	local card_metadata = {}
	card_metadata.type = targetSrc.name
	card_metadata.citizenid = targetSrc['identifier']:sub(-5)
	card_metadata.firstName = targetSrc.variables.firstName
	card_metadata.lastName = targetSrc.variables.lastName
	card_metadata.dateofbirth = targetSrc.variables.dateofbirth
	card_metadata.sex = targetSrc.variables.sex
	card_metadata.height = targetSrc.variables.height
	card_metadata.mugshoturl = url
	card_metadata.cardtype = 'kartu_pasien'
	local curtime = os.time(os.date("!*t"))
	local diftime = curtime + 2629746
	card_metadata.issuedon = habis
	card_metadata.expireson = habis

	local sex, identifier = targetSrc.variables.sex
	if sex == 'm' then sex = 'Pria' elseif sex == 'f' then sex = 'Wanita' end
	card_metadata.description = ('Nama : %s Tanggal Lahir: %s Jenis Kelamin: %s Berlaku: %s'):format( targetSrc.name, sex, targetSrc.variables.dateofbirth, habis )
	targetSrc.addInventoryItem('kartu_pasien', 1, card_metadata)
end)

RegisterServerEvent('dl-job:terbuatBPJS')
AddEventHandler('dl-job:terbuatBPJS', function(targetSrc, url, habis)
	local src = source
	local targetSrc = ESX.GetPlayerFromId(targetSrc)
	local xPlayer = ESX.GetPlayerFromId(src)
	local card_metadata = {}
	card_metadata.type = targetSrc.name
	card_metadata.citizenid = targetSrc['identifier']:sub(-5)
	card_metadata.firstName = targetSrc.variables.firstName
	card_metadata.lastName = targetSrc.variables.lastName
	card_metadata.dateofbirth = targetSrc.variables.dateofbirth
	card_metadata.sex = targetSrc.variables.sex
	card_metadata.height = targetSrc.variables.height
	card_metadata.mugshoturl = url
	card_metadata.cardtype = 'kartu_bpjs'
	local curtime = os.time(os.date("!*t"))
	local diftime = curtime + 2629746
	card_metadata.issuedon = habis
	card_metadata.expireson = habis

	local sex, identifier = targetSrc.variables.sex
	if sex == 'm' then sex = 'Pria' elseif sex == 'f' then sex = 'Wanita' end
	card_metadata.description = ('Nama : %s Tanggal Lahir: %s Jenis Kelamin: %s Berlaku: %s'):format( targetSrc.name, sex, targetSrc.variables.dateofbirth, habis )
	targetSrc.addInventoryItem('kartu_bpjs', 1, card_metadata)
end)

RegisterServerEvent('dl-job:gawekno')
AddEventHandler('dl-job:gawekno', function(targetSrc, mugshotURL, habis)
	local src = source
	local targetSrc = tonumber(targetSrc)

	TriggerEvent('dl-job:terbuatpasien', targetSrc, mugshotURL, habis)
end)

RegisterServerEvent('dl-job:gaweknoBPJS')
AddEventHandler('dl-job:gaweknoBPJS', function(targetSrc, mugshotURL, habis)
	local src = source
	local targetSrc = tonumber(targetSrc)

	TriggerEvent('dl-job:terbuatBPJS', targetSrc, mugshotURL, habis)
end)