local houseowneridentifier = {}
local houseownercid = {}
local housekeyholders = {}
local housesLoaded = false
-- Threads

CreateThread(function()
    local HouseGarages = {}
    local result = MySQL.query.await('SELECT * FROM houselocations', {})
    if result[1] then
        for _, v in pairs(result) do
            local owned = false
            if tonumber(v.owned) == 1 then
                owned = true
            end

            local garage = json.decode(v.garage) or {}
            Config.Houses[v.name] = {
                coords = json.decode(v.coords),
                owned = owned,
                price = v.price,
                locked = true,
                adress = v.label,
                tier = v.tier,
                garage = garage,
                decorations = {}
            }

            HouseGarages[v.name] = {
                label = v.label,
                takeVehicle = garage
            }
        end
    end

    TriggerClientEvent("garage:client:houseGarageConfig", -1, HouseGarages)
    TriggerClientEvent("alan-property:client:setHouseConfig", -1, Config.Houses)
end)

ESX.RegisterServerCallback('alan-property:server:loadgarage', function(source, cb)
    local HouseGarages = {}
    local result = MySQL.query.await('SELECT * FROM houselocations', {})
    if result[1] then
        for _, v in pairs(result) do
            local owned = false
            if tonumber(v.owned) == 1 then
                owned = true
            end

            local garage = json.decode(v.garage) or {}
            Config.Houses[v.name] = {
                coords = json.decode(v.coords),
                owned = owned,
                price = v.price,
                locked = true,
                adress = v.label,
                tier = v.tier,
                garage = garage,
                decorations = {}
            }

            HouseGarages[v.name] = {
                label = v.label,
                takeVehicle = garage
            }
        end

        cb(HouseGarages)
    end
    
    TriggerClientEvent("garage:client:houseGarageConfig", -1, HouseGarages)
    TriggerClientEvent("alan-property:client:setHouseConfig", -1, Config.Houses)
end)

CreateThread(function()
    while true do
        if not housesLoaded then
            MySQL.query('SELECT * FROM player_houses', {}, function(houses)
                if houses then
                    for _, house in pairs(houses) do
                        houseowneridentifier[house.house] = house.identifier
                        --houseownercid[house.house] = house.identifier
                        housekeyholders[house.house] = json.decode(house.keyholders)
                    end
                end
            end)
            housesLoaded = true
        end
        Wait(7)
    end
end)

-- Commands

ESX.RegisterCommand({'decorate'}, 'user', function(xPlayer, args, showError)
    xPlayer.triggerEvent('alan-property:client:decorate')
  end, false)

ESX.RegisterCommand({'addgarage'}, 'user', function(xPlayer, args, showError)
    xPlayer.triggerEvent('alan-property:client:addGarage')
end, false)

ESX.RegisterCommand({'ring'}, 'user', function(xPlayer, args, showError)
    xPlayer.triggerEvent('alan-property:client:RequestRing')
end, false)

ESX.RegisterCommand({'addhouse'}, 'admin', function(xPlayer, args, showError)
    local price = tonumber(args.price)
    local tier = tonumber(args.tier)

    xPlayer.triggerEvent('alan-property:client:createHouses', price, tier)
end, false, {
    help = 'Create House', 
    arguments = {
        {
            name = 'price', 
            help = 'price', 
            type = 'any'
        }, {
            name = 'tier', 
            help = 'tier', 
            type = 'any'
        }
    }
})

-- Functions

local function hasKey(identifier, house)
    if houseowneridentifier[house] then
        if houseowneridentifier[house] == identifier then
            return true
        else
            if housekeyholders[house] then
                for i = 1, #housekeyholders[house], 1 do
                    if housekeyholders[house][i] == identifier then
                        return true
                    end
                end
            end
        end
    end
    return false
end

exports('hasKey', hasKey)

local function GetHouseStreetCount(street)
    local count = 1
    local query = '%' .. street .. '%'
    local result = MySQL.query.await('SELECT * FROM houselocations WHERE name LIKE ?', {query})
    if result[1] then
        for _ = 1, #result, 1 do
            count = count + 1
        end
    end
    return count
end

local function isHouseOwned(house)
    local result = MySQL.query.await('SELECT owned FROM houselocations WHERE name = ?', {house})
    if result[1] then
        if result[1].owned == 1 then
            return true
        end
    end
    return false
end

local function escape_sqli(source)
    local replacements = {
        ['"'] = '\\"',
        ["'"] = "\\'"
    }
    return source:gsub("['\"]", replacements)
end

-- Events

RegisterNetEvent('alan-property:server:setHouses', function()
    local src = source
    TriggerClientEvent("alan-property:client:setHouseConfig", src, Config.Houses)
end)

RegisterNetEvent('alan-property:server:createBlip', function()
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    TriggerClientEvent("alan-property:client:createBlip", -1, coords)
end)

RegisterNetEvent('alan-property:server:addNewHouse', function(street, coords, price, tier)
    local src = source
    street = street:gsub("%'", "")
    price = tonumber(price)
    tier = tonumber(tier)
    local houseCount = GetHouseStreetCount(street)
    local name = street:lower() .. tostring(houseCount)
    local label = street .. " " .. tostring(houseCount)
    MySQL.insert('INSERT INTO houselocations (name, label, coords, owned, price, tier) VALUES (?, ?, ?, ?, ?, ?)',
        {name, label, json.encode(coords), 0, price, tier})
    Config.Houses[name] = {
        coords = coords,
        owned = false,
        price = price,
        locked = true,
        adress = label,
        tier = tier,
        garage = {},
        decorations = {}
    }
    TriggerClientEvent("alan-property:client:setHouseConfig", -1, Config.Houses)
    TriggerClientEvent('alan-tasknotify:client:SendAlert', src, { type = 'inform', text = Lang:t("info.added_house", {value = label}), length = 5000 })
end)

RegisterNetEvent('alan-property:server:addGarage', function(house, coords)
    local src = source
    MySQL.update('UPDATE houselocations SET garage = ? WHERE name = ?', {json.encode(coords), house})
    local garageInfo = {
        label = Config.Houses[house].adress,
        takeVehicle = coords
    }
    TriggerClientEvent("garage:client:addHouseGarage", -1, house, garageInfo)
    TriggerClientEvent('alan-tasknotify:client:SendAlert', src, { type = 'inform', text = Lang:t("info.added_garage", {value = garageInfo.label}), length = 5000 })
end)

RegisterNetEvent('alan-property:server:viewHouse', function(house)
    local src = source
    local pData = ESX.GetPlayerFromId(src)
    local houseprice = Config.Houses[house].price
    local brokerfee = (houseprice / 100 * 5)
    local bankfee = (houseprice / 100 * 10)
    local taxes = (houseprice / 100 * 6)

    TriggerClientEvent('alan-property:client:viewHouse', src, houseprice, brokerfee, bankfee, taxes, pData.firstname, pData.lastname)
end)

RegisterNetEvent('alan-property:server:buyHouse', function(house)
    local src = source
    local pData = ESX.GetPlayerFromId(src)
    local price = Config.Houses[house].price
    local HousePrice = math.ceil(price * 1.21)
    local moneyBalance = pData.getMoney()

    local isOwned = isHouseOwned(house)
    if isOwned then
        TriggerClientEvent('alan-tasknotify:client:SendAlert', src, { type = 'inform', text = Lang:t("error.already_owned"), length = 5000 })
        CancelEvent()
        return
    end

    if (moneyBalance >= HousePrice) then
        --houseowneridentifier[house] = pData.license
        houseowneridentifier[house] = pData.identifier
        housekeyholders[house] = {
            [1] = pData.identifier
        }
        MySQL.insert('INSERT INTO player_houses (house, identifier, keyholders) VALUES (?, ?, ?)',{house, pData.identifier, json.encode(housekeyholders[house])})
        MySQL.update('UPDATE houselocations SET owned = ? WHERE name = ?', {1, house})
        TriggerClientEvent('alan-property:client:SetClosestHouse', src)
        TriggerClientEvent('alan-property:client:RefreshHouseTargets', src)
        pData.removeMoney(HousePrice) -- 21% Extra house costs
        TriggerClientEvent('alan-tasknotify:client:SendAlert', src, { type = 'inform', text = Lang:t("success.house_purchased"), length = 5000 })
    else
        TriggerClientEvent('alan-tasknotify:client:SendAlert', src, { type = 'error', text = Lang:t("error.not_enough_money"), length = 5000 })
    end
end)

RegisterNetEvent('alan-property:server:lockHouse', function(bool, house)
    TriggerClientEvent('alan-property:client:lockHouse', -1, bool, house)
end)

RegisterNetEvent('alan-property:server:SetRamState', function(bool, house)
    Config.Houses[house].IsRaming = bool
    TriggerClientEvent('alan-property:server:SetRamState', -1, bool, house)
end)

RegisterNetEvent('alan-property:server:giveKey', function(house, target)
    local pData = ESX.GetPlayerFromId(target)
    housekeyholders[house][#housekeyholders[house]+1] = pData.identifier
    MySQL.update('UPDATE player_houses SET keyholders = ? WHERE house = ?',
        {json.encode(housekeyholders[house]), house})
end)

RegisterNetEvent('alan-property:server:removeHouseKey', function(house, license)
    local src = source
    local newHolders = {}
    if housekeyholders[house] then
        for k, _ in pairs(housekeyholders[house]) do
            if housekeyholders[house][k] ~= license.identifier then
                newHolders[#newHolders+1] = housekeyholders[house][k]
            end
        end
    end
    housekeyholders[house] = newHolders
    TriggerClientEvent('alan-tasknotify:client:SendAlert', src, { type = 'error', text = Lang:t("error.remove_key_from", {firstname = license.firstname, lastname = license.lastname}), length = 5000 })
    MySQL.update('UPDATE player_houses SET keyholders = ? WHERE house = ?', {json.encode(housekeyholders[house]), house})
end)

RegisterNetEvent('alan-property:server:OpenDoor', function(target, house)
    local OtherPlayer = ESX.GetPlayerFromId(target)
    if OtherPlayer then
        TriggerClientEvent('alan-property:client:SpawnInApartment', OtherPlayer.source, house)
    end
end)

RegisterNetEvent('alan-property:server:RingDoor', function(house)
    local src = source
    TriggerClientEvent('alan-property:client:RingDoor', -1, src, house)
end)

RegisterNetEvent('alan-property:server:savedecorations', function(house, decorations)
    MySQL.update('UPDATE player_houses SET decorations = ? WHERE house = ?', {json.encode(decorations), house})
    TriggerClientEvent("alan-property:server:sethousedecorations", -1, house, decorations)
end)

RegisterNetEvent('alan-property:server:giveHouseKey', function(target, house)
    local src = source
    local tPlayer = ESX.GetPlayerFromId(target)
    if tPlayer then
        if housekeyholders[house] then
            for _, cid in pairs(housekeyholders[house]) do
                if cid == tPlayer.identifier then
                    TriggerClientEvent('alan-tasknotify:client:SendAlert', src, { type = 'error', text = Lang:t("error.already_keys"), length = 5000 })
                    return
                end
            end
            housekeyholders[house][#housekeyholders[house]+1] = tPlayer.identifier
            MySQL.update('UPDATE player_houses SET keyholders = ? WHERE house = ?', {json.encode(housekeyholders[house]), house})
            TriggerClientEvent('alan-property:client:refreshHouse', tPlayer.source)

            TriggerClientEvent('alan-tasknotify:client:SendAlert', tPlayer.source, { type = 'success', text = Lang:t("success.recieved_key", {value = Config.Houses[house].adress}), length = 2500 })
        else
            local sourceTarget = ESX.GetPlayerFromId(src)
            housekeyholders[house] = {
                [1] = sourceTarget.identifier
            }
            housekeyholders[house][#housekeyholders[house]+1] = tPlayer.identifier
            MySQL.update('UPDATE player_houses SET keyholders = ? WHERE house = ?', {json.encode(housekeyholders[house]), house})
            TriggerClientEvent('alan-property:client:refreshHouse', tPlayer.source)
            TriggerClientEvent('alan-tasknotify:client:SendAlert', tPlayer.source, { type = 'success', text = Lang:t("success.recieved_key", {value = Config.Houses[house].adress}), length = 5000 })
        end
    else
        TriggerClientEvent('alan-tasknotify:client:SendAlert', src, { type = 'error', text = Lang:t("error.something_wrong"), length = 5000 })
    end
end)

RegisterNetEvent('alan-property:server:setLocation', function(coords, house, type)
    if type == 1 then
        MySQL.update('UPDATE player_houses SET stash = ? WHERE house = ?', {json.encode(coords), house})
    elseif type == 2 then
        MySQL.update('UPDATE player_houses SET outfit = ? WHERE house = ?', {json.encode(coords), house})
    end
    TriggerClientEvent('alan-property:client:refreshLocations', -1, house, json.encode(coords), type)
end)

RegisterNetEvent('alan-property:server:SetHouseRammed', function(bool, house)
    Config.Houses[house].IsRammed = bool
    TriggerClientEvent('alan-property:client:SetHouseRammed', -1, bool, house)
end)

RegisterNetEvent('alan-property:server:SetInsideMeta', function(insideId, bool)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    if bool then
        MySQL.update('UPDATE users SET house = ? WHERE identifier = ?', {insideId, Player.identifier})
        exports.ox_inventory:RegisterStash(insideId, insideId, 200, 100000000, false)
    else
        MySQL.update('UPDATE users SET house = NULL WHERE identifier = ?', {Player.identifier})
    end
end)

-- Callbacks

ESX.RegisterServerCallback('alan-property:server:checkmax', function(source, cb)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
	MySQL.scalar('SELECT COUNT(identifier) FROM player_houses WHERE identifier = ?', {Player.identifier}, function(result)
        if result then
            cb(result)
        end
	end)
end)

ESX.RegisterServerCallback('alan-property:client:LastLocationHouse', function(source, cb)
    local src = source
	local Player = ESX.GetPlayerFromId(src)
	MySQL.query('SELECT house FROM users WHERE identifier = ?', {Player.identifier}, function(results)
		cb(results[1].house)
	end)
end)

ESX.RegisterServerCallback('alan-property:server:buyFurniture', function(source, cb, price)
    local src = source
    local pData = ESX.GetPlayerFromId(src)
    local moneyBalance = pData.getMoney()

    if moneyBalance >= price then
        pData.removeMoney(price) 
        cb(true)
    else
        TriggerClientEvent('alan-tasknotify:client:SendAlert', src, { type = 'error', text = Lang:t("error.not_enough_money"), length = 10000})
        cb(false)
    end
end)

ESX.RegisterServerCallback('alan-property:server:ProximityKO', function(source, cb, house)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local retvalK = false
    local retvalO

    if Player then
        local identifier = Player.identifier
        if hasKey(identifier, house) then
            retvalK = true
        elseif Player.job.name == "realestate" then
            retvalK = true
        else
            retvalK = false
        end
    end

    if houseowneridentifier[house] then
        retvalO = true
    else
        retvalO = false
    end

    cb(retvalK, retvalO)
end)

ESX.RegisterServerCallback('alan-property:server:hasKey', function(source, cb, house)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local retval = false
    if Player then
        local identifier = Player.identifier
        if hasKey(identifier, house) then
            retval = true
        elseif Player.job.name == "realestate" then
            retval = true
        else
            retval = false
        end
    end

    cb(retval)
end)

ESX.RegisterServerCallback('alan-property:server:isOwned', function(source, cb, house)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if Player and Player and Player.job and Player.job.name == "realestate" then
        cb(true)
    elseif houseowneridentifier[house] then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('alan-property:server:getHouseOwner', function(_, cb, house)
    cb(houseownercid[house])
end)

ESX.RegisterServerCallback('alan-property:server:getHouseKeyHolders', function(source, cb, house)
    local retval = {}
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if housekeyholders[house] then
        for i = 1, #housekeyholders[house], 1 do
            if Player.identifier ~= housekeyholders[house][i] then
                local result = MySQL.query.await('SELECT * FROM users WHERE identifier = ?', {housekeyholders[house][i]})
                if result[1] then
                    retval[#retval+1] = {
                        firstname = result[1].firstname,
                        lastname = result[1].lastname,
                        identifier = housekeyholders[house][i]
                    }
                end
            end
        end
        cb(retval)
    else
        cb(nil)
    end
end)

ESX.RegisterServerCallback('dl-phone:server:TransferCid', function(_, cb, NewCid, house)
    local result = MySQL.query.await('SELECT * FROM users WHERE identifier = ?', {NewCid})
    if result[1] then
        local HouseName = house.name
        housekeyholders[HouseName] = {}
        housekeyholders[HouseName][1] = NewCid
        houseownercid[HouseName] = NewCid
        houseowneridentifier[HouseName] = result[1].identifier
        MySQL.update(
            'UPDATE player_houses SET identifier = ?, keyholders = ?, identifier = ? WHERE house = ?',
            {NewCid, json.encode(housekeyholders[HouseName]), result[1].identifier, HouseName})
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('alan-property:server:getHouseDecorations', function(_, cb, house)
    local retval = nil
    local result = MySQL.query.await('SELECT * FROM player_houses WHERE house = ?', {house})
    if result[1] then
        if result[1].decorations then
            retval = json.decode(result[1].decorations)
        end
    end
    cb(retval)
end)

ESX.RegisterServerCallback('alan-property:server:getHouseLocations', function(_, cb, house)
    local retval = nil
    local result = MySQL.query.await('SELECT * FROM player_houses WHERE house = ?', {house})
    if result[1] then
        retval = result[1]
    end
    cb(retval)
end)

ESX.RegisterServerCallback('alan-property:server:getOwnedHouses', function(source, cb)
    local src = source
    local pData = ESX.GetPlayerFromId(src)
    if pData then
        MySQL.query('SELECT * FROM player_houses WHERE identifier  = ?', {pData.identifier}, function(houses)
            local ownedHouses = {}
            for i = 1, #houses, 1 do
                ownedHouses[#ownedHouses+1] = houses[i].house
            end
            if houses then
                cb(ownedHouses)
            else
                cb(nil)
            end
        end)
    end
end)

ESX.RegisterServerCallback('alan-property:server:getSavedOutfits', function(source, cb)
    local src = source
    local pData = ESX.GetPlayerFromId(src)

    if pData then
        MySQL.query('SELECT * FROM player_outfits WHERE identifier = ?', {pData.identifier},
            function(result)
                if result[1] then
                    cb(result)
                else
                    cb(nil)
                end
            end)
    end
end)

ESX.RegisterServerCallback('dl-phone:server:GetPlayerHouses', function(source, cb)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local MyHouses = {}
    local result = MySQL.query.await('SELECT * FROM player_houses WHERE identifier = ?',
        {Player.identifier})
    if result and result[1] then
        for k, v in pairs(result) do
            MyHouses[#MyHouses+1] = {
                name = v.house,
                keyholders = {},
                owner = Player.identifier,
                price = Config.Houses[v.house].price,
                label = Config.Houses[v.house].adress,
                tier = Config.Houses[v.house].tier,
                garage = Config.Houses[v.house].garage
            }

            if v.keyholders ~= "null" then
                v.keyholders = json.decode(v.keyholders)
                if v.keyholders then
                    for _, data in pairs(v.keyholders) do
                        local keyholderdata = MySQL.query.await('SELECT * FROM users WHERE identifier = ?',
                            {data})
                        if keyholderdata[1] then
                            local userKeyHolderData = {
                                firstname = keyholderdata[1].firstname,
                                lastname =  keyholderdata[1].lastname,
                                identifier = keyholderdata[1].identifier,
                                name = keyholderdata[1].name
                            }

                            MyHouses[k].keyholders[#MyHouses[k].keyholders+1] = userKeyHolderData
                        end
                    end
                else
                    MyHouses[k].keyholders[1] = {
                        firstname = Player.firstname,
                        lastname = Player.lastname,
                        identifier = Player.identifier,
                        name = Player.name
                    }
                end
            else
                MyHouses[k].keyholders[1] = {
                    firstname = Player.firstname,
                    lastname = Player.lastname,
                    identifier = Player.identifier,
                    name = Player.name
                }
            end
        end

        SetTimeout(100, function()
            cb(MyHouses)
        end)
    else
        cb({})
    end
end)

ESX.RegisterServerCallback('dl-phone:server:GetHouseKeys', function(source, cb)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local MyKeys = {}

    local result = MySQL.query.await('SELECT * FROM player_houses', {})
    for _, v in pairs(result) do
        if v.keyholders ~= "null" then
            v.keyholders = json.decode(v.keyholders)
            for _, p in pairs(v.keyholders) do
                if p == Player.identifier  and (v.identifier ~= Player.identifier) then
                    MyKeys[#MyKeys+1] = {
                        HouseData = Config.Houses[v.house]
                    }
                end
            end
        end

        if v.identifier == Player.identifier then
            MyKeys[#MyKeys+1] = {
                HouseData = Config.Houses[v.house]
            }
        end
    end
    cb(MyKeys)
end)

ESX.RegisterServerCallback('dl-phone:server:MeosGetPlayerHouses', function(_, cb, input)
    if input then
        local search = escape_sqli(input)
        local searchData = {}
        local query = '%' .. search .. '%'
        local result = MySQL.query.await('SELECT * FROM users WHERE identifier = ? OR firstname LIKE ? or lastname LIKE ?',
            {search, query, query})
        if result[1] then
            local houses = MySQL.query.await('SELECT * FROM player_houses WHERE identifier = ?',
                {result[1].identifier})
            if houses[1] then
                for _, v in pairs(houses) do
                    searchData[#searchData+1] = {
                        name = v.house,
                        keyholders = v.keyholders,
                        owner = v.identifier,
                        price = Config.Houses[v.house].price,
                        label = Config.Houses[v.house].adress,
                        tier = Config.Houses[v.house].tier,
                        garage = Config.Houses[v.house].garage,
                        charinfo = {
                            firstname = result[1].firstname,
                            lastname = result[1].lastname,
                        },
                        
                        --charinfo = json.decode(result[1].charinfo),
                        coords = {
                            x = Config.Houses[v.house].coords.enter.x,
                            y = Config.Houses[v.house].coords.enter.y,
                            z = Config.Houses[v.house].coords.enter.z
                        }
                    }
                end
                cb(searchData)
            end
        else
            cb(nil)
        end
    else
        cb(nil)
    end
end)
