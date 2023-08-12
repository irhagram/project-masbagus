local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["-"] = 84,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Citizen.CreateThread(function()
	while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)
--[[
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if Config.OnlyPolice then
			if IsControlPressed(0, Config.Key) then
				if Config.OnlyInVehicle then
					if IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) then
						ESX.TriggerServerCallback('ns_policecad:getPlayerJob', function(cb)
							if cb then
								OpenMenu()
							else
								ESX.ShowNotification("You're not a police officer. You cant use that!")
							end
						end)
					end
				else
					ESX.TriggerServerCallback('ns_policecad:getPlayerJob', function(cb)
						if cb then
							OpenMenu()
						else
							ESX.ShowNotification("You're not a police officer. You cant use that!")
						end
					end)
				end
			end
		else
			if IsControlPressed(0, Config.Key) then
				if Config.OnlyInVehicle then
					if IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) then
						OpenMenu()
					end
				else
					OpenMenu()
				end
			end
		end
	end
end)]]

function OpenMenu()
		SendNUIMessage({
			type = 'openSystem'
		})
		SetNuiFocus(true, true)
		TriggerServerEvent('ns_policecad:getData')
		TriggerServerEvent('ns_policecad:additional')
		TriggerServerEvent('ns_policecad:getBolos')
end

RegisterNetEvent('ns_policecad:bolos')
AddEventHandler('ns_policecad:bolos', function()
    TriggerServerEvent('ns_policecad:getBolos')
end)

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

RegisterNetEvent('ns_policecad:setData')
AddEventHandler('ns_policecad:setData', function(firstname, lastname, sex, grade, boss)
    local playerBoss = false
    if boss == 'boss' then
        playerBoss = true
    end
    SendNUIMessage({
        type = 'setData',
        firstname = firstname .. ' ' .. lastname,
        sex = sex,
        grade = ESX.PlayerData.job.grade_label,
        isBoss = false
    })
end)

RegisterNetEvent('ns_policecad:setAdditional')
AddEventHandler('ns_policecad:setAdditional', function(count1, count2)
    ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(societyBalanceAmount)
        SendNUIMessage({
            type = 'setAdditional',
            citizens = count1,
            vehicles = '$DL' ..ESX.Math.GroupDigits(societyBalanceAmount),
            officers = '$DL0'
        })
    end, 'ambulance')
end)

RegisterNetEvent('ns_policecad:setBolos')
AddEventHandler('ns_policecad:setBolos', function(bolos)
    SendNUIMessage({
        type = 'bolos',
        bolos = bolos
    })
end)

RegisterNetEvent('dl-job:tabEMS')
AddEventHandler('dl-job:tabEMS', function()
    OpenMenu()
end)