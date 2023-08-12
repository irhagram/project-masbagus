
RegisterServerEvent('esx-qalle-hunting:reward')
AddEventHandler('esx-qalle-hunting:reward', function(Weight)
    local xPlayer = ESX.GetPlayerFromId(source)

    if Weight >= 1 then
        xPlayer.addInventoryItem('meat', 5)
    elseif Weight >= 9 then
        xPlayer.addInventoryItem('meat', 7)
    elseif Weight >= 15 then
        xPlayer.addInventoryItem('meat', 10)
    end

    xPlayer.addInventoryItem('leather', math.random(5, 8))
        
end)

RegisterServerEvent('esx-qalle-hunting:sell')
AddEventHandler('esx-qalle-hunting:sell', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    local MeatPrice = 150
    local LeatherPrice = 500

    local MeatQuantity = xPlayer.getInventoryItem('meat').count
    local LeatherQuantity = xPlayer.getInventoryItem('leather').count

    if MeatQuantity > 9 or LeatherQuantity > 9 then
        xPlayer.addMoney(MeatQuantity * MeatPrice)
        xPlayer.addMoney(LeatherQuantity * LeatherPrice)

        xPlayer.removeInventoryItem('meat', MeatQuantity)
        xPlayer.removeInventoryItem('leather', LeatherQuantity)
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'You sold ' .. LeatherQuantity + MeatQuantity .. ' and earned $' .. LeatherPrice * LeatherQuantity + MeatPrice * MeatQuantity)
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'You don\'t have any meat or leather')
    end
        
end)

function sendNotification(xsource, message, messageType, messageTimeout)
    TriggerClientEvent('notification', xsource, message)
end