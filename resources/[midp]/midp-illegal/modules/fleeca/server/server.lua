
Doors = {
    ["F1"] = {{loc = vector3(312.93, -284.45, 54.16), h = 160.91, txtloc = vector3(312.93, -284.45, 54.16), obj = nil, locked = false}, {loc = vector3(310.93, -284.44, 54.16), txtloc = vector3(310.93, -284.44, 54.16), state = nil, locked = true}},
    ["F2"] = {{loc = vector3(148.76, -1045.89, 29.37), h = 158.54, txtloc = vector3(148.76, -1045.89, 29.37), obj = nil, locked = false}, {loc = vector3(146.61, -1046.02, 29.37), txtloc = vector3(146.61, -1046.02, 29.37), state = nil, locked = true}},
    ["F3"] = {{loc = vector3(-1209.66, -335.15, 37.78), h = 213.67, txtloc = vector3(-1209.66, -335.15, 37.78), obj = nil, locked = false}, {loc = vector3(-1211.07, -336.68, 37.78), txtloc = vector3(-1211.07, -336.68, 37.78), state = nil, locked = true}},
    ["F4"] = {{loc = vector3(-2957.26, 483.53, 15.70), h = 267.73, txtloc = vector3(-2957.26, 483.53, 15.70), obj = nil, locked = false}, {loc = vector3(-2956.68, 481.34, 15.70), txtloc = vector3(-2956.68, 481.34, 15.7), state = nil, locked = true}},
    ["F5"] = {{loc = vector3(-351.97, -55.18, 49.04), h = 159.79, txtloc = vector3(-351.97, -55.18, 49.04), obj = nil, locked = false}, {loc = vector3(-354.15, -55.11, 49.04), txtloc = vector3(-354.15, -55.11, 49.04), state = nil, locked = true}},
    ["F6"] = {{loc = vector3(1174.24, 2712.47, 38.09), h = 160.91, txtloc = vector3(1174.24, 2712.47, 38.09), obj = nil, locked = false}, {loc = vector3(1176.40, 2712.75, 38.09), txtloc = vector3(1176.40, 2712.75, 38.09), state = nil, locked = true}},
}

RegisterServerEvent("alan-fleecarob:startcheck")
AddEventHandler("alan-fleecarob:startcheck", function(bank)
    local _source = source
    local copcount = 0
    local Players = ESX.GetPlayers()

    for i = 1, #Players, 1 do
        local xPlayer = ESX.GetPlayerFromId(Players[i])

        if xPlayer.job.name == "police" then
            copcount = copcount + 1
        end
    end
    local xPlayer = ESX.GetPlayerFromId(_source)
    local item = xPlayer.getInventoryItem("hack_usb")["count"]

    if copcount >= Config_Fleeca.mincops then
        if not Config_Fleeca.Banks[bank].onaction == true then
            if (os.time() - Config_Fleeca.cooldown) > Config_Fleeca.Banks[bank].lastrobbed then
                Config_Fleeca.Banks[bank].onaction = true
                xPlayer.removeInventoryItem("hack_usb", 1)
                TriggerClientEvent("alan-fleecarob:outcome", _source, true, bank)
                TriggerClientEvent("alan-fleecarob:policenotify", -1, bank)
                message = 'TELAH TERJADI PERAMPOKAN BANK KECIL, HARAP WARGA MENJAUH DARI LOKASI PERAMPOKAN'
                TriggerClientEvent('chat:addMessage', -1, {
                    template = '<div class="chat-message-rob"><b><span style="color: #ffffff">BERITA : </span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">' ..message.. '</span></b></div>',
                    args = { fal, msg }
                })
            else
                TriggerClientEvent("alan-fleecarob:outcome", _source, false, "This bank recently robbed. You need to wait "..math.floor((Config_Fleeca.cooldown - (os.time() - Config_Fleeca.Banks[bank].lastrobbed)) / 60)..":"..math.fmod((Config_Fleeca.cooldown - (os.time() - Config_Fleeca.Banks[bank].lastrobbed)), 60))
            end
        else
            TriggerClientEvent("alan-fleecarob:outcome", _source, false, "This bank is currently being robbed.")
        end
    else
        TriggerClientEvent("alan-fleecarob:outcome", _source, false, "There is not enough police in the city.")
    end
end)


RegisterServerEvent("alan-fleecarob:lootup")
AddEventHandler("alan-fleecarob:lootup", function(var, var2)
    TriggerClientEvent("alan-fleecarob:lootup_c", -1, var, var2)
end)

RegisterServerEvent("alan-fleecarob:openDoor")
AddEventHandler("alan-fleecarob:openDoor", function(coords, method)
    TriggerClientEvent("alan-fleecarob:openDoor_c", -1, coords, method)
end)

RegisterServerEvent("alan-fleecarob:toggleVault")
AddEventHandler("alan-fleecarob:toggleVault", function(key, state)
    Doors[key][2].locked = state
    TriggerClientEvent("alan-fleecarob:toggleVault", -1, key, state)
end)

RegisterServerEvent("alan-fleecarob:updateVaultState")
AddEventHandler("alan-fleecarob:updateVaultState", function(key, state)
    Doors[key][2].state = state
end)

RegisterServerEvent("alan-fleecarob:startLoot")
AddEventHandler("alan-fleecarob:startLoot", function(data, name, players)
    local _source = source

    for i = 1, #players, 1 do
        TriggerClientEvent("alan-fleecarob:startLoot_c", players[i], data, name)
    end
    TriggerClientEvent("alan-fleecarob:startLoot_c", _source, data, name)
end)

RegisterServerEvent("alan-fleecarob:stopHeist")
AddEventHandler("alan-fleecarob:stopHeist", function(name)
    TriggerClientEvent("alan-fleecarob:stopHeist_c", -1, name)
end)

RegisterServerEvent("alan-fleecarob:rewardCash")
AddEventHandler("alan-fleecarob:rewardCash", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local reward = math.random(Config_Fleeca.mincash, Config_Fleeca.maxcash)

    if Config_Fleeca.black then
        xPlayer.addAccountMoney("black_money", reward)
    else
        xPlayer.addMoney(reward)
    end
end)

RegisterServerEvent("alan-fleecarob:setCooldown")
AddEventHandler("alan-fleecarob:setCooldown", function(name)
    Config_Fleeca.Banks[name].lastrobbed = os.time()
    Config_Fleeca.Banks[name].onaction = false
    TriggerClientEvent("alan-fleecarob:resetDoorState", -1, name)
end)

ESX.RegisterServerCallback("alan-fleecarob:getBanks", function(source, cb)
    cb(Config_Fleeca.Banks, Doors)
end)
