AddEventHandler('esx:nui_ready', function()
    CreateFrame('qidentification', 'nui://' .. GetCurrentResourceName() .. '/modules/qidentification/data/html/ui.html')
end)



-- When (re)starting the resource, make sure we turn these state bags off just to be safe
LocalPlayer.state:set('idshown',false,false)
LocalPlayer.state:set('idvisible',false,false)

-- Register a keymapping for the "stop" command (to close the id)

-- Register an empty 'stop' command for future use
RegisterCommand('cancel', function()
	SendFrameMessage('qidentification',{
        action = "close"
    })
    LocalPlayer.state:set('idshown',false,false)
end)

RegisterNetEvent('qidentification:identification')
AddEventHandler('qidentification:identification', function()
	local item = exports.ox_inventory:Items("identification")
	if item then
		TriggerEvent('qidentification:showID',item)
	end
end)
RegisterNetEvent('qidentification:drivers_license')
AddEventHandler('qidentification:drivers_license', function()
	local item = exports.ox_inventory:Items("drivers_license")
	if item then
		TriggerEvent('qidentification:showID',item)
	end
end)
RegisterNetEvent('qidentification:firearms_license')
AddEventHandler('qidentification:firearms_license', function()
	local item = exports.ox_inventory:Items("firearms_license")
	if item then
		TriggerEvent('qidentification:showID',item)
	end
end)

exports('Showidentification',function (data,slot)
    exports.ox_inventory:useItem(data, function(data)
        if data then
            local item = exports.ox_inventory:Items("identification")
            if item then
                TriggerEvent('qidentification:showID',item)
            end
        end
    end)
end)
exports('Showdrivers_license',function (data,slot)
    exports.ox_inventory:useItem(data, function(data)
        if data then
            local item = exports.ox_inventory:Items("drivers_license")
            if item then
                TriggerEvent('qidentification:showID',item)
            end
        end
    end)
end)
exports('Showfirearms_license',function (data,slot)
    exports.ox_inventory:useItem(data, function(data)
        if data then
            local item = exports.ox_inventory:Items("firearms_license")
            if item then
                TriggerEvent('qidentification:showID',item)
            end
        end
    end)
end)


-- Event to show your ID to nearby players
RegisterNetEvent('qidentification:showID')
AddEventHandler('qidentification:showID', function(item)
	if not LocalPlayer.state.idshown  then
		local playersInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), Kartu.DistanceShowID)
		-- loop through players in area and show them the id
		if #playersInArea > 0 then 
			TriggerServerEvent('qidentification:server:showID',item.name,playersInArea)
			TriggerEvent('qidentification:openID',item.name)
		end
		-- set a flag 
		LocalPlayer.state:set('idshown',true,false)
		-- open it for yourself too
		TriggerEvent('qidentification:openID',item.name)
		Citizen.CreateThread(function()
			-- Fire and forget cooldown
			Citizen.Wait(300)
			LocalPlayer.state:set('idshown',false,false) -- Doesn't need to be replicated to the server
		end)
	end
end)

-- Event to show your ID to nearby players
RegisterNetEvent('qidentification:openID')
AddEventHandler('qidentification:openID', function(item)
	if LocalPlayer.state.idvisible == nil or not LocalPlayer.state.idvisible then 
		TriggerEvent('qidentification:showUI',item)
	end 
end)

-- NUI Events 
-- We define a "stop" command inside this too
RegisterNetEvent('qidentification:showUI')
AddEventHandler('qidentification:showUI', function(data)
	LocalPlayer.state:set('idvisible',true,false)
	local id = exports.ox_inventory:Search(1, data)
	for _, v in pairs(id) do
		SendFrameMessage('qidentification',{
			action = "open",
			metadata = v.metadata
		})

		RegisterCommand('cancel', function()
			SendFrameMessage('qidentification',{
				action = "close"
			})
			LocalPlayer.state:set('idvisible',false,false)
			-- Once the NUI is closed, we redefine the command to do nothing again, so it can be used by other resources
			RegisterCommand('cancel', function()
				-- empty the command
			end)
		end)
	end

end)

-- Backup command to force close any id shown on your screen (in case something breaks)
RegisterCommand('closeidentification',function()
	SendFrameMessage('qidentification',{
		action = "close"
	})
	LocalPlayer.state:set('idvisible',false,false)
end)


--[[]if Kartu.EnableLicenseBlip then
    Citizen.CreateThread(function()
		for k,v in pairs(Kartu.LicenseLocation) do
			for i = 1, #v.LicenseLocation, 1 do
				local blip = AddBlipForCoord(v.LicenseLocation[i])
				
				SetBlipSprite (blip, 525)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 0.8)
				SetBlipColour (blip, 59)
				SetBlipAsShortRange(blip, true)
				
				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(Kartu.LicenseBlipName)
				EndTextCommandSetBlipName(blip)
			end
		end
	end)
end]]--