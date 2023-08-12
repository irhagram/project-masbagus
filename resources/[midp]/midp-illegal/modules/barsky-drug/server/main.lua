stressyo = true
local input = nil
local inprogress = 0
--local timer = 0
local finalreturn = 0
local police = 0
local CopsConnected = 0
local playersProcessingCannabis = {}
local playersProcessingCoke = {}
local PlayersSellingCoke       = {}
local PlayersSellingWeed       = {}


local stashes = {
	{
		id = 'brankas_mafia',
		label = 'BRANKAS BADSIDE',
		slots = 500,
		weight = 10000000,
		owner = false,
		jobs = 'mafia'
	},
	{
		id = 'brankas_gang',
		label = 'BRANKAS BADSIDE',
		slots = 500,
		weight = 10000000,
		owner = false,
		jobs = 'gang'
	},
	{
		id = 'brankas_cartel',
		label = 'BRANKAS BADSIDE',
		slots = 500,
		weight = 10000000,
		owner = false,
		jobs = 'cartel'
	},
	{
		id = 'brankas_ormas',
		label = 'BRANKAS BADSIDE',
		slots = 500,
		weight = 10000000,
		owner = false,
		jobs = 'ormas'
	},
	{
		id = 'brankas_biker',
		label = 'BRANKAS BADSIDE',
		slots = 500,
		weight = 10000000,
		owner = false,
		jobs = 'biker'
	},
	{
		id = 'brankas_yakuza',
		label = 'BRANKAS BADSIDE',
		slots = 500,
		weight = 10000000,
		owner = false,
		jobs = 'yakuza'
	},
	{
		id = 'brankas_b7',
		label = 'BRANKAS BADSIDE',
		slots = 500,
		weight = 10000000,
		owner = false,
		jobs = 'badside7'
	},
	{
		id = 'brankas_b8',
		label = 'BRANKAS BADSIDE',
		slots = 500,
		weight = 10000000,
		owner = false,
		jobs = 'badside8'
	},
	{
		id = 'brankas_b9',
		label = 'BRANKAS BADSIDE',
		slots = 500,
		weight = 10000000,
		owner = false,
		jobs = 'badside9'
	},
	{
		id = 'brankas_b10',
		label = 'BRANKAS BADSIDE',
		slots = 500,
		weight = 10000000,
		owner = false,
		jobs = 'badside10'
	},
	{
		id = 'brankas_b11',
		label = 'BRANKAS BADSIDE',
		slots = 500,
		weight = 10000000,
		owner = false,
		jobs = 'badside11'
	},
	{
		id = 'brankas_b12',
		label = 'BRANKAS BADSIDE',
		slots = 500,
		weight = 10000000,
		owner = false,
		jobs = 'badside12'
	},
	{
		id = 'brankas_b13',
		label = 'BRANKAS BADSIDE',
		slots = 500,
		weight = 10000000,
		owner = false,
		jobs = 'badside13'
	},
	{
		id = 'brankas_b14',
		label = 'BRANKAS BADSIDE',
		slots = 500,
		weight = 10000000,
		owner = false,
		jobs = 'badside14'
	},
	{
		id = 'brankas_pedagang',
		label = 'BRANKAS PEDAGANG',
		slots = 250,
		weight = 10000000,
		owner = false,
		jobs = 'pedagang'
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

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(1000 * 10, CountCops)
end

CountCops()

RegisterServerEvent('moneywash:cekpolisi')
AddEventHandler('moneywash:cekpolisi', function(count)
	police = count
end)

--[[ Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if timer > 0 then
			timer = timer - 1000
		end
	end
end) ]]

ESX.RegisterServerCallback('jn-drugs:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.canCarryItem(item, 1))
end)

ESX.RegisterServerCallback('jn-drugs:getCountItem',function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem(item).count
    cb(item)
end)

ESX.RegisterServerCallback('jn-drugs:getCountBM',function(source, cb, money)
    local xPlayer = ESX.GetPlayerFromId(source)
	local money = xPlayer.getAccount('black_money').money
    cb(money)
end)

RegisterServerEvent('jn-drugs:pickedUpCoke')
AddEventHandler('jn-drugs:pickedUpCoke', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.canCarryItem('coke') then
		xPlayer.addInventoryItem('coke', 1)
	else
		TriggerClientEvent('midp-tasknotify:client:SendAlert', _source, { type = 'error', text = 'Inventory penuh'})
	end
end)

RegisterServerEvent('jn-drugs:processCoke')
AddEventHandler('jn-drugs:processCoke', function()
	if not playersProcessingCoke[source] then
	local _source = source

	if CopsConnected < Config.PolisiDibutuhkan then
		TriggerClientEvent('midp-tasknotify:client:SendAlert', _source, { type = 'error', text = 'Tidak Cukup Polisi!'})
		return
	end

			playersProcessingCoke[_source] = ESX.SetTimeout(Config.Delays.CokeProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xCoke, xBag_coke = xPlayer.getInventoryItem('coke'), xPlayer.getInventoryItem('coke_pooch')

			if xCoke.count > 3 then
				if xPlayer.canSwapItem('coke', 6, 'coke_pooch', 1) then
					xPlayer.removeInventoryItem('coke', 6)
					xPlayer.addInventoryItem('coke_pooch', 1)

					TriggerClientEvent('midp-tasknotify:client:SendAlert', _source, { type = 'success', text = 'Menerima 1X Coke'})
				else
					TriggerClientEvent('midp-tasknotify:client:SendAlert', _source, { type = 'error', text = 'gagal!'})
				end
			else
				TriggerClientEvent('midp-tasknotify:client:SendAlert', _source, { type = 'error', text = 'Kamu Harus Memiliki 6 coca Leaf!'})
			end

			playersProcessingCoke[_source] = nil
		end)
	else
		print(('jn-drugs: %s mencoba untuk mengeksploitasi pengolahan Genjer!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerID)
	if playersProcessingCoke[playerID] then
		ESX.ClearTimeout(playersProcessingCoke[playerID])
		playersProcessingCoke[playerID] = nil
	end
end

RegisterServerEvent('jn-drugs:pickedUpCannabis')
AddEventHandler('jn-drugs:pickedUpCannabis', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.canCarryItem('weed') then
		xPlayer.addInventoryItem('weed', 1)
	else
		TriggerClientEvent('midp-tasknotify:client:SendAlert', _source, { type = 'error', text = 'Inventory penuh'})
	end
end)

RegisterServerEvent('jn-drugs:processCannabis')
AddEventHandler('jn-drugs:processCannabis', function()
	if not playersProcessingCannabis[source] then
	local _source = source

	if CopsConnected < Config.PolisiDibutuhkan then
		TriggerClientEvent('midp-tasknotify:client:SendAlert', _source, { type = 'error', text = 'Tidak Cukup Polisi!'})
		return
	end

		playersProcessingCannabis[_source] = ESX.SetTimeout(Config.Delays.CannabisProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xCannabis, xBag_cannabis = xPlayer.getInventoryItem('weed'), xPlayer.getInventoryItem('weed_pooch')

			if xCannabis.count > 3 then
				if xPlayer.canSwapItem('weed', 6, 'weed_pooch', 1) then
					xPlayer.removeInventoryItem('weed', 6)
					xPlayer.addInventoryItem('weed_pooch', 1)

					TriggerClientEvent('midp-tasknotify:client:SendAlert', _source, { type = 'success', text = 'Menerima 1X Olahan KEcubung'})
				else
					TriggerClientEvent('midp-tasknotify:client:SendAlert', _source, { type = 'error', text = 'gagal!'})
				end
			else
				TriggerClientEvent('midp-tasknotify:client:SendAlert', _source, { type = 'error', text = 'Kamu Harus Memiliki 6 Buah Kecubung!'})
			end

			playersProcessingCannabis[_source] = nil
		end)
	else
		print(('jn-drugs: %s mencoba untuk mengeksploitasi pengolahan Genjer!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)


function CancelProcessing(playerID)
	if playersProcessingCannabis[playerID] then
		ESX.ClearTimeout(playersProcessingCannabis[playerID])
		playersProcessingCannabis[playerID] = nil
	end
end

RegisterServerEvent('jn-drugs:cancelProcessing')
AddEventHandler('jn-drugs:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)

local function SellWeed(source)
	if CopsConnected < Config.PolisiDibutuhkan then
		TriggerClientEvent('midp-tasknotify:Alert', source, "SYSTEM", "Tidak cukup polisi!", 5000, 'error')
		return
	end

	SetTimeout(Config.WaktuJualan, function()

		if PlayersSellingWeed[source] == true then
			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent('midp-tasknotify:Alert', source, "SYSTEM", "Tidak cukup barang!", 5000, 'error')
			else
				xPlayer.removeInventoryItem('weed_pooch', 1)
				if CopsConnected == 2 then
					xPlayer.addAccountMoney('black_money', 5000)
				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('black_money', 6000)
				elseif CopsConnected == 4 then
					xPlayer.addAccountMoney('black_money', 7000)
				elseif CopsConnected >= 5 then
					xPlayer.addAccountMoney('black_money', 8000)
				elseif CopsConnected >= 6 then
					xPlayer.addAccountMoney('black_money', 9000)
                elseif CopsConnected >= 7 then
					xPlayer.addAccountMoney('black_money', 10000)			
				elseif CopsConnected >= 8 then
					xPlayer.addAccountMoney('black_money', 15000)		
				end
				SellWeed(source)
			end
		end
	end)
end

RegisterServerEvent('jn-drugs:startSellWeed')
AddEventHandler('jn-drugs:startSellWeed', function(slwd)
	local src = source
	irham.cek(src, slwd, function()
		PlayersSellingWeed[src] = true
		TriggerClientEvent('midp-tasknotify:Alert', src, "SYSTEM", "Jual DImulai!", 5000, 'error')
		SellWeed(src)
	end, function()
		DropPlayer(src, 'Mau Ngetes ILMU KIDS?')
	end)
end)

RegisterServerEvent('jn-drugs:stopSellWeed')
AddEventHandler('jn-drugs:stopSellWeed', function()
	local _source = source
	PlayersSellingWeed[_source] = false
end)

local function SellCoke(source)
	if CopsConnected < Config.PolisiDibutuhkan then
		TriggerClientEvent('midp-tasknotify:Alert', source, "SYSTEM", "Tidak Cukup polisi!", 5000, 'error')
		return
	end

	SetTimeout(Config.WaktuJualan, function()
		if PlayersSellingCoke[source] == true then
			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent('midp-tasknotify:Alert', _source, "SYSTEM", "Tidak cukup barang!", 5000, 'error')
			else
				xPlayer.removeInventoryItem('coke_pooch', 1)
				if CopsConnected == 2 then
					xPlayer.addAccountMoney('black_money', 5000)
				elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('black_money', 6000)
				elseif CopsConnected == 4 then
					xPlayer.addAccountMoney('black_money', 7000)
				elseif CopsConnected == 5 then
					xPlayer.addAccountMoney('black_money', 8000)
				elseif CopsConnected == 6 then
					xPlayer.addAccountMoney('black_money', 9000)
				elseif CopsConnected >= 7 then
					xPlayer.addAccountMoney('black_money', 10000)
                elseif CopsConnected >= 8 then
					xPlayer.addAccountMoney('black_money', 15000)
				end
				SellCoke(source)
			end
		end
	end)
end

RegisterServerEvent('jn-drugs:startSellCoke')
AddEventHandler('jn-drugs:startSellCoke', function(slck)
	local src = source
	irham.cek(src, slck, function()
		PlayersSellingCoke[src] = true
		TriggerClientEvent('midp-tasknotify:Alert', src, "SYSTEM", "Penjualan dimulai!", 5000, 'error')
		SellCoke(src)
	end, function()
		DropPlayer(src, 'Mau Ngetes ILMU KIDS?')
	end)
end)

RegisterServerEvent('jn-drugs:stopSellCoke')
AddEventHandler('jn-drugs:stopSellCoke', function()
	local _source = source
	PlayersSellingCoke[_source] = false
end)

RegisterServerEvent('jn-drugs:GetUserInventory')
AddEventHandler('jn-drugs:GetUserInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('jn-drugs:ReturnInventory', 
		_source, 
		xPlayer.getInventoryItem('coke_pooch').count,
		xPlayer.getInventoryItem('weed_pooch').count,
		xPlayer.job.name, 
		currentZone
	)
end)

function round(x)
	return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end