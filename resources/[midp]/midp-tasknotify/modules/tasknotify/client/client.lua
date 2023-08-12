AddEventHandler('esx:nui_ready', function()
  CreateFrame('tasknotify', 'nui://' .. GetCurrentResourceName() .. '/modules/tasknotify/data/html/ui.html')
end)

function Alert(title, message, time, type)
	SendFrameMessage('tasknotify', {
		action = 'open',
		title = title,
		type = type,
		message = message,
		time = time,
	})
end

RegisterNetEvent('midp-tasknotify:Alert')
AddEventHandler('midp-tasknotify:Alert', function(title, message, time, type)
	Alert(title, message, time, type)
end)