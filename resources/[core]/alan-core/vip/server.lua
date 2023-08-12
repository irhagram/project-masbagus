local webhook = "https://discord.com/api/webhooks/1041761407215091823/vpPyZ3Bh0dG_zCYBGQgaqro-UtOUhxoZBw0ctF9EIoneGyEvb-dlzmutpSkSJCwIeY6A" -- Discord Logs

admins = {
    'steam:11000013f15sdh'
}


-- DON'T CHANGE ANYTHING FROM HERE OR IT WILL BREAK THE RESOURCE

local charset = {}

for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

function string.random(length)
	math.randomseed(os.time())
	if length > 0 then
		return string.random(length - 1) .. charset[math.random(1, #charset)]
	else
		return ""
	end
end

function isWhitelisted(player)
    local whitelisted = false
    for i,id in ipairs(admins) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                whitelisted = true
            end
        end
    end
    return whitelisted
end

RegisterCommand('buatcode', function(source, args)
    if source ~= 0 then
        if isWhitelisted(source) then
            if args ~= nil then
				local t = string.random(10)
				local p = args[1]
				local l = args[2]
				if tonumber(p) and tonumber(l) then
					MySQL.Sync.execute('INSERT INTO daily_kode (transaction, months, level) VALUES (@transaction, @months, @level)', {
						['@transaction'] = t,
						['@months'] = p,
						['@level'] = l
					})
					TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'success', text = 'Kode dibuat, silahkan cek log discord!'})
					local hora = os.date("%d/%m/%Y %X")
					local quien = getIdenti(source)
					local content = {
						{
							["color"] = '12386304',
							["title"] = "**Kode Di Buat**",
							["description"] = '**Kode:** '..t..'\n ** Dibuat Selama:** '..p..' Bulan \n **Level:** '..l..'\n **Dibuat: **'..quien,
							["footer"] = {
								["text"] = hora,
							},
						}
					}
					TriggerEvent('alan-vip:discord',content)
				end
			end
        else
			TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Anda SIAPA?'})
		end
    end
end)

RegisterCommand('tukarcode', function(source, args)
	if args[1] == nil then 
		TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Silahkan input kode yang di beri admin!'})
		return 
	end			
	local clave = tostring(args[1])
	set_vip(source,clave)			
end)

RegisterServerEvent('alan-vip:getVIP')
AddEventHandler('alan-vip:getVIP', function(source, cb)
    local identifier = getIdenti(source)
	
	MySQL.Async.fetchAll("SELECT identifier, level as level, DATE_FORMAT(expiration,'%m-%d-%Y') as expiration FROM daily_vip WHERE identifier = @identifier AND expiration >= CURDATE()", {
		['@identifier'] = identifier
	}, function(vip)
		if vip[1] ~= nil then
			local info = {found = true, vip = true, expiration = vip[1].expiration, level = vip[1].level}
			cb(info)
		else
			local info = {found = false, vip = false, expiration = false, level = 0}
			cb(info)
		end	
	end)
end)

RegisterServerEvent('alan-vip:server:spawn')
AddEventHandler('alan-vip:server:spawn', function()
	local _source = source
	local identifier = getIdenti(source)
	MySQL.Async.fetchAll("SELECT identifier, level as level, DATE_FORMAT(expiration,'%m-%d-%Y') as expiration FROM daily_vip WHERE identifier = @identifier AND expiration >= CURDATE()", {
		['@identifier'] = identifier
	}, function(vip)
		if vip[1] ~= nil then
			local info = {found = true, vip = true, expiration = vip[1].expiration, level = vip[1].level}
			TriggerClientEvent('alan-vip:spawn',_source,info)
		else
			local info = {found = false, vip = false, expiration = false, level = 0}
			TriggerClientEvent('alan-vip:spawn',_source,info)
		end	
	end)
end)

function set_vip(source,id)	
	local result = MySQL.Sync.fetchAll('SELECT * FROM daily_kode WHERE transaction = @transaction', {['@transaction'] = id})
	if result[1] ~= nil then
		local canjeado = result[1].redeemed 
		local meses = result[1].months
		local level = result[1].level		
		if not canjeado then
			MySQL.Async.execute('UPDATE daily_kode SET redeemed = @redeemed WHERE transaction = @transaction', {
				['@redeemed'] = 1,
				['@transaction'] = id
			}, function(redeemed)
				if redeemed then
					add_month(source,meses,level)
					local identi = getIdenti(source)
					local hora = os.date("%d/%m/%Y %X")
					local content = {
						{
							["color"] = '12386304',
							["title"] = "**Kode Di Tukar**",
							["description"] = '**Kode:** '..id..'\n **Identifier:** '..identi..'\n ** Berlaku Selama:** '..meses..' Bualan \n **Level:** '..level..'',
							["footer"] = {
								["text"] = hora,
							},
						}
					}
					TriggerEvent('alan-vip:discord',content)
				end
			end)
		else
			TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Kode sudah di tukar!'})
		end
	else
		TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'error', text = 'Kode tidak valid!'})
	end
end

RegisterCommand('tebex', function(_, arg) 
	local t = arg[1]
	local p = arg[2]
	local l = arg[3]
	MySQL.Sync.execute('INSERT INTO daily_kode (transaction, months, level) VALUES (@transaction, @months, @level)', {
		['@transaction'] = t,
		['@months'] = p,
		['@level'] = l
	})
	local hora = os.date("%d/%m/%Y %X")
	local content = {
		{
			["color"] = '12386304',
			["title"] = "**Memmbuat Kode**",
			["description"] = '**Kode:** '..t..'\n ** Dibuat Selama:** '..p..' Bulan \n **Level:** '..l..'\n **Dibuat :** Alan.gg',
			["footer"] = {
				["text"] = hora,
			},
		}
	}
	TriggerEvent('alan-vip:discord',content)
end,true)

function add_month(source,mes,level)
	local id = getIdenti(source)		
	local t = tonumber(mes)
	local l = tonumber(level)	
	MySQL.Async.fetchAll("SELECT identifier, level as level, DATE_FORMAT(expiration,'%Y-%m-%d') as expiration FROM daily_vip WHERE identifier = @identifier", {
		['@identifier'] = id
	}, function(result)
		if result[1] ~= nil then
			wesentek = result[1].expiration
			if os.date('%Y-%m-%d') >= result[1].expiration then 
				wesentek = os.date('%Y-%m-%d')
			end
			fecha = ",expiration = DATE_ADD('".. wesentek .."', INTERVAL '"..t.."' MONTH)"
			MySQL.Sync.execute('UPDATE daily_vip SET level = @level' .. fecha .. ' WHERE identifier=@identifier', {
				['@identifier'] = id,
				['@level'] = l
			})
			TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'inform', text = 'Kode berhasil ditukar'})
			update(source)
		else
			MySQL.Sync.execute('INSERT INTO daily_vip (identifier, level, expiration) VALUES (@identifier, @level, CURDATE() + INTERVAL '..t..' MONTH)', {
				['@identifier'] = id,
				['@level'] = l
			})
			TriggerClientEvent('alan-tasknotify:client:SendAlert', source, { type = 'inform', text = 'Kode berhasil ditukar'})
			update(source)
		end	
	end)
end	

function update(s)
	local _source = s
	local identifier = getIdenti(s)
	MySQL.Async.fetchAll("SELECT identifier, level as level, DATE_FORMAT(expiration,'%m-%d-%Y') as expiration FROM daily_vip WHERE identifier = @identifier AND expiration >= CURDATE()", {
		['@identifier'] = identifier
	}, function(vip)
		if vip[1] ~= nil then
			local info = {found = true, vip = true, expiration = vip[1].expiration, level = vip[1].level}
			TriggerClientEvent('alan-vip:spawn',_source,info)
		else
			local info = {found = false, vip = false, expiration = false, level = 0}
			TriggerClientEvent('alan-vip:spawn',_source,info)
		end	
	end)
end

function getIdenti(source)
	for k,v in pairs(GetPlayerIdentifiers(source))do       
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			return v
		end
	end
end

RegisterServerEvent('alan-vip:discord')
AddEventHandler('alan-vip:discord', function(content)
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end)
