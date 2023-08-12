Config_Vangelico = {}

Config_Vangelico.Debug = true

Config_Vangelico.MinPolice = 5

Config_Vangelico.ResetTime = 60

Config_Vangelico.ShowBlip = true
Config_Vangelico.BlipCoords = vector3(-622.6827, -231.3588, 38.0570)
Config_Vangelico.UseAlarmSound = false

Config_Vangelico.Doors = {
    [1] = {
        Model       = 1425919976,
        Coordinates = vector3(-631.9554, -236.3333, 38.20653),
        Locked      = true,
    },
    [2] = {
        Model       = 9467943,
        Coordinates = vector3(-630.4265, -238.4375, 38.20653),
        Locked      = true,
    },
}

Config_Vangelico.Showcases = {
    S1 = {
        location = vector3(-626.35, -239.0, 38.06),
        heading = 306,
        zcoords = {37.81, 38.26},
        size = {1.2, 0.6,},
    },
    S2 = {
        location = vector3(-625.31, -238.27, 38.06),
        heading = 306,
        zcoords = {37.81, 38.26},
        size = {1.2, 0.6,},
    },
    S3 = {
        location = vector3(-627.2, -234.92, 38.06),
        heading = 306,
        zcoords = {37.81, 38.26},
        size = {1.2, 0.6,},
    },
    S4 = {
        location = vector3(-626.13, -234.15, 38.06),
        heading = 306,
        zcoords = {37.81, 38.26},
        size = {1.2, 0.6,},
    },
    S5 = {
        location = vector3(-626.57, -233.58, 38.06),
        heading = 306,
        zcoords = {37.81, 38.26},
        size = {1.2, 0.6,},
    },
    S6 = {
        location = vector3(-627.62, -234.34, 38.06),
        heading = 306,
        zcoords = {37.81, 38.26},
        size = {1.2, 0.6,},
    },
    S7 = {
        location = vector3(-624.0, -230.76, 38.06),
        heading = 306,
        zcoords = {37.81, 38.26},
        size = {0.6, 1.2,},
    },
    S8 = {
        location = vector3(-622.65, -232.61, 38.06),
        heading = 306,
        zcoords = {37.81, 38.26},
        size = {0.6, 1.2,},
    },
    S9 = {
        location = vector3(-620.49, -232.92, 38.06),
        heading = 36,
        zcoords = {37.81, 38.26},
        size = {0.6, 1.2,},
    },
    S10 = {
        location = vector3(-619.87, -234.89, 38.06),
        heading = 306,
        zcoords = {37.81, 38.26},
        size = {1.2, 0.6,},
    },
    S11 = {
        location = vector3(-618.82, -234.1, 38.06),
        heading = 306,
        zcoords = {37.81, 38.26},
        size = {1.2, 0.6,},
    },
    S12 = {
        location = vector3(-617.14, -230.19, 38.06),
        heading = 306,
        zcoords = {37.81, 38.26},
        size = {0.6, 1.2,},
    },
    S13 = {
        location = vector3(-617.89, -229.13, 38.06),
        heading = 306,
        zcoords = {37.81, 38.26},
        size = {0.6, 1.2,},
    },
    S14 = {
        location = vector3(-620.16, -230.77, 38.06),
        heading = 306,
        zcoords = {37.81, 38.26},
        size = {0.6, 1.2,},
    },
    S15 = {
        location = vector3(-621.49, -228.93, 38.06),
        heading = 36,
        zcoords = {37.81, 38.26},
        size = {1.2, 0.6,},
    },
    S16 = {
        location = vector3(-619.23, -227.26, 38.06),
        heading = 306,
        zcoords = {37.81, 38.26},
        size = {0.6, 1.2,},
    },
    S17 = {
        location = vector3(-619.99, -226.2, 38.06),
        heading = 306,
        zcoords = {37.81, 38.26},
        size = {0.6, 1.2,},
    },
    S18 = {
        location = vector3(-623.64, -228.59, 38.06),
        heading = 36,
        zcoords = {37.81, 38.26},
        size = {0.6, 1.2,},
    },
    S19 = {
        location = vector3(-624.26, -226.64, 38.06),
        heading = 36,
        zcoords = {37.81, 38.26},
        size = {0.6, 1.2,},
    },
    S20 = {
        location = vector3(-625.31, -227.39, 38.06),
        heading = 36,
        zcoords = {37.81, 38.26},
        size = {0.6, 1.2,},
    },
}

Config_Vangelico.ItemDrops  = {
    { name = 'diamond', min = 50, max = 55,  chance = 90 },
    { name = 'gold',  min = 270, max = 275, chance = 90 },
    { name = 'black_money',  min = 100000, max = 120000, chance = 90 },
    { name = 'laptop_h',  min = 1, max = 1, chance = 90 },
    { name = 'bank_card',  min = 1, max = 1, chance = 50 },
 }

 Config_Vangelico.AllowedWeapons = {
    { name = 'WEAPON_PISTOL', chance = 30 },
    { name = 'WEAPON_PISTOL50', chance = 35 },
    { name = 'WEAPON_REVOLVER_MK2', chance = 35 },
    { name = 'WEAPON_MICROSMG', chance = 40 },
    { name = 'WEAPON_MACHINEPISTOL', chance = 40 },
    { name = 'WEAPON_ASSAULTRIFLE', chance = 50 },
    { name = 'WEAPON_CROWBAR', chance = 18 },
 }

 Config_Vangelico.PoliceJobs =  {
    'police',
 }

 Config_Vangelico.UnAuthJobs = {
    'police', 
    'ambulance', 
 }
