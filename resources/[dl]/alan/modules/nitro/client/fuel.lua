DecorRegister("nitroFuel", 0)

local lastNitro = 0
local nitroleft = 500
local nitroCooldown = 2500 -- TODO: per-vehicle cooldown?

local nitroFuelDrainRate = 4
local nitroPurgeFuelDrainRate = 2
local nitroRechargeRate = nitroFuelDrainRate / 1.5

function DrainNitroFuel(vehicle, purge)
  if not purge then
    purge = false
  end

  if DecorExistOn(vehicle, 'nitroFuel') and DecorGetInt(vehicle, 'nitroFuel') > 0 then
    if purge then
      DecorSetInt(vehicle, 'nitroFuel', DecorGetInt(vehicle,'nitroFuel') - nitroPurgeFuelDrainRate)
      nitroleft = nitroleft - nitroPurgeFuelDrainRate * 2
    else
      DecorSetInt(vehicle, 'nitroFuel', DecorGetInt(vehicle,'nitroFuel') - nitroFuelDrainRate)
      nitroleft = nitroleft - nitroFuelDrainRate * 2
    end
    lastNitro = GetGameTimer()
  end
end

function RechargeNitroFuel(vehicle)
  if nitroleft < 500 then
    nitroleft = nitroleft + nitroRechargeRate
  end
end

function GetNitroFuelLevel(vehicle)
  if nitroleft < 1 then
    return 0
  end

  if DecorExistOn(vehicle,'nitroFuel') then
    return math.max(0, DecorGetInt(vehicle,'nitroFuel'))
  end

  return 0
end

Citizen.CreateThread(function ()
  local function FuelLoop()
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player)

    if vehicle == 0 then
      return
    end

    local driver = GetPedInVehicleSeat(vehicle, -1)
    local isRunning = GetIsVehicleEngineRunning(vehicle)
    if driver ~= player or not isRunning then
      return
    end

    if isRunning then
      local isBoosting = IsVehicleNitroBoostEnabled(vehicle)
      local isPurging = IsVehicleNitroPurgeEnabled(vehicle)
      
      if isBoosting == false and isPurging == false and GetGameTimer() > lastNitro + nitroCooldown then
        RechargeNitroFuel(vehicle)
      end

      if isBoosting == true or isPurging == true then
        DrainNitroFuel(vehicle, isPurging)
      end
    end
  end

  while true do
    local letsleep = 1000

    if IsPedInAnyVehicle(PlayerPedId(), false) then
      letsleep = 0
    end

    FuelLoop()

    Citizen.Wait(letsleep)
  end
end)