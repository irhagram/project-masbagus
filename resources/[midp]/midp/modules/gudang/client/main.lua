
local infoGudang = nil
local nameId = 0

CreateThread(function()

	while ESX.GetPlayerData().job == nil do
		Wait(10)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

LokGudang = {
	["GudangPantai"] = {
		location = vector3(-1607.61, -831.04, 10.08),
        z = 114.32,
        h = 274.68,
	},

    ["GudangPaleto"] = {
		location = vector3(147.41, 6366.67, 31.53),
        z = 31.44,
        h = 44.24,
	},
}

CreateThread(function()
    for k,v in pairs(LokGudang) do
        nameId = nameId + 1
        exports["ox_target"]:AddBoxZone("LokGudang" .. nameId, v.location, 2.0, 5.0, {
            name = "LokGudang" .. nameId,
            heading = v.h,
            debugPoly = false,
            minZ = v.z - 1.0,
            maxZ = v.z + 2.0
        }, {
            options = {
                {
                    event = "dl-gudang:MenuGudang",
                    icon = "fas fa-warehouse",
                    label = "Gudang",
                },
            },
            distance = 2.0
        })
    end
    
    exports["ox_target"]:AddBoxZone("GudangSewa", vector3(-145.44, -635.0, 168.84), 1.5, 1.5, {
        name = "GudangSewa",
        heading = 272.08,
        debugPoly = false,
        minZ = 168.8 - 1.0,
        maxZ = 168.8 + 2.0
    }, {
        options = {
            {
                event = "",
                icon = "fas fa-chevron-circle-right",
                label = "Penyewaan Gudang",
            },
            {
                event = "dl-gudang:sewaKota",
                icon = "fas fa-warehouse",
                label = "Gudang Kota $DL 50.000",
            },
            {
                event = "dl-gudang:sewaPaleto",
                icon = "fas fa-warehouse",
                label = "Gudang Paleto $DL 50.000",
            },
        },
        distance = 2.0
    })

    exports["ox_target"]:AddBoxZone("StopSewa", vector3(-145.04, -638.0, 168.84), 1.5, 1.5, {
        name = "StopSewa",
        heading = 272.08,
        debugPoly = false,
        minZ = 168.8 - 1.0,
        maxZ = 168.8 + 2.0
    }, {
        options = {
        {
            event = "",
            icon = "fas fa-chevron-circle-right",
            label = "Berhenti sewa Gudang",
        },
        {
            event = "dl-gudang:stopKota",
            icon = "fas fa-warehouse",
            label = "Gudang Kota",
        },
        {
            event = "dl-gudang:stopPaleto",
            icon = "fas fa-warehouse",
            label = "Gudang Paleto",
        },
        },
        distance = 2.0
    })
end)


RegisterNetEvent('dl-gudang:MenuGudang')
AddEventHandler('dl-gudang:MenuGudang', function(k, gudang)
    ESX.TriggerServerCallback('dl-gudang:checkGudang', function(gudang)
        if gudang then
            Wait(1000)
            singNduwe = ESX.GetPlayerData().identifier
            exports.ox_inventory:openInventory('stash', {id = infoGudang .. ' - ' .. singNduwe, owner = singNduwe})
        else
            exports['midp-tasknotify']:SendAlert('error', 'Sewa dulu di gedung pemerintah')
        end
    end, infoGudang)
end)

RegisterNetEvent('dl-gudang:sewaKota')
AddEventHandler('dl-gudang:sewaKota', function()
    ESX.TriggerServerCallback('dl-gudang:checkGudang', function(gudang)
        if gudang then
            exports['midp-tasknotify']:SendAlert('error', 'Sudah memiliki gudang kota')
        else
            exports['midp-tasknotify']:SendAlert('success', 'Berhasil menyewa gudang kota')
            TriggerServerEvent('dl-gudang:tukuGudang', 'GudangPantai')
        end
    end, 'GudangPantai')
end)

RegisterNetEvent('dl-gudang:sewaPaleto')
AddEventHandler('dl-gudang:sewaPaleto', function()
    ESX.TriggerServerCallback('dl-gudang:checkGudang', function(gudang)
        if gudang then
            exports['midp-tasknotify']:SendAlert('error', 'Sudah memiliki gudang paleto')
        else
            exports['midp-tasknotify']:SendAlert('success', 'Berhasil menyewa gudang paleto')
            TriggerServerEvent('dl-gudang:tukuGudang', 'GudangPaleto')
        end
    end, 'GudangPaleto')
end)

-- STOP
RegisterNetEvent('dl-gudang:stopKota')
AddEventHandler('dl-gudang:stopKota', function()
    ESX.TriggerServerCallback('dl-gudang:checkGudang', function(gudang)
        TriggerServerEvent('dl-gudang:mandekGudang', 'GudangPantai')
    end, 'GudangPantai')
end)

RegisterNetEvent('dl-gudang:stopPaleto')
AddEventHandler('dl-gudang:stopPaleto', function()
    ESX.TriggerServerCallback('dl-gudang:checkGudang', function(gudang)
        TriggerServerEvent('dl-gudang:mandekGudang', 'GudangPaleto')
    end, 'GudangPaleto')
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
		
		for k, v in pairs (LokGudang) do
			local gudang_name = v.gudang_name
            local gudang_loc = v.location

            if (#(playerCoords - vector3( gudang_loc.x, gudang_loc.y, gudang_loc.z )) < 3.0) then
				isClose = true
                infoGudang = k
                Wait(10000)
            else
                Wait(1000)
			end
		end
        Wait(sleep)
	end
end)