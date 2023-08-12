ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'pedagang', 'pedagang', 'society_pedagang', 'society_pedagang', 'society_pedagang', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'biker', 'biker', 'society_biker', 'society_biker', 'society_biker', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'mafia', 'mafia', 'society_mafia', 'society_mafia', 'society_mafia', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'yakuza', 'yakuza', 'society_yakuza', 'society_yakuza', 'society_yakuza', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'gang', 'gang', 'society_gang', 'society_gang', 'society_gang', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'cartel', 'cartel', 'society_cartel', 'society_cartel', 'society_cartel', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'ormas', 'ormas', 'society_ormas', 'society_ormas', 'society_ormas', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'badside7', 'badside7', 'society_badside7', 'society_badside7', 'society_badside7', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'badside8', 'badside8', 'society_badside8', 'society_badside8', 'society_badside8', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'badside9', 'badside9', 'society_badside9', 'society_badside9', 'society_badside9', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'badside10', 'badside10', 'society_badside10', 'society_badside10', 'society_badside10', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'badside11', 'badside11', 'society_badside11', 'society_badside11', 'society_badside11', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'badside12', 'badside12', 'society_badside12', 'society_badside12', 'society_badside12', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'badside13', 'badside13', 'society_badside13', 'society_badside13', 'society_badside13', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'badside14', 'badside14', 'society_badside14', 'society_badside14', 'society_badside14', {type = 'public'})

RegisterServerEvent('jn-badside:handcuff')
AddEventHandler('jn-badside:handcuff', function(target)
  TriggerClientEvent('jn-badside:handcuff', target)
end)

RegisterServerEvent('jn-badside:drag')
AddEventHandler('jn-badside:drag', function(target)
  local _source = source
  TriggerClientEvent('jn-badside:drag', target, _source)
end)

RegisterServerEvent('jn-badside:putInVehicle')
AddEventHandler('jn-badside:putInVehicle', function(target)
  TriggerClientEvent('jn-badside:putInVehicle', target)
end)

RegisterServerEvent('jn-badside:OutVehicle')
AddEventHandler('jn-badside:OutVehicle', function(target)
    TriggerClientEvent('jn-badside:OutVehicle', target)
end)

--REPAIRSENJATA--
local ox_inventory = exports.ox_inventory

RegisterNetEvent('dl-wrepair:perbaiki')
AddEventHandler('dl-wrepair:perbaiki', function(data)
    local curweapon = data.selweapon
    local weapon = ox_inventory:Search(source, 'slots', curweapon)
    weapon = weapon[1]
    ox_inventory:SetDurability(source, weapon.slot, 100)
end)

ESX.RegisterUsableItem('toolkit_senjata', function(source)
    TriggerClientEvent('dl-wrepair:context', source)
end)

RegisterNetEvent('dl-wrepair:useitem')
AddEventHandler('dl-wrepair:useitem', function(data)
    local curweapon = data.selweapon
    local weapon = ox_inventory:Search(source, 'slots', curweapon)
    weapon = weapon[1]
    ox_inventory:RemoveItem(source, 'toolkit_senjata', 1)
	  ox_inventory:SetDurability(source, weapon.slot, 100)
end)

RegisterNetEvent('dl-wrepair:delItem')
AddEventHandler('dl-wrepair:delItem', function()
    ox_inventory:RemoveItem(source, 'repairkit_senjata', 1)
end)