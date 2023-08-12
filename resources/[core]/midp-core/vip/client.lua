local vip, level, wesentek

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            TriggerServerEvent('alan-vip:server:spawn')
            break
        end
    end
end)

RegisterNetEvent('alan-vip:spawn')
AddEventHandler('alan-vip:spawn', function(data)
	vip = data.vip
	level = data.level
	wesentek = data.expiration
end)

RegisterCommand('cekvip', function()
	if isVIP() then
		exports['midp-tasknotify']:SendAlert('success', 'Prime Status Anda Aktif Sampai: '..wesentek)
		exports['midp-tasknotify']:SendAlert('success', 'Level Anda: '..level)
	else
		exports['midp-tasknotify']:SendAlert('error', 'Anda Tidak Masuk Prime')
	end
end)

function isVIP()
	return vip
end

function Level()
	return level
end

exports("isVIP", isVIP)
exports("Level", Level)