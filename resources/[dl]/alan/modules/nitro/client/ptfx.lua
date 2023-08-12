-- TODO: Get actual exhaust positions and rotations. This is based on bone
-- positions, but custom exhausts can have different positions or rotations.
local exhausthandle = {}

function CreateVehicleExhaustBackfire(vehicle, scale)
  local exhaustNames = {
    "exhaust",    "exhaust_2",  "exhaust_3",  "exhaust_4",
    "exhaust_5",  "exhaust_6",  "exhaust_7",  "exhaust_8",
    "exhaust_9",  "exhaust_10", "exhaust_11", "exhaust_12",
    "exhaust_13", "exhaust_14", "exhaust_15", "exhaust_16"
  }

  RequestNamedPtfxAsset('veh_xs_vehicle_mods')
	-- Wait for the particle dictionary to load.
	while not HasNamedPtfxAssetLoaded('veh_xs_vehicle_mods') do
		Citizen.Wait(0)
	end

  if not exhausthandle[vehicle] then
    exhausthandle[vehicle] = {handle = {}}
  end
  
  for _, exhaustName in ipairs(exhaustNames) do
    local boneIndex = GetEntityBoneIndexByName(vehicle, exhaustName)

    if boneIndex ~= -1 then
      if not exhausthandle[vehicle].handle[boneIndex] then
        local pos = GetWorldPositionOfEntityBone(vehicle, boneIndex)
        local off = GetOffsetFromEntityGivenWorldCoords(vehicle, pos.x, pos.y, pos.z)
        local rot = GetEntityBoneRotationLocal(vehicle, boneIndex)

        UseParticleFxAsset('veh_xs_vehicle_mods')
        exhausthandle[vehicle].handle[boneIndex] = StartParticleFxLoopedOnEntity('veh_nitrous', vehicle, off.x, off.y, off.z, rot.x, rot.y, rot.z, scale, false, false, false)
      end
    end
  end
end

function CreateVehiclePurgeSpray(vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale)
  UseParticleFxAssetNextCall('core')
  return StartParticleFxLoopedOnEntity('ent_sht_steam', vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale, false, false, false)
end

function CreateVehicleLightTrail(vehicle, bone, scale)
  UseParticleFxAssetNextCall('core')
  local ptfx = StartParticleFxLoopedOnEntityBone('veh_light_red_trail', vehicle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, bone, scale, false, false, false)
  SetParticleFxLoopedEvolution(ptfx, "speed", 1.0, false)
  return ptfx
end

function StopVehicleLightTrail(ptfx, duration, vehicle)
  Citizen.CreateThread(function()
    local startTime = GetGameTimer()
    local endTime = GetGameTimer() + duration
    while GetGameTimer() < endTime do 
      Citizen.Wait(0)
      local now = GetGameTimer()
      local scale = (endTime - now) / duration
      SetParticleFxLoopedScale(ptfx, scale)
      SetParticleFxLoopedAlpha(ptfx, scale)
    end
    StopParticleFxLooped(ptfx)

    if exhausthandle[vehicle] then
      for k,v in pairs(exhausthandle[vehicle].handle) do
        StopParticleFxLooped(v)
      end
      exhausthandle[vehicle] = nil
    end
  end)
end

-- function CreateVehiclePurgeSpray(vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale, density, r, g, b)
--   local boneIndex = GetEntityBoneIndexByName(vehicle, 'bonnet')
--   local pos = GetWorldPositionOfEntityBone(vehicle, boneIndex)
--   local off = GetOffsetFromEntityGivenWorldCoords(vehicle, pos.x, pos.y, pos.z)
--
--   local xOffset = (xOffset or 0) + off.x
--   local yOffset = (yOffset or 0) + off.y
--   local zOffset = (zOffset or 0) + off.z
--
--   local xRot = xRot or 0
--   local yRot = yRot or 0
--   local zRot = zRot or 0
--
--   local scale = scale or 0.5
--   local density = density or 3
--
--   local r = (r or 255) / 255
--   local g = (g or 255) / 255
--   local b = (b or 255) / 255
--
--   local particles = {}
--
--   for i = 0, density do
--     UseParticleFxAssetNextCall('core')
--     local fx1 = StartParticleFxLoopedOnEntity('ent_sht_steam', vehicle, off.x - 0.5, off.y + 0.05, off.z, 40.0, -20.0, 0.0, 0.5, false, false, false)
--     SetParticleFxLoopedColour(fx1, r, g, b)
--
--     UseParticleFxAssetNextCall('core')
--     local fx2 = StartParticleFxLoopedOnEntity('ent_sht_steam', vehicle, off.x + 0.5, off.y + 0.05, off.z, 40.0, 20.0, 0.0, 0.5, false, false, false)
--     SetParticleFxLoopedColour(fx2, r, g, b)
--   end
-- end
