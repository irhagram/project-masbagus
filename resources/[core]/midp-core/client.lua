

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	while (ESX == nil) do Citizen.Wait(100) end
    PlayerData = xPlayer
	FreezeEntityPosition(PlayerPedId(), false)
	--TriggerServerEvent('bixbi_core:RemoveFromInstance', GetPlayerServerId(PlayerId()))
end)

AddEventHandler('esx:onPlayerSpawn', function()
	local playerPed = PlayerPedId()
	if GetEntityHealth(playerPed) ~=  20000 then
		SetEntityMaxHealth(playerPed, 20000)
		SetEntityHealth(playerPed, 20000)
	end
	TriggerServerEvent('midp-core:RemoveFromInstance', GetPlayerServerId(PlayerId()))
end)

function playAnim(ped, animDict, animName, duration, emoteMoving, playbackRate)
	local movingType = 49
	if (emoteMoving == nil) then 
		movingType = 49
	elseif (emoteMoving == false) then
		movingType = 0
	end
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Citizen.Wait(100) end

	local playbackSpeed = playbackRate or 0
    -- TaskPlayAnim(ped, animDict, animName, 1.0, -1.0, duration, movingType, 1, false, false, false)
	TaskPlayAnim(ped, animDict, animName, 2.0, 2.0, duration, movingType, playbackSpeed, false, false, false)
    RemoveAnimDict(animDict)
end

function addProp(ped, prop1, bone, off1, off2, off3, rot1, rot2, rot3, timer)
	local x,y,z = table.unpack(GetEntityCoords(ped))
	if not HasModelLoaded(prop1) then LoadPropDict(prop1) end
  
	prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
	SetModelAsNoLongerNeeded(prop1)
	Citizen.Wait(timer)
	DeleteEntity(prop)
  end

function itemCount(item, metadata)
	if (Config.OxInventory) then
		return exports.ox_inventory:Search(2, item, metadata)
	else
		ESX.TriggerServerCallback('midp-core:itemCount', function(itemCount)
			while (itemCount == nil) do Citizen.Wait(100) end
			return itemCount
		end, item)
	end
end

exports('itemCount', itemCount)
AddEventHandler('midp-core:itemCount', function(item, metadata)
	return itemCount(item, metadata)
end)

function isWidescreenAspectRatio()
	local aspectRatio = ESX.Math.Round(GetAspectRatio(true), 2)
	if (aspectRatio == 1.6) then
		-- 16:10
		return true
	elseif (aspectRatio == 2.33) then
		-- 21:9
		return true
	end
	return false
end
exports('isWidescreenAspectRatio', isWidescreenAspectRatio)

RegisterNetEvent('midp-core:UseCommand')
AddEventHandler('midp-core:UseCommand', function(cmd)
	ExecuteCommand(cmd)
end)

AddEventHandler('midp-core:SetClothing', function(Type, Drawable, Texture)
    -- Requires: https://github.com/ZiggyJoJo/brp-fivem-appearance or https://github.com/pedr0fontoura/fivem-appearance
    local playerPed = PlayerPedId()
    Type = string.lower(Type)

    --https://wiki.rage.mp/index.php?title=Clothes
    if (Type == 'hat') then -- head
        exports['fivem-appearance']:setPedProp(playerPed, { prop_id = 0, drawable = Drawable, texture = Texture })
    elseif (Type == 'glasses') then -- glasses
        exports['fivem-appearance']:setPedProp(playerPed, { prop_id = 1, drawable = Drawable, texture = Texture })
    elseif (Type == 'mask') then -- masks
        exports['fivem-appearance']:setPedComponent(playerPed, { component_id = 1, drawable = Drawable, texture = Texture })
    elseif (Type == 'jacket') then -- tops
        exports['fivem-appearance']:setPedComponent(playerPed, { component_id = 11, drawable = Drawable, texture = Texture })
    elseif (Type == 'chain') then -- accessories
        exports['fivem-appearance']:setPedComponent(playerPed, { component_id = 7, drawable = Drawable, texture = Texture })
    elseif (Type == 'arm') then -- torso
        exports['fivem-appearance']:setPedComponent(playerPed, { component_id = 3, drawable = Drawable, texture = Texture })
    elseif (Type == 'shirt') then -- undershirt
        exports['fivem-appearance']:setPedComponent(playerPed, { component_id = 8, drawable = Drawable, texture = Texture })
    elseif (Type == 'leg') then -- legs
        exports['fivem-appearance']:setPedComponent(playerPed, { component_id = 4, drawable = Drawable, texture = Texture })
    elseif (Type == 'shoes') then -- shoes
        exports['fivem-appearance']:setPedComponent(playerPed, { component_id = 6, drawable = Drawable, texture = Texture })
    elseif (Type == 'armour') then -- body armors
        exports['fivem-appearance']:setPedComponent(playerPed, { component_id = 9, drawable = Drawable, texture = Texture })
    end
end)
