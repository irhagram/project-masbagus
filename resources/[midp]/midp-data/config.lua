Config = {}

Config.PlateLetters  = 1
Config.PlateNumbers  = 5
Config.PlateUseSpace = true

Config.vehicleModel = "avanza"
Config.cashRewards = 50000
Config.bankRewards = 50000

Config.Zones = {
    CarSpawn = {
        Pos     = vector3(-1033.54, -2727.78, 20.17),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 247.37,
		Type    = -1
    },
    MarkerCoords = vector3(-1037.89, -2737.66, 20.17)
    
}

-- Chair Bed
Config_ChairBed = {}

Config_ChairBed.Healing = 0 -- // If this is 0, then its disabled.. Default: 3.. That means, if a person lies in a bed, then he will get 1 health every 3 seconds.

Config_ChairBed.objects = {
	SitAnimation = {anim='PROP_HUMAN_SEAT_CHAIR_MP_PLAYER'},
	BedBackAnimation = {dict='anim@gangops@morgue@table@', anim='ko_front'},
	BedStomachAnimation = {anim='WORLD_HUMAN_SUNBATHE'},
	BedSitAnimation = {anim='WORLD_HUMAN_PICNIC'},
	locations = {
		[2117668672] = {object=2117668672, verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-1.4, direction=0.0, bed=true},
		[1631638868] = {object=1631638868, verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-1.4, direction=0.0, bed=true},
		[-1519439119] = {object=-1519439119, verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-2.0, direction=0.0, bed=true},
		[-171943901] = {object=-171943901, verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-0.0, direction=168.0, bed=false},
		[1268458364] = {object=1268458364, verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-0.4, direction=168.0, bed=false},
		[96868307] = {object=96868307, verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-0.4, direction=168.0, bed=false},
		[1037469683] = {object=1037469683, verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-0.4, direction=168.0, bed=false},
		[867556671] = {object=867556671, verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-0.4, direction=168.0, bed=false},
		[-377849416] = {object=-377849416, verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-0.4, direction=168.0, bed=false},
		[-109356459] = {object=-109356459, verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-0.4, direction=168.0, bed=false},
		[-1091386327] = {object=-1091386327, verticalOffsetX=0.0, verticalOffsetY=0.13, verticalOffsetZ=-0.2, direction=90.0, bed=false},
		[536071214] = {object=536071214, verticalOffsetX=0.0, verticalOffsetY=-0.1, verticalOffsetZ=-0.5, direction=180.0, bed=false},
		[538002882] = {object=538002882, verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=0.1, direction=168.0, bed=false},
		[-1118419705] = {object=-1118419705, verticalOffsetX=0.0, verticalOffsetY=-0.1, verticalOffsetZ=-0.5, direction=168.0, bed=false},
		[-992710074] = {object=-992710074, verticalOffsetX=0.0, verticalOffsetY=-0.1, verticalOffsetZ=-0.7, direction=168.0, bed=false},
		[-1195678770] = {object=-1195678770, verticalOffsetX=0.0, verticalOffsetY=-0.1, verticalOffsetZ=-0.7, direction=5.0, bed=false},
		[-992735415] = {object=-992735415, verticalOffsetX=0.0, verticalOffsetY=-0.0, verticalOffsetZ=0.1, direction=180.0, bed=false},
		[-1761659350] = {object=-1761659350, verticalOffsetX=0.0, verticalOffsetY=-0.0, verticalOffsetZ=-0.5, direction=180.0, bed=false},
		[-1626066319] = {object=-1626066319, verticalOffsetX=0.0, verticalOffsetY=-0.0, verticalOffsetZ=0.1, direction=180.0, bed=false},
        [1570477186] = {object=1570477186, verticalOffsetX=0.0, verticalOffsetY=-0.0, verticalOffsetZ=-1.4, direction=180.0, bed=true},
        [28672923] = {object=28672923, verticalOffsetX=0.0, verticalOffsetY=-0.0, verticalOffsetZ=-0.6, direction=180.0, bed=false},
        [449297510] = {object=449297510, verticalOffsetX=0.0, verticalOffsetY=-0.0, verticalOffsetZ=0.1, direction=180.0, bed=false},
        [-293380809] = {object=-293380809, verticalOffsetX=0.0, verticalOffsetY=-0.0, verticalOffsetZ=-0.5, direction=180.0, bed=false},
        [159496659] = {object=159496659, verticalOffsetX=0.0, verticalOffsetY=-0.0, verticalOffsetZ=-0.7, direction=0.0, bed=true},
        [-1544802998] = {object=-1544802998, verticalOffsetX=0.0, verticalOffsetY=-0.0, verticalOffsetZ=-1.4, direction=180.0, bed=true},
        [-1182962909] = {object=-1182962909, verticalOffsetX=0.0, verticalOffsetY=-0.0, verticalOffsetZ=-1.4, direction=180.0, bed=true},     
        [535565992] = {object=535565992, verticalOffsetX=0.0, verticalOffsetY=-0.0, verticalOffsetZ=-1.4, direction=180.0, bed=true}
	}
}

Config_ChairBed.seats = {
	538002882, -- MRPD Chairs 
	-1118419705, -- MRPD Chairs 
	-992710074, -- Pillbox Stools
	-109356459, -- Chairs in Pillbox
	-992735415, -- Chair in Sandy Customs Office
	-1761659350, -- Vineyard Wood Chair
	-1626066319, -- Stumpys Office Chair
	-171943901, 
	1268458364, 
	96868307, 
	1037469683, 
	867556671, 
	-377849416, 
	-1091386327, 
	536071214, 
	-1195678770,
    28672923,    
    449297510,
    -293380809,

}

Config_ChairBed.beds = {
	1631638868, -- Hospital Beds 
	2117668672, -- Hospital Beds 
	-1519439119, -- MRI Machine Pillbox
    1570477186, --OCEAN
    535565992, --OCEAN2
    159496659,
    -1544802998,
    -1182962909,




}

-- Weapon On Back
Rifles = {
    ['WEAPON_HEAVYSNIPER']        = {model = 'w_sr_heavysniper',    front = false},
    ['WEAPON_HEAVYSNIPER_MK2']    = {model = 'w_sr_heavysniper',    front = true},
    ['WEAPON_ADVANCEDRIFLE']      = {model = 'w_ar_advancedrifle',  front = false},
    ['WEAPON_ASSAULTRIFLE']       = {model = 'w_ar_assaultrifle',   front = false},
    ['WEAPON_ASSAULTRIFLE_MK2']   = {model = 'w_ar_assaultrifle',   front = true},
    ['WEAPON_SPECIALCARBINE']     = {model = 'w_ar_specialcarbine', front = true},
    ['WEAPON_SPECIALCARBINE_MK2'] = {model = 'w_ar_specialcarbine', front = true},
    ['WEAPON_BULLPUPRIFLE']       = {model = 'w_ar_bullpuprifle',   front = true},
    ['WEAPON_BULLPUPRIFLE_MK2']   = {model = 'w_ar_bullpuprifle',   front = true},
    ['WEAPON_ASSAULTSHOTGUN']     = {model = 'w_sg_assaultshotgun', front = true},
    ['WEAPON_ASSAULTSMG']         = {model = 'w_sb_assaultsmg',     front = true},
    ['WEAPON_CARBINERIFLE']       = {model = 'w_ar_specialcarbine', front = true},
    ['WEAPON_CARBINERIFLE_MK2']   = {model = 'w_ar_carbinerifle',   front = true},
    ['WEAPON_BULLPUPSHOTGUN']     = {model = 'w_sg_bullpupshotgun', front = true},
    ['WEAPON_COMBATSHOTGUN']      = {model = 'w_sg_pumpshotgun',    front = true},
    ['WEAPON_GUSENBERG']          = {model = 'w_sb_gusenberg',      front = true},
    ['WEAPON_SMG']                = {model = 'w_sb_smg',            front = true},
    ['WEAPON_SMG_MK2']            = {model = 'w_sb_smg',            front = true},
    ['WEAPON_HEAVYSHOTGUN']       = {model = 'w_sg_heavyshotgun',   front = true},
    ['WEAPON_MARKSMANRIFLE']      = {model = 'w_sr_marksmanrifle',  front = true},
    ['WEAPON_MICROSMG']           = {model = 'w_sb_microsmg',       front = true},
    ['WEAPON_PUMPSHOTGUN']        = {model = 'w_sg_pumpshotgun',    front = true},
    ['WEAPON_PUMPSHOTGUN_MK2']    = {model = 'w_sg_pumpshotgun',    front = true},
    ['WEAPON_SAWNOFFSHOTGUN']     = {model = 'w_sg_sawnoff',        front = true},
    ['WEAPON_SNIPERRIFLE']        = {model = 'w_sr_sniperrifle',    front = true},
    ['WEAPON_COMBATPDW']          = {model = 'w_sb_smg',            front = true},
    ['WEAPON_DBSHOTGUN']          = {model = 'w_sg_sawnoff',        front = true},
    ['WEAPON_COMPACTRIFLE']       = {model = 'w_ar_assaultrifle',   front = true},
}

--GYM--
Config.Exercises = {
    ['Pushups'] = {
        ['idleDict'] = 'amb@world_human_push_ups@male@idle_a',
        ['idleAnim'] = 'idle_c',
        ['actionDict'] = 'amb@world_human_push_ups@male@base',
        ['actionAnim'] = 'base',
        ['actionTime'] = 1100,
        ['enterDict'] = 'amb@world_human_push_ups@male@enter',
        ['enterAnim'] = 'enter',
        ['enterTime'] = 3050,
        ['exitDict'] = 'amb@world_human_push_ups@male@exit',
        ['exitAnim'] = 'exit',
        ['exitTime'] = 3400,
        ['actionProcent'] = 1,
        ['actionProcentTimes'] = 3,
    },
    ['Situps'] = {
        ['idleDict'] = 'amb@world_human_sit_ups@male@idle_a',
        ['idleAnim'] = 'idle_a',
        ['actionDict'] = 'amb@world_human_sit_ups@male@base',
        ['actionAnim'] = 'base',
        ['actionTime'] = 3400,
        ['enterDict'] = 'amb@world_human_sit_ups@male@enter',
        ['enterAnim'] = 'enter',
        ['enterTime'] = 4200,
        ['exitDict'] = 'amb@world_human_sit_ups@male@exit',
        ['exitAnim'] = 'exit', 
        ['exitTime'] = 3700,
        ['actionProcent'] = 1,
        ['actionProcentTimes'] = 10,
    },
    ['Chins'] = {
        ['idleDict'] = 'amb@prop_human_muscle_chin_ups@male@idle_a',
        ['idleAnim'] = 'idle_a',
        ['actionDict'] = 'amb@prop_human_muscle_chin_ups@male@base',
        ['actionAnim'] = 'base',
        ['actionTime'] = 3000,
        ['enterDict'] = 'amb@prop_human_muscle_chin_ups@male@enter',
        ['enterAnim'] = 'enter',
        ['enterTime'] = 1600,
        ['exitDict'] = 'amb@prop_human_muscle_chin_ups@male@exit',
        ['exitAnim'] = 'exit',
        ['exitTime'] = 3700,
        ['actionProcent'] = 1,
        ['actionProcentTimes'] = 10,
    },
    ['Chins2'] = {
        ['idleDict'] = 'amb@prop_human_muscle_chin_ups@male@idle_a',
        ['idleAnim'] = 'idle_a',
        ['actionDict'] = 'amb@prop_human_muscle_chin_ups@male@base',
        ['actionAnim'] = 'base',
        ['actionTime'] = 3000,
        ['enterDict'] = 'amb@prop_human_muscle_chin_ups@male@enter',
        ['enterAnim'] = 'enter',
        ['enterTime'] = 1600,
        ['exitDict'] = 'amb@prop_human_muscle_chin_ups@male@exit',
        ['exitAnim'] = 'exit',
        ['exitTime'] = 3700,
        ['actionProcent'] = 1,
        ['actionProcentTimes'] = 10,
    },
}

Config.Locations = {
    {['x'] = -1204.735, ['y'] = -1564.33, ['z'] = 4.62 - 0.98, ['h'] = 38.0, ['exercise'] = 'Chins'},
    {['x'] = 1775.9310302734, ['y'] = 2497.4399414063, ['z'] = 45.82345199585 - 0.98, ['h'] = 38.0, ['exercise'] = 'Chins'}, --PENJARA
    {['x'] = -1200.08,  ['y'] = -1571.15, ['z'] = 4.62 - 0.98, ['h'] = 218.2, ['exercise'] = 'Chins2'},
    {['x'] = 1779.3020019531,  ['y'] = 2496.8039550781, ['z'] = 45.823650360107 - 0.98, ['h'] = nil, ['situp'] = 'Situps'}, --PENJARA
    --PANTAI--
    --PUSHUP--
    {['x'] = -1202.23, ['y'] = -1570.91, ['z'] = 4.62 - 0.98, ['h'] = nil, ['pushap'] = 'Pushups'},
    {['x'] = -1202.7945556641, ['y'] = -1570.8443603516, ['z'] = 4.62 - 0.98, ['h'] = nil, ['pushap'] = 'Pushups'},
    {['x'] = -1202.2553710938, ['y'] = -1570.2453613281, ['z'] = 4.62 - 0.98, ['h'] = nil, ['pushap'] = 'Pushups'},
    {['x'] = -1201.4760742188, ['y'] = -1571.4167480469, ['z'] = 4.62 - 0.98, ['h'] = nil, ['pushap'] = 'Pushups'},
    {['x'] = -1202.7517089844, ['y'] = -1569.9749755859, ['z'] = 4.62 - 0.98, ['h'] = nil, ['pushap'] = 'Pushups'},
    {['x'] = -1202.5794677734, ['y'] = -1572.1123046875, ['z'] = 4.62 - 0.98, ['h'] = nil, ['pushap'] = 'Pushups'},
    --SITUP--
    {['x'] = -1204.4102783203,  ['y'] = -1562.025390625, ['z'] = 4.6151666641235 - 0.98, ['h'] = nil, ['situp'] = 'Situps'},
    {['x'] = -1203.0529785156,  ['y'] = -1562.1695556641, ['z'] = 4.6151666641235 - 0.98, ['h'] = nil, ['situp'] = 'Situps'},
    {['x'] = -1205.3334960938,  ['y'] = -1561.8770751953,['z'] = 4.6151666641235 - 0.98, ['h'] = nil, ['situp'] = 'Situps'},
    {['x'] = -1205.0620117188,  ['y'] = -1560.8741455078, ['z'] = 4.6151666641235 - 0.98, ['h'] = nil, ['situp'] = 'Situps'},
    {['x'] = -1203.9013671875,  ['y'] = -1559.9353027344, ['z'] = 4.6151666641235 - 0.98, ['h'] = nil, ['situp'] = 'Situps'},
    {['x'] = -1205.0863037109,  ['y'] = -1560.1087646484, ['z'] = 4.6151666641235 - 0.98, ['h'] = nil, ['situp'] = 'Situps'},
    --PENJARA--
    {['x'] = 1777.5655517578, ['y'] = 2493.7763671875, ['z'] = 45.838733673096 - 0.98, ['h'] = nil, ['pushap'] = 'Pushups'},
}