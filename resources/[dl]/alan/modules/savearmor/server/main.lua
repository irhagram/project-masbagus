local LoadHealthNArmour = 'SELECT `health`, `armour` FROM `users` WHERE `identifier` = ?'
local UpdateHealthNArmour = 'UPDATE `users` SET `health` = ?, `armour` = ? WHERE `identifier` = ?'

RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer ~= nil then
    MySQL.query(LoadHealthNArmour, {
      xPlayer.identifier
    }, function(data)
      local playerStats = data[1]

      if playerStats.health ~= nil and playerStats.armour ~= nil then
        TriggerClientEvent('esx_healthnarmour:set', xPlayer.source, playerStats.health, playerStats.armour)
      end
    end)
  end
end)

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer ~= nil then
        MySQL.update.await(UpdateHealthNArmour, {
          GetEntityMaxHealth(GetPlayerPed(xPlayer.source)),
          0, 
          xPlayer.identifier
        })
    end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
  local xPlayer = ESX.GetPlayerFromId(playerId)
  
  if xPlayer ~= nil then
    local health = GetEntityHealth(GetPlayerPed(xPlayer.source))
    local armour = GetPedArmour(GetPlayerPed(xPlayer.source))

    MySQL.update.await(UpdateHealthNArmour, {
      health, 
      armour, 
      xPlayer.identifier
    })
  end
end)