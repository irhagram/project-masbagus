local rob = false
local robbers = {}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_holdup:tooFar')
AddEventHandler('esx_holdup:tooFar', function(currentStore)
	local _source = source
	local xPlayers = ESX.GetPlayers()
	rob = false

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('notification', xPlayers[i], _U('robbery_cancelled_at', Stores[currentStore].nameOfStore), 2)
			TriggerClientEvent('esx_holdup:killBlip', xPlayers[i])
		end
		TriggerClientEvent('esx_holdup:killBlip', -1)
	end

	if robbers[_source] then
		TriggerClientEvent('esx_holdup:tooFar', _source)
		robbers[_source] = nil
		TriggerClientEvent('Notification', _source, _U('robbery_cancelled_at', Stores[currentStore].nameOfStore), 2)
		TriggerClientEvent('esx_holdup:killBlip', _source)
	end
end)

RegisterServerEvent('esx_holdup:robberyStarted')
AddEventHandler('esx_holdup:robberyStarted', function(currentStore)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	local CaroToolQuantity = xPlayer.getInventoryItem('lockpick').count
		--[[xPlayer.removeInventoryItem('lockpick', 1)
		TriggerEvent('esx_holdup:robberyStarted', _source)
	end]]

	if Stores[currentStore] then
		local store = Stores[currentStore]

		if (os.time() - store.lastRobbed) < Config.TimerBeforeNewRob and store.lastRobbed ~= 0 then
			--TriggerClientEvent('esx:showNotification', _source, _U('recently_robbed', Config.TimerBeforeNewRob - (os.time() - store.lastRobbed)))
			TriggerClientEvent('notification', _source, _U('recently_robbed', Config.TimerBeforeNewRob - (os.time() - store.lastRobbed)), 2)
			--TriggerClientEvent('mhacking:hide')
			return
		end

		local cops = 0
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				cops = cops + 1
			end
		end

		if not rob then
			if cops >= store.NumberOfCopsRequired then

					rob = true

					for i=1, #xPlayers, 1 do
						local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
						if xPlayer.job.name == 'police' or 'ambulance' then
							TriggerClientEvent('esx_holdup:setBlip', xPlayers[i], Stores[currentStore].position)
						end
					end

					TriggerClientEvent('notification', _source, _U('alarm_triggered'), 2)
					--xPlayer.removeInventoryItem('raspberry', 1)

					TriggerClientEvent('chat:addMessage', -1, {
						template = '<div class="chat-message-rob"><b>{0}</b>{1}</div>',
						args = { "BERITA : ", "TERJADI PERAMPOKAN DI " .. store.nameOfStore }
					})

					local date = os.date('*t')
				
					if date.month < 10 then date.month = '0' .. tostring(date.month) end
					if date.day < 10 then date.day = '0' .. tostring(date.day) end
					if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
					if date.min < 10 then date.min = '0' .. tostring(date.min) end
					if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	
					local name = GetPlayerName(source)
					local steamhex = GetPlayerIdentifier(source)
	
					sendToDiscord1('', '```' .. store.nameOfStore ..' / ' .. name .. '[' .. steamhex .. ']`````'.. date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec ..  '``')
	
					
					TriggerClientEvent('esx_holdup:currentlyRobbing', _source, currentStore)
					TriggerClientEvent('esx_holdup:startTimer', _source)
					
					Stores[currentStore].lastRobbed = os.time()
					robbers[_source] = currentStore

					SetTimeout(store.secondsRemaining * 1000, function()
						if robbers[_source] then
							rob = false
							if xPlayer then
								TriggerClientEvent('esx_holdup:robberyComplete', _source, store.reward)
								

								if Config.GiveBlackMoney then
									xPlayer.addAccountMoney('black_money', store.reward)
								else
									xPlayer.addMoney(store.reward)
								end
								
								local xPlayers, xPlayer = ESX.GetPlayers(), nil
								for i=1, #xPlayers, 1 do
									xPlayer = ESX.GetPlayerFromId(xPlayers[i])

									if xPlayer.job.name == 'police' then
										TriggerClientEvent('notification', xPlayers[i], _U('robbery_complete_at', store.nameOfStore), 1)
										TriggerClientEvent('esx_holdup:killBlip', xPlayers[i])
									end
									TriggerClientEvent('esx_holdup:killBlip', -1)
								end
							
							end
						end
					end)
				--end
			else
				--TriggerClientEvent('esx:showNotification', _source, _U('min_police', Config.PoliceNumberRequired))
				TriggerClientEvent('notification', _source, _U('min_police', Config.NumberOfCopsRequired), 2)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('robbery_already'))
		end
	end
end)


ESX.RegisterServerCallback('dl-storob:hack', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local quantity = xPlayer.getInventoryItem('lockpick').count
	
	cb(quantity)
end)


function sendToDiscord1 (name,message,color)
	local DiscordWebHook = "https://discord.com/api/webhooks/1055735530714845184/9NYwSPmfiGesEFQv46VIca2Q9CN6rfgKN0Ima3XinGaXp3oayGNDc8HeFQCzVnNj9VH2"
	-- Modify here your discordWebHook username = name, content = message,embeds = embeds
  
	local embeds = {
		{
			["title"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
				["text"]= "",
			},
		}
	}
  
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,content = message}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('lockpick:openhtml')
AddEventHandler('lockpick:openhtml', function()
	TriggerClientEvent('lockpick:openlockpick', source)
end)

RegisterNetEvent('dl-storob:delay')
AddEventHandler('dl-storob:delay', function()
	TriggerClientEvent('dl-storob:opendelay', -1)
end)

RegisterNetEvent('dl-storob:item')
AddEventHandler('dl-storob:item', function()
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('lockpick', 1)
end)