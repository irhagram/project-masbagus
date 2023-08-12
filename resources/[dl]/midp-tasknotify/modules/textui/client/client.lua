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

RegisterNetEvent('midp-tasknotify:Open')
AddEventHandler('midp-tasknotify:Open', function(message, color, position)
	Open(message, color, position)
end)

RegisterNetEvent('midp-tasknotify:Close')
AddEventHandler('midp-tasknotify:Close', function()
	Close()
end)