Config = {}

Config.NotifyType = "midp-tasknotify" -- Options = t-notify, esx, mythic_notify, okokNotify
Config.LoadingType = "mythic" -- Options = mythic, pogress, none
Config.OxInventory = true -- When true, ox inventory related exports will work.

Config.IllegalTaskBlacklist = {
    -- Jobs in here cannot perform illegal tasks, if the script checks for it. Such as drug collection / selling.
    police = {},
    ambulance = {},
    mechanic = {}
}

Config.ItemsCrafting = {
	['sate'] = {
		label = 'Sate Ayam',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 10000,
        jumlahnya = 50,
		requiredItems = {
			{ item = "packaged_chicken", item_label = "Paket Ayam", amount = 10 },
			{ item = "lemak", item_label = "Lemak", amount = 10 },
			{ item = "sambal", item_label = "Sambal", amount = 10 },
			{ item = "bgaram", item_label = "Garam", amount = 15 },
		}
	},
    ['kebab'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 10000,
        jumlahnya = 50,
		requiredItems = {
			{ item = "daging_sapi", item_label = "Daging Sapi", amount = 10 },
			{ item = "lemak", item_label = "Lemak", amount = 10 },
			{ item = "sambal", item_label = "Sambal", amount = 10 },
			{ item = "bgaram", item_label = "Garam", amount = 15 },
		}
	},
    ['buburayam'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 10000,
        jumlahnya = 50,
		requiredItems = {
			{ item = "packaged_chicken", item_label = "Paket Ayam", amount = 10 },
			{ item = "water", item_label = "Air", amount = 20 },
			{ item = "beras", item_label = "Beras", amount = 10 },
			{ item = "bgaram", item_label = "Garam", amount = 15 },
		}
	},
    ['soto'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 10000,
        jumlahnya = 50,
		requiredItems = {
			{ item = "daging_sapi", item_label = "Daging Sapi", amount = 10 },
			{ item = "water", item_label = "Air", amount = 20 },
			{ item = "sambal", item_label = "Sambal", amount = 10 },
			{ item = "bgaram", item_label = "Garam", amount = 15 },
		}
	},
	['esbuah'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 10000,
        jumlahnya = 50,
		requiredItems = {
            { item = "water", item_label = "Air", amount = 25 },
			{ item = "gula", item_label = "Gula", amount = 15 },
			{ item = "jeruk", item_label = "Jeruk", amount = 20 },
			{ item = "bottle", item_label = "Botol", amount = 10 },
		}
	},
	['esjeruk'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 10000,
        jumlahnya = 50,
		requiredItems = {
            { item = "water", item_label = "Air", amount = 25 },
			{ item = "gula", item_label = "Gula", amount = 15 },
			{ item = "jeruk", item_label = "Jeruk", amount = 20 },
			{ item = "bottle", item_label = "Botol", amount = 10 },
		}
	},
	['kopi'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 10000,
        jumlahnya = 50,
		requiredItems = {
            { item = "water", item_label = "Air", amount = 25 },
			{ item = "gula", item_label = "Gula", amount = 15 },
			{ item = "bubuk_kopi", item_label = "Bubuk Kopi", amount = 20 },
			{ item = "bottle", item_label = "Botol", amount = 10 },
		}
	},
	['eskopyor'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 10000,
        jumlahnya = 50,
		requiredItems = {
            { item = "water", item_label = "Air", amount = 25 },
			{ item = "gula", item_label = "Gula", amount = 15 },
			{ item = "susu_murni", item_label = "Ikan", amount = 15 },
			{ item = "bottle", item_label = "Botol", amount = 10 },
		}
	},
	['susu'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 10000,
        jumlahnya = 50,
		requiredItems = {
			{ item = "susu_murni", item_label = "Susu Murni", amount = 20 },
			{ item = "gula", item_label = "Gula", amount = 15 },
			{ item = "bottle", item_label = "Botol", amount = 10 },
		}
	},
	--BADSIDE SENJATA
	['WEAPON_PISTOL50'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 1,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 55 },
			{ item = "iron", item_label = "Susu Murni", amount = 40 },
			{ item = "gold", item_label = "Gula", amount = 5 },
			{ item = "diamond", item_label = "Botol", amount = 4 },
			{ item = "kit_senjata", item_label = "Botol", amount = 1 },
			{ item = "black_money", item_label = "Botol", amount = 27250 },
		}
	},
	['WEAPON_MACHINEPISTOL'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 1,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 85 },
			{ item = "iron", item_label = "Susu Murni", amount = 70 },
			{ item = "gold", item_label = "Gula", amount = 10 },
			{ item = "diamond", item_label = "Botol", amount = 3 },
			{ item = "kit_senjata", item_label = "Botol", amount = 2 },
			{ item = "black_money", item_label = "Botol", amount = 62500 },
		}
	},
	['WEAPON_MICROSMG'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 1,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 100 },
			{ item = "iron", item_label = "Susu Murni", amount = 75 },
			{ item = "gold", item_label = "Gula", amount = 10 },
			{ item = "diamond", item_label = "Botol", amount = 3 },
			{ item = "kit_senjata", item_label = "Botol", amount = 2 },
			{ item = "black_money", item_label = "Botol", amount = 112000 },
		}
	},
	['WEAPON_ASSAULTRIFLE'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 1,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 110 },
			{ item = "iron", item_label = "Susu Murni", amount = 80 },
			{ item = "gold", item_label = "Gula", amount = 40 },
			{ item = "diamond", item_label = "Botol", amount = 4 },
			{ item = "kit_senjata", item_label = "Botol", amount = 5 },
			{ item = "black_money", item_label = "Botol", amount = 141900 },
		}
	},
	['WEAPON_REVOLVER_MK2'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 1,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 140 },
			{ item = "iron", item_label = "Susu Murni", amount = 110 },
			{ item = "gold", item_label = "Gula", amount = 15 },
			{ item = "diamond", item_label = "Botol", amount = 5 },
			{ item = "kit_senjata", item_label = "Botol", amount = 8 },
			{ item = "black_money", item_label = "Botol", amount = 269500 },
		}
	},
	['WEAPON_HEAVYSNIPER'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 1,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 165 },
			{ item = "iron", item_label = "Susu Murni", amount = 135 },
			{ item = "gold", item_label = "Gula", amount = 15 },
			{ item = "diamond", item_label = "Botol", amount = 6 },
			{ item = "kit_senjata", item_label = "Botol", amount = 10 },
			{ item = "black_money", item_label = "Botol", amount = 284750 },
		}
	},
	--BADSIDE PELURU
	['ammo-50'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 10,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 40 },
			{ item = "iron", item_label = "Susu Murni", amount = 20 },
		}
	},
	['ammo-rifle2'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 20,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 60 },
			{ item = "iron", item_label = "Susu Murni", amount = 30 },
		}
	},
	['ammo-9'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 20,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 40 },
			{ item = "iron", item_label = "Susu Murni", amount = 20 },
		}
	},
	['ammo-45'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 20,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 60 },
			{ item = "iron", item_label = "Susu Murni", amount = 30 },
		}
	},
	['ammo-44'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 6,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 50 },
			{ item = "iron", item_label = "Susu Murni", amount = 25 },
		}
	},
	['ammo-heavysniper'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 5,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 40 },
			{ item = "iron", item_label = "Susu Murni", amount = 20 },
		}
	},
	--BADSIDE PERAMPOKAN
	['thermite'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 1,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 45 },
			{ item = "iron", item_label = "Susu Murni", amount = 40 },
			{ item = "gold", item_label = "Gula", amount = 5 },
			{ item = "diamond", item_label = "Botol", amount = 4 },
			{ item = "coke_pooch", item_label = "Botol", amount = 2 },
			{ item = "black_money", item_label = "Botol", amount = 7750 },
		}
	},
	['hack_usb'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 1,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 25 },
			{ item = "iron", item_label = "Susu Murni", amount = 15 },
			{ item = "gold", item_label = "Gula", amount = 3 },
			{ item = "diamond", item_label = "Botol", amount = 2 },
			{ item = "black_money", item_label = "Botol", amount = 14750 },
		}
	},
	['lockpick'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 1,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 15 },
			{ item = "iron", item_label = "Susu Murni", amount = 10 },
			{ item = "gold", item_label = "Gula", amount = 2 },
			{ item = "diamond", item_label = "Botol", amount = 1 },
			{ item = "black_money", item_label = "Botol", amount = 8750 },
		}
	},
	['laptop_h'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 1,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 20 },
			{ item = "iron", item_label = "Susu Murni", amount = 15 },
			{ item = "gold", item_label = "Gula", amount = 5 },
			{ item = "diamond", item_label = "Botol", amount = 1 },
			{ item = "black_money", item_label = "Botol", amount = 12500 },
		}
	},
	['kit_senjata'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 1,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 30 },
			{ item = "iron", item_label = "Susu Murni", amount = 25 },
			{ item = "gold", item_label = "Gula", amount = 3 },
			{ item = "black_money", item_label = "Botol", amount = 39000 },
		}
	},
	['repairkit_senjata'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 1,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 45 },
			{ item = "iron", item_label = "Susu Murni", amount = 40 },
			{ item = "gold", item_label = "Gula", amount = 5 },
			{ item = "black_money", item_label = "Botol", amount = 62250 },
		}
	},
	['armor'] = {
		label = 'Pecel',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 1,
		requiredItems = {
			{ item = "iron", item_label = "Susu Murni", amount = 30 },
			{ item = "gold", item_label = "Gula", amount = 7 },
			{ item = "diamond", item_label = "Botol", amount = 3 },
			{ item = "fabric", item_label = "Susu Murni", amount = 4 },
			{ item = "leather", item_label = "Susu Murni", amount = 4 },
			{ item = "black_money", item_label = "Botol", amount = 12700 },
		}
	},
	--BADSIDE ATACHMENT SENJATA
	['at_clip_extended_pistol'] = {
		label = 'Extended Pistol Clip',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 1,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 40 },
			{ item = "iron", item_label = "Susu Murni", amount = 20 },
			{ item = "black_money", item_label = "Botol", amount = 30000 },
		}
	},
	['at_clip_extended_smg'] = {
		label = 'Extended SMG Clip',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 1,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 50 },
			{ item = "iron", item_label = "Susu Murni", amount = 40 },
			{ item = "black_money", item_label = "Botol", amount = 59500 },
		}
	},
	['at_clip_extended_rifle'] = {
		label = 'Extended Rifle Clip',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 1,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 55},
			{ item = "iron", item_label = "Susu Murni", amount = 45 },
			{ item = "black_money", item_label = "Botol", amount = 95250 },
		}
	},
	['at_clip_extended_sniper'] = {
		label = 'Extended Sniper Clip',
		isWeapon = false,
		SuccessRate = 100,
		craftingtime = 7000,
        jumlahnya = 1,
		requiredItems = {
			{ item = "copper", item_label = "Susu Murni", amount = 85 },
			{ item = "iron", item_label = "Susu Murni", amount = 70 },
			{ item = "black_money", item_label = "Botol", amount = 143250 },
		}
	},
	--JOB NON WL
	['fabric'] = {
		label = 'fabric',
        isWeapon = false,
		SuccessRate = 100,
		craftingtime = 5000,
		jumlahnya = 2,
		requiredItems = {
			{ item = "wool", item_label = " ", amount = 4 },
		}
	},
	['clothe'] = {
		label = 'clothe',
        isWeapon = false,
		SuccessRate = 100,
		craftingtime = 10000,
		jumlahnya = 1,
		requiredItems = {
			{ item = "fabric", item_label = " ", amount = 4 },
		}
	},
	['slaughtered_chicken'] = {
		label = 'slaughtered_chicken',
        isWeapon = false,
		SuccessRate = 100,
		craftingtime = 6000,
		jumlahnya = 8,
		requiredItems = {
			{ item = "alive_chicken", item_label = " ", amount = 4 },
		}
	},
	['packaged_chicken'] = {
		label = 'packaged_chicken',
        isWeapon = false,
		SuccessRate = 100,
		craftingtime = 8000,
		jumlahnya = 10,
		requiredItems = {
			{ item = "slaughtered_chicken", item_label = " ", amount = 8 },
		}
	},
	['washed_stone'] = {
		label = 'washed_stone',
        isWeapon = false,
		SuccessRate = 100,
		craftingtime = 5000,
		jumlahnya = 1,
		requiredItems = {
			{ item = "stone", item_label = " ", amount = 1 },
		}
	},
}

Config.JualItem = {
    packaged_chicken = math.random(5, 10),
    clothe = math.random(10, 20),
}