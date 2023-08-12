Config = {}
Config.Enable = {}
Config.Timer = {}
Config.Debug = true
Config.DebugChance = true
Config.Enable.Shooting = true
Config.Locale = 'en'
Config.CheckVersion = false
Config.CheckVersionDelay = 60 -- Minutes

Citizen.CreateThread(function()
    if not GetPlayerPed(-1) then return end
    while not firstname do
        Citizen.Wait(10)
    end

    if notLoaded then
        for k, v in pairs(Config.Enable) do
            if Config.Enable[k] ~= false then
                Config[k] = {}
                Config.Timer[k] = 0 
                Config[k].Success = 300
                Config[k].Fail = 20
            end
        end

        if Config.Shooting then
            Config.Shooting.Success = 100 
            Config.Shooting.Fail = 0 
        end
            
        notLoaded = nil
    end

    Config.WeaponBlacklist = {
        'WEAPON_BAT',
        'WEAPON_GRENADE',
        'WEAPON_BZGAS',
        'WEAPON_MOLOTOV',
        'WEAPON_STICKYBOMB',
        'WEAPON_PROXMINE',
        'WEAPON_SNOWBALL',
        'WEAPON_PIPEBOMB',
        'WEAPON_BALL',
        'WEAPON_SMOKEGRENADE',
        'WEAPON_FLARE',
        'WEAPON_PETROLCAN',
        'WEAPON_FIREEXTINGUISHER',
        'WEAPON_HAZARDCAN',
        'WEAPON_RAYCARBINE',
        'WEAPON_STUNGUN'
    }
end)