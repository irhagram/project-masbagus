RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)
  
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local Melee = { -1569615261, 1737195953, 1317494643, -1786099057, 1141786504, -2067956739, -868994466, -1951375401, -656458692, 419712736  }
local Knife = { -1716189206, 1223143800, -1955384325, -1833087301, 910830060, -102323637, -1810795771, -853065399, -538741184, -581044007, -102973651 }
local Bullet = { 453432689, 1593441988, 584646201, -1716589765, 324215364, 736523883, -270015777, -1074790547, -2084633992, -1357824103, -1660422300, 2144741730, 487013001, 2017895192, -494615257, -1654528753, 100416529, 205991906, 1119849093 }
local Animal = { -100946242, 148160082 }
local FallDamage = { -842959696 }
local Explosion = { -1568386805, 1305664598, -1312131151, 375527679, 324506233, 1752584910, -1813897027, 741814745, -37975472, 539292904, 341774354, -1090665087 }
local Gas = { -1600701090 }
local Burn = { 615608432, 883325847, -544306709, 1233104067, 1198879012 }
local Drown = { -10959621, 1936677264 }
local Car = { 133987706, -1553120962 }

local area = "Tidak Diketahui"

function checkArray (array, val)
	  for name, value in ipairs(array) do
		  if value == val then
			  return true
		  end
	  end


	  return false
end  

RegisterNetEvent('dl-job:cDeath')
AddEventHandler('dl-job:cDeath', function()
	if not IsPedInAnyVehicle(PlayerPedId()) then
		local player, distance = ESX.Game.GetClosestPlayer()
		if distance ~= -1 and distance < 5.0 then
			if distance ~= -1 and distance <= 2.0 then	
				if IsPedDeadOrDying(GetPlayerPed(player)) then
					if (PlayerData.job ~= nil and PlayerData.job.name == 'ambulance') then
						TriggerEvent('dl-job:deaths', GetPlayerPed(player))
					end
				end
			end
		end
	end
end)

RegisterNetEvent('dl-job:deaths')
AddEventHandler('dl-job:deaths', function(player)
	loadAnimDict('amb@medic@standing@kneel@base')
	loadAnimDict('anim@gangops@facility@servers@bodysearch@')

	local d = GetPedCauseOfDeath(player)	
	local playerPed = PlayerPedId()
	local hit, bone = GetPedLastDamageBone(player)

	if (bone == 31086) then
		area = "Kepala"
	elseif bone == 24817 or bone == 24818 or bone == 10706 or bone == 24816 or bone == 11816 or bone == 57597 or bone == 51826 or bone == 64729 then
		area = "Badan"
	end


	TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
	TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )


	Citizen.Wait(5000)
	ClearPedTasksImmediately(playerPed)

	if checkArray(Melee, d) then
		Notify("Terkena pukulan di bagian : " .. area)
	elseif checkArray(Bullet, d) then
		Notify("Terkena peluru di bagian : " .. area)
	elseif checkArray(Knife, d) then
		Notify("Tertusuk di bagian : " .. area)
	elseif checkArray(Animal, d) then
		Notify("Tergigit binatang di bagian : " .. area)
	elseif checkArray(FallDamage, d) then
		Notify('Kemungkinan Terjatuh Dari Ketinggian')
	elseif checkArray(Explosion, d) then
		Notify("Terkena ledakan di bagian : " .. area)
	elseif checkArray(Gas, d) then
		Notify(_U('gas'))
	elseif checkArray(Burn, d) then
		Notify("Terkena luka bakar di bagian : " .. area)
	elseif checkArray(Drown, d) then
		Notify(_U('drown'))
	elseif checkArray(Car, d) then
		Notify("Kecelakaan lalu lintas di bagian : " .. area)
	else
		Notify('Penyebab tidak diketahui')
	end
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end

function Notify(message)
	exports['alan-tasknotify']:SendAlert('success', message)
end