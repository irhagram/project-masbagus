fx_version 'adamant'
games { 'gta5' }
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
	'config.lua'
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"server/server.lua"
}

client_scripts {
	"client/utils.lua",
	"client/client.lua"
}