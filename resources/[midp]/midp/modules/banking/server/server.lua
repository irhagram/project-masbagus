ESX = nil
local oxinv = exports.ox_inventory

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("okokBanking:GetPlayerInfo", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local db = result[1]
		local data = {
			playerName = xPlayer.getName(),
			playerBankMoney = xPlayer.getAccount('bank').money,
			playerIBAN = db.iban,
			walletMoney = xPlayer.getMoney(),
			sex = db.sex,
		}

		cb(data)
	end)
end)

ESX.RegisterServerCallback("okokBanking:IsIBanUsed", function(source, cb, iban)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	MySQL.Async.fetchAll('SELECT * FROM users WHERE iban = @iban', {
		['@iban'] = iban
	}, function(result)
		local db = result[1]
		if db ~= nil then
			
			cb(db, true)
		else
			MySQL.Async.fetchAll('SELECT * FROM okokBanking_societies WHERE iban = @iban', {
				['@iban'] = iban
			}, function(result2)
				local db2 = result2[1]
				
				cb(db2, false)
			end)
		end
	end)
end)

ESX.RegisterServerCallback("okokBanking:GetPIN", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	MySQL.Async.fetchAll('SELECT pincode FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
	}, function(result)
		local pin = result[1]

		cb(pin.pincode)
	end)
end)

ESX.RegisterServerCallback("okokBanking:SocietyInfo", function(source, cb, society)
	MySQL.Async.fetchAll('SELECT * FROM okokBanking_societies WHERE society = @society', {
		['@society'] = society
	}, function(result)
		local db = result[1]
		cb(db)
	end)
end)

RegisterServerEvent("okokBanking:CreateSocietyAccount")
AddEventHandler("okokBanking:CreateSocietyAccount", function(society, society_name, value, iban)
	MySQL.Async.insert('INSERT INTO okokBanking_societies (society, society_name, value, iban) VALUES (@society, @society_name, @value, @iban)', {
		['@society'] = society,
		['@society_name'] = society_name,
		['@value'] = value,
		['@iban'] = iban:upper(),
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:SetIBAN")
AddEventHandler("okokBanking:SetIBAN", function(iban)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET iban = @iban WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
		['@iban'] = iban,
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:DepositMoney")
AddEventHandler("okokBanking:DepositMoney", function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getMoney()

	if amount <= playerMoney then
		xPlayer.removeMoney(amount)
		xPlayer.addAccountMoney('bank', amount)
		local name = GetPlayerName(source)
		local namaic = xPlayer.getName()
		local steamhex = GetPlayerIdentifier(source)
		local communtiylogo = ""
		local logs = "https://discord.com/api/webhooks/1010846632604082236/WNBYS3ACDaujdTCqDwf-xVN-NJqMBPaknVKJWxf047szArhXMWRYte_cZLyzX4hLqS_g"
		local money = xPlayer.getMoney()
		local bank = xPlayer.getAccount('bank').money
		local black = xPlayer.getAccount('black_money').money
		local job = xPlayer.job.name
		local lodwd = {
			{
				["color"] = "1942002",
					["title"] = "LOG DEPOSIT BANK",
					["description"] = "**Nama Ic:** "..namaic.."\n **Nama Steam:** "..name.."\n **Steam Hex:** "..steamhex.."\n**Uang Cash:** $DL "..ESX.Math.GroupDigits(money).."\n**Bank:** $DL "..ESX.Math.GroupDigits(bank).."\n**Uang Kotor:** $DL"..ESX.Math.GroupDigits(black).."\n**Pekerjaan:** "..job.."\n**Deposit Uang: ** $DL " ..ESX.Math.GroupDigits(amount).. "",
					["footer"] = {
					["text"] = "dailyliferp.id",
					["icon_url"] = communtiylogo,
				},
			}
		}
		PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "LOG BANK", embeds = lodwd}), { ['Content-Type'] = 'application/json' })

		TriggerEvent('okokBanking:AddDepositTransaction', amount, source)
		TriggerClientEvent('okokBanking:updateTransactions', source, xPlayer.getAccount('bank').money, xPlayer.getMoney())
		TriggerClientEvent('midp-tasknotify:Alert', source, "You have deposited "..amount.."$",  'success')
	else
		TriggerClientEvent('midp-tasknotify:Alert', source, "You don't have that much money on you",  'error')
	end
end)

RegisterServerEvent("okokBanking:WithdrawMoney")
AddEventHandler("okokBanking:WithdrawMoney", function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getAccount('bank').money

	if amount <= playerMoney then
		xPlayer.removeAccountMoney('bank', amount)
		xPlayer.addMoney(amount)
		local name = GetPlayerName(source)
		local namaic = xPlayer.getName()
		local steamhex = GetPlayerIdentifier(source)
		local communtiylogo = ""
		local logs = "https://discord.com/api/webhooks/1005384472834887780/i8wZB_BDyvUa0jZ1Jg07BPrlOMl0_7Ad8sXxVTLYHKtZNyi0QgHskyDfgzye7qoU3O_C"
		local money = xPlayer.getMoney()
		local bank = xPlayer.getAccount('bank').money
		local black = xPlayer.getAccount('black_money').money
		local job = xPlayer.job.name
		local logambil = {
			{
				["color"] = "1942002",
					["title"] = "LOG WITHDRAW BANK",
					["description"] = "**Nama Ic:** "..namaic.."\n **Nama Steam:** "..name.."\n **Steam Hex:** "..steamhex.."\n**Uang Cash:** $DL "..ESX.Math.GroupDigits(money).."\n**Bank:** $DL "..ESX.Math.GroupDigits(bank).."\n**Uang Kotor:** $DL"..ESX.Math.GroupDigits(black).."\n**Pekerjaan:** "..job.."\n**Mengambil Uang: ** $DL " ..ESX.Math.GroupDigits(amount).. "",
					["footer"] = {
					["text"] = "dailyliferp.id",
					["icon_url"] = communtiylogo,
				},
			}
		}
		PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "LOG BANK", embeds = logambil}), { ['Content-Type'] = 'application/json' })

		TriggerEvent('okokBanking:AddWithdrawTransaction', amount, source)
		TriggerClientEvent('okokBanking:updateTransactions', source, xPlayer.getAccount('bank').money, xPlayer.getMoney())
		TriggerClientEvent('midp-tasknotify:Alert', source, "You have withdrawn "..amount.."$",  'success')
	else
		TriggerClientEvent('midp-tasknotify:Alert', source, "You don't have that much money on the bank",  'error')
	end
end)

RegisterServerEvent("okokBanking:TransferMoney")
AddEventHandler("okokBanking:TransferMoney", function(amount, ibanNumber, targetIdentifier, acc, targetName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromIdentifier(targetIdentifier)
	local xPlayers = ESX.GetPlayers()
	local playerMoney = xPlayer.getAccount('bank').money
	ibanNumber = ibanNumber:upper()
	if xPlayer.identifier ~= targetIdentifier then
		if amount <= playerMoney then
			
			if xTarget ~= nil then
				xPlayer.removeAccountMoney('bank', amount)
				xTarget.addAccountMoney('bank', amount)
				local name = GetPlayerName(source)
				local namaic = xPlayer.getName()
				local steamhex = GetPlayerIdentifier(source)
				local communtiylogo = ""
				local logs = "https://discord.com/api/webhooks/1046288358332174346/9RJrPbARxdDkTSxQFtA9dysjUPYdowtZi14Gef9Jq_c-OZ5bYmbcsiZwzfycFhgkxd6P"
				local money = xPlayer.getMoney()
				local bank = xPlayer.getAccount('bank').money
				local black = xPlayer.getAccount('black_money').money
				local job = xPlayer.job.name
				local logtf = {
					{
						["color"] = "1942002",
							["title"] = "LOG TRANSFER BANK",
							["description"] = "**Nama Ic:** "..namaic.."\n **Nama Steam:** "..name.."\n **Steam Hex:** "..steamhex.."\n**Uang Cash:** $DL "..ESX.Math.GroupDigits(money).."\n**Bank:** $DL "..ESX.Math.GroupDigits(bank).."\n**Uang Kotor:** $DL"..ESX.Math.GroupDigits(black).."\n**Pekerjaan:** "..job.."\n**Jumlah: ** $DL " ..ESX.Math.GroupDigits(amount).. "\n**Target:** "..targetIdentifier.."",
							["footer"] = {
							["text"] = "dailyliferp.id",
							["icon_url"] = communtiylogo,
						},
					}
				}
				PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "LOG BANK", embeds = logtf}), { ['Content-Type'] = 'application/json' })

				for i=1, #xPlayers, 1 do
				    local xForPlayer = ESX.GetPlayerFromId(xPlayers[i])
				    if xForPlayer.identifier == targetIdentifier then

				    	TriggerClientEvent('okokBanking:updateTransactions', xPlayers[i], xTarget.getAccount('bank').money, xTarget.getMoney())
				    	TriggerClientEvent('midp-tasknotify:Alert', xPlayers[i], "You have received "..amount.."$ from "..xPlayer.getName(),  'success')
				    end
				end
				TriggerEvent('okokBanking:AddTransferTransaction', amount, xTarget, source)
				TriggerClientEvent('okokBanking:updateTransactions', source, xPlayer.getAccount('bank').money, xPlayer.getMoney())
				TriggerClientEvent('midp-tasknotify:Alert', source, "You have transferred "..amount.."$ to "..xTarget.getName(),  'success')
			elseif xTarget == nil then
				local playerAccount = json.decode(acc)
				playerAccount.bank = playerAccount.bank + amount
				playerAccount = json.encode(playerAccount)

				xPlayer.removeAccountMoney('bank', amount)

				TriggerEvent('okokBanking:AddTransferTransaction', amount, xTarget, source, targetName, targetIdentifier)
				TriggerClientEvent('okokBanking:updateTransactions', source, xPlayer.getAccount('bank').money, xPlayer.getMoney())
				TriggerClientEvent('midp-tasknotify:Alert', source, "You have transferred "..amount.."$ to "..targetName,  'success')

				MySQL.Async.execute('UPDATE users SET accounts = @playerAccount WHERE identifier = @target', {
					['@playerAccount'] = playerAccount,
					['@target'] = targetIdentifier
				}, function(changed)

				end)
			end
		else
			TriggerClientEvent('midp-tasknotify:Alert', source, "You don't have that much money on the bank",  'error')
		end
	else
		TriggerClientEvent('midp-tasknotify:Alert', source, "You can't send money to yourself",  'error')
	end
end)

RegisterServerEvent("okokBanking:DepositMoneyToSociety")
AddEventHandler("okokBanking:DepositMoneyToSociety", function(amount, society, societyName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getMoney()

	if amount <= playerMoney then
		MySQL.Async.execute('UPDATE okokBanking_societies SET value = value + @value WHERE society = @society AND society_name = @society_name', {
			['@value'] = amount,
			['@society'] = society,
			['@society_name'] = societyName,
		}, function(changed)
		end)
		xPlayer.removeAccountMoney('money', amount)

		TriggerEvent('okokBanking:AddDepositTransactionToSociety', amount, source, society, societyName)
		TriggerClientEvent('okokBanking:updateTransactionsSociety', source, xPlayer.getMoney())
		TriggerClientEvent('midp-tasknotify:Alert', source, "You have deposited "..amount.."$ to "..societyName,  'success')
	else
		TriggerClientEvent('midp-tasknotify:Alert', source, "You don't have that much money on you",  'error')
	end
end)

RegisterServerEvent("okokBanking:WithdrawMoneyToSociety")
AddEventHandler("okokBanking:WithdrawMoneyToSociety", function(amount, society, societyName, societyMoney)
	local xPlayer = ESX.GetPlayerFromId(source)
	local _source = source
	local db
	local hasChecked = false

	MySQL.Async.fetchAll('SELECT * FROM okokBanking_societies WHERE society = @society', {
		['@society'] = society
	}, function(result)
		db = result[1]
		hasChecked = true
	end)

	MySQL.Async.execute('UPDATE okokBanking_societies SET is_withdrawing = 1 WHERE society = @society AND society_name = @society_name', {
		['@value'] = amount,
		['@society'] = society,
		['@society_name'] = societyName,
	}, function(changed)
	end)

	while not hasChecked do 
		Citizen.Wait(100)
	end
	
	if amount <= db.value then
		if db.is_withdrawing == 1 then
			TriggerClientEvent('midp-tasknotify:Alert', _source, "Someone is already withdrawing",  'error')
		else

			MySQL.Async.execute('UPDATE okokBanking_societies SET value = value - @value WHERE society = @society AND society_name = @society_name', {
				['@value'] = amount,
				['@society'] = society,
				['@society_name'] = societyName,
			}, function(changed)
			end)
			
			xPlayer.addAccountMoney('money', amount)
			--xPlayer.addAccountMoney('bank', amount)
			TriggerEvent('okokBanking:AddWithdrawTransactionToSociety', amount, _source, society, societyName)
			TriggerClientEvent('okokBanking:updateTransactionsSociety', _source, xPlayer.getMoney())
			TriggerClientEvent('midp-tasknotify:Alert', _source, "You have withdrawn "..amount.."$ from "..societyName,  'success')
		end
	else
		TriggerClientEvent('midp-tasknotify:Alert', _source, "Your society doesn't have that much money on the bank",  'error')
	end

	MySQL.Async.execute('UPDATE okokBanking_societies SET is_withdrawing = 0 WHERE society = @society AND society_name = @society_name', {
		['@value'] = amount,
		['@society'] = society,
		['@society_name'] = societyName,
	}, function(changed)
	end)
end)

RegisterServerEvent("okokBanking:TransferMoneyToSociety")
AddEventHandler("okokBanking:TransferMoneyToSociety", function(amount, ibanNumber, societyName, society)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getAccount('bank').money

		if amount <= playerMoney then
			MySQL.Async.execute('UPDATE okokBanking_societies SET value = value + @value WHERE iban = @iban', {
				['@value'] = amount,
				['@iban'] = ibanNumber
			}, function(changed)
			end)
			xPlayer.removeAccountMoney('bank', amount)
			TriggerEvent('okokBanking:AddTransferTransactionToSociety', amount, source, society, societyName)
			TriggerClientEvent('okokBanking:updateTransactionsSociety', source, xPlayer.getMoney())
			TriggerClientEvent('midp-tasknotify:Alert', source, "You have transferred "..amount.."$ to "..societyName,  'success')
		else
			TriggerClientEvent('midp-tasknotify:Alert', source, "You don't have that much money on the bank",  'error')
		end
end)

RegisterServerEvent("okokBanking:TransferMoneyToSocietyFromSociety")
AddEventHandler("okokBanking:TransferMoneyToSocietyFromSociety", function(amount, ibanNumber, societyNameTarget, societyTarget, society, societyName, societyMoney)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromIdentifier(targetIdentifier)
	local xPlayers = ESX.GetPlayers()

	if amount <= societyMoney then
		MySQL.Async.execute('UPDATE okokBanking_societies SET value = value - @value WHERE society = @society AND society_name = @society_name', {
			['@value'] = amount,
			['@society'] = society,
			['@society_name'] = societyName,
		}, function(changed)
		end)
		MySQL.Async.execute('UPDATE okokBanking_societies SET value = value + @value WHERE society = @society AND society_name = @society_name', {
			['@value'] = amount,
			['@society'] = societyTarget,
			['@society_name'] = societyNameTarget,
		}, function(changed)
		end)
		TriggerEvent('okokBanking:AddTransferTransactionFromSociety', amount, society, societyName, societyTarget, societyNameTarget)
		TriggerClientEvent('okokBanking:updateTransactionsSociety', source, xPlayer.getMoney())
		TriggerClientEvent('midp-tasknotify:Alert', source, "You have transferred "..amount.."$ to "..societyNameTarget,  'success')
	else
		TriggerClientEvent('midp-tasknotify:Alert', source, "Your society doesn't have that much money on the bank",  'error')
	end
end)

RegisterServerEvent("okokBanking:TransferMoneyToPlayerFromSociety")
AddEventHandler("okokBanking:TransferMoneyToPlayerFromSociety", function(amount, ibanNumber, targetIdentifier, acc, targetName, society, societyName, societyMoney, toMyself)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromIdentifier(targetIdentifier)
	local xPlayers = ESX.GetPlayers()

	if amount <= societyMoney then
		MySQL.Async.execute('UPDATE okokBanking_societies SET value = value - @value WHERE society = @society AND society_name = @society_name', {
			['@value'] = amount,
			['@society'] = society,
			['@society_name'] = societyName,
		}, function(changed)
		end)
		if xTarget ~= nil then
			xTarget.addAccountMoney('bank', amount)
			if not toMyself then
				for i=1, #xPlayers, 1 do
				    local xForPlayer = ESX.GetPlayerFromId(xPlayers[i])
				    if xForPlayer.identifier == targetIdentifier then
				    	--TriggerClientEvent('okokBanking:updateMoney', xPlayers[i], xTarget.getAccount('bank').money)
			    	
			    		TriggerClientEvent('okokBanking:updateTransactions', xPlayers[i], xTarget.getAccount('bank').money, xTarget.getMoney())
			    		TriggerClientEvent('midp-tasknotify:Alert', xPlayers[i], "You have received "..amount.."$ from "..xPlayer.getName(),  'success')
				    end
				end
			end
			TriggerEvent('okokBanking:AddTransferTransactionFromSocietyToP', amount, society, societyName, targetIdentifier, targetName)
			TriggerClientEvent('okokBanking:updateTransactionsSociety', source, xPlayer.getMoney())
			TriggerClientEvent('midp-tasknotify:Alert', source, "You have transferred "..amount.."$ to "..xTarget.getName(),  'success')
		elseif xTarget == nil then
			local playerAccount = json.decode(acc)
			playerAccount.bank = playerAccount.bank + amount
			playerAccount = json.encode(playerAccount)

			--xPlayer.removeAccountMoney('bank', amount)

			--TriggerClientEvent('okokBanking:updateMoney', source, xPlayer.getAccount('bank').money)
			TriggerEvent('okokBanking:AddTransferTransactionFromSocietyToP', amount, society, societyName, targetIdentifier, targetName)
			TriggerClientEvent('okokBanking:updateTransactionsSociety', source, xPlayer.getMoney())
			TriggerClientEvent('midp-tasknotify:Alert', source, "You have transferred "..amount.."$ to "..targetName,  'success')

			MySQL.Async.execute('UPDATE users SET accounts = @playerAccount WHERE identifier = @target', {
				['@playerAccount'] = playerAccount,
				['@target'] = targetIdentifier
			}, function(changed)

			end)
		end
	else
		TriggerClientEvent('midp-tasknotify:Alert', source, "Your society doesn't have that much money on the bank",  'error')
	end
end)

ESX.RegisterServerCallback("okokBanking:GetOverviewTransactions", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerIdentifier = xPlayer.identifier
	local allDays = {}
	local income = 0
	local outcome = 0
	local totalIncome = 0
	local day1_total, day2_total, day3_total, day4_total, day5_total, day6_total, day7_total = 0, 0, 0, 0, 0, 0, 0

	MySQL.Async.fetchAll('SELECT * FROM okokBanking_transactions WHERE receiver_identifier = @identifier OR sender_identifier = @identifier ORDER BY id DESC', {
		['@identifier'] = playerIdentifier
	}, function(result)
		MySQL.Async.fetchAll('SELECT *, DATE(date) = CURDATE() AS "day1", DATE(date) = CURDATE() - INTERVAL 1 DAY AS "day2", DATE(date) = CURDATE() - INTERVAL 2 DAY AS "day3", DATE(date) = CURDATE() - INTERVAL 3 DAY AS "day4", DATE(date) = CURDATE() - INTERVAL 4 DAY AS "day5", DATE(date) = CURDATE() - INTERVAL 5 DAY AS "day6", DATE(date) = CURDATE() - INTERVAL 6 DAY AS "day7" FROM `okokBanking_transactions` WHERE DATE(date) >= CURDATE() - INTERVAL 7 DAY', {

		}, function(result2)
			for k, v in pairs(result2) do
				local type = v.type
				local receiver_identifier = v.receiver_identifier
				local sender_identifier = v.sender_identifier
				local value = tonumber(v.value)

				if v.day1 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day1_total = day1_total + value
							income = income + value
						elseif type == "withdraw" then
							day1_total = day1_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day1_total = day1_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day1_total = day1_total - value
							outcome = outcome - value
						end
					end
					
				elseif v.day2 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day2_total = day2_total + value
							income = income + value
						elseif type == "withdraw" then
							day2_total = day2_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day2_total = day2_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day2_total = day2_total - value
							outcome = outcome - value
						end
					end

				elseif v.day3 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day3_total = day3_total + value
							income = income + value
						elseif type == "withdraw" then
							day3_total = day3_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day3_total = day3_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day3_total = day3_total - value
							outcome = outcome - value
						end
					end

				elseif v.day4 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day4_total = day4_total + value
							income = income + value
						elseif type == "withdraw" then
							day4_total = day4_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day4_total = day4_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day4_total = day4_total - value
							outcome = outcome - value
						end
					end

				elseif v.day5 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day5_total = day5_total + value
							income = income + value
						elseif type == "withdraw" then
							day5_total = day5_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day5_total = day5_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day5_total = day5_total - value
							outcome = outcome - value
						end
					end

				elseif v.day6 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day6_total = day6_total + value
							income = income + value
						elseif type == "withdraw" then
							day6_total = day6_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day6_total = day6_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day6_total = day6_total - value
							outcome = outcome - value
						end
					end

				elseif v.day7 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day7_total = day7_total + value
							income = income + value
						elseif type == "withdraw" then
							day7_total = day7_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day7_total = day7_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day7_total = day7_total - value
							outcome = outcome - value
						end
					end

				end
			end

			totalIncome = day1_total + day2_total + day3_total + day4_total + day5_total + day6_total + day7_total

			table.remove(allDays)
			table.insert(allDays, day1_total)
			table.insert(allDays, day2_total)
			table.insert(allDays, day3_total)
			table.insert(allDays, day4_total)
			table.insert(allDays, day5_total)
			table.insert(allDays, day6_total)
			table.insert(allDays, day7_total)
			table.insert(allDays, income)
			table.insert(allDays, outcome)
			table.insert(allDays, totalIncome)

			cb(result, playerIdentifier, allDays)
		end)
	end)
end)

ESX.RegisterServerCallback("okokBanking:GetSocietyTransactions", function(source, cb, society)
	local playerIdentifier = society
	local allDays = {}
	local income = 0
	local outcome = 0
	local totalIncome = 0
	local day1_total, day2_total, day3_total, day4_total, day5_total, day6_total, day7_total = 0, 0, 0, 0, 0, 0, 0

	MySQL.Async.fetchAll('SELECT * FROM okokBanking_transactions WHERE receiver_identifier = @identifier OR sender_identifier = @identifier ORDER BY id DESC', {
		['@identifier'] = society
	}, function(result)
		MySQL.Async.fetchAll('SELECT *, DATE(date) = CURDATE() AS "day1", DATE(date) = CURDATE() - INTERVAL 1 DAY AS "day2", DATE(date) = CURDATE() - INTERVAL 2 DAY AS "day3", DATE(date) = CURDATE() - INTERVAL 3 DAY AS "day4", DATE(date) = CURDATE() - INTERVAL 4 DAY AS "day5", DATE(date) = CURDATE() - INTERVAL 5 DAY AS "day6", DATE(date) = CURDATE() - INTERVAL 6 DAY AS "day7" FROM `okokBanking_transactions` WHERE DATE(date) >= CURDATE() - INTERVAL 7 DAY AND receiver_identifier = @identifier OR sender_identifier = @identifier ORDER BY id DESC', {
			['@identifier'] = society
		}, function(result2)
			for k, v in pairs(result2) do
				local type = v.type
				local receiver_identifier = v.receiver_identifier
				local sender_identifier = v.sender_identifier
				local value = tonumber(v.value)

				if v.day1 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day1_total = day1_total + value
							income = income + value
						elseif type == "withdraw" then
							day1_total = day1_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day1_total = day1_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day1_total = day1_total - value
							outcome = outcome - value
						end
					end
					
				elseif v.day2 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day2_total = day2_total + value
							income = income + value
						elseif type == "withdraw" then
							day2_total = day2_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day2_total = day2_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day2_total = day2_total - value
							outcome = outcome - value
						end
					end

				elseif v.day3 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day3_total = day3_total + value
							income = income + value
						elseif type == "withdraw" then
							day3_total = day3_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day3_total = day3_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day3_total = day3_total - value
							outcome = outcome - value
						end
					end

				elseif v.day4 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day4_total = day4_total + value
							income = income + value
						elseif type == "withdraw" then
							day4_total = day4_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day4_total = day4_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day4_total = day4_total - value
							outcome = outcome - value
						end
					end

				elseif v.day5 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day5_total = day5_total + value
							income = income + value
						elseif type == "withdraw" then
							day5_total = day5_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day5_total = day5_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day5_total = day5_total - value
							outcome = outcome - value
						end
					end

				elseif v.day6 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day6_total = day6_total + value
							income = income + value
						elseif type == "withdraw" then
							day6_total = day6_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day6_total = day6_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day6_total = day6_total - value
							outcome = outcome - value
						end
					end

				elseif v.day7 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day7_total = day7_total + value
							income = income + value
						elseif type == "withdraw" then
							day7_total = day7_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day7_total = day7_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day7_total = day7_total - value
							outcome = outcome - value
						end
					end

				end
			end

			totalIncome = day1_total + day2_total + day3_total + day4_total + day5_total + day6_total + day7_total

			table.remove(allDays)
			table.insert(allDays, day1_total)
			table.insert(allDays, day2_total)
			table.insert(allDays, day3_total)
			table.insert(allDays, day4_total)
			table.insert(allDays, day5_total)
			table.insert(allDays, day6_total)
			table.insert(allDays, day7_total)
			table.insert(allDays, income)
			table.insert(allDays, outcome)
			table.insert(allDays, totalIncome)

			cb(result, playerIdentifier, allDays)
		end)
	end)
end)


RegisterServerEvent("okokBanking:AddDepositTransaction")
AddEventHandler("okokBanking:AddDepositTransaction", function(amount, source_)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.insert('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = 'bank',
		['@receiver_name'] = 'Bank Account',
		['@sender_identifier'] = tostring(xPlayer.identifier),
		['@sender_name'] = tostring(xPlayer.getName()),
		['@value'] = tonumber(amount),
		['@type'] = 'deposit'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:AddWithdrawTransaction")
AddEventHandler("okokBanking:AddWithdrawTransaction", function(amount, source_)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.insert('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = tostring(xPlayer.identifier),
		['@receiver_name'] = tostring(xPlayer.getName()),
		['@sender_identifier'] = 'bank',
		['@sender_name'] = 'Bank Account',
		['@value'] = tonumber(amount),
		['@type'] = 'withdraw'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:AddTransferTransaction")
AddEventHandler("okokBanking:AddTransferTransaction", function(amount, xTarget, source_, targetName, targetIdentifier)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = ESX.GetPlayerFromId(_source)
	if targetName == nil then
		MySQL.Async.insert('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
			['@receiver_identifier'] = tostring(xTarget.identifier),
			['@receiver_name'] = tostring(xTarget.getName()),
			['@sender_identifier'] = tostring(xPlayer.identifier),
			['@sender_name'] = tostring(xPlayer.getName()),
			['@value'] = tonumber(amount),
			['@type'] = 'transfer'
		}, function (result)
		end)
	elseif targetName ~= nil and targetIdentifier ~= nil then
		MySQL.Async.insert('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
			['@receiver_identifier'] = tostring(targetIdentifier),
			['@receiver_name'] = tostring(targetName),
			['@sender_identifier'] = tostring(xPlayer.identifier),
			['@sender_name'] = tostring(xPlayer.getName()),
			['@value'] = tonumber(amount),
			['@type'] = 'transfer'
		}, function (result)
		end)
	end
end)

RegisterServerEvent("okokBanking:AddTransferTransactionToSociety")
AddEventHandler("okokBanking:AddTransferTransactionToSociety", function(amount, source_, society, societyName)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.insert('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = society,
		['@receiver_name'] = societyName,
		['@sender_identifier'] = tostring(xPlayer.identifier),
		['@sender_name'] = tostring(xPlayer.getName()),
		['@value'] = tonumber(amount),
		['@type'] = 'transfer'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:AddTransferTransactionFromSocietyToP")
AddEventHandler("okokBanking:AddTransferTransactionFromSocietyToP", function(amount, society, societyName, identifier, name)

	MySQL.Async.insert('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = identifier,
		['@receiver_name'] = name,
		['@sender_identifier'] = society,
		['@sender_name'] = societyName,
		['@value'] = tonumber(amount),
		['@type'] = 'transfer'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:AddTransferTransactionFromSociety")
AddEventHandler("okokBanking:AddTransferTransactionFromSociety", function(amount, society, societyName, societyTarget, societyNameTarget)
	
	MySQL.Async.insert('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = societyTarget,
		['@receiver_name'] = societyNameTarget,
		['@sender_identifier'] = society,
		['@sender_name'] = societyName,
		['@value'] = tonumber(amount),
		['@type'] = 'transfer'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:AddDepositTransactionToSociety")
AddEventHandler("okokBanking:AddDepositTransactionToSociety", function(amount, source_, society, societyName)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.insert('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = society,
		['@receiver_name'] = societyName,
		['@sender_identifier'] = tostring(xPlayer.identifier),
		['@sender_name'] = tostring(xPlayer.getName()),
		['@value'] = tonumber(amount),
		['@type'] = 'deposit'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:AddWithdrawTransactionToSociety")
AddEventHandler("okokBanking:AddWithdrawTransactionToSociety", function(amount, source_, society, societyName)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.insert('INSERT INTO okokBanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = tostring(xPlayer.identifier),
		['@receiver_name'] = tostring(xPlayer.getName()),
		['@sender_identifier'] = society,
		['@sender_name'] = societyName,
		['@value'] = tonumber(amount),
		['@type'] = 'withdraw'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:UpdateIbanDB")
AddEventHandler("okokBanking:UpdateIbanDB", function(iban, amount)
	local xPlayer = ESX.GetPlayerFromId(source)

	if Banking.IBANChangeCost <= xPlayer.getAccount('bank').money then
		MySQL.Async.execute('UPDATE users SET iban = @iban WHERE identifier = @identifier', {
			['@iban'] = iban,
			['@identifier'] = xPlayer.identifier,
		}, function(changed)
		end)

		TriggerEvent('okokBanking:AddTransferTransactionToSociety', amount, source, "Bank (IBAN)")
		TriggerClientEvent('okokBanking:updateIban', source, iban)
		TriggerClientEvent('okokBanking:updateIbanPinChange', source)
		TriggerClientEvent('midp-tasknotify:Alert', source, "IBAN successfully changed to "..iban,  'success')
	else
		TriggerClientEvent('midp-tasknotify:Alert', source, "You need to have "..Banking.IBANChangeCost.."$ in order to change your IBAN",  'error')
	end
end)

RegisterServerEvent("okokBanking:UpdatePINDB")
AddEventHandler("okokBanking:UpdatePINDB", function(pin, amount)
	local xPlayer = ESX.GetPlayerFromId(source)

	if Banking.PINChangeCost <= xPlayer.getAccount('bank').money then
		MySQL.Async.execute('UPDATE users SET pincode = @pin WHERE identifier = @identifier', {
			['@pin'] = pin,
			['@identifier'] = xPlayer.identifier,
		}, function(changed)
		end)

		TriggerEvent('okokBanking:AddTransferTransactionToSociety', amount, source, "Bank (PIN)")
		TriggerClientEvent('okokBanking:updateIbanPinChange', source)
		TriggerClientEvent('midp-tasknotify:Alert', source, "PIN successfully changed to "..pin,  'success')
	else
		TriggerClientEvent('midp-tasknotify:Alert', source, "You need to have "..Banking.PINChangeCost.."$ in order to change your PIN", 'error')
	end
end)


RegisterServerEvent('midp-tasknotify:Alert')
AddEventHandler('midp-tasknotify:Alert', function(text, type)
	TriggerClientEvent('midp-tasknotify:client:DoHudText', source, { type = type, text = text } )
end)