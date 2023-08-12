
local Webhook = 'https://discord.com/api/webhooks/1035799584837996606/tge4fKIvCB_4ncTj-YG2FL0fNND6IRdSwfAsiVdMZfOVEUo-orMKTazgEX3WTxv3eSvk'

RegisterServerEvent('okokContract:changeVehicleOwner')
AddEventHandler('okokContract:changeVehicleOwner', function(data)
	_source = data.sourceIDSeller
	target = data.targetIDSeller
	plate = data.plateNumberSeller
	model = data.modelSeller
	source_name = data.sourceNameSeller
	target_name = data.targetNameSeller
	vehicle_price = tonumber(data.vehicle_price)

	local xPlayer = ESX.GetPlayerFromId(_source)
	local tPlayer = ESX.GetPlayerFromId(target)
	local webhookData = {
		model = model,
		plate = plate,
		target_name = target_name,
		source_name = source_name,
		vehicle_price = vehicle_price
	}
	local result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier AND plate = @plate', {
		['@identifier'] = xPlayer.identifier,
		['@plate'] = plate
	})

	if Kontraksu.RemoveMoneyOnSign then
		local bankMoney = tPlayer.getAccount('money').money

		if result[1] ~= nil  then
			if bankMoney >= vehicle_price then
				MySQL.Async.execute('UPDATE owned_vehicles SET owner = @target WHERE owner = @owner AND plate = @plate', {
					['@owner'] = xPlayer.identifier,
					['@target'] = tPlayer.identifier,
					['@plate'] = plate
				}, function (result2)
					if result2 ~= 0 then	
						tPlayer.removeAccountMoney('money', vehicle_price)
						xPlayer.addAccountMoney('money', vehicle_price)

						TriggerClientEvent('midp-tasknotify:client:SendAlert', -1, { type = 'inform', text = "" ..plate.. ' - MILIK ' ..source_name.. " TERJUAL KE ".. target_name.. '', length = 10000 })
						TriggerClientEvent('midp-tasknotify:Alert', _source, "VEHICLE", "Anda Berhasil Menjual Kendaraan <b>"..model.."</b> Plat: <b>"..plate.."</b>", 10000, 'success')
						TriggerClientEvent('midp-tasknotify:Alert', target, "VEHICLE", "Anda Menerima Kendaraan <b>"..model.."</b> Plat: <b>"..plate.."</b>", 10000, 'success')

						if Webhook ~= '' then
							sellVehicleWebhook(webhookData)
						end
					end
				end)
			else
				TriggerClientEvent('midp-tasknotify:Alert', _source, "VEHICLE", target_name.." Uangnya Tidak Cukup", 10000, 'error')
				TriggerClientEvent('midp-tasknotify:Alert', target, "VEHICLE", "Anda tidak punya cukup uang untuk membeli: "..source_name.."'s vehicle", 10000, 'error')
			end
		else
			TriggerClientEvent('midp-tasknotify:Alert', _source, "VEHICLE", "Kendaraan: <b>"..plate.."</b> Bukan Milikmu!", 10000, 'error')
			TriggerClientEvent('midp-tasknotify:Alert', target, "VEHICLE", source_name.." Mencoba Menjual Kendaraan Yang Bukan Miliknya", 10000, 'error')
		end
	else
		if result[1] ~= nil then
			MySQL.Async.execute('UPDATE owned_vehicles SET owner = @target WHERE owner = @owner AND plate = @plate', {
				['@owner'] = xPlayer.identifier,
				['@target'] = tPlayer.identifier,
				['@plate'] = plate
			}, function (result2)
				if result2 ~= 0 then
					TriggerClientEvent('midp-tasknotify:Alert', _source, "VEHICLE", "Berhasil Menjual Kendaraan: <b>"..model.."</b> Plat: <b>"..plate.."</b>", 10000, 'success')
					TriggerClientEvent('midp-tasknotify:Alert', target, "VEHICLE", "Mendapat Kendaran: <b>"..model.."</b>Plat: <b>"..plate.."</b>", 10000, 'success')

					if Webhook ~= '' then
						sellVehicleWebhook(webhookData)
					end
				end
			end)
		else
			TriggerClientEvent('midp-tasknotify:Alert', _source, "VEHICLE", "Kendaraan: <b>"..plate.."</b> Bukan Milikmu!", 10000, 'error')
			TriggerClientEvent('midp-tasknotify:Alert', target, "VEHICLE", source_name.." Mencoba Menjual Kendaraan Yang Bukan Miliknya", 10000, 'error')
		end
	end
end)

ESX.RegisterServerCallback('okokContract:GetTargetName', function(source, cb, targetid)
	local target = ESX.GetPlayerFromId(targetid)
	local targetname = target.getName()

	cb(targetname)
end)

RegisterServerEvent('okokContract:SendVehicleInfo')
AddEventHandler('okokContract:SendVehicleInfo', function(description, price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent('okokContract:GetVehicleInfo', _source, xPlayer.getName(), os.date(Kontraksu.DateFormat), description, price, _source)
end)

RegisterServerEvent('okokContract:SendContractToBuyer')
AddEventHandler('okokContract:SendContractToBuyer', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent("okokContract:OpenContractOnBuyer", data.targetID, data)
	TriggerClientEvent('okokContract:startContractAnimation', data.targetID)

	if Kontraksu.RemoveContractAfterUse then
		xPlayer.removeInventoryItem('contract', 1)
	end
end)

ESX.RegisterUsableItem('contract', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent('okokContract:OpenContractInfo', _source)
	TriggerClientEvent('okokContract:startContractAnimation', _source)
end)

function sellVehicleWebhook(data)
	local information = {
		{
			["color"] = Kontraksu.sellVehicleWebhookColor,
			["author"] = {
				["icon_url"] = Kontraksu.IconURL,
				["name"] = Kontraksu.ServerName,
			},
			["title"] = 'JUAL-BELI KENDARAAN',
			["description"] = '**Kendaraan: **'..data.model..'**\nPlat: **'..data.plate..'**\nNama Pembeli: **'..data.target_name..'**\nNama penjual: **'..data.source_name..'**\nHarga: $DL**'..data.vehicle_price..'',

			["footer"] = {
				["text"] = os.date(Kontraksu.WebhookDateFormat),
			}
		}
	}
	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = Kontraksu.BotName, embeds = information}), {['Content-Type'] = 'application/json'})
end