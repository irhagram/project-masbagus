RegisterServerEvent('duty:onoff')
AddEventHandler('duty:onoff', function(job)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade
    
    if job == 'police' or job == 'ambulance' or job == 'mcg' or job == 'pedagang' or job == 'mechanic' or job == 'taxi' then
        xPlayer.setJob('off' ..job, grade)
        TriggerClientEvent('midp-tasknotify:Alert', _source, "Job", "Off Duty", 3000, 'error')
    elseif job == 'offpolice' then
        xPlayer.setJob('police', grade)
        TriggerClientEvent('midp-tasknotify:Alert', _source, "Job", "On Duty", 3000, 'success')
    elseif job == 'offambulance' then
        xPlayer.setJob('ambulance', grade)
        TriggerClientEvent('midp-tasknotify:Alert', _source, "Job", "On Duty", 3000, 'success')
    elseif job == 'offmcg' then
        xPlayer.setJob('mcg', grade)
        TriggerClientEvent('midp-tasknotify:Alert', _source, "Job", "On Duty", 3000, 'success')
    elseif job == 'offpedagang' then
        xPlayer.setJob('pedagang', grade)
        TriggerClientEvent('midp-tasknotify:Alert', _source, "Job", "On Duty", 3000, 'success')
    elseif job == 'offmechanic' then
        xPlayer.setJob('mechanic', grade)
        TriggerClientEvent('midp-tasknotify:Alert', _source, "Job", "On Duty", 3000, 'success')
    elseif job == 'offtaxi' then
        xPlayer.setJob('taxi', grade)
        TriggerClientEvent('midp-tasknotify:Alert', _source, "Job", "On Duty", 3000, 'success')
    end

end)