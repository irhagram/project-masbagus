Config                            = {}

Config.DrawDistance               = 10.0 -- How close do you need to be in order for the markers to be drawn (in GTA units).
Config.Debug                      = ESX.GetConfig().EnableDebug
Config.Marker                     = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}

Config.ReviveReward               = 1000  -- Revive reward, set to 0 if you don't want it enabled
Config.SaveDeathStatus            = true -- Save Death Status?
Config.LoadIpl                    = true -- Disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'en'

Config.DistressBlip = {
	Sprite = 310,
	Color = 48,
	Scale = 2.0
}

Config.EarlyRespawnTimer          = 60000 * 20  -- time til respawn is available
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
	{coords = vector3(-1878.4510498047,-319.55184936523,49.441776275635), heading = 230.83}, -- Central Los Santos
	--{coords = vector3(1836.03, 3670.99, 34.28), heading = 296.06} -- Sandy Shores
}

Config.Hospitals = {

	CentralLosSantos = {

		--[[Blip = {
			coords = vector3(300.1,-572.23,43.26),
			sprite = 61,
			scale  = 1.1,
			color  = 2
		},]]

		AmbulanceActions = {
			vector3(0,0,0)
		},

		Pharmacies = {
			vector3(0,0,0)
		},

		Vehicles = {
			{
				Spawner = vector3(307.7, 1433.4, 30.0),
				InsideShop = vector3(-1879.345093, -348.250549, 49.263794),
				Marker = {type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true},
				SpawnPoints = {
					{coords = vector3(-1879.345093, -348.250549, 49.263794), heading = 227.6, radius = 4.0},
					{coords = vector3(294.0, -1433.1, 29.8), heading = 227.6, radius = 4.0},
					{coords = vector3(309.4, -1442.5, 29.8), heading = 227.6, radius = 6.0}
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(317.5, -1449.5, 46.5),
				InsideShop = vector3(-1867.635132, -352.786804, 58.025635),
				Marker = {type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true},
				SpawnPoints = {
					{coords = vector3(-1867.635132, -352.786804, 58.025635), heading = 142.7, radius = 10.0}
				}
			}
		},

		FastTravels = {
			{
				From = vector3(294.7, -1448.1, 29.0),
				To = { coords = vector3(272.8, -1358.8, 23.5), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(275.3, -1361, 23.5),
				To = { coords = vector3(295.8, -1446.5, 28.9), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(247.3, -1371.5, 23.5),
				To = { coords = vector3(333.1, -1434.9, 45.5), heading = 138.6 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(335.5, -1432.0, 45.50),
				To = { coords = vector3(249.1, -1369.6, 23.5), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(234.5, -1373.7, 20.9),
				To = { coords = vector3(320.9, -1478.6, 28.8), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(317.9, -1476.1, 28.9),
				To = { coords = vector3(238.6, -1368.4, 23.5), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			}
		},

		FastTravelsPrompt = {
			{
				From = vector3(-429.46710205078, 1109.4599609375, 326.68197631836),
				To = { coords = vector3(-136.76696777344, -623.95123291016, 167.82041931152), heading = 0.0 },
				Marker = { type = 21, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			},
			{
				From = vector3(-136.76696777344, -623.95123291016, 167.82041931152),
				To = { coords = vector3(-429.46710205078, 1109.4599609375, 326.68197631836), heading = 0.0 },
				Marker = { type = 21, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			}
		},

	},

	ShandyShours = {

		Blip = {
			coords = vector3(1840.03,3671.41,34.28),
			sprite = 61,
			scale  = 0.8,
			color  = 2
		},

		AmbulanceActions = {
			vector3(0,0,0)
		},

		Pharmacies = {
			vector3(0,0,0)
		},

		Vehicles = {
			{
				Spawner = vector3(1821.26,3685.42,34.28),
				InsideShop = vector3(1822.47, 3698.47, 33.3),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(1833.15,3660.17,33.94), heading = 204.66, radius = 10.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(1827.1859130859,3678.3979492188,40.279056549072),
				InsideShop = vector3(1843.55, 3635.88, 35.64),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(1843.55, 3635.88, 35.64), heading = 4.99, radius = 10.0 }
				}
			}
		},

		FastTravels = {
			{
				From = vector3(1823.93, 3670.05, 37.70),
				To = { coords = vector3(1828.39, 3673.21, 34.27), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			}
		},

		FastTravelsPrompt = {
			{
				From = vector3(1828.15, 3677.2, 34.27),
				To = { coords = vector3(1824.32, 3673.48, 39.0), heading = 0.0 },
				Marker = { type = 21, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			}
		},

	},

	Paleto = {

		Blip = {
			coords = vector3(-246.0970916748,6316.6303710938,32.408889770508),
			sprite = 61,
			scale  = 0.8,
			color  = 2
		},

		AmbulanceActions = {
			vector3(0,0,0)
		},

		Pharmacies = {
			vector3(0,0,0)
		},

		Vehicles = {
			{
				Spawner = vector3(-250.84037780762,6339.041015625,32.489318847656), --  Paleto
				InsideShop = vector3(-245.41296386719, 6340.1206054688, 32.001934051514),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(-245.41296386719,6340.1206054688,32.001934051514), heading = 225.23, radius = 4.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(0, 0, 0),
				InsideShop = vector3(305.6, -1419.7, 41.5),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(1832.42,3683.88,39.58), heading = 210.8, radius = 10.0 }
				}
			}
		},

		FastTravels = {
			{
				From = vector3(0, 0, 0),
				To = { coords = vector3(1828.39, 3673.21, 34.27), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			}
		},

		FastTravelsPrompt = {
			{
				From = vector3(-429.46710205078, 1109.4599609375, 326.68197631836),
				To = { coords = vector3(-136.76696777344, 623.95123291016, 167.82041931152), heading = 0.0 },
				Marker = { type = 21, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			},
			{
				From = vector3(-136.76696777344, 623.95123291016, 167.82041931152),
				To = { coords = vector3(-429.46710205078, 1109.4599609375, 326.68197631836), heading = 0.0 },
				Marker = { type = 21, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			}
		},

	},
}

Config.AuthorizedVehicles = {
	training = {
		{ model = 'ambulance', label = 'Ambulance Kotak', price = 20000 },
		{ model = 'sanchezems', label = 'Ambulance Motor', price = 15000 },
		{ model = 'crysta', label = 'Amblan Crista', price = 20000}
	},

	coass = {
		{ model = 'ambulance', label = 'Ambulance Kotak', price = 20000 },
		{ model = 'sanchezems', label = 'Ambulance Motor', price = 15000 },
		{ model = 'gsemsrj', label = 'GS EMS', price = 15000 },
		{ model = 'hiluxamb', label = 'Amblan Hilux', price = 20000},
		{ model = 'crysta', label = 'Amblan Crista', price = 20000}
	},

	drumum = {
		{ model = 'ambulance', label = 'Ambulance Kotak', price = 20000 },
		{ model = 'sanchezems', label = 'Ambulance Motor', price = 15000 },
		{ model = 'gsemsrj', label = 'GS EMS', price = 15000 },
		{ model = 'hiluxamb', label = 'Amblan Hilux', price = 20000},
		{ model = 'crysta', label = 'Amblan Crista', price = 20000}
	},

	drspesial = {
		{ model = 'ambulance', label = 'Ambulance Kotak', price = 20000 },
		{ model = 'fd1', label = 'Ambulance Suv', price = 20000 },
		{ model = 'sanchezems', label = 'Ambulance Motor', price = 15000 },
		{ model = 'gsemsrj', label = 'GS EMS', price = 15000 },
		{ model = 'hiluxamb', label = 'Amblan Hilux', price = 20000},
		{ model = 'crysta', label = 'Amblan Crista', price = 20000}
	},
	
	boss = {
		{ model = 'ambulance', label = 'Ambulance Kotak', price = 20000 },
		{ model = 'fd1', label = 'Ambulance Suv', price = 20000 },
		{ model = 'sanchezems', label = 'Ambulance Motor', price = 15000 },
		{ model = 'gsemsrj', label = 'GS EMS', price = 15000 },
		{ model = 'hiluxamb', label = 'Amblan Hilux', price = 20000},
		{ model = 'crysta', label = 'Amblan Crista', price = 20000}
	},
}

Config.AuthorizedHelicopters = {
	drumum = {
		{ model = 'swift', label = 'Helicopter', price = 200000 }
	},

	drspesial = {
		{ model = 'swift', label = 'Helicopter', price = 200000 }
	},

	boss = {
		{ model = 'swift', label = 'Helicopter', price = 200000 }
	},
}