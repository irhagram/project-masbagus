ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Code

ESX.RegisterServerCallback("alan-kunci:get:key:config", function(source, cb)
  cb(Config)
end)

ESX.RegisterServerCallback("alan-kunci:punyakunci", function(source, cb, plate)
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

RegisterServerEvent('alan-kunci:setkunci')
AddEventHandler('alan-kunci:setkunci', function(Plate, bool)
  local Player = ESX.GetPlayerFromId(source)
  Config.VehicleKeys[Plate] = {['Identifier'] = Player.getIdentifier(), ['HasKey'] = bool}
  TriggerClientEvent('alan-kunci:setkunci', -1, Plate, Player.getIdentifier(), bool)
end)

RegisterServerEvent('alan-kunci:kasihkuncis')
AddEventHandler('alan-kunci:kasihkuncis', function(Target, Plate, bool)
  local Player = ESX.GetPlayerFromId(Target)
  if Player ~= nil then
    --TriggerClientEvent('alan-tasknotify:client:SendAlert', Player.PlayerData.source, { type = 'success', text = 'Menerima Kunci Dengan Plat: '..Plate})
    Config.VehicleKeys[Plate] = {['Identifier'] = Player.getIdentifier(), ['HasKey'] = bool}
    TriggerClientEvent('alan-kunci:setkunci', -1, Plate, Player.getIdentifier(), bool)
  end
end)