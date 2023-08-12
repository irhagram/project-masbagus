
local oocdelay = {}
local emsdelay = {}


Config        = {}

Config.EnableESXIdentity = true
Config.OnlyFirstname     = false

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
                template = '<div class="chat-message-ooc"><b>OOC | {0}:</b> {1}</div>',
                args = { user, msg }
            })
            oocdelay[source] = GetGameTimer()
        end
    else
        TriggerClientEvent("pNotify:SendNotification", -1, {text = "Kamu telah menggunakan OOC CHAT 1 menit sebelumnya, kamu harus menunggu", type = "error", queue = "lmao", timeout = 10000, layout = "centerLeft"})
    end
end, false)

RegisterCommand('announce', function(source, args, rawCommand)
    if oocdelay[source] == nil then
        oocdelay[source] = 0
    end
    local xPlayer = ESX.GetPlayerFromId(source)
    local src = source
    local msg = rawCommand:sub(4)
    if xPlayer:getGroup() == 'superadmin' or xPlayer:getGroup() == 'admin' then
        if player ~= false then
            local user = GetPlayerName(src)
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-ann"><b>PENGUMUMAN | </b> {1}</div>',
                args = { user, msg }
            })
            oocdelay[source] = GetGameTimer()
        end
    else
        TriggerClientEvent("pNotify:SendNotification", -1, {text = "Kamu telah menggunakan OOC CHAT 1 menit sebelumnya, kamu harus menunggu", type = "error", queue = "lmao", timeout = 10000, layout = "centerLeft"})
    end
end, false)

RegisterCommand('119', function(source, args, rawCommand)
    if emsdelay[source] == nil then
        emsdelay[source] = 0
    end
    local xPlayers = ESX.GetPlayers()
    local src = source
    local msg = rawCommand:sub(4)
    local user = GetPlayerName(src)
    if GetGameTimer() - emsdelay[source] > 300000 then
        if player ~= false then
            for i=1, #xPlayers, 1 do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                
                if xPlayer.job.name == 'ambulance' then
                    TriggerClientEvent('dl-job:Alert119')
                    TriggerClientEvent('chat:addMessage', xPlayer.source, {
                        template = '<div class="chat-message-ooc"><b>119 | {0}:</b> {1}</div>',
                        args = { user, msg }
                    })
                end
            end
            emsdelay[source] = GetGameTimer()
        end
    else
        TriggerClientEvent("pNotify:SendNotification", -1, {text = "Kamu telah menggunakan 119 CHAT 5 menit sebelumnya, kamu harus menunggu", type = "error", queue = "lmao", timeout = 10000, layout = "centerLeft"})
    end
end, false)

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
            xPlayer.removeMoney(1000)
        else
            TriggerClientEvent("pNotify:SendNotification", -1, {text = "Kamu tidak memiliki cukup uang untuk memasang iklan", type = "error", queue = "lmao", timeout = 10000, layout = "centerLeft"})
        end
    end
end, false)

RegisterCommand('pol', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(4)
    if player ~= false then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == 'police' then
            local name = GetCharacterName(src)
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-polisi"><b>POLISI | {0}:</b> {1}</div>',
                args = { name, msg }
            })
        else
            TriggerClientEvent("pNotify:SendNotification", -1, {text = "Kamu Bukan Anggota Kepolisian", type = "error", queue = "lmao", timeout = 10000, layout = "centerLeft"})
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
                template = '<div class="chat-message-meca"><b>MECHANIC | {0}:</b> {1}</div>',
                args = { name, msg }
            })
        else
            TriggerClientEvent("pNotify:SendNotification", -1, {text = "Kamu Bukan Anggota Mechanic", type = "error", queue = "lmao", timeout = 10000, layout = "centerLeft"})
        end
    end
end, false)

RegisterCommand('mont', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(6)
    if player ~= false then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == 'montir' then
            local name = GetCharacterName(src)
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-montir"><b>MONTIR | {0}:</b> {1}</div>',
                args = { name, msg }
            })
        else
            TriggerClientEvent("pNotify:SendNotification", -1, {text = "Kamu Bukan Anggota Montir", type = "error", queue = "lmao", timeout = 10000, layout = "centerLeft"})
        end
    end
end, false)


RegisterCommand('taxi', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(6)
    if player ~= false then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == 'ojek' then
            local name = GetCharacterName(src)
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-ojek"><b>TRANSPORT | {0}:</b> {1}</div>',
                args = { name, msg }
            })
        else
            TriggerClientEvent("pNotify:SendNotification", -1, {text = "Kamu Bukan Anggota Ojek", type = "error", queue = "lmao", timeout = 10000, layout = "centerLeft"})
        end
    end
end, false)

RegisterCommand('fibc', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(6)
    if player ~= false then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == 'fib' then
            local name = GetCharacterName(src)
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-par"><b>FIB | {0}:</b> {1}</div>',
                args = { name, msg }
            })
        else
            TriggerClientEvent("pNotify:SendNotification", -1, {text = "Kamu Bukan Anggota Paradise", type = "error", queue = "lmao", timeout = 10000, layout = "centerLeft"})
        end
    end
end, false)

RegisterCommand('ems', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(4)
    if player ~= false then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == 'ambulance' then
            local name = GetCharacterName(src)
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-rs"><b>EMS | {0}:</b> {1}</div>',
                args = { name, msg }
            })
        else
            TriggerClientEvent("pNotify:SendNotification", -1, {text = "Kamu Bukan Anggota Paramedis", type = "error", queue = "lmao", timeout = 10000, layout = "centerLeft"})
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
            TriggerClientEvent("pNotify:SendNotification", -1, {text = "Kamu bukan seorang anggota Taxi", type = "error", queue = "lmao", timeout = 10000, layout = "centerLeft"})
        end
    end
end, false)

RegisterCommand('pdm', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    if player ~= false then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == 'cardealer' then
            local name = GetCharacterName(src)
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-pdm"><b>PDM SUMBERJAYA | {0}:</b> {1}</div>',
                args = { name, msg }
            })
        else
            TriggerClientEvent("pNotify:SendNotification", -1, {text = "Kamu bukan seorang anggota PDM", type = "error", queue = "lmao", timeout = 10000, layout = "centerLeft"})
        end
    end
end, false)

RegisterCommand('ped', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    if player ~= false then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == 'pedagang' then
            local name = GetCharacterName(src)
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-pedagang"><b>PEDAGANG | {0}:</b> {1}</div>',
                args = { name, msg }
            })
        else
            TriggerClientEvent("pNotify:SendNotification", -1, {text = "Kamu bukan seorang anggota Pedagang", type = "error", queue = "lmao", timeout = 10000, layout = "centerLeft"})
        end
    end
end, false)

--[[RegisterCommand('bisik', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    if player ~= false then
        if ESX then
            local name = getIdentity(src)
		        fal = name.firstname .. " " .. name.lastname
                TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message pol"><b>MEMBISIKKAN | {0} :  </b>{1}</div>',
                args = { fal, msg }
            })
        else
            local user = GetPlayerName(src)
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message pol"><b>MEMBISIKKAN | {0} :  </b>{1}</div>',
                args = { user, msg }
            })
        end
    end
end, false)]]--

RegisterCommand('annods', function(source, args, rawCommand)
    local msg = rawCommand:sub(7)
    --TriggerClientEvent('chatMessage', -1, (source == 0) and 'Gooks-DEV : ' or GetPlayerName(source), { 0, 0, 255 }, rawCommand:sub(5))
    if (source == 0) then
        sendToDiscord1('', '@everyone **KOTA SUDAH BISA DI AKSESS KEMBALI YA GES YA**\n**HAPPY ROLEPLAY**\n```MARI BERSAMA SAMA KITA MEMBANGUN KOMUNITAS ROLEPLAY YANG SALING MENGHARGAI SESAMA PLAYER DAILYLIFE, DI MULAI DARI KITA SENDIRI DAN JANGAN LUPA SELALU MEMBACA PERATURAN DAN PETUNJUK BERMAIN. HAPPY ROLEPLAY```\n**YUK FOLLOW AKUN SOSMED RESMI KAMI:**\n**INSTAGRAM** : https://www.instagram.com/dailyliferoleplay.id\n**TIKTOK**: https://tiktok.com/@dailyliferoleplay.id')
        ---sendToDiscord2('', '@everyone **SERVER UP**\n```CONNECT KOTA : connect cfx.re/join/pg4lj8\nCONNECT TEAMSPEAK : tsindorev```')
    end
end)

RegisterCommand('badaidc', function(source, args, rawCommand)
    local msg = rawCommand:sub(7)
    --TriggerClientEvent('chatMessage', -1, (source == 0) and 'Gooks-DEV : ' or GetPlayerName(source), { 0, 0, 255 }, rawCommand:sub(5))
    if (source == 0) then
        DcBadai('', 'SERVER PERBAIKAN PUKUL 18.20 WIB @everyone')
        ---sendToDiscord2('', '@everyone **SERVER UP**\n```CONNECT KOTA : connect cfx.re/join/pg4lj8\nCONNECT TEAMSPEAK : tsindorev```')
    end
end)


function GetCharacterName(source)
	local xPlayer = ESX.GetPlayerFromId(source)
    local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
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

function sendToDiscord1 (name,message,color)
	local DiscordWebHook = "https://discord.com/api/webhooks/1051081412868051004/K9vABhMFQt6Kr9amqkDqdkuAQQcGgJHuC1MzU4UlltrLIfG8bkprHVK0JoWprk9cXBBL"
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

function DcBadai (name,message,color)
	local DiscordWebHook = "https://discord.com/api/webhooks/1051081412868051004/K9vABhMFQt6Kr9amqkDqdkuAQQcGgJHuC1MzU4UlltrLIfG8bkprHVK0JoWprk9cXBBL"
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