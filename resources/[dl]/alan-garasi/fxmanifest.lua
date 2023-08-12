fx_version 'bodacious'
game 'gta5'
lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/server.lua'
}

client_scripts {
	'config.lua',
	'client/client.lua'
}