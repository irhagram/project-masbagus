Config = {}
Config.Locale = 'en'

Config.Marker = {
	r = 250, g = 0, b = 0, a = 100,  -- red color
	x = 1.0, y = 1.0, z = 0.5,       -- tiny, cylinder formed circle
	DrawDistance = 5.0, Type = 1    -- default circle type, low draw distance due to indoors area
}

Config.NumberOfCopsRequired = 3
Config.TimerBeforeNewRob    = 30000 -- The cooldown timer on a store after robbery was completed / canceled, in seconds

Config.MaxDistance    = 15   -- max distance from the robbary, going any longer away from it will to cancel the robbary
Config.GiveBlackMoney = true -- give black money? If disabled it will give cash instead

Stores = {
	["paleto_twentyfourseven"] = {
		position = { x = 1734.92, y = 6420.8, z = 35.04 },
		reward = math.random(1200000, 1300000),
		nameOfStore = "24/7. (Paleto Bay)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0,
		NumberOfCopsRequired = 0
	},
	["sandyshores_twentyfoursever"] = {
		position = { x = 1959.32, y = 3748.92, z = 32.36 },
		reward = math.random(1200000, 1300000),
		nameOfStore = "24/7. (Sandy Shores)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0,
		NumberOfCopsRequired = 0
	},
	["littleseoul_twentyfourseven"] = {
		position = { x = -709.68, y = -904.2, z = 19.2 },
		reward = math.random(1200000, 1300000),
		nameOfStore = "24/7. (Little Seoul)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0,
		NumberOfCopsRequired = 0
	},
	["downtown_twentyfourseven"] = {
		position = { x = 378.24, y = 333.36, z = 103.56 },
		reward = math.random(1200000, 1300000),
		nameOfStore = "24/7. (Downtown Vinewood)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0,
		NumberOfCopsRequired = 0
	},
	["desert_twentyfourseven"] = {
		position = { x = 2672.84, y = 3286.68, z = 55.24 },
		reward = math.random(1200000, 1300000),
		nameOfStore = "24/7. (Grand Senora Desert)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0,
		NumberOfCopsRequired = 0
	},
	--[[["bar_one"] = {
		position = { x = 1990.57, y = 3044.95, z = 47.21 },
		reward = math.random(1200000, 1300000),
		nameOfStore = "Yellow Jack. (Sandy Shores)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0,
		NumberOfCopsRequired = 0
	},]]
	["ocean_liquor"] = {
		position = { x = -2959.64, y = 387.08, z = 14.04 },
		reward = math.random(1200000, 1300000),
		nameOfStore = "Robs Liquor. (Great Ocean Highway)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0,
		NumberOfCopsRequired = 0
	},
	["rancho_liquor"] = {
		position = { x = 1126.76, y = -980.08, z = 45.4 },
		reward = math.random(1200000, 1300000),
		nameOfStore = "Robs Liquor. (El Rancho Blvd)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0,
		NumberOfCopsRequired = 0
	},
	["sanandreas_liquor"] = {
		position = { x = -1220.8, y = -916.04, z = 11.32 },
		reward = math.random(1200000, 1300000),
		nameOfStore = "Robs Liquor. (San Andreas Avenue)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0,
		NumberOfCopsRequired = 0
	},
	["morningwood_liquor"] = {
		position = { x = -1478.92, y = -375.52, z = 39.16 },
		reward = math.random(1200000, 1300000),
		nameOfStore = "Robs Liquor. (Morning Wood)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0,
		NumberOfCopsRequired = 0
	},
	["grove_ltd"] = {
		position = { x = -43.44, y = -1748.48, z = 29.44 },
		reward = math.random(1200000, 1300000),
		nameOfStore = "LTD Gasoline. (Grove Street)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0,
		NumberOfCopsRequired = 0
	},
	["mirror_ltd"] = {
		position = { x = 1159.56, y = -314.08, z = 69.2 },
		reward = math.random(1200000, 1300000),
		nameOfStore = "LTD Gasoline. (Mirror Park Boulevard)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0,
		NumberOfCopsRequired = 0
	},
	["strawberry"] = {
		position = { x = 28.16, y = -1339.2, z = 29.48 },
		reward = math.random(1200000, 1300000),
		nameOfStore = "Warung (Strawberry)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0,
		NumberOfCopsRequired = 0
	},
	["grapeseed"] = {
		position = {x = 1707.92, y = 4920.44, z = 42.36},
		reward = math.random(1200000, 1300000),
		nameOfStore = "LTD Gasoline. (Grapeseed)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0,
		NumberOfCopsRequired = 0
	},
	["inseno"] = {
		position = {x = -3047.8, y = 585.6, z = 7.92},
		reward = math.random(1200000, 1300000),
		nameOfStore = "24/7. (Inseno Road)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0,
		NumberOfCopsRequired = 0
	},
	["barbareno"] = {
		position = {x = -3250.08, y = 1004.44, z = 12.84},
		reward = math.random(1200000, 1300000),
		nameOfStore = "24/7. (Barbareno Road)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0,
		NumberOfCopsRequired = 0
	},
	["route68"] = {
		position = {x = 546.4, y = 2662.76, z = 42.16},
		reward = math.random(1200000, 1300000),
		nameOfStore = "24/7. (Route 68)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0,
		NumberOfCopsRequired = 0
	},
}
