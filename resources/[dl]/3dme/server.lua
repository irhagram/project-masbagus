AddEventHandler("playerDropped", function(reason)
    local crds = GetEntityCoords(GetPlayerPed(source))
    local id = source
    local identifier = GetPlayerIdentifier(source)
    TriggerClientEvent("3dme:playerDropped", -1, id, crds, identifier, reason)
end)

RegisterServerEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text)
	TriggerClientEvent('3dme:triggerDisplay', -1, text, source)
end)

RegisterServerEvent('3ddo:shareDisplay')
AddEventHandler('3ddo:shareDisplay', function(text)
	TriggerClientEvent('3ddo:triggerDisplay', -1, text, source)
end)