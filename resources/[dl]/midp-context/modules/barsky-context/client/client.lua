AddEventHandler('esx:nui_ready', function()
    CreateFrame('midp-context', 'nui://' .. GetCurrentResourceName() .. '/modules/midp-context/data/html/ui.html')
end)

RegisterNUICallback("dataPost", function(data, cb)
    FocusFrame('midp-context', true, true)
    TriggerEvent(data.event, data.args, data.arg2, data.arg3)
    cb('ok')
end)

RegisterNUICallback("cancel", function()
    FocusFrame('midp-context', true, true)
end)


RegisterNetEvent('midp-context:sendMenu', function(data)
    if not data then return end
    FocusFrame('midp-context', true, true)
    SendFrameMessage('midp-context', {
        action = "OPEN_MENU",
        data = data
    })
end)
