fx_version 'cerulean'
game 'gta5'

shared_scripts {
	'config.lua',
	'@es_extended/shared/locale.lua',
    '@es_extended/imports.lua',
	'locales/en.lua'
}

server_script 'server/server.lua'
client_script 'client/client.lua'

lua54 'yes'
