fx_version 'bodacious'
game 'gta5'
lua54 'yes'

ui_page {
	'hud/index.html'
}

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
  '@oxmysql/lib/MySQL.lua'
}

files {
	'locale.js',
  'hud/**/*',
}

-- Function
function alangg(rsc)
  file('modules/' .. rsc .. '/data/html/**/*')
  client_script('modules/' .. rsc .. '/locales/en.lua')
  client_script('modules/' .. rsc .. '/common.lua')
  client_script('modules/' .. rsc .. '/*.lua')
  client_script('modules/' .. rsc .. '/client/*.lua')
  client_script('modules/' .. rsc .. '/client/classes/status.lua')
  client_script('modules/' .. rsc .. '/client/hansolo.lua')
  client_script('modules/' .. rsc .. '/radiovolume.lua')
  server_script('modules/' .. rsc .. '/locales/en.lua')
  server_script('modules/' .. rsc .. '/*.lua')
  server_script('modules/' .. rsc .. '/server/*.lua')
  server_script('modules/' .. rsc .. '/server/yarn_builder.js')
  server_script('modules/' .. rsc .. '/radiotower.lua')
end

-- TODO : CALL EVENT
alangg 'bt_polyzone'
alangg 'mugshot'
alangg 'esx_hunting'
alangg 'qalle_coords'
alangg 'okokContract'

exports {
  'AddCircleZone',
  'AddBoxZone',
  'AddPolyZone',
  'getMugshotUrl',
  'ProgressWithStartEvent',
  'ProgressWithTickEvent',
  'ProgressWithStartAndTick',
}