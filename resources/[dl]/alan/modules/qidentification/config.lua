Kartu = {}
-- Distance at which you want to check for a player to show the ID card to
Kartu.DistanceShowID = 2.5
-- xPlayer variable that stores your player's "identification number" - for us it's identifier, you might store it as 'citizenid' or even 'slot'.
Kartu.CitizenID = 'identifier' -- if you use 'identifier' you can check this link https://forum.cfx.re/t/qidentification-a-free-id-card-resource/4024670/20?u=katoteki
-- time in SECONDS to enforce a cooldown between attempts to show your ID card to people around you
Kartu.ShowIDCooldown = 30 
-- The item you use for your physical currency
Kartu.MoneyItem = 'money' -- or 'cash' or whatever you use
Kartu.CustomMugshots = false -- for custom url, you can put your link for img

Kartu.MugshotScriptName = "eprobbery"


Kartu.IdentificationData = {
	{
		label = "KTP",
		item = 'identification',
		cost = 0,
	},
}
--- NPC STUFF
Kartu.Invincible = true
Kartu.Frozen = true
Kartu.Stoic = true
Kartu.FadeIn = true
Kartu.DistanceSpawn = 20.0
Kartu.MinusOne = true

Kartu.GenderNumbers = {
	['male'] = 4,
	['female'] = 5
}

Kartu.NPCList = {
	{
		model = `cs_movpremmale`,
		coords = vector4(0, 0, 0, 5.669291), 
		gender = 'male',
		role = 'license',
	}
}

Kartu.EnableLicenseBlip = true
Kartu.LicenseBlipName = "License Issuer"

--Coordinates for License Issuer
Kartu.LicenseLocation = {
    Loc = {
        LicenseLocation = {
            vector3(-139.226379, -633.969238, 168.813232)
        }
    }
}

