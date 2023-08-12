CarSteal              = {}
CarSteal.DrawDistance = 100.0
CarSteal.CopsRequired = 3
CarSteal.BlipUpdateTime = 3000 --In milliseconds. I used it on 3000. If you want instant update, 50 is more than enough. Even 100 is good. I hope it doesn't kill FPS and the server.
CarSteal.CooldownMinutes = 45
CarSteal.MenuKey 			= 168 -- "L" button, change to whatever you want
CarSteal.UseCustomFonts 	= false -- Leave this as is if you don't know how to or haven't loaded custom fonts.
CarSteal.CustomFontFile 	= "greek" -- change only if you turn custom fonts on.
CarSteal.CustomFontId 	= "OpenSans" -- change only if you turn custom fonts ok.
CarSteal.Documents = {}

CarSteal.Zones1 = {
	VehicleSpawner = {
		Pos   = {x = 764.63360595703, y = -3208.3444824219, z = 6.0337481498718},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Colour    = 6, --BLIP
		Id        = 229, --BLIP
	},
}

CarSteal.Zones2 = {
	VehicleSpawner = {
		Pos   = {x = -750.66, y = -2226.43, z = 6.10},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Colour    = 6, --BLIP
		Id        = 229, --BLIP
	},
}

CarSteal.Zones3 = {
	VehicleSpawner = {
		Pos   = {x = 347.72, y = -2647.73, z = 6.30},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Colour    = 6, --BLIP
		Id        = 229, --BLIP
	},
}

CarSteal.Zones4 = {
	VehicleSpawner = {
		Pos   = {x = -477.71, y = -2773.99, z = 6.30},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Colour    = 6, --BLIP
		Id        = 229, --BLIP
	},
}


CarSteal.VehicleSpawnPoint1 = {
    Pos   = {x = 767.71, y = -3195.20, z = 5.50},
    Size  = {x = 3.0, y = 3.0, z = 1.0},
	Type  = -1,
}

CarSteal.VehicleSpawnPoint2 = {
	Pos   = {x = -751.85, y = -2215.51, z = 6.0},
	Size  = {x = 3.0, y = 3.0, z = 1.0},
	Type  = -1,
}

CarSteal.VehicleSpawnPoint3 = {
	Pos   = {x = 350.29, y = -2640.67, z = 6.22},
	Size  = {x = 3.0, y = 3.0, z = 1.0},
	Type  = -1,
}

CarSteal.VehicleSpawnPoint4 = {
	Pos   = {x = -489.78, y = -2758.26, z = 6.0},
	Size  = {x = 3.0, y = 3.0, z = 1.0},
	Type  = -1,
}


CarSteal.Delivery = {
	--Desert
	--Trevor Airfield 9.22KM
	Delivery1 = {
		Pos      = {x = 2130.68, y = 4781.32, z = 39.87},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Payment  = 250000,
		Cars = {'zentorno','t20','reaper','italigtb','pfister811'},
	},
	--Lighthouse 9.61KM
	Delivery4 = {
		Pos      = {x = 3333.51, y = 5159.91, z = 17.20},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Payment  = 250000,
		Cars = {'zentorno','t20','reaper','italigtb','pfister811'},
	},
	--House in Paleto 12.94KM
	Delivery7 = {
		Pos      = {x = -437.56, y = 6254.53, z = 29.02},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Payment  = 250000,
		Cars = {'zentorno','t20','reaper','italigtb','pfister811'},
	},
	--Great Ocean Highway 10.47KM
	Delivery10 = {
		Pos      = {x = -2221.19, y = 3480.48, z = 29.89},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Payment  = 250000,
		Cars = {'zentorno','t20','reaper','italigtb','pfister811'},
	},
	--Marina Drive Desert 8.15KM
	Delivery13 = {
		Pos      = {x = 895.02, y = 3603.87, z = 31.72},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Payment  = 250000,
		Cars = {'zentorno','t20','reaper','italigtb','pfister811'},
	},
	 -- New 1 (4.03 km)
	Delivery16 = {
		Pos      = {x = 1088.32, y = 2544.3, z = 54.69},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Payment  = 250000,
		Cars = {'zentorno','t20','reaper','italigtb','pfister811'},
	},
	 -- New 2 (4.85 km)
	Delivery19 = {
		Pos      = {x = -661.25, y = 5819.45, z = 17.33},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Payment  = 250000,
		Cars = {'zentorno','t20','reaper','italigtb','pfister811'},
	},
	-- New 3 (7.24 km)
	Delivery22 = {
		Pos      = {x = -1576.71, y = 5156.49, z = 19.95},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Payment  = 250000,
		Cars = {'zentorno','t20','reaper','italigtb','pfister811'},
	},
	-- New 4 (6.76 km)
	Delivery25 = {
		Pos      = {x = 1597.52, y = 6568.23, z = 13.59},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Payment  = 250000,
		Cars = {'zentorno','t20','reaper','italigtb','pfister811'},
	},
	-- New 5 (61.2 km)
	Delivery28 = {
		Pos      = {x = 1354.5, y = 4370.75, z = 44.31},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1,
		Payment  = 250000,
		Cars = {'zentorno','t20','reaper','italigtb','pfister811'},
	},
}







CarSteal.handleMods = {
	{"fMass", 1800.000000},
	{"fInitialDragCoeff",6.000000},
	{"fPercentSubmerged",85.000000},
	{"fDriveBiasFront",0.100000},
	{"nInitialDriveGears",5},
	{"fInitialDriveForce",0.23000},
	{"fDriveInertia",1.000000},
	{"fClutchChangeRateScaleUpShift",2.500000},
	{"fClutchChangeRateScaleDownShift",2.500000},
	{"fInitialDriveMaxFlatVel",230.000000},
	{"fBrakeForce",4.500000},
	{"fBrakeBiasFront",0.525000},
	{"fHandBrakeForce",1.300000},
	{"fSteeringLock",45.000000},
	{"fTractionCurveMax",3.600000},
	{"fTractionCurveMin",3.400000},
	{"fTractionCurveLateral",25.500000},
	{"fTractionSpringDeltaMax",0.150000},
	{"fLowSpeedTractionLossMult",0.000000},
	{"fAntiRollBarForce",1.000000 },
	{"fAntiRollBarBiasFront",0.300000 },
	{"fRollCentreHeightFront",0.300000 },
	{"fRollCentreHeightRear",0.300000 },
	{"fCollisionDamageMult", 0.500000},
	{"fWeaponDamageMult", 1.000000},
	{"fDeformationDamageMult", 0.500000},
	{"fEngineDamageMult", 1.500000},
	{"fPetrolTankVolume", 65.000000},
	{"fOilVolume", 5.000000},
	{"fSeatOffsetDistX", 0.000000},
	{"fSeatOffsetDistY", 0.000000},
	{"fSeatOffsetDistZ", 0.000000},
	{"nMonetaryValue", 25000},
}

CarSteal.Vec1 = vector3(0.000000, 0.000000, 0.000000)
CarSteal.Vec2 = vector3(1.000000, 1.600000, 1.700000)

CarSteal.handlingData = {
    -- generic handling data
    "handlingName",
    "fMass",
    "fInitialDragCoeff",
    "fPercentSubmerged",
    "vecCentreOfMassOffset",
    "vecInertiaMultiplier",
    "fDriveBiasFront",
    "nInitialDriveGears",
    "fInitialDriveForce",
    "fDriveInertia",
    "fClutchChangeRateScaleUpShift",
    "fClutchChangeRateScaleDownShift",
    "fInitialDriveMaxFlatVel",
    "fBrakeForce",
    "fBrakeBiasFront",
    "fHandBrakeForce",
    "fSteeringLock",
    "fTractionCurveMax",
    "fTractionCurveMin",
    "fTractionCurveLateral",
    "fTractionSpringDeltaMax",
    "fLowSpeedTractionLossMult",
    "fCamberStiffnesss",
    "fTractionBiasFront",
    "fTractionLossMult",
    "fSuspensionForce",
    "fSuspensionCompDamp",
    "fSuspensionReboundDamp",
    "fSuspensionUpperLimit",
    "fSuspensionLowerLimit",
    "fSuspensionRaise",
    "fSuspensionBiasFront",
    "fAntiRollBarForce",
    "fAntiRollBarBiasFront",
    "fRollCentreHeightFront",
    "fRollCentreHeightRear",
    "fCollisionDamageMult",
    "fWeaponDamageMult",
    "fDeformationDamageMult",
    "fEngineDamageMult",
    "fPetrolTankVolume",
    "fOilVolume",
    "fSeatOffsetDistX",
    "fSeatOffsetDistY",
    "fSeatOffsetDistZ",
    "nMonetaryValue",
    "strModelFlags",
    "strHandlingFlags",
    "strDamageFlags",
    "AIHandling",

    -- CCarHandlingData
    "fBackEndPopUpCarImpulseMult",
    "fBackEndPopUpBuildingImpulseMult",
    "fBackEndPopUpMaxDeltaSpeed",
    "fCamberFront",
    "fCamberRear",
    "fCastor",
    "fToeFront",
    "fToeRear",
    "fEngineResistance",
    "strAdvancedFlags",

    -- CFlyingHandlingData

    "fThrust",
    "fThrustFallOff",
    "fThrustVectoring",
    "fYawMult",
    "fYawStabilise",
    "fSideSlipMult",
    "fRollMult",
    "fRollStabilise",
    "fPitchMult",
    "fPitchStabilise",
    "fFormLiftMult",
    "fAttackLiftMult",
    "fAttackDiveMult",
    "fGearDownDragV",
    "fGearDownLiftMult",
    "fWindMult",
    "fMoveRes",
    "vecTurnRes",
    "vecSpeedRes",
    "fGearDoorFrontOpen",
    "fGearDoorRearOpen",
    "fGearDoorRearOpen2",
    "fGearDoorRearMOpen",
    "fTurublenceMagnitudeMax",
    "fTurublenceForceMulti",
    "fTurublenceRollTorqueMulti",
    "fTurublencePitchTorqueMulti",
    "fBodyDamageControlEffectMult",
    "fInputSensitivityForDifficulty",
    "fOnGroundYawBoostSpeedPeak",
    "fOnGroundYawBoostSpeedCap",
    "fEngineOffGlideMulti",
    "handlingType",
    "fThrustFallOff",
    "fThrustFallOff",

    -- CCarHandlingData

    "fBackEndPopUpCarImpulseMult",
    "fBackEndPopUpBuildingImpulseMult",
    "fBackEndPopUpMaxDeltaSpeed",


    -- CBikeHandlingData

    "fLeanFwdCOMMult",
    "fLeanFwdForceMult",
    "fLeanBakCOMMult",
    "fLeanBakForceMult",
    "fMaxBankAngle",
    "fFullAnimAngle",
    "fDesLeanReturnFrac",
    "fStickLeanMult",
    "fBrakingStabilityMult",
    "fInAirSteerMult",
    "fWheelieBalancePoint",
    "fStoppieBalancePoint",
    "fWheelieSteerMult",
    "fRearBalanceMult",
    "fFrontBalanceMult",
    "fBikeGroundSideFrictionMult",
    "fBikeWheelGroundSideFrictionMult",
    "fBikeOnStandLeanAngle",
    "fBikeOnStandSteerAngle",
    "fJumpForce",
}
