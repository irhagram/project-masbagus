-- Server event to call open identification card on valid players
RegisterServerEvent('qidentification:server:showID')
AddEventHandler('qidentification:server:showID', function(item, players)
	if #players > 0 then 
		for _,player in pairs(players) do 
			TriggerClientEvent('qidentification:openID',item)
		end 
	end 
end)

-- Creating the card using item metadata.
RegisterServerEvent('qidentification:createCard')
AddEventHandler('qidentification:createCard', function(source,url,type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local card_metadata = {}
	card_metadata.type = xPlayer.name
	card_metadata.citizenid = xPlayer[Kartu.CitizenID]:sub(-5)
	card_metadata.firstName = xPlayer.variables.firstName
	card_metadata.lastName = xPlayer.variables.lastName
	card_metadata.dateofbirth = xPlayer.variables.dateofbirth
	card_metadata.sex = xPlayer.variables.sex
	card_metadata.height = xPlayer.variables.height
	card_metadata.mugshoturl = url
	card_metadata.cardtype = type
	local curtime = os.time(os.date("!*t"))
	local diftime = curtime + 2629746
	card_metadata.issuedon = os.date('%m / %d / %Y',curtime)
	card_metadata.expireson = os.date('%m / %d / %Y', diftime)
	if type == "identification" then 
		local sex, identifier = xPlayer.variables.sex
		if sex == 'm' then sex = 'male' elseif sex == 'f' then sex = 'female' end
		card_metadata.description = ('Sex: %s | DOB: %s'):format( sex, xPlayer.variables.dateofbirth )
	elseif type == "drivers_license" then 
		MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = xPlayer.identifier},
		function (licenses)
			for i=1, #licenses, 1 do
				if licenses[i].type == 'drive' or licenses[i].type == 'drive_bike' or licenses[i].type == 'drive_truck' then
					card_metadata.licenses = licenses
				end
			end
		end)
		TriggerEvent('esx_license:addLicense', source, 'drive', function()
			--cb('bought_weapon_license')
		end)
	elseif type == "firearms_license" then 
		MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = xPlayer.identifier},
		function (licenses)
			for i=1, #licenses, 1 do
				if licenses[i].type == 'weapon' then
					card_metadata.licenses = licenses
				end
			end
		end)
			TriggerEvent('esx_license:addLicense', source, 'weapon', function()
				--cb('bought_weapon_license')
			end)
	end
	if xPlayer.getInventoryItem('identification').count >= 1 then
        TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Anda Sudah Memiliki KTP!' })
    else
	xPlayer.addInventoryItem(type, 1, card_metadata)
	end
end)

-- Server event to call open identification card on valid players
RegisterServerEvent('qidentification:server:payForLicense')
AddEventHandler('qidentification:server:payForLicense', function(identificationData,mugshotURL)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() < identificationData.cost then
		return xPlayer.showNotification("You can't afford this license.")
	end
	xPlayer.removeMoney(identificationData.cost)
	TriggerEvent('qidentification:createCard',source,mugshotURL,identificationData.item)
end)
