ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--[[ ***** EVENTS GUI ***** ]]
RegisterServerEvent("antirpquestion:kick")
AddEventHandler("antirpquestion:kick", function()
	DropPlayer(source, "Kamu tidak lulus menyelesaikan questionare. Keluar dari server.")
end)

RegisterServerEvent("antirpquestion:success")
AddEventHandler("antirpquestion:success", function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local model = Config.vehicleModel
    
    MySQL.Async.execute("UPDATE users SET question_rp='made' WHERE identifier = @username", {
        ['@username'] = xPlayer.identifier
    }, function()
    end)

    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
        ['@owner']   = xPlayer.identifier,
        ['@plate']   = plate,
        ['@vehicle'] = json.encode({model = GetHashKey(model), plate = plate})
    }, function(rowsChanged)
        --xPlayer.showNotification('Kamu memiliki kendaraan '..plate..' sekarang!')
    end)

    xPlayer.addMoney(Config.cashRewards)
    xPlayer.addInventoryItem('kebab', 5)
    xPlayer.addInventoryItem('cola', 5)
    --xPlayer.addAccountMoney('bank', Config.bankRewards)
    TriggerClientEvent('midp-tasknotify:Alert', source, "SYSTEM", "Kamu mendapat mobil dan uang $JN25.000", 5000, 'info')
    --TriggerClientEvent('esx:showNotification', _source,'Kamu mendapatkan ~r~$'..Config.cashRewards..' ~s~dan ~g~$'..Config.bankRewards)

end)

--[[ ***** SPAWN ***** ]]
RegisterServerEvent("antirpquestion:didQuestion")
AddEventHandler("antirpquestion:didQuestion", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @username", {
        ['@username'] = xPlayer.identifier
    }, function(result)
        for _,v in pairs(result) do
            if v.question_rp == "false" then
                TriggerClientEvent('antirpquestion:notMade', xPlayer.source)
            end
        end
    end)
end)
