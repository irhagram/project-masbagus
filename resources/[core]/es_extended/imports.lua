ESX = exports['es_extended']:getSharedObject()
------------------------------------------------------------------------
-- SHARED
------------------------------------------------------------------------
-- Setup imported functions to use on your server

------------------------------------------------------------------------
if IsDuplicityVersion() then
------------------------------------------------------------------------
-- Setup imported functions to use on your server

------------------------------------------------------------------------
else -- CLIENT
------------------------------------------------------------------------
	ESX.UI.RegisteredTypes, ESX.PlayerData.inventory = nil, {}

	AddEventHandler('esx:setPlayerData', function(key, val, last)
		if GetInvokingResource() == 'es_extended' then
			ESX.PlayerData[key] = val
			if OnPlayerData ~= nil then OnPlayerData(key, val, last) end
		end
	end)

------------------------------------------------------------------------
end
------------------------------------------------------------------------
local CreateThread = CreateThread
local Wait = Wait

local Intervals = {}
local CreateInterval = function(name, interval, action, clear)
	local self = {interval = interval}
	CreateThread(function()
		local name, action, clear = name, action, clear
		repeat
			action()
			Wait(self.interval)
		until self.interval == -1
		if clear then clear() end
		Intervals[name] = nil
	end)
	return self
end

SetInterval = function(name, interval, action, clear)
	if Intervals[name] and interval then Intervals[name].interval = interval
	else
		Intervals[name] = CreateInterval(name, interval, action, clear)
	end
end

ClearInterval = function(name)
	if Intervals[name] then Intervals[name].interval = -1 end
end