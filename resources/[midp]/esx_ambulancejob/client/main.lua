local firstSpawn = true
local TaskPlayAnim = TaskPlayAnim

isDead, isSearched, medic = false, false, 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
  ESX.PlayerLoaded = false
  firstSpawn = true
end)

AddEventHandler('esx:onPlayerSpawn', function()
  isDead = false
  ClearTimecycleModifier()
  SetPedMotionBlur(PlayerPedId(), false)
  ClearExtraTimecycleModifier()
  EndDeathCam()
  if firstSpawn then
    firstSpawn = false

    if Config.SaveDeathStatus then
      while not ESX.PlayerLoaded do
        Wait(1000)
      end

      ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(shouldDie)
        if shouldDie then
          Wait(1000)
          SetEntityHealth(PlayerPedId(), 0)
        end
      end)
    end
  end
end)

-- Create blips
CreateThread(function()
  for k, v in pairs(Config.Hospitals) do
    --[[local blip = AddBlipForCoord(v.Blip.coords)

    SetBlipSprite(blip, v.Blip.sprite)
    SetBlipScale(blip, v.Blip.scale)
    SetBlipColour(blip, v.Blip.color)
    SetBlipAsShortRange(blip, true)]]

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(_U('blip_hospital'))
    EndTextCommandSetBlipName(blip)
  end

  while true do
    local Sleep = 1500

    if isDead then
      Sleep = 0
      DisableAllControlActions(0)
      EnableControlAction(0, 47, true) -- G 
      EnableControlAction(0, 245, true) -- T
      EnableControlAction(0, 38, true) -- E

      ProcessCamControls()
      if isSearched then
        local playerPed = PlayerPedId()
        local ped = GetPlayerPed(GetPlayerFromServerId(medic))
        isSearched = false

        AttachEntityToEntity(playerPed, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        Wait(1000)
        DetachEntity(playerPed, true, false)
        ClearPedTasksImmediately(playerPed)
      end
    end

    Wait(Sleep)
  end
end)

RegisterNetEvent('esx_ambulancejob:clsearch')
AddEventHandler('esx_ambulancejob:clsearch', function(medicId)
  local playerPed = PlayerPedId()

  if isDead then
    local coords = GetEntityCoords(playerPed)
    local playersInArea = ESX.Game.GetPlayersInArea(coords, 50.0)

    for i = 1, #playersInArea, 1 do
      local player = playersInArea[i]
      if player == GetPlayerFromServerId(medicId) then
        medic = tonumber(medicId)
        isSearched = true
        break
      end
    end
  end
end)

CreateThread(function()
    while true do
        Wait(10000)
        if isDead then
          TriggerServerEvent('dl-job:getAmbulancesCount')
        else
          Wait(1000)
        end
    end
end)

RegisterNetEvent("dl-job:autorevive")
AddEventHandler("dl-job:autorevive", function()
    TriggerEvent('esx_ambulancejob:revive')
end)

RegisterNetEvent("dl-job:autoreviveems")
AddEventHandler("dl-job:autoreviveems", function()
    TriggerEvent('esx_ambulancejob:revive')
end)

CreateThread(function()
	while true do
 		Wait(10)
 		SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
 	end
end)

CreateThread(function()
    while true do
      if GetPedStealthMovement(PlayerPedId()) then
          SetPedStealthMovement(PlayerPedId(), 0)
      end
      Wait(1)
  end
end)

function loadAnimDict(dict)
  RequestAnimDict(dict)
  while (not HasAnimDictLoaded(dict)) do   
      RequestAnimDict(dict)     
      Wait(1)
  end
end

function GetDeath()
	return isDead
end

function OnPlayerDeath()
  isDead = true
  ESX.UI.Menu.CloseAll()
  local ped = PlayerPedId()
  local coords = GetEntityCoords(ped)
	local formattedCoords = {
        x = ESX.Math.Round(coords.x, 1),
        y = ESX.Math.Round(coords.y, 1),
        z = ESX.Math.Round(coords.z, 1)
    }
	ESX.SetPlayerData('lastPosition', formattedCoords)
  ClearTimecycleModifier()
  SetTimecycleModifier("REDMIST_blend")
  SetTimecycleModifierStrength(0.7)
  SetExtraTimecycleModifier("fp_vig_red")
  SetExtraTimecycleModifierStrength(1.0)
  SetPedMotionBlur(PlayerPedId(), true)
  TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)
  StartDeathTimer()
  StartDeathCam()
  StartDistressSignal()
	ClearPedTasksImmediately(PlayerPedId())
  exports['pma-voice']:removePlayerFromRadio()
  exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
end

RegisterNetEvent('esx_ambulancejob:useItem')
AddEventHandler('esx_ambulancejob:useItem', function(itemName)
  ESX.UI.Menu.CloseAll()

  if itemName == 'medikit' then
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
    local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
    local playerPed = PlayerPedId()

    ESX.Streaming.RequestAnimDict(lib, function()
      TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
      RemoveAnimDict(lib)

      Wait(500)
      while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
        Wait(0)
        DisableAllControlActions(0)
      end

      TriggerEvent('esx_ambulancejob:heal', 'big', true)
      ESX.ShowNotification(_U('used_medikit'))
    end)

  elseif itemName == 'bandage' then
    local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
    local playerPed = PlayerPedId()

    ESX.Streaming.RequestAnimDict(lib, function()
      TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
      RemoveAnimDict(lib)

      Wait(500)
      while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
        Wait(0)
        DisableAllControlActions(0)
      end

      TriggerEvent('esx_ambulancejob:heal', 'small', true)
      ESX.ShowNotification(_U('used_bandage'))
    end)
  end
  else
    ESX.ShowNotification('Tidak ada akses')
  end
end)

--[[ function TeriakRUwetAsu()
	CreateThread(function()
		local timer = Config.BleedoutTimer

		while timer > 0 and isDead do
			Wait(0)
			timer = timer - 30
          if IsControlPressed(0, 74) or IsDisabledControlPressed(0, 74) then
              if not IsPedInAnyVehicle(PlayerPedId(), false) then
                ClearPedTasksImmediately(PlayerPedId())
                SetPedToRagdoll(PlayerPedId(), 26000, 26000, 3, 0, 0, 0) 
            end
        end
		end
	end)
end
 ]]
function StartDistressSignal()
    CreateThread(function()
        local timer = Config.BleedoutTimer

          while timer > 0 and isDead do
            Wait(0)
            timer = timer - 30
            drawTxt(0.91, 1.36, 1.0,1.0,0.6, "Tekan [~r~G~w~] untuk mengirim signal", 255, 255, 255, 255)
            if IsControlJustReleased(0, 47) then
              SendDistressSignal()
              break
            end
        end
    end)
end

function SendDistressSignal()
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local job = ESX.PlayerData.job.name 
	local time = GetClockHours() .. ':' .. GetClockMinutes()
  local data = {displayCode = '119', description = 'Lokasi Korban', priority = 'high', isImportant = 1, recipientList = {'ambulance'}, length = '15000', infoM = 'fa-info-circle', info = 'Check Map Untuk Lokasinya'}
  local dispatchData = {dispatchData = data, caller = 'Alarm', coords = playerCoords}

	TriggerServerEvent('midp-phone:addsms', playerCoords, 'Lokasi korban!', 'ambulance', time)
  TriggerServerEvent('wf-alerts:svNotify', dispatchData)
end

function DrawGenericTextThisFrame()
    SetTextFont(4)
    SetTextScale(0.0, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end 

function secondsToClock(seconds)
  local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

  if seconds <= 0 then
    return 0, 0
  else
    local hours = string.format('%02.f', math.floor(seconds / 3600))
    local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
    local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

    return mins, secs
  end
end

function StartDeathTimer()
  local canPayFine = false

  if Config.EarlyRespawnFine then
    ESX.TriggerServerCallback('esx_ambulancejob:checkBalance', function(canPay)
      canPayFine = canPay
    end)
  end

  local earlySpawnTimer = ESX.Math.Round(Config.EarlyRespawnTimer / 1000)
  local bleedoutTimer = ESX.Math.Round(Config.BleedoutTimer / 1000)

  CreateThread(function()
    -- early respawn timer
    while earlySpawnTimer > 0 and isDead do
      Wait(1000)

      if earlySpawnTimer > 0 then
        earlySpawnTimer = earlySpawnTimer - 1
      end
    end

    -- bleedout timer
    while bleedoutTimer > 0 and isDead do
      Wait(1000)

      if bleedoutTimer > 0 then
        bleedoutTimer = bleedoutTimer - 1
      end
    end
  end)

  CreateThread(function()
    local text, timeHeld

    -- early respawn timer
    while earlySpawnTimer > 0 and isDead do
      Wait(0)
      local menit, detik = secondsToClock(earlySpawnTimer)
      drawTxt(0.90, 1.39, 1.0,1.0,0.6, "TEKAN [~r~H~w~] JIKA TIDAK TERLIHAT PETUGAS", 255, 255, 255, 255)
			drawTxt(0.89, 1.42, 1.0,1.0,0.6, "RESPAWN TERSEDIA: ~r~" .. menit .. "~w~ MENIT ~r~" .. detik .. "~w~ DETIK LAGI", 255, 255, 255, 255)
      if IsControlPressed(0, 74) or IsDisabledControlPressed(0, 74) then
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            ClearPedTasksImmediately(PlayerPedId())
            SetPedToRagdoll(PlayerPedId(), 26000, 26000, 3, 0, 0, 0) 
        end
    end
    end

    -- bleedout timer
    while bleedoutTimer > 0 and isDead do
      Wait(0)
      local menit, detik = secondsToClock(bleedoutTimer)
			drawTxt(0.91, 1.39, 1.0,1.0,0.6, "AUTO RESPAWN: ~r~" .. menit .. "~w~ MENIT ~r~" .. detik .. "~w~ DETIK LAGI", 255, 255, 255, 255)

      if not Config.EarlyRespawnFine then
        drawTxt(0.89, 1.42, 1.0,1.0,0.6, "~w~TAHAN ~r~E ~w~UNTUK ~r~RESPAWN ~w~ATAU TUNGGU ~r~EMS", 255, 255, 255, 255)

        if IsControlPressed(0, 38) and timeHeld > 120 then
          RemoveItemsAfterRPDeath()
          break
        end
      elseif Config.EarlyRespawnFine and canPayFine then
        text = text .. _U('respawn_bleedout_fine', ESX.Math.GroupDigits(Config.EarlyRespawnFineAmount))

        if IsControlPressed(0, 38) and timeHeld > 120 then
          TriggerServerEvent('esx_ambulancejob:payFine')
          RemoveItemsAfterRPDeath()
          break
        end
      end

      if IsControlPressed(0, 38) then
        timeHeld += 1
      else
        timeHeld = 0
      end

      DrawGenericTextThisFrame()

      BeginTextCommandDisplayText('STRING')
      AddTextComponentSubstringPlayerName(text)
      EndTextCommandDisplayText(0.5, 0.8)
    end

    if bleedoutTimer < 1 and isDead then
      RemoveItemsAfterRPDeath()
    end
  end)
end

function GetClosestRespawnPoint()
  local PlyCoords = GetEntityCoords(PlayerPedId())
  local ClosestDist, ClosestHospital, ClosestCoord = 10000, {}, nil

  for k, v in pairs(Config.RespawnPoints) do
    local Distance = #(PlyCoords - vector3(v.coords.x, v.coords.y, v.coords.z))
    if Distance <= ClosestDist then
      ClosestDist = Distance
      ClosestHospital = v
      ClosestCoord = vector3(v.coords.x, v.coords.y, v.coords.z)
    end
  end

  return ClosestCoord, ClosestHospital
end

function RemoveItemsAfterRPDeath()
  TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

  CreateThread(function()
    ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()
      local RespawnCoords, ClosestHospital = GetClosestRespawnPoint()

      ESX.SetPlayerData('loadout', {})

      DoScreenFadeOut(800)
      RespawnPed(PlayerPedId(), RespawnCoords, ClosestHospital.heading)
      while not IsScreenFadedOut() do
        Wait(0)
      end
      DoScreenFadeIn(800)
    end)
  end)
end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
end

function OpenPlasticSurgery()
	HasPaid = false
	
	TriggerEvent('esx_skin:openSaveableMenu', function(data, menu)
		menu.close()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = _U('valid_purchase'),
			align = 'center-right',
			elements = {
				{label = 'Tidak',  value = 'no'},
				{label = 'Iya', value = 'yes'}
			}
		}, function(data, menu)
			menu.close()
			
			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('esx_plasticsurgery:checkMoney', function(hasEnoughMoney)
					if hasEnoughMoney then
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
						end)
						
						TriggerServerEvent('esx_plasticsurgery:pay')
						HasPaid = true
					else
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin) 
						end)
						
						ESX.ShowNotification(_U('not_enough_money'))
					end
				end)
			elseif data.current.value == 'no' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin) 
				end)
			end
			
			--CurrentAction     = 'surgery_menu'
			--CurrentActionMsg  = _U('press_access')
			--CurrentActionData = {}
		end, function(data, menu)
			menu.close()
			
			--CurrentAction     = 'surgery_menu'
			--CurrentActionMsg  = _U('press_access')
			--CurrentActionData = {}
		end)
	end, function(data, menu)
		menu.close()
		
		--CurrentAction     = 'surgery_menu'
		--CurrentActionMsg  = _U('press_access')
		--CurrentActionData = {}
	end)
end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
  local specialContact = {name = 'Ambulance', number = 'ambulance',
                          base64Icon = 'data:image/png;base64,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'}

  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

AddEventHandler('esx:onPlayerDeath', function(data)
  OnPlayerDeath()
end)

RegisterNetEvent("dl-ems:oplasmenu")
AddEventHandler("dl-ems:oplasmenu", function()
	if (exports['midp-core']:itemCount('tiketoplas') > 0) then
		  TriggerServerEvent('dl-ems:hapustiket', tiket)
		  OpenPlasticSurgery()
	  else
	    exports['midp-tasknotify']:SendAlert('error', 'Tidak Memiliki Ticket')
	  end
end)

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
      Wait(50)
    end

    local formattedCoords = {x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1)}

    RespawnPed(playerPed, formattedCoords, 0.0)
    isDead = false
    ClearTimecycleModifier()
    SetPedMotionBlur(playerPed, false)
    ClearExtraTimecycleModifier()
    EndDeathCam()
    DoScreenFadeIn(800)
    TriggerEvent('esx_basicneeds:resetStatus')
    Wait(2000)
    loadAnimDict("random@crash_rescue@help_victim_up") 
    TaskPlayAnim( PlayerPedId(), "random@crash_rescue@help_victim_up", "helping_victim_to_feet_victim", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Wait(3000)
    ClearPedSecondaryTask(PlayerPedId())
    ClearPedTasksImmediately(PlayerPedId())
end)

-- Load unloaded IPLs
if Config.LoadIpl then
  RequestIpl('Coroner_Int_on') -- Morgue
end

local cam = nil

local isDead = false

local angleY = 0.0

local angleZ = 0.0

-------------------------------------------------------

-----------------DEATH CAMERA FUNCTIONS ---------------

--------------------------------------------------------

-- initialize camera

function StartDeathCam()
  ClearFocus()
  local playerPed = PlayerPedId()
  cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(playerPed), 0, 0, 0, GetGameplayCamFov())
  SetCamActive(cam, true)
  RenderScriptCams(true, true, 1000, true, false)
end

-- destroy camera

function EndDeathCam()
  ClearFocus()
  RenderScriptCams(false, false, 0, true, false)
  DestroyCam(cam, false)
  cam = nil
end
-- process camera controls
function ProcessCamControls()
  local playerPed = PlayerPedId()
  local playerCoords = GetEntityCoords(playerPed)
  -- disable 1st person as the 1st person camera can cause some glitches
  DisableFirstPersonCamThisFrame()
  -- calculate new position
  local newPos = ProcessNewPosition()
  SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)
  -- set coords of cam
  SetCamCoord(cam, newPos.x, newPos.y, newPos.z)
  -- set rotation
  PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.5)
end

function ProcessNewPosition()
  local mouseX = 0.0
  local mouseY = 0.0
  -- keyboard
  if (IsInputDisabled(0)) then
    -- rotation
    mouseX = GetDisabledControlNormal(1, 1) * 8.0

    mouseY = GetDisabledControlNormal(1, 2) * 8.0
    -- controller
  else
    mouseX = GetDisabledControlNormal(1, 1) * 1.5

    mouseY = GetDisabledControlNormal(1, 2) * 1.5
  end

  angleZ = angleZ - mouseX -- around Z axis (left / right)

  angleY = angleY + mouseY -- up / down
  -- limit up / down angle to 90°

  if (angleY > 89.0) then
    angleY = 89.0
  elseif (angleY < -89.0) then
    angleY = -89.0
  end
  local pCoords = GetEntityCoords(PlayerPedId())
  local behindCam = {x = pCoords.x + ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * (5.5 + 0.5),

                     y = pCoords.y + ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * (5.5 + 0.5),

                     z = pCoords.z + ((Sin(angleY))) * (5.5 + 0.5)}
  local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, PlayerPedId(), 0)

  local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

  local maxRadius = 1.9
  if (hitBool and Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords) < 5.5 + 0.5) then
    maxRadius = Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords)
  end

  local offset = {x = ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * maxRadius,
                  y = ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * maxRadius, z = ((Sin(angleY))) * maxRadius}

  local pos = {x = pCoords.x + offset.x, y = pCoords.y + offset.y, z = pCoords.z + offset.z}

  return pos
end

--LIFT EMS--
lib.registerContext({
  id = 'liftems',
  title = 'RUMAH SAKIT DAILYLIFE',
  onExit = function()
      print('berhasil')
  end,
  options = {
      {
          title = 'Basement',
          description = ' ',
          arrow = false,
          event = 'basement',
      },
      {
        title = 'Lobby',
        description = ' ',
        arrow = false,
        event = 'lt1',
    },
    {
      title = 'Lantai 1',
      description = ' ',
      arrow = false,
      event = 'lt2',
  },
  {
    title = 'Lantai 2',
    description = ' ',
    arrow = false,
    event = 'lt3',
  },
  {
    title = 'Lantai 8',
    description = ' ',
    arrow = false,
    event = 'lt4',
  }
  },
})

RegisterNetEvent('basement', function()
  ESX.Game.Teleport(ESX.PlayerData.ped, vector4(-1845.7388916016,-341.9899597168,41.248447418213,135.6))
end)

RegisterNetEvent('lt1', function()
  ESX.Game.Teleport(ESX.PlayerData.ped, vector4(-1843.2434082031,-341.91519165039,49.452751159668,140.42))
end)

RegisterNetEvent('lt2', function()
  ESX.Game.Teleport(ESX.PlayerData.ped, vector4(-1870.3321533203,-309.19799804688,53.780044555664,127.77))
end)

RegisterNetEvent('lt3', function()
  ESX.Game.Teleport(ESX.PlayerData.ped, vector4(-1835.1689453125,-339.06008911133,58.157730102539,140.41))
end)

RegisterNetEvent('lt4', function()
  ESX.Game.Teleport(ESX.PlayerData.ped, vector4(-1877.5584716797,-315.77313232422,84.042282104492,322.39))
end)

RegisterNetEvent('dl-job:lift', function()
  lib.showContext('liftems')
end)

--MENU LAPOR KOMA--
RegisterNetEvent('dl-job:LaporKoma', function()
  local Data = ESX.GetPlayerData()
  local gettjob = Data.job.name

    if gettjob == 'police' then
        gettjob = 'Polisi' 
    elseif gettjob == 'ambulance' then
        gettjob = 'EMS'
    elseif gettjob == 'mechanic' then
        gettjob = 'Mekanik'
    elseif gettjob == 'pedagang' then
        gettjob = 'Pedagang'
    elseif gettjob == 'taxi' then
        gettjob = 'Trans'
    else
        gettjob = 'Warga'
    end
    local input = lib.inputDialog('LAPOR KOMA', {'ALASAN :'})

    if not input then return end
    local alasane = input[1]
    TriggerServerEvent('dl-job:kirimLKoma', gettjob, alasane)
    exports['midp-tasknotify']:SendAlert('success', 'Laporan Terkirim')
end)

RegisterNetEvent("dl-job:buatKPasien")
AddEventHandler("dl-job:buatKPasien", function(data)
  local mugshotURL = nil
	local data       = lib.inputDialog('Pembuatan Kartu Pasien', {'ID Player:', 'Link Foto:', 'Berlaku:'})

	if not data then return end
	local idplyr = tonumber(data[1])
	local mugshotURL = data[2]
	local habis = data[3]
	TriggerServerEvent("dl-job:gawekno", idplyr, mugshotURL, habis)
  exports['midp-tasknotify']:SendAlert('success', 'Berhasil Membuat (Terikirim Ke id yang di tuju)')
end)

RegisterNetEvent("dl-job:buatKBPJS")
AddEventHandler("dl-job:buatKBPJS", function(data)
  local mugshotURL = nil
	local data = lib.inputDialog('Pembuatan Kartu BPJS', {'ID Player:', 'Link Foto:', 'Berlaku:'})

	if not data then return end
	local idplyr = tonumber(data[1])
	local mugshotURL = data[2]
	local habis = data[3]
	TriggerServerEvent("dl-job:gaweknoBPJS", idplyr, mugshotURL, habis)
  exports['midp-tasknotify']:SendAlert('success', 'Berhasil Membuat (Terikirim Ke id yang di tuju)')
end)

local liftcuy = {
	{x = -1845.7388916016, y = -341.9899597168, z = 41.248447418213, h = 45},
  {x = -1843.2434082031, y = -341.91519165039, z = 49.452751159668, h = 45},
  {x = -1870.3321533203, y = -309.19799804688, z = 53.780044555664, h = 45},
  {x = -1835.1689453125, y = -339.06008911133, z = 58.157730102539, h = 45},
  {x = -1877.5584716797, y = -315.77313232422, z = 84.042282104492, h = 45}
}

local lkoma = {
  {x = 307.100006, y = -594.700012, z = 43.299999, h = 0, length = 1, width = 1, Minz = 48.79, Maxz = 52.79},
}

local nameid = 0

CreateThread(function()
  for k,v in pairs(liftcuy) do
		nameid = nameid + 1
		exports["ox_target"]:AddBoxZone("liftcuy".. nameid, vector3(v.x, v.y, v.z), 3.2, 8.0, {
		  name = "liftcuy" .. nameid,
		  heading = v.h,
		  debugPoly = false,
		  minZ = v.z - 1.0,
		  maxZ = v.z + 2.0
		}, {
		  options = {
		  {
        event = "dl-job:lift",
        icon = "fas fa-sign-out-alt",
        label = "lift",
		  },
		  },
		  distance = 2.0
		})
	end
  for k,v in pairs(lkoma) do
    nameid = nameid + 1
    exports["ox_target"]:AddBoxZone("lkoma".. nameid, vector3(v.x, v.y, v.z), v.length, v.width, {
      name = "lkoma" .. nameid,
      heading = v.h,
      debugPoly = false,
      minZ = v.Minz,
      maxZ = v.Maxz
    }, {
      options = {
      {
        event = "dl-job:LaporKoma",
        icon = "fas fa-sign-out-alt",
        label = "Lapor Koma",
      },
      },
      distance = 2.0
    })
  end
end)