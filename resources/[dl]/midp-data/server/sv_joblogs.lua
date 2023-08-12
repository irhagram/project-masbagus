ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local timers = { -- if you want more job shifts add table entry here same as the examples below
    ambulance = {
        {} -- don't edit inside
    },
    police = {
        {} -- don't edit inside
    },
    mechanic = {
        {} -- don't edit inside
    },
    pedagang = {
        {} -- don't edit inside
    },
    -- fbi = {}
}
local dcname = "LOGS ABSENSI" -- bot's name
local http = "https://discord.com/api/webhooks/1028589285198266439/CBrMulsoJrHw-t9_bU0sY2tVJMApkQcpZ_5Yia11AgaF_3G-V8K_7M25UXJeU0QnPyxz" -- webhook for police
local http2 = "https://discord.com/api/webhooks/1028589362302169098/VBeAPF6-R76vJ01BCFUR5npPLFJtAMYVQT2mNCU-s13ZakgskocpkyiY0J4guN1_3C_c" -- webhook for ems (you can add as many as you want)
local http3 = "https://discord.com/api/webhooks/1032980971424858182/CeHrVPAZfwlNaqjJO5qIH_VFhlQei_twyV60-LT6B22Ag4Ia6POj-6tmmbd6u4b3n4oO" -- mechanic
local http4 = "https://discord.com/api/webhooks/1032993881681313862/a1pALZpodkbke1J6vwKxPN56b81YhqGk9Lka0LUFqSs9zC4Cw1vVnN9BVoR-ld63T-v5" -- pedagang
local avatar = "https://media.discordapp.net/attachments/982929367296516145/1026658903255154789/BENNER_BELAJAR.jpg" -- bot's avatar

function DiscordLog(name, message, color, job)
    local connect = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "dailyliferp.id",
            },
        }
    }
    if job == "police" then
        PerformHttpRequest(http, function(err, text, headers) end, 'POST', json.encode({username = dcname, embeds = connect, avatar_url = avatar}), { ['Content-Type'] = 'application/json' })
    elseif job == "ambulance" then
        PerformHttpRequest(http2, function(err, text, headers) end, 'POST', json.encode({username = dcname, embeds = connect, avatar_url = avatar}), { ['Content-Type'] = 'application/json' })
    elseif job == "mechanic" then
        PerformHttpRequest(http3, function(err, text, headers) end, 'POST', json.encode({username = dcname, embeds = connect, avatar_url = avatar}), { ['Content-Type'] = 'application/json' })
    elseif job == "pedagang" then
        PerformHttpRequest(http4, function(err, text, headers) end, 'POST', json.encode({username = dcname, embeds = connect, avatar_url = avatar}), { ['Content-Type'] = 'application/json' })
    end
end

RegisterServerEvent("utk_sl:userjoined")
AddEventHandler("utk_sl:userjoined", function(job)
    local id = source
    local xPlayer = ESX.GetPlayerFromId(id)

    table.insert(timers[job], {id = id, identifier = xPlayer.identifier, name = xPlayer.name, time = os.time(), date = os.date("%d/%m/%Y %X")})
end)

RegisterServerEvent("utk_sl:jobchanged")
AddEventHandler("utk_sl:jobchanged", function(old, new, method)
    local xPlayer = ESX.GetPlayerFromId(source)
    local header = nil
    local color = nil

    if old == "police" then
        header = "SHIFT POLISI" -- Header
        color = 3447003 -- Color
    elseif old == "ambulance" then
        header = "SHIFT  EMS"
        color = 15158332
    elseif old == "mechanic" then
        header = "SHIFT  MEKANIK"
        color = 15844367
    elseif old == "pedagang" then
        header = "SHIFT  PEDAGANG"
        color = 2067276
    --elseif job == "fbi" then
        --header = "FBI Shift"
        --color = 3447003
    end
    if method == 1 then
        for i = 1, #timers[old], 1 do
            if timers[old][i].identifier == xPlayer.identifier then
                local duration = os.time() - timers[old][i].time
                local date = timers[old][i].date
                local timetext = nil

                if duration > 0 and duration < 60 then
                    timetext = tostring(math.floor(duration)).." seconds"
                elseif duration >= 60 and duration < 3600 then
                    timetext = tostring(math.floor(duration / 60)).." minutes"
                elseif duration >= 3600 then
                    timetext = tostring(math.floor(duration / 3600).." hours, "..tostring(math.floor(math.fmod(duration, 3600)) / 60)).." minutes"
                end
                DiscordLog(header , "Nama IC: **"..timers[old][i].name.."**\nIdentifier: **"..timers[old][i].identifier.."**\n Shift duration: **__"..timetext.."__**\n Start date: **"..date.."**\n End date: **"..os.date("%d/%m/%Y %X").."**", color, old)
                table.remove(timers[old], i)
                break
            end
        end
    end
    if not (timers[new] == nil) then
        for t, l in pairs(timers[new]) do
            if l.id == xPlayer.source then
                table.remove(table[new], l)
            end
        end
    end
    if new == "police" then
        table.insert(timers[new], {id = xPlayer.source, identifier = xPlayer.identifier, name = xPlayer.name, time = os.time(), date = os.date("%d/%m/%Y %X")})
    elseif new == "ambulance" then
        table.insert(timers[new], {id = xPlayer.source, identifier = xPlayer.identifier, name = xPlayer.name, time = os.time(), date = os.date("%d/%m/%Y %X")})
    elseif new == "mechanic" then
        table.insert(timers[new], {id = xPlayer.source, identifier = xPlayer.identifier, name = xPlayer.name, time = os.time(), date = os.date("%d/%m/%Y %X")})
    elseif new == "pedagang" then
        table.insert(timers[new], {id = xPlayer.source, identifier = xPlayer.identifier, name = xPlayer.name, time = os.time(), date = os.date("%d/%m/%Y %X")})
    end
end)

AddEventHandler("playerDropped", function(reason)
    local id = source
    local header = nil
    local color = nil

    for k, v in pairs(timers) do
        for n = 1, #timers[k], 1 do
            if timers[k][n].id == id then
                local duration = os.time() - timers[k][n].time
                local date = timers[k][n].date
                local timetext = nil

                if k == "police" then
                    header = "Police Shift"
                    color = 3447003
                elseif k == "ambulance" then
                    header = "EMS Shift"
                    color = 15158332
                elseif k == "mechanic" then
                    header = "Mechanic Shift"
                    color = 15844367
                elseif k == "pedagang" then
                    header = "Pedagang Shift"
                    color = 2067276
                end
                if duration > 0 and duration < 60 then
                    timetext = tostring(math.floor(duration)).." seconds"
                elseif duration >= 60 and duration < 3600 then
                    timetext = tostring(math.floor(duration / 60)).." minutes"
                elseif duration >= 3600 then
                    timetext = tostring(math.floor(duration / 3600).." hours, "..tostring(math.floor(math.fmod(duration, 3600)) / 60)).." minutes"
                end
                DiscordLog(header, "Nama IC: **"..timers[k][n].name.."**\nIdentifier: **"..timers[k][n].identifier.."**\n Shift duration: **__"..timetext.."__**\n Start date: **"..date.."**\n End date: **"..os.date("%d/%m/%Y %X").."**", color, k)
                table.remove(timers[k], n)
                return
            end
        end
    end
end)