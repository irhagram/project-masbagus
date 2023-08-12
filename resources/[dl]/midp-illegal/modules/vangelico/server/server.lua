ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local doorState = Config_Vangelico.Doors

RegisterCommand('vdoors', function(source, args, rawCommand)
    local doorId = tonumber(args[1])
    if not doorId or not doorState[doorId] then
        return
    end
    doorState[doorId].Locked = not doorState[doorId].Locked
    TriggerClientEvent('dl-vdoors:set', -1, doorId, doorState[doorId].Locked)
end)

AddEventHandler('playerJoining', function()
    TriggerClientEvent('dl-vdoors:initialize', source, doorState)
end)

ESX.RegisterUsableItem('thermite', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('dl-robjewel:thermite', source)
end)

RegisterNetEvent('dl-robjewel:thermitedelete')
AddEventHandler('dl-robjewel:thermitedelete', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem("thermite", 1)
end)

--[[ RegisterNetEvent('dl-robjewel:rewards')
AddEventHandler('dl-robjewel:rewards', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local randomitem = math.random(1,100)
    for i, v in pairs(Config_Vangelico.ItemDrops) do 
        if randomitem <= v.chance then
            randomamount = math.random(v.min, v.max)
            sourceItem = xPlayer.getInventoryItem(v.name)
            if sourceItem.limit ~= nil then
                if sourceItem.limit ~= -1 and (sourceItem.count + randomamount) > sourceItem.limit then
                    if sourceItem.count < sourceItem.limit then
                        randomamount = sourceItem.limit - sourceItem.count
                        xPlayer.addInventoryItem(v.name, randomamount)
                    else
                        TriggerClientEvent('midp-tasknotify:client:SendAlert', source, { type = 'error', text = "Inventory Tidak Cukup " .. sourceItem.label})
                    end
                else
                    xPlayer.addInventoryItem(v.name, randomamount)
                end
                break
            else
                xPlayer.addInventoryItem(v.name, randomamount)
                break
            end
        end
    end
end) ]]

RegisterNetEvent("dl-robjewel:rewards")
AddEventHandler("dl-robjewel:rewards", function(item, count)
    local src = source
    local xPlayer  = ESX.GetPlayerFromId(src)
    local randomChance = math.random(1, 100)
    local jumlahc = math.random(250000, 300000)
    local jumlahb = math.random(30, 35)
    local jumlahg = math.random(40, 45)
    if xPlayer ~= nil then
        if randomChance > 40 and randomChance < 50 then
            if xPlayer.getInventoryItem('diamond').count >= 100 then
                TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Muatan dikantongmu telah penuh' })
            else
                xPlayer.addInventoryItem("bank_card", 1)
                xPlayer.addInventoryItem("gold", jumlahg)
                xPlayer.addInventoryItem("diamond", jumlahb)
                xPlayer.addInventoryItem("black_money", jumlahc)
            end
        elseif randomChance > 49 then
            if xPlayer.getInventoryItem('gold').count >= 100 then
                TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Muatan dikantongmu telah penuh' })
            else
                xPlayer.addInventoryItem("laptop_h", 1)
                xPlayer.addInventoryItem("gold", jumlahg)
                xPlayer.addInventoryItem("diamond", jumlahb)
                xPlayer.addInventoryItem("black_money", jumlahc)
            end
        end
    end
end)

RegisterServerEvent('dl-robjewel:particleserver')
AddEventHandler('dl-robjewel:particleserver', function(method)
    TriggerClientEvent('dl-robjewel:ptfxparticle', -1, method)
end)

RegisterServerEvent('dl-robjewel:allnotify')
AddEventHandler('dl-robjewel:allnotify', function(players)
    TriggerClientEvent('midp-tasknotify:client:SendAlert', source, { type = 'error', text = 'System keamanan akan online 10 menit lagi!'})
end)

RegisterServerEvent('dl-robjewel:policenotify')
AddEventHandler('dl-robjewel:policenotify', function()
    TriggerClientEvent('dl-robjewel:policenotify', -1)   
    message = 'TELAH TERJADI PERAMPOKAN TOKO BERLIAN HARAP WARGA MENJAUH DARI LOKASI PERAMPOKAN'
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message-rob"><b><span style="color: #ffffff">BERITA: </span>&nbsp;<span style="font-size: 14px; color: #ffffff;">' ..message.. '</span></b></div>',
        args = { fal, msg }
    }) 
end)