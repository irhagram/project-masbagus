Config = {}
Config.Locale = 'en'

Config.DoorList = {
	
	--
	-- Mission Row First Floor
	--

	{
		textCoords = vector3(434.7, -982.0, 31.5),
		authorizedJobs = {'police', 'offpolice'},
		locked = false,
		distance = 2.5,
		doors = {
			{objName = 'gabz_mrpd_reception_entrancedoor', objYaw = 270.0, objCoords = vector3(434.7, -980.6, 30.8)},
			{objName = 'gabz_mrpd_reception_entrancedoor', objYaw = 90.0, objCoords = vector3(434.7, -983.2, 30.8)}
		}
	},
	--sivuovi
	
		{
		textCoords = vector3(457.00, -972.28, 30.7),
		authorizedJobs = {'police', 'offpolice'},
		locked = true,
		distance = 2.5,
		doors = {
			{objName = 'gabz_mrpd_reception_entrancedoor', objYaw = 180.0, objCoords = vector3(457.4, -972.36, 30.72)},
			{objName = 'gabz_mrpd_reception_entrancedoor', objYaw = 360.0, objCoords = vector3(455.2087, -972.2543, 30.81)}
		}
	},
	--sivuovi 2
			{
		textCoords = vector3(441.8, -998.73, 30.7),
		authorizedJobs = {'police', 'offpolice'},
		locked = true,
		distance = 2.5,
		doors = {
			{objName = 'gabz_mrpd_reception_entrancedoor', objYaw = 360.0, objCoords = vector3(440.7392, -998.7462, 30.8)},
			{objName = 'gabz_mrpd_reception_entrancedoor', objYaw = 180.0, objCoords = vector3(443.0618,-998.7462,30.8153)}
		}
	},
	--tuplaovi
	{
		textCoords = vector3(469.43, -986.26, 30.7),
		authorizedJobs = {'police', 'offpolice'},
		locked = true,
		distance = 2.5,
		doors = {
			{objName = 'gabz_mrpd_door_01', objYaw = 270.0, objCoords = vector3(469.4406, -985.0313, 30.82319)},
			{objName = 'gabz_mrpd_door_01', objYaw = 90.0, objCoords = vector3(469.4406,-987.4377,30.82319)}
		}
	},
--takaovi
	{
		textCoords = vector3(468.37, -1014.21, 26.42),
		authorizedJobs = {'police', 'offpolice'},
		locked = true,
		distance = 2.5,
		doors = {
			{objName = 'gabz_mrpd_door_03', objYaw = 180.0, objCoords = vector3(469.7743, -1014.406, 26)},
			{objName = 'gabz_mrpd_door_03', objYaw = 360.0, objCoords = vector3(467.3686,-1014.406,26.48697)}
		}
	},

	-- Cell 1
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -90.0,
		objCoords  = vector3(462.3, -993.6, 24.9),
		textCoords = vector3(461.8, -993.3, 25.0),
		authorizedJobs = { 'police', 'tni' },
		locked = true
	},

	-- Cell 2
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.3, -998.1, 24.9),
		textCoords = vector3(461.8, -998.8, 25.0),
		authorizedJobs = { 'police', 'tni' },
		locked = true
	},

	-- Cell 3
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.7, -1001.9, 24.9),
		textCoords = vector3(461.8, -1002.4, 25.0),
		authorizedJobs = { 'police', 'tni' },
		locked = true
	},

--CELL KANPOL
	{
		objName = 'gabz_mrpd_cells_door',
		objYaw = -90.0,
		objCoords  = vector3(476.24923706055,-1008.2137451172,26.273416519165),
		textCoords = vector3(476.1452331543,-1008.3913574219,26.273416519165),
		authorizedJobs = { 'police', 'tni' },
		locked = true
	},

	{
		objName = 'gabz_mrpd_cells_door',
		objYaw = 1.0,
		objCoords  = vector3(477.00936889648,-1011.9694213867,26.27854347229),
		textCoords = vector3(477.07138061523,-1011.7503662109,26.273202896118),
		authorizedJobs = { 'police', 'tni' },
		locked = true
	},

	{
		objName = 'gabz_mrpd_cells_door',
		objYaw = 1.0,
		objCoords  = vector3(480.06185913086,-1012.1249389648,26.32303237915),
		textCoords = vector3(480.06185913086,-1012.1249389648,26.32303237915),
		authorizedJobs = { 'police', 'tni' },
		locked = true
	},

	{
		objName = 'gabz_mrpd_cells_door',
		objYaw = 1.0,
		objCoords  = vector3(483.07971191406,-1012.0784912109,26.322881698608),
		textCoords = vector3(483.07971191406,-1012.0784912109,26.322881698608),
		authorizedJobs = { 'police', 'tni' },
		locked = true
	},

	{
		objName = 'gabz_mrpd_cells_door',
		objYaw = 1.0,
		objCoords  = vector3(485.94973754883,-1011.9716796875,26.275451660156),
		textCoords = vector3(485.94973754883,-1011.9716796875,26.275451660156),
		authorizedJobs = { 'police', 'tni' },
		locked = true
	},

	{
		objName = 'gabz_mrpd_cells_door',
		objYaw = 180.0,
		objCoords  = vector3(485.05068969727,-1007.8005371094,26.323020935059),
		textCoords = vector3(485.05068969727,-1007.8005371094,26.323020935059),
		authorizedJobs = { 'police', 'tni' },
		locked = true
	},

	{
		objName = 'gabz_mrpd_cells_door',
		objYaw = 180.0,
		objCoords  = vector3(481.87789916992,-1004.1567993164,26.323040008545),
		textCoords = vector3(481.87789916992,-1004.1567993164,26.323040008545),
		authorizedJobs = { 'police', 'tni' },
		locked = true
	},

	--PINTU DEPAN POLSI
	{
		objName = 'gabz_mrpd_door_04',
		objYaw = 1.0,
		objCoords  = vector3(441.42288208008,-977.65997314453,30.790338516235),
		textCoords = vector3(441.42288208008,-977.65997314453,30.790338516235),
		authorizedJobs = { 'police', 'tni' },
		locked = true
	},

	{
		objName = 'gabz_mrpd_door_05',
		objYaw = 180.0,
		objCoords  = vector3(441.294921875,-986.09802246094,30.790351867676),
		textCoords = vector3(441.294921875,-986.09802246094,30.790351867676),
		authorizedJobs = { 'police', 'tni' },
		locked = true
	},

	-- Back (double doors)
	{
		textCoords = vector3(468.6, -1014.4, 27.1),
		authorizedJobs = { 'police', 'tni' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'gabz_mrpd_door_03',
				objYaw = 0.0,
				objCoords  = vector3(467.3, -1014.4, 26.5)
			},

			{
				objName = 'gabz_mrpd_door_03',
				objYaw = 180.0,
				objCoords  = vector3(469.9, -1014.4, 26.5)
			}
		}
	},

	-- Back Gate
	{
		objName = 'hei_prop_station_gate',
		objYaw = 90.0,
		objCoords  = vector3(488.8, -1017.2, 27.1),
		textCoords = vector3(488.8, -1020.2, 30.0),
		authorizedJobs = { 'police', 'tni' },
		locked = true,
		distance = 14,
		size = 2
	},

	--
	-- Sandy Shores
	--

	-- Entrance
	{
		objName = 'v_ilev_shrfdoor',
		objYaw = 30.0,
		objCoords  = vector3(1855.1, 3683.5, 34.2),
		textCoords = vector3(1855.1, 3683.5, 35.0),
		authorizedJobs = { 'police', 'satpol', 'tni' },
		locked = false
	},

	--
	-- Paleto Bay
	--

	-- Entrance (double doors)
	{
		textCoords = vector3(-443.5, 6016.3, 32.0),
		authorizedJobs = { 'police', 'satpol', 'tni' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_shrf2door',
				objYaw = -45.0,
				objCoords  = vector3(-443.1, 6015.6, 31.7),
			},

			{
				objName = 'v_ilev_shrf2door',
				objYaw = 135.0,
				objCoords  = vector3(-443.9, 6016.6, 31.7)
			}
		}
	},

	-- Fort_Zancudo_Gates | Route 68 Entrance
	{
		objName = 'prop_gate_airport_01',
		objYaw = -139.9,
		objCoords  = vector3(-1600.2, 2793.7, 15.7),
		textCoords = vector3(-1597.4, 2796.3, 19.7),
		authorizedJobs = { 'tni' },
		locked = true,
		distance = 14,
		size = 2
	},
	{
		objName = 'prop_gate_airport_01',
		objYaw = 44.4,
		objCoords  = vector3(-1587.2, 2805.0, 15.8),
		textCoords = vector3(-1590.0, 2802.1, 19.8),
		authorizedJobs = { 'tni' },
		locked = true,
		distance = 14,
		size = 2
	},

		--federal

		{
			objName = 'v_ilev_ph_cellgate',
			objCoords  = vector3(1700.9130859375,2568.6284179688,45.588733673096),
			textCoords = vector3(1700.9130859375,2568.6284179688,45.588733673096),
			authorizedJobs = { 'ambulance', 'police', 'satpol', 'tni' },
			locked = true,
			distance = 2.5,
			size = 2
		},
		
		{
			objName = 'v_ilev_ph_cellgate',
			objCoords  = vector3(1680.6400146484,2568.6066894531,45.588722229004),
			textCoords = vector3(1680.6400146484,2568.6066894531,45.588722229004),
			authorizedJobs = { 'ambulance', 'police', 'satpol', 'tni' },
			locked = true,
			distance = 2.5,
			size = 2
		},
		
	-- Fort_Zancudo_Gates | Great Ocean Hwy Entrance
	{
		objName = 'prop_gate_airport_01',
		objYaw = 54.9,
		objCoords  = vector3(-2296.1, 3393.1, 30.0),
		textCoords = vector3(-2298.3, 3389.9, 34.0),
		authorizedJobs = { 'tni' },
		locked = true,
		distance = 14,
		size = 2
	},
	{
		objName = 'prop_gate_airport_01',
		objYaw = -126.9,
		objCoords  = vector3(-2306.1, 3379.3, 30.2),
		textCoords = vector3(-2303.6, 3382.3, 34.2),
		authorizedJobs = { 'tni' },
		locked = true,
		distance = 14,
		size = 2
	},

	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = vector3(1677.14, 2569.52, 45.73),
		textCoords = vector3(1677.26, 2568.35, 45.59),
		authorizedJobs = { 'ambulance', 'police', 'satpol', 'tni' },
		locked = true,
		distance = 2.5,
		size = 2
	},

	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = vector3(1704.31, 2569.53, 45.74),
		textCoords = vector3(1704.14, 2568.47, 45.59),
		authorizedJobs = { 'ambulance', 'police', 'satpol', 'tni' },
		locked = true,
		distance = 2.5,
		size = 2
	},

	{
		objName = 'prop_facgate_07b',
		objCoords  = vector3(-3138.10, 799.9, 19.26),
		textCoords = vector3(-3135.16, 795.6, 17.34),
		authorizedJobs = { 'tni' },
		locked = true,
		distance = 2.5,
		size = 2
	},
}