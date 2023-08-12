local players = {}
local blipsPlayers = {}
local freeze = false
local spectate = false
local spectateOldCoord = nil
local showblips = false
local godmode = false
local selectedplayer
spawnped = false


AddEventHandler('esx:onPlayerSpawn', function()
	spawnped = true 
	if spawnped then 
		Wait(5000)
		TriggerServerEvent("midp-admin:provideped", PlayerPedId()) 
	else
		--
	end
end)

ChooseWep = {
    {label = "AP Pistol",                   weapon = 'weapon_appistol',}, 
    {label = "Assault Rifle",               weapon = 'weapon_assaultrifle',}, 
    {label = "Carbine Rifle",               weapon = 'weapon_carbinerifle',}, 
    {label = "Combat Pistol",               weapon = 'weapon_combatpistol',}, 
    {label = "Heavy Revolver",              weapon = 'weapon_revolver',}, 
    {label = "Heavy Sniper",                weapon = 'weapon_heavysniper',}, 
    {label = "Heavy Sniper Mk II",          weapon = 'weapon_heavysniper_mk2',}, 
    {label = "Machine Pistol",              weapon = 'weapon_machinepistol',}, 
    {label = "Micro SMG",                   weapon = 'weapon_microsmg',}, 
    {label = "Mini SMG",                    weapon = 'weapon_minismg',}, 
    {label = "Pistol",                      weapon = 'weapon_pistol',}, 
    {label = "Pistol .50",                  weapon = 'weapon_pistol50',}, 
    {label = "SMG",                         weapon = 'weapon_smg',},
    {label = "Sniper Rifle",                weapon = 'weapon_sniperrifle',}, 
    {label = "Special Carbine",             weapon = 'weapon_specialcarbine',}, 
    {label = "Stun Gun",                    weapon = 'weapon_stungun',},
}
    
AvailableWeatherTypes = {
    {label = "Extra Sunny",         weather = 'EXTRASUNNY',}, 
    {label = "Clear",               weather = 'CLEAR',}, 
    {label = "Neutral",             weather = 'NEUTRAL',}, 
    {label = "Smog",                weather = 'SMOG',}, 
    {label = "Foggy",               weather = 'FOGGY',}, 
    {label = "Overcast",            weather = 'OVERCAST',}, 
    {label = "Clouds",              weather = 'CLOUDS',}, 
    {label = "Clearing",            weather = 'CLEARING',}, 
    {label = "Rain",                weather = 'RAIN',}, 
    {label = "Thunder",             weather = 'THUNDER',}, 
    {label = "Snow",                weather = 'SNOW',}, 
    {label = "Blizzard",            weather = 'BLIZZARD',}, 
    {label = "Snowlight",           weather = 'SNOWLIGHT',}, 
    {label = "XMAS (Heavy Snow)",   weather = 'XMAS',}, 
    {label = "Halloween (Scarry)",  weather = 'HALLOWEEN',},
}

local time = {"06 00","09 00","12 00","15 00","18 00","21 00","24 00"}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if InfStamina then
            RestorePlayerStamina(PlayerId(), 1.0)
        end

        if deleteLazer then
            local color = {r = 255, g = 255, b = 255, a = 200}
            local position = GetEntityCoords(GetPlayerPed(-1))
            local hit, coords, entity = RayCastGamePlayCamera(1000.0)
            
            if hit and (IsEntityAVehicle(entity) or IsEntityAPed(entity) or IsEntityAnObject(entity)) then
                local entityCoord = GetEntityCoords(entity)
                local minimum, maximum = GetModelDimensions(GetEntityModel(entity))
                
                DrawEntityBoundingBox(entity, color)
                DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
                DrawText3D(entityCoord.x, entityCoord.y, entityCoord.z, "Obj: " .. entity .. " Model: " .. GetEntityModel(entity).. " \nPress [~g~E~s~] to delete this object!", 2)

                if IsControlJustReleased(0, 38) then
                    SetEntityAsMissionEntity(entity, true, true)
                    DeleteEntity(entity)
                end

            elseif coords.x ~= 0.0 and coords.y ~= 0.0 then
                DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
                DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, color.r, color.g, color.b, color.a, false, true, 2, nil, nil, false)
            end
        end

        if showCoords then
            x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
            heading = GetEntityHeading(GetPlayerPed(-1))
        
            roundx = tonumber(string.format("%.2f", x))
            roundy = tonumber(string.format("%.2f", y))
            roundz = tonumber(string.format("%.2f", z))
            roundh = tonumber(string.format("%.2f", heading))

            DrawTxt("~r~X:~s~ "..roundx, 0.32, 0.00)
            DrawTxt("~r~Y:~s~ "..roundy, 0.38, 0.00)
            DrawTxt("~r~Z:~s~ "..roundz, 0.445, 0.00)
            DrawTxt("~r~H:~s~ "..roundh, 0.50, 0.00)
        end

        if drawInfo then
            local text = {}
            -- cheat checks
            local targetPed = GetPlayerPed(drawTarget)
            local targetGod = GetPlayerInvincible(drawTarget)
            local invehhh   = IsPedInAnyVehicle(targetPed, false)
            local isTalking = NetworkIsPlayerTalking(drawTarget)
            local x, y, z   = table.unpack(GetEntityCoords(targetPed, true))
            local heading   = GetEntityHeading(targetPed)

            roundx = tonumber(string.format("%.2f", x))
            roundy = tonumber(string.format("%.2f", y))
            roundz = tonumber(string.format("%.2f", z))
            roundh = tonumber(string.format("%.2f", heading))

            if targetGod then
                table.insert(text, "God Mode: ~r~Detected~w~")
            end
            if isTalking then
                table.insert(text, "Talking: ~g~Detected~w~")
            end
            -- health info
            table.insert(text,"Coord " ..": " .. roundx .. ", " .. roundy .. ", " .. roundz .. ", " .. roundh)
            table.insert(text,"Health "..": "..GetEntityHealth(targetPed).."/"..GetEntityMaxHealth(targetPed))
            table.insert(text,"Armor "..": "..GetPedArmour(targetPed).."/100")
            -- misc info
            if invehhh then
                vehicle = GetVehiclePedIsIn(targetPed, false)
                asu = GetEntitySpeed(vehicle)
                kmh = tostring(math.ceil(asu * 3.6))
                bensin = tostring(math.ceil(exports["dl-bensin"]:GetFuel(vehicle)))
                table.insert(text, "Fuel" ..": ".. bensin)
                table.insert(text, "Speed" ..": "..kmh.." km/h")
            else
                speed = GetEntitySpeed(targetPed)
                rounds = tonumber(string.format("%.2f", speed))
                table.insert(text, "Speed" ..": "..rounds)
            end
            
            for i,theText in pairs(text) do
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.30)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString(theText)
                EndTextCommandDisplayText(0.019, 0.5+(i/30))
            end
        end

        if showblips then 
            for _, player in ipairs(GetActivePlayers()) do
                if GetPlayerPed(id) ~= PlayerPedId() then
                    local name = GetPlayerName(player)
                    createBlip(player, '[' .. GetPlayerServerId(player) .. '] ' .. name)
                end
            end
        end

        function createBlip(id, nama)
            local ped = GetPlayerPed(id)
            local blip = GetBlipFromEntity(ped)
        
            if not DoesBlipExist(blip) then -- Add blip and create head display on player
                blip = AddBlipForEntity(ped)
                SetBlipSprite(blip, 1)
                SetBlipColour(blip, 0)
                ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
                SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
                SetBlipScale(blip, 0.85) -- set scale
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(nama)
                SetBlipCategory(blip, 7)
                EndTextCommandSetBlipName(blip)
                
                table.insert(blipsPlayers, blip) -- add blip to array so we can remove it later
            end
        end
        
        if shouldDraw then
            local nearbyPlayers = GetNeareastPlayers()
            for k, v in pairs(nearbyPlayers) do
                local x, y, z = table.unpack(v.coords)
                DrawText3D(x, y, z + 1.0, v.playerId .. ' | ' .. v.playerName) 
            end
        end
    end
end)

Citizen.CreateThread(function()
    -- superadmin menu
	WarMenu.CreateMenu("MainMenu", " ")
    WarMenu.SetSubTitle("MainMenu", "Options")
    WarMenu.SetMenuWidth("MainMenu", 0.5)
    WarMenu.SetMenuX("MainMenu", 0.769)
    WarMenu.SetMenuY("MainMenu", 0.04)
    WarMenu.SetMenuMaxOptionCountOnScreen("MainMenu", 30)
    WarMenu.SetTitleColor("MainMenu", 135, 206, 250, 255)
    WarMenu.SetTitleBackgroundColor("MainMenu", 0 , 0, 0, 150)
    WarMenu.SetMenuBackgroundColor("MainMenu", 0, 0, 0, 100)
    WarMenu.SetMenuSubTextColor("MainMenu", 255, 255, 255, 255)
--admin menu
    WarMenu.CreateMenu("AdminMainMenu", " ")
    WarMenu.SetSubTitle("AdminMainMenu", "Options")
    WarMenu.SetMenuWidth("AdminMainMenu", 0.5)
    WarMenu.SetMenuX("AdminMainMenu", 0.769)
    WarMenu.SetMenuY("AdminMainMenu", 0.04)
    WarMenu.SetMenuMaxOptionCountOnScreen("AdminMainMenu", 30)
    WarMenu.SetTitleColor("AdminMainMenu", 135, 206, 250, 255)
    WarMenu.SetTitleBackgroundColor("AdminMainMenu", 0 , 0, 0, 150)
    WarMenu.SetMenuBackgroundColor("AdminMainMenu", 0, 0, 0, 100)
    WarMenu.SetMenuSubTextColor("AdminMainMenu", 255, 255, 255, 255)

    -- record menu
    WarMenu.CreateMenu("recmenu", "")
    WarMenu.SetSubTitle("recmenu", "Options")
    WarMenu.SetMenuWidth("recmenu", 0.5)  
    WarMenu.SetMenuX("recmenu", 0.769)  
    WarMenu.SetMenuY("recmenu", 0.04)  
    WarMenu.SetMenuMaxOptionCountOnScreen("recmenu", 30) 
    WarMenu.SetTitleColor("recmenu", 135, 206, 250, 255)
    WarMenu.SetTitleBackgroundColor("recmenu", 0 , 0, 0, 150)  
    WarMenu.SetMenuBackgroundColor("recmenu", 0, 0, 0, 100)  
    WarMenu.SetMenuSubTextColor("recmenu", 255, 255, 255, 255)

    local function SetDefaultSubMenuProperties(menu)
        WarMenu.SetMenuWidth(menu, 0.5)
        WarMenu.SetTitleColor(menu, 135, 206, 250, 255)
        WarMenu.SetTitleBackgroundColor(menu, 0 , 0, 0, 150)
        WarMenu.SetMenuBackgroundColor(menu, 0, 0, 0, 100)
        WarMenu.SetMenuSubTextColor(menu, 255, 255, 255, 255)
    end

    WarMenu.CreateSubMenu('playerlist', 'MainMenu', 'Player List')
    SetDefaultSubMenuProperties("playerlist")
    WarMenu.CreateSubMenu("aallplayer", "MainMenu", "All Players")
    SetDefaultSubMenuProperties("aallplayer")
    --[[WarMenu.CreateSubMenu('chooseweather', 'MainMenu', 'Choose Weather')
    SetDefaultSubMenuProperties("chooseweather")
    WarMenu.CreateSubMenu('choosetime', 'MainMenu', 'Choose Time')
    SetDefaultSubMenuProperties("choosetime")]]
    WarMenu.CreateSubMenu("spawnobj", "MainMenu", "Spawn Object Menu")
    SetDefaultSubMenuProperties("spawnobj")
    WarMenu.CreateSubMenu("deletevehicle", "MainMenu", "Delete Vehicle Menu")
    SetDefaultSubMenuProperties("deletevehicle")
    WarMenu.CreateSubMenu('utility', 'MainMenu', 'Utility')
    SetDefaultSubMenuProperties("utility")
    --WarMenu.CreateSubMenu('worldopt', 'MainMenu', 'World Menu')
    --SetDefaultSubMenuProperties("worldopt")
    WarMenu.CreateSubMenu('playermanage', 'MainMenu', 'Player manage')
    SetDefaultSubMenuProperties("playermanage")
    WarMenu.CreateSubMenu('vehicle', 'MainMenu', 'Vehicle manage')
    SetDefaultSubMenuProperties("vehicle")
    WarMenu.CreateSubMenu('troll', 'MainMenu', 'Troll Players')
    SetDefaultSubMenuProperties("troll")
    WarMenu.CreateSubMenu('SingleWepPlayer', 'MainMenu', 'Weapon manage')
    SetDefaultSubMenuProperties("SingleWepPlayer")
    WarMenu.CreateSubMenu('givemoney', 'MainMenu', 'Give money')
    SetDefaultSubMenuProperties("givemoney")
    WarMenu.CreateSubMenu("changeskin", "MainMenu", "Change Skin")
    SetDefaultSubMenuProperties("changeskin")
    WarMenu.CreateSubMenu("bannedmenu", "MainMenu", "Banned Menu")
    SetDefaultSubMenuProperties("bannedmenu")
    WarMenu.CreateSubMenu("bannedmenuoff", "MainMenu", "Banned Offline")
    SetDefaultSubMenuProperties("bannedmenuoff")
    WarMenu.CreateSubMenu("awarningp", "MainMenu", "Warning Player")
    SetDefaultSubMenuProperties("awarningp")
    WarMenu.CreateSubMenu("gantiplat", "MainMenu", "Ganti Plat")
    SetDefaultSubMenuProperties("gantiplat")
    WarMenu.CreateSubMenu("spawnveh", "MainMenu", "Spawn Kendaraan")
    SetDefaultSubMenuProperties("spawnveh")
    --admin menu ruwet
    WarMenu.CreateSubMenu('adminplayerlist', 'AdminMainMenu', 'Player List')
    SetDefaultSubMenuProperties("adminplayerlist")
    WarMenu.CreateSubMenu("adminaallplayer", "AdminMainMenu", "All Players")
    SetDefaultSubMenuProperties("adminaallplayer")
    WarMenu.CreateSubMenu("admindeletevehicle", "AdminMainMenu", "Delete Vehicle Menu")
    SetDefaultSubMenuProperties("admindeletevehicle")
    WarMenu.CreateSubMenu('adminutility', 'AdminMainMenu', 'Utility')
    SetDefaultSubMenuProperties("adminutility")
    WarMenu.CreateSubMenu('adminplayermanage', 'AdminMainMenu', 'Player manage')
    SetDefaultSubMenuProperties("adminplayermanage")
    WarMenu.CreateSubMenu('givemoney', 'AdminMainMenu', 'Give money')
    SetDefaultSubMenuProperties("givemoney")
    WarMenu.CreateSubMenu("bannedmenu", "AdminMainMenu", "Banned Menu")
    SetDefaultSubMenuProperties("bannedmenu")
    WarMenu.CreateSubMenu("bannedmenuoff", "AdminMainMenu", "Banned Offline")
    SetDefaultSubMenuProperties("bannedmenuoff")
    WarMenu.CreateSubMenu("awarningp", "AdminMainMenu", "Warning Player")
    SetDefaultSubMenuProperties("adminawarningp")
    --RECORD MENU--
    WarMenu.CreateSubMenu("crecord", "recmenu", "Recording Menu")
    SetDefaultSubMenuProperties("crecord")
    
    while true do
        shouldDraw = false
        if WarMenu.IsMenuOpened('MainMenu') then ------------MAIN MENU------------
            if WarMenu.MenuButton('Player List', 'playerlist') then
            elseif WarMenu.MenuButton('Utility', 'utility') then
            --elseif WarMenu.MenuButton('World Menu', 'worldopt') then
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened('AdminMainMenu') then ------------MAIN MENU------------
            if WarMenu.MenuButton('Player List', 'adminplayerlist') then
            elseif WarMenu.MenuButton('Utility', 'adminutility') then
            end
    
            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened('utility') then ------------SELF MENU------------
            if WarMenu.Button("TP Marker") then
                TriggerEvent("midp-admin:tpm")
                TriggerServerEvent("midp-admin:wedos", 'TP Marker')
            elseif WarMenu.MenuButton('Vehicle Menu', 'vehicle')  then
            elseif WarMenu.Button("No Clip") then
                ExecuteCommand('noclip')
                TriggerServerEvent("midp-admin:wedos", 'Noclip')
            elseif WarMenu.Button("Refresh") then              
                TriggerEvent("midp-admin:RefreshPlayer", GetPlayerServerId(opt))
                TriggerServerEvent("midp-admin:wedos", 'Refresh Player')
            elseif WarMenu.Button("Invisible") then
                if invisible == true then 
                    invisible = false 
                    SetEntityVisible(GetPlayerPed(-1), false, 0)
                    TriggerServerEvent("midp-admin:wedos", 'Invisible = False')
                else
                    invisible = true 
                    SetEntityVisible(GetPlayerPed(-1), true, 0)
                    TriggerServerEvent("midp-admin:wedos", 'Invisible = True')             
                end
            elseif WarMenu.Button("Ganti Plat") then
                WarMenu.OpenMenu("gantiplat")
            elseif WarMenu.Button("Armor") then
                local ped = GetPlayerPed(-1)
				SetPedArmour(PlayerPedId(), 200)
                TriggerServerEvent("midp-admin:wedos", 'Armor')
            elseif WarMenu.Button("Godmode") then
                godmode = not godmode
                if godmode then
                    SetEntityInvincible(PlayerPedId(), true)
                    exports['midp-tasknotify']:SendAlert('success', 'GodMode ON')
                    TriggerServerEvent("midp-admin:wedos", 'GodMode = ON')             
                else
                    SetEntityInvincible(PlayerPedId(), false)    
                    exports['midp-tasknotify']:SendAlert('success', 'GodMode OFF')  
                    TriggerServerEvent("midp-admin:wedos", 'GodMode = OFF')    
                end    
            elseif WarMenu.Button("Suicide") then
                SetEntityHealth(PlayerPedId(), 0)
                TriggerServerEvent("midp-admin:wedos", 'Suicide')
            elseif WarMenu.Button("Spawn Kendaraan") then
                WarMenu.OpenMenu("spawnveh")
            elseif WarMenu.Button("Spawn Object") then
                WarMenu.OpenMenu("spawnobj")
            elseif WarMenu.Button("Clear Vehicle") then
                ShowTextEntry('Radius', "", function(result)
                    TriggerEvent('midp-admin:deleteVehicle', result)
                    TriggerServerEvent("midp-admin:wedos", 'Clear Vehicle Dengan Radius:' ..result)
                end)
            elseif WarMenu.Button("Clear Object") then
                ShowTextEntry('Radius', "", function(result)
                    TriggerEvent('midp-admin:deleteObj', result)
                    TriggerServerEvent("midp-admin:wedos", 'Clear Object Dengan Radius:' ..result)
                end)
            elseif WarMenu.Button("Clear Peds") then
                TriggerEvent('midp-admin:deletePeds')   
                TriggerServerEvent("midp-admin:wedos", 'Delete Peds')
            elseif WarMenu.Button("Change Skin") then
                ESX.TriggerServerCallback("midp-admin:getadminRank", function(playerRank)
                    if playerRank == "superadmin" then
                        ShowTextEntry('Skin Model', "", function(result)
                            if result then
                                TriggerEvent('midp-admin:changeSkin', result)
                                TriggerServerEvent("midp-admin:wedos", " Menggunakan Fitur Change Skin")
                            end
                            
                        end)
                    end
                end)
            elseif WarMenu.Button("Show Blip") then
                ESX.TriggerServerCallback("midp-admin:getadminRank", function(playerRank)
                if playerRank == "superadmin" then
                if showblips == true then 
                    showblips = false 
                    TriggerServerEvent("midp-admin:wedos", 'Show blips = False')
                else
                    showblips = true 
                    TriggerServerEvent("midp-admin:wedos", 'Show blips = Off')
                end
            end
        end)
            elseif WarMenu.Button("Input Warning") then
                WarMenu.OpenMenu("awarningp")
            elseif WarMenu.MenuButton('Banned Offline Player', 'bannedmenuoff')  then
            elseif WarMenu.CheckBox("Coords",showCoords,function(enabled)showCoords = enabled end) then
                TriggerServerEvent("midp-admin:wedos", 'Show Coords')
            elseif WarMenu.CheckBox("Infinite Stamina",InfStamina,function(enabled)InfStamina = enabled end) then
                ESX.TriggerServerCallback("midp-admin:getadminRank", function(playerRank)
                if playerRank == "superadmin" then
                TriggerServerEvent("midp-admin:wedos", 'Infinite Stamina')
                end
            end)
            --[[elseif WarMenu.CheckBox("Infinite Ammo",InfAmmo,function(enabled)InfAmmo = enabled SetPedInfiniteAmmo(PlayerPedId(), InfAmmo)end) then
                ESX.TriggerServerCallback("midp-admin:getadminRank", function(playerRank)
                    if playerRank == "superadmin" then
                    TriggerServerEvent("midp-admin:wedos", 'Infinite Ammo')
                    end
                end)]]
            elseif WarMenu.CheckBox("Delete Entity", deleteLazer, function(checked) deleteLazer = checked end) then
        end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened('adminutility') then ------------ADMIN SELF MENU------------
            if WarMenu.Button("TP Marker") then
                TriggerEvent("midp-admin:tpm")
                TriggerServerEvent("midp-admin:wedos", 'TP Marker')
            elseif WarMenu.Button("No Clip") then
                ExecuteCommand('noclip')
                TriggerServerEvent("midp-admin:wedos", 'Noclip')
            elseif WarMenu.Button("Refresh") then              
                TriggerEvent("midp-admin:RefreshPlayer", GetPlayerServerId(opt))
                TriggerServerEvent("midp-admin:wedos", 'Refresh Player')
            elseif WarMenu.Button("Max Performace Vehicle") then              
                engine(GetVehiclePedIsUsing(PlayerPedId()))
                TriggerServerEvent("midp-admin:wedos", 'Max Performace Veh')
            elseif WarMenu.Button("Invisible") then
                if invisible == true then 
                    invisible = false 
                    SetEntityVisible(GetPlayerPed(-1), false, 0)
                    TriggerServerEvent("midp-admin:wedos", 'Invisible = False')
                else
                    invisible = true 
                    SetEntityVisible(GetPlayerPed(-1), true, 0)
                    TriggerServerEvent("midp-admin:wedos", 'Invisible = True')             
                end
            elseif WarMenu.Button("Clear Vehicle") then
                ShowTextEntry('Radius', "", function(result)
                    TriggerEvent('midp-admin:deleteVehicle', result)
                    TriggerServerEvent("midp-admin:wedos", 'Clear Vehicle Dengan Radius:' ..result)
                end)
            elseif WarMenu.Button("Input Warning") then
                WarMenu.OpenMenu("awarningp")
            elseif WarMenu.MenuButton('Banned Offline Player', 'bannedmenuoff')  then
            elseif WarMenu.CheckBox("Coords",showCoords,function(enabled)showCoords = enabled end) then
                TriggerServerEvent("midp-admin:wedos", 'Show Coords')
        end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("worldopt") then ------------WORLD MENU------------
            if WarMenu.MenuButton('Weather', 'chooseweather') then
            elseif WarMenu.MenuButton('Time', 'choosetime') then
            elseif WarMenu.Button("Blackout") then
                ExecuteCommand('blackout')
            elseif WarMenu.Button("Freeze Time") then
                ExecuteCommand('freezetime')
            elseif WarMenu.Button("Freeze Weather") then
                ExecuteCommand('freezeweather')
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("chooseweather") then ------------WEATHER MENU------------
            for k, v in pairs(AvailableWeatherTypes) do
                if WarMenu.MenuButton(AvailableWeatherTypes[k].label, 'chooseweather') then
                    ExecuteCommand('weather '..AvailableWeatherTypes[k].weather)
                end
            end
            
            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("choosetime") then ------------TIME MENU------------
            for i = 1, #time do
                if WarMenu.Button(time[i]) then
                    ExecuteCommand('time '..time[i])
                end
            end
            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("spawnobj") then ------------SPAWN OBJECT MENU------------
            local playerPed = PlayerPedId()
            local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
            local position = (coords + forward * 3.0)
            local color = {r = 255, g = 255, b = 255, a = 200}

            DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
            message1 = message1 ~= nil and message1 or ''
            message2 = message2 ~= nil and message2 or ''

            if WarMenu.Button("Object", (message1 and message1 or nil)) then
                ShowTextEntry('Ketik Object', "", function(result)
                    message1 = result
                end)
            end

            message2 = message1 

            if WarMenu.Button("Spawn Object: " .. (message2 and message2 or "")) then
                if message1 == '' then 
                    exports['midp-tasknotify']:SendAlert('error', 'Input yang bener!', 10000)
                else
                    ExecuteCommand('spawnobj '.. message1)
                end
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("deletevehicle") then ------------DELETE VEHICLE MENU------------
            local playerPed = PlayerPedId()

            message1 = message1 ~= nil and message1 or ''
            message2 = message2 ~= nil and message2 or ''

            if WarMenu.Button("Radius", (message1 and message1 or nil)) then
                ShowTextEntry('Ketik Radius', "", function(result)
                    message1 = result
                end)
            end

            message2 = message1 

            if WarMenu.Button("Delete Vehicle: " .. (message2 and message2 or "")) then
                if message1 == '' then 
                    exports['midp-tasknotify']:SendAlert('error', 'Input yang bener!', 10000)
                else
                    TriggerServerEvent("midp-admin:dv", message1)
                end
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("admindeletevehicle") then ------------DELETE VEHICLE MENU------------
            local playerPed = PlayerPedId()

            message1 = message1 ~= nil and message1 or ''
            message2 = message2 ~= nil and message2 or ''

            if WarMenu.Button("Radius", (message1 and message1 or nil)) then
                ShowTextEntry('Ketik Radius', "", function(result)
                    message1 = result
                end)
            end

            message2 = message1 

            if WarMenu.Button("Delete Vehicle: " .. (message2 and message2 or "")) then
                if message1 == '' then 
                    exports['midp-tasknotify']:SendAlert('error', 'Input yang bener!', 10000)
                else
                    TriggerServerEvent("midp-admin:dv", message1)
                end
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("vehicle") then ------------VEHICLE MENU------------
            local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
            if WarMenu.Button("Repair Vehicle") then
                SetVehicleEngineHealth(veh, 1000)
                SetVehicleFixed(veh)
                SetVehicleEngineOn(veh, 1, 1)
            elseif WarMenu.Button("Clean Vehicle") then
                SetVehicleDirtLevel(veh, 0)
            elseif WarMenu.Button("Max All Tuning") then
                MaxOut(GetVehiclePedIsUsing(PlayerPedId()))
            elseif WarMenu.Button("Max Performance") then
                engine(GetVehiclePedIsUsing(PlayerPedId()))
            elseif WarMenu.Button("Modifikasi") then
                OpenVehicleControlsMenu()
                WarMenu.CloseMenu()
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("SingleWepPlayer") then ------------WEAPON MENU------------
            local ammo = 10000
            for k, v in pairs(ChooseWep) do
                if WarMenu.MenuButton(ChooseWep[k].label, 'SingleWepPlayer') then
                    ExecuteCommand('giveweapon '..selectedplayer.. " " .. ChooseWep[k].weapon .. " " .. ammo)
                end
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("troll") then ------------TROLL MENU------------
            local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
            if WarMenu.Button("Spawn FBI") then
                ExecuteCommand('trollfbi '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Troll Player (FBI)')
            elseif WarMenu.Button("Spawn Macan") then
                ExecuteCommand('trollmacan '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Troll Player (MACAN)')
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("vehicle") then ------------VEHICLE MENU------------
            local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
            if WarMenu.Button("Repair Vehicle") then
                SetVehicleEngineHealth(veh, 1000)
                SetVehicleFixed(veh)
                SetVehicleEngineOn(veh, 1, 1)
            elseif WarMenu.Button("Clean Vehicle") then
                SetVehicleDirtLevel(veh, 0)
            elseif WarMenu.Button("Max All Tuning") then
                MaxOut(GetVehiclePedIsUsing(PlayerPedId()))
            elseif WarMenu.Button("Max Performance") then
                engine(GetVehiclePedIsUsing(PlayerPedId()))
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("givemoney") then ------------GIVEMONEY MENU------------
            message1 = message1 ~= nil and message1 or 'money/bank/black_money'
            message2 = message2 ~= nil and message2 or '0'
            message3 = message3 ~= nil and message3 or 'ISI ALASAN YANG JELAS'
            message4 = message4 ~= nil and message4 or '0'

           
            if WarMenu.Button("Type", (message1 and message1 or "money")) then
                ShowTextEntry('Type?', "", function(result)
                    message1 = result
                end)
            end

            if WarMenu.Button("Amount", (message2 and message2 or "0")) then
                ShowTextEntry('Amount?', "", function(result)
                    message2 = result
                end)
            end

            if WarMenu.Button("Alasan", (message3 and message3 or "0")) then
                ShowTextEntry('Alasan?', "", function(result)
                    message3 = result
                end)
            end

            message4 = message1 .. ' | ' .. message2

            if WarMenu.Button("Set Money: " .. (message4 and message4 or "")) then
                if message1 == nil then message1 = 'money' end
                ExecuteCommand('briakwangalan '..selectedplayer.. " " .. message1 .. " " .. message2)
                TriggerServerEvent("midp-admin:beriuangnyadongg", 'SETMONEY SEBANYAK >> ' .. message2 .. " DENGAN ALASAN >> " .. message3)
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("bannedmenu") then ------------BANNED ONLINE MENU------------
            message1 = message1 ~= nil and message1 or ''
            message2 = message2 ~= nil and message2 or ''
            message3 = message3 ~= nil and message3 or ''

            if WarMenu.Button("Reason", (message1 and message1 or nil)) then
                ShowTextEntry('Ketik Alasan', "", function(result)
                    message1 = result
                end)
            end

            if WarMenu.Button("Hari", (message2 and message2 or nil)) then
                ShowTextEntry('Hari', "", function(result)
                    message2 = result
                end)
            end

            message3 = message1 .. ' | ' .. message2 
            if WarMenu.Button("Banned Player: " .. (message3 and message3 or "")) then
                if message1 == '' or message2 == '' then 
                    exports['midp-tasknotify']:SendAlert('error', 'Input yang bener!', 10000)
                else
                    exports.alan:bannedcok(selectedplayer, message2, message1)
                    --TriggerServerEvent('midp-admin:banplayeron', selectedplayer, message2, message1)
                    WarMenu.CloseMenu()
                end
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("bannedmenuoff") then ------------BANNED OFFLINE MENU------------
            message1 = message1 ~= nil and message1 or ''
            message2 = message2 ~= nil and message2 or ''
            message3 = message3 ~= nil and message3 or ''
            message4 = message4 ~= nil and message4 or ''

            if WarMenu.Button("Hex", (message1 and message1 or nil)) then
                ShowTextEntry('Ketik Hex', "", function(result)
                    message1 = result
                end)
            end

            if WarMenu.Button("Reason", (message2 and message2 or nil)) then
                ShowTextEntry('Ketik Alasan', "", function(result)
                    message2 = result
                end)
            end

            if WarMenu.Button("Hari", (message3 and message3 or nil)) then
                ShowTextEntry('Hari', "", function(result)
                    message3 = result
                end)
            end

            message4 = message1 .. ' | ' .. message2 .. ' | ' .. message3 
            if WarMenu.Button("Banned Player: " .. (message4 and message4 or "")) then
                if message1 == '' or message2 == '' or message3 == '' then 
                    exports['midp-tasknotify']:SendAlert('error', 'Input yang bener!', 10000)
                else
                    exports.alan:bannedcok(message1, message3, message2)
                    --TriggerServerEvent('midp-admin:banPlayeroff',message1, message2,message3)
                    WarMenu.CloseMenu()
                end
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("awarningp") then ------------ WARNING PLAYER ------------
            message1 = message1 ~= nil and message1 or ''
            message2 = message2 ~= nil and message2 or ''
            message3 = message3 ~= nil and message3 or ''
            message4 = message4 ~= nil and message4 or ''

            if WarMenu.Button("Steam Hex : ", (message1 and message1 or nil)) then
                ShowTextEntry('Steam Hex Target : ', "", function(result)
                    message1 = result
                end)
            end

            if WarMenu.Button("Alasan : ", (message3 and message3 or nil)) then
                ShowTextEntry('Ketik Alasan : ', "", function(result)
                    message3 = result
                end)
            end

            message4 = message1 .. ' | ' .. message3

            if WarMenu.Button("Kirim : " .. (message4 and message4 or "")) then
                if message1 == '' or message3 == '' then 
                    exports['midp-tasknotify']:SendAlert('error', 'Input yang bener!', 10000)
                else
                    TriggerServerEvent('midp-admin:inputwarning', message1, message3)
                    TriggerServerEvent("midp-admin:wedos", 'Memberikan Warning = ' .. message1 .. ' Alasan ' ..message3)
                    WarMenu.CloseMenu()
                end
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("gantiplat") then
            platetext1 = platetext1 ~= nil and platetext1 or 'nil'
            platetext2 = platetext2 ~= nil and platetext2 or '0'
            platetext3 = platetext3 ~= nil and platetext3 or '0'

            local playerPed = PlayerPedId()

            if IsPedInAnyVehicle(playerPed, true) then

                local vehicle = GetVehiclePedIsIn(playerPed, false)
                local plate = GetVehicleNumberPlateText(vehicle)

                if WarMenu.Button("Input new plate:", (platetext1 and platetext1 or "0")) then
                    ShowTextEntry('MAX 8 DIGIT (Termasuk Space):', "", function(result)
                        platetext1 = result
                        platetext2 = plate
                    end)
                end

                platetext3 = platetext1 .. ' | ' .. platetext2

                if WarMenu.Button("New plate: " .. (platetext3 and platetext3 or "0")) then

                    ESX.TriggerServerCallback('midp-admin:update', function( cb )
                        if cb == 'found' then
                          SetVehicleNumberPlateText(vehicle, platetext1)

                        elseif cb == 'error' then
                            exports['midp-tasknotify']:SendAlert('error', 'Tidak bisa digunakan')
                        end
                      end, platetext2, platetext1)

                end
            end
            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("spawnveh") then
            spawnveh = spawnveh ~= nil and spawnveh or 'nil'

            if WarMenu.Button("Model name:", (spawnveh and spawnveh or "0")) then
                ShowTextEntry('Model name:', "", function(result)
                    spawnveh = result
                end)
            end

            if WarMenu.Button("Set Owned") then
                TriggerEvent('esx_giveownedcar:spawnVehicle', GetPlayerServerId(PlayerId()), spawnveh, GetPlayerName(GetPlayerServerId(PlayerId())), 'playermanage')
            end

            if WarMenu.Button("Spawn Vehicle: " .. (spawnveh and spawnveh or "0")) then
                local playerPed = PlayerPedId()
                local coords    = GetEntityCoords(playerPed)

                local nameveh = GetHashKey(spawnveh)
                local namemodel = GetLabelText(GetDisplayNameFromVehicleModel(nameveh))

                if namemodel == 'NULL' then
                    exports['midp-tasknotify']:SendAlert('error', 'Kendaraan tidak terdaftar')
                else
                    ESX.Game.SpawnVehicle(spawnveh, coords, 90.0, function(vehicle)
                        TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
                    end)
                end
            end
            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("changeskin") then ------------CHANGE SKIN MENU------------
            message1 = message1 ~= nil and message1 or ''

            if WarMenu.Button("Skin Model", (message1 and message1 or nil)) then
                ShowTextEntry('Ketik Skin Model', "", function(result)
                    message1 = result
                end)
            end

            if WarMenu.Button("Change Skin: " .. (message1 and message1 or "")) then
                TriggerEvent('midp-admin:ChangeSkin', message1)
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened('playerlist') then ------------PLAYER LIST------------
            for i=1, #players, 1 do
                if WarMenu.MenuButton('['..players[i].id..'] '..players[i].name, 'playermanage') then
                    selectedplayer = players[i].id
                end
            end

            if WarMenu.Button("All Players") then
                WarMenu.OpenMenu("aallplayer")
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("aallplayer") then  
            if WarMenu.Button("Revive All") then
                ExecuteCommand( "reviveall" )
                TriggerServerEvent("midp-admin:wedos", 'Revive All')
            end
            if WarMenu.Button("Kick All") then
                TriggerServerEvent("midp-admin:kickall")
                TriggerServerEvent("midp-admin:wedos", 'Kick All')
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened('adminplayerlist') then ------------ADMIN PLAYER LIST------------
            for i=1, #players, 1 do
                if WarMenu.MenuButton('['..players[i].id..'] '..players[i].name, 'adminplayermanage') then
                    selectedplayer = players[i].id
                end
            end

            if WarMenu.Button("All Players") then
                WarMenu.OpenMenu("adminaallplayer")
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened("adminaallplayer") then  
            if WarMenu.Button("Revive All") then
                ExecuteCommand( "reviveall" )
                TriggerServerEvent("midp-admin:wedos", 'Revive All')
            end
            if WarMenu.Button("Kick All") then
                TriggerServerEvent("midp-admin:kickall")
                TriggerServerEvent("midp-admin:wedos", 'Kick All')
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened('playermanage') then ------------PLAYER LIST MENU------------
            if WarMenu.Button("Spectate") then
                if selectedplayer ~= GetPlayerServerId(PlayerId()) then
                    spectate = not spectate
                    if spectate then
                        spectateOldCoord = GetEntityCoords(PlayerPedId())
                        FreezeEntityPosition(PlayerPedId(), 1)
                        ESX.TriggerServerCallback('midp-admin:getTargetCoord', function(coord)
                            if coord ~= nil then
                                DoScreenFadeOut(200)
                                Citizen.Wait(350)
                                SetEntityCoords(PlayerPedId(), coord.x, coord.y, coord.z - 50, 0, 0, 0, 0)
                                Citizen.Wait(600)
                                DoScreenFadeIn(200)
                                NetworkSetInSpectatorMode(1, GetPlayerPed(GetPlayerFromServerId(selectedplayer)))
                                DrawPlayerInfo(GetPlayerFromServerId(selectedplayer))
                                -- TriggerEvent('updateVoipTargetPed', GetPlayerPed(GetPlayerFromServerId(selectedplayer)), false)
                            end
                        end, selectedplayer)
                    else
                        DoScreenFadeOut(200)
                        Citizen.Wait(350)
                        RequestCollisionAtCoord(spectateOldCoord.x, spectateOldCoord.y, spectateOldCoord.z)
                        NetworkSetInSpectatorMode(0, PlayerPedId())
                        -- TriggerEvent('updateVoipTargetPed', PlayerPedId(), true)
                        SetEntityCoords(PlayerPedId(), spectateOldCoord.x, spectateOldCoord.y, spectateOldCoord.z - 1.8, 0, 0, 0, 0)
                        FreezeEntityPosition(PlayerPedId(), 0)
                        DoScreenFadeIn(200)
                        StopDrawPlayerInfo()
                    end
                else
                    exports['midp-tasknotify']:SendAlert('error', 'Tidak Bisa Spectate Diri Sendiri COOOKKKKKKKK!', 10000)
                end
                TriggerServerEvent("midp-admin:wedos", 'Spectate')
            elseif WarMenu.Button("Bring") then
                ExecuteCommand('bring '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Bring')
            elseif WarMenu.Button("Bring Back") then
                ExecuteCommand('bringback '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Bring Back')
            elseif WarMenu.Button("Goto") then
                ExecuteCommand('goto '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Goto')
            elseif WarMenu.Button("Go Back") then
                ExecuteCommand('goback '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Goto Back')
            elseif WarMenu.Button("To Marker") then
                ExecuteCommand('tomarker'..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'To Marker')
            elseif WarMenu.Button("Heal") then
                ESX.TriggerServerCallback("midp-admin:getadminRank", function(playerRank)
                if playerRank == "superadmin" then
                ExecuteCommand('heal '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Heal Player')
                end
            end)
            elseif WarMenu.Button("Revive") then
                ExecuteCommand('revive '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Revive Player')
            elseif WarMenu.Button("Refresh") then
                ExecuteCommand('refreshplayer '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Refresh Player')
            elseif WarMenu.Button("Clone") then
                ESX.TriggerServerCallback("midp-admin:getadminRank", function(playerRank)
                    if playerRank == "superadmin" then
                TriggerEvent('midp-admin:ClonePed', GetPlayerPed(GetPlayerFromServerId(selectedplayer)))
            --     TriggerServerEvent("midp-admin:wedos", 'Clone Player')
                    end
                end)
            elseif WarMenu.Button("Frozen") then
                ExecuteCommand('freeze '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Freeze')
            elseif WarMenu.Button("Open Inventory") then
                ExecuteCommand('viewinv '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'OpenInventory')
            elseif WarMenu.Button("Slay") then
                ESX.TriggerServerCallback("midp-admin:getadminRank", function(playerRank)
                    if playerRank == "superadmin" then
                ExecuteCommand('kill '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Kill Player')
                    end
                end)
            elseif WarMenu.Button("Slap") then
                ESX.TriggerServerCallback("midp-admin:getadminRank", function(playerRank)
                    if playerRank == "superadmin" then
                ExecuteCommand('slap '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Slap Player')
                    end
                end)
            elseif WarMenu.Button("Fly") then
                ExecuteCommand('fly '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Fly Player')
            elseif WarMenu.Button("Noclip") then
                ESX.TriggerServerCallback("midp-admin:getadminRank", function(playerRank)
                    if playerRank == "superadmin" then
                ExecuteCommand('noclip2 '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Noclip Player')
                    end
                end)
            elseif WarMenu.Button("Delete Vehicle") then
                ExecuteCommand('dv2 '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'DV Player')
            elseif WarMenu.Button("Give money") then
				WarMenu.OpenMenu("givemoney")
            elseif WarMenu.Button("Give Weapon") then
                WarMenu.OpenMenu("SingleWepPlayer")
            elseif WarMenu.Button("Clear Inventory") then
                ShowTextEntry('Y or N', "", function(confirm)
                    if confirm == "y" or confirm == "Y" then
                        ExecuteCommand('clearinventory '..selectedplayer)
                        ExecuteCommand('clearloadout '..selectedplayer)
                    else
                        WarMenu.CloseMenu()
                    end
                end)
            elseif WarMenu.Button("Kick Player") then
                ShowTextEntry('Reason', "", function(reason)
                    if reason == nil then reason = 'No Reason' end
                    TriggerServerEvent("midp-admin:kickPlayer", selectedplayer, reason) 
                end)
            elseif WarMenu.MenuButton('Ban Player', 'bannedmenu') then
            elseif WarMenu.MenuButton('Troll Menu', 'troll')  then
            --elseif WarMenu.Button("Troll Menu") then
              --  ExecuteCommand('troll '..selectedplayer)
                --TriggerServerEvent("midp-admin:wedos", 'Troll Player')
            end

            WarMenu.Display()
            shouldDraw = true
        elseif WarMenu.IsMenuOpened('adminplayermanage') then ------------ADMIN PLAYER LIST MENU------------
            if WarMenu.Button("Spectate") then
                if selectedplayer ~= GetPlayerServerId(PlayerId()) then
                    spectate = not spectate
                    if spectate then
                        spectateOldCoord = GetEntityCoords(PlayerPedId())
                        FreezeEntityPosition(PlayerPedId(), 1)
                        ESX.TriggerServerCallback('midp-admin:getTargetCoord', function(coord)
                            if coord ~= nil then
                                DoScreenFadeOut(200)
                                Citizen.Wait(350)
                                SetEntityCoords(PlayerPedId(), coord.x, coord.y, coord.z - 50, 0, 0, 0, 0)
                                Citizen.Wait(600)
                                DoScreenFadeIn(200)
                                NetworkSetInSpectatorMode(1, GetPlayerPed(GetPlayerFromServerId(selectedplayer)))
                                DrawPlayerInfo(GetPlayerFromServerId(selectedplayer))
                                -- TriggerEvent('updateVoipTargetPed', GetPlayerPed(GetPlayerFromServerId(selectedplayer)), false)
                            end
                        end, selectedplayer)
                    else
                        DoScreenFadeOut(200)
                        Citizen.Wait(350)
                        RequestCollisionAtCoord(spectateOldCoord.x, spectateOldCoord.y, spectateOldCoord.z)
                        NetworkSetInSpectatorMode(0, PlayerPedId())
                        -- TriggerEvent('updateVoipTargetPed', PlayerPedId(), true)
                        SetEntityCoords(PlayerPedId(), spectateOldCoord.x, spectateOldCoord.y, spectateOldCoord.z - 1.8, 0, 0, 0, 0)
                        FreezeEntityPosition(PlayerPedId(), 0)
                        DoScreenFadeIn(200)
                        StopDrawPlayerInfo()
                    end
                else
                    exports['midp-tasknotify']:SendAlert('error', 'Tidak Bisa Spectate Diri Sendiri COOOKKKKKKKK!', 10000)
                end
                TriggerServerEvent("midp-admin:wedos", 'Spectate')
            elseif WarMenu.Button("Bring") then
                ExecuteCommand('bring '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Bring')
            elseif WarMenu.Button("Bring Back") then
                ExecuteCommand('bringback '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Bring Back')
            elseif WarMenu.Button("Goto") then
                ExecuteCommand('goto '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Goto')
            elseif WarMenu.Button("Go Back") then
                ExecuteCommand('goback '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Goto Back')
            elseif WarMenu.Button("Refresh") then
                ExecuteCommand('refreshplayer '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Refresh Player')
            elseif WarMenu.Button("Frozen") then
                ExecuteCommand('freeze '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'Freeze')
            elseif WarMenu.Button("Open Inventory") then
                TriggerEvent("jn-inventory:openPlayerInventory",(selectedplayer))
                TriggerServerEvent("midp-admin:wedos", 'OpenInventory')
            elseif WarMenu.Button("Delete Vehicle") then
                ExecuteCommand('dv2 '..selectedplayer)
                TriggerServerEvent("midp-admin:wedos", 'DV Player Vehicle')
            elseif WarMenu.Button("Give money") then
				WarMenu.OpenMenu("givemoney")
            elseif WarMenu.Button("Clear Inventory") then
                ShowTextEntry('Y or N', "", function(confirm)
                    if confirm == "y" or confirm == "Y" then
                        ExecuteCommand('clearinventory '..selectedplayer)
                        ExecuteCommand('clearloadout '..selectedplayer)
                    else
                        WarMenu.CloseMenu()
                    end
                end)
            elseif WarMenu.Button("Kick Player") then
                ShowTextEntry('Reason', "", function(reason)
                    if reason == nil then reason = 'No Reason' end
                    TriggerServerEvent("midp-admin:kickPlayer", selectedplayer, reason) 
                end)
            elseif WarMenu.MenuButton('Ban Player', 'bannedmenu') then
            end

            WarMenu.Display()
            shouldDraw = true
        elseif IsDisabledControlPressed(0, 57) then
            ESX.TriggerServerCallback("midp-admin:getadminRank", function(playerRank)
                if playerRank == "admin" then
                    refreshPlayers()
                    WarMenu.OpenMenu("AdminMainMenu")
                end
            end)
        elseif IsControlJustReleased(0, 344) then -- F10
            
            WarMenu.OpenMenu("recmenu")
        elseif WarMenu.IsMenuOpened("recmenu") then
            if WarMenu.Button("Start Recording") then
                if IsRecording() then 
                    exports['midp-tasknotify']:SendAlert('error', 'Recording sedang berlangsung!', 10000)
                else
                    StartRecording(1)
                end
            end

            if WarMenu.Button("Stop Recording") then
                if not IsRecording() then 
                    exports['midp-tasknotify']:SendAlert('error', 'Recording tidak berlangsung!', 10000)
                else
                    StopRecordingAndSaveClip()
                end
            end

            if WarMenu.Button("Rockstar Editor") then
                NetworkSessionLeaveSinglePlayer()
                ActivateRockstarEditor()
                DoScreenFadeIn(1)
            end

            WarMenu.Display()
		else
			Citizen.Wait(100)
		end
		Citizen.Wait(0)
	end
end)

RegisterCommand('adminMenuRWT', function()
    ESX.TriggerServerCallback("midp-admin:getadminRank", function(playerRank)
        if playerRank == "superadmin" then
            refreshPlayers()
            WarMenu.OpenMenu("MainMenu")
        end
    end)
end)

function DrawPlayerInfo(target)
    drawTarget = target
     drawInfo = true
end

function StopDrawPlayerInfo()
    drawInfo = false
    drawTarget = nil
end

function refreshPlayers()
    ESX.TriggerServerCallback('midp-admin:getPlayers', function(alantesplayer)
        if alantesplayer ~= nil or #alantesplayer > 0 then
            players = {}
            table.sort(alantesplayer, function(a, b) return a.id < b.id end)
            players = alantesplayer
        end
    end)
end

deleteLazer = false


local textEntryCb

local function nuiCallBack(data)
    if data.textEntry then
        textEntryCb(data.text and data.text or nil)
    end

    if data.close then
        SetNuiFocus(false, false)
    end

    if data.showcursor or data.showcursor == false then SetNuiFocus(data.showcursor, data.showcursor) end
end

RegisterNUICallback("nuiMessage", nuiCallBack)

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)

    return coroutine.wrap(function()

        local iter, id = initFunc()

        if not id or id == 0 then

            disposeFunc(iter)

            return

        end



        local enum = {handle = iter, destructor = disposeFunc}

        setmetatable(enum, entityEnumerator)



        local next = true

        repeat

        coroutine.yield(id)

        next, id = moveFunc(iter)

        until not next



        enum.destructor, enum.handle = nil, nil

        disposeFunc(iter)

    end)

end

function ShowTextEntry(title, subMsg, cb)
    SendNUIMessage({
        open = true, textEntry = true, title = title, submsg = subMsg and subMsg or ""
    })

    textEntryCb = function(text) cb(text) end
end

function openTextEntry(title)
    ShowTextEntry(title, "", function(result)

    end)
end

function EnumerateObjects()

    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)

end
function EnumeratePeds()

    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)

end
function EnumerateVehicles()

    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)

end

function GetInputMode()
    return Citizen.InvokeNative(0xA571D46727E2B718, 2) and "MouseAndKeyboard" or "GamePad"
end

function GetNeareastPlayers()
    local players = {}

    for _, i in ipairs(GetActivePlayers()) do        -- do stuff
        table.insert(players, 
        { 
            playerName = GetPlayerName(i), 
            playerId = GetPlayerServerId(i), 
            coords = GetEntityCoords(GetPlayerPed(i)) 
        })
    end

    return players
end

function OpenBodySearchMenu(player)
	TriggerEvent('jn-inventory:openPlayerInventory', GetPlayerServerId(selectedplayer), GetPlayerName(selectedplayer))
end

-- Draws boundingbox around the object with given color parms
function DrawEntityBoundingBox(entity, color)
    local model = GetEntityModel(entity)
    local min, max = GetModelDimensions(model)
    local rightVector, forwardVector, upVector, position = GetEntityMatrix(entity)

    -- Calculate size
    local dim = { x = 0.5*(max.x - min.x), y = 0.5*(max.y - min.y), z = 0.5*(max.z - min.z)}

    local FUR = {x = position.x + dim.y*rightVector.x + dim.x*forwardVector.x + dim.z*upVector.x, y = position.y + dim.y*rightVector.y + dim.x*forwardVector.y + dim.z*upVector.y, z = 0}

    local FUR_bool, FUR_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    FUR.z = FUR_z
    FUR.z = FUR.z + 2 * dim.z

    local BLL = {x = position.x - dim.y*rightVector.x - dim.x*forwardVector.x - dim.z*upVector.x,y = position.y - dim.y*rightVector.y - dim.x*forwardVector.y - dim.z*upVector.y,z = 0}
    local BLL_bool, BLL_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    BLL.z = BLL_z

    -- DEBUG
    local edge1 = BLL
    local edge5 = FUR
    local edge2 = {x = edge1.x + 2 * dim.y*rightVector.x, y = edge1.y + 2 * dim.y*rightVector.y,z = edge1.z + 2 * dim.y*rightVector.z}
    local edge3 = {x = edge2.x + 2 * dim.z*upVector.x,y = edge2.y + 2 * dim.z*upVector.y,z = edge2.z + 2 * dim.z*upVector.z}
    local edge4 = {x = edge1.x + 2 * dim.z*upVector.x,y = edge1.y + 2 * dim.z*upVector.y,z = edge1.z + 2 * dim.z*upVector.z}
    local edge6 = {x = edge5.x - 2 * dim.y*rightVector.x,y = edge5.y - 2 * dim.y*rightVector.y,z = edge5.z - 2 * dim.y*rightVector.z}
    local edge7 = {x = edge6.x - 2 * dim.z*upVector.x, y = edge6.y - 2 * dim.z*upVector.y,z = edge6.z - 2 * dim.z*upVector.z}
    local edge8 = {x = edge5.x - 2 * dim.z*upVector.x, y = edge5.y - 2 * dim.z*upVector.y,z = edge5.z - 2 * dim.z*upVector.z}

    DrawLine(edge1.x, edge1.y, edge1.z, edge2.x, edge2.y, edge2.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge3.x, edge3.y, edge3.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge6.x, edge6.y, edge6.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge7.x, edge7.y, edge7.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge5.x, edge5.y, edge5.z, color.r, color.g, color.b, color.a)
    DrawLine(edge4.x, edge4.y, edge4.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
end

-- Embed direction in rotation vector
function RotationToDirection(rotation)
    local adjustedRotation = { x = (math.pi / 180) * rotation.x, y = (math.pi / 180) * rotation.y, z = (math.pi / 180) * rotation.z }
    local direction = {x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), z = math.sin(adjustedRotation.x)}
    return direction
end

-- Raycast function for "Admin Lazer"
function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination = { x = cameraCoord.x + direction.x * distance, y = cameraCoord.y + direction.y * distance, z = cameraCoord.z + direction.z * distance }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
    return b, c, e
end

function MaxOut(veh)
    SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
    SetVehicleWheelType(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 6, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 6) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 8, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 8) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 9, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 9) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 10, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 10) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 11, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 11) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 14, 16, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16) - 1, false)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 17, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 18, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 19, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 20, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 21, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, true)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 23, 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 24, 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 25, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 25) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 27) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 28, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 28) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 30, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 30) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 33, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 33) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 34, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 34) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 35, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 35) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 38, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 38) - 1, true)
    SetVehicleWindowTint(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1)
    SetVehicleTyresCanBurst(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
    SetVehicleNumberPlateTextIndex(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5)
end

function engine(veh)
    SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 11, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 11) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13) - 1, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 15, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 15) - 2, false)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16) - 1, false)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 17, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 18, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 19, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 21, true)
    SetVehicleTyresCanBurst(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)              
end

local function RGBRainbow(frequency)
    local result = {}
    local curtime = GetGameTimer() / 1000

    result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
    result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
    result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

    return result
end

function math.round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function DrawTxt(text, x, y)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.4)
    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        local dist = GetDistanceBetweenCoords(GetGameplayCamCoords(), x, y, z, 1)
        local scale = 1.8 * (1 / dist) * (1 / GetGameplayCamFov()) * 100

        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropShadow(0, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextEdge(4, 0, 0, 0, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

RegisterNetEvent('midp-admin:ChangeSkin')
AddEventHandler('midp-admin:ChangeSkin', function(model)
    local modelHash = GetHashKey(model)
    ESX.Streaming.RequestModel(modelHash, function()
        SetPlayerModel(PlayerId(), modelHash)
        SetPedRandomComponentVariation(PlayerPedId(), true)
        SetModelAsNoLongerNeeded(modelHash)
    end)
end)

RegisterNetEvent("midp-admin:ClonePed")
AddEventHandler('midp-admin:ClonePed', function(target)
    local ped = target
    local me = PlayerPedId()

    hat = GetPedPropIndex(ped, 0)
    hat_texture = GetPedPropTextureIndex(ped, 0)

    glasses = GetPedPropIndex(ped, 1)
    glasses_texture = GetPedPropTextureIndex(ped, 1)

    ear = GetPedPropIndex(ped, 2)
    ear_texture = GetPedPropTextureIndex(ped, 2)

    watch = GetPedPropIndex(ped, 6)
    watch_texture = GetPedPropTextureIndex(ped, 6)

    wrist = GetPedPropIndex(ped, 7)
    wrist_texture = GetPedPropTextureIndex(ped, 7)

    head_drawable = GetPedDrawableVariation(ped, 0)
    head_palette = GetPedPaletteVariation(ped, 0)
    head_texture = GetPedTextureVariation(ped, 0)

    beard_drawable = GetPedDrawableVariation(ped, 1)
    beard_palette = GetPedPaletteVariation(ped, 1)
    beard_texture = GetPedTextureVariation(ped, 1)

    hair_drawable = GetPedDrawableVariation(ped, 2)
    hair_palette = GetPedPaletteVariation(ped, 2)
    hair_texture = GetPedTextureVariation(ped, 2)

    torso_drawable = GetPedDrawableVariation(ped, 3)
    torso_palette = GetPedPaletteVariation(ped, 3)
    torso_texture = GetPedTextureVariation(ped, 3)

    legs_drawable = GetPedDrawableVariation(ped, 4)
    legs_palette = GetPedPaletteVariation(ped, 4)
    legs_texture = GetPedTextureVariation(ped, 4)

    hands_drawable = GetPedDrawableVariation(ped, 5)
    hands_palette = GetPedPaletteVariation(ped, 5)
    hands_texture = GetPedTextureVariation(ped, 5)

    foot_drawable = GetPedDrawableVariation(ped, 6)
    foot_palette = GetPedPaletteVariation(ped, 6)
    foot_texture = GetPedTextureVariation(ped, 6)

    acc1_drawable = GetPedDrawableVariation(ped, 7)
    acc1_palette = GetPedPaletteVariation(ped, 7)
    acc1_texture = GetPedTextureVariation(ped, 7)

    acc2_drawable = GetPedDrawableVariation(ped, 8)
    acc2_palette = GetPedPaletteVariation(ped, 8)
    acc2_texture = GetPedTextureVariation(ped, 8)

    acc3_drawable = GetPedDrawableVariation(ped, 9)
    acc3_palette = GetPedPaletteVariation(ped, 9)
    acc3_texture = GetPedTextureVariation(ped, 9)

    mask_drawable = GetPedDrawableVariation(ped, 10)
    mask_palette = GetPedPaletteVariation(ped, 10)
    mask_texture = GetPedTextureVariation(ped, 10)

    aux_drawable = GetPedDrawableVariation(ped, 11)
    aux_palette = GetPedPaletteVariation(ped, 11)   
    aux_texture = GetPedTextureVariation(ped, 11)

    SetPedPropIndex(me, 0, hat, hat_texture, 1)
    SetPedPropIndex(me, 1, glasses, glasses_texture, 1)
    SetPedPropIndex(me, 2, ear, ear_texture, 1)
    SetPedPropIndex(me, 6, watch, watch_texture, 1)
    SetPedPropIndex(me, 7, wrist, wrist_texture, 1)

    SetPedComponentVariation(me, 0, head_drawable, head_texture, head_palette)
    SetPedComponentVariation(me, 1, beard_drawable, beard_texture, beard_palette)
    SetPedComponentVariation(me, 2, hair_drawable, hair_texture, hair_palette)
    SetPedComponentVariation(me, 3, torso_drawable, torso_texture, torso_palette)
    SetPedComponentVariation(me, 4, legs_drawable, legs_texture, legs_palette)
    SetPedComponentVariation(me, 5, hands_drawable, hands_texture, hands_palette)
    SetPedComponentVariation(me, 6, foot_drawable, foot_texture, foot_palette)
    SetPedComponentVariation(me, 7, acc1_drawable, acc1_texture, acc1_palette)
    SetPedComponentVariation(me, 8, acc2_drawable, acc2_texture, acc2_palette)
    SetPedComponentVariation(me, 9, acc3_drawable, acc3_texture, acc3_palette)
    SetPedComponentVariation(me, 10, mask_drawable, mask_texture, mask_palette)
    SetPedComponentVariation(me, 11, aux_drawable, aux_texture, aux_palette)
end)

RegisterNetEvent('midp-admin:deleteObj')
AddEventHandler('midp-admin:deleteObj', function(radius)
        radius = tonumber(radius)
        if radius == 0 then 
            for obj in EnumerateObjects() do
                ESX.Game.DeleteObject(obj)
            end
        else

            pedPos = GetEntityCoords(PlayerPedId(), false)
            for obj in EnumerateObjects() do
                entPos = GetEntityCoords(obj, false)
                dist = Vdist2(entPos, pedPos)
                if dist < radius then
                    ESX.Game.DeleteObject(obj)
            end
        end
    end
end)

RegisterNetEvent('midp-admin:deletePeds')
AddEventHandler('midp-admin:deletePeds', function(radius)
    PedStatus = 0
    for ped in EnumeratePeds() do
        PedStatus = PedStatus + 1
        if not (IsPedAPlayer(ped))then
            RemoveAllPedWeapons(ped, true)
            DeleteEntity(ped)
        end
    end
end)

RegisterNetEvent('midp-admin:deleteVehicle')
AddEventHandler('midp-admin:deleteVehicle', function(radius)
    radius = tonumber(radius)
    if radius == 0 then 
        for vehicle in EnumerateVehicles() do
           SetEntityAsMissionEntity(GetVehiclePedIsIn(vehicle, true), 1, 1)
            DeleteEntity(GetVehiclePedIsIn(vehicle, true))
            SetEntityAsMissionEntity(vehicle, 1, 1)
            DeleteEntity(vehicle)
        end
    else
        local playerPed = PlayerPedId()
        radius = tonumber(radius) + 0.01
        local vehArea = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed), radius)
        for veh1, veh2 in ipairs(vehArea) do
            local ty = 0

            while not NetworkHasControlOfEntity(veh2) and ty < 50 and DoesEntityExist(veh2) do
                NetworkRequestControlOfEntity(veh2)
                ty = ty + 1
            end

            if DoesEntityExist(veh2) and NetworkHasControlOfEntity(veh2) then
                SetEntityAsMissionEntity(veh2, false, true)
                DeleteVehicle(veh2)
            end
        end
    end
end)

RegisterNetEvent('midp-admin:deleteVehiclee')
AddEventHandler('midp-admin:deleteVehiclee', function(x, y, z)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, true) then
        local veh = GetVehiclePedIsIn(ped, false)
        ESX.Game.DeleteVehicle(veh)
    end
end)

RegisterNetEvent('midp-admin:teleportUser')
AddEventHandler('midp-admin:teleportUser', function(x, y, z)
    local playerPed = PlayerPedId()
	SetEntityCoords(playerPed, x, y, z)
end)

RegisterNetEvent('midp-admin:RefreshPlayer')
AddEventHandler('midp-admin:RefreshPlayer', function()
    ClearPedTasksImmediately(PlayerPedId())
end)

RegisterNetEvent('midp-admin:spawnmacan')
AddEventHandler('midp-admin:spawnmacan', function()
    local mtlion = "A_C_MtLion"
    local co = GetEntityCoords(PlayerPedId())
    for i = 0, 5 do
        RequestModel(GetHashKey(mtlion))
        Citizen.Wait(50)
        if HasModelLoaded(GetHashKey(mtlion)) then
            local ped = CreatePed(21, GetHashKey(mtlion), co.x + math.random(-5, 5), co.y + math.random(-5, 5), co.z, 0, true, true)
            NetworkRegisterEntityAsNetworked(ped)
            if DoesEntityExist(ped) and not IsEntityDead(PlayerPedId()) then
                local ei = PedToNet(ped)
                NetworkSetNetworkIdDynamic(ei, false)
                SetNetworkIdCanMigrate(ei, true)
                SetNetworkIdExistsOnAllMachines(ei, true)
                Citizen.Wait(50)
                NetToPed(ei)
                TaskCombatPed(ped, PlayerPedId(), 0, 16)
            elseif IsEntityDead(PlayerPedId()) then
                TaskCombatHatedTargetsInArea(ped, co.x, co.y, co.z, 500)
            else
                Citizen.Wait(0)
            end
        end
    end
end)

RegisterNetEvent('midp-admin:spawnswat')
AddEventHandler('midp-admin:spawnswat', function()
    local bQ = "s_m_y_swat_01"
    local bR = "weapon_rpg"
    local w_npc = {
        [1] = "WEAPON_ASSAULTRIFLE",
        [2] = "weapon_rpg",
        [3] = "weapon_flaregun",
        [4] = "weapon_railgun",
    }
    for i = 0, 5 do
        local bK = GetEntityCoords(PlayerPedId())
        RequestModel(GetHashKey(bQ))
        Citizen.Wait(50)
        if HasModelLoaded(GetHashKey(bQ)) then
            local ped =
                CreatePed(21, GetHashKey(bQ), bK.x + math.random(-5, 5), bK.y + math.random(-5, 5), bK.z, 0, true, true) and
                CreatePed(21, GetHashKey(bQ), bK.x + math.random(-5, 5), bK.y + math.random(-5, 5), bK.z, 0, true, true)
            NetworkRegisterEntityAsNetworked(ped)
            if DoesEntityExist(ped) and not IsEntityDead(PlayerPedId()) then
                local ei = PedToNet(ped)
                NetworkSetNetworkIdDynamic(ei, false)
                SetNetworkIdCanMigrate(ei, true)
                SetNetworkIdExistsOnAllMachines(ei, true)
                Citizen.Wait(50)
                NetToPed(ei)
                GiveWeaponToPed(ped, GetHashKey(w_npc[math.random(4)]), 9999, 1, 1)
                SetEntityInvincible(ped, true)
                SetPedCanSwitchWeapon(ped, true)
                TaskCombatPed(ped, PlayerPedId(), 0, 16)
            elseif IsEntityDead(PlayerPedId()) then
                TaskCombatHatedTargetsInArea(ped, bK.x, bK.y, bK.z, 500)
            else
                Citizen.Wait(0)
            end
        end
    end
end)

RegisterNetEvent('midp-admin:changepedmenu', function()
	local input = lib.inputDialog('PED CHANGER', {'ID PLAYER:', 'NAMA PED:'})

	if not input then return end
	local idply = tonumber(input[1])
	local namaped = input[2]
	TriggerServerEvent('midp-admin:changeped', idply, namaped)
end)

RegisterCommand('gantiped', function()
	ESX.TriggerServerCallback("midp-admin:getadminRank", function(playerRank)
		if playerRank == "superadmin" then
			TriggerEvent("midp-admin:changepedmenu")
		else
			exports["midp-tasknotify"]:SendAlert("error", "Anda SIAPA YA?")
		end
	end)
end)

RegisterCommand("deleteped", function(source, args, raw)
	ESX.TriggerServerCallback("midp-admin:getadminRank", function(playerRank)
		if playerRank == "superadmin" then
			TriggerServerEvent("midp-admin:deleteped", args[1])
		else
			exports["midp-tasknotify"]:SendAlert("error", "Anda SIAPA YA?")
		end
	end)
end)

RegisterNetEvent('midp-admin:setPed')
AddEventHandler('midp-admin:setPed', function(modelpeda)
	local model = modelpeda
	if IsModelInCdimage(model) and IsModelValid(model) then
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(0)
	end
	SetPlayerModel(PlayerId(), model)
	SetModelAsNoLongerNeeded(model)
	end   
end)

RegisterNetEvent("midp-admin:loadSkin")
AddEventHandler("midp-admin:loadSkin", function()
	TriggerEvent('skinchanger:loadDefaultModel', 0, function()
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
			TriggerEvent('esx:restoreLoadout')
		end)
	end)
end)

RegisterNetEvent("textsent")
AddEventHandler('textsent', function(tPID, names2, names3, textmsg)
  TriggerEvent('chat:addMessage', {
    template = '<div class="chat-message-rep"><b>{0}</b> {1}</div>',
    args = { "ADMIN | " .. names3 .. " >> " .. names2 .. " : " , textmsg  }
  })

end)

RegisterNetEvent("textmsg")
AddEventHandler('textmsg', function(source, textmsg, names2, names3 )
  TriggerEvent('chat:addMessage', {
    template = '<div class="chat-message-rep"><b>{0}</b> {1}</div>',
    args = { "ADMIN | " .. names3 .. " >> " .. names2 .. " : ", textmsg }
  })
end)

local neons = true

function OpenVehicleControlsMenu()
    local elements = {
        {label = 'Extras', value = 'extras'},
        {label = 'Enable Neon', value = 'neons'},
        {label = 'Liveries', value = 'livery'},
    }	
    
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player,false)
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_controls', {
                title    = 'ALAN.GG',
                align    = 'LEFT',
                elements = elements
            }, function(data, menu)
                if data.current.value == 'extras' then
                    OpenVehicleExtrasMenu()
                elseif data.current.value == 'livery' then
                    LiveriesMenu()
                elseif data.current.value == 'neons' then
                    if neons then
                        neons = false
                        DisableVehicleNeonLights(vehicle, false, false, false)
                    elseif not neons then
                        neons = true
                        DisableVehicleNeonLights(vehicle, true, false, false)
                    end	
                end			
            end, function(data, menu)
                menu.close()
            end)
    end
    
    function OpenVehicleExtrasMenu()
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped)
        local elements = {}
        for x = 0, 20 do
            if DoesExtraExist(vehicle, x) then
                if IsVehicleExtraTurnedOn(vehicle, x) then
                    table.insert(elements, {label = 'EXTRA '..x.." <FONT color='green'>ON</FONT>", value = x})
                elseif not IsVehicleExtraTurnedOn(vehicle, x) then
                    table.insert(elements, {label = 'EXTRA '..x.." <FONT color='red'>OFF</FONT>", value = x})
                end
            end
        end
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_extras', {
                title    = 'Extras',
                align    = 'LEFT',
                elements = elements
            }, function(data, menu)
                for x = 0, 20 do
                    if data.current.value == x then
                        if IsVehicleExtraTurnedOn(vehicle, x) then
                            SetVehicleExtra(vehicle, x, 1)
                            ESX.UI.Menu.CloseAll()
                            OpenVehicleExtrasMenu()
                        elseif not IsVehicleExtraTurnedOn(vehicle, x) then
                            SetVehicleExtra(vehicle, x, 0)
                            ESX.UI.Menu.CloseAll()
                            OpenVehicleExtrasMenu()
                        end
                    end
                end
            end, function(data, menu)
                menu.close()
            end)
    
    end
    
    function LiveriesMenu()
    
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped)
        local elements = {}
    
        for x = 0, GetVehicleLiveryCount(vehicle) do
            table.insert(elements, {label = 'Livery '..x, value = x})
        end
    
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_liveries', {
                title    = 'Liveries',
                align    = 'LEFT',
                elements = elements
            }, function(data, menu)
                for x = 0, GetVehicleLiveryCount(vehicle) do
                    if data.current.value == x then
    
                        SetVehicleLivery(vehicle, x)
    
                    end
                end
            end, function(data, menu)
                menu.close()
        end, function(data, menu)
            SetVehicleLivery(vehicle, data.current.value)
        end)
    
    end

TriggerEvent('chat:removeSuggestion', '/gantiped')
TriggerEvent('chat:removeSuggestion', '/deleteped')