BuatFrame = function(name, url, visible)
  visible = (visible == nil) and true or false
  SendNUIMessage({action = 'create_frame', name = name, url = url, visible = visible})
end

KirimFrameMessage = function(name, msg)
  SendNUIMessage({target = name, data = msg})
end

PokusFrame = function(name, cursor)
  SendNUIMessage({action = 'focus_frame', name = name})
  SetNuiFocus(true, cursor)
end

RegisterNUICallback('nui_ready', function(data, cb)
  TriggerEvent('esx:nui_ready')
  cb('')
end)

RegisterNUICallback('frame_message', function(data, cb)
  TriggerEvent('esx:frame_message', data.name, data.msg, data.cb)
  cb('')
end)