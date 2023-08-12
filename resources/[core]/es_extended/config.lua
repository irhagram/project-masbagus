Config                      = {}
Config.Locale               = GetConvar('esx:locale', 'en')

Config.Accounts             = {
	bank = {
		label = TranslateCap('account_bank'),
		round = true
	},
	black_money = {
		label = TranslateCap('account_black_money'),
		round = true
	},
	money = {
		label = TranslateCap('account_money'),
		round = true
	}
}

Config.StartingAccountMoney = { bank = 50000 }


Config.DefaultSpawns = { -- If you want to have more spawn positions and select them randomly uncomment commented code or add more locations
	{ x = 222.2027, y = -864.0162, z = 30.2922, heading = 1.0 },
	--{x = 224.9865, y = -865.0871, z = 30.2922, heading = 1.0},
	--{x = 227.8436, y = -866.0400, z = 30.2922, heading = 1.0},
	--{x = 230.6051, y = -867.1450, z = 30.2922, heading = 1.0},
	--{x = 233.5459, y = -868.2626, z = 30.2922, heading = 1.0}
}

Config.AdminGroups = {
	['superadmin'] = true,
	['admin'] = true,
	['mod'] = true,
	['staff'] = true,
}

Config.EnablePaycheck            = true      -- enable paycheck
Config.LogPaycheck               = false     -- Logs paychecks to a nominated Discord channel via webhook (default is false)
Config.EnableSocietyPayouts      = false     -- pay from the society account that the player is employed at? Requirement: esx_society
Config.MaxWeight                 = 50        -- the max inventory weight without backpack
Config.PaycheckInterval          = 7 * 60000 -- how often to recieve pay checks in milliseconds
Config.EnableDebug               = false     -- Use Debug options?
Config.EnableDefaultInventory    = false      -- Display the default Inventory ( F2 )
Config.EnableWantedLevel         = false     -- Use Normal GTA wanted Level?
Config.EnablePVP                 = true      -- Allow Player to player combat
Config.Identifier 				 = 'steam' -- 'steam'/'discord'/'license'
Config.Multichar                 = true
Config.Identity                  = true  -- Select a characters identity data before they have loaded in (this happens by default with multichar)
Config.DistanceGive              = 4.0   -- Max distance when giving items, weapons etc.

Config.AdminLogging              = false -- Logs the usage of certain commands by those with group.admin ace permissions (default is false)

Config.DisableHealthRegeneration = true -- Player will no longer regenerate health
Config.DisableVehicleRewards     = true -- Disables Player Recieving weapons from vehicles
Config.DisableNPCDrops           = true -- stops NPCs from dropping weapons on death
Config.DisableDispatchServices   = true -- Disable Dispatch services
Config.DisableScenarios          = true -- Disable Scenarios
Config.DisableWeaponWheel        = true -- Disables default weapon wheel
Config.DisableAimAssist          = true -- disables AIM assist (mainly on controllers)
Config.DisableVehicleSeatShuff   = true -- Disables vehicle seat shuff
Config.RemoveHudCommonents       = {
	[1] = true,                         --WANTED_STARS,
	[2] = true,                         --WEAPON_ICON
	[3] = true,                         --CASH
	[4] = true,                         --MP_CASH
	[5] = true,                         --MP_MESSAGE
	[6] = true,                         --VEHICLE_NAME
	[7] = true,                         -- AREA_NAME
	[8] = true,                         -- VEHICLE_CLASS
	[9] = true,                         --STREET_NAME
	[10] = false,                        --HELP_TEXT
	[11] = false,                        --FLOATING_HELP_TEXT_1
	[12] = false,                        --FLOATING_HELP_TEXT_2
	[13] = false,                        --CASH_CHANGE
	[14] = false,                        --RETICLE
	[15] = false,                        --SUBTITLE_TEXT
	[16] = true,                        --RADIO_STATIONS
	[17] = true,                        --SAVING_GAME,
	[18] = false,                        --GAME_STREAM
	[19] = true,                        --WEAPON_WHEEL
	[20] = true,                        --WEAPON_WHEEL_STATS
	[21] = true,                        --HUD_COMPONENTS
	[22] = true,                        --HUD_WEAPONS
}

Config.SpawnVehMaxUpgrades       = true       -- admin vehicles spawn with max vehcle settings
Config.CustomAIPlates            = 'SDP......' -- Custom plates for AI vehicles
-- Pattern string format
--1 will lead to a random number from 0-9.
--A will lead to a random letter from A-Z.
-- . will lead to a random letter or number, with 50% probability of being either.
--^1 will lead to a literal 1 being emitted.
--^A will lead to a literal A being emitted.
--Any other character will lead to said character being emitted.
-- A string shorter than 8 characters will be padded on the right.

