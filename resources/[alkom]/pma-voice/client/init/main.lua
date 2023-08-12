local mutedPlayers = {}

-- we can't use GetConvarInt because its not a integer, and theres no way to get a float... so use a hacky way it is!
local volumes = {
	-- people are setting this to 1 instead of 1.0 and expecting it to work.
	['radio'] = GetConvarInt('voice_defaultRadioVolume', 60) / 100,
	['call'] = GetConvarInt('voice_defaultCallVolume', 60) / 100,
}

radioEnabled, radioPressed, mode = true, false, GetConvarInt('voice_defaultVoiceMode', 2)
radioData = {}
callData = {}
submixIndicies = {}
--- function setVolume
--- Toggles the players volume
---@param volume number between 0 and 100
---@param volumeType string the volume type (currently radio & call) to set the volume of (opt)
function setVolume(volume, volumeType)
	type_check({volume, "number"})
	local volume = volume / 100
	
	if volumeType then
		local volumeTbl = volumes[volumeType]
		if volumeTbl then
			LocalPlayer.state:set(volumeType, volume, true)
			volumes[volumeType] = volume
			resyncVolume(volumeType, volume)
		else
			error(('setVolume got a invalid volume type %s'):format(volumeType))
		end
	else
		for volumeType, _ in pairs(volumes) do
			volumes[volumeType] = volume
			LocalPlayer.state:set(volumeType, volume, true)
		end
		resyncVolume("all", volume)
	end
end

exports('setRadioVolume', function(vol)
	setVolume(vol, 'radio')
end)
exports('getRadioVolume', function()
	return volumes['radio']
end)
exports("setCallVolume", function(vol)
	setVolume(vol, 'call')
end)
exports('getCallVolume', function()
	return volumes['call']
end)


-- default submix incase people want to fiddle with it.
-- freq_low = 389.0
-- freq_hi = 3248.0
-- fudge = 0.0
-- rm_mod_freq = 0.0
-- rm_mix = 0.16
-- o_freq_lo = 348.0
-- 0_freq_hi = 4900.0

if gameVersion == 'fivem' then
	local radioEffectId = CreateAudioSubmix('Radio')
	SetAudioSubmixEffectRadioFx(radioEffectId, 0)
	-- This is a GetHashKey on purpose, backticks break treesitter in nvim :|
	SetAudioSubmixEffectParamInt(radioEffectId, 0, GetHashKey('default'), 1)
	SetAudioSubmixOutputVolumes(
		radioEffectId,
		0,
		1.0 --[[ frontLeftVolume ]],
		0.25 --[[ frontRightVolume ]],
		0.0 --[[ rearLeftVolume ]],
		0.0 --[[ rearRightVolume ]],
		1.0 --[[ channel5Volume ]],
		1.0 --[[ channel6Volume ]]
	)
	AddAudioSubmixOutput(radioEffectId, 0)
	submixIndicies['radio'] = radioEffectId

	local callEffectId = CreateAudioSubmix('Call')
	SetAudioSubmixOutputVolumes(
		callEffectId,
		1,
		0.10 --[[ frontLeftVolume ]],
		0.50 --[[ frontRightVolume ]],
		0.0 --[[ rearLeftVolume ]],
		0.0 --[[ rearRightVolume ]],
		1.0 --[[ channel5Volume ]],
		1.0 --[[ channel6Volume ]]
	)
	AddAudioSubmixOutput(callEffectId, 1)
	submixIndicies['call'] = callEffectId

	-- Callback is expected to return data in an array, this is for compatibility sake with js, index 0 should be the name and index 1 should be the submixId
	exports("registerCustomSubmix", function(callback)
		local submixTable = callback()
		type_check({submixTable, "table"})
		local submixName, submixId = submixTable[1], submixTable[2]
		type_check({submixName, "string"}, {submixId, "number"})
		logger.info("Creating submix %s with submixId %s", submixName, submixId)
		submixIndicies[submixName] = submixId
	end)

	-- Trigger an event so resources can know when to register their submix
	-- Implementers will still have to do custom logic if their script has to restart during runtime
	TriggerEvent("pma-voice:registerCustomSubmixes")
end

--- export setEffectSubmix
--- Sets a user defined audio submix for radio and phonecall effects
---@param type string either "call" or "radio"
---@param effectId number submix id returned from CREATE_AUDIO_SUBMIX
exports("setEffectSubmix", function(type, effectId)
	type_check({type, "string"}, {effectId, "number"})
	if submixIndicies[type] then
		submixIndicies[type] = effectId
	end
end)

function restoreDefaultSubmix(plyServerId)
	local submix = Player(plyServerId).state.submix
	local submixEffect = submixIndicies[submix]
	if not submix or not submixEffect then
		MumbleSetSubmixForServerId(plyServerId, -1)
		return
	end
	MumbleSetSubmixForServerId(plyServerId, submixEffect)
end

-- used to prevent a race condition if they talk again afterwards, which would lead to their voice going to default.
local disableSubmixReset = {}
--- function toggleVoice
--- Toggles the players voice
---@param plySource number the players server id to override the volume for
---@param enabled boolean if the players voice is getting activated or deactivated
---@param moduleType string the volume & submix to use for the voice.
function toggleVoice(plySource, enabled, moduleType)
	if mutedPlayers[plySource] then return end
	logger.verbose('[main] Updating %s to talking: %s with submix %s', plySource, enabled, moduleType)
	local distance = currentTargets[plySource]
	if enabled and (not distance or distance > 4.0) then
		MumbleSetVolumeOverrideByServerId(plySource, enabled and volumes[moduleType])
		if GetConvarInt('voice_enableSubmix', 1) == 1 and gameVersion == 'fivem' then
			if moduleType then
				disableSubmixReset[plySource] = true
				if submixIndicies[moduleType] then
					MumbleSetSubmixForServerId(plySource, submixIndicies[moduleType])
				end
			else
				restoreDefaultSubmix(plySource)
			end
		end
	elseif not enabled then
		if GetConvarInt('voice_enableSubmix', 1) == 1 and gameVersion == 'fivem' then
			-- garbage collect it
			disableSubmixReset[plySource] = nil
			SetTimeout(250, function()
				if not disableSubmixReset[plySource] then
					restoreDefaultSubmix(plySource)
				end
			end)
		end
		MumbleSetVolumeOverrideByServerId(plySource, -1.0)
	end
end

local function updateVolumes(voiceTable, override)
	for serverId, talking in pairs(voiceTable) do
		if not talking or serverId == playerServerId then goto skip_iter end
		MumbleSetVolumeOverrideByServerId(serverId, override)
		::skip_iter::
	end
end

--- resyncs the call/radio/etc volume to the new volume
---@param volumeType any
function resyncVolume(volumeType, newVolume)
	if volumeType == "all" then
		resyncVolume("radio", newVolume)
		resyncVolume("call", newVolume)
	elseif volumeType == "radio" then
		updateVolumes(radioData, newVolume)
	elseif volumeType == "call" then
		updateVolumes(callData, newVolume)
	end
end

--- function playerTargets
---Adds players voices to the local players listen channels allowing
---Them to communicate at long range, ignoring proximity range.
---@diagnostic disable-next-line: undefined-doc-param
---@param targets table expects multiple tables to be sent over
function playerTargets(...)
	local targets = {...}
	local addedPlayers = {
		[playerServerId] = true
	}

	for i = 1, #targets do
		for id, _ in pairs(targets[i]) do
			-- we don't want to log ourself, or listen to ourself
			if addedPlayers[id] and id ~= playerServerId then
				logger.verbose('[main] %s is already target don\'t re-add', id)
				goto skip_loop
			end
			if not addedPlayers[id] then
				logger.verbose('[main] Adding %s as a voice target', id)
				addedPlayers[id] = true
				MumbleAddVoiceTargetPlayerByServerId(voiceTarget, id)
			end
			::skip_loop::
		end
	end
end

--- function playMicClicks
---plays the mic click if the player has them enabled.
---@param clickType boolean whether to play the 'on' or 'off' click. 
function playMicClicks(clickType)
	if micClicks ~= 'true' then return logger.verbose("Not playing mic clicks because client has them disabled") end
	-- TODO: Add customizable radio click volumes
	sendUIMessage({
		sound = (clickType and "audio_on" or "audio_off"),
		volume = (clickType and 0.1 or 0.03)
	})
end

--- getter for mutedPlayers
exports('getMutedPlayers', function()
	return mutedPlayers
end)

--- toggles the targeted player muted
---@param source number the player to mute
function toggleMutePlayer(source)
	if mutedPlayers[source] then
		mutedPlayers[source] = nil
		MumbleSetVolumeOverrideByServerId(source, -1.0)
	else
		mutedPlayers[source] = true
		MumbleSetVolumeOverrideByServerId(source, 0.0)
	end
end
exports('toggleMutePlayer', toggleMutePlayer)

--- function setVoiceProperty
--- sets the specified voice property
---@param type string what voice property you want to change (only takes 'radioEnabled' and 'micClicks')
---@param value any the value to set the type to.
function setVoiceProperty(type, value)
	if type == "radioEnabled" then
		radioEnabled = value
		sendUIMessage({
			radioEnabled = value
		})
	elseif type == "micClicks" then
		local val = tostring(value)
		micClicks = val
		SetResourceKvp('pma-voice_enableMicClicks', val)
	end
end
exports('setVoiceProperty', setVoiceProperty)
-- compatibility
exports('SetMumbleProperty', setVoiceProperty)
exports('SetTokoProperty', setVoiceProperty)


local currentRouting = 0
local overrideCoords = false

--- function setOverrideCoords
--- overrides the players coords to a seperate coordinate, useful when spectating.
---@param coords vector3|boolean the coords to override with, or false to reset
function setOverrideCoords(coords) 
	local coordType = type(coords)
	-- if someone sets this to true it will break playerPos, error instead.
	if coordType ~= 'vector3' and (coordType ~= 'boolean' or coords == true) then
		return logger.error("setOverrideCoords expects a 'vector3' or 'boolean' (as false), got %s with the value of %s", coordType, coords)
	end
	overrideCoords = coords
end
exports('setOverrideCoords', setOverrideCoords)

function getMaxSize(zoneRadius)
	return math.floor(math.max(4500.0 + 8192.0, 0.0) / zoneRadius + math.max(8022.0 + 8192.0, 0.0) / zoneRadius)
end

local updatedRouting = false
--- function getGridZone
--- calculate the players grid
---@return number returns the players current grid.
local function getGridZone()
	local plyPos = overrideCoords or GetEntityCoords(PlayerPedId(), false)
	local zoneRadius = GetConvarInt('voice_zoneRadius', 256)
	local newRouting = LocalPlayer.state.routingBucket

	if newRouting ~= currentRouting then
		currentRouting = newRouting or 0
		updatedRouting = true
	end

	local sectorX = math.max(plyPos.x + 8192.0, 0.0) / zoneRadius
	local sectorY = math.max(plyPos.y + 8192.0, 0.0) / zoneRadius
	return (math.ceil(sectorX + sectorY) + (currentRouting * getMaxSize(zoneRadius)))
end

--- function getGridZoneAtCoords
--- gets the grid at the set coords
--- @param coords vector3 the coords to get the grid at
---@return number returns the grid that would be at the current coords
local function getGridZoneAtCoords(coords)
	local plyPos = coords
	local zoneRadius = GetConvarInt('voice_zoneRadius', 256)

	local sectorX = math.max(plyPos.x + 8192.0, 0.0) / zoneRadius
	local sectorY = math.max(plyPos.y + 8192.0, 0.0) / zoneRadius
	return (math.ceil(sectorX + sectorY) + (currentRouting * getMaxSize(zoneRadius)))
end
exports('getGridZoneAtCoords', getGridZoneAtCoords)

local lastGridChange = GetGameTimer()

--- function updateZone
--- updates the players current grid, if they're in a different grid.
---@param forced boolean whether or not to force a grid refresh. default: false
local function updateZone(forced)
	local newGrid = getGridZone()
	if newGrid ~= currentGrid or forced then
		logger.verbose('Time since last grid change: %s',  (GetGameTimer() - lastGridChange)/1000)
		logger.info('Updating zone from %s to %s and adding nearby grids, was forced: %s', currentGrid, newGrid, forced)
		lastGridChange = GetGameTimer()
		currentGrid = newGrid
		MumbleClearVoiceTargetChannels(1)
		NetworkSetVoiceChannel(currentGrid)
		-- Delay adding listener channels until NetworkSetVoiceChannel resolves
		if updatedRouting then
			Wait(GetConvarInt('voice_routingUpdateWait', 50))
			updatedRouting = false
		end
		LocalPlayer.state:set('grid', currentGrid, true)
		-- add nearby grids to voice targets
		for nearbyGrids = currentGrid - 3, currentGrid + 3 do
			MumbleAddVoiceTargetChannel(1, nearbyGrids)
		end
	end
end

-- cache their external servers so if it changes in runtime we can reconnect the client.
local externalAddress = '172.104.183.9'
local externalPort = 10130
CreateThread(function()
	while true do
		Wait(500)
		-- only change if what we have doesn't match the cache
		if GetConvar('voice_externalAddress', '') ~= externalAddress or GetConvarInt('voice_externalPort', 0) ~= externalPort then
			externalAddress = GetConvar('voice_externalAddress', '')
			externalPort = GetConvarInt('voice_externalPort', 0)
			MumbleSetServerAddress(GetConvar('voice_externalAddress', ''), GetConvarInt('voice_externalPort', 0))
		end
	end
end)

RegisterCommand('+resetVoiceRWT', function() --  chat command, You can change it to your liking.
    local newGrid = getGridZone()
	print(('[vsync] Forcing zone from %s to %s and resetting voice targets.'):format(currentGrid, newGrid))
	exports['midp-tasknotify']:SendAlert('success', "Reset Voice...", 10000)
	if GetConvar('voice_externalAddress', '') ~= externalAddress and GetConvarInt('voice_externalPort', 0) ~= externalPort then
		MumbleSetServerAddress(GetConvar('voice_externalAddress', ''), GetConvarInt('voice_externalPort', 0))
		while not MumbleIsConnected() do
			Wait(250)
		end
	end
    --NetworkSetVoiceChannel(newGrid + 100)
	NetworkClearVoiceChannel()
	NetworkSessionVoiceLeave()
	Wait(50)
	NetworkSetVoiceActive(false)
	MumbleClearVoiceTarget(2)
	Wait(1000)
	MumbleSetVoiceTarget(2)
	NetworkSetVoiceActive(true)
    --updateZone(true)
end)

if gameVersion == 'redm' then
	CreateThread(function()
		while true do
			if IsControlJustPressed(0, 0xA5BDCD3C --[[ Right Bracket ]]) then
				ExecuteCommand('cycleproximity')
			end
			if IsControlJustPressed(0, 0x430593AA --[[ Left Bracket ]]) then
				ExecuteCommand('+radiotalk')
			elseif IsControlJustReleased(0, 0x430593AA --[[ Left Bracket ]]) then
				ExecuteCommand('-radiotalk')
			end

			Wait(0)
		end
	end)
end
