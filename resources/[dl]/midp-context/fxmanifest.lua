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
} 

server_scripts {
	'@es_extended/locale.lua',
  '@es_extended/imports.lua',
  '@oxmysql/lib/MySQL.lua'
}

files {
	'locale.js',
  'hud/**/*',
}

dependency 'es_extended'

-- Function
function bismillah(rsc)

  file('modules/' .. rsc .. '/data/html/**/*')
  client_script('modules/' .. rsc .. '/locales/en.lua')
  client_script('modules/' .. rsc .. '/common.lua')
  client_script('modules/' .. rsc .. '/*.lua')
  client_script('modules/' .. rsc .. '/client/*.lua')
  client_script('modules/' .. rsc .. '/locales/*.lua')
  client_script('modules/' .. rsc .. '/client/classes/status.lua')
  client_script('modules/' .. rsc .. '/client/hansolo.lua')
  client_script('modules/' .. rsc .. '/radiovolume.lua')
  server_script('modules/' .. rsc .. '/locales/en.lua')
  server_script('modules/' .. rsc .. '/*.lua')
  server_script('modules/' .. rsc .. '/server/*.lua')
  server_script('modules/' .. rsc .. '/locales/*.lua')
  server_script('modules/' .. rsc .. '/server/yarn_builder.js')
  server_script('modules/' .. rsc .. '/radiotower.lua')
  
end

-- TODO : CALL EVENT
bismillah 'midp-context'
bismillah 'dl-keypad'
bismillah 'mobilrusak'
bismillah 'alan-game'
bismillah 'hacking'

exports {
  'OpenHackingGame',
}