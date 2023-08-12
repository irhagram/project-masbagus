fx_version 'adamant'
games { 'gta5' }

shared_script '@es_extended/imports.lua'

client_scripts {
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config.lua',
    'client/a_*.lua',
    'client/cl_*.lua'
}

server_scripts {
    '@async/async.lua',
	'@oxmysql/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config.lua',
    'server/sv_*.lua',
    'server/classes/*.lua'
}