IsInside = false
ClosestHouse = nil
HasHouseKey = false

local isOwned = false
local cam = nil
local viewCam = false
local FrontCam = false
local stashLocation = nil
local outfitLocation = nil
local logoutLocation = nil
local OwnedHouseBlips = {}
local UnownedHouseBlips = {}
local CurrentDoorBell = 0
local rangDoorbell = nil
local houseObj = {}
local POIOffsets = nil
local entering = false
local data = nil
local CurrentHouse = nil
local RamsDone = 0
local keyholderMenu = {}
local keyholderOptions = {}
local fetchingHouseKeys = false

-- zone check
local stashTargetBoxID = 'stashTarget'
local stashTargetBox = nil
local isInsideStashTarget = false

local outfitsTargetBoxID = 'outfitsTarget'
local outfitsTargetBox = nil
local isInsideOutfitsTarget = false

-- Functions

local function showEntranceHeaderMenu()
    local headerMenu = {}
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'admin' then
        isOwned = true
    end

    if not isOwned then
        headerMenu[#headerMenu+1] = {
            header = Lang:t("menu.view_house"),
            params = {
                event = "midp-property:client:ViewHouse",
                args = {}
            }
        }
    else
        if isOwned and HasHouseKey then
            headerMenu[#headerMenu+1] = {
                header = Lang:t("menu.enter_house"),
                params = {
                    event = "midp-property:client:EnterHouse",
                    args = {}
                }
            }
           --[[ headerMenu[#headerMenu+1] = {
                header = Lang:t("menu.give_house_key"),
                params = {
                    event = "midp-property:client:giveHouseKey",
                    args = {}
                }
            }]]
        elseif isOwned and not HasHouseKey then
            headerMenu[#headerMenu+1] = {
                header = Lang:t("menu.ring_door"),
                params = {
                    event = "midp-property:client:RequestRing",
                    args = {}
                }
            }
            headerMenu[#headerMenu+1] = {
                header = Lang:t("menu.enter_unlocked_house"),
                params = {
                    event = "midp-property:client:EnterHouse",
                    args = {}
                }
            }
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
                headerMenu[#headerMenu+1] = {
                    header = Lang:t("menu.lock_door_police"),
                    params = {
                        event = "midp-property:client:ResetHouse",
                        args = {}
                    }
                }
            end
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'admin' then
                headerMenu[#headerMenu+1] = {
                    header = Lang:t("menu.give_house_key"),
                    params = {
                        event = "midp-property:client:giveHouseKey",
                        args = {}
                    }
                }
            end
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'admin' then
                headerMenu[#headerMenu+1] = {
                    header = "Masuk Rumah (ADMIN)",
                    params = {
                        event = "midp-property:client:ResetHouse",
                        args = {}
                    }
                }
            end
        else
            headerMenu = {}
        end
    end

    headerMenu[#headerMenu + 1] = {
        header = Lang:t('menu.close_menu'),
        params = {
            event = 'menu:client:closeMenu'
        }
    }

    if headerMenu and next(headerMenu) then
        exports['menu']:openMenu(headerMenu)
    end
end

local function showExitHeaderMenu()
    local headerMenu = {}
    headerMenu[#headerMenu+1] = {
        header = Lang:t("menu.exit_property"),
        params = {
            event = "midp-property:client:ExitOwnedHouse",
            args = {}
        }
    }
    if isOwned then
        headerMenu[#headerMenu+1] = {
            header = Lang:t("menu.front_camera"),
            params = {
                event = "midp-property:client:FrontDoorCam",
                args = {}
            }
        }
        headerMenu[#headerMenu+1] = {
            header = Lang:t("menu.open_door"),
            params = {
                event = "midp-property:client:AnswerDoorbell",
                args = {}
            }
        }
    end

    headerMenu[#headerMenu + 1] = {
        header = Lang:t('menu.close_menu'),
        params = {
          event = 'menu:client:closeMenu'
        }
    }

    if headerMenu and next(headerMenu) then
        exports['menu']:openMenu(headerMenu)
    end
end

local function RegisterStashTarget()
    if not stashLocation then
        return
    end

    stashTargetBox = BoxZone:Create(vector3(stashLocation.x, stashLocation.y, stashLocation.z), 1.5, 1.5, {
        name = stashTargetBoxID,
        heading = 0.0,
        minZ = stashLocation.z - 1.0,
        maxZ = stashLocation.z + 1.0,
        debugPoly = false
    })

    stashTargetBox:onPlayerInOut(function (isPointInside)
        if isPointInside and not entering and isOwned then
            exports['midp-tasknotify']:Open(Lang:t("target.open_stash"), 'darkblue', 'left')
        else
            exports['midp-tasknotify']:Close()
        end

        isInsideStashTarget = isPointInside
    end)
end

local function RegisterOutfitsTarget()
    if not outfitLocation then
        return
    end

    outfitsTargetBox = BoxZone:Create(vector3(outfitLocation.x, outfitLocation.y, outfitLocation.z), 1.5, 1.5, {
        name = outfitsTargetBoxID,
        heading = 0.0,
        minZ = outfitLocation.z - 1.0,
        maxZ = outfitLocation.z + 1.0,
        debugPoly = false
    })

    outfitsTargetBox:onPlayerInOut(function (isPointInside)
        if isPointInside and not entering and isOwned then
            exports['midp-tasknotify']:Open(Lang:t("target.outfits"), 'darkblue', 'left')
        else
            exports['midp-tasknotify']:Close()
        end

        isInsideOutfitsTarget = isPointInside
    end)
end

local function RegisterHouseExitZone(id)
    if not Config.Houses[id] then
        return
    end

    local boxName = 'houseExit_' .. id
    local boxData = Config.Targets[boxName] or {}
    if boxData and boxData.created then
        return
    end

    if not POIOffsets then
        return
    end

    local house = Config.Houses[id]
    local coords = vector3(house.coords['enter'].x + POIOffsets.exit.x, house.coords['enter'].y + POIOffsets.exit.y, house.coords['enter'].z  - Config.MinZOffset + POIOffsets.exit.z + 1.0)

    local zone = BoxZone:Create(coords, 2, 1, {
        name = boxName,
        heading = 0.0,
        debugPoly = false,
        minZ = coords.z - 2.0,
        maxZ = coords.z + 1.0,
    })

    zone:onPlayerInOut(function (isPointInside)
        if isPointInside then
            showExitHeaderMenu()
        else
            CloseMenuFull()
        end
    end)

    Config.Targets[boxName] = {created = true, zone = zone}
end

local function RegisterHouseEntranceZone(id, house)
    local coords = vector3(house.coords['enter'].x, house.coords['enter'].y, house.coords['enter'].z)
    local boxName = 'houseEntrance_' .. id
    local boxData = Config.Targets[boxName] or {}

    if boxData and boxData.created then
        return
    end

    local zone = BoxZone:Create(coords, 2, 1, {
        name = boxName,
        heading = house.coords['enter'].h,
        debugPoly = false,
        minZ = house.coords['enter'].z - 1.0,
        maxZ = house.coords['enter'].z + 1.0,
    })

    zone:onPlayerInOut(function (isPointInside)
        if isPointInside then
            showEntranceHeaderMenu()
        else
            CloseMenuFull()
        end
    end)

    Config.Targets[boxName] = {created = true, zone = zone}
end

local function DeleteBoxTarget(box)
    if not box then
        return
    end

    box:destroy()
end

local function DeleteHousesTargets()
    if Config.Targets and next(Config.Targets) then
        for id, target in pairs(Config.Targets) do
            target.zone:destroy()
            Config.Targets[id] = nil
        end
    end
end

local function SetHousesEntranceTargets()
    if Config.Houses and next(Config.Houses) then
        for id, house in pairs(Config.Houses) do
            if house and house.coords and house.coords['enter'] then
                RegisterHouseEntranceZone(id, house)
            end
        end
    end
end

RegisterNetEvent('midp-property:client:setHouseConfig', function(houseConfig)
    Config.Houses = houseConfig
    DeleteHousesTargets()
    SetHousesEntranceTargets()
end)

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function openHouseAnim()
    loadAnimDict("anim@heists@keycard@")
    TaskPlayAnim( ESX.PlayerData.ped, "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Wait(400)
    ClearPedTasks(ESX.PlayerData.ped)
end

local function openContract(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "toggle",
        status = bool,
    })
end

local function GetClosestPlayer()
    local closestPlayers = ESX.Game.GetClosestPlayer()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(ESX.PlayerData.ped)
    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = #(pos - coords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end
	return closestPlayer, closestDistance
end

local function DoRamAnimation(bool)
    local ped = ESX.PlayerData.ped
    local dict = "missheistfbi3b_ig7"
    local anim = "lift_fibagent_loop"
    if bool then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(1)
        end
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 1, -1, false, false, false)
    else
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(1)
        end
        TaskPlayAnim(ped, dict, "exit", 8.0, 8.0, -1, 1, -1, false, false, false)
    end
end

local function setViewCam(coords, h, yaw)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z, yaw, 0.00, h, 80.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    viewCam = true
end

local function InstructionButton(ControlButton)
    ScaleformMovieMethodAddParamPlayerNameString(ControlButton)
end

local function InstructionButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

local function CreateInstuctionScaleform(scaleform)
    scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    InstructionButton(GetControlInstructionalButton(1, 194, true))
    InstructionButtonMessage(Lang:t("info.exit_camera"))
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()
    return scaleform
end

local function FrontDoorCam(coords)
    DoScreenFadeOut(150)
    Wait(500)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z + 0.5, 0.0, 0.00, coords.h - 180, 80.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    TriggerEvent('weathersync:client:EnableSync')
    FrontCam = true
    FreezeEntityPosition(ESX.PlayerData.ped, true)
    Wait(500)
    DoScreenFadeIn(150)
    SendNUIMessage({
        type = "frontcam",
        toggle = true,
        label = Config.Houses[ClosestHouse].adress
    })

    CreateThread(function()
        while FrontCam do
            local instructions = CreateInstuctionScaleform("instructional_buttons")
            DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
            SetTimecycleModifier("scanline_cam_cheap")
            SetTimecycleModifierStrength(1.0)
            if IsControlJustPressed(1, 194) then -- Backspace
                DoScreenFadeOut(150)
                SendNUIMessage({
                    type = "frontcam",
                    toggle = false,
                })
                Wait(500)
                RenderScriptCams(false, true, 500, true, true)
                FreezeEntityPosition(ESX.PlayerData.ped, false)
                SetCamActive(cam, false)
                DestroyCam(cam, true)
                ClearTimecycleModifier("scanline_cam_cheap")
                cam = nil
                FrontCam = false
                Wait(500)
                DoScreenFadeIn(150)
                TriggerEvent('weathersync:client:DisableSync')
            end

            local getCameraRot = GetCamRot(cam, 2)

            -- ROTATE UP
            if IsControlPressed(0, 32) then -- W
                if getCameraRot.x <= 0.0 then
                    SetCamRot(cam, getCameraRot.x + 0.7, 0.0, getCameraRot.z, 2)
                end
            end

            -- ROTATE DOWN
            if IsControlPressed(0, 33) then -- S
                if getCameraRot.x >= -50.0 then
                    SetCamRot(cam, getCameraRot.x - 0.7, 0.0, getCameraRot.z, 2)
                end
            end

            -- ROTATE LEFT
            if IsControlPressed(0, 34) then -- A
                SetCamRot(cam, getCameraRot.x, 0.0, getCameraRot.z + 0.7, 2)
            end

            -- ROTATE RIGHT
            if IsControlPressed(0, 35) then -- D
                SetCamRot(cam, getCameraRot.x, 0.0, getCameraRot.z - 0.7, 2)
            end

            Wait(1)
        end
    end)
end

local function disableViewCam()
    if viewCam then
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        viewCam = false
    end
end

local function SetClosestHouse()
    local pos = GetEntityCoords(ESX.PlayerData.ped, true)
    local current = nil
    local dist = nil
    if not IsInside then
        for id, _ in pairs(Config.Houses) do
            local distcheck = #(pos - vector3(Config.Houses[id].coords.enter.x, Config.Houses[id].coords.enter.y, Config.Houses[id].coords.enter.z))
            if current ~= nil then
                if distcheck < dist then
                    current = id
                    dist = distcheck
                end
            else
                dist = distcheck
                current = id
            end
        end
        ClosestHouse = current
        if ClosestHouse ~= nil and tonumber(dist) < 30 then
            ESX.TriggerServerCallback('midp-property:server:ProximityKO', function(key, owned)
                HasHouseKey = key
                isOwned = owned
            end, ClosestHouse)
        end
    end
end

local function setHouseLocations()
    if ClosestHouse ~= nil then
        ESX.TriggerServerCallback('midp-property:server:getHouseLocations', function(result)
            if result ~= nil then
                if result.stash ~= nil then
                    stashLocation = json.decode(result.stash)
                    RegisterStashTarget()
                end
                if result.outfit ~= nil then
                    outfitLocation = json.decode(result.outfit)
                    RegisterOutfitsTarget()
                end
            end
        end, ClosestHouse)
    end
end

local function UnloadDecorations()
	if ObjectList ~= nil then
		for _, v in pairs(ObjectList) do
			if DoesEntityExist(v.object) then
				DeleteObject(v.object)
			end
		end
	end
end

local function LoadDecorations(house)
	if Config.Houses[house].decorations == nil or next(Config.Houses[house].decorations) == nil then
		ESX.TriggerServerCallback('midp-property:server:getHouseDecorations', function(result)
			Config.Houses[house].decorations = result
			if Config.Houses[house].decorations ~= nil then
				ObjectList = {}
				for k, _ in pairs(Config.Houses[house].decorations) do
					if Config.Houses[house].decorations[k] ~= nil then
						if Config.Houses[house].decorations[k].object ~= nil then
							if DoesEntityExist(Config.Houses[house].decorations[k].object) then
								DeleteObject(Config.Houses[house].decorations[k].object)
							end
						end
						local modelHash = GetHashKey(Config.Houses[house].decorations[k].hashname)
						RequestModel(modelHash)
						while not HasModelLoaded(modelHash) do
							Wait(10)
						end
						local decorateObject = CreateObject(modelHash, Config.Houses[house].decorations[k].x, Config.Houses[house].decorations[k].y, Config.Houses[house].decorations[k].z, false, false, false)
						FreezeEntityPosition(decorateObject, true)
						SetEntityCoordsNoOffset(decorateObject, Config.Houses[house].decorations[k].x, Config.Houses[house].decorations[k].y, Config.Houses[house].decorations[k].z)
						SetEntityRotation(decorateObject, Config.Houses[house].decorations[k].rotx, Config.Houses[house].decorations[k].roty, Config.Houses[house].decorations[k].rotz)
						ObjectList[Config.Houses[house].decorations[k].objectId] = {hashname = Config.Houses[house].decorations[k].hashname, x = Config.Houses[house].decorations[k].x, y = Config.Houses[house].decorations[k].y, z = Config.Houses[house].decorations[k].z, rotx = Config.Houses[house].decorations[k].rotx, roty = Config.Houses[house].decorations[k].roty, rotz = Config.Houses[house].decorations[k].rotz, object = decorateObject, objectId = Config.Houses[house].decorations[k].objectId}
					end
				end
			end
		end, house)
	elseif Config.Houses[house].decorations ~= nil then
		ObjectList = {}
		for k, _ in pairs(Config.Houses[house].decorations) do
			if Config.Houses[house].decorations[k] ~= nil then
				if Config.Houses[house].decorations[k].object ~= nil then
					if DoesEntityExist(Config.Houses[house].decorations[k].object) then
						DeleteObject(Config.Houses[house].decorations[k].object)
					end
				end
				local modelHash = GetHashKey(Config.Houses[house].decorations[k].hashname)
				RequestModel(modelHash)
				while not HasModelLoaded(modelHash) do
					Wait(10)
				end
				local decorateObject = CreateObject(modelHash, Config.Houses[house].decorations[k].x, Config.Houses[house].decorations[k].y, Config.Houses[house].decorations[k].z, false, false, false)
				FreezeEntityPosition(decorateObject, true)
				SetEntityCoordsNoOffset(decorateObject, Config.Houses[house].decorations[k].x, Config.Houses[house].decorations[k].y, Config.Houses[house].decorations[k].z)
				Config.Houses[house].decorations[k].object = decorateObject
				SetEntityRotation(decorateObject, Config.Houses[house].decorations[k].rotx, Config.Houses[house].decorations[k].roty, Config.Houses[house].decorations[k].rotz)
				ObjectList[Config.Houses[house].decorations[k].objectId] = {hashname = Config.Houses[house].decorations[k].hashname, x = Config.Houses[house].decorations[k].x, y = Config.Houses[house].decorations[k].y, z = Config.Houses[house].decorations[k].z, rotx = Config.Houses[house].decorations[k].rotx, roty = Config.Houses[house].decorations[k].roty, rotz = Config.Houses[house].decorations[k].rotz, object = decorateObject, objectId = Config.Houses[house].decorations[k].objectId}
			end
		end
	end
end

local function CheckDistance(target, distance)
    local ped = ESX.PlayerData.ped
    local pos = GetEntityCoords(ped)

    return #(pos - target) <= distance
end

-- GUI Functions

function CloseMenuFull()
    exports['menu']:closeMenu()
end

local function RemoveHouseKey(citizenData)
    TriggerServerEvent('midp-property:server:removeHouseKey', ClosestHouse, citizenData)
    CloseMenuFull()
end

local function getKeyHolders()
    if fetchingHouseKeys then return end
    fetchingHouseKeys = true

    local p = promise.new()
    ESX.TriggerServerCallback('midp-property:server:getHouseKeyHolders', function(holders)
        p:resolve(holders)
    end,ClosestHouse)

    return Citizen.Await(p)
end

function HouseKeysMenu()
    local holders = getKeyHolders()
    fetchingHouseKeys = false

    if holders == nil or next(holders) == nil then
        exports['midp-tasknotify']:SendAlert('error', Lang:t("error.no_key_holders"))
        CloseMenuFull()
    else
        keyholderMenu = {}

        for k, _ in pairs(holders) do
            keyholderMenu[#keyholderMenu+1] = {
                header = holders[k].firstname .. " " .. holders[k].lastname,
                params = {
                    event = "midp-property:client:OpenClientOptions",
                    args = {
                        citizenData = holders[k]
                    }
                }
            }
        end
        exports['menu']:openMenu(keyholderMenu)
    end

end

local function optionMenu(citizenData)
    keyholderOptions = {
        {
            header = Lang:t("menu.remove_key"),
            params = {
                event = "midp-property:client:RevokeKey",
                args = {
                    citizenData = citizenData
                }
            }
        },
        {
            header = Lang:t("menu.back"),
            params = {
                event = "midp-property:client:removeHouseKey",
                args = {}
            }
        },
    }

    exports['menu']:openMenu(keyholderOptions)
end

-- Shell Configuration
local function getDataForHouseTier(house, coords)
    if Config.Houses[house].tier == 1 then
        return exports['midp-property']:CreateFurniMotelModern(coords)
    elseif Config.Houses[house].tier == 2 then
        return exports['midp-property']:CreateFranklinAunt(coords)
    elseif Config.Houses[house].tier == 3 then
        return exports['midp-property']:CreateGarageMed(coords)
    elseif Config.Houses[house].tier == 4 then
        return exports['midp-property']:CreateLesterShell(coords)
    elseif Config.Houses[house].tier == 5 then
        return exports['midp-property']:CreateMichael(coords)
    elseif Config.Houses[house].tier == 6 then
        return exports['midp-property']:CreateOffice1(coords)
    elseif Config.Houses[house].tier == 7 then
        return exports['midp-property']:CreateRanchShell(coords)
    elseif Config.Houses[house].tier == 8 then
        return exports['midp-property']:CreateTrevorsShell(coords)
    elseif Config.Houses[house].tier == 9 then
        return exports['midp-property']:CreateApartmentShell(coords)
    elseif Config.Houses[house].tier == 10 then
        return exports['midp-property']:CreateTier1House(coords)
    elseif Config.Houses[house].tier == 11 then
        return exports['midp-property']:CreateWarehouse1(coords)
    elseif Config.Houses[house].tier == 12 then
        return exports['midp-property']:CreateFurniMotelStandard(coords)
    elseif Config.Houses[house].tier == 13 then
        return exports['midp-property']:CreateHighend1(coords)
    elseif Config.Houses[house].tier == 14 then
        return exports['midp-property']:CreateHighendV2(coords)
    elseif Config.Houses[house].tier == 15 then
        return exports['midp-property']:CreateGarageHigh(coords)
    elseif Config.Houses[house].tier == 16 then
        return exports['midp-property']:CreateHighend2(coords)
    elseif Config.Houses[house].tier == 17 then
        return exports['midp-property']:CreateHighend3(coords)
    elseif Config.Houses[house].tier == 18 then
        return exports['midp-property']:CreateMedium3(coords)
    else
        exports['midp-tasknotify']:SendAlert('error', Lang:t("error.invalid_tier"))
    end
end

local function enterOwnedHouse(house)
    CurrentHouse = house
    ClosestHouse = house
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "doorenter", 0.25)
    openHouseAnim()
    IsInside = true
    Wait(250)
    local coords = { x = Config.Houses[house].coords.enter.x, y = Config.Houses[house].coords.enter.y, z= Config.Houses[house].coords.enter.z - Config.MinZOffset}
    LoadDecorations(house)
    data = getDataForHouseTier(house, coords)
    Wait(100)
    houseObj = data[1]
    POIOffsets = data[2]
    entering = true
    Wait(500)
    TriggerServerEvent('midp-property:server:SetInsideMeta', house, true)
    TriggerEvent('weathersync:client:DisableSync')
    TriggerEvent('weed:client:getHousePlants', house)
    entering = false
    setHouseLocations()
    CloseMenuFull()

    Wait(5000)

    RegisterHouseExitZone(house)
end

local function LeaveHouse(house)
    if not FrontCam then
        IsInside = false
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "doorexit", 0.25)
        openHouseAnim()
        Wait(250)
        DoScreenFadeOut(250)
        Wait(500)
        exports['midp-property']:DespawnInterior(houseObj, function()
            UnloadDecorations()
            TriggerEvent('weathersync:client:EnableSync')
            Wait(250)
            DoScreenFadeIn(250)
            SetEntityCoords(ESX.PlayerData.ped, Config.Houses[CurrentHouse].coords.enter.x, Config.Houses[CurrentHouse].coords.enter.y, Config.Houses[CurrentHouse].coords.enter.z)
            SetEntityHeading(ESX.PlayerData.ped, Config.Houses[CurrentHouse].coords.enter.h)
            TriggerEvent('weed:client:leaveHouse')
            TriggerServerEvent('midp-property:server:SetInsideMeta', house, false)
            CurrentHouse = nil
            DeleteBoxTarget(stashTargetBox)
            isInsideStashTarget = false
            DeleteBoxTarget(outfitsTargetBox)
            isInsideOutfitsTarget = false
            DeleteBoxTarget(Config.Targets['houseExit_' .. house].zone)
            Config.Targets['houseExit_' .. house] = nil
        end)

        exports.ox_inventory:setStashTarget(nil)
    end
end

local function enterNonOwnedHouse(house)
    CurrentHouse = house
    ClosestHouse = house
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "doorenter", 0.25)
    openHouseAnim()
    IsInside = true
    Wait(250)
    local coords = { x = Config.Houses[ClosestHouse].coords.enter.x, y = Config.Houses[ClosestHouse].coords.enter.y, z= Config.Houses[ClosestHouse].coords.enter.z - Config.MinZOffset}
    LoadDecorations(house)
    data = getDataForHouseTier(house, coords)
    houseObj = data[1]
    POIOffsets = data[2]
    entering = true
    Wait(500)
    TriggerServerEvent('midp-property:server:SetInsideMeta', house, true)
    TriggerEvent('weathersync:client:DisableSync')
    TriggerEvent('weed:client:getHousePlants', house)
    entering = false
    InOwnedHouse = true
    setHouseLocations()
    CloseMenuFull()

    RegisterHouseExitZone(house)
end

local function isNearHouses()
    local ped = ESX.PlayerData.ped
    local pos = GetEntityCoords(ped)

    if ClosestHouse ~= nil then
        local dist = #(pos - vector3(Config.Houses[ClosestHouse].coords.enter.x, Config.Houses[ClosestHouse].coords.enter.y, Config.Houses[ClosestHouse].coords.enter.z))
        if dist <= 1.5 then
            if HasHouseKey then
                return true
            end
        end
    end
end

exports('isNearHouses', isNearHouses)

-- Events

RegisterNetEvent('midp-property:server:sethousedecorations', function(house, decorations)
	Config.Houses[house].decorations = decorations
	if IsInside and ClosestHouse == house then
		LoadDecorations(house)
	end
end)

RegisterNetEvent('midp-property:client:sellHouse', function()
    if ClosestHouse and HasHouseKey then
        TriggerServerEvent('midp-property:server:viewHouse', ClosestHouse)
    end
end)

RegisterNetEvent('midp-property:client:EnterHouse', function()
    local ped = ESX.PlayerData.ped
    local pos = GetEntityCoords(ped)

    if ClosestHouse ~= nil then
        local dist = #(pos - vector3(Config.Houses[ClosestHouse].coords.enter.x, Config.Houses[ClosestHouse].coords.enter.y, Config.Houses[ClosestHouse].coords.enter.z))
        if dist <= 1.5 then
            if HasHouseKey then
                enterOwnedHouse(ClosestHouse)
            else
                if not Config.Houses[ClosestHouse].locked then
                    enterNonOwnedHouse(ClosestHouse)
                end
            end
        end
    end
end)

RegisterNetEvent('midp-property:client:RequestRing', function()
    if ClosestHouse ~= nil then
        TriggerServerEvent('midp-property:server:RingDoor', ClosestHouse)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true

    Wait(200)
    TriggerServerEvent('midp-property:server:setHouses')
    SetClosestHouse()
    TriggerEvent('midp-property:client:setupHouseBlips')

    if Config.UnownedBlips then 
        TriggerEvent('midp-property:client:setupHouseBlips2') 
    end

    Wait(100)

    TriggerServerEvent("midp-property:server:setHouses")
end)

RegisterNetEvent('midp-property:client:lockHouse', function(bool, house)
    Config.Houses[house].locked = bool
end)

RegisterNetEvent('midp-property:client:createHouses', function(price, tier)
    local pos = GetEntityCoords(ESX.PlayerData.ped)
    local heading = GetEntityHeading(ESX.PlayerData.ped)
	local s1, _ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street = GetStreetNameFromHashKey(s1)
    local coords = {
        enter 	= { x = pos.x, y = pos.y, z = pos.z, h = heading},
        cam 	= { x = pos.x, y = pos.y, z = pos.z, h = heading, yaw = -10.00},
    }
    street = street:gsub("%-", " ")
    TriggerServerEvent('midp-property:server:addNewHouse', street, coords, price, tier)
    if Config.UnownedBlips then TriggerServerEvent('midp-property:server:createBlip') end
end)

RegisterNetEvent('midp-property:client:addGarage', function()
    if ClosestHouse ~= nil then
        local pos = GetEntityCoords(ESX.PlayerData.ped)
        local heading = GetEntityHeading(ESX.PlayerData.ped)
        local coords = {
            x = pos.x,
            y = pos.y,
            z = pos.z,
            h = heading,
        }
        TriggerServerEvent('midp-property:server:addGarage', ClosestHouse, coords)
    else
        exports['midp-tasknotify']:SendAlert('error', Lang:t("error.no_house"))
    end
end)

RegisterNetEvent('midp-property:client:toggleDoorlock', function()
    local pos = GetEntityCoords(ESX.PlayerData.ped)
    local dist = #(pos - vector3(Config.Houses[ClosestHouse].coords.enter.x, Config.Houses[ClosestHouse].coords.enter.y, Config.Houses[ClosestHouse].coords.enter.z))
    if dist <= 1.5 then
        if HasHouseKey then
            if Config.Houses[ClosestHouse].locked then
                TriggerServerEvent('midp-property:server:lockHouse', false, ClosestHouse)
                exports['midp-tasknotify']:SendAlert('success', Lang:t("success.unlocked"))
            else
                TriggerServerEvent('midp-property:server:lockHouse', true, ClosestHouse)
                exports['midp-tasknotify']:SendAlert('error', Lang:t("error.locked"))
            end
        else
            exports['midp-tasknotify']:SendAlert('error', Lang:t("error.no_keys"))
        end
    else
        exports['midp-tasknotify']:SendAlert('error', Lang:t("error.no_door"))
    end
end)

RegisterNetEvent('midp-property:client:RingDoor', function(player, house)
    if ClosestHouse == house and IsInside then
        CurrentDoorBell = player
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "doorbell", 0.1)
        exports['midp-tasknotify']:SendAlert('inform', Lang:t("info.door_ringing"))
    end
end)

RegisterNetEvent('midp-property:client:giveHouseKey', function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 and ClosestHouse ~= nil then
        local playerId = GetPlayerServerId(player)
        local pedpos = GetEntityCoords(ESX.PlayerData.ped)
        local housedist = #(pedpos - vector3(Config.Houses[ClosestHouse].coords.enter.x, Config.Houses[ClosestHouse].coords.enter.y, Config.Houses[ClosestHouse].coords.enter.z))
        if housedist < 10 then
            TriggerServerEvent('midp-property:server:giveHouseKey', playerId, ClosestHouse)
        else
            exports['midp-tasknotify']:SendAlert('error', Lang:t("error.no_door"))
        end
    elseif ClosestHouse == nil then
        exports['midp-tasknotify']:SendAlert('error', Lang:t("error.no_house"))
    else
        exports['midp-tasknotify']:SendAlert('error', Lang:t("error.no_one_near"))
    end
end)

RegisterNetEvent('midp-property:client:removeHouseKey', function()
    if ClosestHouse ~= nil then
        local pedpos = GetEntityCoords(ESX.PlayerData.ped)
        local housedist = #(pedpos - vector3(Config.Houses[ClosestHouse].coords.enter.x, Config.Houses[ClosestHouse].coords.enter.y, Config.Houses[ClosestHouse].coords.enter.z))
        if housedist <= 5 then
            ESX.TriggerServerCallback('midp-property:server:getHouseOwner', function(result)
                --ESX.GetPlayerData().license
                if ESX.GetPlayerData().citizenid == result then
                    HouseKeysMenu()
                else
                    exports['midp-tasknotify']:SendAlert('error', Lang:t("error.not_owner"))
                end
            end, ClosestHouse)
        else
            exports['midp-tasknotify']:SendAlert('error', Lang:t("error.no_door"))
        end
    else
        exports['midp-tasknotify']:SendAlert('error', Lang:t("error.no_door"))
    end
end)

RegisterNetEvent('midp-property:client:RevokeKey', function(cData)
    RemoveHouseKey(cData.citizenData)
end)

RegisterNetEvent('midp-property:client:refreshHouse', function()
    Wait(100)
    SetClosestHouse()
end)

AddEventHandler('playerSpawned', function()
	ESX.TriggerServerCallback('midp-property:client:LastLocationHouse', function(house)
		if house and not entering then
			if house ~= '' then
                local door = vector3(Config.Houses[house].coords.enter.x , Config.Houses[house].coords.enter.y, Config.Houses[house].coords.enter.z)
                Wait(500)
                SetEntityCoords(PlayerPedId(), door)
                TriggerServerEvent('midp-property:server:SetInsideMeta', house, false)
			end
		end
	end)
end)

RegisterNetEvent('midp-property:client:SpawnInApartment', function(house)
    local pos = GetEntityCoords(ESX.PlayerData.ped)
    if rangDoorbell ~= nil then
        if #(pos - vector3(Config.Houses[house].coords.enter.x, Config.Houses[house].coords.enter.y, Config.Houses[house].coords.enter.z)) > 5 then
            return
        end
    end
    ClosestHouse = house
    enterNonOwnedHouse(house)
end)

RegisterNetEvent('midp-property:client:enterOwnedHouse', function(house)
    ESX.GetPlayerData(function(PlayerData)
        enterOwnedHouse(house)
	end)
end)

RegisterNetEvent('midp-property:client:LastLocationHouse', function(houseId)
    ESX.GetPlayerData(function(PlayerData)
        enterOwnedHouse(houseId)
	end)
end)

RegisterNetEvent('midp-property:client:setupHouseBlips', function() -- Setup owned on load
    CreateThread(function()
        Wait(2000)
        ESX.TriggerServerCallback('midp-property:server:getOwnedHouses', function(ownedHouses)
            if ownedHouses then
                for k, _ in pairs(ownedHouses) do
                    local house = Config.Houses[ownedHouses[k]]
                    local HouseBlip = AddBlipForCoord(house.coords.enter.x, house.coords.enter.y, house.coords.enter.z)
                    SetBlipSprite (HouseBlip, 40)
                    SetBlipDisplay(HouseBlip, 4)
                    SetBlipScale  (HouseBlip, 0.65)
                    SetBlipAsShortRange(HouseBlip, true)
                    SetBlipColour(HouseBlip, 4)
                    AddTextEntry('OwnedHouse', house.adress)
                    BeginTextCommandSetBlipName('OwnedHouse')
                    EndTextCommandSetBlipName(HouseBlip)
                    OwnedHouseBlips[#OwnedHouseBlips+1] = HouseBlip
                end
            end
        end)
    end)
end)

RegisterNetEvent('midp-property:client:setupHouseBlips2', function() -- Setup unowned on load
    for _, v in pairs(Config.Houses) do
        if not v.owned then
            local HouseBlip2 = AddBlipForCoord(v.coords.enter.x, v.coords.enter.y, v.coords.enter.z)
            SetBlipSprite (HouseBlip2, 40)
            SetBlipDisplay(HouseBlip2, 4)
            SetBlipScale  (HouseBlip2, 0.65)
            SetBlipAsShortRange(HouseBlip2, true)
            SetBlipColour(HouseBlip2, 3)
            AddTextEntry('UnownedHouse', Lang:t("info.house_for_sale"))
            BeginTextCommandSetBlipName('UnownedHouse')
            EndTextCommandSetBlipName(HouseBlip2)
            UnownedHouseBlips[#UnownedHouseBlips+1] = HouseBlip2
        end
    end
end)

RegisterNetEvent('midp-property:client:createBlip', function(coords) -- Create unowned on command
    local NewHouseBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite (NewHouseBlip, 40)
    SetBlipDisplay(NewHouseBlip, 4)
    SetBlipScale  (NewHouseBlip, 0.65)
    SetBlipAsShortRange(NewHouseBlip, true)
    SetBlipColour(NewHouseBlip, 3)
    AddTextEntry('NewHouseBlip', Lang:t("info.house_for_sale"))
    BeginTextCommandSetBlipName('NewHouseBlip')
    EndTextCommandSetBlipName(NewHouseBlip)
    UnownedHouseBlips[#UnownedHouseBlips+1] = NewHouseBlip
end)

RegisterNetEvent('midp-property:client:refreshBlips', function() -- Refresh unowned on buy
    for _, v in pairs(UnownedHouseBlips) do RemoveBlip(v) end
    Wait(250)
    TriggerEvent('midp-property:client:setupHouseBlips2')
    DeleteHousesTargets()
    SetHousesEntranceTargets()
end)

RegisterNetEvent('midp-property:client:SetClosestHouse', function()
    SetClosestHouse()
end)

RegisterNetEvent('midp-property:client:viewHouse', function(houseprice, brokerfee, bankfee, taxes, firstname, lastname)
    setViewCam(Config.Houses[ClosestHouse].coords.cam, Config.Houses[ClosestHouse].coords.cam.h, Config.Houses[ClosestHouse].coords.yaw)
    Wait(500)
    openContract(true)
    SendNUIMessage({
        type = "setupContract",
        firstname = firstname,
        lastname = lastname,
        street = Config.Houses[ClosestHouse].adress,
        houseprice = houseprice,
        brokerfee = brokerfee,
        bankfee = bankfee,
        taxes = taxes,
        totalprice = (houseprice + brokerfee + bankfee + taxes)
    })
end)

RegisterCommand('setlokasi', function(source, args)
	TriggerEvent('midp-property:client:setLocation', args[1])
end)

RegisterNetEvent('midp-property:client:setLocation', function(type)
    local ped = ESX.PlayerData.ped
    local pos = GetEntityCoords(ped)
    local coords = {x = pos.x, y = pos.y, z = pos.z}
    if IsInside then
        if HasHouseKey then
            if type == 'setstash' then
                TriggerServerEvent('midp-property:server:setLocation', coords, ClosestHouse, 1)
            elseif type == 'setoutift' then
                TriggerServerEvent('midp-property:server:setLocation', coords, ClosestHouse, 2)
            elseif type == 'setlogout' then
                TriggerServerEvent('midp-property:server:setLocation', coords, ClosestHouse, 3)
            end
        else
            exports['midp-tasknotify']:SendAlert('error', Lang:t("error.not_owner"))
        end
    else
        exports['midp-tasknotify']:SendAlert('error', Lang:t("error.not_in_house"))
    end
end)

RegisterNetEvent('midp-property:client:refreshLocations', function(house, location, type)
    if ClosestHouse == house then
        if IsInside then
            if type == 1 then
                stashLocation = json.decode(location)
                DeleteBoxTarget(stashTargetBox)
                isInsideStashTarget = false
                RegisterStashTarget()
            elseif type == 2 then
                outfitLocation = json.decode(location)
                DeleteBoxTarget(outfitsTargetBox)
                isInsideOutfitsTarget = false
                RegisterOutfitsTarget()
            end
        end
    end
end)

RegisterNetEvent('midp-property:client:HomeInvasion', function()
    local ped = ESX.PlayerData.ped
    local pos = GetEntityCoords(ped)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if ClosestHouse ~= nil then
        ESX.TriggerServerCallback('police:server:IsPoliceForcePresent', function(IsPresent)
            if IsPresent then
                local dist = #(pos - vector3(Config.Houses[ClosestHouse].coords.enter.x, Config.Houses[ClosestHouse].coords.enter.y, Config.Houses[ClosestHouse].coords.enter.z))
                if Config.Houses[ClosestHouse].IsRaming == nil then
                    Config.Houses[ClosestHouse].IsRaming = false
                end
                if dist < 1 then
                    if Config.Houses[ClosestHouse].locked then
                        if not Config.Houses[ClosestHouse].IsRaming then
                            DoRamAnimation(true)
                            Skillbar.Start({
                                duration = math.random(5000, 10000),
                                pos = math.random(10, 30),
                                width = math.random(10, 20),
                            }, function()
                                if RamsDone + 1 >= Config.RamsNeeded then
                                    TriggerServerEvent('midp-property:server:lockHouse', false, ClosestHouse)
                                    exports['midp-tasknotify']:SendAlert('success', Lang:t("success.home_invasion"))
                                    TriggerServerEvent('midp-property:server:SetHouseRammed', true, ClosestHouse)
                                    TriggerServerEvent('midp-property:server:SetRamState', false, ClosestHouse)
                                    DoRamAnimation(false)
                                else
                                    DoRamAnimation(true)
                                    Skillbar.Repeat({
                                        duration = math.random(500, 1000),
                                        pos = math.random(10, 30),
                                        width = math.random(5, 12),
                                    })
                                    RamsDone = RamsDone + 1
                                end
                            end, function()
                                RamsDone = 0
                                TriggerServerEvent('midp-property:server:SetRamState', false, ClosestHouse)
                                exports['midp-tasknotify']:SendAlert('error', Lang:t("error.failed_invasion"))
                                DoRamAnimation(false)
                            end)
                            TriggerServerEvent('midp-property:server:SetRamState', true, ClosestHouse)
                        else
                            exports['midp-tasknotify']:SendAlert('error', Lang:t("error.inprogress_invasion"))
                        end
                    else
                        exports['midp-tasknotify']:SendAlert('error', Lang:t("error.already_open"))
                    end
                else
                    exports['midp-tasknotify']:SendAlert('error', Lang:t("error.no_house"))
                end
            else
                exports['midp-tasknotify']:SendAlert('error', Lang:t("error.no_police"))
            end
        end)
    else
        exports['midp-tasknotify']:SendAlert('error', Lang:t("error.no_house"))
    end
end)

RegisterNetEvent('midp-property:client:SetRamState', function(bool, house)
    Config.Houses[house].IsRaming = bool
    DeleteHousesTargets()
    SetHousesEntranceTargets()
end)

RegisterNetEvent('midp-property:client:SetHouseRammed', function(bool, house)
    Config.Houses[house].IsRammed = bool
    DeleteHousesTargets()
    SetHousesEntranceTargets()
end)

RegisterNetEvent('midp-property:client:ResetHouse', function()
    if ClosestHouse ~= nil then
        if Config.Houses[ClosestHouse].IsRammed == nil then
            Config.Houses[ClosestHouse].IsRammed = false
            TriggerServerEvent('midp-property:server:SetHouseRammed', false, ClosestHouse)
            TriggerServerEvent('midp-property:server:SetRamState', false, ClosestHouse)
        end
        if Config.Houses[ClosestHouse].IsRammed then
            openHouseAnim()
            TriggerServerEvent('midp-property:server:SetHouseRammed', false, ClosestHouse)
            TriggerServerEvent('midp-property:server:SetRamState', false, ClosestHouse)
            TriggerServerEvent('midp-property:server:lockHouse', true, ClosestHouse)
            RamsDone = 0
            exports['midp-tasknotify']:SendAlert('success', Lang:t("success.lock_invasion"))
        else
            exports['midp-tasknotify']:SendAlert('error', Lang:t("error.no_invasion"))
        end
    end
end)

RegisterNetEvent('midp-property:client:ExitOwnedHouse', function()
    local door = vector3(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z)
    if CheckDistance(door, 1.5) then
        LeaveHouse(CurrentHouse)
    end
end)

RegisterNetEvent('midp-property:client:FrontDoorCam', function()
    local door = vector3(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z)
    if CheckDistance(door, 1.5) then
        FrontDoorCam(Config.Houses[CurrentHouse].coords.enter)
    end
end)

RegisterNetEvent('midp-property:client:AnswerDoorbell', function()
    if not CurrentDoorBell or CurrentDoorBell == 0 then
        exports['midp-tasknotify']:SendAlert('error', Lang:t('error.nobody_at_door'))
        return
    end
    local door = vector3(Config.Houses[CurrentHouse].coords.enter.x + POIOffsets.exit.x, Config.Houses[CurrentHouse].coords.enter.y + POIOffsets.exit.y, Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset + POIOffsets.exit.z)
    if CheckDistance(door, 1.5) and CurrentDoorBell ~= 0 then
        TriggerServerEvent("midp-property:server:OpenDoor", CurrentDoorBell, ClosestHouse)
        CurrentDoorBell = 0
    end
end)

RegisterNetEvent('midp-property:client:OpenStash', function()
    local stashLoc = vector3(stashLocation.x, stashLocation.y, stashLocation.z)
    if CheckDistance(stashLoc, 1.5) then
        exports.ox_inventory:setStashTarget(CurrentHouse)
        ExecuteCommand("inv2")
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "StashOpen", 0.4)
        exports.ox_inventory:setStashTarget(nil)
    end
end)

RegisterNetEvent('midp-property:client:ChangeOutfit', function()
    local outfitLoc = vector3(outfitLocation.x, outfitLocation.y, outfitLocation.z)
    if CheckDistance(outfitLoc, 1.5) then
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "Clothes1", 0.4)
        TriggerEvent('fivem-appearance:browseOutfits')
    end
end)

RegisterNetEvent('midp-property:client:ViewHouse', function()
    local houseCoords = vector3(Config.Houses[ClosestHouse].coords.enter.x, Config.Houses[ClosestHouse].coords.enter.y, Config.Houses[ClosestHouse].coords.enter.z)
    if CheckDistance(houseCoords, 1.5) then
        TriggerServerEvent('midp-property:server:viewHouse', ClosestHouse)
    end
end)

RegisterNetEvent('midp-property:client:KeyholderOptions', function(cData)
    optionMenu(cData.citizenData)
end)

RegisterNetEvent('midp-property:client:RefreshHouseTargets', function ()
    DeleteHousesTargets()
    SetHousesEntranceTargets()
end)

-- NUI Callbacks

RegisterNUICallback('HasEnoughMoney', function(cData, cb)
    ESX.TriggerServerCallback('midp-property:server:HasEnoughMoney', function(_)
        cb('ok')
    end, cData.objectData)
end)

RegisterNUICallback('buy', function(_, cb)
    ESX.TriggerServerCallback('midp-property:server:checkmax', function(limit)
        if limit >= 2 then
            exports['midp-tasknotify']:SendAlert('error', Lang:t('error.max_buy'))
        else
            openContract(false)
            disableViewCam()
            Config.Houses[ClosestHouse].owner = true
            if Config.UnownedBlips then TriggerEvent('midp-property:client:refreshBlips') end
            TriggerServerEvent('midp-property:server:buyHouse', ClosestHouse)
            cb("ok")
        end
    end)
end)

RegisterNUICallback('exit', function(_, cb)
    openContract(false)
    disableViewCam()
    cb("ok")
end)

-- Threads

CreateThread(function ()
    local wait = 500

    TriggerServerEvent('midp-property:server:setHouses')
    TriggerEvent('midp-property:client:setupHouseBlips')
    if Config.UnownedBlips then
        TriggerEvent('midp-property:client:setupHouseBlips2')
    end
    Wait(wait)

    TriggerServerEvent("midp-property:server:setHouses")

    while true do
        wait = 5000

        if not IsInside then
            SetClosestHouse()
        end

        if IsInside then
            wait = 1000
            if isInsideStashTarget then
                wait = 0
                if IsControlJustPressed(0, 38) then
                    TriggerEvent('midp-property:client:OpenStash')
                    exports['midp-tasknotify']:Close()
                end
            end

            if isInsideOutfitsTarget then
                wait = 0
                if IsControlJustPressed(0, 38) then
                    TriggerEvent('midp-property:client:ChangeOutfit')
                    exports['midp-tasknotify']:Close()
                end
            end
        end
        Wait(wait)
    end
end)

RegisterCommand('getoffset', function()
    local coords = GetEntityCoords(ESX.PlayerData.ped)
    local houseCoords = vector3(
        Config.Houses[CurrentHouse].coords.enter.x,
        Config.Houses[CurrentHouse].coords.enter.y,
        Config.Houses[CurrentHouse].coords.enter.z - Config.MinZOffset
    )
    if IsInside then
        local xdist = houseCoords.x - coords.x
        local ydist = houseCoords.y - coords.y
        local zdist = houseCoords.z - coords.z
        print('X: '..xdist)
        print('Y: '..ydist)
        print('Z: '..zdist)
    end
end)

local function getInRumahCOK()
    if IsInside then
        if HasHouseKey then
            return true
        end
    end
end

exports('getInRumahCOK', getInRumahCOK)