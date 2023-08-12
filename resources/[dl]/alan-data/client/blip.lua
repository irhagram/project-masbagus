local blips = {
  {title="Pemakaman", colour=1, id=310, x = -1763.03, y = -262.64, z = 48.22},
  {title="Pernikahan", colour=48, id=181, x = -1485.72, y = -1479.24, z = 4.64},

  {title="Perumahan Dailylife", colour=2, id=492, x = 1131.8, y = -565.14, z = 56.7},
  {title="Kapal Persiar", colour=0, id=455, x = -2043.974, y = -1031.582, z = 11.981},
  {title="Kapal Persiar", colour=0, id=455, x = -1469.65, y = 6768.03, z = 8.1},
  {title="Dermaga Nelayan", colour=38, id=68, x = 3867.44, y = 4463.62, z = 1.72},
  {title="Pabrik Kayu", colour=4, id=237, x = -489.07, y = 5473.55, z = 69.50},
  {title="Tambang", colour=5, id=318, x = 2954.23, y = 2792.36, z = 42.39},
  {title="Kandang Ayam", colour=5, id=484, x = -62.90, y = 6241.46, z = 30.09},
  {title="Bengkel | Mekanik", colour=2, id=643,x = 55.51,  y = 6517.95, z = 32.84},
  {title="Polres", colour=29, id=60, x = 425.1, y = -979.5, z = 30.7},
  {title="Polsek", colour=29, id=60, x = 1858.43, y = 3679.46, z = 33.73},
  {title="Polsek", colour=29, id=60, x = -437.37, y = 6022.26, z = 31.49},
  {title="Lapas", colour=29, id=60, x = 1848.39, y = 2586.14, z = 45.67},
  {title="Puskesmas", colour=2, id=61, x = 1839.9252929688, y = 3671.3820800781, z = 34.280338287354 },
  {title="Rumah Sakit", colour=2, id=61, x = -1862.360474, y = -355.358246, z = 49.213135 },  
  {title="Pangkalan Taxi & Ojek", colour=3, id=280, x = -1034.49, y = -2730.69, z = 20.03}, 
  {title="Pangkalan Taxi & Ojek", colour=3, id=280, x = 244.06, y = -582.23, z = 43.21},
  {title="Pangkalan Taxi & Ojek", colour=3, id=280, x = 369.81, y = -947.29, z = 29.44},
  {title="Pangkalan Taxi & Ojek", colour=3, id=280, x = -404.64, y = 1196.71, z = 325.94},
  {title="Pangkalan Taxi & Ojek", colour=3, id=280, x = 1082.2464599609, y = -772.42614746094, z = 57.925758361816},
  {title="Terjun Payung", colour=8, id=94, x = 501.82, y = 5604.86, z = 797.91},
  {title="Gym", colour=7, id=311, x = -1199.69, y = -1571.61, z = 4.61},
  {title="Disnaker/Kantor Walikota", colour=64, id=590, x = -425.604401, y = 1123.938477, z = 325.836670},    

  ---------------------------------------------------------------------------------------------

  {title="Kantor Nelayan", colour=38, id=68, x = 868.39, y = -1639.75, z = 29.33},
  {title="Kantor T. Kayu", colour=4, id=237, x = 1200.63, y = -1276.87, z = 34.38},
  {title="Kantor Tambang", colour=5, id=318, x = 892.35, y = -2172.77, z = 31.28},
  {title="Kantor T. Ayam", colour=5, id=484, x = -1071.13, y = -2003.78, z = 14.78},
  {title="Kantor Penjahit", colour=4, id=366, x = 706.73, y = -960.90, z = 29.39},
  {title="Kantor T.Minyak", colour=5, id=436, x = 556.69, y = -2328.04, z = 5.85},
  {title="Terminal", colour=4, id=513, x = -820.43, y = 1745.5, z = 203.41},

  ---------------------------------------------------------------------------------------------

  {title="Tequil-La La", colour=27, id=93, x=-565.906, y=276.093, z=100.176},
  {title="Bahamas", colour=27, id=93, x =-1388.409, y =-585.624, z =100.319},
  {title="Yellow Jack", colour=27, id=93, x =1992.69, y =3058.57, z =100.319},
  {title="Lounge/Pedagang", colour=27, id=93, x =-625.79, y =247.28, z =81.63},
  {title="Gudang Kota", colour=3, id=473, x = -1607.61, y =  -831.04, z = 10.08},
  {title="Gudang Paleto", colour=3, id=473, x = 147.41, y =   6366.67, z = 31.53},
}

CreateThread(function()
    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.55)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)