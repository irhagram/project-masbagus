ESX = exports["es_extended"]:getSharedObject()
local shops, savedOutfits = {}, {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
    ESX.PlayerLoaded = false
    ESX.PlayerData = {}
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    closeMenu()
end)

RegisterNetEvent('fivem-appearance:skinCommand')
AddEventHandler('fivem-appearance:skinCommand', function()
	local config = {
		ped = true,
		headBlend = true,
		faceFeatures = true,
		headOverlays = true,
		components = true,
		props = true
	}
	exports['fivem-appearance']:startPlayerCustomization(function (appearance)
		if (appearance) then
			TriggerServerEvent('fivem-appearance:save', appearance)
			ESX.SetPlayerData('ped', PlayerPedId())
		else
			ESX.SetPlayerData('ped', PlayerPedId())
		end
	end, config)
end)

RegisterNetEvent('fivem-appearance:setOutfit')
AddEventHandler('fivem-appearance:setOutfit', function(data)
	local pedModel = data.ped
	local pedComponents = data.components
	local pedProps = data.props
	local playerPed = PlayerPedId()
	local currentPedModel = exports['fivem-appearance']:getPedModel(playerPed)
	if currentPedModel ~= pedModel then
    	exports['fivem-appearance']:setPlayerModel(pedModel)
		Wait(500)
		playerPed = PlayerPedId()
		exports['fivem-appearance']:setPedComponents(playerPed, pedComponents)
		exports['fivem-appearance']:setPedProps(playerPed, pedProps)
		local appearance = exports['fivem-appearance']:getPedAppearance(playerPed)
		TriggerServerEvent('fivem-appearance:save', appearance)
		ESX.SetPlayerData('ped', PlayerPedId())
	else
		exports['fivem-appearance']:setPedComponents(playerPed, pedComponents)
		exports['fivem-appearance']:setPedProps(playerPed, pedProps)
		local appearance = exports['fivem-appearance']:getPedAppearance(playerPed)
		TriggerServerEvent('fivem-appearance:save', appearance)
		ESX.SetPlayerData('ped', PlayerPedId())
	end
end)

RegisterNetEvent('fivem-appearance:saveOutfit', function()
    local input = lib.inputDialog(Strings.save_outfit_title, {Strings.save_outfit_info})
    if input then
        local name = input[1]
        local playerPed = PlayerPedId()
        local pedModel = exports['fivem-appearance']:getPedModel(playerPed)
        local pedComponents = exports['fivem-appearance']:getPedComponents(playerPed)
        local pedProps = exports['fivem-appearance']:getPedProps(playerPed)
        TriggerServerEvent('fivem-appearance:saveOutfit', name, pedModel, pedComponents, pedProps)
    end
end)

AddEventHandler('fivem-appearance:clothingMenu', function(price)
    openShop('clothing_menu', 10000)
end)

AddEventHandler('fivem-appearance:tokobarber', function(price)
    openShop('barber', 8000)
end)

AddEventHandler('fivem-appearance:tattoshop', function(price)
    openShop('tattoo', 15000)
end)

RegisterNetEvent('fivem-appearance:deleteOutfitMenu', function()
    local outfits = lib.callback.await('fivem-appearance:getOutfits', 100)
    local Options = {}
    if outfits then
        for i=1, #outfits do
            Options[#Options + 1] = {
                title = outfits[i].name,
                serverEvent = 'fivem-appearance:deleteOutfit',
                args = outfits[i].id 
            }
        end
    else
    end
    lib.registerContext({
        id = 'outfit_delete_menu',
        title = Strings.delete_outfits_title,
        options = Options
    })
    lib.showContext('outfit_delete_menu')
end)

RegisterNetEvent('fivem-appearance:browseOutfits', function()
    local outfits = lib.callback.await('fivem-appearance:getOutfits', 100)
    local Options = {}
    if outfits then 
        for i=1, #outfits do 
            Options[#Options + 1] = {
                title = outfits[i].name,
                event = 'fivem-appearance:setOutfit',
                args = {
                    ped = outfits[i].ped,
                    components = outfits[i].components,
                    props = outfits[i].props
                }
            }
        end
    else
    end
    lib.registerContext({
        id = 'outfit_menu',
        title = Strings.browse_outfits_title,
        options = Options
    })
    lib.showContext('outfit_menu')
end)

RegisterNetEvent('fivem-appearance:clothingShop', function(price)
	lib.registerContext({
		id = 'clothing_menu',
		title = Strings.clothing_shop_title,
		options = {
			{
				title = Strings.change_clothing_title,
				description = Strings.change_clothing_desc,
				arrow = false,
				event = 'fivem-appearance:clothingMenu',
                args = price
			},
			{
				title = Strings.browse_outfits_title,
				description = Strings.browse_outfits_desc,
				arrow = false,
				event = 'fivem-appearance:browseOutfits'
			},
			{
				title = Strings.save_outfit_title,
				description = Strings.save_outfit_desc,
				arrow = false,
				event = 'fivem-appearance:saveOutfit'
			},
			{
				title = Strings.delete_outfit_title,
				description = Strings.delete_outfit_desc,
				arrow = false,
				event = 'fivem-appearance:deleteOutfitMenu'
			},
		}
	})
	lib.showContext('clothing_menu')
end)

CreateThread(function()
    for i=1, #Config.ClothingShops do
        if Config.ClothingShops[i].blip.enabled then
            createBlip(Config.ClothingShops[i].coords, Config.ClothingShops[i].blip.sprite, Config.ClothingShops[i].blip.color, Config.ClothingShops[i].blip.string, Config.ClothingShops[i].blip.scale)
        end
    end
    for i=1, #Config.BarberShops do
        if Config.BarberShops[i].blip.enabled then
            createBlip(Config.BarberShops[i].coords, Config.BarberShops[i].blip.sprite, Config.BarberShops[i].blip.color, Config.BarberShops[i].blip.string, Config.BarberShops[i].blip.scale)
        end
    end
    for i=1, #Config.TattooShops do
        if Config.TattooShops[i].blip.enabled then
            createBlip(Config.TattooShops[i].coords, Config.TattooShops[i].blip.sprite, Config.TattooShops[i].blip.color, Config.TattooShops[i].blip.string, Config.TattooShops[i].blip.scale)
        end
    end
end)

RegisterCommand('reloadchar', function()
    ExecuteCommand('e jtrynewc2')
    Wait(3000)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(appearance)
        exports['fivem-appearance']:setPlayerAppearance(appearance)
    end)
end)

RegisterNetEvent('dl-radial:loadSkin')
AddEventHandler('dl-radial:loadSkin', function(ped, skin)
    ExecuteCommand('e jtrynewc2')
    Wait(3000)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(appearance)
        exports['fivem-appearance']:setPlayerAppearance(appearance)
    end)
end)

--cd_multicharacter compatibility
RegisterNetEvent('skinchanger:loadSkin2')
AddEventHandler('skinchanger:loadSkin2', function(ped, skin)
    if not skin.model then skin.model = 'mp_m_freemode_01' end
    	exports['fivem-appearance']:setPedAppearance(ped, skin)
    if cb ~= nil then
        cb()
    end
end)

-- esx_skin/skinchanger compatibility(The best I/we can)
AddEventHandler('skinchanger:getSkin', function(cb)
    while not ESX.PlayerLoaded do
        Wait(1000)
    end
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(appearance)
        cb(appearance)
    end)
end)

RegisterNetEvent('skinchanger:loadSkin')
AddEventHandler('skinchanger:loadSkin', function(skin, cb)
	if not skin.model then skin.model = 'mp_m_freemode_01' end
	exports['fivem-appearance']:setPlayerAppearance(skin)
	if cb ~= nil then
		cb()
	end
end)

AddEventHandler('skinchanger:loadDefaultModel', function(loadMale, cb)
    if loadMale then
        TriggerEvent('skinchanger:loadSkin',Config.DefaultSkin)
    else
        local skin = Config.DefaultSkin
        skin.model = 'mp_f_freemode_01'
        TriggerEvent('skinchanger:loadSkin',skin)
    end
end)

RegisterNetEvent('skinchanger:loadClothes')
AddEventHandler('skinchanger:loadClothes', function(skin, clothes)
    local playerPed = PlayerPedId()
    local outfit = convertClothes(clothes)
    exports['fivem-appearance']:setPedComponents(playerPed, outfit.Components)
    exports['fivem-appearance']:setPedProps(playerPed, outfit.Props)
end)

RegisterNetEvent('esx_skin:openSaveableMenu')
AddEventHandler('esx_skin:openSaveableMenu', function(submitCb, cancelCb)
	local config = {
		ped = true,
		headBlend = true,
		faceFeatures = true,
		headOverlays = true,
		components = true,
		props = true
	}
	exports['fivem-appearance']:startPlayerCustomization(function (appearance)
		if (appearance) then
			TriggerServerEvent('fivem-appearance:save', appearance)
			ESX.SetPlayerData('ped', PlayerPedId())
			if submitCb then submitCb() end
		else
			if cancelCb then cancelCb() end
			ESX.SetPlayerData('ped', PlayerPedId())
		end
	end, config)
end)

local name = 0
local coordsbarber = {
    { x = -816.35, y = -181.63, z = 37.57 },
    { x = 139.51, y = -1709.74, z = 29.29 },
    { x = -1282.27, y = -1120.39, z = 6.99 }, 
    { x = 1934.27, y = 3731.67, z = 32.84 },
    { x = 1211.51, y = -475.76, z = 66.21 },
    { x = -35.86, y = -151.22, z = 57.08 },
    { x = -280.37, y = 6225.97, z = 31.7 },
	{ x = 138.53, y = -1710.01, z = 29.3 },
}

local coorbaju = {
    { x = 72.3, y = -1399.1, z = 28.4 }, 
    { x = -708.7, y = -152.1, z = 37.42 },
    { x = -165.1, y = -302.4, z = 38.6 },
    { x = 428.7, y = -800.1, z = 28.5 },
    { x = -829.4, y = -1073.7, z = 10.3 },
    { x = -1449.1, y = -238.3, z = 48.8},  
    { x = 11.6, y = 6514.2, z = 30.9 },
    { x = 122.9, y = -222.2, z = 53.5 },
    { x = 1696.3, y = 4829.3, z = 41.1 },
    { x = 618.1, y = 2759.6, z = 41.1 },
    { x = 1190.6, y = 2713.4, z = 37.2 },
    { x = -1193.4, y = -772.3, z = 16.3 },
    { x = -3172.5, y = 1048.1, z = 19.9 },
    { x = -1108.4, y = 2708.9, z = 18.1 },
}

local coordstattoss = {
    { x = 1322.6, y = -1651.9, z = 51.2 },
    { x = -1153.6, y = -1425.6, z = 4.9 },
    { x = -3170.0, y = 1075.0, z = 20.8 }, 
    { x = 322.1, y = 180.4, z = 103.5 },
    { x = 1864.6, y = 3747.7, z = 33.0 },
    { x = -293.7, y = 6200.0, z = 31.4 },
}

Citizen.CreateThread(function()
    for k,v in pairs(coordsbarber) do
        name = name + 1
        exports["ox_target"]:AddBoxZone(name, vector3(v.x, v.y, v.z), 2.0, 2.0, {
            name = name,
            heading = 91,
            debugPoly = false,
            minZ = v.z - 1.0,
            maxZ = v.z + 1.5
        }, {
            options = {
                {
                    event = "fivem-appearance:tokobarber",
                    icon = "fas fa-cut",
                    label = "Pangkas Rambut",
                },
            },
            distance = 2.5
        })
    end

    for k,v in pairs(coorbaju) do
        name = name + 1
        exports["ox_target"]:AddBoxZone(name, vector3(v.x, v.y, v.z), 4.0, 4.0, {
            name = name,
            heading = 91,
            debugPoly = false,
            minZ = v.z - 1.0,
            maxZ = v.z + 1.5
        }, {
            options = {
                {
                    event = "fivem-appearance:clothingMenu",
                    icon = "fas fa-tshirt",
                    label = "SESUAIKAN BAJU",
                      
                },
                {
                    event = "fivem-appearance:browseOutfits",
                    icon = "fas fa-theater-masks",
                    label = "LIST BAJU",
                    
                },
                {
                    event = "fivem-appearance:saveOutfit",
                    icon = "fas fa-tshirt",
                    label = "SIMPAN BAJU",
                    
                },
                {
                    event = "fivem-appearance:deleteOutfitMenu",
                    icon = "fas fa-tshirt",
                    label = "BUANG BAJU",
                    
                },
            },
            distance = 4.0
        })
    end

    for k,v in pairs(coordstattoss) do
        name = name + 1
        exports["ox_target"]:AddBoxZone(name, vector3(v.x, v.y, v.z), 2.0, 2.0, {
            name = name,
            heading = 91,
            debugPoly = false,
            minZ = v.z - 1.0,
            maxZ = v.z + 1.5
        }, {
            options = {
                {
                    event = "fivem-appearance:tattoshop",
                    icon = "fas fa-cut",
                    label = "Buat Tatto",
                },
            },
            distance = 2.5
        })
    end
end)