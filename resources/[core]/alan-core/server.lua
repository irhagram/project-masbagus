ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function removeItem(src, item, count, metadata)
    if (src == nil) then src = source end
    if (src == nil) then return end

    if (Config.OxInventory) then
        exports.ox_inventory:RemoveItem(src, item, count, metadata)
    else 
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.removeInventoryItem(item, count)
    end
end

exports('removeItem', removeItem)

RegisterServerEvent('alan-core:removeItem')
AddEventHandler('alan-core:removeItem', function(src, item, count, metadata)
    removeItem(src, item, count, metadata)
end)

function addItem(source, item, count, metadata)
    if (source == nil) then return end
    if (Config.OxInventory) then
        local Inventory = exports.ox_inventory
        local canCarryItem = Inventory:CanCarryItem(source, item, count)
        if (canCarryItem) then
            Inventory:AddItem(source, item, count, metadata)
            return true
        else
            TriggerClientEvent('alan-core:Notify', source, 'error', 'You cannot carry this item')
            return false
        end
    else
        if (xPlayer.canCarryItem(item, count)) then
            xPlayer.addInventoryItem(item, count)
            return true
        else
            TriggerClientEvent('alan-core:Notify', source, 'error', 'You cannot carry this item')
            return false
        end
    end
end
exports('addItem', addItem)

AddEventHandler('alan-core:addItem', function(item, count)
    return addItem(source, item, count)
end)

function itemCount(source, item, metadata)
    if (source == nil) then return end
    if (Config.OxInventory) then
        local itemCount = exports.ox_inventory:Search(source, 'count', item, metadata)
        if (itemCount == nil) then itemCount = 0 end
		return itemCount
	else
		local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getInventoryItem(item).count
	end
end

exports('sv_itemCount', itemCount)
ESX.RegisterServerCallback('alan-core:itemCountCb', function(source, cb, item, metadata)
    cb(itemCount(source, item, metadata))
end)

RegisterServerEvent('alan-core:sv_itemCount')
AddEventHandler('alan-core:sv_itemCount', function(source, item, metadata)
    return itemCount(source, item, metadata)
end)

function canHoldItem(source, item, count)
    if (source == nil) then return end
    if (Config.OxInventory) then
		return exports.ox_inventory:CanCarryItem(source, item, count)
	else
		local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.canCarryItem(item, count)
	end
end

exports('sv_canHoldItem', canHoldItem)

ESX.RegisterServerCallback('alan-core:canHoldItem', function(source, cb, item, count)
    cb(canHoldItem(source, item, count))
end)

RegisterServerEvent('alan-core:sv_canHoldItem')
AddEventHandler('alan-core:sv_canHoldItem', function(source, item, count)
    return canHoldItem(source, item, count)
end)

RegisterServerEvent('alan-core:AddToInstance')
AddEventHandler('alan-core:AddToInstance', function(source, instanceId)
    SetPlayerRoutingBucket(source, instanceId)
        if (instanceId == 0) then return end
    SetRoutingBucketEntityLockdownMode(instanceId, 'strict')
    SetRoutingBucketPopulationEnabled(instanceId, false)
end)

RegisterServerEvent('alan-core:RemoveFromInstance')
AddEventHandler('alan-core:RemoveFromInstance', function(source)
    if (GetPlayerRoutingBucket(source) ~= 0) then TriggerEvent('alan-core:AddToInstance', source, 0) end
end)

ESX.RegisterServerCallback('alan-core:illegalTaskBlacklist', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = Config.IllegalTaskBlacklist[xPlayer.job.name] == true and true or false
    cb(result)
end)

ESX.RegisterServerCallback('alan-core:cekJob', function(source, cb, job)
    cb(#ESX.GetExtendedPlayers('job', job))
end)