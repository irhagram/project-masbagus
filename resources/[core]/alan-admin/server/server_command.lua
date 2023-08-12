ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local onTimer       = {}
local savedCoords   = {}
local warnedPlayers = {}
local deadPlayers   = {}

---------- Bring / Bringback ----------
RegisterCommand("bring", function(source, args, rawCommand)	-- /bring [ID]
	if source ~= 0 then
	  	local xPlayer = ESX.GetPlayerFromId(source)
	  	if havePermission(xPlayer) then
	    	if args[1] and tonumber(args[1]) then
	      		local targetId = tonumber(args[1])
	      		local xTarget = ESX.GetPlayerFromId(targetId)
	      		if xTarget then
	        		local targetCoords = xTarget.getCoords()
	        		local playerCoords = xPlayer.getCoords()
	        		savedCoords[targetId] = targetCoords
	        		xTarget.setCoords(playerCoords)
	        		--TriggerClientEvent("chatMessage", xPlayer.source, _U('bring_adminside', args[1]))
	        		TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Berhasil'})
	      		else
	        		TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Berhasil'})
	      		end
	    	else
				TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Input yang bener!'})
	    	end
	  	end
	end
end, false)

RegisterCommand("bringback", function(source, args, rawCommand)	-- /bringback [ID] will teleport player back where he was before /bring
	if source ~= 0 then
  		local xPlayer = ESX.GetPlayerFromId(source)
  		if havePermission(xPlayer) then
    		if args[1] and tonumber(args[1]) then
      			local targetId = tonumber(args[1])
      			local xTarget = ESX.GetPlayerFromId(targetId)
      			if xTarget then
        			local playerCoords = savedCoords[targetId]
        			if playerCoords then
          			xTarget.setCoords(playerCoords)
          			--TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Berhasil'})
          			TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Berhasil'})
          			savedCoords[targetId] = nil
        		else
					TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Berhasil'})
        			end
      			else
        			TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Berhasil'})
      			end
    		else
				TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Input yang bener!'})
    		end
  		end
	end
end, false)

---------- goto/goback ----------
RegisterCommand("goto", function(source, args, rawCommand)	-- /goto [ID]
	if source ~= 0 then
  		local xPlayer = ESX.GetPlayerFromId(source)
  		if havePermission(xPlayer) then
    		if args[1] and tonumber(args[1]) then
      			local targetId = tonumber(args[1])
      			local xTarget = ESX.GetPlayerFromId(targetId)
      			if xTarget then
        			local targetCoords = xTarget.getCoords()
        			local playerCoords = xPlayer.getCoords()
        			savedCoords[source] = playerCoords
        			xPlayer.setCoords(targetCoords)
        			--TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Berhasil'})
					TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Berhasil'})
      			else
        			TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Berhasil'})
      			end
    		else
				TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Input yang bener!'})
    		end
  		end
	end
end, false)

RegisterCommand("goback", function(source, args, rawCommand)	-- /goback will teleport you back where you was befor /goto
	if source ~= 0 then
	  	local xPlayer = ESX.GetPlayerFromId(source)
	  	if havePermission(xPlayer) then
	    	local playerCoords = savedCoords[source]
	    	if playerCoords then
	      		xPlayer.setCoords(playerCoords)
				  TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Berhasil'})
	      		savedCoords[source] = nil
	    	else
				TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Input yang bener!'})
	    	end
	  	end
	end
end, false)

---------- Noclip --------
RegisterCommand("noclip", function(source, args, rawCommand)	-- /goback will teleport you back where you was befor /goto
	if source ~= 0 then
	  	local xPlayer = ESX.GetPlayerFromId(source)
	  	if havePermission(xPlayer) then
	    	TriggerClientEvent("alan-admin:noclip", xPlayer.source)
	  	end
	end
end, false)
---------- Noclip2 --------
RegisterCommand("noclippla", function(source, args, rawCommand)	-- /noclip2 [ID]
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if havePermission(xPlayer) then
			if args[1] and tonumber(args[1]) then
				local targetId = tonumber(args[1])
      			local xTarget = ESX.GetPlayerFromId(targetId)
      			if xTarget then
					TriggerClientEvent("alan-admin:noclip", xTarget.source)
      			else
        			TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'KILL'))
      			end
    		else
      			TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'KILL'))
    		end
  		end
	end
end, false)
-- To Marker
RegisterCommand("tomarker", function(source, args, rawCommand)	-- /tomarker [ID]
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if havePermission(xPlayer) then
			if args[1] and tonumber(args[1]) then
				local targetId = tonumber(args[1])
      			local xTarget = ESX.GetPlayerFromId(targetId)
      			if xTarget then
					TriggerClientEvent("alan-admin:teleportUser", xTarget.source)
      			else
        			TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'KILL'))
      			end
    		else
				TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Input yang bener!'})
    		end
  		end
	end
end, false)
---------- Refresh --------
RegisterCommand("refreshplayer", function(source, args, rawCommand)	-- /refreshplayer [ID]
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if havePermission(xPlayer) then
			if args[1] and tonumber(args[1]) then
				local targetId = tonumber(args[1])
      			local xTarget = ESX.GetPlayerFromId(targetId)
      			if xTarget then
					TriggerClientEvent("alan-admin:RefreshPlayer", xTarget.source)
      			else
        			TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'KILL'))
      			end
    		else
      			TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'KILL'))
    		end
  		end
	end
end, false)
RegisterCommand("report", function(source, args, rawCommand)	-- /report [MESSAGE]		send report message to all online admins
	local xPlayer = ESX.GetPlayerFromId(source)
  if args[1] then
	  local message = string.sub(rawCommand, 8)
	  local xAll = ESX.GetPlayers()
	  for i=1, #xAll, 1 do
			local xTarget = ESX.GetPlayerFromId(xAll[i])
			if havePermission(xTarget) then		-- you can exclude some ranks to NOT reciveing reports
			  if xPlayer.source ~= xTarget.source then
				  TriggerClientEvent('chat:addMessage',xTarget.source, {
					  template = '<div class="chat-message-rep"><b>REPORT | {0} | {1} :</b> {2}</b></div>',
					  args = { xPlayer.source,GetPlayerName(source), message }
				  })
			  end
			end
	  end
	  TriggerClientEvent('chat:addMessage',xPlayer.source, {
		  template = '<div class="chat-message-rep"><b>REPORT | {0} | {1} :</b> {2}</b></div>',
		  args = { xPlayer.source,GetPlayerName(source), message }
	  })
  else
	  TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Input yang bener!'})
  end
end, false)

--[[ RegisterCommand("r", function(source, args, rawCommand)	
  local xPlayer = ESX.GetPlayerFromId(source)
  if args[1] and args[2] then
	  local message = string.sub(rawCommand, 5)
	  local xPlayer = ESX.GetPlayerFromId(source)
	  if havePermission(xPlayer) then
		  TriggerClientEvent('chat:addMessage',args[1], {
			  template = '<div class="chat-message-rep"><b>ADMIN | {0}:</b> {1}</b></div>',
			  args = { GetPlayerName(source), message }
		  })
		  TriggerClientEvent('chat:addMessage',xPlayer.source, {
			  template = '<div class="chat-message-rep"><b>ADMIN | {0}:</b> {1}</b></div>',
			  args = { GetPlayerName(source), message }
		  })
	  end
  else
	  TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Input yang bener!'})
  end
end, false) ]]

AddEventHandler('chatMessage', function(source, color, msg)
	local xPlayer = ESX.GetPlayerFromId(source)
	cm = stringsplit(msg, " ")
	if cm[1] == "/reply" or cm[1] == "/rr" or cm[1] == "/r" then
		CancelEvent()
		if tablelength(cm) > 1 then
			local tPID = tonumber(cm[2])
			local names2 = GetPlayerName(tPID)
			local names3 = GetPlayerName(source)
			local textmsg = ""
			for i=1, #cm do
				if i ~= 1 and i ~=2 then
					textmsg = (textmsg .. " " .. tostring(cm[i]))
				end
			end
			local playerGroup = xPlayer.getGroup()
		    if playerGroup ~= 'user' or playerGroup ~= 'superadmin' or playerGroup ~= 'admin' then
			    TriggerClientEvent('textmsg', tPID, source, textmsg, names2, names3)
			    TriggerClientEvent('textsent', source, tPID, names2, names3, textmsg)
			else
			    TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Tidak ada aksess'})
			end
		end
	end	
end)

---------- Troll --------
RegisterCommand("trollfbi", function(source, args, rawCommand)	-- /troll [ID]
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if havePermission(xPlayer) then
			if args[1] and tonumber(args[1]) then
				local targetId = tonumber(args[1])
      			local xTarget = ESX.GetPlayerFromId(targetId)
      			if xTarget then
					--TriggerClientEvent("alan-admin:spawnmacan", xTarget.source)
					TriggerClientEvent("alan-admin:spawnswat", xTarget.source)
      			else
        			TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'KILL'))
      			end
    		else
      			TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'KILL'))
    		end
  		end
	end
end, false)

RegisterCommand("trollmacan", function(source, args, rawCommand)	-- /troll [ID]
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if havePermission(xPlayer) then
			if args[1] and tonumber(args[1]) then
				local targetId = tonumber(args[1])
      			local xTarget = ESX.GetPlayerFromId(targetId)
      			if xTarget then
					TriggerClientEvent("alan-admin:spawnmacan", xTarget.source)
					--TriggerClientEvent("alan-admin:spawnswat", xTarget.source)
      			else
        			TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'KILL'))
      			end
    		else
      			TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'KILL'))
    		end
  		end
	end
end, false)
---------- dv2 --------
RegisterCommand("dv2", function(source, args, rawCommand)	-- /dv2 [ID]
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if havePermission(xPlayer) then
			if args[1] and tonumber(args[1]) then
				local targetId = tonumber(args[1])
      			local xTarget = ESX.GetPlayerFromId(targetId)
      			if xTarget then
					TriggerClientEvent("alan-admin:deleteVehiclee", xTarget.source)
      			else
        			TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'KILL'))
      			end
    		else
      			TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'KILL'))
    		end
  		end
	end
end, false)
---------- kill ----------
RegisterCommand("kill", function(source, args, rawCommand)	-- /kill [ID]
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if havePermission(xPlayer) then
			if args[1] and tonumber(args[1]) then
				local targetId = tonumber(args[1])
      			local xTarget = ESX.GetPlayerFromId(targetId)
      			if xTarget then
					TriggerClientEvent("alan-admin:killPlayer", xTarget.source)
      			else
        			TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'KILL'))
      			end
    		else
      			TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'KILL'))
    		end
  		end
	end
end, false)
---------- slap ----------
RegisterCommand("slap", function(source, args, rawCommand)	-- /kill [ID]
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if havePermission(xPlayer) then
			if args[1] and tonumber(args[1]) then
				local targetId = tonumber(args[1])
      			local xTarget = ESX.GetPlayerFromId(targetId)
      			if xTarget then
					TriggerClientEvent("alan-admin:slapplayer", xTarget.source)
      			else
        			TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'KILL'))
      			end
    		else
      			TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'KILL'))
    		end
  		end
	end
end, false)
---------- fly ----------
RegisterCommand("fly", function(source, args, rawCommand)	-- /fly [ID]
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if havePermission(xPlayer) then
			if args[1] and tonumber(args[1]) then
				local targetId = tonumber(args[1])
      			local xTarget = ESX.GetPlayerFromId(targetId)
      			if xTarget then
					TriggerClientEvent("alan-admin:flyplayer", xTarget.source)
      			else
        			TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'KILL'))
      			end
    		else
      			TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'KILL'))
    		end
  		end
	end
end, false)
---------- freeze ----------
RegisterCommand("freeze", function(source, args, rawCommand)	-- /kill [ID]
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if havePermission(xPlayer) then
			if args[1] and tonumber(args[1]) then
				local targetId = tonumber(args[1])
      			local xTarget = ESX.GetPlayerFromId(targetId)
      			if xTarget then
					TriggerClientEvent("alan-admin:freezeplayer", xTarget.source)
      			else
        			TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'KILL'))
      			end
    		else
      			TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'KILL'))
    		end
  		end
	end
end, false)
---------- kick all ----------
RegisterCommand('kickallcmd', function(source, args, rawCommand)
    kickPl()
end, true)

function kickPl ()
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        xPlayer.kick("SERVER RESTART")
    end
end
---------- spawnobj ----------
RegisterCommand("spawnobj", function(source, args, rawCommand)	-- /kill [ID]
	local xPlayer = ESX.GetPlayerFromId(source)
	if havePermission(xPlayer) then
		TriggerClientEvent("alan-admin:spawnobj",source ,args[1])
	end
end, false)
---------- reviveall ----------
RegisterCommand("reviveall", function(source, args, rawCommand)	-- reviveall (can be used from console)
	canRevive = false
	if source == 0 then
		canRevive = true
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if havePermission(xPlayer) then
			canRevive = true
		end
	end
	if canRevive then
		for i,data in pairs(deadPlayers) do
			TriggerClientEvent('esx_ambulancejob:revive', i)
		end
	end
end, false)

------------ functions and events ------------
RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	deadPlayers[source] = data
end)

RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
	if deadPlayers[source] then
		deadPlayers[source] = nil
	end
end)

RegisterServerEvent("alan-admin:kickall")
AddEventHandler('alan-admin:kickall', function()
	kickPl()
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	-- empty tables when player no longer online
	if onTimer[playerId] then
		onTimer[playerId] = nil
	end
    if savedCoords[playerId] then
    	savedCoords[playerId] = nil
    end
	if warnedPlayers[playerId] then
		warnedPlayers[playerId] = nil
	end
	if deadPlayers[playerId] then
		deadPlayers[playerId] = nil
	end
end)

function havePermission(xPlayer, exclude)	-- you can exclude rank(s) from having permission to specific commands 	[exclude only take tables]
	if exclude and type(exclude) ~= 'table' then exclude = nil;print("^3[alan-admin] ^1ERROR ^0exclude argument is not table..^0") end	-- will prevent from errors if you pass wrong argument

	local playerGroup = xPlayer.getGroup()
	for k,v in pairs(Config.adminRanks) do
		if v == playerGroup then
			if not exclude then
				return true
			else
				for a,b in pairs(exclude) do
					if b == v then
						return false
					end
				end
				return true
			end
		end
	end
	return false
end

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			name = identity['name'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height'],
			job = identity['job'],
			group = identity['group']
		}
	else
		return nil
	end
end