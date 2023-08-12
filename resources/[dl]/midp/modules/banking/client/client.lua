ESX = nil
local PlayerData = {}
local trans = {}
local societyTrans = {}
local societyIdent, societyDays
local didAction = false
local isBankOpened = false
local canAccessSociety = false
local society = ''
local societyInfo
local closestATM, atmPos

local playerName, playerBankMoney, playerIBAN, trsIdentifier, allDaysValues, walletMoney

AddEventHandler('esx:nui_ready', function()
  CreateFrame('banking', 'nui://' .. GetCurrentResourceName() .. '/modules/banking/data/html/ui.html')
end)

CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

CreateThread(function()
	if Banking.ShowBankBlips then
		Wait(2000)
		for k,v in ipairs(Banking.BankLocations)do
			local blip = AddBlipForCoord(v.x, v.y, v.z)
			SetBlipSprite (blip, v.blip)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, v.blipScale)
			SetBlipColour (blip, v.blipColor)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.blipText)
			EndTextCommandSetBlipName(blip)
		end
	end
end)

function openBank()
	local hasJob = false
	local playeJob = ESX.GetPlayerData().job
	local playerJobName = ''
	local playerJobGrade = ''
	local jobLabel = ''
	isBankOpened = true

	canAccessSociety = false

	if playeJob ~= nil then
		hasJob = true
		playerJobName = playeJob.name
		playerJobGrade = playeJob.grade_name
		jobLabel = playeJob.label
		society = 'society_'..playerJobName
	end

	ESX.TriggerServerCallback("okokBanking:GetPlayerInfo", function(data)
		ESX.TriggerServerCallback("okokBanking:GetOverviewTransactions", function(cb, identifier, allDays)
			for k,v in pairs(Banking.Societies) do
				if playerJobName == v then
					if json.encode(Banking.SocietyAccessRanks) ~= '[]' then
						for k2,v2 in pairs(Banking.SocietyAccessRanks) do
							if playerJobGrade == v2 then
								canAccessSociety = true
							end
						end
					else
						canAccessSociety = true
					end
				end
			end

			if canAccessSociety then
				ESX.TriggerServerCallback("okokBanking:SocietyInfo", function(cb)
					if cb ~= nil then
						societyInfo = cb
					else
						local societyIban = Banking.IBANPrefix..jobLabel
						TriggerServerEvent("okokBanking:CreateSocietyAccount", society, jobLabel, 0, societyIban)
						Wait(200)
						ESX.TriggerServerCallback("okokBanking:SocietyInfo", function(cb)
							societyInfo = cb
						end, society)
					end
				end, society)
			end

			isBankOpened = true
			trans = cb
			playerName, playerBankMoney, playerIBAN, trsIdentifier, allDaysValues, walletMoney = data.playerName, data.playerBankMoney, data.playerIBAN, identifier, allDays, data.walletMoney
			ESX.TriggerServerCallback("okokBanking:GetSocietyTransactions", function(societyTranscb, societyID, societyAllDays)
				societyIdent = societyID
				societyDays = societyAllDays
				societyTrans = societyTranscb
				if data.playerIBAN ~= nil then
					FocusFrame('banking', true, true) -- PENGGANTI SETNUIFOCUS
					SendFrameMessage('banking', {
						action = 'bankmenu',
						playerName = data.playerName,
						playerSex = data.sex,
						playerBankMoney = data.playerBankMoney,
						walletMoney = walletMoney,
						playerIBAN = data.playerIBAN,
						db = trans,
						identifier = trsIdentifier,
						graphDays = allDaysValues,
						isInSociety = canAccessSociety,
					})
				else
					GenerateIBAN()
					Wait(1000)
					ESX.TriggerServerCallback("okokBanking:GetPlayerInfo", function(data)
						FocusFrame('banking', true, true) -- PENGGANTI SETNUIFOCUS
						SendFrameMessage('banking', {
							action = 'bankmenu',
							playerName = data.playerName,
							playerSex = data.sex,
							playerBankMoney = data.playerBankMoney,
							walletMoney = walletMoney,
							playerIBAN = data.playerIBAN,
							db = trans,
							identifier = trsIdentifier,
							graphDays = allDaysValues,
							isInSociety = canAccessSociety,
						})
					end)
				end
			end, society)
		end)
	end)
end

RegisterNUICallback("action", function(data, cb)
	if data.action == "close" then
		isBankOpened = false
		SetNuiFocus(false, false)
	elseif data.action == "deposit" then
		if tonumber(data.value) ~= nil then
			if tonumber(data.value) > 0 then
				if data.window == 'bankmenu' then
					TriggerServerEvent('okokBanking:DepositMoney', tonumber(data.value))
				elseif data.window == 'societies' then
					TriggerServerEvent('okokBanking:DepositMoneyToSociety', tonumber(data.value), societyInfo.society, societyInfo.society_name)
				end
			else
				exports['midp-tasknotify']:DoHudText('error', 'Invalid amount')
			end	
		else
			exports['midp-tasknotify']:DoHudText('error', 'Invalid input')
		end
	elseif data.action == "withdraw" then
		if tonumber(data.value) ~= nil then
			if tonumber(data.value) > 0 then
				if data.window == 'bankmenu' then
					TriggerServerEvent('okokBanking:WithdrawMoney', tonumber(data.value))
				elseif data.window == 'societies' then
					TriggerServerEvent('okokBanking:WithdrawMoneyToSociety', tonumber(data.value), societyInfo.society, societyInfo.society_name, societyInfo.value)
				end
			else
				exports['midp-tasknotify']:DoHudText('error', 'Invalid amount')
			end
		else
			--exports['midp-tasknotify']:DoHudText('error', 'Invalid input')
			exports['midp-tasknotify']:DoHudText('error', 'Invalid input')
		end
	elseif data.action == "transfer" then
		if tonumber(data.value) ~= nil then
			if tonumber(data.value) > 0 then
				ESX.TriggerServerCallback("okokBanking:IsIBanUsed", function(isUsed, isPlayer)
					if isUsed ~= nil then
						if data.window == 'bankmenu' then
							if isPlayer then
								TriggerServerEvent('okokBanking:TransferMoney', tonumber(data.value), data.iban:upper(), isUsed.identifier, isUsed.accounts, isUsed.name)
							elseif not isPlayer then
								TriggerServerEvent('okokBanking:TransferMoneyToSociety', tonumber(data.value), isUsed.iban:upper(), isUsed.society_name, isUsed.society)
							end
						elseif data.window == 'societies' then
							local toMyself = false
							if data.iban:upper() == playerIBAN then
								toMyself = true
							end

							if isPlayer then
								TriggerServerEvent('okokBanking:TransferMoneyToPlayerFromSociety', tonumber(data.value), data.iban:upper(), isUsed.identifier, isUsed.accounts, isUsed.name, societyInfo.society, societyInfo.society_name, societyInfo.value, toMyself)
							elseif not isPlayer then
								TriggerServerEvent('okokBanking:TransferMoneyToSocietyFromSociety', tonumber(data.value), isUsed.iban:upper(), isUsed.society_name, isUsed.society, societyInfo.society, societyInfo.society_name, societyInfo.value)
							end
						end
					elseif isUsed == nil then
						exports['midp-tasknotify']:Alert("BANK", "This IBAN does not exist", 5000, 'error')
						exports['midp-tasknotify']:DoHudText('error', 'This IBAN does not exist')
					end
				end, data.iban:upper())
			else
				exports['midp-tasknotify']:DoHudText('error', 'Invalid amount')
			end
		else
			exports['midp-tasknotify']:DoHudText('error', 'Invalid input')
		end
	elseif data.action == "overview_page" then
		FocusFrame('banking', true, true) -- PENGGANTI SETNUIFOCUS
		SendFrameMessage('banking', {
			action = 'overview_page',
			playerBankMoney = playerBankMoney,
			walletMoney = walletMoney,
			playerIBAN = playerIBAN,
			db = trans,
			identifier = trsIdentifier,
			graphDays = allDaysValues,
			isInSociety = canAccessSociety,
		})
	elseif data.action == "transactions_page" then
		FocusFrame('banking', true, true) -- PENGGANTI SETNUIFOCUS
		SendFrameMessage('banking', {
			action = 'transactions_page',
			db = trans,
			identifier = trsIdentifier,
			graph_values = allDaysValues,
			isInSociety = canAccessSociety,
		})
	elseif data.action == "society_transactions" then
		FocusFrame('banking', true, true) -- PENGGANTI SETNUIFOCUS
		SendFrameMessage('banking', {
			action = 'society_transactions',
			db = societyTrans,
			identifier = societyIdent,
			graph_values = societyDays,
			isInSociety = canAccessSociety,
			societyInfo = societyInfo,
		})
	elseif data.action == "society_page" then
		FocusFrame('banking', true, true) -- PENGGANTI SETNUIFOCUS
		SendFrameMessage('banking', {
			action = 'society_page',
			playerBankMoney = playerBankMoney,
			walletMoney = walletMoney,
			playerIBAN = playerIBAN,
			db = societyTrans,
			identifier = societyIdent,
			graphDays = societyDays,
			isInSociety = canAccessSociety,
			societyInfo = societyInfo,
		})
	elseif data.action == "settings_page" then
		FocusFrame('banking', true, true) -- PENGGANTI SETNUIFOCUS
		SendFrameMessage('banking', {
			action = 'settings_page',
			isInSociety = canAccessSociety,
			ibanCost = Banking.IBANChangeCost,
			ibanPrefix = Banking.IBANPrefix,
			ibanCharNum = Banking.CustomIBANMaxChars,
			pinCost = Banking.PINChangeCost,
			pinCharNum = 4,
		})
	elseif data.action == "atm" then
		FocusFrame('banking', true, true) -- PENGGANTI SETNUIFOCUS
		SendFrameMessage('banking', {
			action = 'loading_data',
		})
		Wait(500)
		openBank()
	elseif data.action == "change_iban" then
		if Banking.CustomIBANAllowLetters then
			local iban = Banking.IBANPrefix..data.iban:upper()
			
			ESX.TriggerServerCallback("okokBanking:IsIBanUsed", function(isUsed, isPlayer)

				if isUsed == nil then
					TriggerServerEvent('okokBanking:UpdateIbanDB', iban, Banking.IBANChangeCost)
				elseif isUsed ~= nil then
					--exports['midp-tasknotify']:Alert("BANK", "This IBAN is already in use", 5000, 'error')
					exports['midp-tasknotify']:DoHudText('error', 'This IBAN is already in use')
				end
			end, iban)
		elseif not Banking.CustomIBANAllowLetters then
			if tonumber(data.iban) ~= nil then
				local iban = Banking.IBANPrefix..data.iban:upper()
				
				ESX.TriggerServerCallback("okokBanking:IsIBanUsed", function(isUsed, isPlayer)

					if isUsed == nil then
						TriggerServerEvent('okokBanking:UpdateIbanDB', iban, Banking.IBANChangeCost)
					elseif isUsed ~= nil then
						--exports['midp-tasknotify']:Alert("BANK", "This IBAN is already in use", 5000, 'error')
						exports['midp-tasknotify']:DoHudText('error', 'This IBAN is already in use')
					end
				end, iban)
			else
				--exports['midp-tasknotify']:Alert("BANK", "You can only use numbers on your IBAN", 5000, 'error')
				exports['midp-tasknotify']:DoHudText('error', 'You can only use numbers on your IBAN')
			end
		end
	elseif data.action == "change_pin" then
		if tonumber(data.pin) ~= nil then
			if string.len(data.pin) == 4 then
				TriggerServerEvent('okokBanking:UpdatePINDB', data.pin, Banking.PINChangeCost)
			else
				--exports['midp-tasknotify']:Alert("BANK", "Your PIN needs to be 4 digits long", 5000, 'info')
				exports['midp-tasknotify']:DoHudText('error', 'Your PIN needs to be 4 digits long')
			end
		else
			exports['midp-tasknotify']:Alert("BANK", "You can only use numbers", 5000, 'info')
			exports['midp-tasknotify']:DoHudText('error', 'You can only use numbers')
		end
	end
end)

RegisterNetEvent("okokBanking:updateTransactions")
AddEventHandler("okokBanking:updateTransactions", function(money, wallet)
	Wait(100)
	if isBankOpened then
		ESX.TriggerServerCallback("okokBanking:GetOverviewTransactions", function(cb, id, allDays)
			trans = cb
			allDaysValues = allDays
			FocusFrame('banking', true, true) -- PENGGANTI SETNUIFOCUS
			SendFrameMessage('banking', {
				action = 'overview_page',
				playerBankMoney = playerBankMoney,
				walletMoney = walletMoney,
				playerIBAN = playerIBAN,
				db = trans,
				identifier = trsIdentifier,
				graphDays = allDaysValues,
				isInSociety = canAccessSociety,
			})
			TriggerEvent('okokBanking:updateMoney', money, wallet)
		end)
	end
end)

RegisterNetEvent("okokBanking:updateMoney")
AddEventHandler("okokBanking:updateMoney", function(money, wallet)
	if isBankOpened then
		playerBankMoney = money
		walletMoney = wallet
		SendFrameMessage('banking', {
			action = 'updatevalue',
			playerBankMoney = money,
			walletMoney = wallet,
		})
	end
end)

RegisterNetEvent("okokBanking:updateIban")
AddEventHandler("okokBanking:updateIban", function(iban)
	playerIBAN = iban
	SendFrameMessage('banking', {
		action = 'updateiban',
		iban = playerIBAN,
	})
end)

RegisterNetEvent("okokBanking:updateIbanPinChange")
AddEventHandler("okokBanking:updateIbanPinChange", function()
	Wait(100)
	ESX.TriggerServerCallback("okokBanking:GetOverviewTransactions", function(cbs, ids, allDays)
		trans = cbs
	end)
end)

RegisterNetEvent("okokBanking:updateTransactionsSociety")
AddEventHandler("okokBanking:updateTransactionsSociety", function(wallet)
	Wait(100)
	ESX.TriggerServerCallback("okokBanking:SocietyInfo", function(cb)
		ESX.TriggerServerCallback("okokBanking:GetSocietyTransactions", function(societyTranscb, societyID, societyAllDays)
			ESX.TriggerServerCallback("okokBanking:GetOverviewTransactions", function(cbs, ids, allDays)
				trans = cbs
				walletMoney = wallet
				societyDays = societyAllDays
				societyIdent = societyID
				societyTrans = societyTranscb
				societyInfo = cb
				if cb ~= nil then
					FocusFrame('banking', true, true) -- PENGGANTI SETNUIFOCUS
					SendFrameMessage('banking', {
						action = 'society_page',
						walletMoney = wallet,
						db = societyTrans,
						graphDays = societyDays,
						isInSociety = canAccessSociety,
						societyInfo = societyInfo,
					})
				else

				end
			end)
		end, society)
	end, society)
end)

function GenerateIBAN()
	math.randomseed(GetGameTimer())
	local stringFormat = "%0"..Banking.IBANNumbers.."d"
	local number = math.random(0, 10^Banking.IBANNumbers-1)
	number = string.format(stringFormat, number)
	local iban = Banking.IBANPrefix..number:upper()
	local isIBanUsed = true
	local hasChecked = false

	while true do
		Wait(10)
		if isIBanUsed and not hasChecked then
			isIBanUsed = false
			ESX.TriggerServerCallback("okokBanking:IsIBanUsed", function(isUsed)
				if isUsed ~= nil then
					isIBanUsed = true
					number = math.random(0, 10^Banking.IBANNumbers-1)
					number = string.format("%03d", number)
					iban = Banking.IBANPrefix..number:upper()
				elseif isUsed == nil then
					hasChecked = true
					isIBanUsed = false
				end
				canLoop = true
			end, iban)
		elseif not isIBanUsed and hasChecked then
			break
		end
	end
	TriggerServerEvent('okokBanking:SetIBAN', iban)
end

RegisterNetEvent('dl-bank:atm')
AddEventHandler('dl-bank:atm', function ()
	ESX.TriggerServerCallback("okokBanking:GetPIN", function(pin)
		if pin then
			if not isBankOpened then
				isBankOpened = true
				FocusFrame('banking', true, true) -- PENGGANTI SETNUIFOCUS
				SendFrameMessage('banking', {
					action = 'atm',
					pin = pin,
				})
			end
		else
			--exports['midp-tasknotify']:Alert("BANK", "Head up to a bank to set a PIN code", 5000, 'info')
			exports['midp-tasknotify']:DoHudText('error', 'Head up to a bank to set a PIN code')
		end
	end)
end)

RegisterNetEvent('dl-bank:banking')
AddEventHandler('dl-bank:banking', function()
	FocusFrame('banking', true, true) -- PENGGANTI SETNUIFOCU
	SendFrameMessage('banking', {
		action = 'loading_data',
	})
	openBank()
end)

CreateThread(function()
    local atm = {
		-870868698,
		-1126237515,
		-1364697528,
		506770882,
		2930269768,
		3168729781,
		3424098598,
    }
    exports["ox_target"]:AddTargetModel(atm, {
    	options = {
    		{
				event = "dl-bank:atm",
				icon = "fas fa-money-bills",
				label = "Atm",
			},
			},
			distance = 2.5
		})
end)

local lokasiBank = {
	{x = 149.1, 	y = -1041.21, z = 29.37, h = 340, Minz = 28.37, Maxz = 32.37},
	{x = -1212.82, 	y = -331.63, z = 37.79, h = 27, Minz = 36.79, Maxz = 40.79},
	{x = -2961.89, 	y = 482.1, z = 15.7, h = 87, Minz = 14.75, Maxz = 18.75},
	{x = -112.52, y = 6470.52, z = 31.63, h = 45, Minz = 30.63, Maxz = 34.63},
	{x = 313.42, y = -279.54, z = 54.17, h = 340, Minz = 53.17, Maxz = 57.17},
	{x = -351.73, y = -50.46, z = 49.04, h = 340, Minz = 48.04, Maxz = 52.04},
	{x = 1175.71, y = 2707.55, z = 38.09, h = 0, Minz = 37.09, Maxz = 41.09},
}

local nameid = 0

CreateThread(function()
	for k,v in pairs(lokasiBank) do
		nameid = nameid + 1
		exports["ox_target"]:AddBoxZone("lokasiBank" .. nameid, vector3(v.x, v.y, v.z), 1.0, 6.0, {
			name = "lokasiBank" .. nameid,
			heading = v.h,
			debugPoly = false,
			minZ = v.Minz,
			maxZ = v.Maxz
		}, {
			options = {
			{
				event = "dl-bank:banking",
				icon = "fas fa-piggy-bank",
				label = "Bank",
			},
			},
			distance = 2.5
		})
	end
end)


RegisterNetEvent('midp-tasknotify:Alert')
AddEventHandler('midp-tasknotify:Alert', function(text, type)
	exports['midp-tasknotify']:DoHudText(type, text)
end)