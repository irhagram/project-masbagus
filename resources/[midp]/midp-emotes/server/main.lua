local function EmoteMenuPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'
    print(('^5[midp-emotes]%s %s^7'):format(color, log))
end

RegisterNetEvent('midp-emotes:requestSynchronizedEmote', function(target, senderData, targetData)
    local src = source
    if senderData.SkipRequest then
        local senderPed, targetPed = GetPlayerPed(src), GetPlayerPed(target)
        local distance = #(GetEntityCoords(senderPed) - GetEntityCoords(targetPed))
        if distance < 5 then
            TriggerClientEvent('midp-emotes:targetStartSynchronizedEmote', target, src, senderData, targetData)
            TriggerClientEvent('midp-emotes:senderStartSynchronizedEmote', src, target, senderData)
        end
        return
    end
    TriggerClientEvent('midp-emotes:synchronizedEmoteRequest', target, src, senderData, targetData)
end)

RegisterNetEvent('midp-emotes:synchronizedEmoteResponse', function(sender, senderData, targetData)
    local src = source
    local senderPed, targetPed = GetPlayerPed(sender), GetPlayerPed(src)
    local distance = #(GetEntityCoords(senderPed) - GetEntityCoords(targetPed))
    if distance < 5 then
        TriggerClientEvent('midp-emotes:targetStartSynchronizedEmote', src, sender, senderData, targetData)
        TriggerClientEvent('midp-emotes:senderStartSynchronizedEmote', sender, src, senderData)
    end
end)

RegisterNetEvent('midp-emotes:cancelSynchronizedEmote', function(target)
    TriggerClientEvent('midp-emotes:cancelSynchronizedEmote', target)
end)

RegisterNetEvent('midp-emotes:syncPtfx', function(asset, name, placement, color)
    if (type(asset) ~= 'string') or (type(name) ~= 'string') or (type(placement) ~= 'table') then
        EmoteMenuPrint('error', 'Invalid arguments for PTFX.')
        return
    end

    local src = source
    local playerState = Player(src).state
    playerState:set('ptfxAsset', asset, true)
    playerState:set('ptfxName', name, true)
    playerState:set('ptfxOffset', placement[1], true)
    playerState:set('ptfxRot', placement[2], true)
    playerState:set('ptfxScale', placement[3], true)
    playerState:set('ptfxColor', color, true)
    playerState:set('ptfxPropNet', false, true)
    playerState:set('ptfx', false, true)
end)

RegisterNetEvent('midp-emotes:syncProp', function(propNet)
    local src = source
    if propNet then
        local doesExist = false
        for i = 1, 5000 do
			Wait(0)
			if DoesEntityExist(NetworkGetEntityFromNetworkId(propNet)) then
				doesExist = true
                break
			end
		end
        if doesExist then
            Player(src).state:set('ptfxPropNet', propNet, true)
        end
    end
end)