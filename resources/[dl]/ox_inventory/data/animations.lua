return {
	anim = {
		['eating'] = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger_fp' },
		['eatinga'] = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
		['eatingb'] = { dict = 'anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1', clip = 'base_idle' },
		['drinking'] = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
		['drinkinga'] = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
		['showida'] = { dict = 'paper_1_rcm_alt1-8', clip = 'player_one_dual-8' },
		['propose'] = { dict = 'ultra@propose', clip = 'propose' }
	},
	prop = {
--makanan
		['burger'] = { model = `prop_cs_burger_01`, pos = vec3(0.02, 0.02, -0.02), rot = vec3(0.0, 0.0, 0.0) },
		['taco'] = { model = `prop_taco_01`, bone = 60309, pos = vec3(-0.017000, 0.007000, -0.021000), rot = vec3(-80.0, -105.025101, 55.777901) },
		['torpedo'] = { model = `prop_food_bs_burger2`, bone = 18905, pos = vec3(0.100000, -0.070000, 0.091000), rot = vec3(15.000000, 135.000000, 0.000000) },
		['pho'] = 	{
						{ model = `scully_pho`, bone = 60309, pos = vec3(0.000000, 0.030000, 0.010000), rot = vec3(0.000000, 0.000000, 0.000000) },
						{ model = `scully_spoon_pho`, bone = 28422, pos = vec3(0.000000, 0.000000, 0.000000), rot = vec3(0.000000, 0.000000, 0.000000) }
					},
		['beansoup'] = 	
					{
						{ model = `prop_cs_bowl_01`, bone = 60309, pos = vec3(0.000000, 0.030000, 0.010000), rot = vec3(0.000000, 0.000000, 0.000000) },
						{ model = `h4_prop_h4_caviar_spoon_01a`, bone = 28422, pos = vec3(0.000000, 0.000000, 0.000000), rot = vec3(0.000000, 0.000000, 0.000000) }
					},
		['beans'] = 	
					{
						{ model = `h4_prop_h4_caviar_tin_01a`, bone = 60309, pos = vec3(0.000000, 0.030000, 0.010000), rot = vec3(0.000000, 0.000000, 0.000000) },
						{ model = `h4_prop_h4_caviar_spoon_01a`, bone = 28422, pos = vec3(0.000000, 0.000000, 0.000000), rot = vec3(0.000000, 0.000000, 0.000000) }
					},
--minuman		
		['vodka'] = { model = `prop_vodka_bottle`, bone = 18905, pos = vec3(0.000000, -0.260000, 0.100000), rot = vec3(240.000000, -60.000000, 0.000000) },
		['ecola'] = { model = `prop_ecola_can`, bone = 18905, pos = vec3(0.120000, 0.008000, 0.030000), rot = vec3(240.000000, -60.000000, 0.000000) },
		['boba'] = { model = `scully_boba`, bone = 18905, pos = vec3(0.070000, -0.10000, 0.06000), rot = vec3(240.000000, -60.000000, 0.000000) },
		['boba2'] = { model = `scully_boba2`, bone = 18905, pos = vec3(0.070000, -0.10000, 0.06000), rot = vec3(240.000000, -60.000000, 0.000000) },
		['boba3'] = { model = `scully_boba3`, bone = 18905, pos = vec3(0.070000, -0.10000, 0.06000), rot = vec3(240.000000, -60.000000, 0.000000) },
		['coffee'] = { model = `p_amb_coffeecup_01`, bone = 18905, pos = vec3(0.120000, 0.008000, 0.030000), rot = vec3(240.000000, -60.000000, 0.000000) },
		['esjeruk'] = { model = `prop_beer_amopen`, bone = 18905, pos = vec3(0.030000, -0.180000, 0.100000), rot = vec3(240.000000, -60.000000, 0.000000) },	
		['tawar'] = { model = `bzzz_food_xmas_mulled_wine_a`, bone = 18905, pos = vec3(0.13, 0.03, 0.05), rot = vec3(-110.0, -47.0, 7.0) },
--lainnya
		['idcard'] = { model = `prop_cs_r_business_card`, bone = 28422, pos = vec3(0.100000, 0.020000, -0.030000), rot = vec3(-90.000000, 170.000000, 78.999001) },
		['wedring'] = { model = `ultra_ringcase`, bone = 57005, pos = vec3(0.17, 0.04, -0.055506), rot = vec3(-138.082, 7.06138, -59.7062) },
	}
}