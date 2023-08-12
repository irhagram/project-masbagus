fx_version 'bodacious'
game 'gta5'
lua54 'yes'

ui_page {
	'hud/index.html'
}

shared_script '@es_extended/imports.lua'

client_scripts {
	'@es_extended/client/wrapper.lua',
	'@es_extended/locale.lua',
	'client.lua',
  '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
} 

server_scripts {
	'@es_extended/locale.lua',
  '@async/async.lua',
  '@oxmysql/lib/MySQL.lua'
}

files {
	'locale.js',
  'hud/**/*',
}

function alan(rsc)
  file('modules/' .. rsc .. '/data/html/**/*')
  client_script('modules/' .. rsc .. '/locales/en.lua')
  client_script('modules/' .. rsc .. '/common.lua')
  client_script('modules/' .. rsc .. '/*.lua')
  client_script('modules/' .. rsc .. '/client/*.lua')
  client_script('modules/' .. rsc .. '/locales/*.lua')
  client_script('modules/' .. rsc .. '/client/classes/status.lua')
  server_script('modules/' .. rsc .. '/locales/en.lua')
  server_script('modules/' .. rsc .. '/*.lua')
  server_script('modules/' .. rsc .. '/server/*.lua')
  server_script('modules/' .. rsc .. '/locales/*.lua')
end

alan 'banking'
alan 'idcard2'
alan 'savearmor'
alan 'basicneeds'
alan 'gudang'
alan 'simmaker'
alan 'rflx_pdblips'
alan 'nitro'
alan 'GetOut'
alan 'plat'

exports {
  'AddStress',
  'RemoveStress'
}