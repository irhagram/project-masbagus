AddEventHandler('esx:nui_ready', function()
  CreateFrame('textui', 'nui://' .. GetCurrentResourceName() .. '/modules/textui/data/html/ui.html')
end)

function Open(message, color, position)
	SendFrameMessage('textui',{
        action = 'open',
		message = message,
		color = color,
		position = position,
    })
end

function Close()
	SendFrameMessage('textui',{
        action = 'close'
    })
end

RegisterNetEvent('alan-tasknotify:Open')
AddEventHandler('alan-tasknotify:Open', function(message, color, position)
	Open(message, color, position)
end)

RegisterNetEvent('alan-tasknotify:Close')
AddEventHandler('alan-tasknotify:Close', function()
	Close()
end)