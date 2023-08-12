local myIDServer        = 0

ESX = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end

    myIDServer = GetPlayerServerId(PlayerId())
end)

local nbrDisplaying = 1

RegisterCommand('me', function(source, args, raw)
    local text = string.sub(raw, 4)
    TriggerServerEvent('3dme:shareDisplay', text)
end)

RegisterCommand('do', function(source, args, raw)
    local text1 = string.sub(raw, 4)
    TriggerServerEvent('3ddo:shareDisplay', text1)
end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, serverId)
    local ped = GetPlayerPed(GetPlayerFromServerId(serverId))
    Display(ped, text, serverId)
end)

RegisterNetEvent('3ddo:triggerDisplay')
AddEventHandler('3ddo:triggerDisplay', function(text1, serverId)
    local ped = GetPlayerPed(GetPlayerFromServerId(serverId))
    Display1(ped, text1, serverId)
end)

local pedDisplaying = {}
local displayTime = 5000

function Display(ped, text, serverId)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)
	
    if pedCoords ~= playerCoords or serverId == myIDServer then
        if dist <= 10 then
            pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1
            local display = true
            CreateThread(function()
                Wait(displayTime)
                display = false
            end)
            local offset = 0.1 + pedDisplaying[ped] * 0.1
            while display do
                if HasEntityClearLosToEntity(playerPed, ped, 17 ) then
                    local x, y, z = table.unpack(GetEntityCoords(ped))
                    z = z + offset
                    DrawText3D(x, y, z, text)
                end
                Wait(0)
            end
            pedDisplaying[ped] = pedDisplaying[ped] - 1
        end
    end
end

function Display1(ped, text1, serverId)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)
	
    if pedCoords ~= playerCoords or serverId == myIDServer then
        if dist <= 10 then
            pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1
            local display = true
            CreateThread(function()
                Wait(displayTime)
                display = false
            end)
            local offset = 0.75 + pedDisplaying[ped] * 0.1
            while display do
                if HasEntityClearLosToEntity(playerPed, ped, 17 ) then
                    local x, y, z = table.unpack(GetEntityCoords(ped))
                    z = z + offset
                    DrawText3D1(x, y, z, text1)
                end
                Wait(0)
            end
            pedDisplaying[ped] = pedDisplaying[ped] - 1
        end
    end
end

RegisterNetEvent("3dme:playerDropped")
AddEventHandler("3dme:playerDropped", function(id, crds, identifier, reason)
    local displaying = true

    CreateThread(function()
        Wait(30000)
        displaying = false
    end)

    CreateThread(function()
        while displaying do
            Wait(5)
            local pcoords = GetEntityCoords(PlayerPedId())
            if GetDistanceBetweenCoords(crds.x, crds.y, crds.z, pcoords.x, pcoords.y, pcoords.z, true) < 15.0 then
                DrawText3D(crds.x, crds.y, crds.z, "ID: "..id.." ("..identifier..")\nReason: "..reason)
            else 
                Wait(2000)
            end
        end
    end)
end)

RegisterNetEvent('3ddo:sendProximityMessage')
AddEventHandler('3ddo:sendProximityMessage', function(playerId, title, message, color)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local ped = GetPlayerPed(GetPlayerFromServerId(playerId))
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)
    local myIDServer = GetPlayerServerId(PlayerId())
    
    if pedCoords ~= playerCoords or playerId == myIDServer then
        if dist <= 15 then
            TriggerEvent('chat:addMessage', { 
                template = '<div class="chat-message-do"><b>{0}</b> {1}</div>',
                args = { title, message }
            })
        end
    end
end)

function DrawText3D(x,y,z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
		local factor = (string.len(text)) / 370
        DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 3, 8, 113, 68)
    end
end

function DrawText3D1(x,y,z, text1)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text1)
		DrawText(_x,_y)
		local factor = (string.len(text1)) / 370
        DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 255, 182, 193, 68)
    end
end