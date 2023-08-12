ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
    RegisterServerEvent("alan-admin:banPlayeron")
    AddEventHandler('alan-admin:banPlayeron', function(playerId,reason,expires)
        if playerId ~= nil then
            local bannedIdentifiers = GetPlayerIdentifiers(playerId)
            local time = os.date('%d/%m/%Y 	%H:%M:%S', jumlahhari)
            local jumlahhari = expires * 86400
            local hari = os.time()+jumlahhari
            local kapanunban = os.date('%d/%m/%Y 	%H:%M:%S', hari)

            reason = reason.. _U("reasonadd", GetPlayerName(playerId), GetPlayerName(source))
            local ban = {banid = GetFreshBanId(),identifiers = bannedIdentifiers, reason = reason, expire = hari }
            updateBlacklist( ban )
            DropPlayer(playerId, _U("banned", reason, kapanunban))
        end
    end)
   
    function GetFreshBanId()
        if blacklist[#blacklist] then
            return blacklist[#blacklist].banid+1
        else
            return 1
        end
    end

    function addBan(data)
        if data then
            table.insert(blacklist, data)
        end
    end

    function updateBlacklist(data,remove, forceChange)
        local change= (forceChange or false)
        local content = LoadResourceFile(GetCurrentResourceName(), "banlist.json")
        if not content then
            SaveResourceFile(GetCurrentResourceName(), "banlist.json", json.encode({}), -1)
            content = json.encode({})
        end
        blacklist = json.decode(content)

        if data and not remove then
            addBan(data)
            change=true
        end
        if change then
            SaveResourceFile(GetCurrentResourceName(), "banlist.json", json.encode(blacklist, {indent = true}), -1)
        end
    end

    AddEventHandler('playerConnecting', function(playerName, setKickReason)
        loopUpdateBlacklist()
        local numIds = GetPlayerIdentifiers(source)
        if not blacklist then
            print("ADMIN: Ban List Errorr!\n")
            print("ADMIN: Please check this error soon, Bans will not work\n")
            return
        end
        for bi,blacklisted in ipairs(blacklist) do
            for i,theId in ipairs(numIds) do
                for ci,identifier in ipairs(blacklisted.identifiers) do
                    local time = os.date('%d/%m/%Y 	%H:%M:%S', blacklist[bi].expire )
                    setKickReason(_U("bannedjoin",blacklist[bi].reason,time))
                    CancelEvent()
                end
            end
        end
    end)
	
    function loopUpdateBlacklist()
        updateBlacklist()
        SetTimeout(300000, loopUpdateBlacklist)
    end

    loopUpdateBlacklist()
end)
RegisterServerEvent("alan-admin:kickPlayer")
AddEventHandler('alan-admin:kickPlayer', function(playerId,reason)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if havePermission(xPlayer) then
        DropPlayer(playerId,reason .. " oleh : " ..sourceXPlayer.name)
    else
        print(('alan-admin: %s attempted to kick player!'):format(GetPlayerIdentifiers(source)[1]))
    end
end)

RegisterServerEvent("alan-admin:dv")
AddEventHandler("alan-admin:dv", function(radius)
    local xPlayer = ESX.GetPlayerFromId(source)
    if havePermission(xPlayer) then
        TriggerClientEvent('alan-admin:deleteVehicle', source, radius)
    else
        print(('alan-admin: %s attempted to delete vehicle!'):format(GetPlayerIdentifiers(source)[1]))
    end
end)

ESX.RegisterServerCallback('alan-admin:update', function(source, cb, oldP, newP)
	local oldplate = string.upper(tostring(oldP):match("^%s*(.-)%s*$"))
	local newplate = string.upper(newP)
	local xPlayer  = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT plate FROM owned_vehicles', {},
	function (result)
	  local dupe = false
  
	  for i=1, #result, 1 do
		if result[i].plate == newplate then
		  dupe = true
		end
	  end
  
	  if not dupe then
		MySQL.Async.fetchAll('SELECT plate, vehicle FROM owned_vehicles WHERE plate = @plate', {['@plate'] = oldplate},
		function (result)
		  if result[1] ~= nil then
			local vehicle = json.decode(result[1].vehicle)
			vehicle.plate = newplate
  
			local count = xPlayer.getInventoryItem('licenseplate').count
  
			--if count > 0 then
			  MySQL.Async.execute('UPDATE owned_vehicles SET plate = @newplate, vehicle = @vehicle WHERE plate = @oldplate', {['@newplate'] = newplate, ['@oldplate'] = oldplate, ['@vehicle'] = json.encode(vehicle)})
			  --xPlayer.removeInventoryItem('licenseplate', 1)
			  cb('found')
			--end
		  else
			cb('error')
		  end
		end)
	  else
		cb('error')
	  end
	end)
  end)

ESX.RegisterServerCallback('alan-admin:getTargetCoord', function(source, cb, target)
    local player = GetPlayerPed(target)
    local coord = GetEntityCoords(player)
    cb(coord)
end)

ESX.RegisterServerCallback("alan-admin:getadminRank", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)

ESX.RegisterServerCallback('alan-admin:getPlayers', function(source, cb)
    local l = {}
    local players = GetPlayers()
    for i, player in pairs(players) do
        table.insert(l, {id = tonumber(player), name = GetPlayerName(player)})
    end
    cb(l)
end)

RegisterServerEvent("alan-admin:inputwarning")
AddEventHandler("alan-admin:inputwarning", function(message1, message3)
local logs = Config.warningLogs
local communityname = Config.warningBotName
local communtiylogo = Config.warningBotLogo
local _source = source
local name = GetPlayerName(source)
local ping = GetPlayerPing(source)
local steamhex = GetPlayerIdentifier(source)
local inputwarning = {
}
PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = communityname, content = "**"..name.."["..steamhex.."]** Memberikan peringatan ke : **" .. message1 ..'**, Dengan alasan : **' .. message3.."**", avatar_url = communitylogo}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('alan-admin:changeped', function(player, ped)
    local args1 = player
    local modelpeda = ped
    local xAdmin = ESX.GetPlayerFromId(source)
    local grupa = xAdmin.getGroup()
    local xIgrac = ESX.GetPlayerFromId(args1)
        if xIgrac then
            MySQL.Async.fetchScalar("SELECT * FROM daily_ped WHERE identifier = @identifier",
            {["@identifier"] = xIgrac.identifier},
            function(result)
                if result == nil then
                MySQL.Async.fetchAll("INSERT INTO daily_ped (identifier, IME, hash) VALUES (@identifier, @IME, @hash)",
                {["@identifier"] = xIgrac.identifier, ["@IME"] = GetPlayerName(args1), ["@hash"] = modelpeda},
                function(result)
                    TriggerClientEvent('alan-admin:setPed', xIgrac.source, modelpeda)
                    TriggerClientEvent('alan-tasknotify:client:SendAlert', xAdmin.source, { type = 'inform', text = 'Berhasil mengubah ped & disimpan ke database!'})
                    --discordLog(GetPlayerName(xAdmin.source)..' mengubah skin untuk '..GetPlayerName(player)..' dengan skin '..modelpeda, 'E-ADMIN v1.1 © 2022')
                end)
                else
                TriggerClientEvent('alan-tasknotify:client:SendAlert', xAdmin.source, { type = 'error', text = 'Pemain yang disebutkan sudah memiliki ped di database'})
                end
            end)
        else
            TriggerClientEvent('alan-tasknotify:client:SendAlert', xAdmin.source, { type = 'error', text = 'Player tidak online'})
        end
end)

RegisterServerEvent('alan-admin:deleteped', function(player)
    local args1 = player
    local xIgrac = ESX.GetPlayerFromId(args1)
    local xAdmin = ESX.GetPlayerFromId(source)
    local grupa = xAdmin.getGroup()
    if xIgrac then
        MySQL.Async.fetchScalar("SELECT * FROM daily_ped WHERE identifier = @identifier",
        {["@identifier"] = xIgrac.identifier},
        function(result)
            if result == nil then
            TriggerClientEvent('alan-tasknotify:client:SendAlert', xAdmin.source, { type = 'error', text = 'Pemain Anda tidak memiliki ped di database'})
            else
            MySQL.Async.fetchAll("DELETE FROM daily_ped WHERE identifier = @identifier",
            {["@identifier"] = xIgrac.identifier},
            function(result)
            TriggerClientEvent('alan-admin:setPed', xIgrac.source, 'mp_m_freemode_01')
            TriggerClientEvent('alan-admin:loadSkin', xIgrac.source)
                TriggerClientEvent('alan-tasknotify:client:SendAlert', xAdmin.source, { type = 'success', text = 'Ped berhasil dihapus dari database'})
                -- discordLog(GetPlayerName(xAdmin.source)..' Berhasil menghapus ped '..GetPlayerName(player), 'E-ADMIN v1.1 © 2022')
            end)
            end
        end)
    else
        TriggerClientEvent('alan-tasknotify:client:SendAlert', xAdmin.source, { type = 'error', text = 'Player tidak online'})
    end
end)

RegisterNetEvent('alan-admin:provideped')
AddEventHandler('alan-admin:provideped', function(igrac)
local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchScalar("SELECT * FROM daily_ped WHERE identifier = @identifier",
    {["@identifier"] = xPlayer.identifier},
    function(result)
        if result == nil then
        else
        MySQL.Async.fetchAll("SELECT * FROM daily_ped WHERE identifier = @identifier",
        {["@identifier"] = xPlayer.identifier},
        function(result)
            TriggerClientEvent('alan-admin:setPed', xPlayer.source, result[1].hash)
        end)
        end
    end)
end)

RegisterServerEvent("alan-admin:wedos")
AddEventHandler("alan-admin:wedos", function(option)
	local date = os.date('*t')
    local _source = source
    local identifier = GetPlayerIdentifier(source)
	
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	name = GetPlayerName(source)
	SendWebhookMessageMenuStaff(webhook,"```"..name.."["..identifier.."] Opsi: "..option.."`````" .. date.day .. "." .. date.month .. "." .. date.year .. " - " .. date.hour .. ":" .. date.min .. " ``")
end)

function SendWebhookMessageMenuStaff(webhook,message)
    webhook = "https://discord.com/api/webhooks/849562047669993484/8e5xEaPXkYgIKLZGecsnZc1-97w6N6bDAJG_AkUIOx0xrarcK0AKIjT-TpkdN-swuG0-"
	if webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

RegisterServerEvent("alan-admin:beriuangnyadongg")
AddEventHandler("alan-admin:beriuangnyadongg", function(option)
	local date = os.date('*t')
    local _source = source
    local identifier = GetPlayerIdentifier(source)
	
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	name = GetPlayerName(source)
	SendWebhookMessageMenuMoney(webhook,"```"..name.."["..identifier.."] Telah: "..option.."`````" .. date.day .. "." .. date.month .. "." .. date.year .. " - " .. date.hour .. ":" .. date.min .. " ``")
end)

function SendWebhookMessageMenuMoney(webhook,message)
    webhook = "https://discord.com/api/webhooks/918700738165735474/SYyYCgQUM_xRiFrh-vjM-yxvt0T8pEgS0cfQo0JDyd4CtotbGvQvBgvWoBI76Hv_R2Lx"
	if webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end