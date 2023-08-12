-- This file manages the main menu parts of the code. 
-- I separated it here becuase it relies on nh-context and nh-keyboard and you may wish to replace it with your own method, maybe using ESX Menu Default? 

-- The event called by the qtarget to open the menu
RegisterNetEvent('qidentification:requestLicense')
AddEventHandler('qidentification:requestLicense',function()

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

	-- loop through identification data defined in Kartu.lua and add options for each entry
	for i=1,#Kartu.IdentificationData,1 do 
		data = Kartu.IdentificationData[i]
		table.insert(sendMenu,{
			id = #sendMenu + 1,
			header = "<span class='target-icon'><i class='fa-solid fa-id-card fa-fw'></i></span> Request "..data.label,
			txt = "$"..data.cost,
			params = { 
				event = "qidentification:applyForLicense",
				args = {
					item = data.item
				}
			}
		})
	end

	-- not necessary as you can hit "escape" to leave the nh-context menu, but I define a cancel button because it looks nice and makes sense from a user experience perspective
	table.insert(sendMenu,
	{
		id = 99,
		header = "<span class='target-icon'><i class='fa-solid fa-circle-xmark fa-fw'></i></span> Kembali",
		txt = "",
		params = {
			event = "qidentification:cancel",
		}
	})

	-- actually trigger the menu event 
	TriggerEvent('midp-context:sendMenu', sendMenu)
end)


-- the event that handles applying for license
RegisterNetEvent('qidentification:applyForLicense')
AddEventHandler('qidentification:applyForLicense',function(data)
	local identificationData = nil
	-- Loop through identificationdata and match item and set a variable for future use
	for k,v in pairs(Kartu.IdentificationData) do 
		if v.item == data.item then 
			identificationData = v
			break
		end
	end
	TriggerServerEvent('qidentification:server:payForLicense',identificationData)
end)
