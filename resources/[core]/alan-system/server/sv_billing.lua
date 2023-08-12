RegisterServerEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function(playerId, sharedAccountName, label, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	amount = ESX.Math.Round(amount)
	local date = os.date('*t')
			
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end

    local hari = date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' ..date.hour.. '.' ..date.min

	if amount > 0 and xTarget then
		TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)
			if account then
				local name = xPlayer.getName()
				local namet = xTarget.getName()
				local ip = GetPlayerEndpoint(source)
				local steamhex = GetPlayerIdentifier(source)
				local communtiylogo = ""
				local logs = "https://discord.com/api/webhooks/1060045972123697252/rSYFO1IKGx1n9MTAV73MiU7Wgu3jiAVxzrx9wUQlAVnt_cz69DjaKNwfJ6-l6lo0VjwG"
				local logsgivesu = {
					{
						["color"] = "1942002",
							["title"] = "Memberi Biling",
							["description"] = "**Hex Pengirim: **"..xTarget.identifier.."\n**Nama Pengirim**: "..name.."\n**Hex Target: **"..xTarget.identifier.."\n**Nama Target:** "..namet.."**\nSociety: **"..sharedAccountName.."\n**Alasan: **"..label.."\n**Jumlah: **"..amount.."",
						["footer"] = {
							["text"] = "dailyliferp.id | "..hari,
							["icon_url"] = communtiylogo,
						},
					}
				}
				PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "ALAN LOGS", embeds = logsgivesu}), { ['Content-Type'] = 'application/json' })
				MySQL.insert('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (?, ?, ?, ?, ?, ?)', {xTarget.identifier, xPlayer.identifier, 'society', sharedAccountName, label, amount},
				function(rowsChanged)
					xTarget.showNotification(_U('received_invoice'), inform)
				end)
			else
				MySQL.insert('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (?, ?, ?, ?, ?, ?)', {xTarget.identifier, xPlayer.identifier, 'player', xPlayer.identifier, label, amount},
				function(rowsChanged)
					xTarget.showNotification(_U('received_invoice'), 'inform')
				end)
			end
		end)
	end
end)

ESX.RegisterServerCallback('esx_billing:getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.query('SELECT amount, id, label FROM billing WHERE identifier = ?', {xPlayer.identifier},
	function(result)
		cb(result)
	end)
end)

ESX.RegisterServerCallback('esx_billing:getTargetBills', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		MySQL.query('SELECT amount, id, label FROM billing WHERE identifier = ?', {xPlayer.identifier},
		function(result)
			cb(result)
		end)
	else
		cb({})
	end
end)

ESX.RegisterServerCallback('esx_billing:payBill', function(source, cb, billId)
	local xPlayer = ESX.GetPlayerFromId(source)
	local date = os.date('*t')
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end

    local hari = date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' ..date.hour.. '.' ..date.min

	MySQL.single('SELECT sender, target_type, target, amount FROM billing WHERE id = ?', {billId},
	function(result)
		if result then
			local amount = result.amount
			local xTarget = ESX.GetPlayerFromIdentifier(result.sender)

			if result.target_type == 'player' then
				if xTarget then
					if xPlayer.getMoney() >= amount then
						MySQL.update('DELETE FROM billing WHERE id = ?', {billId},
						function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeMoney(amount)
								xTarget.addMoney(amount)
								local name = xPlayer.getName()
								local namet = xTarget.getName()
								local ip = GetPlayerEndpoint(source)
								local steamhex = GetPlayerIdentifier(source)
								local communtiylogo = ""
								local logs = "https://discord.com/api/webhooks/1060045972123697252/rSYFO1IKGx1n9MTAV73MiU7Wgu3jiAVxzrx9wUQlAVnt_cz69DjaKNwfJ6-l6lo0VjwG"
								local logsgivesu = {
									{
										["color"] = "1942002",
											["title"] = "Membayar Biling",
											["description"] = "**Hex Pengirim: **"..xTarget.identifier.."\n**Nama Pengirim**: "..name.."\n**Hex Target: **"..xTarget.identifier.."\n**Nama Target:** "..namet.."**\nSociety: **"..sharedAccountName.."\n**Alasan: **"..label.."\n**Jumlah: **"..amount.."",
										["footer"] = {
											["text"] = "dailyliferp.id | "..hari,
											["icon_url"] = communtiylogo,
										},
									}
								}
								PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "ALAN LOGS", embeds = logsgivesu}), { ['Content-Type'] = 'application/json' })
								xPlayer.showNotification(_U('paid_invoice', ESX.Math.GroupDigits(amount)))
								xTarget.showNotification(_U('received_payment', ESX.Math.GroupDigits(amount)))
							end

							cb()
						end)
					elseif xPlayer.getAccount('bank').money >= amount then
						MySQL.update('DELETE FROM billing WHERE id = ?', {billId},
						function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeAccountMoney('bank', amount)
								xTarget.addAccountMoney('bank', amount)

								local name = xPlayer.getName()
								local namet = xTarget.getName()
								local ip = GetPlayerEndpoint(source)
								local steamhex = GetPlayerIdentifier(source)
								local communtiylogo = ""
								local logs = "https://discord.com/api/webhooks/1060045972123697252/rSYFO1IKGx1n9MTAV73MiU7Wgu3jiAVxzrx9wUQlAVnt_cz69DjaKNwfJ6-l6lo0VjwG"
								local logsgivesu = {
									{
										["color"] = "1942002",
											["title"] = "Membayar Biling",
											["description"] = "**Hex Pengirim: **"..xTarget.identifier.."\n**Nama Pengirim**: "..name.."\n**Hex Target: **"..xTarget.identifier.."\n**Nama Target:** "..namet.."**\nSociety: **"..sharedAccountName.."\n**Alasan: **"..label.."\n**Jumlah: **"..amount.."",
										["footer"] = {
											["text"] = "dailyliferp.id | "..hari,
											["icon_url"] = communtiylogo,
										},
									}
								}
								PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "ALAN LOGS", embeds = logsgivesu}), { ['Content-Type'] = 'application/json' })
								xPlayer.showNotification(_U('paid_invoice', ESX.Math.GroupDigits(amount)))
								xTarget.showNotification(_U('received_payment', ESX.Math.GroupDigits(amount)))
							end

							cb()
						end)
					else
						xTarget.showNotification(_U('target_no_money'))
						xPlayer.showNotification(_U('no_money'))
						cb()
					end
				else
					xPlayer.showNotification(_U('player_not_online'))
					cb()
				end
			else
				TriggerEvent('esx_addonaccount:getSharedAccount', result.target, function(account)
					if xPlayer.getMoney() >= amount then
						MySQL.update('DELETE FROM billing WHERE id = ?', {billId},
						function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeMoney(amount)
								account.addMoney(amount)

								xPlayer.showNotification(_U('paid_invoice', ESX.Math.GroupDigits(amount)))
								if xTarget then
									xTarget.showNotification(_U('received_payment', ESX.Math.GroupDigits(amount)))
								end
							end

							cb()
						end)
					elseif xPlayer.getAccount('bank').money >= amount then
						MySQL.update('DELETE FROM billing WHERE id = ?', {billId},
						function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeAccountMoney('bank', amount)
								account.addMoney(amount)
								local name = xPlayer.getName()
								local namet = xTarget.getName()
								local ip = GetPlayerEndpoint(source)
								local steamhex = GetPlayerIdentifier(source)
								local communtiylogo = ""
								local logs = "https://discord.com/api/webhooks/1060045972123697252/rSYFO1IKGx1n9MTAV73MiU7Wgu3jiAVxzrx9wUQlAVnt_cz69DjaKNwfJ6-l6lo0VjwG"
								local logsgivesu = {
									{
										["color"] = "1942002",
											["title"] = "Membayar Biling",
											["description"] = "**Hex Pengirim: **"..xTarget.identifier.."\n**Nama Pengirim**: "..name.."\n**Hex Target: **"..xTarget.identifier.."\n**Nama Target:** "..namet.."\n**Jumlah: **"..amount.."",
										["footer"] = {
											["text"] = "dailyliferp.id | "..hari,
											["icon_url"] = communtiylogo,
										},
									}
								}
								PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "ALAN LOGS", embeds = logsgivesu}), { ['Content-Type'] = 'application/json' })
								xPlayer.showNotification(_U('paid_invoice', ESX.Math.GroupDigits(amount)))

								if xTarget then
									xTarget.showNotification(_U('received_payment', ESX.Math.GroupDigits(amount)))
								end
							end

							cb()
						end)
					else
						if xTarget then
							xTarget.showNotification(_U('target_no_money'))
						end

						xPlayer.showNotification(_U('no_money'))
						cb()
					end
				end)
			end
		end
	end)
end)
