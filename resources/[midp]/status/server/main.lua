local function setPlayerStatus(xPlayer, data)
	data = data and json.decode(data) or {}

	xPlayer.set('status', data)
	TriggerClientEvent('esx_status:load', xPlayer.source, data)
end

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  	return
	end

	local xPlayers = ESX.GetExtendedPlayers()
	for i = 1, #(xPlayers) do
		local xPlayer = xPlayers[i]

		MySQL.scalar('SELECT status FROM users WHERE identifier = ?', { xPlayer.identifier }, function(result)
			setPlayerStatus(xPlayer, result)
		end)
	end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	MySQL.scalar('SELECT status FROM users WHERE identifier = ?', { xPlayer.identifier }, function(result)
		setPlayerStatus(xPlayer, result)
	end)
end)

--[[
AddEventHandler('esx:playerDropped', function(playerId, reason)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local status = xPlayer.get('status')

	MySQL.update('UPDATE users SET status = ? WHERE identifier = ?', { json.encode(status), xPlayer.identifier })
end)
]]

AddEventHandler('esx_status:getStatus', function(playerId, statusName, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local status  = xPlayer.get('status')

	for i=1, #status, 1 do
		if status[i].name == statusName then
			return cb(status[i])
		end
	end
end)

RegisterServerEvent('esx_status:update', function(status)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		xPlayer.set('status', status)	-- save to xPlayer for compatibility
	end
end)