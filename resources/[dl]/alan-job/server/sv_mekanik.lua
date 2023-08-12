ESX                = nil
PlayersHarvesting  = {}
PlayersHarvesting2 = {}
PlayersHarvesting3 = {}
PlayersCrafting    = {}
PlayersCrafting2   = {}
PlayersCrafting3   = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MekanikMaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'mechanic', Config.MekanikMaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'mechanic', _U('mechanic_customer'), true, true)
TriggerEvent('esx_society:registerSociety', 'mechanic', 'mechanic', 'society_mechanic', 'society_mechanic', 'society_mechanic', {type = 'private'})

local stashes = {
	{
		-- Police stash
		id = 'brankas_mekanik',
		label = 'BRANKAS MEKANIK',
		slots = 100,
		weight = 600000,
		owner = false,
		jobs = 'mechanic'
	},
}

AddEventHandler('onServerResourceStart', function(resourceName)
	local GetCurrentResourceName = GetCurrentResourceName()
	local ox_inventory = exports.ox_inventory
	if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName then
		for i=1, #stashes do
			local stash = stashes[i]
			ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight, stash.owner, stash.jobs)
		end
	end
end)

local function Harvest(source)
	SetTimeout(4000, function()

		if PlayersHarvesting[source] == true then
			local xPlayer = ESX.GetPlayerFromId(source)
			local GazBottleQuantity = xPlayer.getInventoryItem('gazbottle').count

			if GazBottleQuantity >= 5 then
				TriggerClientEvent('esx:showNotification', source, _U('you_do_not_room'))
			else
				xPlayer.addInventoryItem('gazbottle', 1)
				Harvest(source)
			end
		end

	end)
end

RegisterServerEvent('jn-mekanik:startHarvest')
AddEventHandler('jn-mekanik:startHarvest', function()
	local _source = source
	PlayersHarvesting[_source] = true
	TriggerClientEvent('esx:showNotification', _source, _U('recovery_gas_can'))
	Harvest(source)
end)

RegisterServerEvent('jn-mekanik:stopHarvest')
AddEventHandler('jn-mekanik:stopHarvest', function()
	local _source = source
	PlayersHarvesting[_source] = false
end)

local function Harvest2(source)
	SetTimeout(4000, function()

		if PlayersHarvesting2[source] == true then
			local xPlayer = ESX.GetPlayerFromId(source)
			local FixToolQuantity = xPlayer.getInventoryItem('fixtool').count

			if FixToolQuantity >= 5 then
				TriggerClientEvent('esx:showNotification', source, _U('you_do_not_room'))
			else
				xPlayer.addInventoryItem('fixtool', 1)
				Harvest2(source)
			end
		end

	end)
end

RegisterServerEvent('jn-mekanik:startHarvest2')
AddEventHandler('jn-mekanik:startHarvest2', function()
	local _source = source
	PlayersHarvesting2[_source] = true
	TriggerClientEvent('esx:showNotification', _source, _U('recovery_repair_tools'))
	Harvest2(_source)
end)

RegisterServerEvent('jn-mekanik:stopHarvest2')
AddEventHandler('jn-mekanik:stopHarvest2', function()
	local _source = source
	PlayersHarvesting2[_source] = false
end)

local function Harvest3(source)
	SetTimeout(4000, function()

		if PlayersHarvesting3[source] == true then
			local xPlayer = ESX.GetPlayerFromId(source)
			local CaroToolQuantity = xPlayer.getInventoryItem('carotool').count
			if CaroToolQuantity >= 5 then
				TriggerClientEvent('esx:showNotification', source, _U('you_do_not_room'))
			else
				xPlayer.addInventoryItem('carotool', 1)
				Harvest3(source)
			end
		end

	end)
end

ESX.RegisterUsableItem('kanebo', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('kanebo', 1)
	TriggerClientEvent('jn-mekanik:kanebo', source)

end)

RegisterServerEvent('jn-mekanik:startHarvest3')
AddEventHandler('jn-mekanik:startHarvest3', function()
	local _source = source
	PlayersHarvesting3[_source] = true
	TriggerClientEvent('esx:showNotification', _source, _U('recovery_body_tools'))
	Harvest3(_source)
end)

RegisterServerEvent('jn-mekanik:stopHarvest3')
AddEventHandler('jn-mekanik:stopHarvest3', function()
	local _source = source
	PlayersHarvesting3[_source] = false
end)

local function Craft(source)
	--TriggerClientEvent('startAnim', source)
	TriggerClientEvent('startProgbar', source, 4000, 'Merakit Nitro N05')
	SetTimeout(4000, function()

		if PlayersCrafting[source] == true then
			local xPlayer = ESX.GetPlayerFromId(source)
			local BahanQuantity = xPlayer.getInventoryItem('gazbottle').count
			local Bahan2Quantity = xPlayer.getInventoryItem('baut').count

			if BahanQuantity <= 4 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_gas_can'))
			elseif Bahan2Quantity <= 4 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_repair_tools'))
			else
				xPlayer.removeInventoryItem('gazbottle', 5)
				xPlayer.removeInventoryItem('baut', 5)
				xPlayer.addInventoryItem('nitro', 1)
				Craft(source)
			end

			TriggerClientEvent('stopProgbar', source)
			--TriggerClientEvent('stopAnim', source)
		end

	end)
end

RegisterServerEvent('jn-mekanik:startCraft')
AddEventHandler('jn-mekanik:startCraft', function()
	local _source = source
	PlayersCrafting[_source] = true
	TriggerClientEvent('esx:showNotification', _source, _U('assembling_blowtorch'))
	Craft(_source)
end)

RegisterServerEvent('jn-mekanik:stopCraft')
AddEventHandler('jn-mekanik:stopCraft', function()
	local _source = source
	PlayersCrafting[_source] = false
	TriggerClientEvent('stopProgbar', source)
	--TriggerClientEvent('stopAnim', source)
end)

local function Craft2(source)
	--TriggerClientEvent('startAnim', source)
	TriggerClientEvent('startProgbar', source, 4000, 'Membuat Repair Kit')
	SetTimeout(4000, function()

		if PlayersCrafting2[source] == true then
			local xPlayer = ESX.GetPlayerFromId(source)
			local BautQuantity = xPlayer.getInventoryItem('baut').count
			local BlowtorchQuantity = xPlayer.getInventoryItem('blowtorch').count

			if BautQuantity <= 4 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_repair_tools'))
			elseif BlowtorchQuantity <= 1 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_blowtorch'))
			else
				xPlayer.removeInventoryItem('baut', 5)
				xPlayer.removeInventoryItem('blowtorch', 2)
				xPlayer.addInventoryItem('fixkit', 1)
				Craft2(source)
			end
			TriggerClientEvent('stopProgbar', source)
			--TriggerClientEvent('stopAnim', source)
		end

	end)
end

RegisterServerEvent('jn-mekanik:startCraft2')
AddEventHandler('jn-mekanik:startCraft2', function()
	local _source = source
	PlayersCrafting2[_source] = true
	TriggerClientEvent('esx:showNotification', _source, _U('assembling_repair_kit'))
	Craft2(_source)
end)

RegisterServerEvent('jn-mekanik:stopCraft2')
AddEventHandler('jn-mekanik:stopCraft2', function()
	local _source = source
	PlayersCrafting2[_source] = false
	TriggerClientEvent('stopProgbar', source)
	--TriggerClientEvent('stopAnim', source)
end)

local function Craft3(source)
	--TriggerClientEvent('startAnim', source)
	TriggerClientEvent('startProgbar', source, 4000, 'Body Tool')
	SetTimeout(4000, function()

		if PlayersCrafting3[source] == true then
			local xPlayer = ESX.GetPlayerFromId(source)
			local CaroToolQuantity = xPlayer.getInventoryItem('carotool').count

			if CaroToolQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_body_tools'))
			else
				xPlayer.removeInventoryItem('carotool', 1)
				xPlayer.addInventoryItem('carokit', 1)
				-- Craft3(source)
			end
			TriggerClientEvent('stopProgbar', source)
			--TriggerClientEvent('stopAnim', source)
		end

	end)
end

RegisterServerEvent('jn-mekanik:startCraft3')
AddEventHandler('jn-mekanik:startCraft3', function()
	local _source = source
	PlayersCrafting3[_source] = true
	TriggerClientEvent('esx:showNotification', _source, _U('assembling_body_kit'))
	Craft3(_source)
end)

RegisterServerEvent('jn-mekanik:stopCraft3')
AddEventHandler('jn-mekanik:stopCraft3', function()
	local _source = source
	PlayersCrafting3[_source] = false
	TriggerClientEvent('stopProgbar', source)
	--TriggerClientEvent('stopAnim', source)
end)

RegisterServerEvent('jn-mekanik:onNPCJobMissionCompleted')
AddEventHandler('jn-mekanik:onNPCJobMissionCompleted', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total   = math.random(Config.MekanikNPCJobEarnings.min, Config.MekanikNPCJobEarnings.max);

	if xPlayer.job.grade >= 3 then
		total = total * 2
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
		account.addMoney(total)
	end)

	TriggerClientEvent("esx:showNotification", _source, _U('your_comp_earned').. total)
end)

RegisterServerEvent('jn-mekanik:belirepairkit')
AddEventHandler('jn-mekanik:belirepairkit', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == 'mechanic' then
        xPlayer.removeMoney(990)
        xPlayer.addInventoryItem('fixkit', 1)
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
            account.addMoney(990)
            
          end)
    else
        print(('jn-mekanik: %s berhasil membeli Perban!'):format(xPlayer.identifier))
    end
end)

RegisterServerEvent('jn-mekanik:belitoolkit')
AddEventHandler('jn-mekanik:belitoolkit', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == 'mechanic' then
        xPlayer.removeMoney(1190)
        xPlayer.addInventoryItem('repairkit', 1)
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
            account.addMoney(1190)
            
          end)
    else
        print(('jn-mekanik: %s berhasil membeli P3K!'):format(xPlayer.identifier))
    end
end)

RegisterServerEvent('jn-mekanik:belikanebo')
AddEventHandler('jn-mekanik:belikanebo', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == 'mechanic' then
        xPlayer.removeMoney(3000)
        xPlayer.addInventoryItem('kanebo', 1)
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
            account.addMoney(3000)
            
          end)
    else
        print(('jn-mekanik: %s berhasil membeli P3K!'):format(xPlayer.identifier))
    end
end)


RegisterServerEvent('jn-mekanik:stancerkit')
AddEventHandler('jn-mekanik:stancerkit', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == 'mechanic' then
        xPlayer.removeMoney(500000)
        xPlayer.addInventoryItem('stancerkit', 1)
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
            account.addMoney(500000)
            
          end)
    else
        print(('jn-mekanik: %s berhasil membeli P3K!'):format(xPlayer.identifier))
    end
end)

ESX.RegisterUsableItem('blowpipe', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('blowpipe', 1)

	TriggerClientEvent('jn-mekanik:onHijack', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('you_used_blowtorch'))
end)

ESX.RegisterUsableItem('fixkit', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('fixkit', 1)

	TriggerClientEvent('jn-mekanik:onFixkit', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('you_used_repair_kit'))
end)

ESX.RegisterUsableItem('carokit', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('carokit', 1)

	TriggerClientEvent('jn-mekanik:onCarokit', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('you_used_body_kit'))
end)

RegisterServerEvent('jn-mekanik:getStockItem')
AddEventHandler('jn-mekanik:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
		local item = inventory.getItem(itemName)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('player_cannot_hold'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', count, item.label))
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
		end
	end)
end)

ESX.RegisterServerCallback('jn-mekanik:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('jn-mekanik:putStockItems')
AddEventHandler('jn-mekanik:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
		local item = inventory.getItem(itemName)
		local playerItemCount = xPlayer.getInventoryItem(itemName).count

		if item.count >= 0 and count <= playerItemCount then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
		end

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, item.label))
	end)
end)

ESX.RegisterServerCallback('jn-mekanik:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({items = items})
end)

-- INVENTORY
RegisterServerEvent('dwk_Mechanic:getItem')
AddEventHandler('dwk_Mechanic:getItem', function(owner, type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	--[[ local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)
	local whitelisted, isWhitelist = {8, 9, 10, 11}, false
	local authorized, isAuthorize = {6, 7, 8, 9, 10, 11}, false
	
	for i, v in pairs(whitelisted) do
		if v == xPlayer.job.grade then
			isWhitelist = true
		end
	end

	for i, v in pairs(authorized) do
		if v == xPlayer.job.grade then
			isAuthorize = true
		end
	end

	if isWhitelist or isAuthorize then]]
		if type == 'item_standard' then

			local sourceItem = xPlayer.getInventoryItem(item)

			TriggerEvent('esx_addoninventory:getSharedInventory', "society_mechanic", function(inventory)
				local inventoryItem = inventory.getItem(item)

				-- is there enough in the property?
				if count > 0 and inventoryItem.count >= count then
				
					-- can the player carry the said amount of x item?
					if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
						TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
					else
						inventory.removeItem(item, count)
						xPlayer.addInventoryItem(item, count)
						TriggerClientEvent('notification', _source, _U('have_withdrawn', count, inventoryItem.label), 2)
						
						local time 		= os.date('%Y-%m-%d %H:%M')
						local steamID 	= string.gsub(xPlayer.identifier, "steam:", "")
						local steamURL	=	tonumber("0x"..steamID)
						local theURL	= "https://steamcommunity.com/profiles/"..steamURL
						local webhook 	= "https://canary.discordapp.com/api/webhooks/704814462808621188/mv22pPW9Pl3GCVNwoxZnSArpKXNW5KwLKuXRxhdIOtgIoG4yxl2G8Zcfrv1ayhHfopLF"
						local message 	= "**Waktu: "..time.."**\n```ID Steam Player : "..xPlayer.identifier.."\nNama Player     : "..xPlayer.name.." - "..xPlayer.job.label.."\nLink Player     : "..theURL.."\nMengambil Barang : " ..item.. "("..count..")\n```"
						TriggerEvent('DiscordBot:ToDiscord', webhook, "RI-LOG", message, "https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png", false)
						--PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
					end
				else
					TriggerClientEvent('esx:showNotification', _source, _U('not_enough_in_property'))
				end
			end)

		elseif type == 'item_account' then

			TriggerEvent('esx_addonaccount:getSharedAccount', "society_mechanic", function(account)
				local roomAccountMoney = account.money

				if roomAccountMoney >= count then
					account.removeMoney(count)
					xPlayer.addAccountMoney(item, count)
					TriggerClientEvent('notification', _source, _U('withdrawn_money', count), 2)
					
					local time 		= os.date('%Y-%m-%d %H:%M')
					local steamID 	= string.gsub(xPlayer.identifier, "steam:", "")
					local steamURL	=	tonumber("0x"..steamID)
					local theURL	= "https://steamcommunity.com/profiles/"..steamURL
					local webhook 	= "https://canary.discordapp.com/api/webhooks/704814462808621188/mv22pPW9Pl3GCVNwoxZnSArpKXNW5KwLKuXRxhdIOtgIoG4yxl2G8Zcfrv1ayhHfopLF"
					local message 	= "**Waktu: "..time.."**\n```ID Steam Player : "..xPlayer.identifier.."\nNama Player     : "..xPlayer.name.." - "..xPlayer.job.label.."\nLink Player     : "..theURL.."\nMengambil : " ..item.. " ($ "..count..")\n```"
					--PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
					TriggerEvent('DiscordBot:ToDiscord', webhook, "RI-LOG", message, "https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png", false)
				else
					TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
				end
			end)

		elseif type == 'item_weapon' then

			TriggerEvent('esx_datastore:getSharedDataStore', "society_mechanic", function(store)
				local storeWeapons = store.get('weapons') or {}
				local weaponName   = nil
				local ammo         = nil
				
				for i=1, #storeWeapons, 1 do
					if storeWeapons[i].name == item then
						weaponName = storeWeapons[i].name
						ammo       = storeWeapons[i].count
						
						table.remove(storeWeapons, i)
						break
					end
				end
				local weaponLabel = ESX.GetWeaponLabel(weaponName)

				TriggerClientEvent('notification', _source, _U('have_withdrawn', count, weaponLabel), 2)
				store.set('weapons', storeWeapons)
				xPlayer.addWeapon(weaponName, ammo)
				
				local time 		= os.date('%Y-%m-%d %H:%M')
				local steamID 	= string.gsub(xPlayer.identifier, "steam:", "")
				local steamURL	=	tonumber("0x"..steamID)
				local theURL	= "https://steamcommunity.com/profiles/"..steamURL
				local webhook 	= "https://canary.discordapp.com/api/webhooks/704814462808621188/mv22pPW9Pl3GCVNwoxZnSArpKXNW5KwLKuXRxhdIOtgIoG4yxl2G8Zcfrv1ayhHfopLF"
				local message 	= "**Waktu: "..time.."**\n```ID Steam Player : "..xPlayer.identifier.."\nNama Player     : "..xPlayer.name.." - "..xPlayer.job.label.."\nLink Player     : "..theURL.."\nMengambil Senjata : " ..weaponName.. " ("..ammo..")\n```"
				--PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
				TriggerEvent('DiscordBot:ToDiscord', webhook, "RI-LOG", message, "https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png", false)
			end)

		end
	--[[else
		xPlayer.triggerEvent("pNotify:SendNotification", {
            text = "Anda tidak mempunyai akses untuk melakukan hal itu", type = "error", queue = "inven_Mechanic", timeout = 2000, layout = "centerLeft"}
        )
	end]]
	xPlayer.triggerEvent("esx_inventoryhud:refreshMechanicInventory")
	xPlayer.triggerEvent("esx_inventoryhud:loadPlayerInventory")
end)

RegisterServerEvent('dwk_Mechanic:putItem')
AddEventHandler('dwk_Mechanic:putItem', function(owner, type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	-- local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

	if type == 'item_standard' then

		local xItem = xPlayer.getInventoryItem(item)
		local playerItemCount = xItem.count

		if playerItemCount >= count and count > 0 then
			TriggerEvent('esx_addoninventory:getSharedInventory', "society_mechanic", function(inventory)
				xPlayer.removeInventoryItem(item, count)
				inventory.addItem(item, count)
				TriggerClientEvent('notification', _source, _U('have_deposited', count, xItem.label), 2)
				
				local time 		= os.date('%Y-%m-%d %H:%M')
				local steamID 	= string.gsub(xPlayer.identifier, "steam:", "")
				local steamURL	=	tonumber("0x"..steamID)
				local theURL	= "https://steamcommunity.com/profiles/"..steamURL
				local webhook 	= "https://canary.discordapp.com/api/webhooks/704814462808621188/mv22pPW9Pl3GCVNwoxZnSArpKXNW5KwLKuXRxhdIOtgIoG4yxl2G8Zcfrv1ayhHfopLF"
				local message 	= "**Waktu: "..time.."**\n```ID Steam Player : "..xPlayer.identifier.."\nNama Player     : "..xPlayer.name.." - "..xPlayer.job.label.."\nLink Player     : "..theURL.."\nMenaruh : " ..inventory.getItem(item).label.. " (" ..count..")\n```"
				PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
			
			end)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
		end

	elseif type == 'item_account' then

		local playerAccountMoney = xPlayer.getAccount(item).money

		if playerAccountMoney >= count and count > 0 then
			xPlayer.removeAccountMoney(item, count)

            TriggerEvent('esx_addonaccount:getSharedAccount', "society_mechanic", function(account)
				account.addMoney(count)
			end)

			TriggerClientEvent('notification', _source, _U('deposited_money', count), 2)
			
			local time 		= os.date('%Y-%m-%d %H:%M')
			local steamID 	= string.gsub(xPlayer.identifier, "steam:", "")
			local steamURL	=	tonumber("0x"..steamID)
			local theURL	= "https://steamcommunity.com/profiles/"..steamURL
			local webhook 	= "https://canary.discordapp.com/api/webhooks/704814462808621188/mv22pPW9Pl3GCVNwoxZnSArpKXNW5KwLKuXRxhdIOtgIoG4yxl2G8Zcfrv1ayhHfopLF"
			local message 	= "**Waktu: "..time.."**\n```ID Steam Player : "..xPlayer.identifier.."\nNama Player     : "..xPlayer.name.." - "..xPlayer.job.label.."\nLink Player     : "..theURL.."\nMenaruh : " ..item.. " ($ " ..count..")\n```"
			PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
			
		else
			TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
		end

	elseif type == 'item_weapon' then

		TriggerEvent('esx_datastore:getSharedDataStore', "society_mechanic", function(store)
			local storeWeapons = store.get('weapons') or {}
			local weaponLabel = ESX.GetWeaponLabel(item)

			table.insert(storeWeapons, {
				name = item,
				count = count
			})

			store.set('weapons', storeWeapons)
			xPlayer.removeWeapon(item)
			TriggerClientEvent('notification', _source, _U('have_deposited', 1, weaponLabel), 2)
			
			local time 		= os.date('%Y-%m-%d %H:%M')
			local steamID 	= string.gsub(xPlayer.identifier, "steam:", "")
			local steamURL	=	tonumber("0x"..steamID)
			local theURL	= "https://steamcommunity.com/profiles/"..steamURL
			local webhook 	= "https://canary.discordapp.com/api/webhooks/704814462808621188/mv22pPW9Pl3GCVNwoxZnSArpKXNW5KwLKuXRxhdIOtgIoG4yxl2G8Zcfrv1ayhHfopLF"
			local message 	= "**Waktu: "..time.."**\n```ID Steam Player : "..xPlayer.identifier.."\nNama Player     : "..xPlayer.name.." - "..xPlayer.job.label.."\nLink Player     : "..theURL.."\nMenaruh Senjata : " ..item.. " ("..count..")\n```"
			PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
			
		end)
	end

	xPlayer.triggerEvent("esx_inventoryhud:refreshMechanicInventory")
	xPlayer.triggerEvent("esx_inventoryhud:loadPlayerInventory")

end)

ESX.RegisterServerCallback('dwk_Mechanic:getMechanicInventory', function(source, cb, owner)
	-- local xPlayer    = ESX.GetPlayerFromIdentifier(owner)
	local blackMoney = 0
	local items      = {}
	local weapons    = {}

	-- TriggerEvent('esx_addonaccount:getSharedAccount', "society_mechanic", function(account)
	-- 	blackMoney = account.money
	-- end)

	TriggerEvent('esx_addoninventory:getSharedInventory', "society_mechanic", function(inventory)
		items = inventory.items
	end)

	-- TriggerEvent('esx_datastore:getSharedDataStore', "society_mechanic", function(store)
	-- 	weapons = store.get('weapons') or {}
	-- end)

	cb({
		-- blackMoney = blackMoney,
		items      = items,
		-- weapons    = weapons
	})
end)

ESX.RegisterServerCallback("jn-mekanik:checktoolkit", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.getInventoryItem('repairkit')

    if items.count >= 1 then
    xPlayer.removeInventoryItem('repairkit', 1)
        cb(true)
    else
        cb(false)
    end
end)
