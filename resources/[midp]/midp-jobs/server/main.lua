
--[[RegisterServerEvent('midp-core:NambahItems')
AddEventHandler('midp-core:NambahItems', function(namaitem, count, jumlah)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getInventoryItem(namaitem).count >= 100 then
        TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Muatan dikantongmu telah penuh!' })
    else
        xPlayer.addInventoryItem(namaitem, jumlah)
    end
end)]]
RegisterServerEvent('midp-core:NambahItems')
AddEventHandler('midp-core:NambahItems', function(namaitem, jumlah)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getInventoryItem(namaitem, jumlah) then
        xPlayer.addInventoryItem(namaitem, jumlah)
    else
        TriggerClientEvent('midp-tasknotify:client:SendAlert', source, { type = 'error', text = 'Tidak Cukup Barang!'})
    end
end)
RegisterServerEvent('midp-core:delItem')
AddEventHandler('midp-core:delItem', function(namaitem, jumlah)
    local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getInventoryItem(namaitem, jumlah) then
		xPlayer.removeInventoryItem(namaitem, jumlah)
	else
		TriggerClientEvent('midp-tasknotify:client:SendAlert', source, { type = 'error', text = 'Tidak Cukup Barang!'})
	end
end)

RegisterServerEvent('midp-core:JualItems')
AddEventHandler('midp-core:JualItems', function(namaitem, jumlah)
    local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getInventoryItem(namaitem, jumlah) then
		xPlayer.removeInventoryItem(namaitem, jumlah)
		xPlayer.addMoney(price)
	else
		TriggerClientEvent('midp-tasknotify:client:SendAlert', source, { type = 'error', text = 'Tidak Cukup Barang!'})
	end
end)

RegisterNetEvent('midp-jobs:machete', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local TRAxeClassicPrice = 5000
    local parang = xPlayer.hasWeapon('WEAPON_MACHETE')
    if not parang then
        xPlayer.addInventoryItem('WEAPON_MACHETE', ammo)
        xPlayer.removeAccountMoney("money", TRAxeClassicPrice)
        TriggerClientEvent('midp-tasknotify:client:SendAlert', source, { type = 'error', text = 'Membeli Parang $DL 5.000!'})
    elseif parang then
        TriggerClientEvent('midp-tasknotify:client:SendAlert', source, { type = 'error', text = 'Sudah Punya Parang!'})
    end
end)

RegisterNetEvent("midp-jobs:lebur")
AddEventHandler("midp-jobs:lebur", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local randomChance = math.random(1, 100)
    local jumlahc = math.random(3, 4)
    local jumlahb = math.random(2, 3)
    local jumlahg = math.random(1, 2)
    if xPlayer ~= nil then
        if randomChance < 15 then
            if xPlayer.getInventoryItem('diamond').count >= 100 then
                TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Muatan dikantongmu telah penuh' })
            else
                xPlayer.removeInventoryItem("washed_stone", 2)
                xPlayer.addInventoryItem("diamond", 1)
                xPlayer.addInventoryItem("gold", jumlahg)
                xPlayer.addInventoryItem("copper", jumlahc)
                xPlayer.addInventoryItem("iron", jumlahb)
            end
        elseif randomChance > 9 and randomChance < 25 then
            if xPlayer.getInventoryItem('gold').count >= 100 then
                TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Muatan dikantongmu telah penuh' })
            else
                xPlayer.removeInventoryItem("washed_stone", 2)
                xPlayer.addInventoryItem("gold", jumlahg)
                xPlayer.addInventoryItem("copper", jumlahc)
                xPlayer.addInventoryItem("iron", jumlahb)
            end
        elseif randomChance > 24 and randomChance < 50 then
            if xPlayer.getInventoryItem('iron').count >= 100 then
                TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Muatan dikantongmu telah penuh' })
            else
                xPlayer.removeInventoryItem("washed_stone", 2)
                xPlayer.addInventoryItem("iron", jumlahb)
                xPlayer.addInventoryItem("copper", jumlahc)
            end
        elseif randomChance > 49 then
            if xPlayer.getInventoryItem('copper').count >= 100 then
                TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Muatan dikantongmu telah penuh' })
            else
                xPlayer.removeInventoryItem("washed_stone", 2)
                xPlayer.addInventoryItem("copper", jumlahc)
                xPlayer.addInventoryItem("iron", jumlahb)
            end
        end
    end
end)

RegisterServerEvent("midp-jobs:JualBaju")
AddEventHandler("midp-jobs:JualBaju",function(sby)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 2000
    local item = xPlayer.getInventoryItem("clothe").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Baju!'})
        return
    else
        irham.cek(source, sby, function()
            TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. amount})
            xPlayer.removeInventoryItem("clothe",item)
            xPlayer.addMoney(money)
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end)
    end
end)

RegisterServerEvent("midp-jobs:jualAyam")
AddEventHandler("midp-jobs:jualAyam",function(mjk)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 150
    local item = xPlayer.getInventoryItem("packaged_chicken").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Ayam Kemas!'})
        return
    else
        irham.cek(source, mjk, function()
            TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. amount})
            xPlayer.removeInventoryItem("packaged_chicken",item)
            xPlayer.addMoney(money)
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end) 
    end
end)

RegisterServerEvent("midp-jobs:jualTembaga")
AddEventHandler("midp-jobs:jualTembaga",function(ndhasmu)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 150
    local item = xPlayer.getInventoryItem("copper").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Tembaga!'})
        return
    else
        irham.cek(source, ndhasmu, function()
            TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. amount})
            xPlayer.removeInventoryItem("copper",item)
            xPlayer.addMoney(money) 
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end)
    end
end)

RegisterServerEvent("midp-jobs:jualIron")
AddEventHandler("midp-jobs:jualIron",function(gurih)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 200
    local item = xPlayer.getInventoryItem("iron").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Besi!'})
        return
    else
        irham.cek(source, gurih, function()
            TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. amount})
            xPlayer.removeInventoryItem("iron",item)
            xPlayer.addMoney(money)
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end)
    end
end)

RegisterServerEvent("midp-jobs:jualGold")
AddEventHandler("midp-jobs:jualGold",function(daily)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 500
    local item = xPlayer.getInventoryItem("gold").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Emas!'})
        return
    else
        irham.cek(source, daily, function()
            TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. amount})
            xPlayer.removeInventoryItem("gold",item)
            xPlayer.addMoney(money)
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end)
    end
end)

RegisterServerEvent("midp-jobs:jualDiamond")
AddEventHandler("midp-jobs:jualDiamond",function(kikuk)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 1000
    local item = xPlayer.getInventoryItem("diamond").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Diamond!'})
        return
    else
        irham.cek(source, kikuk, function()
            TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. amount})
            xPlayer.removeInventoryItem("diamond",item)
            xPlayer.addMoney(money)
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end)
    end
end)

RegisterServerEvent("midp-jobs:JualanIkan")
AddEventHandler("midp-jobs:JualanIkan",function(mumet)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 150
    local item = xPlayer.getInventoryItem("fish").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Ikan!'})
        return
    else
        irham.cek(source, mumet, function()
            TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. amount})
            xPlayer.removeInventoryItem("fish",item)
            xPlayer.addMoney(money) 
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end)
    end
end)

RegisterServerEvent("midp-jobs:JualinMinyak")
AddEventHandler("midp-jobs:JualinMinyak",function(rwt)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 550
    local item = xPlayer.getInventoryItem("essence").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Gas!'})
        return
    else
        irham.cek(source, rwt, function()
            TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. amount})
            xPlayer.removeInventoryItem("essence",item)
            xPlayer.addMoney(money)
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end)
    end
end)

RegisterServerEvent("midp-jobs:JualinKayu")
AddEventHandler("midp-jobs:JualinKayu",function(alan)
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = 220
    local item = xPlayer.getInventoryItem("packaged_plank").count
    local money = amount * item

    if item == 0 then
        TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Tidak Punya Kayu Paket!'})
        return
    else
        irham.cek(source, alan, function()
            TriggerClientEvent('midp-tasknotify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Menjual Dengan Harga $DL '.. money})
            xPlayer.removeInventoryItem("packaged_plank",item)
            xPlayer.addMoney(money)
        end, function()
            DropPlayer(source, 'Mau Ngetes ILMU KIDS?')
        end)
    end
end)

ESX.RegisterServerCallback('midp-jobs:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.canCarryItem(item, 1))
end)

ESX.RegisterServerCallback('midp-jobs:cekItem', function(source, cb, items)
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