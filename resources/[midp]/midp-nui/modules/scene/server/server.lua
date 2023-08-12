local scenes = {}

RegisterNetEvent('scenes:fetch', function()
    local src = source
    TriggerClientEvent('scenes:send', src, scenes)
end)

RegisterNetEvent('scenes:add', function(coords, message, color, distance)
    table.insert(scenes, {
        message = message,
        color = color,
        distance = distance,
        coords = coords
    })
    TriggerClientEvent('scenes:send', -1, scenes)
    TriggerEvent('scenes:log', source, message, coords)
end)

RegisterNetEvent('scenes:delete', function(key)
    table.remove(scenes, key)
    TriggerClientEvent('scenes:send', -1, scenes)
end)


RegisterNetEvent('scenes:log', function(id, text, coords)
    local f, err = io.open('sceneLogging.txt', 'a')
    if not f then return print(err) end
    f:write('Player: ['..id..'] Placed Scene: ['..text..'] At Coords = '..coords..'\n')
    f:close()
end)