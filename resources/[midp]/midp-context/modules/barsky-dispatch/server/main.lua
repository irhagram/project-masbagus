

RegisterServerEvent('dispatch:svNotify')
AddEventHandler('dispatch:svNotify', function(data)
    TriggerClientEvent('dispatch:clNotify',-1,data)
end)

