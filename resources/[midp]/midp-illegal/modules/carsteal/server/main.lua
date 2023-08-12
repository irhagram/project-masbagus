
local activity = 0
local activitySource = 0
local cooldown = 0

RegisterServerEvent('alan-carsteal:pay')
AddEventHandler('alan-carsteal:pay', function(payment, token)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	xPlayer.addAccountMoney('black_money',tonumber(payment))
	cooldown = CarSteal.CooldownMinutes * 60000
end)

ESX.RegisterServerCallback('alan-carsteal:anycops',function(source, cb)
	local anycops = 0
	local playerList = ESX.GetPlayers()
	for i=1, #playerList, 1 do
		local src = playerList[i]
		local xPlayer = ESX.GetPlayerFromId(src)
		local playerjob = xPlayer.job.name
		if playerjob == 'police' then
		anycops = anycops + 1
		end
	end
	cb(anycops)
end)

ESX.RegisterServerCallback('alan-carsteal:ambulance',function(source, cb)
	local anyems = 0
	local playerList = ESX.GetPlayers()
	for i=1, #playerList, 1 do
		local src = playerList[i]
		local xPlayer = ESX.GetPlayerFromId(src)
		local playerjob = xPlayer.job.name
		if playerjob == 'ambulance' then
			anyems = anyems + 1
		end
	end
	cb(anyems)
end)

ESX.RegisterServerCallback('midp-illegal:isAktif',function(source, cb)
  cb(activity, cooldown)
end)

RegisterServerEvent('midp-illegal:aktifYaBund')
AddEventHandler('midp-illegal:aktifYaBund', function(value)
	activity = value
	if value == 1 then
		activitySource = source
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				TriggerClientEvent('alan-carsteal:setcopnotification', xPlayers[i])
			end
		end
	else
		activitySource = 0
	end
end)

RegisterServerEvent('alan-carsteal:alertcops')
AddEventHandler('alan-carsteal:alertcops', function(cx,cy,cz)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('alan-carsteal:setcopblip', xPlayers[i], cx,cy,cz)
		end
	end
end)

RegisterServerEvent('alan-carsteal:berital')
AddEventHandler('alan-carsteal:berital', function()
	message = 'TELAH TERJADI PERAMPOKAN KENDARAAN BERLIAN HARAP WARGA MENJAUH DARI LOKASI PERAMPOKAN'
	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div class="chat-message-rob"><b><span style="color: #ffffff">BERITA: </span>&nbsp;<span style="font-size: 14px; color: #ffffff;">' ..message.. '</span></b></div>',
		args = { fal, msg }
	}) 
end)

RegisterServerEvent('alan-carsteal:stopalertcops')
AddEventHandler('alan-carsteal:stopalertcops', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('alan-carsteal:removecopblip', xPlayers[i])
		end
	end
end)

AddEventHandler('playerDropped', function ()
	local src = source
	if src == activitySource then
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				TriggerClientEvent('alan-carsteal:removecopblip', xPlayers[i])
			end
		end
		activity = 0
		activitySource = 0
	end
end)

AddEventHandler('onResourceStart', function(resource)
	while true do
		Wait(5000)
		if cooldown > 0 then
			cooldown = cooldown - 5000
		end
	end
end)