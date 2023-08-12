ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("alan-core:keluarKau")
AddEventHandler("alan-core:keluarKau", function(reason)
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

RegisterServerEvent('alan-data:sync')
AddEventHandler('alan-data:sync', function(id, tireIndex)
	TriggerClientEvent('alan-data:sync', id, tireIndex)
end)