--- action functions
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil


--- esx
local GUI = {}
GUI.Time                      = 0
local PlayerData              = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('dl-duty:onoff')
AddEventHandler('dl-duty:onoff', function(job)
   TriggerServerEvent('duty:onoff')
end)

RegisterNetEvent('alan-context:DutyPolice', function()
  TriggerEvent('alan-context:sendMenu', {
      {
          id = 1,
          header = "👮POLISI DAILYLIFE",
          txt = ""
      },
      {
          id = 2,
          header = "⚠️On Duty",
          txt = "ON DUTY",
          params = {
              event = "dl-duty:onoff",
              args = {
                  number = 1,
                  id = 2
              }
          }
      },
      {
          id = 3,
          header = "⚠️Off Duty",
          txt = "OFF DUTY",
          params = {
              event = "dl-duty:onoff",
              args = {
                  number = 1,
                  id = 3
              }
          }
      },
  })
end)

RegisterNetEvent('alan-context:DutyPedagang', function()
    TriggerEvent('alan-context:sendMenu', {
        {
            id = 1,
            header = "PEDAGANG DAILYLIFE",
            txt = ""
        },
        {
            id = 2,
            header = "⚠️On Duty",
            txt = "ON DUTY",
            params = {
                event = "dl-duty:onoff",
                args = {
                    number = 1,
                    id = 2
                }
            }
        },
        {
            id = 3,
            header = "⚠️Off Duty",
            txt = "OFF DUTY",
            params = {
                event = "dl-duty:onoff",
                args = {
                    number = 1,
                    id = 3
                }
            }
        },
    })
  end)

RegisterNetEvent('alan-context:DutyEms', function()
    TriggerEvent('alan-context:sendMenu', {
        {
            id = 1,
            header = "EMS DAILYLIFE",
            txt = ""
        },
        {
            id = 2,
            header = "⚠️On Duty",
            txt = "ON DUTY",
            params = {
                event = "dl-duty:onoff",
                args = {
                    number = 1,
                    id = 2
                }
            }
        },
        {
            id = 3,
            header = "⚠️Off Duty",
            txt = "OFF DUTY",
            params = {
                event = "dl-duty:onoff",
                args = {
                    number = 1,
                    id = 3
                }
            }
        },
    })
end)

RegisterNetEvent('alan-context:DutyTrans', function()
    TriggerEvent('alan-context:sendMenu', {
        {
            id = 1,
            header = "TRANS DAILY",
            txt = ""
        },
        {
            id = 2,
            header = "⚠️On Duty",
            txt = "ON DUTY",
            params = {
                event = "dl-duty:onoff",
                args = {
                    number = 1,
                    id = 2
                }
            }
        },
        {
            id = 3,
            header = "⚠️Off Duty",
            txt = "OFF DUTY",
            params = {
                event = "dl-duty:onoff",
                args = {
                    number = 1,
                    id = 3
                }
            }
        },
    })
end)

exports.ox_target:AddBoxZone("dutypolisi", vector3(441.79,-982.07, 30.69), 2.2, 2.8, {
	name="dutypolisi",
	heading=91,
	--debugPoly=true,
	minZ=26.87,
	maxZ=30.87
	}, {
		options = {
			{
				event = "alan-context:DutyPolice",
				icon = "fas fa-sign-in-alt",
				label = "Duty Management",
                job = {
					["police"] = 0,
					["offpolice"] = 0,
				}
			},
		},
		distance = 2
})

exports.ox_target:AddBoxZone("dutypolisiss", vector3(1852.36, 3687.23, 34.22), 1, 2, {
	name="dutypolisiss",
	heading = 30,
  	--debugPoly = true,
  	minZ = 33.22,
  	maxZ = 37.22
	}, {
		options = {
			{
				event = "alan-context:DutyPolice",
				icon = "fas fa-sign-in-alt",
				label = "Duty Management",
                job = {
					["police"] = 0,
					["offpolice"] = 0,
				}
			},
		},
		distance = 2
})

exports.ox_target:AddBoxZone("dutypolisipal", vector3(-449.0, 6013.92, 31.72), 1, 1, {
	name="dutypolisipal",
	heading = 45,
  	--debugPoly = true,
  	minZ = 30.72,
  	maxZ = 34.72
	}, {
		options = {
			{
				event = "alan-context:DutyPolice",
				icon = "fas fa-sign-in-alt",
				label = "Duty Management",
                job = {
					["police"] = 0,
					["offpolice"] = 0,
				}
			},
		},
		distance = 2
})

exports.ox_target:AddBoxZone("dutyEMSss", vector3(1832.73, 3677.59, 34.28), 1, 2, {
    name = "dutyEMSss",
    heading = 120,
  	--debugPoly = true,
  	minZ = 33.28,
  	maxZ = 37.28
	}, {
		options = {
			{
				event = "alan-context:DutyEms",
				icon = "fas fa-sign-in-alt",
				label = "Duty Management",
                job = {
					["ambulance"] = 0,
					["offambulance"] = 0,
				}
			},
            {
                event = "documents:open",
                icon = "fas fa-clipboard",
                label = "Buat Dokumen",
                job = "ambulance",
            },
            {
                event = "dl-job:tabEMS",
                icon = "fas fa-clipboard",
                label = "Komputer",
                job = "ambulance",
            },
            {
                event = "dl-job:buatKPasien",
                icon = "fas fa-clipboard",
                label = "Buat BPJS",
                job = "ambulance",
            },
            {
                event = "dl-job:buatKBPJS",
                icon = "fas fa-clipboard",
                label = "Buat Kartu Pasien",
                job = "ambulance",
            },
		},
		distance = 2
})

exports.ox_target:AddBoxZone("dutyEMS", vector3(-1851.01, -338.34, 49.45), 1, 1, {
    name = "dutyEMs",
    heading = 320,
    --debugPoly = true,
    minZ = 48.45,
    maxZ = 52.45
	}, {
		options = {
			{
				event = "alan-context:DutyEms",
				icon = "fas fa-sign-in-alt",
				label = "Duty Management",
                job = {
					["ambulance"] = 0,
					["offambulance"] = 0,
				}
			},
            {
                event = "documents:open",
                icon = "fas fa-clipboard",
                label = "Buat Dokumen",
                job = "ambulance",
            },
            {
                event = "dl-job:tabEMS",
                icon = "fas fa-clipboard",
                label = "Komputer",
                job = "ambulance",
            },
            {
                event = "dl-job:buatKPasien",
                icon = "fas fa-clipboard",
                label = "Buat Kartu Pasien",
                job = "ambulance",
            },
            {
                event = "dl-job:buatKBPJS",
                icon = "fas fa-clipboard",
                label = "Buat Kartu BPJS",
                job = "ambulance",
            },
		},
		distance = 2
})