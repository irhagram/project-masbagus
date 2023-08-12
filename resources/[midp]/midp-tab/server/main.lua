

RegisterServerEvent('ns_policecad:getData')
AddEventHandler('ns_policecad:getData', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    MySQL.Async.fetchAll('SELECT firstname, lastname, job, job_grade, sex FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.getIdentifier()
    }, function(result)
        if result[1] ~= nil then
            MySQL.Async.fetchAll('SELECT label, name FROM job_grades WHERE job_name = @job AND grade = @grade', {
                ['@job'] = Config.JobName,
                ['@grade'] = result[1].job_grade
            }, function(results)
                if results[1] ~= nil then
                    TriggerClientEvent('ns_policecad:setData', src, result[1].firstname, result[1].lastname,
                        result[1].sex, results[1].label, xPlayer.getJob().grade_name)
                end
            end)
        end
    end)
end)

RegisterServerEvent('ns_policecad:additional')
AddEventHandler('ns_policecad:additional', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    --MySQL.Async.fetchAll('SELECT * FROM users', {}, function(results)
        MySQL.Async.fetchAll('SELECT target, amount FROM billing WHERE target = @target', {
            ['@target'] = 'society_ambulance',
        }, function(res)
            MySQL.Async.fetchAll('SELECT * FROM users WHERE job = @job', {
                ['@job'] = 'ambulance'
            }, function(result)
                TriggerClientEvent('ns_policecad:setAdditional', src, #result, abc)
            end)
        end)
    --end)
end)

RegisterServerEvent('ns_policecad:getBolos')
AddEventHandler('ns_policecad:getBolos', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local bolos = {}
    MySQL.Async.fetchAll('SELECT firstname, lastname, phone, koma FROM users', {
    }, function(result)
        for _,v in pairs(result) do
            koma = v.koma
            --if koma > 0 then
                table.insert(bolos, {
                    firstname = v.firstname,
                    text = v.phone,
                    koma = koma
                })
            --end
        end

        TriggerClientEvent('ns_policecad:setBolos', src, bolos)
    end)
        --end
    --end)
end)

RegisterServerEvent('ns_policecad:searchCitizenServer')
AddEventHandler('ns_policecad:searchCitizenServer', function(firstname, lastname)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if (tostring(firstname) ~= "" or tostring(firstname) ~= nil) and
        (tostring(lastname) ~= "" or tostring(lastname) ~= nil) then
        MySQL.Async.fetchAll('SELECT * FROM users WHERE firstname = @firstname AND lastname = @lastname', {
            ['@firstname'] = firstname,
            ['@lastname'] = lastname
        }, function(results)
            if results[1] ~= nil then
                MySQL.Async.fetchAll('SELECT label FROM job_grades WHERE job_name = @job_name AND grade = @grade', {
                    ['@job_name'] = results[1].job,
                    ['@grade'] = results[1].job_grade
                }, function(result)

                    MySQL.Async.fetchAll('SELECT label FROM jobs WHERE name = @job', {
                        ['@job'] = results[1].job
                    }, function(res)
                        MySQL.Async.fetchAll('SELECT * FROM ns_bolos WHERE identifier = @identifier', {
                            ['@identifier'] = results[1].identifier
                        }, function(bolo)
                            local activeBolo = false
                            if bolo[1] ~= nil then
                                activeBolo = true
                            else
                                activeBolo = false
                            end
                            local citizens = {}
                            table.insert(citizens, {
                                firstname = results[1].firstname,
                                lastname = results[1].lastname,
                                identifier = results[1].identifier,
                                sex = results[1].sex,
                                grade = result[1].label,
                                height = results[1].height,
                                address = results[1].address,
                                phone = results[1].phone_number,
                                job = res[1].label,
                                bolo = activeBolo
                            })
                            if #results > 0 then
                                TriggerClientEvent('ns_policecad:getCitizenResults', src, citizens)
                                TriggerClientEvent('ns_policecad:getNotes', src, results[1].identifier)
                                TriggerClientEvent('ns_policecad:getEntries', src, results[1].identifier)
                            else
                                TriggerClientEvent('ns_policead:noCitizenResult', src)
                            end
                        end)
                    end)
                end)
            end
        end)
    else
        xPlayer.showNotification('Please specify a firstname and lastname')
    end
end)

RegisterServerEvent('ns_policecad:searchVehicleServer')
AddEventHandler('ns_policecad:searchVehicleServer', function(plate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    plate = tostring(plate)

    if xPlayer.getJob().name == Config.JobName then
        MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate LIKE @plate', {
            ['@plate'] = "%" .. plate .. "%"
        }, function(result)
            for i = 1, #result, 1 do
                MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
                    ['@identifier'] = result[i].owner
                }, function(results)
                    local vehicles = {}
                    table.insert(vehicles, {
                        plate = result[i].plate,
                        firstname = results[1].firstname,
                        lastname = results[1].lastname
                    })
                    TriggerClientEvent('ns_policecad:getVehicleResults', src, vehicles)
                end)
            end
        end)
    end
end)

RegisterServerEvent('ns_policecad:stopBoloServer')
AddEventHandler('ns_policecad:stopBoloServer', function(identifier)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getJob().name == Config.JobName then
        if xPlayer.getJob().grade > 0 then
            MySQL.Async.execute('DELETE FROM ns_bolos WHERE identifier = @identifier', {
                ['@identifier'] = identifier
            })
            TriggerClientEvent('ns_policecad:bolos', src)
        else
            xPlayer.showNotification('You cant do that as an recruit')
        end
    end
end)

RegisterServerEvent('ns_policecad:createBolo')
AddEventHandler('ns_policecad:createBolo', function(identifier, text)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getJob().name == Config.JobName then
        MySQL.Async.fetchAll('SELECT identifier FROM ns_bolos WHERE identifier = @identifier', {
            ['@identifier'] = identifier
        }, function(result)
            if result[1] ~= nil then
                TriggerClientEvent('ns_policecad:boloExists', src)
            else
                MySQL.Async.execute('INSERT INTO ns_bolos (identifier, text) VALUES(@identifier, @text)', {
                    ['@identifier'] = identifier,
                    ['@text'] = text
                })
                TriggerClientEvent('ns_policecad:boloCreated', src)
            end
        end)
    end
end)

RegisterServerEvent('ns_policecad:getEmployees')
AddEventHandler('ns_policecad:getEmployees', function ()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getJob().name == Config.JobName then
        MySQL.Async.fetchAll('SELECT firstname, lastname, job_grade, identifier FROM users WHERE job = @job ORDER BY job_grade DESC', {
            ['@job'] = Config.JobName
        }, function (results)
            local employees = {}

            for i=1, #results, 1 do
                table.insert(employees, {
                    name = results[i].firstname.." "..results[i].lastname,
                    identifier = results[i].identifier,
                    rank = results[i].job_grade
                })
            end
            TriggerClientEvent('ns_policecad:setEmployees', src, employees)
        end)
    end
end)

RegisterServerEvent('ns_policecad:uprank')
AddEventHandler('ns_policecad:uprank', function (identifier)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getJob().name == Config.JobName and xPlayer.getJob().grade_name == 'boss' then
        local xPlayers = ESX.GetPlayers()
        local upranked = false
        for i=1, #xPlayers, 1 do
            local xPlayerr = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayerr.getIdentifier() == identifier then
                upranked = true
                if xPlayerr.getJob().grade >= 0 and xPlayerr.getJob().grade < Config.MaxRanks then
                    xPlayerr.setJob(Config.JobName, xPlayerr.getJob().grade + 1)
                end
            end
        end
        if not upranked then
            MySQL.Async.fetchAll('SELECT job_grade FROM users WHERE identifier = @identifier', {
                ['@identifier'] = identifier
            }, function (result)
                if result[1].job_grade >= 0 and result[1].job_grade < Config.MaxRanks then
                    MySQL.Async.execute('UPDATE users SET job_grade = @grade WHERE identifier = @identifier', {
                        ['@grade'] = result[1].job_grade + 1,
                        ['@identifier'] = identifier
                    })
                end
            end)
        end
        TriggerClientEvent('ns_policecad:getEmployeesClient', src)
    end
end)

RegisterServerEvent('ns_policecad:derank')
AddEventHandler('ns_policecad:derank', function (identifier)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getJob().name == Config.JobName and xPlayer.getJob().grade_name == 'boss' then
        local xPlayers = ESX.GetPlayers()
        local deranked = false
        for i=1, #xPlayers, 1 do
            local xPlayerr = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayerr.getIdentifier() == identifier then
                deranked = true
                if xPlayerr.getJob().grade > 0 and xPlayerr.getJob().grade <= Config.MaxRanks then
                    xPlayerr.setJob(Config.JobName, xPlayerr.getJob().grade - 1)
                end
            end
        end
        if not deranked then
            MySQL.Async.fetchAll('SELECT job_grade FROM users WHERE identifier = @identifier', {
                ['@identifier'] = identifier
            }, function (result)
                if result[1].job_grade > 0 and result[1].job_grade <= Config.MaxRanks then
                    MySQL.Async.execute('UPDATE users SET job_grade = @grade WHERE identifier = @identifier', {
                        ['@grade'] = result[1].job_grade - 1,
                        ['@identifier'] = identifier
                    })
                end
            end)
        end
        TriggerClientEvent('ns_policecad:getEmployeesClient', src)
    end
end)

RegisterServerEvent('ns_policecad:fire')
AddEventHandler('ns_policecad:fire', function (identifier)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getJob().name == Config.JobName and xPlayer.getJob().grade_name == 'boss' then
        local xPlayers = ESX.GetPlayers()
        local fired = false
        for i=1, #xPlayers, 1 do
            local xPlayerr = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayerr.getIdentifier() == identifier then
                fired = true
                xPlayerr.setJob('unemployed', 0)
            end
        end
        if not fired then
            MySQL.Async.execute('UPDATE users SET job_grade = @grade, job = @job WHERE identifier = @identifier', {
                ['@grade'] = 0,
                ['@job'] = 'unemployed',
                ['@identifier'] = identifier
            })
        end
        TriggerClientEvent('ns_policecad:getEmployeesClient', src)
    end
end)

RegisterServerEvent('ns_policecad:storeNote')
AddEventHandler('ns_policecad:storeNote', function (identifier, text)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getJob().name == Config.JobName then
        MySQL.Async.execute('INSERT INTO ns_notes(identifier, text) VALUES(@identifier, @text)', {
            ['@identifier'] = identifier,
            ['@text'] = tostring(text)
        })
        TriggerClientEvent('ns_policecad:noteCreated', src)
    end
end)

RegisterServerEvent('ns_policecad:getNotesServer')
AddEventHandler('ns_policecad:getNotesServer', function (identifier)
    local src = source

    MySQL.Async.fetchAll('SELECT * FROM ns_notes WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function (results)
        if #results > 0 then
            local notes = {}

            for i = 1, #results, 1 do
                table.insert(notes, {
                    text = results[i].text,
                    id = results[i].id,

                })
            end
            TriggerClientEvent('ns_policecad:setNotes', src, notes)
        end
    end)
end)

-- RegisterServerEvent('ns_policecad:getEntriesServer')
-- AddEventHandler('ns_policecad:getEntriesServer', function (identifier)
--     local src = source

--     MySQL.Async.fetchAll('SELECT text FROM ns_entries WHERE identifier = @identifier', {
--         ['@identifier'] = identifier
--     }, function (results)
--         if #results > 0 then
--             local entries = {}

--             for i = 1, #results, 1 do
--                 table.insert(entries, {
--                     text = results[i].text
--                 })
--             end
--             TriggerClientEvent('ns_policecad:setEntries', src, entries)
--         end
--     end)
-- end)

RegisterServerEvent('ns_policecad:deleteNote')
AddEventHandler('ns_policecad:deleteNote', function (identifier, id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer.getJob().name == Config.JobName then
        MySQL.Async.execute('DELETE FROM ns_notes WHERE id = @id', {
            ['@id'] = tonumber(id)
        })
        TriggerClientEvent('ns_policecad:getNotes', src, identifier)
    end
end)


ESX.RegisterServerCallback('ns_policecad:getPlayerJob', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	if xPlayer.getJob().name == Config.JobName then
		cb(true)
	else
		cb(false)
	end
end)


ESX.RegisterServerCallback('ir-ems:getUsers', function(source, cb)
	local usero = {}

	MySQL.Async.fetchAll('SELECT firstname, lastname FROM users', {
		--['@identifier']  = GetPlayerIdentifiers(source)[1],
	}, function(result)
		for _,v in pairs(result) do
			table.insert(usero, {nama = v.firstname .. ' ' .. v.lastname})
		end
		cb(usero)
	end)
end)