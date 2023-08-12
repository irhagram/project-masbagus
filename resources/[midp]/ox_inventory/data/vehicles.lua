return {
	-- 0	vehicle has no storage
	-- 1	vehicle has no trunk storage
	-- 2	vehicle has no glovebox storage
	-- 3	vehicle has trunk in the hood
	Storage = {
		[`jester`] = 3,
		[`adder`] = 3,
		[`osiris`] = 1,
		[`pfister811`] = 1,
		[`penetrator`] = 1,
		[`autarch`] = 1,
		[`bullet`] = 1,
		[`cheetah`] = 1,
		[`cyclone`] = 1,
		[`voltic`] = 1,
		[`reaper`] = 3,
		[`entityxf`] = 1,
		[`t20`] = 1,
		[`taipan`] = 1,
		[`tezeract`] = 1,
		[`torero`] = 3,
		[`turismor`] = 1,
		[`fmj`] = 1,
		[`infernus`] = 1,
		[`italigtb`] = 3,
		[`italigtb2`] = 3,
		[`nero2`] = 1,
		[`vacca`] = 3,
		[`vagner`] = 1,
		[`visione`] = 1,
		[`prototipo`] = 1,
		[`zentorno`] = 1,
		[`trophytruck`] = 0,
		[`trophytruck2`] = 0,
        [`hino`] = 3,
        [`canter`] = 3,
	},

	-- slots, maxWeight; default weight is 8000 per slot
	glovebox = {
		[0] = {11, 88000},		-- Compact
		[1] = {11, 88000},		-- Sedan
		[2] = {11, 88000},		-- SUV
		[3] = {11, 88000},		-- Coupe
		[4] = {11, 88000},		-- Muscle
		[5] = {11, 88000},		-- Sports Classic
		[6] = {11, 88000},		-- Sports
		[7] = {11, 88000},		-- Super
		[8] = {5, 40000},		-- Motorcycle
		[9] = {11, 88000},		-- Offroad
		[10] = {11, 88000},		-- Industrial
		[11] = {11, 88000},		-- Utility
		[12] = {11, 88000},		-- Van
		[14] = {31, 88000}, 	-- Boat
		[15] = {31, 248000},	-- Helicopter
		[16] = {51, 408000},	-- Plane
		[17] = {11, 88000},		-- Service
		[18] = {11, 88000},		-- Emergency
		[19] = {11, 88000},		-- Military
		[20] = {11, 88000},		-- Commercial (trucks)
		models = {
			[`xa21`] = {11, 88000}
		}
	},

	trunk = {
		[0] = {15, 30000},		-- Compact
		[1] = {20, 40000},		-- Sedan
		[2] = {25, 70000},		-- SUV
		[3] = {25, 25000},		-- Coupe
		[4] = {20, 30000},		-- Muscle
		[5] = {10, 10000},		-- Sports Classic
		[6] = {7, 5000},		-- Sports
		[7] = {7, 5000},		-- Super
		[8] = {5, 5000},		-- Motorcycle
		[9] = {20, 180000},		-- Offroad
		[10] = {30, 300000},	-- Industrial
		[11] = {25, 70000},	-- Utility
		[12] = {30, 100000},	-- Van
		-- [14] -- Boat
		-- [15] -- Helicopter
		-- [16] -- Plane
		[17] = {20, 40000},	-- Service
		[18] = {20, 40000},	-- Emergency
		[19] = {20, 500000},	-- Military
		[20] = {15, 300000},	-- Commercial
		models = {
			[`brickade`] = {100, 500000},
			[`hino`] = {15, 150000},
			[`canter`] = {15, 150000},
			[`raptor2017`] = {40, 400000},
			[`tonkat`] = {30, 300000},
			[`evo9mr`] = {15, 100000},
		},
		boneIndex = {
			[`pounder`] = 'wheel_rr',
			[`hino`] = 'wheel_rr',
			[`brickade`] = 'wheel_rr',
			[`canter`] = 'wheel_rr',
		}
	}
}