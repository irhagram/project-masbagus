local isJudge = false
local isPolice = false
local isMedic = false
local isDoctor = false
local isNews = false
local isDead = false
local isInstructorMode = false
local myJob = "unemployed"
local isHandcuffed = false
local isHandcuffedAndWalking = false
local hasOxygenTankOn = false
local gangNum = 0
local cuffStates = {}
local PlayerData = {}

rootMenuConfig =  {
    {
        id = "idcard",
        displayName = "ID Card",
        icon = "#icard-general",
        enableMenu = function()
            return not isDead
        end,
        subMenus = {"idcard:checkid", "idcard:showid", "general:kasihnophone"}
    },
    {
        id = "animasi",
        displayName = "Animasi",
        icon = "#emotes-general",
        enableMenu = function()
            return not isDead
        end,
        subMenus = {"emotes:general", "emotes:no", "emotes:cheer", "emotes:slowclap", "emotes:foldarms2", "emotes:salute", "emotes:finger", "emotes:peace", "emotes:facepalm", "emotes:pusing", "emotes:facepalm4", "emotes:dead", "emotes:sit", "emotes:sitchair", "emotes:think2", "emotes:argue", "emotes:boi"}
    },
    {
        id = "Phone",
        displayName = "Phone",
        icon = "#cuffs-check-phone",
        enableMenu = function()
            return not isDead
        end,
        functionName = "alan-phone:openPhone"
    },
    {
        id = "clotheMenu",
        displayName = "Pakaian",
        icon = "#clotheMenu-general",
        enableMenu = function() return not isDead end,
        subMenus = {"clotheMenu:Shirt", "clotheMenu:Pants", "clotheMenu:bl", "clotheMenu:Mask", "clotheMenu:Shoes", "clotheMenu:Hair", "clotheMenu:Glasses", "clotheMenu:Hat", "clotheMenu:Bag", "clotheMenu:Bagoff", "clotheMenu:Vest", "clotheMenu:Neck", "clotheMenu:Watch", "clotheMenu:Bracelet", "clotheMenu:Visor", "clotheMenu:Top", "clotheMenu:Gloves", "clotheMenu:Ear"}
    },
    {
        id = "Inventory",
        displayName = "Inventory",
        icon = "#dl-inventory",
        enableMenu = function()
            return not isDead
        end,
        functionName = "ox_inventory:openInventory"
    },
    {
        id = "dokumen",
        displayName = "Dokumen",
        icon = "#dokumen-general",
        enableMenu = function()
            return not isDead
        end,
        functionName = "documents:openMenu"
    },
    {
        id = "kunci",
        displayName = "Kunci",
        icon = "#lockpick-general",
        functionName = "alan-kunci:kunciKendaraan",
        enableMenu = function()
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then
                return true
            else
                local veh, dist = ESX.Game.GetClosestVehicle()
                if dist < 2 then 
                    return true
                end
            end
        end
    },
    {
        id = "givekey",
        displayName = "Beri Kunci",
        icon = "#engine-general",
        functionName = "alan-kunci:kasihkunci",
        enableMenu = function()
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then
                return true
            else
                local veh, dist = ESX.Game.GetClosestVehicle()
                if dist < 2 then 
                    return true
                end
            end
        end
    },
    {
        id = "vehicle",
        displayName = "Kendaraan",
        icon = "#vehicle-options-vehicle",
        functionName = "veh:options",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId(), false))
        end
    },
    {
        id = "enginestart",
        displayName = "Start",
        icon = "#engine-general",
        functionName = "veh:EngineToggle",
        enableMenu = function()
            if (IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() and not isDead) then 
                if not IsVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(), false)) then 
                    return true
                else
                    return false
                end
            else
                return false
            end
        end
    },
    {
        id = "enginestop",
        displayName = "Stop",
        icon = "#engine-general",
        functionName = "veh:EngineToggle",
        enableMenu = function()
            if (IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() and not isDead) then 
                if IsVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(), false)) then 
                    return true
                else
                    return false
                end
            else
                return false
            end
        end
    },
    {
        id = "rumah",
        displayName = "Rumah",
        icon = "#property-general",
        enableMenu = function()
            return (exports["alan-property"]:getInRumahCOK() and not IsDead)
        end,
        subMenus = {"rumah:kuncirumah", "rumah:dekorasi", "rumah:setstash", "rumah:setbaju"}
    },
    -- JOB WHITELIST

    {
        id = "mechanicaction",
        displayName = "MEKANIK",
        icon = "#police-action",
        enableMenu = function()
        local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
            if PlayerData.job.name == "mechanic" and not fuck then
                return true
            end
        end,
        subMenus = {'repair','wash','boboll','sitamech', 'towingg', 'mech:billing'}
    },

    {
        id = "policeaction",
        displayName = "Polisi",
        icon = "#police-action",
        enableMenu = function()
        local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
            
            if PlayerData.job.name == "police" and not fuck then
                return true
            end
        end,
        subMenus = {'drag','borgol','lepasborgol','geledah','denda','cekbilling','masukpaksa','keluarpaksa','penjara','spwnobj','bilcus','police:samsat','police:cktp','bobol','cekkendaraan','sitamech'}
    },

    {
        id = "policedown",
        displayName = "Polisi Down",
        icon = "#police-general",
        enableMenu = function()
            local Data = ESX.GetPlayerData()
            return (Data.job.name == 'police' and isDead)
        end, subMenus = {"police:s13"}
    },

    {
        id = "ambulanceaction",
        displayName = "EMS",
        icon = "#police-action",
        enableMenu = function()
        local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
            if PlayerData.job.name == "ambulance" and not fuck then
                return true
            end
        end,
        subMenus =  {"general:revive", "general:big", "ambulance:cekdeath", "general:billingems", "masukpaksa", "keluarpaksa", "borgol", "lepasborgol"}
    },
    {
        id = "pedagang",
        displayName = "PEDAGANG",
        icon = "#police-action",
        enableMenu = function()
        local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
            if PlayerData.job.name == "pedagang" and not fuck then
                return true
            end
        end,
        subMenus =  {"pedagang:billing"}
    },
    {
        id = "badside-action",
        displayName = "Job",
        icon = "#police-action",
        enableMenu = function()
            local Data = ESX.GetPlayerData()
            return (Data.job.name == 'mafia' or Data.job.name == 'yakuza' or Data.job.name == 'biker' or Data.job.name == 'gang' or Data.job.name == 'cartel' or Data.job.name == 'ormas' or Data.job.name == 'badside7' or Data.job.name == 'badside8'  or Data.job.name == 'badside9' or Data.job.name == 'badside10' or Data.job.name == 'badside11' or Data.job.name == 'badside12' or Data.job.name == 'badside13' or Data.job.name == 'badside14'and not isDead)
        end,
        subMenus = {'borgol','lepasborgol','geledah','drag'}
    }

}

newSubMenus = {
    ['general:emotes'] = {
        title = "Emotes",
        icon = "#general-emotes",
        commandName = "emotemenu"
    },

    ['general:doc'] = {
        title = "Document",
        icon = "#dl-dok",
        commandName = "dokumen"
    },
    -- Identity
    ['idcard:checkid'] = {
        title = "Cek Ktp",
        icon = "#icard-general",
        commandName = "showid"
    }, 
    ['idcard:showid'] = {
        title = "Beri Ktp",
        icon = "#icard-general",
        commandName = "showidpl"
    }, 
    ['general:kasihnophone'] = {
        title = "Give Contact",
        icon = "#address-book",
        functionName = "qs-smartphone:client:GiveContactDetails"
    },
    -- POLISI
    ['drag'] = {
        title = "Seret/Lepas Seret",
        icon = "#general-escort",
        functionName = "dl-job:dragg"
    },
    ['borgol'] = {
        title = "Borgol",
        icon = "#general-escort",
        functionName = "dl-job:borgol"
    },
    ['cekkendaraan'] = {
        title = "Cek Kendaraan",
        icon = "#general-escort",
        functionName = "dl-job:checkstnk"
    },
    ['lepasborgol'] = {
        title = "Lepas Borgol",
        icon = "#general-escort",
        functionName = "dl-job:lepasborgol"
    },
    ['police:cktp'] = {
        title = "Cek ktp",
        icon = "#general-escort",
        functionName = "dl-job:cekKtp"
    },
    ['police:samsat'] = {
        title = "Menyita Samsat",
        icon = "#car",
        functionName = "dl-job:samsat"
    },
    ['bobol'] = {
        title = "Bobol Kendaraan",
        icon = "#car",
        functionName = "dl-job:bobol"
    },
    ['geledah'] = {
        title = "Geledah",
        icon = "#general-escort",
        functionName = "dl-job:geledah"
    },
    ['denda'] = {
        title = "Denda",
        icon = "#general-escort",
        functionName = "dl-job:fine"
    },
    ['cekbilling'] = {
        title = "Cek Billing Belum Dibayar",
        icon = "#general-escort",
        functionName = "dl-job:cekbilling"
    },
    ['penjara'] = {
        title = "Penjara",
        icon = "#general-escort",
        functionName = "esx-qalle-jail:openJailMenu"
    },
    ['spwnobj'] = {
        title = "Spawn Object",
        icon = "#general-escort",
        functionName = "dl-job:objspawn"
    },
    ['bilcus'] = {
        title = "Billing Custom",
        icon = "#general-escort",
        functionName = "dl-job:blipocok"
    },
    ['masukpaksa'] = {
        title = "Masukkin Paksa",
        icon = "#general-escort",
        functionName = "dl-job:masukpaksa"
    },
    ['keluarpaksa'] = {
        title = "Keluarin Paksa",
        icon = "#general-escort",
        functionName = "dl-job:keluarpaksa"
    },
    --TAXI--
    ['taxi:billing'] = {
        title = "Billing",
        icon = "#document",
        functionName = "mk-taxi:billing"
    },
    --PEDAGANG
    ['pdg:billing'] = {
        title = "Billing",
        icon = "#document",
        functionName = "marskuy-ped:billing"
    },
    ['kunci:ken'] = {
        title = "Lock Vehicle",
        icon = "#car",
        functionName = "kunciken"
    },
    ['pedagang:billing'] = {
        title = "Tagihan",
        icon = "#judge-raid-take-cash",
        functionName = "dl-job:billpeda"
    },
   -- EMS
    ['general:billingems'] = {
        title = "Tagihan",
        icon = "#judge-raid-take-cash",
        functionName = "dl-job:billems"
    },

    ['general:revive'] = {
        title = "Revive",
        icon = "#judge-raid-take-med",
        functionName = "dl-job:revive"
    },

    ['general:big'] = {
        title = "Treatment",
        icon = "#judge-raid-take-rev",
        functionName = "dl-job:big"
    },
    ['ambulance:cekdeath'] = {
        title = "Periksa",
        icon = "#ambulance-cekdeath",
        functionName = "dl-job:cDeath"
    },
    -- MEKANIK
    ['mech:billing'] = {
        title = "Billing",
        icon = "#document",
        functionName = "dl-job:billingmecha"
    },
    ['repair'] = {
        title = "Repair",
        icon = "#mech-repair",
        functionName = "repairmech"
    },
    ['wash'] = {
        title = "Wash",
        icon = "#mech-wash",
        functionName = "cleanmech"
    },
    ['boboll'] = {
        title = "Bobol",
        icon = "#mech-door",
        functionName = "bobolmecha"
    },
    ['sitamech'] = {
        title = "Impound",
        icon = "#car",
        functionName = "sitamech"
    },
    ['towingg'] = {
        title = "Towing",
        icon = "#car",
        functionName = "towing"
    },
    ['billingmech'] = {
        title = "Billing",
        icon = "#car",
        functionName = "billingngontol"
    },
    ['police:s13'] = {
        title = "S13",
        icon = "#police-dead",
        functionName = "dl-job:s13"
    },
    -- BADSIDE
    ['badside:borgol'] = {
        title = "Ikat/Lepas ikatan",
        icon = "#cuffs-cuff",
        commandName = "badsidemenucok handcuff"
    },

    ['badside:geledah'] = {
        title = "Geledah",
        icon = "#cuffs-check-inventory",
        commandName = "badsidemenucok body_search"
    },
    --menubaju--
    ['clotheMenu:Top'] = {
        title = "Top",
        icon = "#clotheMenu:Top",
        commandName = "top"
    },
    ['clotheMenu:Gloves'] = {
        title = "Gloves",
        icon = "#clotheMenu:Gloves",
        commandName = "gloves"
    },
    ['clotheMenu:Visor'] = {
        title = "Visor",
        icon = "#clotheMenu:Visor",
        commandName = "visor"
    },
    ['clotheMenu:Bag'] = {
        title = "Bag",
        icon = "#clotheMenu:Bag",
        commandName = "bag"
    },
    ['clotheMenu:Shoes'] = {
        title = "Shoes",
        icon = "#clotheMenu:Shoes",
        commandName = "shoes"
    },
    ['clotheMenu:Vest'] = {
        title = "Vest",
        icon = "#clotheMenu:Vest",
        commandName = "vest"
    },
    ['clotheMenu:Hair'] = {
        title = "Hair",
        icon = "#clotheMenu:Hair",
        commandName = "hair"
    },
    ['clotheMenu:Hat'] = {
        title = "Hat",
        icon = "#clotheMenu:Hat",
        commandName = "hat"
    },
    ['clotheMenu:Glasses'] = {
        title = "Glasses",
        icon = "#clotheMenu:Glasses",
        commandName = "glasses"
    },
    ['clotheMenu:Ear'] = {
        title = "Ear",
        icon = "#clotheMenu:Ear",
        commandName = "ear"
    },
    ['clotheMenu:Neck'] = {
        title = "Neck",
        icon = "#clotheMenu:Neck",
        commandName = "neck"
    },
    ['clotheMenu:Watch'] = {
        title = "Watch",
        icon = "#clotheMenu:Watch",
        commandName = "watch"
    },
    ['clotheMenu:Bracelet'] = {
        title = "Bracelet",
        icon = "#clotheMenu:Bracelet",
        commandName = "bracelet"
    },
    ['clotheMenu:Mask'] = {
        title = "Mask",
        icon = "#clotheMenu:Mask",
        commandName = "mask"
    },
    ['clotheMenu:Pants'] = {
        title = "Pants",
        icon = "#clotheMenu:Pants",
        commandName = "pants"
    },
    ['clotheMenu:bl'] = {
        title = "Baju Lengkap",
        icon = "#clotheMenu:Pants",
        functionName = "dl-radial:loadSkin"
    },
    ['clotheMenu:Shirt'] = {
        title = "Shirt",
        icon = "#clotheMenu:Shirt",
        commandName = "shirt"
    },
    ['clotheMenu:Bagoff'] = {
        title = "Buka Tas",
        icon = "#clotheMenu:Bagoff",
        commandName = "bagoff"
    },
        --EMOTE
    ['emotes:general'] = {
        title = "Open Menu",
        icon = "#emotes-general",
        commandName = "dpemotes:openMenu"
    },
    ['emotes:no'] = {
        title = "NO",
        icon = "#emotes-general",
        commandName = "e no"
    },
    ['emotes:cheer'] = {
        title = "CHEER",
        icon = "#emotes-general",
        commandName = "e cheer"
    },
    ['emotes:slowclap'] = {
        title = "CLAP",
        icon = "#emotes-general",
        commandName = "e slowclap"
    },  
    ['emotes:foldarms2'] = {
        title = "FOLDARMS",
        icon = "#emotes-general",
        commandName = "e foldarms2"
    },  
    ['emotes:leanwall'] = {
        title = "LEAN",
        icon = "#emotes-general",
        commandName = "e leanwall"
    },  
    ['emotes:salute'] = {
        title = "SALUTE",
        icon = "#emotes-general",
        commandName = "e salute"
    },  
    ['emotes:finger'] = {
        title = "FINGER",
        icon = "#emotes-general",
        commandName = "e finger"
    },  
    ['emotes:peace'] = {
        title = "PEACE",
        icon = "#emotes-general",
        commandName = "e peace"
    }, 
    ['emotes:facepalm'] = {
        title = "FACEPALM",
        icon = "#emotes-general",
        commandName = "e facepalm"
    }, 
    ['emotes:pusing'] = {
        title = "PUSING",
        icon = "#emotes-general",
        commandName = "e pusing"
    }, 
    ['emotes:facepalm4'] = {
        title = "FACEPALM4",
        icon = "#emotes-general",
        commandName = "e facepalm4"
    }, 
    ['emotes:dead'] = {
        title = "DEAD",
        icon = "#emotes-general",
        commandName = "e dead"
    }, 
    ['emotes:sit'] = {
        title = "SIT",
        icon = "#emotes-general",
        commandName = "e sit"
    }, 
    ['emotes:sitchair'] = {
        title = "SITCHAIR",
        icon = "#emotes-general",
        commandName = "e sitchair"
    }, 
    ['emotes:think2'] = {
        title = "THINK2",
        icon = "#emotes-general",
        commandName = "e think2"
    }, 
    ['emotes:argue'] = {
        title = "ARGUE",
        icon = "#emotes-general",
        commandName = "e argue"
    }, 
    ['emotes:boi'] = {
        title = "BOI",
        icon = "#emotes-general",
        commandName = "e boi"
    },
        --rumah--
    --[[['rumah:berikunci'] = {
        title = "Beri Kunci",
        icon = "#lockpick-general",
        functionName = "alan-property:client:giveHouseKey"
    },
    ['rumah:copotkunci'] = {
        title = "Copot Kunci",
        icon = "#lockpick-general",
        functionName = "alan-property:client:removeHouseKey"
    },]]
    ['rumah:kuncirumah'] = {
        title = "Toggle Door",
        icon = "#lockpick-general",
        functionName = "alan-property:client:toggleDoorlock"
    },
    ['rumah:dekorasi'] = {
        title = "Decorate",
        icon = "#property-decoratehouse",
        functionName = "alan-property:client:decorate"
    },
    ['rumah:setstash'] = {
        title = "Set Inv",
        icon = "#property-setstash",
        commandName = "setlokasi setstash"
    },
    ['rumah:setbaju'] = {
        title = "Set Baju",
        icon = "#clotheMenu-general",
        commandName = "setlokasi setoutift"
    }
    --[[['rumah:keluarumah'] = {
        title = "Set Logout",
        icon = "#property-setlogout",
        commandName = "setlokasi setlogout"
    }]]
}