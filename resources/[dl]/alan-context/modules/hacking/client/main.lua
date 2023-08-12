local IsHacking = false

AddEventHandler('esx:nui_ready', function()
  CreateFrame('hacking', 'nui://' .. GetCurrentResourceName() .. '/modules/hacking/data/html/ui.html')
end)

AddEventHandler('open:minigame', function(callback)
    Callbackk = callback
    openHack()
end)

function OpenHackingGame(callback)
    Callbackk = callback
    openHack()
end

RegisterNUICallback('callback', function(data, cb)
    closeHack()
    Callbackk(data.success)
    cb('ok')
end)

function openHack()
    FocusFrame('hacking', true, true)
    SendFrameMessage('hacking', {
		action = "open"
	})
    IsHacking = true
end

function closeHack()
    SetNuiFocus(false, false)
    IsHacking = false
end

function GetHackingStatus()
    return IsHacking
end