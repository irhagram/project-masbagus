local INPUT_VEH_ACCELERATE = 71
local nitrous = false
local isBusy = false

RegisterNetEvent('alan_nitrous:onNitrous')
AddEventHandler('alan_nitrous:onNitrous', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
  local vehicle

  if IsPedInAnyVehicle(playerPed, false) then
    vehicle = GetVehiclePedIsIn(playerPed, false)
  else
    vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
  end

  if DoesEntityExist(vehicle) and isBusy == false and IsToggleModOn(vehicle, 18) then
    isBusy = true
    exports['mythic_progbar']:Progress({
      name = "Nitrous",
      duration = 30000,
      label = 'Memasang Nitro',
      useWhileDead = false,
      canCancel = false,
      controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
      },
      animation = {
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        flags = 1,
      }
    }, function(cancelled)
      if not cancelled then
        local currentnitro = 0

        if DecorExistOn(vehicle, 'nitroFuel') then
          currentnitro = DecorGetInt(vehicle, 'nitroFuel')
        end
        
        currentnitro = currentnitro + 1500

        if currentnitro >= 3500 then
          currentnitro = 3500
        end

        DecorSetInt(vehicle, 'nitroFuel', currentnitro)

        exports['alan-tasknotify']:DoHudText('success', 'Nitro Terpasang')
      end
      isBusy = false
      ClearPedTasks(PlayerPedId())
    end)
  elseif DoesEntityExist(vehicle) and not IsToggleModOn(vehicle, 18) then
    exports['alan-tasknotify']:DoHudText('error', 'Kendaraan Tidak Memiliki Nitro Storage')
  else
    exports['alan-tasknotify']:DoHudText('error', 'Tidak Ada Kendaraan Di Sekitar')
  end
end)

local function IsDrivingControlPressed()
  return IsControlPressed(0, INPUT_VEH_ACCELERATE)
end

local function NitroLoop(lastVehicle)
  local player = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(player)
  local driver = GetPedInVehicleSeat(vehicle, -1)

  if lastVehicle ~= 0 and lastVehicle ~= vehicle then
    SetVehicleNitroBoostEnabled(lastVehicle, false)
    SetVehicleLightTrailEnabled(lastVehicle, false)
    SetVehicleNitroPurgeEnabled(lastVehicle, false)
    TriggerServerEvent('nitro:__sync', false, false, true)
  end

  if vehicle == 0 or driver ~= player then
    return 0
  end

  local model = GetEntityModel(vehicle)

  if not IsThisModelACar(model) or IsVehicleElectric(vehicle) then
    return 0
  end

  local isDriving = IsDrivingControlPressed()
  local isRunning = GetIsVehicleEngineRunning(vehicle)
  local isBoosting = IsVehicleNitroBoostEnabled(vehicle)
  local isPurging = IsVehicleNitroPurgeEnabled(vehicle)
  local isFueled = GetNitroFuelLevel(vehicle) > 0
  local isEnabled = nitrous
  local haveTurbo = IsToggleModOn(vehicle, 18)

  if isRunning and isFueled and haveTurbo and isEnabled then
    if isDriving then
      if not isBoosting then
        SetVehicleNitroBoostEnabled(vehicle, true)
        SetVehicleLightTrailEnabled(vehicle, true)
        SetVehicleNitroPurgeEnabled(vehicle, false)
        TriggerServerEvent('nitro:__sync', true, false, false)
      end
    else
      if not isPurging then
        SetVehicleNitroBoostEnabled(vehicle, false)
        SetVehicleLightTrailEnabled(vehicle, false)
        SetVehicleNitroPurgeEnabled(vehicle, true)
        TriggerServerEvent('nitro:__sync', false, true, false)
      end
    end
  elseif isBoosting or isPurging then
    SetVehicleNitroBoostEnabled(vehicle, false)
    SetVehicleLightTrailEnabled(vehicle, false)
    SetVehicleNitroPurgeEnabled(vehicle, false)
    TriggerServerEvent('nitro:__sync', false, false, false)
  end

  return vehicle
end

Citizen.CreateThread(function ()
  local lastVehicle = 0

  while true do
    local letsleep = 1000

    if IsPedInAnyVehicle(PlayerPedId(), false) then
      letsleep = 0
    end

    lastVehicle = NitroLoop(lastVehicle)

    Citizen.Wait(letsleep)
  end
end)

RegisterCommand('+nitrous', function() nitrous = true end)
RegisterCommand('-nitrous', function() nitrous = false end)
RegisterKeyMapping('+nitrous', 'Toggle vehicle nitrous', 'keyboard', ' ')

RegisterNetEvent('nitro:__update')
AddEventHandler('nitro:__update', function (playerServerId, boostEnabled, purgeEnabled, lastVehicle)
  local playerId = GetPlayerFromServerId(playerServerId)

  -- Sometimes, the source player is disconnected from our session. If we don't
  -- check for that, their player ID will be -1. GetPlayerPed(-1) is our local
  -- player, so the logic to apply nitro sync will apply it to our vehicle when
  -- that happens.
  --
  -- Say, the source player enables nitro, but is not connected in our session.
  -- Nitro is then synced on the vehicle for player -1, which is us, so nitro is
  -- activated on our vehicle. However, because we're not actually pressing the
  -- nitro key, our client will update the nitro state accordingly, and turn it
  -- off. That then syncs to the original source player, who has the exact same
  -- network issue as we do. Nitro will be disabled on his vehicle, but he's
  -- still pressing the nitro key, so it's being enabled right after. Long story
  -- short, this causes an infinite sync loop between all clients as long as at
  -- least one player has nitro activated.
  --
  -- Therefor, simply check if the source player is connected to our session. If
  -- not, ignore the synced state and don't do anything.
  if not NetworkIsPlayerConnected(playerId) then
    return
  end

  local player = GetPlayerPed(playerId)
  local vehicle = GetVehiclePedIsIn(player, lastVehicle)
  local driver = GetPedInVehicleSeat(vehicle, -1)

  SetVehicleNitroBoostEnabled(vehicle, boostEnabled)
  SetVehicleLightTrailEnabled(vehicle, boostEnabled)
  SetVehicleNitroPurgeEnabled(vehicle, purgeEnabled)
end)
