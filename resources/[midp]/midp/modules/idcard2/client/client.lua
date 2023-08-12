AddEventHandler('esx:nui_ready', function()
    CreateFrame('idcard2', 'nui://' .. GetCurrentResourceName() .. '/modules/idcard2/data/html/ui.html')
end)

LocalPlayer.state:set('idshown',false,false)
LocalPlayer.state:set('idvisible',false,false)

RegisterKeyMapping('cancel', 'Cancel Action', 'keyboard', 'x')

RegisterCommand('cancel', function()
	-- empty the command
end)

local ox_inventory = exports.ox_inventory
exports('identification', function(data, slot)
	if not LocalPlayer.state.idshown  then 
		ox_inventory:useItem(data, function(data)
			if data then
				TriggerEvent('dl-idcard:showID',data)
			end
		end)
	else
		ox_inventory:notify({text = 'License is in cooldown.'})
	end
end)

RegisterNetEvent('dl-idcard:showID')
AddEventHandler('dl-idcard:showID', function(item)
	if not LocalPlayer.state.idshown  then 
		local playersInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), Config.DistanceShowID)
		if #playersInArea > 0 then 
			local Playerinareaid = {}
			for i = 1, #playersInArea do
				table.insert(Playerinareaid, GetPlayerServerId(playersInArea[i]))
			end
			TriggerServerEvent('dl-idcard:server:showID',item,Playerinareaid)
			TriggerEvent('dl-idcard:openID',item)
		end
		LocalPlayer.state:set('idshown',true,false)
		TriggerEvent('dl-idcard:openID',item)
		Citizen.CreateThread(function()
			Citizen.Wait(Config.ShowIDCooldown * 1000)
			LocalPlayer.state:set('idshown',false,false)
		end)
	end 
end)

RegisterNetEvent('dl-idcard:openID')
AddEventHandler('dl-idcard:openID', function(item)
	if LocalPlayer.state.idvisible == nil or not LocalPlayer.state.idvisible then 
		TriggerEvent('dl-idcard:showUI',item)
	end 
end)

RegisterNetEvent('dl-idcard:showUI')
AddEventHandler('dl-idcard:showUI', function(data)
	LocalPlayer.state:set('idvisible',true,false)
	SendFrameMessage('idcard2',{
		action = "open",
		metadata = data.metadata
	})
	RegisterCommand('cancel', function()
		SendFrameMessage('idcard2',{
			action = "close"
		})
		LocalPlayer.state:set('idvisible',false,false)
		RegisterCommand('cancel', function()
			-- empty the command
		end)
	end)
end)

RegisterCommand('closeidentification',function()
	SendFrameMessage('idcard2',{
		action = "close"
	})
	LocalPlayer.state:set('idvisible',false,false)
end)

if Config.EnableLicenseBlip then
    Citizen.CreateThread(function()
		for k,v in pairs(Config.LicenseLocation) do
			for i = 1, #v.LicenseLocation, 1 do
				local blip = AddBlipForCoord(v.LicenseLocation[i])
				
				SetBlipSprite (blip, 483)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 0.8)
				SetBlipColour (blip, 17)
				SetBlipAsShortRange(blip, true)
				
				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(Config.LicenseBlipName)
				EndTextCommandSetBlipName(blip)
			end
		end
	end)
end
