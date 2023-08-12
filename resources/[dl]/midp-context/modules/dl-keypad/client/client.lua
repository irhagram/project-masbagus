AddEventHandler('esx:nui_ready', function()
    CreateFrame('dl-keypad', 'nui://' .. GetCurrentResourceName() .. '/modules/dl-keypad/data/html/ui.html')
end)

local p = nil

RegisterNUICallback("dataPost", function(data, cb)
    SetNuiFocus(false)
    p:resolve(data.data)
    p = nil
    cb("ok")
end)

RegisterNUICallback("cancel", function(data, cb)
    SetNuiFocus(false)
    p:resolve(nil)
    p = nil
    cb("ok")
end)

function KeyboardInput(data)
    Wait(150)
    if not data then return end
    if p then return end
    
    p = promise.new()

    FocusFrame('dl-keypad', true, true)
    SendFrameMessage('dl-keypad', {
        action = "OPEN_MENU",
        data = data
    })

    return Citizen.Await(p)
end

exports("KeyboardInput", KeyboardInput)