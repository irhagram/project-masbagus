ESX = nil

local IsRobbing = false
local LastVehicle = nil
local isLoggedIn = true

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
  Citizen.SetTimeout(1250, function()
      isLoggedIn = true
  end)
end)

Citizen.CreateThread(function()
    while ESX == nil do Wait(1) end
    while not ESX.IsPlayerLoaded() do Wait(1000) end
    isLoggedIn = true
end)

Citizen.CreateThread(function()
RegisterCommand('+IsLagiKunci', IsLagiKunci, false)
RegisterCommand('-IsLagiKunci', function() end, false)
end)

function IsLagiKunci()
	if IsDisabledControlPressed(0, 19) then 
		if kunci then
      ToggleLocks()
			kunci = false
		elseif not kunci then
      ToggleLocks()
			kunci = true
		end
	end
end

-- // Events \\ --

RegisterNetEvent('alan-kunci:setkunci')
AddEventHandler('alan-kunci:setkunci', function(Plate, Identifier, bool)
    Config.VehicleKeys[Plate] = {['Identifier'] = Identifier, ['HasKey'] = bool}
    LastVehicle = nil
end)

RegisterNetEvent('alan-kunci:kasihkunci')
AddEventHandler('alan-kunci:kasihkunci', function(TargetPlayer)
    local Vehicle, VehDistance = ESX.Game.GetClosestVehicle()
    local Player, Distance = ESX.Game.GetClosestPlayer()
    local Plate = GetVehicleNumberPlateText(Vehicle)
    ESX.TriggerServerCallback("alan-kunci:punyakunci", function(HasKey)
        if HasKey then
            if Player ~= -1 and Player ~= 0 and Distance < 2.3 then
              exports["alan-tasknotify"]:DoHudText("success", "Memberi Kunci Dengan Plat: "..Plate)
                 TriggerServerEvent('alan-kunci:kasihkuncis', GetPlayerServerId(Player), Plate, true)
            else
                exports["alan-tasknotify"]:DoHudText("error", "Tidak Ada Orang Di Sekitar!")
            end
        else
            exports["alan-tasknotify"]:DoHudText("error", "Anda Tidak Memiliki Kunci Mobil Ini!")
        end
    end, Plate)
end)

RegisterNetEvent('alan-kunci:kunciKendaraan')
AddEventHandler('alan-kunci:kunciKendaraan', function()
    ToggleLocks()
end)

-- // Functions \\ --

function givePlayerKeys(Plate, bool)
 TriggerServerEvent('alan-kunci:setkunci', Plate, bool)
end

function ToggleLocks()
 local Vehicle, VehDistance = ESX.Game.GetClosestVehicle()
 if Vehicle ~= nil and Vehicle ~= 0 then
    local VehicleCoords = GetEntityCoords(Vehicle)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    local VehicleLocks = GetVehicleDoorLockStatus(Vehicle)
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if VehDistance <= 5.0 then
        ESX.TriggerServerCallback("alan-kunci:punyakunci", function(HasKey)
         if HasKey then
            LoadAnim("anim@mp_player_intmenu@key_fob@")
            TaskPlayAnim(GetPlayerPed(-1), 'anim@mp_player_intmenu@key_fob@', 'fob_click' ,3.0, 3.0, -1, 49, 0, false, false, false)
            if VehicleLocks == 1 then
                Citizen.Wait(450)
                SetVehicleDoorsLocked(Vehicle, 2)
                ClearPedTasks(GetPlayerPed(-1))
                TriggerEvent('alan-kunci:lampu', Vehicle)
                exports["alan-tasknotify"]:DoHudText("error", "Kendaraan Terkunci!")
                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.2, PlayerCoords)
            else
                Citizen.Wait(450)
                SetVehicleDoorsLocked(Vehicle, 1)
                ClearPedTasks(GetPlayerPed(-1))
                TriggerEvent('alan-kunci:lampu', Vehicle)
                exports["alan-tasknotify"]:DoHudText("success", "Kendaraan Terbuka!")
                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "unlock", 0.2, PlayerCoords)
            end
         else
            exports["alan-tasknotify"]:DoHudText("error", "Anda Tidak Memiliki Kunci Mobil Ini!")
        end
    end, Plate)
    end
 end
end

RegisterNetEvent('alan-kunci:lampu')
AddEventHandler('alan-kunci:lampu', function(Vehicle)
 SetVehicleLights(Vehicle, 2)
 SetVehicleBrakeLights(Vehicle, true)
 SetVehicleInteriorlight(Vehicle, true)
 SetVehicleIndicatorLights(Vehicle, 0, true)
 SetVehicleIndicatorLights(Vehicle, 1, true)
 Citizen.Wait(450)
 SetVehicleIndicatorLights(Vehicle, 0, false)
 SetVehicleIndicatorLights(Vehicle, 1, false)
 Citizen.Wait(450)
 SetVehicleInteriorlight(Vehicle, true)
 SetVehicleIndicatorLights(Vehicle, 0, true)
 SetVehicleIndicatorLights(Vehicle, 1, true)
 Citizen.Wait(450)
 SetVehicleLights(Vehicle, 0)
 SetVehicleBrakeLights(Vehicle, false)
 SetVehicleInteriorlight(Vehicle, false)
 SetVehicleIndicatorLights(Vehicle, 0, false)
 SetVehicleIndicatorLights(Vehicle, 1, false)
end)

function LoadAnim(animDict)
    RequestAnimDict(animDict)
  
    while not HasAnimDictLoaded(animDict) do
      Citizen.Wait(10)
    end
  end
  
  function LoadModel(model)
    RequestModel(model)
  
    while not HasModelLoaded(model) do
      Citizen.Wait(10)
    end
  end
  