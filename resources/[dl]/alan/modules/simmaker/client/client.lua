local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                           = nil


AddEventHandler('esx:nui_ready', function()
    CreateFrame('simmaker', 'nui://' .. GetCurrentResourceName() .. '/modules/simmaker/data/html/ui.html')
end)

PlayerData = {}

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)

        Citizen.Wait(5)
    end
    if ESX.IsPlayerLoaded() then
        PlayerData = ESX.GetPlayerData()
        Citizen.Wait(500)
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
    PlayerData = response

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('cek:loadLicenses')
AddEventHandler('cek:loadLicenses', function(licenses)
  Licenses = licenses
end)

RegisterNetEvent('dl-polisi:buatsim')
AddEventHandler('dl-polisi:buatsim', function()
    if PlayerData.job.name == 'police' then
        OpenDrivingLicenseMenu()
    end
end)

--[[RegisterCommand('dapit', function ()
    OpenDrivingLicenseMenu()
end)]]

function OpenDrivingLicenseMenu()
    Citizen.Wait(1000)
    ExecuteCommand('e clipboard')
    SendFrameMessage('simmaker', {
        action = "simmaker:open_menu",
        type = "license"
    })
    FocusFrame('simmaker', true, true)
end

RegisterNUICallback('simmaker:CloseMenu' , function(data, cb)
    SetNuiFocus(false , false)
    ExecuteCommand('e c')
    SendFrameMessage('simmaker', {
        action = "simmaker:close_menu",
        type = "license"
    })
    cb('ok')
end)


RegisterNUICallback('simmaker:getDataCivilian' , function(data, cb)
    ESX.TriggerServerCallback('simmaker:cancel' , function(result)
        if #result == 0 then
            exports['alan-tasknotify']:DoHudText('error', 'ID Tidak ditemukkan')
        else
            exports['alan-tasknotify']:DoHudText('success', 'ID ditemukkan')
        end
        if PlayerData.job.name == 'police' then
            result[1].job = 'WARGA'
        elseif PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'taxi' or PlayerData.job.name == 'pedagang' or PlayerData.job.name == 'mechanic' then
            result[1].job = 'WARGA'
        else
            result[1].job = 'WARGA'
        end
        SendFrameMessage('simmaker', {
            action = 'simmaker:license_civ_data',
            data = result,
            type = 'license',
        })
    end, tonumber(data.id))
    cb('ok')
end)

RegisterNUICallback('simmaker:CreateLicense' , function(data, cb)
    ESX.TriggerServerCallback('simmaker:add', function(status)
        if status then
            exports['alan-tasknotify']:DoHudText('success', 'Sukses membuatkan lisensi')
        else
            cb(false)
        end
    end, data.id, data.type, data.date_expired)

    cb('ok')
end)







