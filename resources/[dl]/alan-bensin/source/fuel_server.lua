ESX = nil

local ox_inventory = exports.ox_inventory

if Config.UseESX then
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

	RegisterServerEvent('fuel:pay')
	AddEventHandler('fuel:pay', function(price)
		local xPlayer = ESX.GetPlayerFromId(source)
		local amount = ESX.Math.Round(price)

		if price > 0 then
			ox_inventory:RemoveItem(source, 'money', amount)
		end
	end)
end

RegisterServerEvent('alan-bensin:delbensin')
AddEventHandler('alan-bensin:delbensin', function(id)
	local ox_inventory = exports.ox_inventory
	ox_inventory:RemoveItem(id,'WEAPON_PETROLCAN', 1)
end)

RegisterServerEvent('alan-bensin:getbensin')
AddEventHandler('alan-bensin:getbensin', function(id)
	local ox_inventory = exports.ox_inventory
	ox_inventory:AddItem(id,'WEAPON_PETROLCAN', 1)
end)