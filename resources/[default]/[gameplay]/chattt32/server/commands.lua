--ESX = nil 

local oocdelay = {}
--local emsdelay = {}

--TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('clear', function(source, args, rawCommand)
    TriggerClientEvent('chat:client:ClearChat', source)
end, false)

RegisterCommand('ooc', function(source, args, rawCommand)
    if oocdelay[source] == nil then
        oocdelay[source] = 0
    end
    local xPlayer = ESX.GetPlayerFromId(source)
    local src = source
    local msg = rawCommand:sub(4)
    if GetGameTimer() - oocdelay[source] > 60000 or xPlayer:getGroup() == 'superadmin' or xPlayer:getGroup() == 'admin' then
        if player ~= false then
            local user = GetPlayerName(src)
                TriggerClientEvent('chat:addMessage', -1, {
                    template = '<div class="chat-message-ooc"><b>{0} {1}: </b>{2}</div>',
                    args = { "OOC | " ..source.. " |", user, msg }
            })
            oocdelay[source] = GetGameTimer()
        end
    else
        TriggerClientEvent('alan-tasknotify:Alert', source, "INFO", "Kamu telah menggunakan OOC CHAT 1 menit sebelumnya, kamu harus menunggu", 5000, 'error')
    end
end, false)

--[[RegisterCommand('119', function(source, args, rawCommand)
    if emsdelay[source] == nil then
        emsdelay[source] = 0
    end
    local xPlayers = ESX.GetPlayerFromId(rawCommand)
    local src = source
    local msg = rawCommand:sub(4)
    local user = GetPlayerName(src)
    if GetGameTimer() - emsdelay[source] > 300000 then
        if player ~= false then
            for i=1, #xPlayers, 1 do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                
                if xPlayer.job.name == 'ambulance' then
                    TriggerClientEvent('chat:addMessage', xPlayer.source, {
                        template = '<div class="chat-message-jel"><b>199 | {0}:</b> {1}</div>',
                        args = { user, msg }
                    })
                end
            end
            emsdelay[source] = GetGameTimer()
        end
    else

        TriggerClientEvent('alan-tasknotify:Alert', source, "INFO", "Kamu telah menggunakan 119 CHAT 5 menit sebelumnya, kamu harus menunggu", 5000, 'error')
    end
end, false)]]

RegisterCommand('iklan', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(6)
    if player ~= false then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getMoney() >= 10000 then
            local name = GetCharacterName(src)
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-ad"><b>IKLAN | {0}:</b> {1}</div>',
                args = { name, msg }
            })
            xPlayer.removeMoney(10000)
        else
            TriggerClientEvent('alan-tasknotify:Alert', source, "INFO", "Tidak Cukup Uang Untuk Memasang Iklan", 5000, 'error')
        end
    end
end, false)

RegisterCommand('pol', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    if player ~= false then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == 'police' then
            local name = GetCharacterName(src)
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-polisi"><b>POLISI | {0}:</b> {1}</div>',
                args = { name, msg }
            })
        else
            TriggerClientEvent('alan-tasknotify:Alert', source, "INFO", "Tidak Ada Aksess!", 5000, 'error')
        end
    end
end, false)

RegisterCommand('mecha', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(6)
    if player ~= false then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == 'mechanic' then
            local name = GetCharacterName(src)
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-meca"><b>MEKANIK | {0}:</b> {1}</div>',
                args = { name, msg }
            })
        else
            TriggerClientEvent('alan-tasknotify:Alert', source, "INFO", "Tidak Ada Aksess!", 5000, 'error')
        end
    end
end, false)

RegisterCommand('ems', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    if player ~= false then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == 'ambulance' then
            local name = GetCharacterName(src)
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-rs"><b>EMS | {0}:</b> {1}</div>',
                args = { name, msg }
            })
        else
            TriggerClientEvent('alan-tasknotify:Alert', source, "INFO", "Tidak Ada Aksess!", 5000, 'error')
        end
    end
end, false)

RegisterCommand('taxi', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    if player ~= false then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == 'taxi' then
            local name = GetCharacterName(src)
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-taxi"><b>TAXI | {0}:</b> {1}</div>',
                args = { name, msg }
            })
        else
            TriggerClientEvent('alan-tasknotify:Alert', source, "INFO", "Tidak Ada Aksess!", 5000, 'error')
        end
    end
end, false)

RegisterCommand('pedagang', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(9)
    if player ~= false then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == 'pedagang' then
            local name = GetCharacterName(src)
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-pedagang"><b>PEDAGANG | {0}:</b> {1}</div>',
                args = { name, msg }
            })
        else
            TriggerClientEvent('alan-tasknotify:Alert', source, "INFO", "Tidak Ada Aksess!", 5000, 'error')
        end
    end
end, false)

RegisterCommand('pemerintah', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(11)
    if player ~= false then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == 'state' then
            local name = GetCharacterName(src)
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-pemerintah"><b>PEMERINTAH | {0}:</b> {1}</div>',
                args = { name, msg }
            })
        else
            TriggerClientEvent('alan-tasknotify:Alert', source, "INFO", "Tidak Ada Aksess!", 5000, 'error')
        end
    end
end, false)

RegisterCommand('infoadmin', function(source, args, rawCommand) 
    local src = source
    local msg = rawCommand:sub(10)
    if player ~= false then
        if ESX then
            local user = 'GUEST'
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message info"><b>PENGUMUMAN : </b>{1}</div>',
                args = { user, msg }
            })
        end
    end
end, false)


function GetCharacterName(source)
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] and result[1].firstname and result[1].lastname then
		if Config.OnlyFirstname then
			return result[1].firstname
		else
			return ('%s %s'):format(result[1].firstname, result[1].lastname)
		end
	else
		return GetPlayerName(source)
	end
end