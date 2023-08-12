AddEventHandler('esx:nui_ready', function()
    CreateFrame('alan-context', 'nui://' .. GetCurrentResourceName() .. '/modules/alan-context/data/html/ui.html')
end)

RegisterNUICallback("dataPost", function(data, cb)
    FocusFrame('alan-context', true, true)
    TriggerEvent(data.event, data.args, data.arg2, data.arg3)
    cb('ok')
end)

RegisterNUICallback("cancel", function()
    FocusFrame('alan-context', true, true)
end)


RegisterNetEvent('alan-context:sendMenu', function(data)
    if not data then return end
    FocusFrame('alan-context', true, true)
    SendFrameMessage('alan-context', {
        action = "OPEN_MENU",
        data = data
    })
end)
