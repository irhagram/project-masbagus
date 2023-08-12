--=====================
-- Praryo Locker Room
--=====================


local Delay = false


ESX.RegisterServerCallback('alan_locker:checkLocker', function(source, cb, lockerId)
	local pyrp = source
	local xPlayer = ESX.GetPlayerFromId(pyrp)
	MySQL.Async.fetchAll('SELECT * FROM alan_locker WHERE lockerName = @lockerId AND identifier = @identifier', { ['@lockerId'] = lockerId, ['@identifier'] = xPlayer.identifier }, function(result) 
		if result[1] ~= nil then
			cb(true)
		else
			cb(false)
		end	
	end)
end)

--===========================
-- Locker Start/Stop Renting
--===========================

RegisterServerEvent('alan_locker:startRentingLocker')
AddEventHandler('alan_locker:startRentingLocker', function(lockerId, lockerName) 
	local pyrp = source
	local xPlayer = ESX.GetPlayerFromId(pyrp)
	MySQL.Async.fetchAll('SELECT * FROM alan_locker WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
		if result[1] == nil then
			if xPlayer.getMoney() >= Gudang.InitialRentPrice then
				MySQL.Async.execute('INSERT INTO alan_locker (identifier, lockerName) VALUES (@identifier, @lockerId)', {
					['@identifier'] = xPlayer.identifier,
					['@lockerId'] = lockerId
				})
				xPlayer.removeMoney(Gudang.InitialRentPrice)
				TriggerClientEvent('mythic_notify:client:SendAlert', pyrp, { type = 'success', text = "Kamu mulai menyewa " ..lockerName.. ". Kamu akan dikenakan biaya Rp."..Gudang.DailyRentPrice.." daily (IRL)", length = 5000 })
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', pyrp, { type = 'error', text = "Kamu tidak memiliki uang untuk membayar biaya penyewaan pertama.", length = 5000 })
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', pyrp, { type = 'error', text = "Kamu sudah memiliki gudang.", length = 5000 })
		end
	end)
end)

RegisterServerEvent('alan_locker:stopRentingLocker')
AddEventHandler('alan_locker:stopRentingLocker', function(lockerId, lockerName) 
	local pyrp = source
	local xPlayer = ESX.GetPlayerFromId(pyrp)
	MySQL.Async.fetchAll('SELECT * FROM alan_locker WHERE lockerName = @lockerId AND identifier = @identifier', { ['@lockerId'] = lockerId, ['@identifier'] = xPlayer.identifier }, function(result)
		if result[1] ~= nil then
			MySQL.Async.execute('DELETE from alan_locker WHERE lockerName = @lockerId AND identifier = @identifier', {
				['@lockerId'] = lockerId,
				['@identifier'] = xPlayer.identifier
			})
			TriggerClientEvent('mythic_notify:client:SendAlert', pyrp, { type = 'inform', text = "Membatalkan penyewaan gudang.", length = 5000 })
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', pyrp, { type = 'error', text = "Kamu tidak memiliki gudang ini.", length = 5000 })
		end
	end)
end)

--=============
-- Pay Rent
--=============

function PayLockerRent(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM alan_locker', {}, function(result)
		for i=1, #result, 1 do
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].identifier)
			if xPlayer then
				xPlayer.removeAccountMoney('bank', Gudang.DailyRentPrice)
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = "Kamu membayar Rp. "..Gudang.DailyRentPrice.." untuk biaya gudang.", length = 8000 })
			else
				MySQL.Sync.execute('UPDATE users SET bank = bank - @bank WHERE identifier = @identifier', { ['@bank'] = Gudang.DailyRentPrice, ['@identifier'] = result[i].identifier })
			end
		end
	end)
end

TriggerEvent('cron:runAt', 5, 10, PayLockerRent)

--=============
-- Stash
--=============


RegisterServerEvent('alan_locker:getItem')
AddEventHandler('alan_locker:getItem', function(owner, type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)
	local tanggalWaktu = os.date("%x %X", os.time())

	if type == 'item_standard' then

		local sourceItem = xPlayer.getInventoryItem(item)

		TriggerEvent('esx_addoninventory:getInventory', 'locker', xPlayerOwner.identifier, function(inventory)
			local inventoryItem = inventory.getItem(item)

			-- is there enough in the property?
			if count > 0 and inventoryItem.count >= count then
			
				-- can the player carry the said amount of x item?
				if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Kantongmu penuh.', length = 5000 })
				else
					if not Delay then
						inventory.removeItem(item, count)
						xPlayer.addInventoryItem(item, count)
						--TriggerEvent('nat:loggudang', 'https://discord.com/api/webhooks/838244094932942878/gO4azKAtQBujm9O6OcuZ-I-b6pflTnweURcVXrmwiWxvpZVXbIzs7KmU62n0j7Bt8x-H', 'SYSTEM', '`' .. tanggalWaktu .. '`\n```css\n' .. xPlayer.name .. ' mengambil ' .. count .. ' ' .. item .. '\n```', 'https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png', false)
						TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Mengambil '..count..'x '..inventoryItem.label..' dari gudang.', length = 1000 })
						TriggerEvent('nat:delaygudang')
						Delay = true
					else
						TriggerClientEvent('esx:showNotification', _source, 'Tunggu 1 detik lagi!')
					end
				end
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Kamu tidak memiliki barang ini lagi di gudang.', length = 5000 })
			end
		end)

	elseif type == 'item_account' then

		TriggerEvent('esx_addonaccount:getAccount', 'locker', xPlayerOwner.identifier, function(account)
			local roomAccountMoney = account.money

			if roomAccountMoney >= count then
				if not Delay then
					account.removeMoney(count)
					xPlayer.addAccountMoney(item, count)
					--TriggerEvent('nat:loggudang', 'https://discord.com/api/webhooks/838244094932942878/gO4azKAtQBujm9O6OcuZ-I-b6pflTnweURcVXrmwiWxvpZVXbIzs7KmU62n0j7Bt8x-H', 'SYSTEM', '`' .. tanggalWaktu .. '`\n```css\n' .. xPlayer.name .. ' mengambil ' .. count .. ' ' .. item .. '\n```', 'https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png', false)
					Delay = true
					TriggerEvent('nat:delaygudang')
				else
					TriggerClientEvent('esx:showNotification', _source, 'Tunggu 1 detik lagi!')
				end
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Jumlah salah.', length = 5000 })
			end
		end)

	elseif type == 'item_weapon' then

		TriggerEvent('esx_datastore:getDataStore', 'locker', xPlayerOwner.identifier, function(store)
			local storeWeapons = store.get('weapons') or {}
			local weaponName   = nil
			local ammo         = nil

			for i=1, #storeWeapons, 1 do
				if storeWeapons[i].name == item then
					weaponName = storeWeapons[i].name
					ammo       = storeWeapons[i].ammo

					table.remove(storeWeapons, i)
					break
				end
			end

			if not Delay then
				store.set('weapons', storeWeapons)
				xPlayer.addWeapon(weaponName, ammo)
				--TriggerEvent('nat:loggudang', 'https://discord.com/api/webhooks/838244094932942878/gO4azKAtQBujm9O6OcuZ-I-b6pflTnweURcVXrmwiWxvpZVXbIzs7KmU62n0j7Bt8x-H', 'SYSTEM', '`' .. tanggalWaktu .. '`\n```css\n' .. xPlayer.name .. ' mengambil ' .. weaponName .. ' berpeluru ' .. ammo .. '\n```', 'https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png', false)
				Delay = true
				TriggerEvent('nat:delaygudang')
			else
				TriggerClientEvent('esx:showNotification', _source, 'Tunggu 1 detik lagi!')
			end
		end)

	end

end)

RegisterServerEvent('alan_locker:putItem')
AddEventHandler('alan_locker:putItem', function(owner, type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)
	local tanggalWaktu = os.date("%x %X", os.time())

	if type == 'item_standard' then

		local playerItemCount = xPlayer.getInventoryItem(item).count

		if playerItemCount >= count and count > 0 then
			if not Delay then
				TriggerEvent('esx_addoninventory:getInventory', 'locker', xPlayerOwner.identifier, function(inventory)
					xPlayer.removeInventoryItem(item, count)
					inventory.addItem(item, count)
					--TriggerEvent('nat:loggudang', 'https://discord.com/api/webhooks/838244094932942878/gO4azKAtQBujm9O6OcuZ-I-b6pflTnweURcVXrmwiWxvpZVXbIzs7KmU62n0j7Bt8x-H', 'SYSTEM', '`' .. tanggalWaktu .. '`\n```css\n' .. xPlayer.name .. ' menaruh ' .. count .. ' ' .. item .. '\n```', 'https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png', false)
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Kamu memasukkan '..count..'x '..inventory.getItem(item).label..' kedalam gudang.', length = 1000 })
					Delay = true
					TriggerEvent('nat:delaygudang')
				end)
			else
				TriggerClientEvent('esx:showNotification', _source, 'Tunggu 1 detik lagi!')
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Jumlah salah.', length = 5000 })
		end

	elseif type == 'item_account' then

		local playerAccountMoney = xPlayer.getAccount(item).money

		if playerAccountMoney >= count and count > 0 then
			if not Delay then
				xPlayer.removeAccountMoney(item, count)

				TriggerEvent('esx_addonaccount:getAccount', 'locker', xPlayerOwner.identifier, function(account)
					account.addMoney(count)
				end)
				--TriggerEvent('nat:loggudang', 'https://discord.com/api/webhooks/838244094932942878/gO4azKAtQBujm9O6OcuZ-I-b6pflTnweURcVXrmwiWxvpZVXbIzs7KmU62n0j7Bt8x-H', 'SYSTEM', '`' .. tanggalWaktu .. '`\n```css\n' .. xPlayer.name .. ' menaruh ' .. count .. ' ' .. item .. '\n```', 'https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png', false)
				Delay = true
				TriggerEvent('nat:delaygudang')
			else
				TriggerClientEvent('esx:showNotification', _source, 'Tunggu 1 detik lagi!')
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Jumlah salah.', length = 5000 })
		end

	elseif type == 'item_weapon' then

		TriggerEvent('esx_datastore:getDataStore', 'locker', xPlayerOwner.identifier, function(store)
			local storeWeapons = store.get('weapons') or {}

			table.insert(storeWeapons, {
				name = item,
				ammo = count
			})

			if not Delay then
				store.set('weapons', storeWeapons)
				xPlayer.removeWeapon(item)
				--TriggerEvent('nat:loggudang', 'https://discord.com/api/webhooks/838244094932942878/gO4azKAtQBujm9O6OcuZ-I-b6pflTnweURcVXrmwiWxvpZVXbIzs7KmU62n0j7Bt8x-H', 'SYSTEM', '`' .. tanggalWaktu .. '`\n```css\n' .. xPlayer.name .. ' menaruh ' .. item .. '\n```', 'https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png', false)
				Delay = true
				TriggerEvent('nat:delaygudang')
			else
				TriggerClientEvent('esx:showNotification', _source, 'Tunggu 1 detik lagi!')
			end
		end)

	end

end)

ESX.RegisterServerCallback('alan_locker:getPropertyInventory', function(source, cb, owner, lockerName)
	local xPlayer    = ESX.GetPlayerFromIdentifier(owner)
	local blackMoney = 0
	local items      = {}
	local weapons    = {}

	TriggerEvent('esx_addonaccount:getAccount', 'locker', xPlayer.identifier, function(account)
		blackMoney = account.money
	end)

	TriggerEvent('esx_addoninventory:getInventory', 'locker', xPlayer.identifier, function(inventory)
		items = inventory.items
	end)

	TriggerEvent('esx_datastore:getDataStore', 'locker', xPlayer.identifier, function(store)
		weapons = store.get('weapons') or {}
	end)

	cb({
		blackMoney = blackMoney,
		items      = items,
		weapons    = weapons,
		stash_name    = lockerName
	})
end)


RegisterServerEvent('nat:loggudang')
AddEventHandler('nat:loggudang', function(WebHook, Name, Message, Image, External, Source, TTS)
	PerformHttpRequest(WebHook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message, avatar_url = Image, tts = TTS}), {['Content-Type'] = 'application/json'})
end)

RegisterServerEvent('nat:delaygudang')
AddEventHandler('nat:delaygudang', function(WebHook, Name, Message, Image, External, Source, TTS)
	Delay = true
	Citizen.Wait(2000)
	Delay = false
end)


--============================--
	--OX REGISTERSTASH--
--============================--

RegisterServerEvent('gudang:registerstash', function(id)
	TriggerClientEvent('koe_storageunits:openStash', source, id)
	exports.ox_inventory:RegisterStash(id, "Gudang", 75, 500000, true)
end)

