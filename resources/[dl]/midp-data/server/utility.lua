ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("midp-core:keluarKau")
AddEventHandler("midp-core:keluarKau", function(reason)
	DropPlayer(source, reason)
end)

-- Bullet-Proof Vest
ESX.RegisterUsableItem('armor', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('alan-toollkit:bulletproof', source)
    xPlayer.removeInventoryItem('armor', 1)
end)

ESX.RegisterUsableItem('rompik', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('alan-toolkit:rompik', source)
    xPlayer.removeInventoryItem('rompik', 1)
end)

ESX.RegisterUsableItem('megaphone', function(source)
    TriggerClientEvent("megaphone:Toggle",source)
end)

RegisterServerEvent('deleteitem')
AddEventHandler('deleteitem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(item, count)
end)

ESX.RegisterUsableItem('toolkit', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('alan-toolkit:onUse', _source)
end)

RegisterNetEvent('alan-toolkit:removeKit')
AddEventHandler('alan-toolkit:removeKit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('toolkit', 1)
end)

RegisterServerEvent('midp-data:sync')
AddEventHandler('midp-data:sync', function(id, tireIndex)
	TriggerClientEvent('midp-data:sync', id, tireIndex)
end)