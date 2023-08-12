return {
	['testburger'] = {
		label = 'Test Burger',
		weight = 220,
		degrade = 10,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			export = 'ox_inventory_examples.testburger'
		},
		server = {
			export = 'ox_inventory_examples.testburger',
			test = 'what an amazingly delicious burger, amirite?'
		},
		buttons = {
			{
				label = 'Lick it',
				action = function(slot)
					print('You licked the burger')
				end
			},
			{
				label = 'Squeeze it',
				action = function(slot)
					print('You squeezed the burger :(')
				end
			}
		},
		consume = 0.3
	},

	['bandage'] = {
		label = 'Perban',
		weight = 115,
		client = {
			anim = { dict = 'amb@world_human_clipboard@male@idle_a', clip = 'idle_c', flag = 49 },
			prop = { bone = 18905, model = `prop_ld_health_pack`, pos = vec3(0.15, 0.08, 0.1), rot = vec3(180.0, 220.0, 0.0) },
			disable = { move = false, car = true, combat = true },
			usetime = 10000,
		}
	},
	
	['black_money'] = {
		label = 'Uang Merah',
	},
	-- Makanan --
	['burger'] = {
		label = 'Burger',
		weight = 100,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 3000,
		},
	},
	['roti'] = {
		label = 'Roti',
		weight = 100,
		client = {
			status = { hunger = 100000 },
			anim = 'eating',
			--prop = 'burger',
			usetime = 3000,
		},
	},
	['ramen'] = {
		label = 'Ramen',
		weight = 100,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			--prop = 'burger',
			usetime = 3000,
		},
	},
	['sushi'] = {
		label = 'Sushi',
		weight = 100,
		client = {
			status = { hunger = 400000 },
			anim = 'eating',
			--prop = 'burger',
			usetime = 3000,
		},
	},
	['sate'] = {
		label = 'Sate Ayam',
		weight = 100,
		client = {
			status = { hunger = 400000 },
			anim = 'eating',
			prop = 'torpedo',
			usetime = 3000,
		},
	},
	['kebab'] = {
		label = 'Kebab',
		weight = 100,
		client = {
			status = { hunger = 400000 },
			anim = 'eating',
			prop = 'taco',
			usetime = 3000,
		},
	},
	['buburayam'] = {
		label = 'Bubur Ayam',
		weight = 100,
		client = {
			status = { hunger = 400000 },
			anim = 'eatingb',
			prop = 'pho',
			usetime = 3000,
		},
	},
	['soto'] = {
		label = 'Soto',
		weight = 100,
		client = {
			status = { hunger = 400000 },
			anim = 'eatingb',
			prop = 'beansoup',
			usetime = 3000,
		},
	},
	['nasiikan'] = {
		label = 'Nasi Ikan',
		weight = 100,
		client = {
			status = { hunger = 400000 },
			anim = 'eatingb',
			prop = 'beans',
			usetime = 3000,
		},
	},
	-- Minuman --
	['cola'] = {
		label = 'Coca-Cola',
		weight = 100,
		client = {
			status = { thirst = 200000 },
			anim = 'drinking',
			prop = 'ecola',
			usetime = 3000,
		}
	},
	['esbuah'] = {
		label = 'Es Buah',
		weight = 100,
		client = {
			status = { thirst = 400000 },
			anim = 'drinking',
			prop = 'boba',
			usetime = 3000,
		}
	},
	['kopi'] = {
		label = 'Kopi',
		weight = 100,
		client = {
			status = { thirst = 400000 },
			anim = 'drinking',
			prop = 'coffee',
			usetime = 3000,
		}
	},
	['jamu'] = {
		label = 'Jamu',
		weight = 100,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			--prop = { model = `prop_ecola_can`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 3000,
		}
	},
	['esjeruk'] = {
		label = 'Es Jeruk',
		weight = 100,
		client = {
			status = { thirst = 400000 },
			anim = 'drinking',
			prop = 'esjeruk',
			usetime = 3000,
		}
	},
	['eskopyor'] = {
		label = 'Es Kopyor',
		weight = 100,
		client = {
			status = { thirst = 400000 },
			anim = 'drinking',
			prop = 'boba2',
			usetime = 3000,
		}
	},
	['soju'] = {
		label = 'Soju',
		weight = 100,
		client = {
			status = { thirst = 400000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			--prop = { model = `prop_ecola_can`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 3000,
		}
	},
	['tawar'] = {
		label = 'Teh Tawar',
		weight = 100,
		client = {
			status = { thirst = 400000 },
			anim = 'drinking',
			prop = 'tawar',
			usetime = 3000,
		}
	},
	['susu'] = {
		label = 'Susu',
		weight = 100,
		client = {
			status = { drunk = -100000 },
			anim = 'drinking',
			prop = 'ecola',
			usetime = 3000,
		}
	},
	['parachute'] = {
		label = 'Parachute',
		weight = 8000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 3000
		}
	},
	['kompas'] = {
        label = 'Kompas',
        weight = 50,
        stack = true,
        close = true,
        client = {
            event = "dl-bensin:compass"
        }
    },

	['garbage'] = {
		label = 'Garbage',
	},

	['paperbag'] = {
		label = 'Kantong Ajaib',
		weight = 1,
		stack = false,
		close = false,
		consume = 0,
		description = 'Membawa item ini selain Admin = Banned Permanen!!'
	},

	['medikit'] = {
		label = 'Medkit',
		weight = 1,
		stack = true,
		close = false,
	},

	['drivers_license'] = {
        label = 'SIM',
        weight = 50,
        stack = false,
        close = true,
		consume = 0,
        client = {
            export = "alan.identification"
        }
    },
    ['firearms_license'] = {
        label = 'Lisensi Senjata',
        weight = 50,
        stack = false,
        close = true,
		consume = 0,
        client = {
            export = "alan.identification"
        }
    },
	['kartu_pasien'] = {
        label = 'Kartu Pasien',
        weight = 50,
        stack = false,
        close = true,
		consume = 0,
        client = {
            export = "alan.identification",
			anim = 'showida',
			prop = 'idcard',
			usetime = 3000,
        }
    },
	['kartu_bpjs'] = {
        label = 'Kartu Bpjs',
        weight = 50,
        stack = false,
        close = true,
		consume = 0,
        client = {
            export = "alan.identification",
			anim = 'showida',
			prop = 'idcard',
			usetime = 3000,
        }
    },
    ['identification'] = {
        label = 'Ktp',
        weight = 50,
        stack = false,
        close = true,
		consume = 0,
        client = {
            export = "alan.identification"
        }
    },

	['panties'] = {
		label = 'Knickers',
		weight = 10,
		client = {
			status = { thirst = -100000, stress = -25000 },
			usetime = 2500,
		}
	},

	['lockpick'] = {
		label = 'Lockpick',
		weight = 160,
		consume = 1,
		client = {
			anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' },
			disable = { move = true, car = true, combat = true },
			usetime = 10000,
			cancel = true
		}
	},

	['phone'] = {
		label = 'Phone',
		weight = 190,
		stack = true,
	},

	['bread'] = {
		label = 'Bread',
		weight = 100,
		stack = false,
	},

	['nitro'] = {
		label = 'Nitro',
		weight = 190,
		stack = false,
	},

	['radio'] = {
		label = 'Radio',
		weight = 190,
		stack = true,
	},

	['money'] = {
		label = 'Uang',
	},

	['mustard'] = {
		label = 'Mustard',
		weight = 500,
		client = {
			status = { hunger = 25000, thirst = 25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
		}
	},

	--[[['water'] = {
		label = 'Air',
		weight = 500,
		client = {
			status = { thirst = 100000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 3000,
			cancel = true,
		}
	},]]
	['water'] = {
		label = 'Air',
		weight = 25,
		stack = true,
		close = true,
		description = 'Air Mentah'
	},
	['hack_usb'] = {
		label = 'hack_usb',
		weight = 10,
		stack = true,
		close = true,
		description = ''
	},

	['moneywash_card'] = {
		label = 'Biker Card',
		weight = 100,
		stack = true,
		close = true,
		description = ''
	},

	['proses_card'] = {
		label = 'Cartel Card',
		weight = 100,
		stack = true,
		close = true,
		description = ''
	},

	['gang_card'] = {
		label = 'Gang Card',
		weight = 100,
		stack = true,
		close = true,
		description = ''
	},

	['mafia_card'] = {
		label = 'Mafia Card',
		weight = 100,
		stack = true,
		close = true,
		description = ''
	},

	['armor'] = {
		label = 'Armor',
		weight = 800,
		stack = true,
		close = true,
		description = 'Armor',
	},

	['copper'] = {
		label = 'Tembaga',
		weight = 120,
		stack = true,
		close = true,
		description = '',
	},

	-- Mech Item

	['toolkit'] = {
        label = 'Toolkit',
        weight = 1000,
        stack = true,
        close = true,
    },

	['ore_coal'] = {
		label = 'Coal Ore',
		weight = 5,
		stack = true,
		close = true,
		description = ''
	},

	['ore_iron'] = {
		label = 'Iron Ore',
		weight = 10,
		stack = true,
		close = true,
		description = ''
	},

	['ore_gold'] = {
		label = 'Gold Ore',
		weight = 25,
		stack = true,
		close = true,
		description = ''
	},

	['ore_diamond'] = {
		label = 'Diamond Ore',
		weight = 50,
		stack = true,
		close = true,
		description = ''
	},

	['diamond'] = {
		label = 'Diamond',
		weight = 50,
		stack = true,
		close = true,
		description = ''
	},

	['gold'] = {
		label = 'Gold',
		weight = 260,
		stack = true,
		close = true,
		description = ''
	},

	['iron'] = {
		label = 'Iron',
		weight = 105,
		stack = true,
		close = true,
		description = ''
	},

	['coal'] = {
		label = 'Coal',
		weight = 50,
		stack = true,
		close = true,
		description = ''
	},

	['wool'] = {
		label = 'Benang',
		weight = 400,
		stack = true,
		close = true,
		description = ''
	},

	['fabric'] = {
		label = 'Kain',
		weight = 500,
		stack = true,
		close = true,
		description = ''
	},

	['clothe'] = {
		label = 'Baju',
		weight = 1200,
		stack = true,
		close = true,
		description = ''
	},

	['wood'] = {
		label = 'Kayu',
		weight = 480,
		stack = true,
		close = true,
		description = ''
	},

	['packedwood'] = {
		label = 'Paketan Kayu',
		weight = 180,
		stack = true,
		close = true,
		description = ''
	},

	['fish'] = {
		label = 'Ikan',
		weight = 50,
		stack = true,
		close = true,
		description = ''
	},

	['alive_chicken'] = {
		label = 'Ayam',
		weight = 450,
		stack = true,
		close = true,
		description = ''
	},

	['slaughtered_chicken'] = {
		label = 'Ayam Potong',
		weight = 200,
		stack = true,
		close = true,
		description = ''
	},

	['packaged_chicken'] = {
		label = 'Kemasan Ayam',
		weight = 120,
		stack = true,
		close = true,
		description = ''
	},

	['jewel'] = {
		label = 'Jewel',
		weight = 10,
		stack = true,
		close = true,
		description = ''
	},

	['thermite'] = {
		label = 'thermite',
		weight = 10,
		stack = true,
		close = true,
		description = ''
	},

	['lockpick'] = {
		label = 'Lockpick',
		weight = 100,
		stack = true,
		close = true,
		description = ''
	},

	['zipties'] = {
		label = 'zipties',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},

	['meat'] = {
		label = 'Daging',
		weight = 120,
		stack = true,
		close = true,
		description = ''
	},

	['leather'] = {
		label = 'Kulit',
		weight = 700,
		stack = true,
		close = true,
		description = ''
	},

	['plastic'] = {
		label = 'Plastik',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},

	['wheelchair'] = {
		label = 'wheelchair',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},

	['petrol'] = {
		label = 'Minyak',
		weight = 400,
		stack = true,
		close = true,
		description = ''
	},

	['petrol_raffin'] = {
		label = 'Petrol Raffin',
		weight = 500,
		stack = true,
		close = true,
		description = ''
	},

	['essence'] = {
		label = 'Gas',
		weight = 450,
		stack = true,
		close = true,
		description = ''
	},

	['kit_senjata'] = {
		label = 'Weapon Kit',
		weight = 500,
		stack = true,
		close = true,
		description = ''
	},

	['weed'] = {
		label = 'Kecubung',
		weight = 100,
		stack = true,
		close = true,
		description = ''
	},

	['coke'] = {
		label = 'coke',
		weight = 100,
		stack = true,
		close = true,
		description = ''
	},

	['coke_pooch'] = {
		label = 'Olahan Coke',
		weight = 150,
		stack = true,
		close = true,
		description = ''
	},

	['weed_pooch'] = {
		label = 'Olahan Kecubung',
		weight = 150,
		stack = true,
		close = true,
		description = ''
	},

	['blowtorch'] = {
		label = 'blowtorch',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},

	['bijigandum'] = {
		label = 'biji gandum',
		weight = 10,
		stack = true,
		close = true,
		description = ''
	},

	['bijikelapa'] = {
		label = 'biji kelapa',
		weight = 10,
		stack = true,
		close = true,
		description = ''
	},

	['cutted_wood'] = {
		label = 'potongan kayu',
		weight = 400,
		stack = true,
		close = true,
		description = ''
	},

	['gandum'] = {
		label = 'gandum',
		weight = 10,
		stack = true,
		close = true,
		description = ''
	},

	['id_card_f'] = {
		label = 'malicious access card',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},

	['kelapa'] = {
		label = 'buah kelapa',
		weight = 10,
		stack = true,
		close = true,
		description = ''
	},

	['packaged_plank'] = {
		label = 'paket kayu',
		weight = 120,
		stack = true,
		close = true,
		description = ''
	},

	['secure_card'] = {
		label = 'secure id card',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},

	['stone'] = {
		label = 'batu',
		weight = 1250,
		stack = true,
		close = true,
		description = ''
	},

	['washed_stone'] = {
		label = 'batu cuci',
		weight = 1000,
		stack = true,
		close = true,
		description = ''
	},

	['rompik'] = {
		label = 'Rompi Kulit',
		weight = 800,
		stack = true,
		close = true,
		description = '',
	},
	['bibit_cabe'] = {
		label = 'bibit cabe',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},

	['bibit_daunbawang'] = {
		label = 'bibit daun bawang',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},

	['bibit_jeruk'] = {
		label = 'bibit jeruk',
		weight = 1,
		stack = true,
		close = true,
		description = '100'
	},

	['bibit_kentang'] = {
		label = 'bibit kentang',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},

	['bibit_tebu'] = {
		label = 'bibit tebu',
		weight = 1,
		stack = true,
		close = true,
		description = '100'
	},

	['bibit_teh'] = {
		label = 'bibit teh',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},
	['bibit_tomat'] = {
		label = 'bibit tomat',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},
	['jeruk'] = {
		label = 'jeruk',
		weight = 50,
		stack = true,
		close = true,
		description = ''
	},

	['cabe'] = {
		label = 'cabe',
		weight = 120,
		stack = true,
		close = true,
		description = ''
	},
	['tomat'] = {
		label = 'tomat',
		weight = 120,
		stack = true,
		close = true,
		description = ''
	},
	['kentang'] = {
		label = 'kentang',
		weight = 120,
		stack = true,
		close = true,
		description = ''
	},
	['daun_bawang'] = {
		label = 'daun bawang',
		weight = 120,
		stack = true,
		close = true,
		description = ''
	},
	['tebu'] = {
		label = 'tebu',
		weight = 120,
		stack = true,
		close = true,
		description = ''
	},
	['teh'] = {
		label = 'teh',
		weight = 50,
		stack = true,
		close = true,
		description = ''
	},
	['boombox'] = {
		label = 'Boombox',
		weight = 1000,
		stack = false,
		close = true,
		description = ''
	},
	-- Bahan Pedagang --
	['beras'] = {
		label = 'Beras',
		weight = 50,
		stack = true,
		close = true,
		description = ''
	},
	['daging_sapi'] = {
		label = 'Daging Sapi',
		weight = 120,
		stack = true,
		close = true,
		description = ''
	},
	['kulit'] = {
		label = 'Kulit',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},
	['sambal'] = {
		label = 'Sambal',
		weight = 50,
		stack = true,
		close = true,
		description = ''
	},
	['tepung'] = {
		label = 'Tepung Terigu',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},
	['minyak'] = {
		label = 'Minyak Goreng',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},
	['kopi_bubuk'] = {
		label = 'Biji Kopi',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},
	['susu_murni'] = {
		label = 'Susu Murni',
		weight = 60,
		stack = true,
		close = true,
		description = ''
	},
	['gula'] = {
		label = 'Gula Pasir',
		weight = 50,
		stack = true,
		close = true,
		description = ''
	},
	['mie'] = {
		label = 'Mie Mentah',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},
	['daunteh'] = {
		label = 'Daun Teh',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},
	['sayuran'] = {
		label = 'Sayuran',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},
	['bottle'] = {
		label = 'Botol',
		weight = 25,
		stack = true,
		close = true,
		description = ''
	},
	['lemak'] = {
		label = 'Lemak',
		weight = 50,
		stack = true,
		close = true,
		description = ''
	},
	['bubuk_kopi'] = {
		label = 'Bubuk kopi',
		weight = 50,
		stack = true,
		close = true,
		description = ''
	},
	-- Lainnya --
	['contract'] = {
		label = 'Kontrak Kendaraan',
		weight = 1,
		stack = true,
		close = true,
		description = 'Jual Kendaraan',
	},
	['usb_hack'] = {
		label = 'Usb Hack',
		weight = 1,
		stack = true,
		close = true,
		description = '',
	},
	['tiketoplas'] = {
		label = 'Tiket Oplas',
		weight = 1,
		stack = true,
		close = true,
		description = ''
	},
	['bgaram'] = {
		label = 'Garam',
		weight = 50,
		stack = true,
		close = true,
		description = ''
	},
	['laptop_h'] = {
		label = 'laptop',
		weight = 1000,
		stack = true,
		close = true,
		description = ''
	},
	['tabungoksigen'] = {
		label = 'Tabung Oksigen',
		weight = 8000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 3000,
			event = 'dl-data:tabungo2',
		}
	},
	['megaphone'] = {
		label = 'Megaphone',
		weight = 10,
		stack = true,
		close = true,
	},

	['licenseplate'] = {
		label = 'Ganti Plat',
		weight = 10,
		stack = true,
		close = true,
	},


	['blowpipe'] = {
		label = 'blowtorch',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['carokit'] = {
		label = 'body kit',
		weight = 3,
		stack = true,
		close = true,
		description = nil
	},

	['carotool'] = {
		label = 'tools',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['fixtool'] = {
		label = 'repair tools',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['gazbottle'] = {
		label = 'gas bottle',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['kanebo'] = {
		label = 'Kanebo',
		weight = 100,
		stack = true,
		close = true,
		description = 'Kanebo Digunakan Untuk Membersihkan Kendaraan'
	},
	['alprazolam'] = {
		label = 'Alprazolam',
		weight = 100,
		client = {
			status = { stress = -300000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			usetime = 3000,
		}
	},
	['sertraline'] = {
		label = 'Sertraline',
		weight = 100,
		client = {
			status = { drunk = -200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			usetime = 3000,
		}
	},
	['documents'] = {
		label = 'Dokumen',
		weight = 50,
		stack = false,
		degrade = 43200,
		close = true,
		client = {
			usetime = 0,
			event = 'mydocuments:show'
		}
	},
	['repairkit_senjata'] = {
		label = 'Repairkit Senjata',
		weight = 1000,
		stack = true,
		close = true,
		description = nil
	},
	['toolkit_senjata'] = {
		label = 'Toolkit Senjata',
		weight = 1500,
		stack = true,
		close = true,
		description = nil
	},
	['itemck'] = {
		label = 'Character Kill',
		weight = 100,
		stack = false,
		close = true,
		description = 'Digunakan jika kalian mau rp ck'
	},
	['bank_card'] = {
		label = 'Bank Card',
		weight = 100,
		stack = true,
		close = true,
		description = nil
	},
	['jewel_card'] = {
		label = 'Jewel Card',
		weight = 100,
		stack = true,
		close = true,
		description = nil
	},
	-- Eggi Rusuh Bikin Item Terus --
	['petfood'] = {
		label = 'Pet Food',
		weight = 50,
		client = {
			status = { hunger = 75000, thirst = 75000 },
			notification = 'Ini makanan hewan loh..',
			usetime = 5000,
		}
	},
	['kotoran_hewan'] = {
		label = 'Kotoran Hewan',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},
	['tiketmasuk'] = {
		label = 'Contestants Pass - JDM 2022',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},
	['tiket_masuk'] = {
		label = 'Entry Pass - JDM 2022',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},
	['sjdm'] = {
		label = 'Keychain - JDM 2022',
		weight = 100,
		stack = true,
		close = true,
		description = nil
	},
	['koyo'] = {
		label = 'Obat Kuat',
		weight = 0.0001,
		stack = true,
		close = true,
		description = 'Obat Kuat Admin',
		consume = 0.01,
		client = {
			status = { hunger = 1000000, thirst = 1000000, drunk = -1000000, stress = -1000000 },
			notification = 'Sekuat Macan!!',
			anim = 'drinking',
			prop = 'vodka',
			usetime = 3000,
		}
	},
	['v_perban'] = {
		label = 'Voucher Perban',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},
	['v_admin'] = {
		label = 'Voucher Admin',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},
	-- ITEM COUPLE --
	['bunga'] = {
		label = 'Flower Bouquet',
		weight = 100,
		stack = false,
		close = true,
		description = nil
	},
	['cincin'] = {
		label = 'Wedding Ring',
		weight = 20,
		stack = false,
		close = true,
		consume = 0.00,
		client = {
			anim = 'propose',
			prop = 'wedring',
			disable = { move = true, car = true, combat = true },
			usetime = 10000,
		},
		description = nil
	},
	['bonekakucing'] = {
		label = 'Boneka Kucing',
		weight = 100,
		stack = false,
		close = true,
		description = nil
	},
	['bonekamonyet'] = {
		label = 'Boneka Monyet',
		weight = 100,
		stack = false,
		close = true,
		description = nil
	},
	['wedding_doll_1'] = {
		label = 'Morris & Sora',
		weight = 100,
		stack = false,
		close = true,
		description = 'Ever thine, ever mine, ever ours - 29 December 2022'
	},
}