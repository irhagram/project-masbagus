RegisterNetEvent('dl-idcard:requestLicense')
AddEventHandler('dl-idcard:requestLicense',function()

	local sendMenu = {
		{
			id = 1,
			header = "<h6>PEMERINTAH DAILYLIFE</h6>",
			txt = "",
			params = { 
				event = "fakeevent",
				args = {}
			}
		}
	}

	for i=1,#Config.IdentificationData,1 do 
		data = Config.IdentificationData[i]
		table.insert(sendMenu,{
			id = #sendMenu + 1,
			header = "<span class='target-icon'><i class='fa-solid fa-id-card fa-fw'></i></span> Request "..data.label,
			txt = "$"..data.cost,
			params = { 
				event = "dl-idcard:applyForLicense",
				args = {
					item = data.item
				}
			}
		})
	end

	table.insert(sendMenu,
	{
		id = 99,
		header = "<span class='target-icon'><i class='fa-solid fa-circle-xmark fa-fw'></i></span> Cancel",
		txt = "",
		params = {
			event = "dl-idcard:cancel",
		}
	})

	TriggerEvent('alan-context:sendMenu', sendMenu)
end)

RegisterNetEvent('dl-idcard:applyForLicense')
AddEventHandler('dl-idcard:applyForLicense',function(data)
	local identificationData = nil
	local mugshotURL = nil

	for k,v in pairs(Config.IdentificationData) do 
		if v.item == data.item then 
			identificationData = v
			break
		end
	end

	if Config.CustomMugshots then 
		local data = exports.ox_inventory:Keyboard('Custom Mugshot URL (Leave blank for default)', {'Direct Image URL (link foto)'})
	
		if data then
			mugshotURL = data[1]
		else
			print('No value was entered into the field!')
		end
	else
		if Config.MugshotsBase64 then
			mugshotURL = exports[Config.MugshotScriptName]:GetMugShotBase64(PlayerPedId(), false)
		else
			local p = promise.new()
			exports[Config.MugshotScriptName]:getMugshotUrl(PlayerPedId(), function(url)
				mugshotURL = url
				p:resolve()
			end)
			Citizen.Await(p)		
		end
	end 
	TriggerServerEvent('dl-idcard:server:payForLicense',identificationData,mugshotURL)
end)
