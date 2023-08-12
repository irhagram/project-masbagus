Banking = {}
Banking.okokTextUI = false
Banking.IBANPrefix = "DAILY"
Banking.IBANNumbers = 6 -- How many characters the IBAN has by default
Banking.CustomIBANMaxChars = 10 -- How many characters the IBAN can have when changing it to a custom one (on Settings tab)
Banking.CustomIBANAllowLetters = true -- If the custom IBAN can have letters or only numbers (on Settings tab)
Banking.IBANChangeCost = 50000 -- How much it costs to change the IBAN to a custom one (on Settings tab)
Banking.PINChangeCost = 25000 -- How much it costs to change the PIN (on Settings tab)
Banking.AnimTime = 2 * 1000 -- 2 * 1000 = 2 seconds (ATM animation)

Banking.Societies = { -- Which societies have bank accounts
	"dwdwa",
	"wadawdaw",
}

Banking.SocietyAccessRanks = { -- Which ranks of the society have access to it
	"boss",
	"chief",
}

Banking.ShowBankBlips = true -- true = show bank blips on the map | false = don't show blips

Banking.BankLocations = { -- to get blips and colors check this: https://wiki.gtanet.work/index.php?title=Blips
	{blip = 108, blipColor = 2, blipScale = 0.9, x = 150.266, y = -1040.203, z = 29.374, blipText = "Bank", BankDistance = 3},
	{blip = 108, blipColor = 2, blipScale = 0.9, x = -1212.980, y = -330.841, z = 37.787, blipText = "Bank", BankDistance = 3},
	{blip = 108, blipColor = 2, blipScale = 0.9, x = -2962.582, y = 482.627, z = 15.703, blipText = "Bank", BankDistance = 3},
	{blip = 108, blipColor = 2, blipScale = 0.9, x = -112.202, y = 6469.295, z = 31.626, blipText = "Bank", BankDistance = 3},
	{blip = 108, blipColor = 2, blipScale = 0.9, x = 314.187, y = -278.621, z = 54.170, blipText = "Bank", BankDistance = 3},
	{blip = 108, blipColor = 2, blipScale = 0.9, x = -351.534, y = -49.529, z = 49.042, blipText = "Bank", BankDistance = 3},
	{blip = 108, blipColor = 3, blipScale = 1.2, x = 252.33, y = 218.11, z = 106.29, blipText = "BANK DAILYLIFE", BankDistance = 13},
	{blip = 108, blipColor = 2, blipScale = 0.9, x = 1175.064, y = 2706.643, z = 38.094, blipText = "Bank", BankDistance = 3},
}

Banking.ATMDistance = 1.5 -- How close you need to be in order to access the ATM

Banking.ATM = { -- ATM models, do not remove any
	{model = -870868698}, 
	{model = -1126237515}, 
	{model = -1364697528}, 
	{model = 506770882}
}