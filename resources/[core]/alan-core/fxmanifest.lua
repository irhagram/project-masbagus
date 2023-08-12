fx_version 'adamant'
game 'gta5'
lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua',
	'core/server.lua',
	'vip/server.lua'
}

client_scripts {
    'client.lua',
	'keybinds.lua',
	'core/client.lua',
	'vip/client.lua'
}

exports {
	"playAnim",
	"addProp"
}