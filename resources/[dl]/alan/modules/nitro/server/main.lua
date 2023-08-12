RegisterNetEvent('nitro:__sync')
AddEventHandler('nitro:__sync', function (boostEnabled, purgeEnabled, lastVehicle)
  -- Fix for source reference being lost during loop below.
  local source = source

  for _, player in ipairs(GetPlayers()) do
    if player ~= tostring(source) then
      TriggerClientEvent('nitro:__update', player, source, boostEnabled, purgeEnabled, lastVehicle)
    end
  end
end)

ESX.RegisterUsableItem('nitro', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)

	if xPlayer.getInventoryItem('nitro').count > 0 then
		TriggerClientEvent('alan_nitrous:onNitrous', source)
    xPlayer.removeInventoryItem('nitro', 1)
	end
end)