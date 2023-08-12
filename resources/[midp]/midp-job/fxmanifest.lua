fx_version 'adamant'
games { 'gta5' }
lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua',
    '@ox_lib/init.lua',
	'config.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    'locales/*.lua',
    'client/cl_*.lua',
}

server_scripts {
    '@async/async.lua',
	'@oxmysql/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'locales/*.lua',
    'server/sv_*.lua',
}