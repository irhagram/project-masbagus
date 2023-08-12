---wip types

---@class OxShop
---@field name string
---@field blip? { id: number, colour: number, scale: number }
---@field inventory { name: string, price: number, count?: number, currency?: string }
---@field locations? vector3[]
---@field targets? { loc: vector3, length: number, width: number, heading: number, minZ: number, maxZ: number, distance: number, debug?: boolean, drawSprite?: boolean }[]
---@field groups? string | string[] | { [string]: number }

return {
	General = {
		name = 'Waroeng',
		blip = {
			id = 59, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'burger', price = 750 },
			{ name = 'cola', price = 750 },
			{ name = 'radio', price = 15000 },
			{ name = 'phone', price = 20000 },
			{ name = 'petfood', price = 1500 },
		}, locations = {
			vec3(25.7, -1347.3, 29.49),
			vec3(-3038.71, 585.9, 7.9),
			vec3(-3241.47, 1001.14, 12.83),
			vec3(1728.66, 6414.16, 35.03),
			vec3(1697.99, 4924.4, 42.06), 
			vec3(1961.48, 3739.96, 32.34),
			vec3(547.79, 2671.79, 42.15),
			vec3(2679.25, 3280.12, 55.24),
			vec3(2557.94, 382.05, 108.62),
			vec3(373.55, 325.56, 103.56),
			vec3(-1820.03, 785.98, 137.98),
		}, targets = {
			{ loc = vec3(25.06, -1347.32, 29.5), length = 0.7, width = 0.5, heading = 0.0, minZ = 29.5, maxZ = 29.9, distance = 1.5 },
			{ loc = vec3(-3039.18, 585.13, 7.91), length = 0.6, width = 0.5, heading = 15.0, minZ = 7.91, maxZ = 8.31, distance = 1.5 },
			{ loc = vec3(-3242.2, 1000.58, 12.83), length = 0.6, width = 0.6, heading = 175.0, minZ = 12.83, maxZ = 13.23, distance = 1.5 },
			{ loc = vec3(1728.39, 6414.95, 35.04), length = 0.6, width = 0.6, heading = 65.0, minZ = 35.04, maxZ = 35.44, distance = 1.5 },
			{ loc = vec3(1698.37, 4923.43, 42.06), length = 0.5, width = 0.5, heading = 235.0, minZ = 42.06, maxZ = 42.46, distance = 1.5 },
			{ loc = vec3(1960.54, 3740.28, 32.34), length = 0.6, width = 0.5, heading = 120.0, minZ = 32.34, maxZ = 32.74, distance = 1.5 },
			{ loc = vec3(548.5, 2671.25, 42.16), length = 0.6, width = 0.5, heading = 10.0, minZ = 42.16, maxZ = 42.56, distance = 1.5 },
			{ loc = vec3(2678.29, 3279.94, 55.24), length = 0.6, width = 0.5, heading = 330.0, minZ = 55.24, maxZ = 55.64, distance = 1.5 },
			{ loc = vec3(2557.19, 381.4, 108.62), length = 0.6, width = 0.5, heading = 0.0, minZ = 108.62, maxZ = 109.02, distance = 1.5 },		--BRANGKAS GA ADA--
			{ loc = vec3(373.13, 326.29, 103.57), length = 0.6, width = 0.5, heading = 345.0, minZ = 103.57, maxZ = 103.97, distance = 1.5 },
			{ loc = vec3(-706.76, -915.65, 19.22), length = 0.6, width = 0.5, heading = 0.0, minZ = 18.22, maxZ = 22.22, distance = 1.5 },
			{ loc = vec3(-48.54, -1759.13, 29.42), length = 0.6, width = 0.5, heading = 50.0, minZ = 28.42, maxZ = 32.42, distance = 1.5 },
			{ loc = vec3(1164.45, -324.85, 69.21), length = 0.6, width = 0.5, heading = 50.0, minZ = 68.21, maxZ = 72.21, distance = 1.5 },
			{ loc = vec3(-1819.92, 792.17, 138.11), length = 0.6, width = 0.5, heading = 50.0, minZ = 68.21, maxZ = 72.21, distance = 1.5 },	--BRANGKAS + BOBOL GA ADA--
		}
	},

	Liquor = {
		name = 'Liquor Store',
		blip = {
			id = 93, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'burger', price = 1500 },
			{ name = 'cola', price = 1500 },
		}, locations = {
			vec3(1135.808, -982.281, 46.415),
			vec3(-1222.915, -906.983, 12.326),
			vec3(-1487.553, -379.107, 40.163),
			vec3(-2968.243, 390.910, 15.043),
			vec3(1166.024, 2708.930, 38.157),
			vec3(1392.562, 3604.684, 34.980),
			vec3(-1393.409, -606.624, 30.319)
		}, targets = {
			{ loc = vec3(1134.9, -982.34, 46.41), length = 0.5, width = 0.5, heading = 96.0, minZ = 46.4, maxZ = 46.8, distance = 1.5 },		--BOBOL GA ADA--
			{ loc = vec3(-1222.33, -907.82, 12.43), length = 0.6, width = 0.5, heading = 32.7, minZ = 12.3, maxZ = 12.7, distance = 1.5 },		--BOBOL GA ADA-
			{ loc = vec3(-1486.67, -378.46, 40.26), length = 0.6, width = 0.5, heading = 133.77, minZ = 40.1, maxZ = 40.5, distance = 1.5 },	--BOBOL GA ADA-
			{ loc = vec3(-2967.0, 390.9, 15.14), length = 0.7, width = 0.5, heading = 85.23, minZ = 15.0, maxZ = 15.4, distance = 1.5 },		--BOBOL GA ADA-
			{ loc = vec3(1165.95, 2710.20, 38.26), length = 0.6, width = 0.5, heading = 178.84, minZ = 38.1, maxZ = 38.5, distance = 1.5 },		--BOBOL GA ADA-
			{ loc = vec3(1393.0, 3605.95, 35.11), length = 0.6, width = 0.6, heading = 200.0, minZ = 35.0, maxZ = 35.4, distance = 1.5 }		--BOBOL GA ADA-
		}
	},

	YouTool = {
		name = 'Pasar Pedagang',
        groups = {
			['pedagang'] = 0,
		},
		blip = {
			id = 402, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'daging_sapi', price = 150 },
            { name = 'packaged_chicken', price = 150 },
			{ name = 'beras', price = 75 },
			{ name = 'sambal', price = 75 },
			{ name = 'gula', price = 50 },
			{ name = 'jeruk', price = 75 },
			{ name = 'bgaram', price = 50 },
			{ name = 'fish', price = 150 },
			{ name = 'susu_murni', price = 100 },
			{ name = 'bottle', price = 50 },
			{ name = 'lemak', price = 100 },
            { name = 'water', price = 50 },
			{ name = 'bubuk_kopi', price = 75 },
            { name = 'radio', price = 5000 },
			{ name = 'phone', price = 10000 },
			{ name = 'boombox', price = 75000 },
			{ name = 'parachute', price = 75000 },
		}, locations = {
			vec3(2748.0, 3473.0, 55.67),
			vec3(342.99, -1298.26, 32.51)
		}, targets = {
			{ loc = vec3(2746.8, 3473.13, 55.67), length = 0.6, width = 3.0, heading = 65.0, minZ = 55.0, maxZ = 56.8, distance = 3.0 }
		}
	},

	Ammunation = {
		name = 'Toko Senjata',
		blip = {
			id = 110, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'WEAPON_KNIFE', price = 25000 },
			{ name = 'WEAPON_BAT', price = 50000 },
			{ name = 'WEAPON_MACHETE', price = 25000 },
			{ name = 'WEAPON_PISTOL', price = 200000, metadata = { registered = true }, license = 'weapon' },
            { name = 'ammo-9', price = 500, metadata = { registered = true }, license = 'weapon' },
		}, locations = {
			vec3(-662.180, -934.961, 21.829),
			vec3(810.25, -2157.60, 29.62),
			vec3(1693.44, 3760.16, 34.71),
			vec3(-330.24, 6083.88, 31.45),
			vec3(252.63, -50.00, 69.94),
			vec3(22.56, -1109.89, 29.80),
			vec3(2567.69, 294.38, 108.73),
			vec3(-1117.58, 2698.61, 18.55),
			vec3(842.44, -1033.42, 28.19)
		}, targets = {
			{ loc = vec3(-660.92, -934.10, 21.94), length = 0.6, width = 0.5, heading = 180.0, minZ = 21.8, maxZ = 22.2, distance = 2.0 },
			{ loc = vec3(808.86, -2158.50, 29.73), length = 0.6, width = 0.5, heading = 360.0, minZ = 29.6, maxZ = 30.0, distance = 2.0 },
			{ loc = vec3(1693.57, 3761.60, 34.82), length = 0.6, width = 0.5, heading = 227.39, minZ = 34.7, maxZ = 35.1, distance = 2.0 },
			{ loc = vec3(-330.29, 6085.54, 31.57), length = 0.6, width = 0.5, heading = 225.0, minZ = 31.4, maxZ = 31.8, distance = 2.0 },
			{ loc = vec3(252.85, -51.62, 70.0), length = 0.6, width = 0.5, heading = 70.0, minZ = 69.9, maxZ = 70.3, distance = 2.0 },
			{ loc = vec3(23.68, -1106.46, 29.91), length = 0.6, width = 0.5, heading = 160.0, minZ = 29.8, maxZ = 30.2, distance = 2.0 },
			{ loc = vec3(2566.59, 293.13, 108.85), length = 0.6, width = 0.5, heading = 360.0, minZ = 108.7, maxZ = 109.1, distance = 2.0 },
			{ loc = vec3(-1117.61, 2700.26, 18.67), length = 0.6, width = 0.5, heading = 221.82, minZ = 18.5, maxZ = 18.9, distance = 2.0 },
			{ loc = vec3(841.05, -1034.76, 28.31), length = 0.6, width = 0.5, heading = 360.0, minZ = 28.2, maxZ = 28.6, distance = 2.0 }
		}
	},

	PoliceArmoury = {
		name = 'Toko Senjata',
		groups = {
			['police'] = 16,
			['police'] = 15,
			['police'] = 14,
			['police'] = 13,
			['police'] = 12
		},
		inventory = {
			{ name = 'ammo-9', price = 5 },
			{ name = 'ammo-rifle', price = 5 },
			{ name = 'ammo-shotgun', price = 5 },
			{ name = 'ammo-heavysniper', price = 5 },
            { name = 'ammo-44', price = 5 },
			{ name = 'repairkit_senjata', price = 10000 },
			{ name = 'at_clip_extended_pistol', price = 25000 },
			{ name = 'at_clip_extended_smg', price = 25000 },
			{ name = 'at_clip_extended_rifle', price = 75000 },
			{ name = 'at_clip_extended_sniper', price = 100000 },
			{ name = 'WEAPON_FLASHLIGHT', price = 200 },
			{ name = 'WEAPON_NIGHTSTICK', price = 100 },
			{ name = 'WEAPON_CARBINERIFLE', price = 1000, metadata = { registered = true, serial = 'POL' }, license = 'weapon' },
			{ name = 'WEAPON_CARBINERIFLE_MK2', price = 1000, metadata = { registered = true, serial = 'POL' }, license = 'weapon' },
			{ name = 'WEAPON_APPISTOL', price = 1000, metadata = { registered = true, serial = 'POL' }, license = 'weapon' },
			{ name = 'WEAPON_SMG', price = 1000, metadata = { registered = true, serial = 'POL' }, license = 'weapon' },
			{ name = 'WEAPON_PISTOL_MK2', price = 1000, metadata = { registered = true, serial = 'POL' }, license = 'weapon' },
			{ name = 'WEAPON_REVOLVER', price = 1000, metadata = { registered = true, serial = 'POL' }, license = 'weapon' },
			{ name = 'WEAPON_COMBATPISTOL', price = 1000, metadata = { registered = true, serial = 'POL' }, license = 'weapon' },
			{ name = 'WEAPON_BULLPUPSHOTGUN', price = 1000, metadata = { registered = true, serial = 'POL' }, license = 'weapon' },
			{ name = 'WEAPON_HEAVYSNIPER', price = 1000, metadata = { registered = true, serial = 'POL' }, license = 'weapon' },
			{ name = 'contract', price = 20000 },
			{ name = 'WEAPON_STUNGUN', price = 500, metadata = { registered = true, serial = 'POL'} }
		}, locations = {
			vec3(451.51, -979.44, 30.68)
		}, targets = {
			{ loc = vec3(484.89, -994.48, 30.69), length = 2.0, width = 1.0, heading = 270.0, minZ = 29.69, maxZ = 33.69, distance = 6 }
		}
	},
    
    Mechanic = {
		name = 'Toko Mekanik',
		groups = {
			['mechanic'] = 0
		},
		blip = {
			id = 402, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'kanebo', price = 2000 },
            { name = 'WEAPON_WRENCH', price = 10000 },
			{ name = 'toolkit', price = 3999 },
			{ name = 'WEAPON_FIREEXTINGUISHER', price = 15000 }
		}, locations = {
			vec3(73.97, 6580.66, 31.75)
		}, targets = {
			{ loc = vec3(73.97, 6580.66, 31.75), length = 1, width = 2, heading = 315, minZ = 30.75, maxZ = 34.75, distance = 6 }

		}
	},

    MechanicBOS = {
		name = 'Toko BOS Mekanik',
		groups = {
			['mechanic'] = 2
		},
		inventory = {
			{ name = 'nitro', price = 100000 }
		}, locations = {
			vec3(56.28, 6568.55, 31.75)
		}, targets = {
			{ loc = vec3(56.28, 6568.55, 31.75), length = 1, width = 1, heading = 315, minZ = 30.75, maxZ = 34.75, distance = 6 }

		}
	},

	TokoBengKot = {
		name = 'Toko Mekanik Kota',
		groups = {
			['mechanic'] = 0
		},
		blip = {
			id = 402, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'kanebo', price = 2000 },
			{ name = 'toolkit', price = 3999 }
		}, locations = {
			vec3(-228.45, -1327.14, 30.89)
		}, targets = {
			{ loc = vec3(-228.45, -1327.14, 30.89), length = 1.0, width = 1.0, heading = 0.0, minZ = 29.89, maxZ = 33.89, distance = 6 }

		}
	},

	Medicine = {
		name = 'Apotek',
		groups = {
			['ambulance'] = 0
		},
		blip = {
			id = 403, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'medikit', price = 1500 },
			{ name = 'sertraline', price = 2000 },
			{ name = 'alprazolam', price = 4000 },
			{ name = 'tiketoplas', price = 50000 },
            { name = 'WEAPON_FLASHLIGHT', price = 10000 },
            { name = 'WEAPON_FIREEXTINGUISHER', price = 15000 },
			{ name = 'tabungoksigen', price = 25000 }
		}, locations = {
			vec3(-1823.69, -380.48, 49.41),
			vec3(1840.62, 3687.36, 34.28)
		}, targets = {
			{ loc = vec3(-1823.69, -380.48, 49.41), length = 3.0, width = 3.0, heading = 316.0, minZ = 47.41, maxZ = 51.41, distance = 6 },
			{ loc = vec3(1840.62, 3687.36, 34.28), length = 3.0, width = 3.0, heading = 300.0, minZ = 31.28, maxZ = 37.28, distance = 6 }

		}
	},

	EMSArmoury2 = {
		name = 'Toko BOS EMS',
		groups = {
			['ambulance'] = 3
		},
		inventory = {
			{ name = 'itemck', price = 1000000 },
			{ name = 'WEAPON_STUNGUN', price = 100000, metadata = { registered = false } }
		}, locations = {
			vec3(-1831.89, -339.75, 49.47)
		}, targets = {
			{ loc = vec3(-1831.89, -339.75, 49.47), length = 1.0, width = 1.0, heading = 320.0, minZ = 48.47, maxZ = 52.47, distance = 6 }

		}
	},

	EMSArmoury = {
		name = 'Toko Voucher',
		groups = {
			['ambulance'] = 2
		},
		inventory = {
			{ name = 'v_perban', price = 100000 }
		}, locations = {
			vec3(-1829.85, -389.98, 49.39)
		}, targets = {
			{ loc = vec3(-1829.85, -389.98, 49.39), length = 1.0, width = 1.0, heading = 320.0, minZ = 48.39, maxZ = 52.39, distance = 6 }

		}
	},	


	BlackMarketArms = {
		name = 'Black Market',
        groups = {
			['admin'] = 2
		},
		inventory = {
			{ name = 'weed', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'weed_pooch', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'coke', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'coke_pooch', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'boombox', price = 1, metadata = { registered = false }, currency = 'v_admin' },

			{ name = 'stone', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'washed_stone', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'wool', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'fabric', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'clothe', price = 1, metadata = { registered = false }, currency = 'v_admin' },

			{ name = 'copper', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'iron', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'gold', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'diamond', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'fish', price = 1, metadata = { registered = false }, currency = 'v_admin' },

			{ name = 'petrol', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'petrol_raffin', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'essence', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'hack_usb', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'itemck', price = 1, metadata = { registered = false }, currency = 'v_admin' },

			{ name = 'alive_chicken', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'slaughtered_chicken', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'packaged_chicken', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'leather', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'meat', price = 1, metadata = { registered = false }, currency = 'v_admin' },

			{ name = 'wood', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'cutted_wood', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'packaged_plank', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'lockpick', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'thermite', price = 1, metadata = { registered = false }, currency = 'v_admin' },

			{ name = 'kanebo', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'itemck', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'sertraline', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'alprazolam', price = 1, metadata = { registered = false }, currency = 'v_admin' },
			{ name = 'bandage', price = 1, metadata = { registered = false }, currency = 'v_admin' }
		}, locations = {
			vec3(-468.85, 1129.21, 325.85)
		}, targets = {
			{ loc = vec3(-468.85, 1129.21, 325.85), length = 1.0, width = 1.0, heading = 350.0, minZ = 324.85, maxZ = 328.85, distance = 2.5 }
		}
	},

	VendingMachineDrinks = {
		name = 'Vending Machine',
		inventory = {
			--{ name = 'water', price = 10 },
			--{ name = 'cola', price = 10 },
		},
		model = {
			--`prop_vend_soda_02`, `prop_vend_fridge01`, `prop_vend_water_01`, `prop_vend_soda_01`
		}
	}
}