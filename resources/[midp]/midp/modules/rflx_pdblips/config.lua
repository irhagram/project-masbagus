JobBlip = {}

JobBlip.selfBlip = true -- use classic arrow or job specified blip?
JobBlip.useRflxMulti = false -- server specific init
JobBlip.useBaseEvents = false -- F for optimisation
JobBlip.prints = false -- server side prints (on/off duty)

-- looks
JobBlip.font = {
    useCustom = false, -- use custom font? Has to be specified below, also can be buggy with player tags
    name = 'Russo One', -- > this being inserted into <font face='nameComesHere'> eg. (<font face='Russo One'>) --> Your font has to be streamed and initialized on ur server
}
JobBlip.notifications = {
    enable = true,
    useMythic = true,
    onDutyText = 'GPS Menyala', -- pretty straight foward
    offDutyText = 'GPS Mati', -- pretty straight foward
}
JobBlip.blipGroup = {
    renameGroup = true,
    groupName = '~b~Anggota'
}

-- blips
JobBlip.bigmapTags = false -- Playername tags when bigmap enabled?
JobBlip.blipCone = true -- use that wierd FOV indicators thing?

JobBlip.useCharacterName = true -- use IC name or OOC name, chose your warrior
JobBlip.usePrefix = false
JobBlip.namePrefix = { -- global name prefixes by grade_name 
    recruit = 'CAD.',
    officer = 'P/O-1.',
    officer2 = 'P/O-2.',
    officer3 = 'P/O-3.',
    sergeant = 'SGT-1.',
    sergeant2 = 'SGT-2.',
    lieutenant = 'LTN.',
    captain = 'CAPT.',
    commander = 'COM.',
    deputy = 'DPT.',
    aschief = 'AS-CHF.',
    boss = 'CHF.',

    deputy1 = 'DPT-1.',
    deputy2 = 'DPT-2.',
    assheriff = 'AS-SHRF.',
    undersheriff = 'UNSHRF.',
    boss_shrf = 'SHRF-COP.',
}

--[[
  Full JobBlip template:

    ['police'] = { --> job name in database
        ignoreDuty = true, -- if ignore, you don't need to call onDuty or offDuty by exports or event, player is on map while he has that job
        blip = {
            sprite = 60, -- on foot blip sprite (required)
            color = 29, -- on foot blip color (required)
            scale = 0.8, -- global blip scale 1.0 by default (not required)
            flashColors = { -- blip flash when siren ON! You can define as many colors as you want! //// If you don't want to use flash, then just delete it (not required)
                59,
                29,
            }
        },
        vehBlip = { -- in vehicle blip JobBlip, if you don't want to use it, just delete it (not required)
            ['default'] = { -- global in vehicle blip (required if you have "vehBlip" defined)
                sprite = 56,
                color = 29,
            },
            [`ambluance`] = { -- this overrides 'default' blip by vehicle hash, hash has to be between ` eg. `spawnnamehere`
                sprite = 56,
                color = 29,
            },
            [`police2`] = {
                sprite = 56,
                color = 29,
            }
        },
        gradePrefix = { -- global JobBlip.namePrefix override (not required)
            [0] = 'CAD.', -- 0 = grade number in database | 'CAD. ' is label obv..
        },
        canSee = { -- What job can see this job, when not defined they'll see only self job --> police will see only police blips (not required)
            ['police'] = true,
            ['sheriff'] = true,
            ['shreck'] = true, --> this cfg has to be in specified format "['jobname'] = true"
        }
    },
--]]

JobBlip.emergencyJobs = {
    ['police'] = {
        ignoreDuty = true,
        blip = {
            sprite = 1,
            color = 29,
            flashColors = {
                59,
                29,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 29,
            },
            [`coolpdcar`] = {
                sprite = 56,
                color = 29,
            },
        },
        canSee = {
            ['police'] = true,
            ['fib'] = true,
            ['ambulance'] = false,
            ['admin'] = false,
        }
    },
    ['fib'] = {
        ignoreDuty = true,
        blip = {
            sprite = 1,
            color = 10,
            flashColors = {
                59,
                29,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 29,
            },
            [`coolpdcar`] = {
                sprite = 56,
                color = 29,
            },
        },
        canSee = {
            ['police'] = false,
            ['ambulance'] = false,
            ['fib'] = true,
            ['admin'] = false,
        }
    },
    ['ambulance'] = {
        ignoreDuty = true,
        blip = {
            sprite = 1,
            color = 59,
            flashColors = {
                0,
                59,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 59,
            },
            [`supervolito2`] = {
                sprite = 43,
                color = 59,
            },
        },
        canSee = {
            ['police'] = false,
            ['ambulance'] = true,
            ['admin'] = false,
        }
    },

    ['mechanic'] = {
        ignoreDuty = true,
        blip = {
            sprite = 1,
            color = 10,
            flashColors = {
                0,
                59,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 10,
            },
            [`supervolito2`] = {
                sprite = 43,
                color = 10,
            },
        },
        canSee = {
            ['police'] = false,
            ['ambulance'] = false,
            ['mechanic'] = true,
            ['admin'] = false,
        }
    },
    ['taxi'] = {
        ignoreDuty = true,
        blip = {
            sprite = 1,
            color = 5,
            flashColors = {
                0,
                59,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 5,
            },
            [`supervolito2`] = {
                sprite = 43,
                color = 5,
            },
        },
        canSee = {
            ['police'] = false,
            ['ambulance'] = false,
            ['mechanic'] = false,
            ['taxi'] = true,
            ['admin'] = false,
        }
    },
    ['pedagang'] = {
        ignoreDuty = true,
        blip = {
            sprite = 1,
            color = 25,
            flashColors = {
                0,
                59,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 25,
            },
            [`supervolito2`] = {
                sprite = 43,
                color = 25,
            },
        },
        canSee = {
            ['police'] = false,
            ['ambulance'] = false,
            ['mechanic'] = false,
            ['taxi'] = false,
            ['pedagang'] = true,
            ['admin'] = false,
        }
    },
    ['pemerintah'] = {
        ignoreDuty = true,
        blip = {
            sprite = 1,
            color = 25,
            flashColors = {
                0,
                59,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 25,
            },
            [`supervolito2`] = {
                sprite = 43,
                color = 25,
            },
        },
        canSee = {
            ['pemerintah'] = true,
        }
    },
    ['cardealer'] = {
        ignoreDuty = true,
        blip = {
            sprite = 1,
            color = 21,
            flashColors = {
                0,
                59,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 25,
            },
            [`supervolito2`] = {
                sprite = 43,
                color = 25,
            },
        },
        canSee = {
            ['police'] = false,
            ['cardealer'] = true,
            ['ambulance'] = false,
            ['mechanic'] = false,
            ['taxi'] = false,
            ['pedagang'] = false,
            ['fib'] = false,
            ['montir'] = false,
            ['admin'] = false,
        }
    }
}