 Config 					= {}

Config.Impound 			= {
	Name = "MissionRow",
	RetrieveLocation = { X = 409.96, Y = -1622.75, Z = 29.29 },
	StoreLocation = { X = 485.95541381836, Y = -1097.5057373047, Z = 29.201677322388 },
	SpawnLocations = {
		{ x = 404.31, y = -1629.38, z = 29.56 , h = 229.06 },
		{ x = 402.1, y = -1631.89, z = 29.56 , h = 229.06 },
		{ x = 399.7, y = -1635.51, z = 29.56 , h = 229.06 },
	},
	AdminTerminalLocations = {
		{ x = 404.63, y = -1624.69, z = 29.65 }
	}
}

Config.Rules = {
	maxWeeks		= 5,
	maxDays			= 6,
	maxHours		= 24,

	minFee			= 1000,
	maxFee 			= 1000000,

	minReasonLength	= 10,
}

--------------------------------------------------------------------------------
----------------------- SERVERS WITHOUT ESX_MIGRATE ----------------------------
---------------- This could work, it also could not work... --------------------
--------------------------------------------------------------------------------
-- Should be true if you still have an owned_vehicles table without plate column.
Config.NoPlateColumn = false
-- Only change when NoPlateColumn is true, menu's will take longer to show but otherwise you might not have any data.
-- Try increments of 250
Config.WaitTime = 250
