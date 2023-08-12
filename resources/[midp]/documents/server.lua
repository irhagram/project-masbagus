-- Callback
lib.callback.register('esx_documents:server:submitDocument', function(source, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local db_form = nil

    if xPlayer then
        local id = MySQL.insert.await('INSERT INTO user_documents (owner, data) VALUES (?, ?)', { xPlayer.identifier,  json.encode(data) })
        if id then
            local result = MySQL.query.await('SELECT * FROM user_documents where id = ?', { id })
            if result[1] then
                db_form = result[1]
                db_form.data = json.decode(result[1].data)
            end
        end
    end

    return db_form
end)

lib.callback.register('esx_documents:server:DeleteDocument', function(source, id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        local delete = MySQL.update.await('DELETE FROM user_documents WHERE id = ? AND owner = ?', { id, xPlayer.identifier})
        if delete then
            TriggerClientEvent('esx:showNotification', src, _U('document_deleted'))
            return true
        else
            TriggerClientEvent('esx:showNotification', src, _U('document_delete_failed'))
        end
    end

    return false
end)

lib.callback.register('esx_documents:server:getPlayerDocuments', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local forms = {}

    if xPlayer then
        local result = MySQL.query.await('SELECT * FROM user_documents WHERE owner = ?', { xPlayer.identifier })
        if #result > 0 then
            for i=1, #result, 1 do
                local tmp_result = result[i]
                tmp_result.data = json.decode(result[i].data)
                forms[#forms+1] = tmp_result
            end
        end
    end

    return forms
end)

lib.callback.register('esx_documents:server:getPlayerDetails', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local cb_data = nil

    if xPlayer then
        local result = MySQL.query.await('SELECT firstname, lastname, dateofbirth FROM users WHERE identifier = ?', { xPlayer.identifier })
        if result[1] then
            cb_data = result[1]
        end
    end

    return cb_data
end)

-- Events
RegisterServerEvent('esx_documents:server:ShowToPlayer', function(targetID, aForm)
    TriggerClientEvent('esx_documents:client:ViewDocument', targetID, aForm)
end)

RegisterServerEvent('esx_documents:server:CopyToPlayer', function(targetID, aForm)
    local src = source
    local targetID = tonumber(targetID)
    local targetxPlayer = ESX.GetPlayerFromId(targetID)

    if targetxPlayer then
        MySQL.insert('INSERT INTO user_documents (owner, data) VALUES (?, ?)', { targetxPlayer.identifier, json.encode(aForm) }, function(id)
            if id then
                MySQL.query('SELECT * FROM user_documents where id = ?', { id }, function(result)
                    if result[1] then
                        db_form = result[1]
                        db_form.data = json.decode(result[1].data)
                        TriggerClientEvent('esx_documents:client:copyForm', targetID, db_form)
                        TriggerClientEvent('esx:showNotification', targetID, _U('copy_from_player'))
                        TriggerClientEvent('esx:showNotification', src, _U('from_copied_player'))
                    else
                        TriggerClientEvent('esx:showNotification', src, _U('could_not_copy_form_player'))
                    end
                end)
            else
                TriggerClientEvent('esx:showNotification', src, _U('could_not_copy_form_player'))
            end
        end)
    end
end)