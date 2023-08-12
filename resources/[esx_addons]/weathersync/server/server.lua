local CurrentWeather = Config.StartWeather
local baseTime = Config.BaseTime
local timeOffset = Config.TimeOffset
local freezeTime = Config.FreezeTime
local blackout = Config.Blackout
local newWeatherTimer = Config.NewWeatherTimer

local function getSource(src)
    if src == '' then
        return 0
    end
    return src
end

local function isAllowedToChange(Player)
    if exclude and type(exclude) ~= 'table' then exclude = nil end
	local group = Player.getGroup()
	for k,v in pairs(Config.AdminRank) do
		if v == group then
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

local function shiftToMinute(minute)
    timeOffset = timeOffset - ( ( (baseTime+timeOffset) % 60 ) - minute )
end

local function shiftToHour(hour)
    timeOffset = timeOffset - ( ( ((baseTime+timeOffset)/60) % 24 ) - hour ) * 60
end

local function nextWeatherStage()
    if CurrentWeather == "CLEAR" or CurrentWeather == "CLOUDS" or CurrentWeather == "EXTRASUNNY"  then
        CurrentWeather = (math.random(1,5) > 2) and "CLEARING" or "OVERCAST" -- 60/40 chance
    elseif CurrentWeather == "CLEARING" or CurrentWeather == "OVERCAST" then
        local new = math.random(1,6)
        if new == 1 then CurrentWeather = (CurrentWeather == "CLEARING") and "FOGGY" or "RAIN"
        elseif new == 2 then CurrentWeather = "CLOUDS"
        elseif new == 3 then CurrentWeather = "CLEAR"
        elseif new == 4 then CurrentWeather = "EXTRASUNNY"
        elseif new == 5 then CurrentWeather = "SMOG"
        else CurrentWeather = "FOGGY"
        end
    elseif CurrentWeather == "THUNDER" or CurrentWeather == "RAIN" then CurrentWeather = "CLEARING"
    elseif CurrentWeather == "SMOG" or CurrentWeather == "FOGGY" then CurrentWeather = "CLEAR"
    else CurrentWeather = "CLEAR"
    end
    TriggerEvent("weathersync:server:RequestStateSync")
end

local function setWeather(weather)
    local validWeatherType = false
    for _,weatherType in pairs(Config.AvailableWeatherTypes) do
        if weatherType == string.upper(weather) then
            validWeatherType = true
        end
    end
    if not validWeatherType then return false end
    CurrentWeather = string.upper(weather)
    newWeatherTimer = Config.NewWeatherTimer
    TriggerEvent('weathersync:server:RequestStateSync')
    return true
end

local function setTime(hour, minute)
    local argh = tonumber(hour)
    local argm = tonumber(minute) or 0
    if argh == nil or argh > 24 then
        print(Lang:t('time.invalid'))
        return false
    end
    shiftToHour((argh < 24) and argh or 0)
    shiftToMinute((argm < 60) and argm or 0)
    print(Lang:t('time.change', {value = argh, value2 = argm}))
    TriggerEvent('weathersync:server:RequestStateSync')
    return true
end

local function setBlackout(state)
    if state == nil then state = not blackout end
    if state then blackout = true
    else blackout = false end
    TriggerEvent('weathersync:server:RequestStateSync')
    return blackout
end

local function setTimeFreeze(state)
    if state == nil then state = not freezeTime end
    if state then freezeTime = true
    else freezeTime = false end
    TriggerEvent('weathersync:server:RequestStateSync')
    return freezeTime
end

local function setDynamicWeather(state)
    if state == nil then state = not Config.DynamicWeather end
    if state then Config.DynamicWeather = true
    else Config.DynamicWeather = false end
    TriggerEvent('weathersync:server:RequestStateSync')
    return Config.DynamicWeather
end

-- EVENTS

RegisterNetEvent('weathersync:server:RequestStateSync', function()
    TriggerClientEvent('weathersync:client:SyncWeather', -1, CurrentWeather, blackout)
    TriggerClientEvent('weathersync:client:SyncTime', -1, baseTime, timeOffset, freezeTime)
end)

RegisterNetEvent('weathersync:server:RequestCommands', function()
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if isAllowedToChange(Player) then
        TriggerClientEvent('weathersync:client:RequestCommands', src, true)
    end
end)

RegisterNetEvent('weathersync:server:setWeather', function(weather)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if isAllowedToChange(Player) then
        local success = setWeather(weather)
        if src > 0 then
            if (success) then TriggerClientEvent('coresv:Notify', Player.identifier, Lang:t('weather.updated'))
            else TriggerClientEvent('coresv:Notify', Player.identifier, Lang:t('weather.invalid'))
            end
        end
    end
end)

RegisterNetEvent('weathersync:server:setTime', function(hour, minute)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if isAllowedToChange(Player) then
        local success = setTime(hour, minute)
        if src > 0 then
            if (success) then TriggerClientEvent('coresv:Notify', Player.identifier, Lang:t('time.change', {value = hour, value2 = minute or "00"}))
            else TriggerClientEvent('coresv:Notify', Player.identifier, Lang:t('time.invalid'))
            end
        end
    end
end)

RegisterNetEvent('weathersync:server:toggleBlackout', function(state)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if isAllowedToChange(Player) then
        local newstate = setBlackout(state)
        if src > 0 then
            if (newstate) then TriggerClientEvent('coresv:Notify', Player.identifier, Lang:t('blackout.enabled'))
            else TriggerClientEvent('coresv:Notify', Player.identifier, Lang:t('blackout.disabled'))
            end
        end
    end
end)

RegisterNetEvent('weathersync:server:toggleFreezeTime', function(state)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if isAllowedToChange(Player) then
        local newstate = setTimeFreeze(state)
        if src > 0 then
            if (newstate) then TriggerClientEvent('coresv:Notify', Player.identifier, Lang:t('time.now_frozen'))
            else TriggerClientEvent('coresv:Notify', Player.identifier, Lang:t('time.now_unfrozen'))
            end
        end
    end
end)

RegisterNetEvent('weathersync:server:toggleDynamicWeather', function(state)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if isAllowedToChange(Player) then
        local newstate = setDynamicWeather(state)
        if src > 0 then
            if (newstate) then TriggerClientEvent('coresv:Notify', Player.identifier, Lang:t('weather.now_unfrozen'))
            else TriggerClientEvent('coresv:Notify', Player.identifier, Lang:t('weather.now_frozen'))
            end
        end
    end
end)

RegisterCommand('freezetime', function(source)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if isAllowedToChange(Player) then
        local newstate = setTimeFreeze()
        if source > 0 then
            if (newstate) then return TriggerClientEvent('coresv:Notify', source, Lang:t('time.frozenc')) end
            return TriggerClientEvent('coresv:Notify', source, Lang:t('time.unfrozenc'))
        end
        if (newstate) then return print(Lang:t('time.now_frozen')) end
        return print(Lang:t('time.now_unfrozen'))
    end
    TriggerClientEvent('coresv:Notify', source, Lang:t('error.not_allowed'), 'error')
end)

RegisterCommand('freezeweather', function(source)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if isAllowedToChange(Player) then
        local newstate = setDynamicWeather()
        if source > 0 then
            if (newstate) then return TriggerClientEvent('coresv:Notify', source, Lang:t('dynamic_weather.enabled')) end
            return TriggerClientEvent('coresv:Notify', source, Lang:t('dynamic_weather.disabled'))
        end
        if (newstate) then return print(Lang:t('weather.now_unfrozen')) end
        return print(Lang:t('weather.now_frozen'))
    end
    TriggerClientEvent('coresv:Notify', source, Lang:t('error.not_allowed'), 'error')
end)

RegisterCommand('weather', function(source, args)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if isAllowedToChange(Player) then
        if args[1] == nil then
            if source > 0 then return TriggerClientEvent('coresv:Notify', source, Lang:t('weather.invalid_syntaxc'), 'error') end
            return print(Lang:t('weather.invalid_syntax'))
        end
        local success = setWeather(args[1])
        if source > 0 then
            if (success) then return TriggerClientEvent('coresv:Notify', source, Lang:t('weather.willchangeto', {value = string.lower(args[1])})) end
            return TriggerClientEvent('coresv:Notify', source, Lang:t('weather.invalidc'), 'error')
        end
        if (success) then return print(Lang:t('weather.updated')) end
        return print(Lang:t('weather.invalid'))
    else
        TriggerClientEvent('coresv:Notify', source, Lang:t('error.not_access'), 'error')
    end
end)

RegisterCommand('blackout', function(source)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if isAllowedToChange(Player) then
        local newstate = setBlackout()
        if src > 0 then
            if (newstate) then return TriggerClientEvent('coresv:Notify', Player.identifier, Lang:t('blackout.enabledc')) end
            return TriggerClientEvent('coresv:Notify', Player.identifier, Lang:t('blackout.disabledc'))
        end
        if (newstate) then return print(Lang:t('blackout.enabled')) end
        return print(Lang:t('blackout.disabled'))
    end
    TriggerClientEvent('coresv:Notify', Player.identifier, Lang:t('error.not_allowed'), 'error')
end)

RegisterCommand('morning', function(source)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if isAllowedToChange(Player) then
        setTime(9, 0)
        if source > 0 then return TriggerClientEvent('coresv:Notify', source, Lang:t('time.morning')) end
    else
        TriggerClientEvent('coresv:Notify', source, Lang:t('error.not_allowed'), 'error')
    end
end)

RegisterCommand('noon', function(source)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if isAllowedToChange(Player) then
        setTime(12, 0)
        if source > 0 then return TriggerClientEvent('coresv:Notify', source, Lang:t('time.noon')) end
    else
        TriggerClientEvent('coresv:Notify', source, Lang:t('error.not_allowed'), 'error')
    end
end)

RegisterCommand('evening', function(source)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if isAllowedToChange(Player) then
        setTime(18, 0)
        if source > 0 then return TriggerClientEvent('coresv:Notify', source, Lang:t('time.evening')) end
    else
        TriggerClientEvent('coresv:Notify', source, Lang:t('error.not_allowed'), 'error')
    end
end)

RegisterCommand('night', function(source)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if isAllowedToChange(Player) then
        setTime(23, 0)
        if source > 0 then return TriggerClientEvent('coresv:Notify', source, Lang:t('time.night')) end
    else
        TriggerClientEvent('coresv:Notify', source, Lang:t('error.not_allowed'), 'error')
    end
end)

RegisterCommand('time', function(source, args)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if isAllowedToChange(Player) then
        if args[1] == nil then
            if source > 0 then return TriggerClientEvent('coresv:Notify', source, Lang:t('time.invalidc'), 'error') end
            return print(Lang:t('time.invalid'))
        end
        local success = setTime(args[1], args[2])
        if source > 0 then
            if (success) then return TriggerClientEvent('coresv:Notify', source, Lang:t('time.changec', {value = args[1]..':'..(args[2] or "00")})) end
            return TriggerClientEvent('coresv:Notify', source, Lang:t('time.invalidc'), 'error')
        end
        if (success) then return print(Lang:t('time.change', {value = args[1], value2 = args[2] or "00"})) end
        return print(Lang:t('time.invalid'))
    else
        TriggerClientEvent('coresv:Notify', source, Lang:t('time.access'), 'error')
    end
end)

-- THREAD LOOPS

CreateThread(function()
    local previous = 0
    while true do
        Wait(0)
        local newBaseTime = os.time(os.date("!*t"))/2 + 360         --Set the server time depending of OS time
        if (newBaseTime % 60) ~= previous then                      --Check if a new minute is passed
            previous = newBaseTime % 60                             --Only update time with plain minutes, seconds are handled in the client
            if freezeTime then
                timeOffset = timeOffset + baseTime - newBaseTime
            end
            baseTime = newBaseTime
        end
    end
end)

CreateThread(function()
    while true do
        Wait(2000)                                          --Change to send every minute in game sync
        TriggerClientEvent('weathersync:client:SyncTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

CreateThread(function()
    while true do
        Wait(300000)
        TriggerClientEvent('weathersync:client:SyncWeather', -1, CurrentWeather, blackout)
    end
end)

CreateThread(function()
    while true do
        newWeatherTimer = newWeatherTimer - 1
        Wait((1000 * 60) * Config.NewWeatherTimer)
        if newWeatherTimer == 0 then
            if Config.DynamicWeather then
                nextWeatherStage()
            end
            newWeatherTimer = Config.NewWeatherTimer
        end
    end
end)

-- EXPORTS

exports('nextWeatherStage', nextWeatherStage)
exports('setWeather', setWeather)
exports('setTime', setTime)
exports('setBlackout', setBlackout)
exports('setTimeFreeze', setTimeFreeze)
exports('setDynamicWeather', setDynamicWeather)
exports('getBlackoutState', function() return blackout end)
exports('getTimeFreezeState', function() return freezeTime end)
exports('getWeatherState', function() return CurrentWeather end)
exports('getDynamicWeather', function() return Config.DynamicWeather end)