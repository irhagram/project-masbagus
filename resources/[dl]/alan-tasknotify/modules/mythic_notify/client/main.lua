AddEventHandler('esx:nui_ready', function()
    CreateFrame('mythic_notify', 'nui://' .. GetCurrentResourceName() .. '/modules/mythic_notify/data/html/ui.html')
end)

RegisterNetEvent('alan-tasknotify:client:SendAlert')
AddEventHandler('alan-tasknotify:client:SendAlert', function(data)
	SendAlert(data.type, data.text, data.length, data.style)
end)

RegisterNetEvent('alan-tasknotify:client:DoHudText')
AddEventHandler('alan-tasknotify:client:DoHudText', function(data)
	DoHudText(data.type, data.text, data.length, data.style)
end)

RegisterNetEvent('alan-tasknotify:client:DoCustomHudText')
AddEventHandler('alan-tasknotify:client:DoCustomHudText', function(data)
	DoCustomHudText(data.type, data.text, data.length, data.style)
end)

RegisterNetEvent('alan-tasknotify:client:DoShortHudText')
AddEventHandler('alan-tasknotify:client:DoShortHudText', function(data)
	DoShortHudText(data.action, data.id, data.type, data.text, data.style)
end)

RegisterNetEvent('alan-tasknotify:client:SendUniqueAlert')
AddEventHandler('alan-tasknotify:client:SendUniqueAlert', function(data)
	SendUniqueAlert(data.id, data.type, data.text, data.length, data.style)
end)


RegisterNetEvent('mythic_notify:client:PersistentAlert')
AddEventHandler('mythic_notify:client:PersistentAlert', function(data)
	PersistentAlert(data.action, data.id, data.type, data.text, data.style)
end)


function SendAlert(type, text, length, style)
	SendFrameMessage('mythic_notify',{
		type = type,
		text = text,
		length = length,
		style = style
	})
end

function DoHudText(type, text, length, style)
	SendFrameMessage('mythic_notify',{
		type = type,
		text = text,
		length = length,
		style = style
	})
end

function DoCustomHudText(type, text, length, style)
	SendFrameMessage('mythic_notify',{
		type = type,
		text = text,
		length = length,
		style = style
	})
end

function DoShortHudText(type, text, length, style)
	SendFrameMessage('mythic_notify',{
		type = type,
		text = text,
		length = length,
		style = style
	})
end

function SendUniqueAlert(id, type, text, length, style)
	SendFrameMessage('mythic_notify',{
		id = id,
		type = type,
		text = text,
		style = style
	})
end

function PersistentAlert(action, id, type, text, style)
	if action:upper() == 'START' then
		SendFrameMessage('mythic_notify',{
			persist = action,
			id = id,
			type = type,
			text = text,
			style = style
		})
	elseif action:upper() == 'END' then
		SendFrameMessage('mythic_notify',{
			persist = action,
			id = id
		})
	end
end