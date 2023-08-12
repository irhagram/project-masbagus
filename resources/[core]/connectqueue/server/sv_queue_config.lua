Config = {}

-- priority list can be any identifier. (hex steamid, steamid32, ip) Integer = power over other people with priority
-- a lot of the steamid converting websites are broken rn and give you the wrong steamid. I use https://steamid.xyz/ with no problems.
-- you can also give priority through the API, read the examples/readme.
Config.Priority = {
	["steam:11000013f5fbf6a"] = 100, -- ALAN
	["steam:1100001461d550d"] = 90, -- ILHAM
	["steam:110000110b0a540"] = 90, -- bie
	["steam:1100001451ed205"] = 80, -- rapza
	["steam:11000013ff9e129"] = 80, -- Asep
    ["steam:110000135c18c46"] = 80, -- Adit
    ["steam:1100001081ccd49"] = 80, -- Eggy
    ["steam:110000112cd089b"] = 80, -- Bara Sky
    ["steam:110000106a54d8e"] = 80, -- Jamess
    ["steam:110000134f18d0f"] = 80, -- Pace

	--donasi--
	--PRIO I = 75
    ["steam:11000014b8d5f8c"] = 75, -- KaizerT
    ["steam:110000131e8bc3b"] = 75, --zynmalih
    ["steam:1100001118d1ff9"] = 75, --IBAL
	--PRIO 2 = 65
    ["steam:110000131cf1e34"] = 65, -- anchor
    ["steam:11000013f668071"] = 65, -- anchor
	--PRIO 3 = 55
    ["steam:110000134f18d0f"] = 55, -- DUNG
    ["steam:11000014ac7a59f"] = 55, -- adeng
    ["steam:11000014150641a"] = 55, -- anchor
    ["steam:1100001152a8468"] = 55, --mouri#6110
    --AISH

	--CEMEMEW--
	["steam:1100001475aa719"] = 60, -- Carol
	["steam:1100001491757a7"] = 50, -- Rara 
    ["steam:1100001000056ba"] = 50, -- Reisha 
   	["steam:11000011c14856c"] = 50, -- Quena 
   	["steam:11000013659f7ad"] = 50, -- Beby 
    ["steam:11000014b2180b6"] = 50, -- Meydie
	["steam:11000011b6c0096"] = 50, -- Pika
    ["steam:11000011670cec1"] = 50, -- Cima
    ["steam:110000153c78f28"] = 50, -- Meli
    ["steam:110000142096284"] = 50, -- NoUrBae
    ["steam:1100001196781b8"] = 50, -- flowerbby
    ["steam:1100001567b7df3"] = 50, -- biancamerliana
    ["steam:11000014d491832"] = 50, -- dnooots
    ["steam:11000014453db6c"] = 50, -- FIAA ONFOOT
    ["steam:1100001346a8c95"] = 50, -- qiqiss
    ["steam:11000014d4e8eac"] = 50, -- Rainvy
    ["steam:110000142fff69b"] = 50, -- argaceee
    ["steam:11000014c101951"] = 50, -- cffc`acedefakyu
    ["steam:11000010acca8bf"] = 50, -- Ecaalmaniaa
    ["steam:1100001579ed2da"] = 50, -- Alice Clara
    ["steam:110000109dfd061"] = 50, -- AISH
    ["steam:110000113dacb55"] = 50, -- Cimory
    ["steam:11000014aa0cd3d"] = 50, -- Chamoomile
    ["steam:110000143ca63ae"] = 50, -- J E N
    ["steam:11000013a90614c"] = 50, -- strenger
}

-- require people to run steam
Config.RequireSteam = true

-- "whitelist" only server
Config.PriorityOnly = false

-- disables hardcap, should keep this true
Config.DisableHardCap = true

-- will remove players from connecting if they don't load within: __ seconds; May need to increase this if you have a lot of downloads.
-- i have yet to find an easy way to determine whether they are still connecting and downloading content or are hanging in the loadscreen.
-- This may cause session provider errors if it is too low because the removed player may still be connecting, and will let the next person through...
-- even if the server is full. 10 minutes should be enough
Config.ConnectTimeOut = 600

-- will remove players from queue if the server doesn't recieve a message from them within: __ seconds
Config.QueueTimeOut = 90

-- will give players temporary priority when they disconnect and when they start loading in
Config.EnableGrace = false

-- how much priority power grace time will give
Config.GracePower = 5

-- how long grace time lasts in seconds
Config.GraceTime = 480

Config.AntiSpamTimer = 10
Config.PleaseWait_1 = "Mohon menunggu "
Config.PleaseWait_2 = " detik. Data kamu sedang di persiapkan untuk memasuki kota!"

-- on resource start, players can join the queue but will not let them join for __ milliseconds
-- this will let the queue settle and lets other resources finish initializing
Config.JoinDelay = 30000

-- will show how many people have temporary priority in the connection message
Config.ShowTemp = false

-- simple localization
Config.Language = {
    joining = "\xE2\x8F\xB3OTW Masuk...",
    connecting = "\xE2\x8F\xB3[queue]Cek Data...",
    idrr = "\xE2\x9D\x97[queue] Error: Couldn't retrieve any of your id's, try restarting.",
    err = "\xE2\x9D\x97[queue] There was an error",
    pos = "\xE2\x8F\xB3Kamu dalam antrian %d/%d \xF0\x9F\x95\x9C%s | https://discord.gg/dailyliferoleplay",
    connectingerr = "\xE2\x9D\x97[queue] Error: Error adding you to connecting list",
    timedout = "\xE2\x9D\x97[queue] Error: Timed out?",
    wlonly = "\xE2\x9D\x97[queue] Server Maintenance!",
    steam = "\xE2\x9D\x97 [queue] Error: Steam must be running"
}