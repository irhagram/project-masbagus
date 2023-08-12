ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
		MySQL.Async.fetchAll('SELECT * FROM gudang', {}, function(result)
			if result then
				for i = 1, #result do
					local row = result[i]
					exports.ox_inventory:RegisterStash(row.gudang .. ' - ' .. row.identifier, 'Gudang', 75, 500000, row.identifier)
				end
			end
		end)
    end
end)

ESX.RegisterServerCallback('dl-gudang:checkGudang', function(source, cb, gudang)
	local xPlayer = ESX.GetPlayerFromId(source)
	local pid = xPlayer.identifier
	MySQL.Async.fetchAll('SELECT * FROM gudang WHERE gudang = @gudang AND identifier = @identifier', { ['@gudang'] = gudang, ['@identifier'] = xPlayer.identifier }, function(result) 
		if result[1] ~= nil then
			cb(true)
		else
			cb(false)
		end	
	end)
end)

RegisterServerEvent('dl-gudang:tukuGudang')
AddEventHandler('dl-gudang:tukuGudang', function(gudangName) 
	local rdg = source
	local xPlayer = ESX.GetPlayerFromId(rdg)

	xPlayer.removeMoney(50000)

	MySQL.Async.execute('INSERT INTO gudang (identifier, gudang) VALUES (@identifier, @gudang)', {
		['@identifier']   = xPlayer.identifier,
		['@gudang']  = gudangName
	}, function(rowsChanged)
		exports.ox_inventory:RegisterStash(gudangName .. ' - ' .. xPlayer.identifier, 'Gudang', 75, 500000, xPlayer.identifier)
		TriggerClientEvent('alan-tasknotify:client:SendAlert', rdg, { type = 'error', text = 'Biaya sewa $DL 50.000'})
	end)
end)

RegisterServerEvent('dl-gudang:mandekGudang')
AddEventHandler('dl-gudang:mandekGudang', function(gudang) 
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	MySQL.Async.execute('DELETE FROM gudang WHERE gudang = @gudang AND identifier = @identifier', {
		['@gudang']  = gudang,
		['@identifier'] = xPlayer.identifier
	}, function(rowsChanged)
		TriggerClientEvent('alan-tasknotify:client:SendAlert', src, { type = 'error', text = 'Berhenti Menyewa gudang'})
	end)
end)

function PayGudangRent(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM gudang', {}, function(result)
		for i=1, #result, 1 do
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].identifier)
			local pajakgudang = 10000
			if xPlayer then
				xPlayer.removeAccountMoney('bank', pajakgudang)
				TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'inform', text = "Membayar Pajak Gudang $DL "..pajakgudang, length = 8000 })
			else
				MySQL.Sync.execute('UPDATE users SET bank = bank - @bank WHERE identifier = @identifier', { ['@bank'] = pajakgudang, ['@identifier'] = result[i].identifier })
			end
		end
	end)
end

TriggerEvent('cron:runAt', 21, 00, PayGudangRent)