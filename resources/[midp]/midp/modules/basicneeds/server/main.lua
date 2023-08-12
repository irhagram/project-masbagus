
ESX.RegisterUsableItem('bread', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bread', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 152000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	--TriggerClientEvent('esx:showNotification', source, _U('used_bread'))
end)

ESX.RegisterUsableItem('radio', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('radioGui', source)

end)

ESX.RegisterUsableItem('chickensalad', function(source)
	
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('chickensalad', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
end)

ESX.RegisterUsableItem('susubayi', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('susubayi', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 500000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 450000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Meminum Susu')
end)

ESX.RegisterUsableItem('bakmi', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bakmi', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	---TriggerClientEvent('esx:showNotification', source, _U('used_choc'))
end)

ESX.RegisterUsableItem('dimsum', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('dimsum', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 190000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	---TriggerClientEvent('esx:showNotification', source, _U('used_siom'))
end)

ESX.RegisterUsableItem('friedrice', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('friedrice', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 190000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	---TriggerClientEvent('esx:showNotification', source, _U('used_nasgor'))
end)

ESX.RegisterUsableItem('nasikatsu', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('nasikatsu', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 190000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	---TriggerClientEvent('esx:showNotification', source, ('Sedang memakan gorengan'))
end)

ESX.RegisterUsableItem('sushi', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('sushi', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 350000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	---TriggerClientEvent('esx:showNotification', source, _U('used_odading'))
end)

ESX.RegisterUsableItem('ramen', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('ramen', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 190000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	---TriggerClientEvent('esx:showNotification', source, _U('used_chips'))
end)

--[[ESX.RegisterUsableItem('water', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('water', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 255000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	---TriggerClientEvent('esx:showNotification', source, _U('used_water'))
end)]]

ESX.RegisterUsableItem('milk', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('milk', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 255000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	---TriggerClientEvent('esx:showNotification', source, _U('used_water'))
end)

ESX.RegisterUsableItem('milkshake', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('milkshake', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 195000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
---	TriggerClientEvent('esx:showNotification', source, _U('used_tehkotak'))
end)

ESX.RegisterUsableItem('icetea', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('icetea', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
---	TriggerClientEvent('esx:showNotification', source, _U('used_esteh'))
end)

ESX.RegisterUsableItem('americano', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('americano', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
---	TriggerClientEvent('esx:showNotification', source, ('Sedang meminum cendol'))
end)

ESX.RegisterUsableItem('coffee', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('coffee', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 225000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
---	TriggerClientEvent('esx:showNotification', source, _U('used_kopi'))
end)

ESX.RegisterUsableItem('orangejuice', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('orangejuice', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 225000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
---	TriggerClientEvent('esx:showNotification', source, _U('used_minum'))
end)

ESX.RegisterUsableItem('dalgona', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('dalgona', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 225000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
---	TriggerClientEvent('esx:showNotification', source, _U('used_minum'))
end)

ESX.RegisterUsableItem('satekulit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('satekulit', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 155000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
---	TriggerClientEvent('esx:showNotification', source, _U('used_makan'))
end)

ESX.RegisterUsableItem('sandwich', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('sandwich', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 145000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
---	TriggerClientEvent('esx:showNotification', source, _U('used_makan'))
end)

ESX.RegisterUsableItem('pizza', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('pizza', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 171000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
---	TriggerClientEvent('esx:showNotification', source, _U('used_makan'))
end)

ESX.RegisterUsableItem('kueloveyou', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('kueloveyou', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 350000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
---	TriggerClientEvent('esx:showNotification', source, _U('used_makan'))
end)

ESX.RegisterUsableItem('susu', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('susu', 1)

	TriggerClientEvent('midp-core:ilanginslow', source)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
end)

--mabok

ESX.RegisterUsableItem('vodka', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('vodka', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 250000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
---	TriggerClientEvent('esx:showNotification', source, _U('used_vodka'))
end)

ESX.RegisterUsableItem('whisky', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('whisky', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 250000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
---	TriggerClientEvent('esx:showNotification', source, _U('used_whisky'))
end)

ESX.RegisterUsableItem('tequila', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('tequila', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 250000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
---	TriggerClientEvent('esx:showNotification', source, _U('used_tequila'))
end)

ESX.RegisterUsableItem('martini', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('martini', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 250000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
---	TriggerClientEvent('esx:showNotification', source, _U('used_martini'))
end)


ESX.RegisterUsableItem('weed_pooch', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('weed_pooch', 1)

	TriggerClientEvent('midp-core:Instan', source)
	TriggerClientEvent('esx_status:add', source, 'drunk', 150000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
end)

ESX.RegisterUsableItem('coke_pooch', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('coke_pooch', 1)

	TriggerClientEvent('midp-core:Instan', source)
	TriggerClientEvent('esx_status:add', source, 'drunk', 150000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
end)

ESX.RegisterUsableItem('alprazolam', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('alprazolam', 1)

	TriggerClientEvent('midp-core:Instan', source)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
end)

ESX.RegisterUsableItem('sertraline', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('sertraline', 1)

	TriggerClientEvent('midp-core:Instan', source)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
end)

ESX.RegisterCommand('heal', 'admin', function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx_basicneeds:onDrink')
	args.playerId.triggerEvent('esx_basicneeds:healPlayer')
end, true, {help = 'Heal a player, or yourself - restores thirst, hunger and health.', validate = true, arguments = {
	{name = 'playerId', help = 'the player id', type = 'player'}
}})

ESX.RegisterCommand('giveplystres', 'superadmin', function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx_basicneeds:givestres')
end, true, {help = 'Heal a player, or yourself - restores thirst, hunger and health.', validate = true, arguments = {
	{name = 'playerId', help = 'the player id', type = 'player'}
}})

AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
	if GetInvokingResource() ~= "monitor" or type(eventData) ~= "table" or type(eventData.id) ~= "number" then
		return
	end

	TriggerClientEvent('esx_basicneeds:healPlayer', eventData.id)
end)

RegisterServerEvent("stress:add")
AddEventHandler("stress:add", function (value)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)


	if xPlayer.job.name == "admin" then --if player is a police officer, he/she gaing half the stress, you can add different jobs using same method
		TriggerClientEvent("esx_status:add", _source, "stress", value / 10)
	else
		TriggerClientEvent("esx_status:add", _source, "stress", value)
	end
end)

RegisterServerEvent("stress:remove") -- stres azalttır // remove stress
AddEventHandler("stress:remove", function (value)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent("esx_status:remove", _source, "stress", value)
end)

RegisterServerEvent('midp-core:delitem')
AddEventHandler('midp-core:delitem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(item, count)
end)