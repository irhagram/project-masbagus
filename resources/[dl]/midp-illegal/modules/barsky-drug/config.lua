Config = {}
Config.GiveBlack = true -- give black money? if disabled it'll give regular cash.
Config.CountPolice = true -- pendapatan uang sesuai jumlah polisi di server
Config.NotifPolice = false -- notifikasi untuk polisi
Config.DelayCreatePed = 30 * 60000 --- delay waktu spawn ped drugs
Config.PolisiDibutuhkan = 2 -- config minimal polisi di butuhkan
Config.PolisiAmbil = 0
Config.Rate = 0.80
Config.MinimumBlackMoney = 10000
Config.YouGot = "Mendapat $DL"
Config.BackFrom = " back from " --make sure you have the spaces like i do here.
Config.DirtyCash = " Uang Kotor"
Config.NotEnoughDirtyCash = "Uang Kotor Tidak Cukup.."
Config.ProgressbarLabel = "Mencuci uang.." --Label for the progressbar?
Config.ProgressbarTime = 20 
Config.WaktuJualan     = 5  * 1000

Config.Delays = {
	CannabisProcessing = 8 * 10,
	CokeProcessing = 8 * 10,
}

Config.CircleZones = {
	--Cannabis
	CannabisField = {coords = vector3(2018.04, 4889.96, 42.72)},
	CannabisProcessing = {coords = vector3(-1072.66, 4897.8, 214.27)},
	--Coke
	CokeField = {coords = vector3(2806.5, 4774.46, 46.98)},
	CokeProcessing = {coords = vector3(-1072.66, 4897.8, 214.27)},
}