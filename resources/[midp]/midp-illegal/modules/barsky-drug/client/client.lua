local PlayerLoaded = false
local PlayerData = {}

Citizen.CreateThread(function()


  while ESX.GetPlayerData().job == nil do
    Citizen.Wait(10)
  end

  ESX.PlayerData = ESX.GetPlayerData()
  
  if ESX.PlayerData.job then
    PlayerLoaded = true
  end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(playerData)
  ESX.PlayerData = playerData
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(newJob)
  ESX.PlayerData["job"] = newJob
end)

RegisterNetEvent('jn-core:maxveh')
AddEventHandler('jn-core:maxveh', function(vehicle)
    local props = {
      modEngine       = 3,
      modBrakes       = 2,
      modArmor       = 2,
      modTransmission = 2,
      modSuspension   = 0,
      modTurbo        = true,
    }
    ESX.Game.SetVehicleProperties(vehicle, props)
end)

RegisterNetEvent('jn-badside:drag')
AddEventHandler('jn-badside:drag', function(cop)
    IsDragged = not IsDragged
    CopPed = tonumber(cop)
end)

Citizen.CreateThread(function()
    while true do
      Wait(0)
      if IsHandcuffed then
        if IsDragged then
          local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
          local myped = player
          AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        else
          DetachEntity(PlayerPedId(), true, false)
        end
      end
    end
end)

function playAnim(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
    RemoveAnimDict(animDict)
end

RegisterNetEvent('jn-badside:handcuff')
AddEventHandler('jn-badside:handcuff', function()
    IsHandcuffed = not IsHandcuffed
    local playerPed = PlayerPedId()

      Citizen.CreateThread(function()
        if IsHandcuffed then

          RequestAnimDict('mp_arresting')
          while not HasAnimDictLoaded('mp_arresting') do
            Citizen.Wait(100)
          end

          TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

          SetEnableHandcuffs(playerPed, true)
          DisablePlayerFiring(playerPed, true)
          SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
          SetPedCanPlayGestureAnims(playerPed, false)
          DisableControlAction(0, 323,  true)
          -- FreezeEntityPosition(playerPed, true)
          DisplayRadar(false)

        else
          playAnim('mp_arresting', 'a_uncuff', 3500)
          ClearPedSecondaryTask(playerPed)
          SetEnableHandcuffs(playerPed, false)
          DisablePlayerFiring(playerPed, false)
          SetPedCanPlayGestureAnims(playerPed, true)
          DisableControlAction(0, 323,  false)
          -- FreezeEntityPosition(playerPed, false)
          DisplayRadar(true)
        end
    end)
end)

RegisterNetEvent('jn-badside:putInVehicle')
AddEventHandler('jn-badside:putInVehicle', function()
    local playerPed = player
    local coords    = GetEntityCoords(playerPed)

      if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

          if DoesEntityExist(vehicle) then
            local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
            local freeSeat = nil
            for i=maxSeats - 1, 0, -1 do
              if IsVehicleSeatFree(vehicle,  i) then
                freeSeat = i
                break
              end
            end

            if freeSeat ~= nil then
              TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
            end
        end
    end
end)

RegisterNetEvent('jn-badside:OutVehicle')
AddEventHandler('jn-badside:OutVehicle', function(t)
    local ped = GetPlayerPed(t)
    ClearPedTasksImmediately(ped)
    plyPos = GetEntityCoords(PlayerPedId(),  true)
    local xnew = plyPos.x+2
    local ynew = plyPos.y+2
    SetEntityCoords(PlayerPedId(), xnew, ynew, plyPos.z)
end)

Citizen.CreateThread(function()
while true do
  Wait(0)
  if IsHandcuffed then
    -- DisableControlAction(0, 1, true) -- Disable pan
    -- DisableControlAction(0, 2, true) -- Disable tilt
    DisableControlAction(0, 24, true) -- Attack
    DisableControlAction(0, 257, true) -- Attack 2
    DisableControlAction(0, 25, true) -- Aim
    DisableControlAction(0, 263, true) -- Melee Attack 1
    -- DisableControlAction(0, 32, true) -- W
    -- DisableControlAction(0, 34, true) -- A
    -- DisableControlAction(0, 31, true) -- S
    -- DisableControlAction(0, 30, true) -- D

    DisableControlAction(0, 45, true) -- Reload
    -- DisableControlAction(0, 22, true) -- Jump
    DisableControlAction(0, 44, true) -- Cover
    DisableControlAction(0, 37, true) -- Select Weapon
    -- DisableControlAction(0, 23, true) -- Also 'enter'?

    DisableControlAction(0, 288,  true) -- Disable phone
    DisableControlAction(0, 289, true) -- Inventory
    DisableControlAction(0, 170, true) -- Animations
    DisableControlAction(0, 167, true) -- Job

    DisableControlAction(0, 0, true) -- Disable changing view
    DisableControlAction(0, 26, true) -- Disable looking behind
    DisableControlAction(0, 73, true) -- Disable clearing animation
    DisableControlAction(2, 199, true) -- Disable pause screen

    DisableControlAction(0, 59, true) -- Disable steering in vehicle
    DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
    DisableControlAction(0, 72, true) -- Disable reversing in vehicle

    DisableControlAction(2, 36, true) -- Disable going stealth

    DisableControlAction(0, 47, true)  -- Disable weapon
    DisableControlAction(0, 264, true) -- Disable melee
    DisableControlAction(0, 257, true) -- Disable melee
    DisableControlAction(0, 140, true) -- Disable melee
    DisableControlAction(0, 141, true) -- Disable melee
    DisableControlAction(0, 142, true) -- Disable melee
    DisableControlAction(0, 143, true) -- Disable melee
    -- DisableControlAction(0, 75, true)  -- Disable exit vehicle
    -- DisableControlAction(27, 75, true) -- Disable exit vehicle
  end
end
end)

RegisterCommand('badsidemenucok', function(source, args)
  local Data = ESX.GetPlayerData()
	if Data.job and Data.job.name == 'biker'
  or Data.job and Data.job.name == 'mafia'
  or Data.job and Data.job.name == 'gang'
  or Data.job and Data.job.name == 'cartel'
  or Data.job and Data.job.name == 'yakuza'
  or Data.job and Data.job.name == 'ormas' then
	TriggerEvent('jn-badside:radialmenu', args[1])
	end
end)

RegisterNetEvent('jn-badside:radialmenu')
AddEventHandler('jn-badside:radialmenu', function(type)
  local pos = GetEntityCoords(PlayerPedId())
  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

  local player, distance = ESX.Game.GetClosestPlayer()
  local pedId = PlayerPedId()

	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		if type == 'body_search' then
			TriggerEvent("mythic_progbar:client:progress", {
				name = "unique_action_name",
				duration = 1000,
				label = "menggeledah",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "mp_missheist_countrybank@nervous",
					anim = "nervous_idle",
				}
			}, function(status)
				if not status then
					-- Do Something If Event Wasn't Cancelled
				end
			end)
			ESX.UI.Menu.CloseAll()
			Citizen.Wait(1000)
			TriggerEvent("jn-inventory:openPlayerInventory", GetPlayerServerId(closestPlayer), GetPlayerName(closestPlayer))
			TriggerServerEvent('3dme:shareDisplay', 'Saya Sedang Menggeledah')
		elseif type == 'handcuff' then
      TriggerServerEvent('jn-badside:handcuff', GetPlayerServerId(closestPlayer))
      playAnim('mp_arresting', 'a_uncuff', 4500)
		elseif type == 'unhandcuff' then
      local target, distance = ESX.Game.GetClosestPlayer()
      playerheading = GetEntityHeading(pedId)
      playerlocation = GetEntityForwardVector(pedId)
      playerCoords = GetEntityCoords(pedId)
      local target_id = GetPlayerServerId(target)
      if distance <= 2.0 then
        TriggerServerEvent('jn-polisi:requestrelease', target_id, playerheading, playerCoords, playerlocation)
      end
		end
	end
end)

RegisterNetEvent('dl-bdsd:geledah')
AddEventHandler('dl-bdsd:geledah',function()
    exports.ox_inventory:openNearbyInventory()
end)

local alan = 0
--BIKER-- --9000-- --MOA--
local coordsberangkasBiker = {  
{x = -611.98, y = -1613.51, z = 27.01, h = 97.07}, 
}
local coordsbossBiker = {
{x = -616.8, y = -1622.79, z = 33.01},
}
local coordsvehBiker = {   
{ x = -612.38, y = -1609.53, z = 26.9 },
}
local coordsvehspawnBiker = {
{ x = -611.25, y = -1597.52, z = 26.75, h = 84.28},
}

--CARTEL-- --Franklin B 9075-- --Spartan--
local coordsberangkasCartel = {
{x = -16.83, y = -1430.5, z = 31.1, h = 65},   
}
local coordsbossCartel = {
{x = -18.32, y = -1432.2, z = 31.1},
}
local coordsvehCartel = {
{ x = -20.95, y = -1438.12, z = 30.65 },
}
local coordsvehspawnCartel = {
{ x = -25.31, y = -1438.45, z = 30.65, h = 175.05},   
}

--YAKUZA-- --Bengkel 9055-- --The Prediksi--
local coordsberangkasYakuza = {
{x = 479.29, y = -1326.71, z = 29.21, h = 121.11},
}
local coordsbossYakuza = {
{x = 472.09, y = -1310.76, z = 29.22},
}
local coordsvehYakuza = {
  {x = 495.7, y = -1340.83 , z = 29.31},
}
local coordsvehspawnYakuza = {
{ x = 496.65, y = -1332.91, z = 29.34, h = 14.93},   
}

--GANG-- --LSC 8181-- --All Star--
local coordsberangkasGang = {
  {x =993.26, y = -135.56, z = 74.06, h = 321.63},  
}
local coordsbossGang = {
  {x = 989.4, y = -135.93, z = 74.06},  
}
local coordsvehGang = {
  { x = 962.04, y = -105.68, z = 74.36 },  
}
local coordsvehspawnGang = {
  { x = 957.89, y = -127.77, z = 74.35, h = 189.47},
}

--MAFIA-- --Rumah Anggur 5009-- --Broker--
local coordsberangkasMafia = {
{x = -1866.53, y = 2065.3, z = 135.43, h = 54.32},  
}
local coordsbossMafia = {
{x = -1876.04, y = 2060.88, z = 145.57},
}
local coordsvehMafia = {
{ x = -1924.52, y = 2050.31, z = 140.83},
}
local coordsvehspawnMafia = {
{ x = -1919.83, y = 2048.36, z = 140.74, h= 259.35},
}

--ORMAS-- --ss 3009-- --HRMC--
local coordsberangkasOrmas = {   
  {x = 1985.34, y = 3048.7, z = 47.22, h = 150.02},
}
local coordsbossOrmas = {   
  {x = 1982.26, y = 3053.22, z = 47.22},
}
local coordsvehOrmas = {    
  {x = 2001.82, y = 3050.02, z = 47.21, h = 143.18},
}
local coordsvehspawnOrmas = {  
  { x = 2006.13, y = 3055.31 , z = 47.05, h= 49.92},
}

--BADSIDE7-- --Michael 7063-- --Yellow Claw--
local StashB7 = {
  {x = -803.33, y = 185.79, z = 72.61, h = 22.14},
}
local BosB7 = {
  {x = -804.69, y = 177.55, z = 72.83},
}
local VehB7 = {
  {x = -815.58, y = 189.11, z = 72.48, h = 18.45},
}
local VsB7 = {
  { x = -826.91, y = 177.86, z = 71.16, h= 153.05},
}

--BADSIDE8-- --SS 2048-- --WRMC--
local StashB8 = {
  {x =  2519.67, y = 4100.49, z = 35.59, h = 330.49},
}
local BosB8 = {
  {x = 2518.6, y = 4098.16, z = 35.59},
}
local VehB8 = {
  {x = 2528.24, y = 4124.09, z = 38.58, h = 335.12},
}
local VsB8 = {
  { x = 2526.27, y = 4121.3, z = 38.58, h= 60.02},
}

--BADSIDE9-- --GROVE STREET-- --Royal Syndicate--
local StashB9 = {
  {x =  -4.2, y = -1817.95, z = 29.55, h = 48.51},
}
local BosB9 = {
  {x = 0.68, y = -1815.65, z = 29.55},
}
local VehB9 = {
  {x = 6.47, y = -1816.61, z = 25.35, h = 47.57},
}
local VsB9 = {
  {x = 10.86, y = -1819.58, z = 25.22, h= 139.63},
}

--BADSIDE10-- --Franklin A 6085-- --251 Area--
local StashB10 = {
  {x =  -8.34, y = 522.71, z = 174.63, h = 63.4},
}
local BosB10 = {
  {x = -6.95, y = 530.6, z = 175.0},
}
local VehB10 = {
  {x = 15.73, y = 543.93, z = 176.02, h = 241.3},
}
local VsB10 = {
  { x = 14.02, y = 548.7, z = 176.19, h= 60.95},
}

--BADSIDE11-- --MorningStar--
local StashB11 = {
  {x =  -344.78, y = -127.95, z = 39.01, h = 72.33},
}
local BosB11 = {
  {x = -324.87, y = -129.06, z = 39.01},
}
local VehB11 = {
  {x = -353.94, y = -137.47, z = 39.01, h = 137.93},
}
local VsB11 = {
  { x = -365.77, y = -117.93, z = 38.7, h= 108.16},
}

--BADSIDE12--
local StashB12 = {
  {x =  -803.45, y = 185.75, z = 72.61, h = 20.97},
}
local BosB12 = {
  {x = -808.46, y = 175.11, z = 76.74},
}
local VehB12 = {
  {x = -815.51, y = 189.0, z = 72.48, h = 24.42},
}
local VsB12 = {
  { x = -826.91, y = 177.86, z = 71.16, h= 153.05},
}

--BADSIDE13--
local StashB13 = {
  {x =  -803.45, y = 185.75, z = 72.61, h = 20.97},
}
local BosB13 = {
  {x = -808.46, y = 175.11, z = 76.74},
}
local VehB13 = {
  {x = -815.51, y = 189.0, z = 72.48, h = 24.42},
}
local VsB13 = {
  { x = -826.91, y = 177.86, z = 71.16, h= 153.05},
}

--BADSIDE14--
local StashB14 = {
  {x =  -803.45, y = 185.75, z = 72.61, h = 20.97},
}
local BosB14 = {
  {x = -808.46, y = 175.11, z = 76.74},
}
local VehB14 = {
  {x = -815.51, y = 189.0, z = 72.48, h = 24.42},
}
local VsB14 = {
  { x = -826.91, y = 177.86, z = 71.16, h= 153.05},
}

--PEDAGANG--
local cohvehpe = {
  {x = -625.79,  y = 247.28,  z = 81.63},
}

local cohbos = {
  {x = -634.51,  y = 228.11,  z = 81.88},    
}

local cobrankaspeda = {
  {x = -632.06,  y = 228.06,  z = 81.88},
}

local cohpeasu = {
  {x = -625.81,  y = 254.4,  z = 81.54, h= 93.8},
}

Citizen.CreateThread(function()
    --START OF BRANKAS--
    for k,v in pairs(coordsberangkasBiker) do
      alan = alan + 1
      exports["ox_target"]:AddBoxZone("coordsberangkasBiker" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "coordsberangkasBiker" .. alan,
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
        event = "jn-badside:invbiker",
        icon = "fas fa-suitcase",
        label = "Brankas",
        job = {
          ["biker"] = 3,
          ["biker"] = 2,
        }
        },
            {
          event = "jn-badside:spawnCar",
          icon = "fas fa-car",
          label = "Mobil",
          job = "biker",
        },
        {
          event = "jn-badside:spawnBike",
          icon = "fas fa-motorcycle",
          label = "Motor",
          job = "biker",
        },
        {
          event = "jn-core:hapusmobil",
          icon = "fas fa-sign-out-alt",
          label = "Masukkan Kendaraan",
          job = "biker",
        },
        },
        distance = 2.0
      })
    end

    for k,v in pairs(coordsberangkasCartel) do
      alan = alan + 1
      exports["ox_target"]:AddBoxZone("coordsberangkasCartel" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "coordsberangkasCartel" .. alan,
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
        event = "jn-badside:invcartel",
        icon = "fas fa-suitcase",
        label = "Brankas",
        job = {
          ["cartel"] = 3,
          ["catel"] = 2,
        }
        },
        },
        distance = 2.0
      })
    end

    for k,v in pairs(coordsberangkasYakuza) do
      alan = alan + 1
      exports["ox_target"]:AddBoxZone("coordsberangkasYakuza" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "coordsberangkasYakuza" .. alan,
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
        event = "jn-badside:invyakuza",
        icon = "fas fa-suitcase",
        label = "Brankas",
        job = {
          ["yakuza"] = 3,
          ["yakuza"] = 2,
        }
        },
        },
        distance = 2.0
      })
    end

    for k,v in pairs(coordsberangkasGang) do
      alan = alan + 1
      exports["ox_target"]:AddBoxZone("coordsberangkasGang" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "coordsberangkasGang" .. alan,
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
        event = "jn-badside:invgang",
        icon = "fas fa-suitcase",
        label = "Brankas",
        job = {
          ["gang"] = 3,
          ["gang"] = 2,
        }
        },
        },
        distance = 2.0
      })
    end

    for k,v in pairs(coordsberangkasMafia) do
      alan = alan + 1
      exports["ox_target"]:AddBoxZone("coordsberangkasMafia" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "coordsberangkasMafia" .. alan,
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
        event = "jn-badside:invmafia",
        icon = "fas fa-suitcase",
        label = "Brankas",
        job = {
          ["mafia"] = 3,
          ["mafia"] = 2,
        }
        },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(coordsberangkasOrmas) do
      alan = alan + 1
      exports["ox_target"]:AddBoxZone("coordsberangkasOrmas" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "coordsberangkasOrmas" .. alan,
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
        event = "jn-badside:invormas",
        icon = "fas fa-suitcase",
        label = "Brankas",
        job = {
          ["ormas"] = 3,
          ["ormas"] = 2,
        }
        },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(StashB7) do
      alan = alan + 1
      exports["ox_target"]:AddBoxZone("StashB7" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "StashB7" .. alan,
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
        event = "dl-job:StashB7",
        icon = "fas fa-suitcase",
        label = "Brankas",
        job = {
          ["badside7"] = 3,
          ["badside7"] = 2,
        }
        },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(StashB8) do
      alan = alan + 1
      exports["ox_target"]:AddBoxZone("StashB8" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "StashB8" .. alan,
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "dl-job:StashB8",
            icon = "fas fa-suitcase",
            label = "Brankas",
            job = {
              ["badside8"] = 3,
              ["badside8"] = 2,
            }
          },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(StashB9) do
      alan = alan + 1
      exports["ox_target"]:AddBoxZone("StashB9" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "StashB9" .. alan,
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "dl-job:StashB9",
            icon = "fas fa-suitcase",
            label = "Brankas",
            job = {
              ["badside9"] = 3,
              ["badside89"] = 2,
            }
          },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(StashB10) do
      alan = alan + 1
      exports["ox_target"]:AddBoxZone("StashB10" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "StashB10" .. alan,
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "dl-job:StashB10",
            icon = "fas fa-suitcase",
            label = "Brankas",
            job = {
              ["badside10"] = 3,
              ["badside10"] = 2,
            }
          },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(StashB11) do
      alan = alan + 1
      exports["ox_target"]:AddBoxZone("StashB11" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "StashB11" .. alan,
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "dl-job:StashB11",
            icon = "fas fa-suitcase",
            label = "Brankas",
            job = {
              ["badside11"] = 3,
              ["badside11"] = 2,
            }
          },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(StashB12) do
      alan = alan + 1
      exports["ox_target"]:AddBoxZone("StashB12" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "StashB12" .. alan,
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "dl-job:StashB12",
            icon = "fas fa-suitcase",
            label = "Brankas",
            job = {
              ["badside12"] = 3,
              ["badside12"] = 2,
            }
          },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(StashB13) do
      alan = alan + 1
      exports["ox_target"]:AddBoxZone("StashB13" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "StashB13" .. alan,
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "dl-job:StashB13",
            icon = "fas fa-suitcase",
            label = "Brankas",
            job = {
              ["badside13"] = 3,
              ["badside13"] = 2,
            }
          },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(StashB14) do
      alan = alan + 1
      exports["ox_target"]:AddBoxZone("StashB14" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "StashB14" .. alan,
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "dl-job:StashB14",
            icon = "fas fa-suitcase",
            label = "Brankas",
            job = {
              ["badside14"] = 3,
              ["badside14"] = 2,
            }
          },
        },
        distance = 2.0
      })
    end
    --END OFF BRANKAS--
    --START OF BOSSMENU--
    for k,v in pairs(coordsbossGang) do
      exports["ox_target"]:AddBoxZone("coordsbossGang", vector3(v.x, v.y, v.z), 1.8, 1.5, {
        name = "coordsbossGang",
        heading = 271.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
          event = "jn-badside:bossmenu",
          icon = "far fa-clipboard",
          label = "Boss Menu",
          job = "gang",
        },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(coordsbossMafia) do
      exports["ox_target"]:AddBoxZone("coordsbossMafia", vector3(v.x, v.y, v.z), 1.8, 1.5, {
        name = "coordsbossMafia",
        heading = 271.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
          event = "jn-badside:bossmenu",
          icon = "far fa-clipboard",
          label = "Boss Menu",
          job = "mafia",
        },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(coordsbossCartel) do
      exports["ox_target"]:AddBoxZone("coordsbossCartel", vector3(v.x, v.y, v.z), 1.8, 1.5, {
        name = "coordsbossCartel",
        heading = 271.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
          event = "jn-badside:bossmenu",
          icon = "far fa-clipboard",
          label = "Boss Menu",
          job = "cartel",
        },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(coordsbossBiker) do
      exports["ox_target"]:AddBoxZone("coordsbossBiker", vector3(v.x, v.y, v.z), 1.8, 1.5, {
        name = "coordsbossBiker",
        heading = 271.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
          event = "jn-badside:bossmenu",
          icon = "far fa-clipboard",
          label = "Boss Menu",
          job = "biker",
        },
        },
        job = {"biker"},
        distance = 2.0
      })
    end
    for k,v in pairs(coordsbossYakuza) do
      exports["ox_target"]:AddBoxZone("coordsbossYakuza", vector3(v.x, v.y, v.z), 1.8, 1.5, {
        name = "coordsbossYakuza",
        heading = 271.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
          event = "jn-badside:bossmenu",
          icon = "far fa-clipboard",
          label = "Boss Menu",
          job = "yakuza",
        },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(coordsbossOrmas) do
      exports["ox_target"]:AddBoxZone("coordsbossOrmas", vector3(v.x, v.y, v.z), 1.8, 1.5, {
        name = "coordsbossOrmas",
        heading = 271.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
          event = "jn-badside:bossmenu",
          icon = "far fa-clipboard",
          label = "Boss Menu",
          job = "ormas",
        },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(BosB7) do
      exports["ox_target"]:AddBoxZone("BosB7", vector3(v.x, v.y, v.z), 1.8, 1.5, {
        name = "BosB7",
        heading = 271.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
          event = "jn-badside:bossmenu",
          icon = "far fa-clipboard",
          label = "Boss Menu",
          job = "badside7",
        },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(BosB8) do
      exports["ox_target"]:AddBoxZone("BosB8", vector3(v.x, v.y, v.z), 1.8, 1.5, {
        name = "BosB8",
        heading = 271.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
          event = "jn-badside:bossmenu",
          icon = "far fa-clipboard",
          label = "Boss Menu",
          job = "badside8",
        },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(BosB9) do
      exports["ox_target"]:AddBoxZone("BosB9", vector3(v.x, v.y, v.z), 1.8, 1.5, {
        name = "BosB9",
        heading = 271.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
          event = "jn-badside:bossmenu",
          icon = "far fa-clipboard",
          label = "Boss Menu",
          job = "badside9",
        },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(BosB10) do
      exports["ox_target"]:AddBoxZone("BosB10", vector3(v.x, v.y, v.z), 1.8, 1.5, {
        name = "BosB10",
        heading = 271.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
          event = "jn-badside:bossmenu",
          icon = "far fa-clipboard",
          label = "Boss Menu",
          job = "badside10",
        },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(BosB11) do
      exports["ox_target"]:AddBoxZone("BosB11", vector3(v.x, v.y, v.z), 1.8, 1.5, {
        name = "BosB11",
        heading = 271.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
          event = "jn-badside:bossmenu",
          icon = "far fa-clipboard",
          label = "Boss Menu",
          job = "badside11",
        },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(BosB12) do
      exports["ox_target"]:AddBoxZone("BosB12", vector3(v.x, v.y, v.z), 1.8, 1.5, {
        name = "BosB12",
        heading = 271.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
          event = "jn-badside:bossmenu",
          icon = "far fa-clipboard",
          label = "Boss Menu",
          job = "badside12",
        },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(BosB13) do
      exports["ox_target"]:AddBoxZone("BosB13", vector3(v.x, v.y, v.z), 1.8, 1.5, {
        name = "BosB13",
        heading = 271.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
          event = "jn-badside:bossmenu",
          icon = "far fa-clipboard",
          label = "Boss Menu",
          job = "badside13",
        },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(BosB14) do
      exports["ox_target"]:AddBoxZone("BosB14", vector3(v.x, v.y, v.z), 1.8, 1.5, {
        name = "BosB14",
        heading = 271.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
          event = "jn-badside:bossmenu",
          icon = "far fa-clipboard",
          label = "Boss Menu",
          job = "badside14",
        },
        },
        distance = 2.0
      })
    end
    --END OFF BOSSMENU--
    --START OF VEHICLE--
    for k,v in pairs(coordsvehBiker) do
      exports["ox_target"]:AddBoxZone("Biker_Motor", vector3(v.x, v.y, v.z), 8.0, 7.0, {
        name = "Biker_Motor",
        heading = 149.32,
        debugPoly = false,
        minZ = 73.69,
        maxZ = 75.69
      }, {
        options = {
        {
          event = "jn-badside:spawnCar",
          icon = "fas fa-car",
          label = "Mobil",
          job = "biker",
        },
        {
          event = "jn-badside:spawnBike",
          icon = "fas fa-motorcycle",
          label = "Motor",
          job = "biker",
        },
        {
          event = "jn-core:hapusmobil",
          icon = "fas fa-sign-out-alt",
          label = "Masukkan Kendaraan",
          job = "biker",
        },
        },
        distance = 4.0
      })
    end
    for k,v in pairs(coordsvehCartel) do
      exports["ox_target"]:AddBoxZone("coordsvehCartel", vector3(v.x, v.y, v.z), 3.0, 4.0, {
        name = "coordsvehCartel",
        heading = 78.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "jn-badside:spawnCar",
            icon = "fas fa-car",
            label = "Mobil",
            job = "cartel",
          },
          {
            event = "jn-badside:spawnBike",
            icon = "fas fa-motorcycle",
            label = "Motor",
            job = "cartel",
          },
          {
            event = "jn-core:hapusmobil",
            icon = "fas fa-sign-out-alt",
            label = "Masukkan Kendaraan",
            job = "cartel",
          },
        },
        distance = 4.0
      })
    end
    for k,v in pairs(coordsvehYakuza) do
      exports["ox_target"]:AddBoxZone("coordsvehYakuza", vector3(v.x, v.y, v.z), 5.0, 6.5, {
        name = "coordsvehYakuza",
        heading = 57.72,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "jn-badside:spawnCar",
            icon = "fas fa-car",
            label = "Mobil",
            job = "yakuza",
          },
          {
            event = "jn-badside:spawnBike",
            icon = "fas fa-motorcycle",
            label = "Motor",
            job = "yakuza",
          },
          {
            event = "jn-core:hapusmobil",
            icon = "fas fa-sign-out-alt",
            label = "Masukkan Kendaraan",
            job = "yakuza",
          },
        },
        distance = 4.0
      })
    end
    for k,v in pairs(coordsvehGang) do
      exports["ox_target"]:AddBoxZone("coordsvehrGang", vector3(v.x, v.y, v.z), 5.0, 4.0, {
        name = "coordsvehrGang",
        heading = 2.92,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "jn-badside:spawnCar",
            icon = "fas fa-car",
            label = "Mobil",
            job = "gang",
          },
          {
            event = "jn-badside:spawnBike",
            icon = "fas fa-motorcycle",
            label = "Motor",
            job = "gang",
          },
          {
            event = "jn-core:hapusmobil",
            icon = "fas fa-sign-out-alt",
            label = "Masukkan Kendaraan",
            job = "gang",
          },
        },
        distance = 4.0
      })
    end
    for k,v in pairs(coordsvehMafia) do
      exports["ox_target"]:AddBoxZone("coordsvehMafia", vector3(v.x, v.y, v.z), 5.0, 4.0, {
        name = "coordsvehMafia",
        heading = 2.92,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "jn-badside:spawnCar",
            icon = "fas fa-car",
            label = "Mobil",
            job = "mafia",
          },
          {
            event = "jn-badside:spawnBike",
            icon = "fas fa-motorcycle",
            label = "Motor",
            job = "mafia",
          },
          {
            event = "jn-core:hapusmobil",
            icon = "fas fa-sign-out-alt",
            label = "Masukkan Kendaraan",
            job = "mafia",
          },
        },
        distance = 4.0
      })
    end
    for k,v in pairs(coordsvehOrmas) do
      exports["ox_target"]:AddBoxZone("coordsvehOrmas", vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "coordsvehOrmas",
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "jn-badside:spawnCar",
            icon = "fas fa-car",
            label = "Mobil",
            job = "ormas",
          },
          {
            event = "jn-badside:spawnBike",
            icon = "fas fa-motorcycle",
            label = "Motor",
            job = "ormas",
          },
          {
            event = "jn-core:hapusmobil",
            icon = "fas fa-sign-out-alt",
            label = "Masukkan Kendaraan",
            job = "ormas",
          },
        },
        distance = 4.0
      })
    end
    for k,v in pairs(VehB7) do
      exports["ox_target"]:AddBoxZone("VehB7", vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "VehB7",
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "jn-badside:spawnCar",
            icon = "fas fa-car",
            label = "Mobil",
            job = "badside7",
          },
          {
            event = "jn-badside:spawnBike",
            icon = "fas fa-motorcycle",
            label = "Motor",
            job = "badside7",
          },
          {
            event = "jn-core:hapusmobil",
            icon = "fas fa-sign-out-alt",
            label = "Masukkan Kendaraan",
            job = "badside7",
          },
        },
        distance = 4.0
      })
    end
    for k,v in pairs(VehB8) do
      exports["ox_target"]:AddBoxZone("VehB8", vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "VehB8",
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "jn-badside:spawnCar",
            icon = "fas fa-car",
            label = "Mobil",
            job = "badside8",
          },
          {
            event = "jn-badside:spawnBike",
            icon = "fas fa-motorcycle",
            label = "Motor",
            job = "badside8",
          },
          {
            event = "jn-core:hapusmobil",
            icon = "fas fa-sign-out-alt",
            label = "Masukkan Kendaraan",
            job = "badside8",
          },
        },
        distance = 4.0
      })
    end
    for k,v in pairs(VehB9) do
      exports["ox_target"]:AddBoxZone("VehB9", vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "VehB9",
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "jn-badside:spawnCar",
            icon = "fas fa-car",
            label = "Mobil",
            job = "badside9",
          },
          {
            event = "jn-badside:spawnBike",
            icon = "fas fa-motorcycle",
            label = "Motor",
            job = "badside9",
          },
          {
            event = "jn-core:hapusmobil",
            icon = "fas fa-sign-out-alt",
            label = "Masukkan Kendaraan",
            job = "badside9",
          },
        },
        distance = 4.0
      })
    end
    for k,v in pairs(VehB10) do
      exports["ox_target"]:AddBoxZone("VehB10", vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "VehB10",
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "jn-badside:spawnCar",
            icon = "fas fa-car",
            label = "Mobil",
            job = "badside10",
          },
          {
            event = "jn-badside:spawnBike",
            icon = "fas fa-motorcycle",
            label = "Motor",
            job = "badside10",
          },
          {
            event = "jn-core:hapusmobil",
            icon = "fas fa-sign-out-alt",
            label = "Masukkan Kendaraan",
            job = "badside10",
          },
        },
        distance = 4.0
      })
    end
    for k,v in pairs(VehB9) do
      exports["ox_target"]:AddBoxZone("VehB9", vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "VehB9",
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "jn-badside:spawnCar",
            icon = "fas fa-car",
            label = "Mobil",
            job = "badside9",
          },
          {
            event = "jn-badside:spawnBike",
            icon = "fas fa-motorcycle",
            label = "Motor",
            job = "badside9",
          },
          {
            event = "jn-core:hapusmobil",
            icon = "fas fa-sign-out-alt",
            label = "Masukkan Kendaraan",
            job = "badside9",
          },
        },
        distance = 4.0
      })
    end
    for k,v in pairs(VehB10) do
      exports["ox_target"]:AddBoxZone("VehB10", vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "VehB10",
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "jn-badside:spawnCar",
            icon = "fas fa-car",
            label = "Mobil",
            job = "badside10",
          },
          {
            event = "jn-badside:spawnBike",
            icon = "fas fa-motorcycle",
            label = "Motor",
            job = "badside10",
          },
          {
            event = "jn-core:hapusmobil",
            icon = "fas fa-sign-out-alt",
            label = "Masukkan Kendaraan",
            job = "badside10",
          },
        },
        distance = 4.0
      })
    end
    for k,v in pairs(VehB11) do
      exports["ox_target"]:AddBoxZone("VehB11", vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "VehB11",
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "jn-badside:spawnCar",
            icon = "fas fa-car",
            label = "Mobil",
            job = "badside11",
          },
          {
            event = "jn-badside:spawnBike",
            icon = "fas fa-motorcycle",
            label = "Motor",
            job = "badside11",
          },
          {
            event = "jn-core:hapusmobil",
            icon = "fas fa-sign-out-alt",
            label = "Masukkan Kendaraan",
            job = "badside11",
          },
        },
        distance = 4.0
      })
    end
    for k,v in pairs(VehB12) do
      exports["ox_target"]:AddBoxZone("VehB12", vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "VehB12",
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "jn-badside:spawnCar",
            icon = "fas fa-car",
            label = "Mobil",
            job = "badside12",
          },
          {
            event = "jn-badside:spawnBike",
            icon = "fas fa-motorcycle",
            label = "Motor",
            job = "badside12",
          },
          {
            event = "jn-core:hapusmobil",
            icon = "fas fa-sign-out-alt",
            label = "Masukkan Kendaraan",
            job = "badside12",
          },
        },
        distance = 4.0
      })
    end
    for k,v in pairs(VehB13) do
      exports["ox_target"]:AddBoxZone("VehB13", vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "VehB13",
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "jn-badside:spawnCar",
            icon = "fas fa-car",
            label = "Mobil",
            job = "badside13",
          },
          {
            event = "jn-badside:spawnBike",
            icon = "fas fa-motorcycle",
            label = "Motor",
            job = "badside13",
          },
          {
            event = "jn-core:hapusmobil",
            icon = "fas fa-sign-out-alt",
            label = "Masukkan Kendaraan",
            job = "badside13",
          },
        },
        distance = 4.0
      })
    end
    for k,v in pairs(VehB14) do
      exports["ox_target"]:AddBoxZone("VehB14", vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "VehB14",
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "jn-badside:spawnCar",
            icon = "fas fa-car",
            label = "Mobil",
            job = "badside14",
          },
          {
            event = "jn-badside:spawnBike",
            icon = "fas fa-motorcycle",
            label = "Motor",
            job = "badside14",
          },
          {
            event = "jn-core:hapusmobil",
            icon = "fas fa-sign-out-alt",
            label = "Masukkan Kendaraan",
            job = "badside14",
          },
        },
        distance = 4.0
      })
    end
    for k,v in pairs(cohvehpe) do
      exports["ox_target"]:AddBoxZone("cohvehpe", vector3(v.x, v.y, v.z), 1.8, 1.5, {
        name = "cohvehpe",
        heading = 271.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "jn-badside:spawnCar",
            icon = "fas fa-car",
            label = "Grandmax",
            job = "pedagang",
          },
          {
            event = "jn-core:hapusmobil",
            icon = "fas fa-sign-out-alt",
            label = "Masukkan Kendaraan",
            job = "pedagang",
          },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(cohbos) do
      exports["ox_target"]:AddBoxZone("cohbos", vector3(v.x, v.y, v.z), 1.8, 1.5, {
        name = "cohbos",
        heading = 271.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "jn-badside:bossmenu",
            icon = "fas fa-car",
            label = "Boss Menu",
            job = {
              ["pedagang"] = 4,
            }
          },
          {
            event = "midp-context:DutyPedagang",
            icon = "fas fa-sign-in-alt",
            label = "Duty Management",
                    job = {
              ["pedagang"] = 0,
              ["offpedagang"] = 0,
            }
          },
        },
        distance = 2.0
      })
    end
    for k,v in pairs(cobrankaspeda) do
      exports["ox_target"]:AddBoxZone("cobrankaspeda", vector3(v.x, v.y, v.z), 1.8, 1.5, {
        name = "cobrankaspeda",
        heading = 271.64,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
          {
            event = "pedagang:bukatas",
            icon = "fas fa-hotjar",
            label = "Buka Brankas",
            job = {
              ["pedagang"] = 0,
            }
          },
        },
        distance = 2.0
      })
    end
end)

RegisterNetEvent('jn-badside:invbiker')
AddEventHandler('jn-badside:invbiker', function()
	local ox_inventory = exports.ox_inventory
	ox_inventory:openInventory('stash', 'brankas_biker')
end)

RegisterNetEvent('jn-badside:invcartel')
AddEventHandler('jn-badside:invcartel', function()
	local ox_inventory = exports.ox_inventory
	ox_inventory:openInventory('stash', 'brankas_cartel')
end)

RegisterNetEvent('jn-badside:invyakuza')
AddEventHandler('jn-badside:invyakuza', function()
	local ox_inventory = exports.ox_inventory
	ox_inventory:openInventory('stash', 'brankas_yakuza')
end)

RegisterNetEvent('jn-badside:invgang')
AddEventHandler('jn-badside:invgang', function()
	local ox_inventory = exports.ox_inventory
	ox_inventory:openInventory('stash', 'brankas_gang')
end)

RegisterNetEvent('jn-badside:invmafia')
AddEventHandler('jn-badside:invmafia', function()
	local ox_inventory = exports.ox_inventory
	ox_inventory:openInventory('stash', 'brankas_mafia')
end)

RegisterNetEvent('jn-badside:invormas')
AddEventHandler('jn-badside:invormas', function()
	local ox_inventory = exports.ox_inventory
	ox_inventory:openInventory('stash', 'brankas_ormas')
end)

RegisterNetEvent('dl-job:StashB7')
AddEventHandler('dl-job:StashB7', function()
	local ox_inventory = exports.ox_inventory
	ox_inventory:openInventory('stash', 'brankas_b7')
end)

RegisterNetEvent('dl-job:StashB8')
AddEventHandler('dl-job:StashB8', function()
	local ox_inventory = exports.ox_inventory
	ox_inventory:openInventory('stash', 'brankas_b8')
end)

RegisterNetEvent('dl-job:StashB9')
AddEventHandler('dl-job:StashB9', function()
	local ox_inventory = exports.ox_inventory
	ox_inventory:openInventory('stash', 'brankas_b9')
end)

RegisterNetEvent('dl-job:StashB10')
AddEventHandler('dl-job:StashB10', function()
	local ox_inventory = exports.ox_inventory
	ox_inventory:openInventory('stash', 'brankas_b10')
end)

RegisterNetEvent('dl-job:StashB11')
AddEventHandler('dl-job:StashB11', function()
	local ox_inventory = exports.ox_inventory
	ox_inventory:openInventory('stash', 'brankas_b11')
end)

RegisterNetEvent('dl-job:StashB12')
AddEventHandler('dl-job:StashB12', function()
	local ox_inventory = exports.ox_inventory
	ox_inventory:openInventory('stash', 'brankas_b12')
end)

RegisterNetEvent('dl-job:StashB13')
AddEventHandler('dl-job:StashB13', function()
	local ox_inventory = exports.ox_inventory
	ox_inventory:openInventory('stash', 'brankas_b13')
end)

RegisterNetEvent('dl-job:StashB14')
AddEventHandler('dl-job:StashB14', function()
	local ox_inventory = exports.ox_inventory
	ox_inventory:openInventory('stash', 'brankas_b14')
end)

RegisterNetEvent('jn-badside:bossmenu')
AddEventHandler('jn-badside:bossmenu', function()
  local Data = ESX.GetPlayerData()
    if Data.job ~= nil and Data.job.name == 'biker' and Data.job.grade_name == 'boss' then
      ESX.UI.Menu.CloseAll()
      TriggerEvent('esx_society:openBossMenu', 'biker', function(data, menu)
        menu.close()
      end)
    elseif Data.job ~= nil and Data.job.name == 'gang' and Data.job.grade_name == 'boss' then
      ESX.UI.Menu.CloseAll()
      TriggerEvent('esx_society:openBossMenu', 'gang', function(data, menu)
        menu.close()
      end)
    elseif Data.job ~= nil and Data.job.name == 'cartel' and Data.job.grade_name == 'boss' then
      ESX.UI.Menu.CloseAll()
      TriggerEvent('esx_society:openBossMenu', 'cartel', function(data, menu)
        menu.close()
      end)
    elseif Data.job ~= nil and Data.job.name == 'mafia' and Data.job.grade_name == 'boss' then
      ESX.UI.Menu.CloseAll()
      TriggerEvent('esx_society:openBossMenu', 'mafia', function(data, menu)
        menu.close()
      end)
    elseif Data.job ~= nil and Data.job.name == 'pedagang' and Data.job.grade_name == 'boss' then
      ESX.UI.Menu.CloseAll()
      TriggerEvent('esx_society:openBossMenu', 'pedagang', function(data, menu)
        menu.close()
      end)
    elseif Data.job ~= nil and Data.job.name == 'yakuza' and Data.job.grade_name == 'boss' then
      ESX.UI.Menu.CloseAll()
      TriggerEvent('esx_society:openBossMenu', 'yakuza', function(data, menu)
        menu.close()
      end)
    elseif Data.job ~= nil and Data.job.name == 'ormas' and Data.job.grade_name == 'boss' then
      ESX.UI.Menu.CloseAll()
      TriggerEvent('esx_society:openBossMenu', 'ormas', function(data, menu)
        menu.close()
      end)
    elseif Data.job ~= nil and Data.job.name == 'badside7' and Data.job.grade_name == 'boss' then
      ESX.UI.Menu.CloseAll()
      TriggerEvent('esx_society:openBossMenu', 'badside7', function(data, menu)
        menu.close()
      end)
    elseif Data.job ~= nil and Data.job.name == 'badside8' and Data.job.grade_name == 'boss' then
      ESX.UI.Menu.CloseAll()
      TriggerEvent('esx_society:openBossMenu', 'badside8', function(data, menu)
        menu.close()
      end)
    elseif Data.job ~= nil and Data.job.name == 'badside9' and Data.job.grade_name == 'boss' then
      ESX.UI.Menu.CloseAll()
      TriggerEvent('esx_society:openBossMenu', 'badside9', function(data, menu)
        menu.close()
      end)
    elseif Data.job ~= nil and Data.job.name == 'badside10' and Data.job.grade_name == 'boss' then
      ESX.UI.Menu.CloseAll()
      TriggerEvent('esx_society:openBossMenu', 'badside10', function(data, menu)
        menu.close()
      end)
    elseif Data.job ~= nil and Data.job.name == 'badside11' and Data.job.grade_name == 'boss' then
      ESX.UI.Menu.CloseAll()
      TriggerEvent('esx_society:openBossMenu', 'badside11', function(data, menu)
        menu.close()
      end)
    elseif Data.job ~= nil and Data.job.name == 'badside12' and Data.job.grade_name == 'boss' then
      ESX.UI.Menu.CloseAll()
      TriggerEvent('esx_society:openBossMenu', 'badside12', function(data, menu)
        menu.close()
      end)
    elseif Data.job ~= nil and Data.job.name == 'badside13' and Data.job.grade_name == 'boss' then
      ESX.UI.Menu.CloseAll()
      TriggerEvent('esx_society:openBossMenu', 'badside13', function(data, menu)
        menu.close()
      end)
    elseif Data.job ~= nil and Data.job.name == 'badside14' and Data.job.grade_name == 'boss' then
      ESX.UI.Menu.CloseAll()
      TriggerEvent('esx_society:openBossMenu', 'badside14', function(data, menu)
        menu.close()
      end)
    end
end)

RegisterNetEvent('jn-badside:spawnCar')
AddEventHandler('jn-badside:spawnCar', function()
  local Data = ESX.GetPlayerData()
  local playerid = PlayerPedId()

      if Data.job ~= nil and Data.job.name == 'biker' then
        for k,v in pairs(coordsvehspawnBiker) do
          ESX.Game.SpawnVehicle('felon', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
            TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
            TriggerEvent('jn-core:maxveh', callback_vehicle)
            exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
          end)
        end
      elseif Data.job ~= nil and Data.job.name == 'gang' then
          for k,v in pairs(coordsvehspawnGang) do
            ESX.Game.SpawnVehicle('felon', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
              TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
              TriggerEvent('jn-core:maxveh', callback_vehicle)
              exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
            end)
          end
      elseif Data.job ~= nil and Data.job.name == 'cartel' then
        for k,v in pairs(coordsvehspawnCartel) do
          ESX.Game.SpawnVehicle('felon', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
            TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
            TriggerEvent('jn-core:maxveh', callback_vehicle)
            exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
          end)
        end
      elseif Data.job ~= nil and Data.job.name == 'mafia' then
        for k,v in pairs(coordsvehspawnMafia) do
          ESX.Game.SpawnVehicle('felon', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
            TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
            TriggerEvent('jn-core:maxveh', callback_vehicle)
            exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
          end)
        end
      elseif Data.job ~= nil and Data.job.name == 'yakuza' then
        for k,v in pairs(coordsvehspawnYakuza) do
          ESX.Game.SpawnVehicle('felon', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
            TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
            TriggerEvent('jn-core:maxveh', callback_vehicle)
            exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
          end)
        end
      elseif Data.job ~= nil and Data.job.name == 'pedagang' then
        for k,v in pairs(cohpeasu) do
          ESX.Game.SpawnVehicle('granmax', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
            TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
            TriggerEvent('jn-core:maxveh', callback_vehicle)
            exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
          end)
        end
      elseif Data.job ~= nil and Data.job.name == 'ormas' then
        for k,v in pairs(coordsvehspawnOrmas) do
          ESX.Game.SpawnVehicle('felon', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
            TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
            TriggerEvent('jn-core:maxveh', callback_vehicle)
            exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
          end)
        end
      elseif Data.job ~= nil and Data.job.name == 'badside7' then
        for k,v in pairs(VsB7) do
          ESX.Game.SpawnVehicle('felon', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
            TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
            TriggerEvent('jn-core:maxveh', callback_vehicle)
            exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
          end)
        end
      elseif Data.job ~= nil and Data.job.name == 'badside8' then
        for k,v in pairs(VsB8) do
          ESX.Game.SpawnVehicle('felon', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
            TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
            TriggerEvent('jn-core:maxveh', callback_vehicle)
            exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
          end)
        end
    elseif Data.job ~= nil and Data.job.name == 'badside9' then
      for k,v in pairs(VsB9) do
        ESX.Game.SpawnVehicle('felon', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'badside10' then
      for k,v in pairs(VsB10) do
        ESX.Game.SpawnVehicle('felon', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'badside11' then
      for k,v in pairs(VsB11) do
        ESX.Game.SpawnVehicle('felon', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'badside12' then
      for k,v in pairs(VsB12) do
        ESX.Game.SpawnVehicle('felon', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'badside13' then
      for k,v in pairs(VsB13) do
        ESX.Game.SpawnVehicle('felon', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'badside14' then
      for k,v in pairs(VsB14) do
        ESX.Game.SpawnVehicle('felon', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    end
end)

RegisterNetEvent('jn-badside:spawnBike')
AddEventHandler('jn-badside:spawnBike', function()
    local Data = ESX.GetPlayerData()
    local playerid = PlayerPedId()

    if Data.job ~= nil and Data.job.name == 'biker' then
      for k,v in pairs(coordsvehspawnBiker) do
        ESX.Game.SpawnVehicle('gargoyle', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'gang' then
      for k,v in pairs(coordsvehspawnGang) do
        ESX.Game.SpawnVehicle('gargoyle', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'cartel' then
      for k,v in pairs(coordsvehspawnCartel) do
        ESX.Game.SpawnVehicle('gargoyle', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'mafia' then
      for k,v in pairs(coordsvehspawnMafia) do
        ESX.Game.SpawnVehicle('gargoyle', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'yakuza' then
      for k,v in pairs(coordsvehspawnYakuza) do
        ESX.Game.SpawnVehicle('gargoyle', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'ormas' then
      for k,v in pairs(coordsvehspawnOrmas) do
        ESX.Game.SpawnVehicle('gargoyle', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'badside7' then
      for k,v in pairs(VsB7) do
        ESX.Game.SpawnVehicle('gargoyle', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'badside8' then
      for k,v in pairs(VsB8) do
        ESX.Game.SpawnVehicle('gargoyle', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'badside9' then
      for k,v in pairs(VsB9) do
        ESX.Game.SpawnVehicle('gargoyle', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'badside10' then
      for k,v in pairs(VsB10) do
        ESX.Game.SpawnVehicle('gargoyle', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'badside11' then
      for k,v in pairs(VsB11) do
        ESX.Game.SpawnVehicle('gargoyle', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'badside12' then
      for k,v in pairs(VsB12) do
        ESX.Game.SpawnVehicle('gargoyle', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'badside13' then
      for k,v in pairs(VsB13) do
        ESX.Game.SpawnVehicle('gargoyle', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    elseif Data.job ~= nil and Data.job.name == 'badside14' then
      for k,v in pairs(VsB14) do
        ESX.Game.SpawnVehicle('gargoyle', { x = v.x, y = v.y, z = v.z}, v.h, function(callback_vehicle)
          TaskWarpPedIntoVehicle(playerid, callback_vehicle, -1)
          TriggerEvent('jn-core:maxveh', callback_vehicle)
          exports['midp-kunci']:givePlayerKeys(GetVehicleNumberPlateText(callback_vehicle), true)
        end)
      end
    end
end)

RegisterNetEvent('jn-core:hapusmobil')
AddEventHandler('jn-core:hapusmobil', function()
    local ped = PlayerPedId()
    local vehicle = GetPlayersLastVehicle()
    local vehicleCoords = GetEntityCoords(vehicle)

    if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(ped), vehicleCoords) < 10.0 then
      ESX.Game.DeleteVehicle(vehicle)
    end
end)

RegisterNetEvent("pedagang:bukatas")
AddEventHandler("pedagang:bukatas", function()
  local ox_inventory = exports.ox_inventory
	ox_inventory:openInventory('stash', 'brankas_pedagang')
end)

--ROCKSTAR EDITOR--
RegisterNetEvent('dl-data:record', function()
  if IsRecording() then 
      exports['midp-tasknotify']:SendAlert('inform', 'Recording sedang berlangsung!', 3500)
  else
      StartRecording(1)
  end
end)

RegisterNetEvent('dl-data:stopRecord', function()
  if not IsRecording() then 
      exports['midp-tasknotify']:SendAlert('error', 'Recording tidak berlangsung!', 3500)
  else
      StopRecordingAndSaveClip()
  end
end)

RegisterNetEvent('dl-data:openRockstar', function()
  NetworkSessionLeaveSinglePlayer()
  ActivateRockstarEditor()
  DoScreenFadeIn(1)
end)

lib.registerContext({
  id = 'edit',
  title = 'DAILYLIFE ROLEPLAY',
  options = {
      {
          title = 'Start Recording',
          description = ' ',
          arrow = false,
          event = 'dl-data:record',
      },
      {
          title = 'Stop Recording',
          description = ' ',
          arrow = false,
          event = 'dl-data:stopRecord',
      },
      {
          title = 'Rockstar Editor',
          description = ' ',
          arrow = false,
          event = 'dl-data:openRockstar',
      }
  }
})

RegisterCommand('+openrockstar', function()
  lib.showContext('edit')
end)
exports["midp-core"]:registerKeyMapping('Rockstar Editor', '+openrockstar', '', '')