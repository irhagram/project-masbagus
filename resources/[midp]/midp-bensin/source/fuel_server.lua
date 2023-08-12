
local ox_inventory = exports.ox_inventory

if Config.UseESX then

	RegisterServerEvent('fuel:pay')
	AddEventHandler('fuel:pay', function(price)
		local xPlayer = ESX.GetPlayerFromId(source)
		local amount = ESX.Math.Round(price)

		if price > 0 then
			ox_inventory:RemoveItem(source, 'money', amount)
		end
	end)
end

RegisterServerEvent('midp-bensin:delbensin')
AddEventHandler('midp-bensin:delbensin', function(id)
	local ox_inventory = exports.ox_inventory
	ox_inventory:RemoveItem(id,'WEAPON_PETROLCAN', 1)
end)

RegisterServerEvent('midp-bensin:getbensin')
AddEventHandler('midp-bensin:getbensin', function(id)
	local ox_inventory = exports.ox_inventory
	ox_inventory:AddItem(id,'WEAPON_PETROLCAN', 1)
end)