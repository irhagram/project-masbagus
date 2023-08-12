Config                            = {}

Config.PolisiDrawDistance               = 20.0
Config.PolisiMarkerType                 = 1
Config.PolisiMarkerSize                 = { x = 1.5, y = 1.5, z = 0.5 }
Config.PolisiMarkerColor                = { r = 50, g = 50, b = 204 }

Config.PolisiEnablePlayerManagement     = true
Config.PolisiEnableArmoryManagement     = true
Config.PolisiEnableESXIdentity          = true -- enable if you're using esx_identity
Config.PolisiEnableNonFreemodePeds      = true -- turn this on if you want custom peds
Config.PolisiEnableLicenses             = true -- enable if you're using esx_license
Config.EnableNonFreemodePeds			= false

Config.PolisiEnableHandcuffTimer        = false -- enable handcuff timer? will unrestrain player after the time ends
Config.PolisiHandcuffTimer              = 10 * 60000 -- 10 mins

Config.PolisiEnableJobBlip              = true -- enable blips for colleagues, requires esx_society

Config.PolisiMaxInService               = -1
Config.Locale = 'en'

Config.PoliceStations = {

	LSPD = {

		Blip = {
			Coords  = vector3(425.1, -979.5, 30.7),
			Sprite  = 60,
			Display = 5,
			Scale   = 0.7,
			Colour  = 29
		},

		Cloakrooms = {
			vector3(451.81344604492,-993.36560058594,30.689535140991),
		},

		Armories = {
			vector3(454.10073852539,-980.25006103516,30.689544677734),
			vector3(467.68682861328,-992.69488525391,24.920818328857),
		},

		Vehicles = {
			{
				Spawner = vector3(457.78137207031, -1011.5294799805, 28.307106018066),
				InsideShop = vector3(449.53, -1021.29, 28.40),
				SpawnPoints = {
					{coords = vector3(447.36019897461, -1018.7012939453, 27.578824996948), heading = 92.52, radius = 6.0},
					{coords = vector3(432.9137878418, -1019.3269042969, 27.868848800659), heading = 92.52, radius = 6.0},
					{coords = vector3(421.15014648438, -1026.5518798828, 28.097103118896), heading = 92.28, radius = 6.0},
				}
			},
		},

		Helicopters = {
			{
				Spawner = vector3(461.1, -981.5, 43.6),
				InsideShop = vector3(481.83, -982.29, 41.01),
				SpawnPoints = {
					{coords = vector3(449.5, -981.2, 43.6), heading = 92.6, radius = 10.0}
				}
			}
		},

		BossActions = {
			vector3(448.07135009766,-973.0699759375,30.689540863037)
		}

	},
	LSPD2 = {

		Blip = {
			Coords  = vector3(367.68, -1598.34, 29.29),
			Sprite  = 60,
			Display = 4,
			Scale   = 0.7,
			Colour  = 29
		},

		Cloakrooms = {
			vector3(381.85, -1609.31, 29.29)
		},

		Armories = {
			vector3(367.68, -1598.34, 29.29)
		},

		Vehicles = {
			{
				Spawner = vector3(380.89398199759,-1612.5625,29.292043685913),
				InsideShop = vector3(449.53, -1021.29, 28.40),
				SpawnPoints = {
					{coords = vector3(387.30349731445,-1616.0295410156,29.292051315308), heading = 16.61, radius = 6.0},
					{coords = vector3(387.30349731445,-1616.0295410156,29.292051315308), heading = 16.29, radius = 6.0},
				}
			},
		},

		Helicopters = {
			{
				Spawner = vector3(377.55, -1598.6, 36.92),
				InsideShop = vector3(481.83, -982.29, 41.01),
				SpawnPoints = {
					{coords = vector3(362.9, -1598.3, 36.95), heading = 139.53, radius = 10.0}
				}
			}
		},

		BossActions = {
			vector3(387.96, -1601.97, 29.29)
		}

	},
	LSPD3 = {

		Blip = {
			Coords  = vector3(-447.31521606445, 6013.3227539063, 31.716352462769),
			Sprite  = 60,
			Display = 4,
			Scale   = 0.7,
			Colour  = 29
		},

		Cloakrooms = {
			vector3(-453.31994628906,6017.6572265625,31.716272354126)
		},

		Armories = {
			vector3(-437.95358276367,5988.6313476562,31.71618270874)
		},

		Vehicles = {
			{
				Spawner = vector3(-456.07272978867, 6009.890625, 31.490112304688),
				InsideShop = vector3(449.53, -1021.29, 28.40),
				SpawnPoints = {
					{coords = vector3(1858.36328125,2588.8359375,45.672008514404), heading = 39.2, radius = 6.0},
				}
			},
		},

		Helicopters = {
			{
				Spawner = vector3(-459.88314819976, 5989.6689453125, 31.321088790894),
				InsideShop = vector3(481.83, -982.29, 41.01),
				SpawnPoints = {
					{coords = vector3(-475.24, 5988.41, 31.321088790894), heading = 317.52, radius = 10.0}
				}
			}
		},

		BossActions = {
			vector3(-433.11486816406,6002.3466796875,31.716213226318)
		}

	},
	LSPD4 = {

		Blip = {
			Coords  = vector3(-447.31521606445, 6013.3227539063, 31.716352462769),
			Sprite  = 60,
			Display = 4,
			Scale   = 0.7,
			Colour  = 29
		},

		Cloakrooms = {
			vector3(1849.42, 3695.76, 34.27)
		},

		Armories = {
			vector3(1841.93, 3691.31, 34.32)
		},

		Vehicles = {
			{
				Spawner = vector3(1857.73, 3707.17, 33.53),
				InsideShop = vector3(449.53, -1021.29, 28.40),
				SpawnPoints = {
					{coords = vector3(1868.2541503906,3696.5786132812,32.760291290283), heading = 210.12, radius = 6.0},
				}
			},
		},

		Helicopters = {
			{
				Spawner = vector3(1868.1662597656,3659.3439941406,33.872077941895),
				InsideShop = vector3(481.83, -982.29, 41.01),
				SpawnPoints = {
					{coords = vector3(1870.8137207031,3645.46875,33.90701675415), heading = 25.96, radius = 10.0}
				}
			}
		},

		BossActions = {
			vector3(1861.9217529297,3689.6372070312,34.261726379395)
		}

	},
	LSPD5 = {

		Blip = {
			Coords  = vector3(-447.31521606445, 6013.3227539063, 31.716352462769),
			Sprite  = 60,
			Display = 4,
			Scale   = 0.7,
			Colour  = 29
		},

		Cloakrooms = {
			vector3(-1624.6911621094,-1034.5935058594,13.145440101624)
		},

		Armories = {
			vector3(-1617.7987060547,-1029.8869628906,13.152540206909)
		},

		Vehicles = {
			{
				Spawner = vector3(-462.86,6019.33,31.35),
				InsideShop = vector3(-462.86,6019.33,31.35),
				SpawnPoints = {
					{coords = vector3(-462.86,6019.33,31.35), heading = 309.75, radius = 6.0},
				}
			},
		},

		Helicopters = {
			{
				Spawner = vector3(-1606.8292236328,-1027.2923583984,13.091463088989),
				InsideShop = vector3(481.83, -982.29, 41.01),
				SpawnPoints = {
					{coords = vector3(-1599.0959472656,-1034.3076171875,13.033041000366), heading = 318.39, radius = 10.0}
				}
			}
		},

		BossActions = {
			vector3(-1617.2271728516,-1017.5680541992,13.145432472229)
		}

	},
	LSPD6 = {

		Blip = {
			Coords  = vector3(1684.0083007812,2578.5625,45.911502838135),
			Sprite  = 60,
			Display = 4,
			Scale   = 0.7,
			Colour  = 29
		},

		Cloakrooms = {
			vector3(1696.9069824219,2575.0075683594,45.911483764648)
		},

		Armories = {
			vector3(1681.2194824219,2574.5942382812,45.911502838135)
		},

		Vehicles = {
			{
				Spawner = vector3(1852.7407226562,2581.8811035156,45.672031402588),
				InsideShop = vector3(449.53, -1021.29, 28.40),
				SpawnPoints = {
					{coords = vector3(1855.4694824219,2579.2541503906,45.672031402588), heading = 269.42, radius = 6.0},
				}
			},
		},

		Helicopters = {
			{
				Spawner = vector3(1684.791015625,2574.5373535156,50.619781494141),
				InsideShop = vector3(481.83, -982.29, 41.01),
				SpawnPoints = {
					{coords = vector3(1690.4096679688,2583.3032226562,50.78385925293), heading = 359.09, radius = 10.0}
				}
			}
		},

		BossActions = {
			vector3(-1617.2271728516,-1017.5680541992,13.145432472229)
		}

	},

}

Config.PolisiAuthorizedWeapons = {
	kombes = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 10000 },
		{ weapon = 'WEAPON_BULLPUPSHOTGUN', components = { 2000, 6000, 6000 }, price = 15000 },
		{ weapon = 'WEAPON_SMG', components = { 2000, 6000, 6000 }, price = 20000 },
		{ weapon = 'WEAPON_CARBINERIFLE',  components = { 6000, 6000, nil, 6000, nil, 6000, 6000 }, price = 25000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 20000 },
		{ weapon = 'WEAPON_SPECIALCARBINE',  price = 25000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_HEAVYSNIPER', price = 100000 },
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 10000 },
		{ weapon = 'GADGET_PARACHUTE', price = 10000 },
		{ weapon = 'WEAPON_PISTOL_MK2', price = 10000},
		{ weapon = 'WEAPON_PISTOL', price = 10000 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }

	},

	brigjen = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 10000 },
		{ weapon = 'WEAPON_BULLPUPSHOTGUN', components = { 2000, 6000, 6000 }, price = 15000 },
		{ weapon = 'WEAPON_SMG', components = { 2000, 6000, 6000 }, price = 20000 },
		{ weapon = 'WEAPON_CARBINERIFLE',  components = { 6000, 6000, nil, 6000, nil, 6000, 6000 }, price = 25000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 20000 },
		{ weapon = 'WEAPON_SPECIALCARBINE',  price = 25000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_HEAVYSNIPER', price = 100000 },
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 10000 },
		{ weapon = 'GADGET_PARACHUTE', price = 10000 },
		{ weapon = 'WEAPON_PISTOL_MK2', price = 10000},
		{ weapon = 'WEAPON_PISTOL', price = 10000 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }

	},

	brigjen2 = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 10000 },
		{ weapon = 'WEAPON_BULLPUPSHOTGUN', components = { 2000, 6000, 6000 }, price = 15000 },
		{ weapon = 'WEAPON_SMG', components = { 2000, 6000, 6000 }, price = 20000 },
		{ weapon = 'WEAPON_CARBINERIFLE',  components = { 6000, 6000, nil, 6000, nil, 6000, 6000 }, price = 25000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 20000 },
		{ weapon = 'WEAPON_SPECIALCARBINE',  price = 25000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_HEAVYSNIPER', price = 100000 },
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 10000 },
		{ weapon = 'GADGET_PARACHUTE', price = 10000 },
		{ weapon = 'WEAPON_PISTOL_MK2', price = 10000},
		{ weapon = 'WEAPON_PISTOL', price = 10000 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }

	},

	brigjen3 = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 10000 },
		{ weapon = 'WEAPON_BULLPUPSHOTGUN', components = { 2000, 6000, 6000 }, price = 15000 },
		{ weapon = 'WEAPON_SMG', components = { 2000, 6000, 6000 }, price = 20000 },
		{ weapon = 'WEAPON_CARBINERIFLE',  components = { 6000, 6000, nil, 6000, nil, 6000, 6000 }, price = 25000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 20000 },
		{ weapon = 'WEAPON_SPECIALCARBINE',  price = 25000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_HEAVYSNIPER', price = 100000 },
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 10000 },
		{ weapon = 'GADGET_PARACHUTE', price = 10000 },
		{ weapon = 'WEAPON_PISTOL_MK2', price = 10000},
		{ weapon = 'WEAPON_PISTOL', price = 10000 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }

	},

	komjen = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 10000 },
		{ weapon = 'WEAPON_BULLPUPSHOTGUN', components = { 2000, 6000, 6000 }, price = 15000 },
		{ weapon = 'WEAPON_SMG', components = { 2000, 6000, 6000 }, price = 20000 },
		{ weapon = 'WEAPON_CARBINERIFLE',  components = { 6000, 6000, nil, 6000, nil, 6000, 6000 }, price = 25000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 20000 },
		{ weapon = 'WEAPON_SPECIALCARBINE',  price = 25000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_HEAVYSNIPER', price = 100000 },
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 10000 },
		{ weapon = 'GADGET_PARACHUTE', price = 10000 },
		{ weapon = 'WEAPON_PISTOL', price = 10000 },
		{ weapon = 'WEAPON_PISTOL_MK2', price = 10000},
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
		
	},

	komjen2 = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 10000 },
		{ weapon = 'WEAPON_BULLPUPSHOTGUN', components = { 2000, 6000, 6000 }, price = 15000 },
		{ weapon = 'WEAPON_SMG', components = { 2000, 6000, 6000 }, price = 20000 },
		{ weapon = 'WEAPON_CARBINERIFLE',  components = { 6000, 6000, nil, 6000, nil, 6000, 6000 }, price = 25000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 20000 },
		{ weapon = 'WEAPON_SPECIALCARBINE',  price = 25000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_HEAVYSNIPER', price = 100000 },
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 10000 },
		{ weapon = 'GADGET_PARACHUTE', price = 10000 },
		{ weapon = 'WEAPON_PISTOL', price = 10000 },
		{ weapon = 'WEAPON_PISTOL_MK2', price = 10000},
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
		
	},

	komjen3 = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 10000 },
		{ weapon = 'WEAPON_BULLPUPSHOTGUN', components = { 2000, 6000, 6000 }, price = 15000 },
		{ weapon = 'WEAPON_SMG', components = { 2000, 6000, 6000 }, price = 20000 },
		{ weapon = 'WEAPON_CARBINERIFLE',  components = { 6000, 6000, nil, 6000, nil, 6000, 6000 }, price = 25000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 20000 },
		{ weapon = 'WEAPON_SPECIALCARBINE',  price = 25000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_HEAVYSNIPER', price = 100000 },
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 10000 },
		{ weapon = 'GADGET_PARACHUTE', price = 10000 },
		{ weapon = 'WEAPON_PISTOL', price = 10000 },
		{ weapon = 'WEAPON_PISTOL_MK2', price = 10000},
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
		
	},

	irjen = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 10000 },
		{ weapon = 'WEAPON_BULLPUPSHOTGUN', components = { 2000, 6000, 6000 }, price = 15000 },
		{ weapon = 'WEAPON_SMG', components = { 2000, 6000, 6000 }, price = 20000 },
		{ weapon = 'WEAPON_CARBINERIFLE',  components = { 6000, 6000, nil, 6000, nil, 6000, 6000 }, price = 25000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 20000 },
		{ weapon = 'WEAPON_SPECIALCARBINE',  price = 25000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_HEAVYSNIPER', price = 100000 },
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 10000 },
		{ weapon = 'GADGET_PARACHUTE', price = 10000 },
		{ weapon = 'WEAPON_PISTOL', price = 10000 },
		{ weapon = 'WEAPON_PISTOL_MK2', price = 10000},
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	irjen2 = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 10000 },
		{ weapon = 'WEAPON_BULLPUPSHOTGUN', components = { 2000, 6000, 6000 }, price = 15000 },
		{ weapon = 'WEAPON_SMG', components = { 2000, 6000, 6000 }, price = 20000 },
		{ weapon = 'WEAPON_CARBINERIFLE',  components = { 6000, 6000, nil, 6000, nil, 6000, 6000 }, price = 25000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 20000 },
		{ weapon = 'WEAPON_SPECIALCARBINE',  price = 25000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_HEAVYSNIPER', price = 100000 },
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 10000 },
		{ weapon = 'GADGET_PARACHUTE', price = 10000 },
		{ weapon = 'WEAPON_PISTOL', price = 10000 },
		{ weapon = 'WEAPON_PISTOL_MK2', price = 10000},
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	irjen3 = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 10000 },
		{ weapon = 'WEAPON_BULLPUPSHOTGUN', components = { 2000, 6000, 6000 }, price = 15000 },
		{ weapon = 'WEAPON_SMG', components = { 2000, 6000, 6000 }, price = 20000 },
		{ weapon = 'WEAPON_CARBINERIFLE',  components = { 6000, 6000, nil, 6000, nil, 6000, 6000 }, price = 25000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 20000 },
		{ weapon = 'WEAPON_SPECIALCARBINE',  price = 25000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_HEAVYSNIPER', price = 100000 },
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 10000 },
		{ weapon = 'GADGET_PARACHUTE', price = 10000 },
		{ weapon = 'WEAPON_PISTOL', price = 10000 },
		{ weapon = 'WEAPON_PISTOL_MK2', price = 10000},
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	boss = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 10000 },
		{ weapon = 'WEAPON_BULLPUPSHOTGUN', components = { 2000, 6000, 6000 }, price = 15000 },
		{ weapon = 'WEAPON_SMG', components = { 2000, 6000, 6000 }, price = 20000 },
		{ weapon = 'WEAPON_CARBINERIFLE',  components = { 6000, 6000, nil, 6000, nil, 6000, 6000 }, price = 25000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', price = 20000 },
		{ weapon = 'WEAPON_SPECIALCARBINE',  price = 25000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_HEAVYSNIPER', price = 100000 },
		{ weapon = 'WEAPON_FIREEXTINGUISHER', price = 10000 },
		{ weapon = 'GADGET_PARACHUTE', price = 10000 },
		{ weapon = 'WEAPON_PISTOL', price = 10000 },
		{ weapon = 'WEAPON_PISTOL_MK2', price = 10000},
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	}
}

Config.PolisiAuthorizedVehicles = {
	Shared = {
		{ model = 'sanchezpol', label = 'Sanchez', price = 20000 }
	},

	recruit = {
		{ model = 'evopol', label = 'Lancer Evo X ', price = 20000},
		{ model = 'triton', label = 'Triton L200', price = 20000},
		{ model = 'wolf1', label = 'D-APC Wolf', price = 20000 }
	},

	bripda = {
		{ model = 'evopol', label = 'Lancer Evo X ', price = 20000},
		{ model = 'triton', label = 'Triton L200', price = 20000},
		{ model = 'wolf1', label = 'D-APC Wolf', price = 20000 },
		{ model = 'goldpol', label = 'Goldwing', price = 20000},
		{ model = 'siresp_mfuso', label = 'Truck Samsat', price = 20000},
		{ model = 'rangerpol', label = 'Ranger', price = 20000},
		{ model = 'mazda6', label = 'Mazda6', price = 20000 },
		{ model = 'psp_bmwgs', label = 'BMW R 1200 GS', price = 20000},
		{ model = 'r1200rtp', label = 'R 1200 RTP', price = 20000},
		{ model = 'elantrapol', label = 'Elantra', price = 20000}
	},

	kombes = {
		{ model = 'barracks', label = 'Trek', price = 20000 },
		{ model = 'sanchezpol', label = 'Sanchez', price = 20000 },
		{ model = 'evopol', label = 'Lancer Evo X ', price = 20000},
		{ model = 'dmaxpol', label = 'D-max', price = 20000 },
		{ model = 'triton', label = 'Triton L200', price = 20000},
		{ model = 'elantrapol', label = 'Elantra', price = 20000},
		{ model = 'goldpol', label = 'Goldwing', price = 20000},
		{ model = 'siresp_mfuso', label = 'Truck Samsat', price = 20000},
		{ model = 'rangerpol', label = 'Ranger', price = 20000},
		{ model = 'mazda6', label = 'Mazda6', price = 20000 },
		{ model = 'psp_bmwgs', label = 'BMW R 1200 GS', price = 15000},
		{ model = 'brimob1', label = 'Insurgent', price = 20000 },
		{ model = 'baracuda', label = 'Baracuda', price = 20000 },
		{ model = 'watercanon', label = 'Water Canon', price = 20000 },
		{ model = 'wolf1', label = 'D-APC Wolf', price = 20000 },
		{ model = 'almera', label = 'Almera', price = 20000},
		{ model = 'r1200rtp', label = 'R 1200 RTP', price = 15000},
		{ model = 'pajerovos', label = 'Pajero Provos', price = 300000},
		{ model = 'hp_x6', label = 'BMW X6 Polisi', price = 300000},
		{ model = 'hotpol', label = 'Mobil Hotpersuit', price = 300000},
		{ model = 'mclarenpursuit', label = 'McLaren Pursuit', price = 300000},
		{ model = 'resmob', label = 'Mobil Resmob', price = 100000},
		{ model = 'foxctp', label = 'Tesla Brimob', price = 100000},
		{ model = 'vxr', label = 'Toyota Landcruiser V20', price = 300000}
	},

	brigjen = {
		{ model = 'barracks', label = 'Trek', price = 20000 },
		{ model = 'sanchezpol', label = 'Sanchez', price = 20000 },
		{ model = 'evopol', label = 'Lancer Evo X ', price = 20000},
		{ model = 'dmaxpol', label = 'D-max', price = 20000 },
		{ model = 'triton', label = 'Triton L200', price = 20000},
		{ model = 'elantrapol', label = 'Elantra', price = 20000},
		{ model = 'goldpol', label = 'Goldwing', price = 20000},
		{ model = 'siresp_mfuso', label = 'Mobil Tilang', price = 20000},
		{ model = 'rangerpol', label = 'Ranger', price = 20000},
		{ model = 'mazda6', label = 'Mazda6', price = 20000 },
		{ model = 'psp_bmwgs', label = 'BMW R 1200 GS', price = 15000},
		{ model = 'brimob1', label = 'Insurgent', price = 20000 },
		{ model = 'baracuda', label = 'Baracuda', price = 20000 },
		{ model = 'watercanon', label = 'Water Canon', price = 20000 },
		{ model = 'wolf1', label = 'D-APC Wolf', price = 20000 },
		{ model = 'almera', label = 'Almera', price = 20000},
		{ model = 'r1200rtp', label = 'R 1200 RTP', price = 15000},
		{ model = 'pajerovos', label = 'Pajero Provos', price = 300000},
		{ model = 'hp_x6', label = 'BMW X6 Polisi', price = 300000},
		{ model = 'hotpol', label = 'Mobil Hotpersuit', price = 300000},
		{ model = 'mclarenpursuit', label = 'McLaren Pursuit', price = 300000},
		{ model = 'resmob', label = 'Mobil Resmob', price = 100000},
		{ model = 'foxctp', label = 'Tesla Brimob', price = 100000},
		{ model = 'vxr', label = 'Toyota Landcruiser V20', price = 300000}
	},

	irjen = {
		{ model = 'barracks', label = 'Trek', price = 20000 },
		{ model = 'sanchezpol', label = 'Sanchez', price = 20000 },
		{ model = 'evopol', label = 'Lancer Evo X ', price = 20000},
		{ model = 'dmaxpol', label = 'D-max', price = 20000 },
		{ model = 'triton', label = 'Triton L200', price = 20000},
		{ model = 'elantrapol', label = 'Elantra', price = 20000},
		{ model = 'goldpol', label = 'Goldwing', price = 20000},
		{ model = 'siresp_mfuso', label = 'Mobil Tilang', price = 20000},
		{ model = 'rangerpol', label = 'Ranger', price = 20000},
		{ model = 'mazda6', label = 'Mazda6', price = 20000 },
		{ model = 'psp_bmwgs', label = 'BMW R 1200 GS', price = 15000},
		{ model = 'brimob1', label = 'Insurgent', price = 20000 },
		{ model = 'baracuda', label = 'Baracuda', price = 20000 },
		{ model = 'watercanon', label = 'Water Canon', price = 20000 },
		{ model = 'wolf1', label = 'D-APC Wolf', price = 20000 },
		{ model = 'almera', label = 'Almera', price = 20000},
		{ model = 'r1200rtp', label = 'R 1200 RTP', price = 15000},
		{ model = 'pajerovos', label = 'Pajero Provos', price = 300000},
		{ model = 'hp_x6', label = 'BMW X6 Polisi', price = 300000},
		{ model = 'hotpol', label = 'Mobil Hotpersuit', price = 300000},
		{ model = 'mclarenpursuit', label = 'McLaren Pursuit', price = 300000},
		{ model = 'resmob', label = 'Mobil Resmob', price = 100000},
		{ model = 'foxctp', label = 'Tesla Brimob', price = 100000},
		{ model = 'vxr', label = 'Toyota Landcruiser V20', price = 300000}
	},

	komjen = {
		{ model = 'barracks', label = 'Trek', price = 20000 },
		{ model = 'sanchezpol', label = 'Sanchez', price = 20000 },
		{ model = 'evopol', label = 'Lancer Evo X ', price = 20000},
		{ model = 'dmaxpol', label = 'D-max', price = 20000 },
		{ model = 'triton', label = 'Triton L200', price = 20000},
		{ model = 'elantrapol', label = 'Elantra', price = 20000},
		{ model = 'goldpol', label = 'Goldwing', price = 20000},
		{ model = 'siresp_mfuso', label = 'Mobil Tilang', price = 20000},
		{ model = 'rangerpol', label = 'Ranger', price = 20000},
		{ model = 'mazda6', label = 'Mazda6', price = 20000 },
		{ model = 'psp_bmwgs', label = 'BMW R 1200 GS', price = 15000},
		{ model = 'brimob1', label = 'Insurgent', price = 20000 },
		{ model = 'baracuda', label = 'Baracuda', price = 20000 },
		{ model = 'watercanon', label = 'Water Canon', price = 20000 },
		{ model = 'wolf1', label = 'D-APC Wolf', price = 20000 },
		{ model = 'almera', label = 'Almera', price = 20000},
		{ model = 'r1200rtp', label = 'R 1200 RTP', price = 15000},
		{ model = 'pajerovos', label = 'Pajero Provos', price = 300000},
		{ model = 'hp_x6', label = 'BMW X6 Polisi', price = 300000},
		{ model = 'hotpol', label = 'Mobil Hotpersuit', price = 300000},
		{ model = 'mclarenpursuit', label = 'McLaren Pursuit', price = 300000},
		{ model = 'resmob', label = 'Mobil Resmob', price = 100000},
		{ model = 'foxctp', label = 'Tesla Brimob', price = 100000},
		{ model = 'vxr', label = 'Toyota Landcruiser V20', price = 300000}
	},

	boss = {
		{ model = 'barracks', label = 'Trek', price = 20000 },
		{ model = 'sanchezpol', label = 'Sanchez', price = 20000 },
		{ model = 'evopol', label = 'Lancer Evo X ', price = 20000},
		{ model = 'dmaxpol', label = 'D-max', price = 20000 },
		{ model = 'triton', label = 'Triton L200', price = 20000},
		{ model = 'elantrapol', label = 'Elantra', price = 20000},
		{ model = 'goldpol', label = 'Goldwing', price = 20000},
		{ model = 'siresp_mfuso', label = 'Mobil Tilang', price = 20000},
		{ model = 'rangerpol', label = 'Ranger', price = 20000},
		{ model = 'mazda6', label = 'Mazda6', price = 20000 },
		{ model = 'psp_bmwgs', label = 'BMW R 1200 GS', price = 15000},
		{ model = 'brimob1', label = 'Insurgent', price = 20000 },
		{ model = 'baracuda', label = 'Baracuda', price = 20000 },
		{ model = 'watercanon', label = 'Water Canon', price = 20000 },
		{ model = 'wolf1', label = 'D-APC Wolf', price = 20000 },
		{ model = 'almera', label = 'Almera', price = 20000},
		{ model = 'r1200rtp', label = 'R 1200 RTP', price = 15000},
		{ model = 'pajerovos', label = 'Pajero Provos', price = 300000},
		{ model = 'hp_x6', label = 'BMW X6 Polisi', price = 300000},
		{ model = 'hotpol', label = 'Mobil Hotpersuit', price = 300000},
		{ model = 'mclarenpursuit', label = 'McLaren Pursuit', price = 300000},
		{ model = 'resmob', label = 'Mobil Resmob', price = 100000},
		{ model = 'foxctp', label = 'Tesla Brimob', price = 100000},
		{ model = 'vxr', label = 'Toyota Landcruiser V20', price = 300000}
	}
}

Config.PolisiAuthorizedHelicopters = {
	kombes = {
		{ model = 'polmav', label = 'Helikopter', livery = 0, price = 500000 },
	},
	brigjen = {
		 {model = 'polmav', label = 'Helikopter', livery = 0, price = 500000 },
	},
	irjen = {
		{ model = 'polmav', label = 'Helikopter', livery = 0, price = 500000 },
	},
	komjen = {
		{ model = 'polmav', label = 'Helikopter', livery = 0, price = 500000 },
	},
	boss = {
		{ model = 'polmav', label = 'Helikopter', livery = 0, price = 500000 }
	}
}


-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
	taruna_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 29,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 151,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 16,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 20,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 29,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	taruna_tbc = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 104,  ['helmet_2'] = 4,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 90,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	taruna_olg = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 146,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	taruna_lantas = {
		male = {
			['tshirt_1'] = 55,  ['tshirt_2'] = 0,
			['torso_1'] = 193,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	taruna_brimob = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 212,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	bripda_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 29,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 151,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 16,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 20,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 29,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	bripda_tbc = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 104,  ['helmet_2'] = 4,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 90,   ['torso_2'] = 0,
			['decals_1'] = 11,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	bripda_olg = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 146,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 11,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	bripda_lantas = {
		male = {
			['tshirt_1'] = 55,  ['tshirt_2'] = 0,
			['torso_1'] = 193,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 15,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	bripda_brimob = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 212,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	briptu_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 29,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 151,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 16,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 20,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 29,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	briptu_tbc = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 104,  ['helmet_2'] = 4,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 90,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 1,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	briptu_olg = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 146,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 1,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	briptu_lantas = {
		male = {
			['tshirt_1'] = 55,  ['tshirt_2'] = 0,
			['torso_1'] = 193,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	briptu_brimob = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 212,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	brigpol_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 29,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 151,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 16,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 20,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 29,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	brigpol_tbc = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 104,  ['helmet_2'] = 4,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 90,   ['torso_2'] = 0,
			['decals_1'] = 11,   ['decals_2'] = 1,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	brigpol_olg = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 146,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 11,   ['decals_2'] = 1,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	brigpol_lantas = {
		male = {
			['tshirt_1'] = 55,  ['tshirt_2'] = 0,
			['torso_1'] = 193,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	brigpol_brimob = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 212,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	bripka_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 29,   ['torso_2'] = 4,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 151,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 16,   ['torso_2'] = 4,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 20,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 29,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	bripka_tbc = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 104,  ['helmet_2'] = 4,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 90,   ['torso_2'] = 0,
			['decals_1'] = 11,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	bripka_olg = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 146,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 11,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	bripka_lantas = {
		male = {
			['tshirt_1'] = 55,  ['tshirt_2'] = 0,
			['torso_1'] = 193,   ['torso_2'] = 4,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	bripka_brimob = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 212,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	aipda_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 29,   ['torso_2'] = 5,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 151,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 16,   ['torso_2'] = 5,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 20,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 29,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	aipda_tbc = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 104,  ['helmet_2'] = 4,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 90,   ['torso_2'] = 0,
			['decals_1'] = 11,   ['decals_2'] = 4,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	aipda_olg = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 146,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 11,   ['decals_2'] = 4,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	aipda_lantas = {
		male = {
			['tshirt_1'] = 55,  ['tshirt_2'] = 0,
			['torso_1'] = 193,   ['torso_2'] = 5,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	aipda_brimob = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 212,   ['torso_2'] = 4,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	aiptu_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 29,   ['torso_2'] = 6,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 151,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 16,   ['torso_2'] = 6,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 20,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 29,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},
	aiptu_tbc = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 104,  ['helmet_2'] = 4,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 90,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	aiptu_olg = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 146,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	aiptu_lantas = {
		male = {
			['tshirt_1'] = 55,  ['tshirt_2'] = 0,
			['torso_1'] = 193,   ['torso_2'] = 6,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	aiptu_brimob = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 212,   ['torso_2'] = 5,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	ipda_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 29,   ['torso_2'] = 7,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 151,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 11,   ['decals_2'] = 5,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	ipda_tbc = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 104,  ['helmet_2'] = 4,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 90,   ['torso_2'] = 0,
			['decals_1'] = 11,   ['decals_2'] = 5,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	ipda_olg = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 146,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 11,   ['decals_2'] = 5,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	ipda_lantas = {
		male = {
			['tshirt_1'] = 55,  ['tshirt_2'] = 0,
			['torso_1'] = 193,   ['torso_2'] = 7,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	ipda_brimob = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 212,   ['torso_2'] = 6,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	iptu_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 31,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 151,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	iptu_tbc = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 104,  ['helmet_2'] = 4,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 90,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	iptu_olg = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 146,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	iptu_lantas = {
		male = {
			['tshirt_1'] = 55,  ['tshirt_2'] = 0,
			['torso_1'] = 193,   ['torso_2'] = 8,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	iptu_brimob = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 212,   ['torso_2'] = 7,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	akp_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 31,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 151,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	akp_tbc = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 104,  ['helmet_2'] = 4,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	akp_olg = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 146,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	akp_lantas = {
		male = {
			['tshirt_1'] = 55,  ['tshirt_2'] = 0,
			['torso_1'] = 193,   ['torso_2'] = 9,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	akp_brimob = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 212,   ['torso_2'] = 8,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	kompol_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 31,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = 151,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	kompol_tbc = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 104,  ['helmet_2'] = 4,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	kompol_olg = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 146,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	kompol_lantas = {
		male = {
			['tshirt_1'] = 55,  ['tshirt_2'] = 0,
			['torso_1'] = 193,   ['torso_2'] = 10,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	kompol_brimob = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 212,   ['torso_2'] = 9,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	akbp_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 31,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = 151,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	akbp_tbc = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 104,  ['helmet_2'] = 4,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	akbp_olg = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 146,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	akbp_lantas = {
		male = {
			['tshirt_1'] = 55,  ['tshirt_2'] = 0,
			['torso_1'] = 193,   ['torso_2'] = 11,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	akbp_brimob = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 212,   ['torso_2'] = 10,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	kombes_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 31,   ['torso_2'] = 4,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = 151,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	kombes_tbc = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 104,  ['helmet_2'] = 4,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	kombes_olg = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 146,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	kombes_lantas = {
		male = {
			['tshirt_1'] = 55,  ['tshirt_2'] = 0,
			['torso_1'] = 193,   ['torso_2'] = 12,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	kombes_brimob = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 212,   ['torso_2'] = 11,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	brigjen_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 31,   ['torso_2'] = 5,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = 151,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	brigjen_tbc = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 104,  ['helmet_2'] = 4,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	brigjen_olg = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 146,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	brigjen_lantas = {
		male = {
			['tshirt_1'] = 55,  ['tshirt_2'] = 0,
			['torso_1'] = 193,   ['torso_2'] = 13,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	brigjen_brimob = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 212,   ['torso_2'] = 12,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	irjen_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 31,   ['torso_2'] = 6,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = 151,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	irjen_tbc = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 104,  ['helmet_2'] = 4,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	irjen_olg = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 146,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	irjen_lantas = {
		male = {
			['tshirt_1'] = 55,  ['tshirt_2'] = 0,
			['torso_1'] = 193,   ['torso_2'] = 14,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	irjen_brimob = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 212,   ['torso_2'] = 13,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	komjen_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 31,   ['torso_2'] = 7,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = 151,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	komjen_tbc = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 104,  ['helmet_2'] = 4,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	komjen_olg = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 146,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	komjen_lantas = {
		male = {
			['tshirt_1'] = 55,  ['tshirt_2'] = 0,
			['torso_1'] = 193,   ['torso_2'] = 15,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	komjen_brimob = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 212,   ['torso_2'] = 14,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	boss_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 31,   ['torso_2'] = 7,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = 151,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	boss_tbc = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 1,
			['torso_1'] = 93,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 12,   ['shoes_2'] = 0,
			['helmet_1'] = 104,  ['helmet_2'] = 4,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	boss_olg = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 146,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 91,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 41,   ['pants_2'] = 1,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 13,  ['helmet_2'] = 1,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 14,  ['bproof_2'] = 0
		}
	},
	boss_lantas = {
		male = {
			['tshirt_1'] = 55,  ['tshirt_2'] = 0,
			['torso_1'] = 193,   ['torso_2'] = 16,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	boss_brimob = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 212,   ['torso_2'] = 15,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 52,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 29,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		},
		female = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 36,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 52,   ['shoes_2'] = 0,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['chain_1'] = 8,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 19,  ['bproof_2'] = 0
		}
	},
	bullet_wear = {
		male = {
			['bproof_1'] = 20,  ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 13,  ['bproof_2'] = 1
		}
	},
	polisi = {
		male = {
			['bproof_1'] = 2,  ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 20,  ['bproof_2'] = 0
		}
	},
	gilet_wear = {
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 1
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1
		}
	}

}

--MEKANIK--
Config.MekanikDrawDistance               = 25.0
Config.MekanikMaxInService               = 10
Config.MekanikEnablePlayerManagement     = true
Config.MekanikEnableSocietyOwnedVehicles = false

Config.MekanikNPCSpawnDistance           = 500.0
Config.MekanikNPCNextToDistance          = 25.0
Config.MekanikNPCJobEarnings             = { min = 15, max = 40 }

Config.MekanikVehicles = {
	'adder',
	'asea',
	'asterope',
	'banshee',
	'buffalo'
}

Config.MekanikZones = {

	MechanicActions = {
		Pos   = { x = 0, y = 0, z = 0 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = 21
	},

	Garage = {
		Pos   = { x = 0, y = 0, z = 0 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = 1
	},

	Craft = {
		Pos   = { x = 0, y = 0, z = 0 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = 1
	},

	VehicleSpawnPoint = {
		Pos   = {x = 102.04,  y = 6514.38, z = 32.95},
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = -1
	},

	VehicleDeleter = {
		Pos   = {x = 102.04,  y = 6514.38, z = 31.95},
		Size  = { x = 3.0, y = 3.0, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = 1
	},

	VehicleDelivery = {
		Pos   = { x = -382.925, y = -133.748, z = 37.685 },
		Size  = { x = 20.0, y = 20.0, z = 3.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = -1
	}
}

Config.MekanikTowables = {
	vector3(-2480.9, -212.0, 17.4),
	vector3(-2723.4, 13.2, 15.1),
	vector3(-3169.6, 976.2, 15.0),
	vector3(-3139.8, 1078.7, 20.2),
	vector3(-1656.9, -246.2, 54.5),
	vector3(-1586.7, -647.6, 29.4),
	vector3(-1036.1, -491.1, 36.2),
	vector3(-1029.2, -475.5, 36.4),
	vector3(75.2, 164.9, 104.7),
	vector3(-534.6, -756.7, 31.6),
	vector3(487.2, -30.8, 88.9),
	vector3(-772.2, -1281.8, 4.6),
	vector3(-663.8, -1207.0, 10.2),
	vector3(719.1, -767.8, 24.9),
	vector3(-971.0, -2410.4, 13.3),
	vector3(-1067.5, -2571.4, 13.2),
	vector3(-619.2, -2207.3, 5.6),
	vector3(1192.1, -1336.9, 35.1),
	vector3(-432.8, -2166.1, 9.9),
	vector3(-451.8, -2269.3, 7.2),
	vector3(939.3, -2197.5, 30.5),
	vector3(-556.1, -1794.7, 22.0),
	vector3(591.7, -2628.2, 5.6),
	vector3(1654.5, -2535.8, 74.5),
	vector3(1642.6, -2413.3, 93.1),
	vector3(1371.3, -2549.5, 47.6),
	vector3(383.8, -1652.9, 37.3),
	vector3(27.2, -1030.9, 29.4),
	vector3(229.3, -365.9, 43.8),
	vector3(-85.8, -51.7, 61.1),
	vector3(-4.6, -670.3, 31.9),
	vector3(-111.9, 92.0, 71.1),
	vector3(-314.3, -698.2, 32.5),
	vector3(-366.9, 115.5, 65.6),
	vector3(-592.1, 138.2, 60.1),
	vector3(-1613.9, 18.8, 61.8),
	vector3(-1709.8, 55.1, 65.7),
	vector3(-521.9, -266.8, 34.9),
	vector3(-451.1, -333.5, 34.0),
	vector3(322.4, -1900.5, 25.8)
}

for k,v in ipairs(Config.MekanikTowables) do
	Config.MekanikZones['Towable' .. k] = {
		Pos   = v,
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = -1
	}
end

--TAXI--
Config.TaxiDrawDistance           = 5.0

Config.TaxiNPCJobEarnings         = {min = 300, max = 600}
Config.TaxiMinimumDistance            = 3000 -- Minimum NPC job destination distance from the pickup in GTA units, a higher number prevents nearby destionations.

Config.TaxiMaxInService               = -1
Config.ConfigEnablePlayerManagement     = true
Config.ConfigEnableSocietyOwnedVehicles = false

Config.TaxiAuthorizedVehicles = {
	{model = 'taxi', label = 'Taxi'}
}

Config.TaxiZones = {

	VehicleSpawner = {
		Pos   = {x = 893.715, y = -162.304, z = 76.8},
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 36, Rotate = true
	},

	VehicleSpawnPoint = {
		Pos     = {x = 896.652, y = -153.978, z = 76.569},
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Type    = -1, Rotate = false,
		Heading = 326.15
	},

	VehicleDeleter = {
		Pos   = {x = 908.317, y = -183.070, z = 73.201},
		Size  = {x = 3.0, y = 3.0, z = 0.25},
		Color = {r = 255, g = 0, b = 0},
		Type  = 1, Rotate = false
	},

	TaxiActions = {
		Pos   = {x = 893.47, y = -167.08, z = 74.1},
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 20, Rotate = true
	},

	taxiCloakroom = {
		Pos     = {x = 892.86, y = -146.37, z = 76.8},
		Size    = {x = 1.0, y = 1.0, z = 1.0},
		Color   = {r = 204, g = 204, b = 0},
		Type    = 21, Rotate = true
	}
}

Config.JobLocations = {
	vector3(293.5, -590.2, 42.7),
	vector3(253.4, -375.9, 44.1),
	vector3(120.8, -300.4, 45.1),
	vector3(-38.4, -381.6, 38.3),
	vector3(-107.4, -614.4, 35.7),
	vector3(-252.3, -856.5, 30.6),
	vector3(-236.1, -988.4, 28.8),
	vector3(-277.0, -1061.2, 25.7),
	vector3(-576.5, -999.0, 21.8),
	vector3(-602.8, -952.6, 21.6),
	vector3(-790.7, -961.9, 14.9),
	vector3(-912.6, -864.8, 15.0),
	vector3(-1069.8, -792.5, 18.8),
	vector3(-1306.9, -854.1, 15.1),
	vector3(-1468.5, -681.4, 26.2),
	vector3(-1380.9, -452.7, 34.1),
	vector3(-1326.3, -394.8, 36.1),
	vector3(-1383.7, -270.0, 42.5),
	vector3(-1679.6, -457.3, 39.4),
	vector3(-1812.5, -416.9, 43.7),
	vector3(-2043.6, -268.3, 23.0),
	vector3(-2186.4, -421.6, 12.7),
	vector3(-1862.1, -586.5, 11.2),
	vector3(-1859.5, -617.6, 10.9),
	vector3(-1635.0, -988.3, 12.6),
	vector3(-1284.0, -1154.2, 5.3),
	vector3(-1126.5, -1338.1, 4.6),
	vector3(-867.9, -1159.7, 5.0),
	vector3(-847.5, -1141.4, 6.3),
	vector3(-722.6, -1144.6, 10.2),
	vector3(-575.5, -318.4, 34.5),
	vector3(-592.3, -224.9, 36.1),
	vector3(-559.6, -162.9, 37.8),
	vector3(-535.0, -65.7, 40.6),
	vector3(-758.2, -36.7, 37.3),
	vector3(-1375.9, 21.0, 53.2),
	vector3(-1320.3, -128.0, 48.1),
	vector3(-1285.7, 294.3, 64.5),
	vector3(-1245.7, 386.5, 75.1),
	vector3(-760.4, 285.0, 85.1),
	vector3(-626.8, 254.1, 81.1),
	vector3(-563.6, 268.0, 82.5),
	vector3(-486.8, 272.0, 82.8),
	vector3(88.3, 250.9, 108.2),
	vector3(234.1, 344.7, 105.0),
	vector3(435.0, 96.7, 99.2),
	vector3(482.6, -142.5, 58.2),
	vector3(762.7, -786.5, 25.9),
	vector3(809.1, -1290.8, 25.8),
	vector3(490.8, -1751.4, 28.1),
	vector3(432.4, -1856.1, 27.0),
	vector3(164.3, -1734.5, 28.9),
	vector3(-57.7, -1501.4, 31.1),
	vector3(52.2, -1566.7, 29.0),
	vector3(310.2, -1376.8, 31.4),
	vector3(182.0, -1332.8, 28.9),
	vector3(-74.6, -1100.6, 25.7),
	vector3(-887.0, -2187.5, 8.1),
	vector3(-749.6, -2296.6, 12.5),
	vector3(-1064.8, -2560.7, 19.7),
	vector3(-1033.4, -2730.2, 19.7),
	vector3(-1018.7, -2732.0, 13.3),
	vector3(797.4, -174.4, 72.7),
	vector3(508.2, -117.9, 60.8),
	vector3(159.5, -27.6, 67.4),
	vector3(-36.4, -106.9, 57.0),
	vector3(-355.8, -270.4, 33.0),
	vector3(-831.2, -76.9, 37.3),
	vector3(-1038.7, -214.6, 37.0),
	vector3(1918.4, 3691.4, 32.3),
	vector3(1820.2, 3697.1, 33.5),
	vector3(1619.3, 3827.2, 34.5),
	vector3(1418.6, 3602.2, 34.5),
	vector3(1944.9, 3856.3, 31.7),
	vector3(2285.3, 3839.4, 34.0),
	vector3(2760.9, 3387.8, 55.7),
	vector3(1952.8, 2627.7, 45.4),
	vector3(1051.4, 474.8, 93.7),
	vector3(866.4, 17.6, 78.7),
	vector3(319.0, 167.4, 103.3),
	vector3(88.8, 254.1, 108.2),
	vector3(-44.9, 70.4, 72.4),
	vector3(-115.5, 84.3, 70.8),
	vector3(-384.8, 226.9, 83.5),
	vector3(-578.7, 139.1, 61.3),
	vector3(-651.3, -584.9, 34.1),
	vector3(-571.8, -1195.6, 17.9),
	vector3(-1513.3, -670.0, 28.4),
	vector3(-1297.5, -654.9, 26.1),
	vector3(-1645.5, 144.6, 61.7),
	vector3(-1160.6, 744.4, 154.6),
	vector3(-798.1, 831.7, 204.4)
}

--[[EMS
Config.DrawDistance               = 10.0 -- How close do you need to be in order for the markers to be drawn (in GTA units).

Config.Marker                     = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}

Config.ReviveReward               = 700  -- Revive reward, set to 0 if you don't want it enabled
Config.SaveDeathStatus              = true -- Save Death Status?
Config.LoadIpl                    = true -- Disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'en'

Config.EarlyRespawnTimer          = 60000 * 1  -- time til respawn is available
Config.BleedoutTimer              = 60000 * 10 -- time til the player bleeds out

Config.EnablePlayerManagement     = false -- Enable society managing (If you are using esx_society).

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 5000

Config.OxInventory                = ESX.GetConfig().OxInventory
Config.RespawnPoints = {
	{coords = vector3(341.0, -1397.3, 32.5), heading = 48.5}
}

Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(307.7, -1433.4, 28.9),
			sprite = 61,
			scale  = 1.2,
			color  = 2
		},

		AmbulanceActions = {
			vector3(270.5, -1363.0, 23.5)
		},

		Pharmacies = {
			vector3(230.1, -1366.1, 38.5)
		},

		Vehicles = {
			{
				Spawner = vector3(307.7, -1433.4, 30.0),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = {type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true},
				SpawnPoints = {
					{coords = vector3(297.2, -1429.5, 29.8), heading = 227.6, radius = 4.0},
					{coords = vector3(294.0, -1433.1, 29.8), heading = 227.6, radius = 4.0},
					{coords = vector3(309.4, -1442.5, 29.8), heading = 227.6, radius = 6.0}
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(317.5, -1449.5, 46.5),
				InsideShop = vector3(305.6, -1419.7, 41.5),
				Marker = {type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true},
				SpawnPoints = {
					{coords = vector3(313.5, -1465.1, 46.5), heading = 142.7, radius = 10.0},
					{coords = vector3(299.5, -1453.2, 46.5), heading = 142.7, radius = 10.0}
				}
			}
		},

		FastTravels = {
			{
				From = vector3(294.7, -1448.1, 29.0),
				To = {coords = vector3(272.8, -1358.8, 23.5), heading = 0.0},
				Marker = {type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(275.3, -1361, 23.5),
				To = {coords = vector3(295.8, -1446.5, 28.9), heading = 0.0},
				Marker = {type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(247.3, -1371.5, 23.5),
				To = {coords = vector3(333.1, -1434.9, 45.5), heading = 138.6},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(335.5, -1432.0, 45.50),
				To = {coords = vector3(249.1, -1369.6, 23.5), heading = 0.0},
				Marker = {type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(234.5, -1373.7, 20.9),
				To = {coords = vector3(320.9, -1478.6, 28.8), heading = 0.0},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false}
			},

			{
				From = vector3(317.9, -1476.1, 28.9),
				To = {coords = vector3(238.6, -1368.4, 23.5), heading = 0.0},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false}
			}
		},

		FastTravelsPrompt = {
			{
				From = vector3(237.4, -1373.8, 26.0),
				To = {coords = vector3(251.9, -1363.3, 38.5), heading = 0.0},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false},
				Prompt = 'LIFT'
			},

			{
				From = vector3(256.5, -1357.7, 36.0),
				To = {coords = vector3(235.4, -1372.8, 26.3), heading = 0.0},
				Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false},
				Prompt = 'LIFT'
			}
		}

	}
}

Config.EmsAuthorizedVehicles = {
	car = {
		ambulance = {
			{model = 'ambulance', price = 5000}
		},

		doctor = {
			{model = 'ambulance', price = 4500}
		},

		chief_doctor = {
			{model = 'ambulance', price = 3000}
		},

		boss = {
			{model = 'ambulance', price = 2000}
		}
	},

	helicopter = {
		ambulance = {},

		doctor = {
			{model = 'buzzard2', price = 150000}
		},

		chief_doctor = {
			{model = 'buzzard2', price = 150000},
			{model = 'seasparrow', price = 300000}
		},

		boss = {
			{model = 'buzzard2', price = 10000},
			{model = 'seasparrow', price = 250000}
		}
	}
}
]]

--STATE--
Config.StateEnablePlayerManagement     = true
Config.StateEnableArmoryManagement     = true
Config.StateEnableESXIdentity          = true -- enable if you're using esx_identity
Config.StateEnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.StateEnableSocietyOwnedVehicles = false
Config.StateEnableLicenses             = false -- enable if you're using esx_license

Config.StateEnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.StateHandcuffTimer              = 10 * 60000 -- 10 mins

Config.StateEnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.StateMaxInService               = -1
Config.StateBlip = {
    Blip = {
      Pos     = { x = -572.38, y = 286.89, z = 79.18 },
      Sprite  = 303,
      Display = 4,
      Scale   = 0.8,
      Colour  = 2 
	  
   }
}

Config.StatepemerintahStations = {

	LSPD1 = {
  
	  Blip = {
		--Pos     = { x = 1396.71, y = 1139.54, z = 113.33 },
		Sprite  = 60,
		Display = 4,
		Scale   = 1.2,
		Colour  = 29,
	  },
  
	  AuthorizedWeapons = {
		--{ name = 'WEAPON_PISTOL50',     price = 1500000 }
	  },
  
	   AuthorizedVehicles = {
		{ name = 'walkotjava',    label = 'MOBIL WALIKOTA' },
		{ name = 'guardian',   label = 'Guardian' },
		{ name = 'moonbeam',   label = 'Alphard' },
		{ name = 'bf400',   label = 'BF400' }
		},
  
	  Cloakrooms = {
		{ x = -129.98577880859, y = -633.24139404297, z = 168.82037353516}
	  },
  
	  Armories = {
		{x = -132.64,  y = -633.08,  z = 168.84}
	  },
  
	  Vehicles = {
		{
		  Spawner    = {x = -435.2,  y = 1181.32,  z = 325.88},
		  SpawnPoints = {x = -517.15515136719,  y = -263.99536132813,  z = 35.376220703125},
		  Heading    = 136.93,
		}
	  },
  
	  Helicopters = {
		{
		  Spawner    = { x = 113.30500793457, y = -3109.3337402344, z = 6.0060696601868 },
		  SpawnPoint = { x = 112.94457244873, y = -3102.5942382813, z = 6.0050659179688 },
		  Heading    = 0.0,
		}
	  },
  
	  VehicleDeleters = {
		{x = -429.36,  y = 1185.6,  z = 325.64},
  
	  },
  
	  BossActions = {
		--{ x = -804.75, y =177.54, z = 72.83 },
	  },
  
	},
  
  }

Config.StateUniforms = {
	recruta_wear = {
		male = {
			['tshirt_1'] = 7,  ['tshirt_2'] = 12,
			['torso_1'] = 11,  ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 59,
			['pants_1'] = 28,    ['pants_2'] = 8,
			['shoes_1'] = 20,    ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,    ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 6,   ['tshirt_2'] = 0,
			['torso_1'] = 81,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 1,
			['pants_1'] = 54,   ['pants_2'] = 2,
			['shoes_1'] = 3,    ['shoes_2'] = 5,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,    ['ears_2'] = 0
		}
	},
	soldado_wear = {
		male = {
			['tshirt_1'] = 7,  ['tshirt_2'] = 12,
			['torso_1'] = 11,  ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 59,
			['pants_1'] = 28,    ['pants_2'] = 8,
			['shoes_1'] = 20,    ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,    ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 6,   ['tshirt_2'] = 0,
			['torso_1'] = 81,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 1,
			['pants_1'] = 54,   ['pants_2'] = 2,
			['shoes_1'] = 3,    ['shoes_2'] = 5,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,    ['ears_2'] = 0
		}
	},
	gerente_wear = {
		male = {
			['tshirt_1'] = 7,  ['tshirt_2'] = 12,
			['torso_1'] = 11,  ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 59,
			['pants_1'] = 28,    ['pants_2'] = 8,
			['shoes_1'] = 20,    ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,    ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 6,   ['tshirt_2'] = 0,
			['torso_1'] = 81,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 1,
			['pants_1'] = 54,   ['pants_2'] = 2,
			['shoes_1'] = 3,    ['shoes_2'] = 5,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,    ['ears_2'] = 0
		}
	},
	boss_wear = { -- currently the same as chef_wear
		male = {
			['tshirt_1'] = 7,  ['tshirt_2'] = 12,
			['torso_1'] = 11,  ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 59,
			['pants_1'] = 28,    ['pants_2'] = 8,
			['shoes_1'] = 20,    ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,    ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 6,   ['tshirt_2'] = 0,
			['torso_1'] = 81,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 1,
			['pants_1'] = 54,   ['pants_2'] = 2,
			['shoes_1'] = 3,    ['shoes_2'] = 5,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,    ['ears_2'] = 0
		}
	},
	bulletSTATE_wear = {
		male = {
			['bproof_1'] = 11,  ['bproof_2'] = 1
		},
		female = {
			['bproof_1'] = 13,  ['bproof_2'] = 1
		}
	},
	giletstate_wear = {
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 1
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1
		}
	}
}