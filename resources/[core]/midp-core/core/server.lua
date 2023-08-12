RegisterServerEvent('midp-core:bayardong')
AddEventHandler('midp-core:bayardong', function(price)
	local xPlayer  = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() > price then
        xPlayer.removeMoney(price)
        TriggerClientEvent('midp-tasknotify', source, "SYSTEM", 'Kamu membayar $JN' .. price, 5000, 'error')
    else
        TriggerClientEvent('midp-tasknotify', source, "SYSTEM", 'Uang kamu tidak cukup', 5000, 'error')
    end
end)

--AlanMASAK--
RegisterServerEvent('midp-core:cekKebutuhan')
AddEventHandler('midp-core:cekKebutuhan', function(itemId)
	local rendy = source
	local xPlayer = ESX.GetPlayerFromId(rendy)
	local getPlayerInv = xPlayer.getInventoryItem()
	local requiredItems = Config.ItemsCrafting[itemId].requiredItems
	local canCraft = false
	
	for k,v in pairs(requiredItems) do
		if xPlayer.getInventoryItem(v.item).count >= v.amount then
			canCraft = true
		else
			canCraft = false
			break
		end
	end
	
	if canCraft then
		TriggerClientEvent('midp-core:mulaiBuat', xPlayer.source, itemId)
	else
			TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Cukup Bahan!', length = 5000 })
	end
end)

RegisterServerEvent('midp-core:giveCraftedItem')
AddEventHandler('midp-core:giveCraftedItem', function(itemId, type)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local requiredItems = Config.ItemsCrafting[itemId].requiredItems
	local jumlahitem = Config.ItemsCrafting[itemId].jumlahnya
	for k,v in pairs(requiredItems) do
		xPlayer.removeInventoryItem(v.item, v.amount)
	end

	if Config.ItemsCrafting[itemId].SuccessRate > math.random(0, Config.ItemsCrafting[itemId].SuccessRate) then
		if Config.ItemsCrafting[itemId].isWeapon then
			xPlayer.addWeapon(itemId, jumlahnya)
		else
			xPlayer.addInventoryItem(itemId, jumlahitem)
		end
		TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'inform', text = "Kamu Berhasil Mengcrafting ", length = 5000 })
	else
		TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'UPS! Kamu Gagal Mengcrafting', length = 5000 })
	end
end)

RegisterNetEvent('midp-core:jualitem', function()
    local source = source
    local price = 0
    local xPlayer = ESX.GetPlayerFromId(source)
    for k,v in pairs(Config.JualItem) do 
        local item = xPlayer.getInventoryItem(k)
        if item and item.count >= 1 then
            price = price + (v * item.count)
            xPlayer.removeInventoryItem(k, item.count)
        end
    end
    if price > 0 then
        xPlayer.addMoney(price)
        TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Berhasil Menjual', length = 5000 })
    else
        TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Cukup Barang!', length = 5000 })
    end
end)