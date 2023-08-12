fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
	'config.lua'
}

client_scripts {
	'@es_extended/import.lua',
	'@es_extended/threads.lua',
	'client/main.lua',
	'client/tukangayam.lua',
	'client/penjahit.lua',
	'client/tambang.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}