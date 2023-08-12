local PlayerData    = {}
local isInVehicle   = false


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        isInVehicle = IsPedInAnyVehicle(PlayerPedId(), true)
    end
end)

Citizen.CreateThread(function()
    while true do
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        local ped = GetPlayerPed(-1)
        local vehicleClass = GetVehicleClass(vehicle)
        
        if isInVehicle then
            if vehicleClass == 18 and GetPedInVehicleSeat(vehicle, -1) == ped then
                if PlayerData.job ~= nil and PlayerData.job.name ~= 'police' and PlayerData.job.name ~= 'ambulance' and PlayerData.job.name ~= 'mechanic' and PlayerData.job.name ~= 'admin' and PlayerData.job.name ~= 'state' then
                    ClearPedTasksImmediately(ped)
                    TaskLeaveVehicle(ped,vehicle,0)
                end
            end
            if vehicleClass == 15 and GetPedInVehicleSeat(vehicle, -1) == ped then
                if PlayerData.job ~= nil and PlayerData.job.name ~= 'police' and PlayerData.job.name ~= 'ambulance' and PlayerData.job.name ~= 'mechanic' and PlayerData.job.name ~= 'admin' and PlayerData.job.name ~= 'state' then
                    ClearPedTasksImmediately(ped)
                    TaskLeaveVehicle(ped,vehicle,0)
                end
            end
            if vehicleClass == 16 and GetPedInVehicleSeat(vehicle, -1) == ped then
                if PlayerData.job ~= nil and PlayerData.job.name ~= 'police' and PlayerData.job.name ~= 'ambulance' and PlayerData.job.name ~= 'mechanic' and PlayerData.job.name ~= 'admin' and PlayerData.job.name ~= 'state' then
                    ClearPedTasksImmediately(ped)
                    TaskLeaveVehicle(ped,vehicle,0)
                    TriggerServerEvent('KickPlayer:EmergencyVehicle', "Jangan menggunakan kendaraan petugas!")
                    Citizen.Wait(1000)
                end
            end
        end
        Citizen.Wait(1000)
    end
end)