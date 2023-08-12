RegisterNetEvent('dl-rent:Show', function()
    ESX.TriggerServerCallback('midp-core:cekJob', function(jumlah)
        if jumlah < 1 then
          TriggerEvent('midp-core:sewaspd')
        else
          exports['midp-tasknotify']:DoHudText('error', 'Taxi sedang online, silahkan hubungi taxi!')
        end
    end, 'taxi')
end)

RegisterNetEvent('dl-rent:ShowLah', function()
    ESX.TriggerServerCallback('midp-core:cekJob', function(jumlah)
        if jumlah < 1 then
          TriggerEvent('midp-core:sewaVehLah')
        else
          exports['midp-tasknotify']:DoHudText('error', 'Taxi sedang online, silahkan hubungi taxi!')
        end
    end, 'taxi')
end)

RegisterNetEvent('midp-core:CraftArmor', function()
    ESX.TriggerServerCallback('midp-core:cekJob', function(jumlah)
        if jumlah > 2 then
          TriggerEvent('dl-craft:Armor')
        else
          exports['midp-tasknotify']:DoHudText('error', 'Tidak Cukup Polisi! (minimal 3)')
        end
    end, 'police')
end)

RegisterNetEvent('midp-core:CraftMachine', function()
    ESX.TriggerServerCallback('midp-core:cekJob', function(jumlah)
        if jumlah > 2 then
          TriggerEvent('dl-craft:Machinetools')
        else
          exports['midp-tasknotify']:DoHudText('error', 'Tidak Cukup Polisi! (minimal 3)')
        end
    end, 'police')
end)

RegisterNetEvent('midp-core:CraftRampok', function()
    ESX.TriggerServerCallback('midp-core:cekJob', function(jumlah)
        if jumlah > 2 then
          TriggerEvent('dl-craft:AlartRampok')
        else
          exports['midp-tasknotify']:DoHudText('error', 'Tidak Cukup Polisi! (minimal 3)')
        end
    end, 'police')
end)

RegisterNetEvent('midp-core:CraftPluru', function()
    ESX.TriggerServerCallback('midp-core:cekJob', function(jumlah)
        if jumlah > 2 then
          TriggerEvent('dl-craft:Craftpluru')
        else
          exports['midp-tasknotify']:DoHudText('error', 'Tidak Cukup Polisi! (minimal 3)')
        end
    end, 'police')
end)

RegisterNetEvent('midp-core:CraftBedil', function()
  ESX.TriggerServerCallback('midp-core:cekJob', function(jumlah)
      if jumlah > 2 then
        TriggerEvent('dl-craft:CraftBedil')
      else
        exports['midp-tasknotify']:DoHudText('error', 'Tidak Cukup Polisi! (minimal 3)')
      end
  end, 'police')
end)

RegisterNetEvent('midp-core:sewaspd')
AddEventHandler('midp-core:sewaspd', function()
  TriggerEvent('midp-context:sendMenu', {
    {
      id = 1,
      header = "MIRIP IDP ROLEPLAY",
      txt = ""
    },
    {
      id = 2,
      header = "BMX",
      txt = "Harga : $DL1000",
      params = {
        event = "midp-core:spawnVeh",
        args = {type = 'bmx', price = 1000}
      }
    },
    {
      id = 3,
      header = "Cruiser",
      txt = "Harga $DL1500",
      params = {
        event = "midp-core:spawnVeh",
        args = {type = 'cruiser', price = 1500}
      }
    },
  })
  TriggerEvent('midp-context:sendMenu', {
    {
        id = 0,
        header = "⬅ Kembali",
        txt = "",
        params = {
            event = " "
        }
    },
  })
end)

RegisterNetEvent('midp-core:sewaVehLah')
AddEventHandler('midp-core:sewaVehLah', function()
  TriggerEvent('midp-context:sendMenu', {
    {
      id = 1,
      header = "DAILYLIFE ROLEPLAY",
      txt = ""
    },
    {
      id = 2,
      header = "BMX",
      txt = "Harga : $DL1000",
      params = {
        event = "midp-core:spawnVehLah",
        args = {type = 'bmx', price = 1000}
      }
    },
    {
      id = 3,
      header = "Cruiser",
      txt = "Harga $DL1500",
      params = {
        event = "midp-core:spawnVehLah",
        args = {type = 'cruiser', price = 1500}
      }
    },
  })
  TriggerEvent('midp-context:sendMenu', {
    {
        id = 0,
        header = "⬅ Kembali",
        txt = "",
        params = {
            event = " "
        }
    },
  })
end)

RegisterNetEvent('dl-craft:CraftBedil', function()
  TriggerEvent('midp-context:sendMenu', {
    {
      id = 1,
      header = "Crafting Senjata",
      text = ""
    },
    {
      id = 2,
      header = "Desert Eagle",
      txt = "Tembaga 55, Iron 40, Gold 5, Diamond 4, Weapon Kit 1, Uang Kotor $DL27.250",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'WEAPON_PISTOL50'}
      }
    },
    {
      id = 3,
      header = "TEC-9",
      txt = "Tembaga 85, Iron 70, Gold 10, Diamond 3, Weapon Kit 2, Uang Kotor $DL62.250",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'WEAPON_MACHINEPISTOL'}
      }
    },
    {
      id = 4,
      header = "MICRO SMG",
      txt = "Tembaga 100, Iron 75, Gold 10, Diamond 3, Weapon Kit 2, Uang Kotor $DL112.000",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'WEAPON_MICROSMG'}
      }
    },
    {
      id = 5,
      header = "AK-47",
      txt = "Tembaga 110, Iron 88, Gold 40, Diamond 4, Weapon Kit 5, Uang Kotor $DL141.900",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'WEAPON_ASSAULTRIFLE'}
      }
    },
    {
      id = 6,
      header = "PYTHON MAGNUM",
      txt = "Tembaga 140, Iron 110, Gold 15, Diamond 5, Weapon Kit 8, Uang Kotor $DL269.500",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'WEAPON_REVOLVER_MK2'}
      }
    },
    {
      id = 7,
      header = "HEAVY SNIPER",
      txt = "Tembaga 165, Iron 135, Gold 15, Diamond 6, Weapon Kit 10, Uang Kotor $DL284.750",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'WEAPON_HEAVYSNIPER'}
      }
    },
    {
      id = 8,
      header = "Extended Pistol Clip",
      txt = "Tembaga 40, Iron 20, Uang Kotor $DL30.000",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'at_clip_extended_pistol'}
      }
    },
    {
      id = 9,
      header = "Extended SMG Clip",
      txt = "Tembaga 50, Iron 40, Uang Kotor $DL59.500",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'at_clip_extended_smg'}
      }
    },
    {
      id = 10,
      header = "Extended Rifle Clip",
      txt = "Tembaga 55, Iron 45, Uang Kotor $DL95.250",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'at_clip_extended_rifle'}
      }
    },
    {
      id = 11,
      header = "Extended Sniper Clip",
      txt = "Tembaga 85, Iron 70, Uang Kotor $DL143.250",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'at_clip_extended_sniper'}
      }
    },
  })
  TriggerEvent('midp-context:sendMenu', {
    {
        id = 0,
        header = "⬅ Kembali",
        txt = "",
        params = {
            event = " "
        }
    },
  })
end)

RegisterNetEvent('dl-craft:Craftpluru', function()
  TriggerEvent('midp-context:sendMenu', {
    {
      id = 1,
      header = "Crafting Peluru",
      text = " "
    },
    {
      id = 2,
      header = ".50 AE",
      txt = "Tembaga 40, Iron 20",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'ammo-50'}
      }
    },
    {
      id = 3,
      header = "9mm",
      txt = "Tembaga 40, Iron 20",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'ammo-9'}
      }
    },
    {
      id = 4,
      header = ".45 ACP",
      txt = "Tembaga 40, Iron 20",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'ammo-45'}
      }
    },
    {
      id = 5,
      header = "7.62",
      txt = "Tembaga 60, Iron 30",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'ammo-rifle2'}
      }
    },
    {
      id = 6,
      header = ".44 Magnum",
      txt = "Tembaga 50, Iron 25",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'ammo-44'}
      }
    },
    {
      id = 7,
      header = ".50 BMG",
      txt = "Tembaga 40, Iron 20",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'ammo-heavysniper'}
      }
    },
  })
  TriggerEvent('midp-context:sendMenu', {
    {
        id = 0,
        header = "⬅ Kembali",
        txt = "",
        params = {
            event = " "
        }
    },
  })
end)

RegisterNetEvent('dl-craft:AlartRampok', function()
  TriggerEvent('midp-context:sendMenu', {
    {
      id = 1,
      header = "Crafting Alat Rampok",
      text = " "
    },
    {
      id = 2,
      header = "Thermite",
      txt = "Tembaga 45, Iron 40, Gold 5, Diamond 4, Coke Pooch 2, Uang Kotor $DL 7.750",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'thermite'}
      }
    },
    {
      id = 3,
      header = "Usb Hack",
      txt = "Tembaga 25, Iron 15, Gold 3, Diamond 2, Uang Kotor $DL 14.750",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'hack_usb'}
      }
    },
    {
      id = 4,
      header = "Lockpick",
      txt = "Tembaga 15, Iron 10, Gold 2, Diamond 1, Uang Kotor $DL 8750",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'lockpick'}
      }
    },
    {
      id = 5,
      header = "Laptop",
      txt = "Tembaga 20, Iron 15, Gold 5, Diamond 1, Uang Kotor $DL 12500",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'laptop_h'}
      }
    },
  })
  TriggerEvent('midp-context:sendMenu', {
    {
        id = 0,
        header = "⬅ Kembali",
        txt = "",
        params = {
            event = " "
        }
    },
  })
end)

RegisterNetEvent('dl-craft:Machinetools', function()
  TriggerEvent('midp-context:sendMenu', {
    {
      id = 1,
      header = "Crafting Machine Tools",
      text = " "
    },
    {
      id = 2,
      header = "Repairkit Senjata",
      txt = "Tembaga 45, Iron 40, Gold 5, Uang Kotor $DL 62250",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'repairkit_senjata'}
      }
    },
    {
      id = 3,
      header = "Weapon Kit",
      txt = "Tembaga 30, Iron 25, Gold 3, Uang Kotor $DL 39000",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'kit_senjata'}
      }
    },
  })
  TriggerEvent('midp-context:sendMenu', {
    {
        id = 0,
        header = "⬅ Kembali",
        txt = "",
        params = {
            event = " "
        }
    },
  })
end)

RegisterNetEvent('dl-craft:Armor', function()
  TriggerEvent('midp-context:sendMenu', {
    {
      id = 1,
      header = "Crafting Armor",
      text = " "
    },
    {
      id = 2,
      header = "Armor",
      txt = "Iron 30, Gold 7, Diamond 3, Kain 4, Kulit 4, Uang Kotor $DL 12700",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'armor'}
      }
    },
  })
  TriggerEvent('midp-context:sendMenu', {
    {
        id = 0,
        header = "⬅ Kembali",
        txt = "",
        params = {
            event = " "
        }
    },
  })
end)

RegisterNetEvent('midp-core:masakPedagang')
AddEventHandler('midp-core:masakPedagang', function()
  TriggerEvent('midp-context:sendMenu', {
    {
      id = 1,
      header = "Menu Masak",
      txt = ""
    },
    {
      id = 2,
      header = "Sate",
      txt = "K.Ayam 10, Lemak 10, Sambal 10, Garam 15",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'sate'}
      }
    },
    {
      id = 3,
      header = "Kebab",
      txt = "D.Sapi 10, Lemak 10, Sambal 10, Garam 15",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'kebab'}
      }
    },
    {
      id = 4,
      header = "Bubur Ayam",
      txt = "K.Ayam 10, Air 20, Beras 10, Garam 15",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'buburayam'}
      }
    },
    {
      id = 5,
      header = "Soto",
      txt = "D.Sapi 10, Air 20, Sambal 10, Garam 15",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'soto'}
      }
    },
    {
      id = 6,
      header = "Es Buah",
      txt = "Air 25, Gula 15, Jeruk 20, Botol 10",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'esbuah'}
      }
    },
    {
      id = 7,
      header = "Es Jeruk",
      txt = "Air 25, Gula 15, Jeruk 20, Botol 10",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'esjeruk'}
      }
    },
    {
      id = 8,
      header = "Es Kopyor",
      txt = "Air 25, Gula 15, Susu Murni 15, Botol 10",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'eskopyor'}
      }
    },
    {
      id = 9,
      header = "Susu",
      txt = "Susu Murni 20, Gula 15, Botol 10",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'susu'}
      }
    },
    {
      id = 10,
      header = "Kopi",
      txt = "Air 25, Gula 15, B.Kopi 20, Botol 10",
      params = {
        event = "midp-core:alanMulai",
        args = {type = 'kopi'}
      }
    },
  })
  TriggerEvent('midp-context:sendMenu', {
    {
        id = 0,
        header = "⬅ Kembali",
        txt = "",
        params = {
            event = " "
        }
    },
  })
end)

RegisterNetEvent('midp-core:spawnVeh')
AddEventHandler('midp-core:spawnVeh', function(data)
    local price = data.price
    ESX.Game.SpawnVehicle(data.type, {x = -1039.1832275391, y = -2727.9150390625, z = 20.038572311401}, 319.72, function(callback_vehicle)
        TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
        TriggerServerEvent('midp-core:bayardong', price)
    end)
end)

RegisterNetEvent('midp-core:spawnVehLah')
AddEventHandler('midp-core:spawnVehLah', function(data)
    local price = data.price
    ESX.Game.SpawnVehicle(data.type, {x = -739.74, y = -1306.07, z = 5.0}, 65.03, function(callback_vehicle)
        TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
        TriggerServerEvent('midp-core:bayardong', price)
    end)
end)

RegisterNetEvent('midp-core:alanMulai')
AddEventHandler('midp-core:alanMulai', function(itemId)
	  TriggerServerEvent('midp-core:cekKebutuhan', itemId.type)
end)

RegisterNetEvent('midp-core:mulaiBuat')
AddEventHandler('midp-core:mulaiBuat', function(item)
    isCrafting = true
    MasakHayuk(item)
end)

function MasakHayuk(item)
  if not sibuk then
      sibuk = true
      exports.ox_inventory:Progress({
          duration = Config.ItemsCrafting[item].craftingtime,
          label = 'Proses...',
          useWhileDead = false,
          canCancel = true,
          disable = {
              move = true,
              car = true,
              combat = true,
              mouse = false
          },
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
      }, function(cancel)
          if not cancel then
              isCrafting = false
              TriggerServerEvent('midp-core:giveCraftedItem', item)
              sibuk = false
          else
              sibuk = false
              exports['midp-tasknotify']:DoHudText('error', 'Proses Dibatalkan!')
          end
      end)
   end
end

--TARGET--
local alan = 0

local coordsMasak = {  
	{x = -629.33, y = 223.59, z = 81.88, h = 0},
}

local craftBedil = {  
	{x = 590.98, y = -3282.2, z = 6.07, h = 0},
}

local Craftpluru = {  
	{x = 499.39, y = -1958.68, z = 24.83, h = 0},
}

local MachineTools = {  
	{x = 1343.2, y = 4390.65, z = 44.34, h = 0},
}

local Lockpick = {  
	{x = 144.6, y = -2204.59, z = 4.69, h = 0},
}

local Armor = {  
	{x = -468.47, y = 6289.67, z = 13.61, h = 0},
}

CreateThread(function()
    for k,v in pairs(coordsMasak) do
        alan = alan + 1
          exports["ox_target"]:AddBoxZone("coordsMasak" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
            name = "coordsMasak" .. alan,
            heading = v.h,
            debugPoly = false,
            minZ = v.z - 1.0,
            maxZ = v.z + 2.0
          }, {
            options = {
            {
              event = "midp-core:masakPedagang",
              icon = "fas fa-suitcase",
              label = "Masak",
              job = {
                ["pedagang"] = 0,
              },
            },
          },
          distance = 2.0
        })
    end
      for k,v in pairs(craftBedil) do
        alan = alan + 1
          exports["ox_target"]:AddBoxZone("craftBedil" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
            name = "craftBedil" .. alan,
            heading = v.h,
            debugPoly = false,
            minZ = v.z - 1.0,
            maxZ = v.z + 2.0
          }, {
            options = {
            {
              event = "midp-core:CraftBedil",
              icon = "fas fa-gun",
              label = "Crafting Senjata",
              item = "mafia_card",
              job = {
                ["gang"] = 0,
                ["mafia"] = 0,
                ["cartel"] = 0,
                ["biker"] = 0,
                ["yakuza"] = 0,
                ["ormas"] = 0,
                ["badside7"] = 0,
                ["badside8"] = 0,
                ["badside9"] = 0,
                ["badside10"] = 0,
                ["badside11"] = 0,
                ["badside12"] = 0,
                ["badside13"] = 0,
                ["badside14"] = 0,
              },
            },
            {
              event = "dl-wrepair:RepairBlog",
              icon = "fas fa-gun",
              label = "Repair Senjata",
              job = {
                ["gang"] = 0,
                ["mafia"] = 0,
                ["cartel"] = 0,
                ["biker"] = 0,
                ["yakuza"] = 0,
                ["ormas"] = 0,
                ["badside7"] = 0,
                ["badside8"] = 0,
                ["badside9"] = 0,
                ["badside10"] = 0,
                ["badside11"] = 0,
                ["badside12"] = 0,
                ["badside13"] = 0,
                ["badside14"] = 0,
              },
            },
          },
          distance = 2.0
        })
    end
    for k,v in pairs(Craftpluru) do
      alan = alan + 1
        exports["ox_target"]:AddBoxZone("Craftpluru" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
          name = "Craftpluru" .. alan,
          heading = v.h,
          debugPoly = false,
          minZ = v.z - 1.0,
          maxZ = v.z + 2.0
        }, {
          options = {
          {
            event = "midp-core:CraftPluru",
            icon = "fas fa-gun",
            label = "Crafting Peluru",
            item = "gang_card",
            job = {
              ["gang"] = 0,
              ["mafia"] = 0,
              ["cartel"] = 0,
              ["biker"] = 0,
              ["yakuza"] = 0,
              ["ormas"] = 0,
              ["badside7"] = 0,
              ["badside8"] = 0,
              ["badside9"] = 0,
              ["badside10"] = 0,
              ["badside11"] = 0,
              ["badside12"] = 0,
              ["badside13"] = 0,
              ["badside14"] = 0,
            },
          },
        },
        distance = 2.0
      })
  end
  for k,v in pairs(Lockpick) do
    alan = alan + 1
      exports["ox_target"]:AddBoxZone("Lockpick" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "Lockpick" .. alan,
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
          event = "midp-core:CraftRampok",
          icon = "fas fa-swords-laser",
          label = "Crafting Alat Rampok",
          item = "gang_card",
          job = {
            ["gang"] = 0,
            ["mafia"] = 0,
            ["cartel"] = 0,
            ["biker"] = 0,
            ["yakuza"] = 0,
            ["ormas"] = 0,
            ["badside7"] = 0,
            ["badside8"] = 0,
            ["badside9"] = 0,
            ["badside10"] = 0,
            ["badside11"] = 0,
            ["badside12"] = 0,
            ["badside13"] = 0,
            ["badside14"] = 0,
          },
        },
      },
      distance = 2.0
    })
  end
  for k,v in pairs(MachineTools) do
    alan = alan + 1
      exports["ox_target"]:AddBoxZone("MachineTools" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "MachineTools" .. alan,
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
          event = "midp-core:CraftMachine",
          icon = "fas fa-lock",
          label = "Crafting Machine",
          item = "proses_card",
          job = {
            ["gang"] = 0,
            ["mafia"] = 0,
            ["cartel"] = 0,
            ["biker"] = 0,
            ["yakuza"] = 0,
            ["ormas"] = 0,
            ["badside7"] = 0,
            ["badside8"] = 0,
            ["badside9"] = 0,
            ["badside10"] = 0,
            ["badside11"] = 0,
            ["badside12"] = 0,
            ["badside13"] = 0,
            ["badside14"] = 0,
          },
        },
      },
      distance = 2.0
    })
  end
  for k,v in pairs(Armor) do
    alan = alan + 1
      exports["ox_target"]:AddBoxZone("Armor" .. alan, vector3(v.x, v.y, v.z), 2.0, 2.0, {
        name = "Armor" .. alan,
        heading = v.h,
        debugPoly = false,
        minZ = v.z - 1.0,
        maxZ = v.z + 2.0
      }, {
        options = {
        {
          event = "midp-core:CraftArmor",
          icon = "fas fa-shield-halved",
          label = "Crafting Armor",
          item = "moneywash_card",
          job = {
            ["gang"] = 0,
            ["mafia"] = 0,
            ["cartel"] = 0,
            ["biker"] = 0,
            ["yakuza"] = 0,
            ["ormas"] = 0,
            ["badside7"] = 0,
            ["badside8"] = 0,
            ["badside9"] = 0,
            ["badside10"] = 0,
            ["badside11"] = 0,
            ["badside12"] = 0,
            ["badside13"] = 0,
            ["badside14"] = 0,
          },
        },
      },
      distance = 2.0
    })
  end
end)

CreateThread(function()
  local biker = {
  `a_m_o_acult_02`
  }

  exports['ox_target']:AddTargetModel(biker, {
      options = {
          {
              event = 'dl-rent:Show',
              icon = 'fas fa-car',
              label = "Sewa Sepda"
          },
          {
              event = "ujian",
              icon = "fas fa-car",
              label = "Ambil Starterpack",
          },
      },
      distance = 1.5
  })
end)

CreateThread(function()
  local rwt = {
  `a_m_m_farmer_01`
  }

  exports['ox_target']:AddTargetModel(rwt, {
      options = {
          {
              event = 'dl-rent:ShowLah',
              icon = 'fas fa-car',
              label = "Sewa Sepda"
          },
      },
      distance = 1.5
  })
end)

CreateThread(function()
  local rwt = {
  `cs_movpremmale`
  }

  exports['ox_target']:AddTargetModel(rwt, {
      options = {
        {
          event = "dl-jobs:pilihkerja",
          icon = "fa-solid fa-id-card",
          label = "Ambil Jobs",
        },
      },
      distance = 2.5
  })
end)