
----------------------------------------------------------------------------------
RegisterNetEvent("midp-admin:killPlayer")
AddEventHandler("midp-admin:killPlayer", function()
  SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent("midp-admin:slapplayer")
AddEventHandler("midp-admin:slapplayer", function()
	ApplyForceToEntity(PlayerPedId(), 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false)
end)

RegisterNetEvent("midp-admin:flyplayer")
AddEventHandler("midp-admin:flyplayer", function()
	local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    SetEntityCoords(PlayerPedId(), x, y, 2680.32)
end)

RegisterNetEvent("midp-admin:freezeplayer")
AddEventHandler("midp-admin:freezeplayer", function()
	local targetPed = PlayerPedId()
    freeze = not freeze
    if freeze then
        FreezeEntityPosition(targetPed, true)
    else
        FreezeEntityPosition(targetPed, false)
    end
end)
RegisterNetEvent("midp-admin:spawnobj")
AddEventHandler("midp-admin:spawnobj", function(objeknya)
	local playerPed = PlayerPedId()
	local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
	local objectCoords = (coords + forward * 3.0)

		ESX.Game.SpawnObject(objeknya, objectCoords, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
	end)
end)

-------- noclip --------------
local x = 0.01135
local y = 0.002
local noclip = false
local level = 0
RegisterNetEvent("midp-admin:noclip")
AddEventHandler("midp-admin:noclip", function(input)
    local player = PlayerId()
	local ped = PlayerPedId
	
    local msg = "disabled"
	if(noclip == false)then
		noclip_pos = GetEntityCoords(PlayerPedId(), false)
	end

	noclip = not noclip

	if(noclip)then
		msg = "enabled"
	end

	--TriggerEvent("chatMessage", "Noclip has been ^2^*" .. msg)
	end)
	
	local heading = 0
	Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if(noclip)then
			local currentSpeed = 2
			local noclipEntity =
			IsPedInAnyVehicle(PlayerPedId(), false) and GetVehiclePedIsUsing(PlayerPedId()) or PlayerPedId()
			FreezeEntityPosition(PlayerPedId(), true)
			SetEntityInvincible(PlayerPedId(), true)
			local newPos = GetEntityCoords(entity)

			DisableControlAction(0, 32, true) --MoveUpOnly
			DisableControlAction(0, 268, true) --MoveUp

			DisableControlAction(0, 31, true) --MoveUpDown

			DisableControlAction(0, 269, true) --MoveDown
			DisableControlAction(0, 33, true) --MoveDownOnly

			DisableControlAction(0, 266, true) --MoveLeft
			DisableControlAction(0, 34, true) --MoveLeftOnly

			DisableControlAction(0, 30, true) --MoveLeftRight

			DisableControlAction(0, 267, true) --MoveRight
			DisableControlAction(0, 35, true) --MoveRightOnly

			DisableControlAction(0, 44, true) --Cover
			DisableControlAction(0, 20, true) --MultiplayerInfo

			local yoff = 0.0
			local zoff = 0.0

			if GetInputMode() == "MouseAndKeyboard" then
				if IsDisabledControlPressed(0, 32) then
					yoff = 0.5
				end
				if IsDisabledControlPressed(0, 33) then
					yoff = -0.5
				end
				if IsDisabledControlPressed(0, 34) then
					SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 3.0)
				end
				if IsDisabledControlPressed(0, 35) then
					SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - 3.0)
				end
				if IsDisabledControlPressed(0, 44) then
					zoff = 0.21
				end
				if IsDisabledControlPressed(0, 20) then
					zoff = -0.21
				end
			end

			newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (currentSpeed + 0.3), zoff * (currentSpeed + 0.3))

			local heading = GetEntityHeading(noclipEntity)
			SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
			SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
			SetEntityHeading(noclipEntity, heading)
			SetEntityCollision(noclipEntity, false, false)
			SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)
			FreezeEntityPosition(noclipEntity, false)
			SetEntityInvincible(noclipEntity, false)
			SetEntityCollision(noclipEntity, true, true)
		else
			Citizen.Wait(200)
		end
	end
end)

function GetInputMode()
	return Citizen.InvokeNative(0xA571D46727E2B718, 2) and "MouseAndKeyboard" or "GamePad"
end

RegisterNetEvent("midp-admin:tpm")
AddEventHandler("midp-admin:tpm", function()
    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                break
            end

            Citizen.Wait(5)
        end
        --TriggerEvent('chatMessage', _U('teleported'))
    else
        --TriggerEvent('chatMessage', _U('set_waypoint'))
    end
end)

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1+w, y - 0.02+h)
end