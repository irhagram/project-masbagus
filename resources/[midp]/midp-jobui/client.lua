local showJobs = false
local isShowUI = false
local PlayerData = {}
local isNomerID = 0

CreateThread(function()


	while ESX.GetPlayerData().job == nil do
        Wait(10)
    end

	Wait(1000)
	PlayerData = ESX.GetPlayerData()
	TriggerEvent('jobui:updateStats')
	isNomerID = GetPlayerServerId(PlayerId())
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	TriggerEvent('jobui:updateStats')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	TriggerEvent('jobui:updateStats')
end)

RegisterNetEvent('jobui:updateStats')
AddEventHandler('jobui:updateStats', function()
	local name  = ESX.PlayerData.job.name
	local label = ESX.PlayerData.job.label
	local grade = ESX.PlayerData.job.grade_label

	SendNUIMessage({
		action = "setValue", 
		key = "job", 
		value = label.." - "..grade, 
		icon = name
	})
end)

CreateThread(function()
	RegisterCommand('+isShowUI', openisShowUI, false)
    RegisterCommand('-isShowUI', function() end, false)

    RegisterCommand('+isshowJobs', isshowJobs, false)
    RegisterCommand('-isshowJobs', function() end, false)

    RegisterCommand('+isshowIDPlayer', showIDEnable, false)
    RegisterCommand('-isshowIDPlayer', showIDDisable, false)
	while true do
		Wait(0)		
		if isShowUI then 
			DrawAdvancedText(0.112 - 0.01135, 0.06 - 0.002, 0.005, 0.0028, 0.4, isNomerID, 255, 255, 255, 255, 6, 1)
		end
	end
end)

function openisShowUI()
	if IsDisabledControlPressed(0, 19) then 
		if isShowUI then
			isShowUI = false
		elseif not isShowUI then 
			isShowUI = true
		end
	end
end

function isshowJobs()
	if IsDisabledControlPressed(0, 19) then 
		if showJobs then
			SendNUIMessage({ action = "toggle", show = false })
			showJobs = false
		elseif not showJobs then 
			SendNUIMessage({ action = "toggle", show = true })
			showJobs = true
		end
	end
end

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1+w, y - 0.02+h)
end

local playerDistances = {}
local function DrawText3D(x,y,z, text, r,g,b) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz)-vector3(x,y,z))
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        if not useCustomScale then
            SetTextScale(0.0*scale, 0.55*scale)
        else 
            SetTextScale(0.0*scale, customScale)
        end
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

CreateThread(function()
    while true do
    	Wait(1000)
        for _, id in ipairs(GetActivePlayers()) do
            x1, y1, z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
            x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
            distance = math.floor(#(vector3(x1,  y1,  z1)-vector3(x2,  y2,  z2)))
			playerDistances[id] = distance
        end        
    end
end)

local showIDPlayers = false

function showIDEnable()
	showIDPlayers = true
end

CreateThread(function()
    while true do
		Wait(0)
		if showIDPlayers then
			for _, id in ipairs(GetActivePlayers()) do
				if playerDistances[id] then
					if (playerDistances[id] < 2) then
						x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
						if IsEntityVisible(GetPlayerPed(id)) then
							if NetworkIsPlayerTalking(id) then
								DrawText3D(x2, y2, z2 + 1, GetPlayerServerId(id), 0,191,255)
							else
								DrawText3D(x2, y2, z2 + 1, GetPlayerServerId(id), 255,255,255)
							end
						end						
					end
				end
			end
		end		
	end
end)

function showIDDisable()
	showIDPlayers = false
end