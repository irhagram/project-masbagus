ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Code

ESX.RegisterServerCallback("midp-kunci:get:key:config", function(source, cb)
  cb(Config)
end)

ESX.RegisterServerCallback("midp-kunci:punyakunci", function(source, cb, plate)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if Config.VehicleKeys[plate] ~= nil then
        if Config.VehicleKeys[plate]['Identifier'] == Player.getIdentifier() and Config.VehicleKeys[plate]['HasKey'] then
            HasKey = true
        else
            HasKey = false
        end
    else
        HasKey = false
    end
    cb(HasKey)
end)

-- // Events \\ --

RegisterServerEvent('midp-kunci:setkunci')
AddEventHandler('midp-kunci:setkunci', function(Plate, bool)
  local Player = ESX.GetPlayerFromId(source)
  Config.VehicleKeys[Plate] = {['Identifier'] = Player.getIdentifier(), ['HasKey'] = bool}
  TriggerClientEvent('midp-kunci:setkunci', -1, Plate, Player.getIdentifier(), bool)
end)

RegisterServerEvent('midp-kunci:kasihkuncis')
AddEventHandler('midp-kunci:kasihkuncis', function(Target, Plate, bool)
  local Player = ESX.GetPlayerFromId(Target)
  if Player ~= nil then
    --TriggerClientEvent('midp-tasknotify:client:SendAlert', Player.PlayerData.source, { type = 'success', text = 'Menerima Kunci Dengan Plat: '..Plate})
    Config.VehicleKeys[Plate] = {['Identifier'] = Player.getIdentifier(), ['HasKey'] = bool}
    TriggerClientEvent('midp-kunci:setkunci', -1, Plate, Player.getIdentifier(), bool)
  end
end)