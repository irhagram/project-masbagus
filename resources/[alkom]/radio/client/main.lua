local PlayerData = {}
local radioChannel = nil

Citizen.CreateThread(function()


    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local vol = 30
local GuiOpened = false

RegisterNetEvent('radioGui')
AddEventHandler('radioGui', function()
    openGui()
end)

RegisterNetEvent('radio:closeAllChannel')
AddEventHandler('radio:closeAllChannel', function()
    exports['pma-voice']:removePlayerFromRadio()
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)

    if GuiOpened then 
        GuiOpened = false
        SetNuiFocus(false,false)
        SendNUIMessage({open = false})
        toggleRadioAnimation()
    end
end)

function openGui()
    local radio = hasRadio()
    toggleRadioAnimation(true)

    if not GuiOpened and radio then
        GuiOpened = true
        SetNuiFocus(false,false)
        SetNuiFocus(true,true)
        SendNUIMessage({open = true, jobType = ESX.PlayerData.job.name})
    else
        GuiOpened = false
        SetNuiFocus(false,false)
        SendNUIMessage({open = false, jobType = ESX.PlayerData.job.name})
    end
end

function hasRadio()
    if (exports['midp-core']:itemCount('radio') > 0)then
        return true
    else
        return false
    end
end

local function formattedChannelNumber(number)
    local power = 10 ^ 1
    return math.floor(number * power) / power
end

RegisterNUICallback('click', function(data, cb)
    PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    cb('ok')
end)

RegisterNUICallback('volumeUp', function(data, cb)
  local volume = exports["pma-voice"]:getRadioVolume() * 100
  local newvol = volume + 10
  if volume < 90 then
    exports["pma-voice"]:setRadioVolume(newvol)
    exports['midp-tasknotify']:SendAlert('inform', 'Volume: ' .. newvol, 1000)
  end
  cb('ok')
end)

RegisterNUICallback('volumeDown', function(data, cb)
  local volume = exports["pma-voice"]:getRadioVolume() * 100
  local newvol = volume- 10
  if volume > 10 then
    exports["pma-voice"]:setRadioVolume(newvol)
    exports['midp-tasknotify']:SendAlert('inform', 'Volume: ' .. newvol, 1000)
  end
  cb('ok')
end)


RegisterNUICallback('cleanClose', function(data, cb)
    TriggerEvent("InteractSound_CL:PlayOnOne","radioclick",0.6)
    GuiOpened = false
    SetNuiFocus(false,false)
    SendNUIMessage({open = false})
    toggleRadioAnimation()
end)

RegisterNUICallback('close', function(data, cb)
    TriggerEvent("InteractSound_CL:PlayOnOne","radioclick",0.6)
    local ruwetcokk = tonumber(data.channel)
    if ruwetcokk == nil then ruwetcokk = 0 end

    if ruwetcokk == 0 then
        exports['midp-tasknotify']:SendAlert('error', 'Tidak Ada Aksess!', 5000)
        exports['pma-voice']:removePlayerFromRadio()
        exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
    else
        radioChannel = ruwetcokk
        exports['pma-voice']:addPlayerToRadio(radioChannel)
        exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
        exports['midp-tasknotify']:SendAlert('inform', 'Join radio: ' .. radioChannel, 5000)
    end

    GuiOpened = false
    SetNuiFocus(false,false)
    SendNUIMessage({open = false})
    toggleRadioAnimation()
end)

RegisterNUICallback('poweredOn', function(data, cb)
    local ruwetcokk = tonumber(data.channel)
    if ruwetcokk == nil then
        ruwetcokk = 0
    end

    exports['midp-tasknotify']:SendAlert('inform', 'Radio On!', 5000)
    exports['pma-voice']:addPlayerToRadio(ruwetcokk)
    exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
end)

RegisterNUICallback('poweredOff', function(data, cb)
    exports['pma-voice']:removePlayerFromRadio()
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
    exports['midp-tasknotify']:SendAlert('error', 'Radio Off!', 5000)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if GuiOpened then      
            DisableControlAction(0, 1, GuiOpened) -- LookLeftRight
            DisableControlAction(0, 2, GuiOpened) -- LookUpDown
            DisableControlAction(0, 14, GuiOpened) -- INPUT_WEAPON_WHEEL_NEXT
            DisableControlAction(0, 15, GuiOpened) -- INPUT_WEAPON_WHEEL_PREV
            DisableControlAction(0, 16, GuiOpened) -- INPUT_SELECT_NEXT_WEAPON
            DisableControlAction(0, 17, GuiOpened) -- INPUT_SELECT_PREV_WEAPON
            DisableControlAction(0, 99, GuiOpened) -- INPUT_VEH_SELECT_NEXT_WEAPON
            DisableControlAction(0, 100, GuiOpened) -- INPUT_VEH_SELECT_PREV_WEAPON
            DisableControlAction(0, 115, GuiOpened) -- INPUT_VEH_FLY_SELECT_NEXT_WEAPON
            DisableControlAction(0, 116, GuiOpened) -- INPUT_VEH_FLY_SELECT_PREV_WEAPON
            DisableControlAction(0, 142, GuiOpened) -- MeleeAttackAlternate
            DisableControlAction(0, 106, GuiOpened) -- VehicleMouseControlOverride
        else
            Citizen.Wait(1000)
        end    
    end
end)

local Handle = 0

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(1)
    end

    RequestModel('prop_cs_hand_radio')
    while not HasModelLoaded(GetHashKey('prop_cs_hand_radio')) do
        Citizen.Wait(1)
    end
end

function toggleRadioAnimation(enable)
    loadAnimDict('cellphone@')
    local playerPed = PlayerPedId()

    if enable then 
        RequestModel('prop_cs_hand_radio')
        while not HasModelLoaded(GetHashKey('prop_cs_hand_radio')) do
            Citizen.Wait(1)
        end
        Handle = CreateObject(GetHashKey('prop_cs_hand_radio'), 0.0, 0.0, 0.0, true, true, false)
        local bone = GetPedBoneIndex(playerPed, 28422)
        SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
        AttachEntityToEntity(Handle, playerPed, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, false, false, false, 2, true)
        SetModelAsNoLongerNeeded(Handle)
        TaskPlayAnim(playerPed, 'cellphone@', 'cellphone_text_in', 4.0, -1, -1, 50, 0, false, false, false)
    else
        NetworkRequestControlOfEntity(Handle)
        TaskPlayAnim(playerPed, 'cellphone@', 'cellphone_text_out', 4.0, -1, -1, 50, 0, false, false, false)
        DeleteEntity(Handle)
        Handle = 0
        Citizen.Wait(250)
        ClearPedSecondaryTask(playerPed)
    end
end