Config_Fleeca = {}
Config_Fleeca.hacktime = 1000 -- first door open delay to make time for police to arrive and roleplay in miliseconds (I highly recommend to leave it be (2.5 min default))
Config_Fleeca.maxcash = 85000 -- maximum amount of cash a pile can hold
Config_Fleeca.mincash = 65000 -- minimum amount of cash a pile holds
Config_Fleeca.black = true -- enable this if you want blackmoney as a reward
Config_Fleeca.cooldown = 600 -- amount of time to do the heist again in seconds (15min)
Config_Fleeca.mincops = 0 -- minimum required cops to start mission harusnya 6
Config_Fleeca.vaultdoor = "v_ilev_gb_vauldr"
Config_Fleeca.door = "v_ilev_gb_vaubar"
Config_Fleeca.office = "v_ilev_gb_teldr"
Config_Fleeca.Banks = {
    F1 = {
        doors = {
            startloc = {x = 310.93, y = -284.44, z = 54.16, h = -90.00, animcoords = {x = 311.05, y = -284.00, z = 53.16, h = 248.60}},
            secondloc = {x = 312.93, y = -284.45, z = 54.16, h = 160.91, animcoords = {x = 313.41, y = -284.42, z = 53.16, h = 160.91}},
        },
        prop = {
            first = {coords = vector3(311.5481, -284.5114, 54.285), rot = vector3(90.0, 180.0, 21.0)},
            second = {coords = vector3(312.90, -284.95, 54.285), rot = vector3(90.0, 180.0, 110.0)}
        },
        trolley1 = {x = 313.45, y = -289.24, z = 53.14, h = -15},
        objects = {
            vector3(313.45, -289.24, 53.14)
        },
        loot1 = false,
        onaction = false,
        lastrobbed = 0
    },
    F2 = {
        doors = {
            startloc = {x = 146.61, y = -1046.02, z = 29.37, h = 244.20, animcoords = {x = 146.75, y = -1045.60, z = 28.37, h = 244.20}},
            secondloc = {x = 148.76, y = -1045.89, z = 29.37, h = 158.54, animcoords = {x = 149.10, y = -1046.08, z = 28.37, h = 158.54}}
        },
        prop = {
            first = {coords = vector3(147.22, -1046.148, 29.487), rot = vector3(90.0, 180.0, 20.0)},
            second = {coords = vector3(148.57, -1046.578, 29.487), rot = vector3(90.0, 180.0, 110.0)}
        },
        trolley1 = {x = 147.25, y = -1050.38, z = 28.35, h = -15},
        objects = {
            vector3(147.25, -1050.38, 28.35)
        },
        loot1 = false,
        onaction = false,
        lastrobbed = 0
    },
    F3 = {
        doors = {
            startloc = {x = -1211.07, y = -336.68, z = 37.78, h = 296.76, animcoords = {x = -1211.25, y = -336.37, z = 36.78, h = 296.76}}, 
            secondloc = {x = -1209.66, y = -335.15, z = 37.78, h = 213.67, animcoords = {x = -1209.40, y = -335.05, z = 36.78, h = 213.67}}
        },
        prop = {
            first = {coords = vector3(-1210.50, -336.37, 37.901), rot = vector3(-90.0, 0.0, 25.0)},
            second = {coords = vector3(-1209.27, -335.68, 37.90), rot = vector3(90.0, 180.0, 65.0)}
        },
        trolley1 = {x = -1207.50, y = -339.20, z = 36.76, h = 30},
        objects = {
            vector3(-1207.50, -339.20, 36.76)
        },
        loot1 = false,
        onaction = false,
        lastrobbed = 0
    },
    F4 = {
        hash = 4231427725, -- exception
        doors = {
            startloc = {x = -2956.68, y = 481.34, z = 15.70, h = 353.97, animcoords = {x = -2956.68, y = 481.34, z = 14.70, h = 353.97}},
            secondloc = {x = -2957.26, y = 483.53, z = 15.70, h = 267.73, animcoords = {x = -2957.26, y = 483.53, z = 14.70, h = 267.73}}
        },
        prop = {
            first = {coords = vector3(-2956.59, 482.05, 15.815), rot = vector3(90.0, 180.0, -88.0)},
            second = {coords = vector3(-2956.60, 483.46, 15.815), rot = vector3(90.0, 180.0, 3.0)}
        },
        trolley1 = {x = -2952.69, y = 483.34, z = 14.68, h = 85},
        objects = {
            vector3(-2952.69, 483.34, 14.68)
        },
        loot1 = false,
        onaction = false,
        lastrobbed = 0
    },
    F5 = {
        doors = {
            startloc = {x = -354.15, y = -55.11, z = 49.04, h = 251.05, animcoords = {x = -354.15, y = -55.11, z = 48.04, h = 251.05}},
            secondloc = {x = -351.97, y = -55.18, z = 49.04, h = 159.79, animcoords = {x = -351.97, y = -55.18, z = 48.04, h = 159.79}}
        },
        prop = {
            first = {coords = vector3(-353.50, -55.37, 49.157), rot = vector3(90.0, 180.0, 20.0)},
            second = {coords = vector3(-352.15, -55.77, 49.157), rot = vector3(90.0, 180.0, 110.0)}
        },
        trolley1 = {x = -353.34, y = -59.48, z = 48.01, h = -15},
        objects = {
            vector3(-353.34, -59.48, 48.01)
        },
        loot1 = false,
        onaction = false,
        lastrobbed = 0
    },
    F6 = {
        doors = {
            startloc = {x = 1176.40, y = 2712.75, z = 38.09, h = 84.83, animcoords = {x = 1176.40, y = 2712.75, z = 37.09, h = 84.83}},
            secondloc = {x = 1174.24, y = 2712.47, z = 38.09, h = 359.05, animcoords = {x = 1174.33, y = 2712.09, z = 37.09, h = 359.05}}
        },
        prop = {
            first = {coords = vector3(1175.70, 2712.82, 38.207), rot = vector3(90.0, 180.0, 180.0)},
            second = {coords = vector3(1174.267, 2712.736, 38.207), rot = vector3(90.0, 180.0, -90.0)}
        },
        trolley1 = {x = 1174.24, y = 2716.69, z = 37.07, h = -180},
        objects = {
            vector3(1174.24, 2716.69, 37.07)
        },
        loot1 = false,
        onaction = false,
        lastrobbed = 0
    }
}
