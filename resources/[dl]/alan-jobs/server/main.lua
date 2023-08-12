ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--[[RegisterServerEvent('alan-core:NambahItems')
AddEventHandler('alan-core:NambahItems', function(namaitem, count, jumlah)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getInventoryItem(namaitem).count >= 100 then
        TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Muatan dikantongmu telah penuh!' })
    else
        xPlayer.addInventoryItem(namaitem, jumlah)
    end
end)]]
RegisterServerEvent('alan-core:NambahItems')
AddEventHandler('alan-core:NambahItems', function(namaitem, jumlah)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getInventoryItem(namaitem, jumlah) then
        xPlayer.addInventoryItem(namaitem, jumlah)
    else
        TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Tidak Cukup Barang!'})
    end
end)
RegisterServerEvent('alan-core:delItem')
AddEventHandler('alan-core:delItem', function(namaitem, jumlah)
    local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getInventoryItem(namaitem, jumlah) then
		xPlayer.removeInventoryItem(namaitem, jumlah)
	else
		TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Tidak Cukup Barang!'})
	end
end)

RegisterServerEvent('alan-core:JualItems')
AddEventHandler('alan-core:JualItems', function(namaitem, jumlah)
    local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getInventoryItem(namaitem, jumlah) then
		xPlayer.removeInventoryItem(namaitem, jumlah)
		xPlayer.addMoney(price)
	else
		TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Tidak Cukup Barang!'})
	end
end)

RegisterNetEvent('alan-jobs:machete', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local TRAxeClassicPrice = 5000
    local parang = xPlayer.hasWeapon('WEAPON_MACHETE')
    if not parang then
        xPlayer.addInventoryItem('WEAPON_MACHETE', ammo)
        xPlayer.removeAccountMoney("money", TRAxeClassicPrice)
        TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Membeli Parang $DL 5.000!'})
    elseif parang then
        TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Sudah Punya Parang!'})
    end
end)

RegisterNetEvent("alan-jobs:lebur")
AddEventHandler("alan-jobs:lebur", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local randomChance = math.random(1, 100)
    local jumlahc = math.random(3, 4)
    local jumlahb = math.random(2, 3)
    local jumlahg = math.random(1, 2)
    if xPlayer ~= nil then
        if randomChance < 15 then
            if xPlayer.getInventoryItem('diamond').count >= 100 then
                TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Muatan dikantongmu telah penuh' })
            else
                xPlayer.removeInventoryItem("washed_stone", 2)
                xPlayer.addInventoryItem("diamond", 1)
                xPlayer.addInventoryItem("gold", jumlahg)
                xPlayer.addInventoryItem("copper", jumlahc)
                xPlayer.addInventoryItem("iron", jumlahb)
            end
        elseif randomChance > 9 and randomChance < 25 then
            if xPlayer.getInventoryItem('gold').count >= 100 then
                TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Muatan dikantongmu telah penuh' })
            else
                xPlayer.removeInventoryItem("washed_stone", 2)
                xPlayer.addInventoryItem("gold", jumlahg)
                xPlayer.addInventoryItem("copper", jumlahc)
                xPlayer.addInventoryItem("iron", jumlahb)
            end
        elseif randomChance > 24 and randomChance < 50 then
            if xPlayer.getInventoryItem('iron').count >= 100 then
                TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Muatan dikantongmu telah penuh' })
            else
                xPlayer.removeInventoryItem("washed_stone", 2)
                xPlayer.addInventoryItem("iron", jumlahb)
                xPlayer.addInventoryItem("copper", jumlahc)
            end
        elseif randomChance > 49 then
            if xPlayer.getInventoryItem('copper').count >= 100 then
                TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Muatan dikantongmu telah penuh' })
            else
                xPlayer.removeInventoryItem("washed_stone", 2)
                xPlayer.addInventoryItem("copper", jumlahc)
                xPlayer.addInventoryItem("iron", jumlahb)
            end
        end
    end
end)

RegisterServerEvent("alan-jobs:JualBaju")
AddEventHandler("alan-jobs:JualBaju",function(sby)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 2000
    local item = xPlayer.getInventoryItem("clothe").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Baju!'})
        return
    else
        irham.cek(source, sby, function()
            TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. amount})
            xPlayer.removeInventoryItem("clothe",item)
            xPlayer.addMoney(money)
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end)
    end
end)

RegisterServerEvent("alan-jobs:jualAyam")
AddEventHandler("alan-jobs:jualAyam",function(mjk)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 150
    local item = xPlayer.getInventoryItem("packaged_chicken").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Ayam Kemas!'})
        return
    else
        irham.cek(source, mjk, function()
            TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. amount})
            xPlayer.removeInventoryItem("packaged_chicken",item)
            xPlayer.addMoney(money)
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end) 
    end
end)

RegisterServerEvent("alan-jobs:jualTembaga")
AddEventHandler("alan-jobs:jualTembaga",function(ndhasmu)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 150
    local item = xPlayer.getInventoryItem("copper").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Tembaga!'})
        return
    else
        irham.cek(source, ndhasmu, function()
            TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. amount})
            xPlayer.removeInventoryItem("copper",item)
            xPlayer.addMoney(money) 
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end)
    end
end)

RegisterServerEvent("alan-jobs:jualIron")
AddEventHandler("alan-jobs:jualIron",function(gurih)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 200
    local item = xPlayer.getInventoryItem("iron").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Besi!'})
        return
    else
        irham.cek(source, gurih, function()
            TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. amount})
            xPlayer.removeInventoryItem("iron",item)
            xPlayer.addMoney(money)
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end)
    end
end)

RegisterServerEvent("alan-jobs:jualGold")
AddEventHandler("alan-jobs:jualGold",function(daily)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 500
    local item = xPlayer.getInventoryItem("gold").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Emas!'})
        return
    else
        irham.cek(source, daily, function()
            TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. amount})
            xPlayer.removeInventoryItem("gold",item)
            xPlayer.addMoney(money)
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end)
    end
end)

RegisterServerEvent("alan-jobs:jualDiamond")
AddEventHandler("alan-jobs:jualDiamond",function(kikuk)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 1000
    local item = xPlayer.getInventoryItem("diamond").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Diamond!'})
        return
    else
        irham.cek(source, kikuk, function()
            TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. amount})
            xPlayer.removeInventoryItem("diamond",item)
            xPlayer.addMoney(money)
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end)
    end
end)

RegisterServerEvent("alan-jobs:JualanIkan")
AddEventHandler("alan-jobs:JualanIkan",function(mumet)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 150
    local item = xPlayer.getInventoryItem("fish").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Ikan!'})
        return
    else
        irham.cek(source, mumet, function()
            TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. amount})
            xPlayer.removeInventoryItem("fish",item)
            xPlayer.addMoney(money) 
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end)
    end
end)

RegisterServerEvent("alan-jobs:JualinMinyak")
AddEventHandler("alan-jobs:JualinMinyak",function(rwt)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 550
    local item = xPlayer.getInventoryItem("essence").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Gas!'})
        return
    else
        irham.cek(source, rwt, function()
            TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. amount})
            xPlayer.removeInventoryItem("essence",item)
            xPlayer.addMoney(money)
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end)
    end
end)

RegisterServerEvent("alan-jobs:JualinKayu")
AddEventHandler("alan-jobs:JualinKayu",function(alan)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 220
    local item = xPlayer.getInventoryItem("packaged_plank").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Kayu Paket!'})
        return
    else
        irham.cek(source, alan, function()
            TriggerClientEvent('alan-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. money})
            xPlayer.removeInventoryItem("packaged_plank",item)
            xPlayer.addMoney(money)
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end)
    end
end)

ESX.RegisterServerCallback('alan-jobs:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.canCarryItem(item, 1))
end)

ESX.RegisterServerCallback('alan-jobs:cekItem', function(source, cb, items)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.getInventoryItem(items)

    if items == nil then
        cb(0)
    else
        cb(items.count)
    end
end)

RegisterServerEvent('Night:setjob')
AddEventHandler('Night:setjob', function(nombre,grado)
    local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

    if xPlayer then
        xPlayer.setJob(nombre, grado)
    end    
end) 

RegisterServerEvent('Night:drop')
AddEventHandler('Night:drop', function(msg)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(source)
    DropPlayer(source, msg)   
end) 