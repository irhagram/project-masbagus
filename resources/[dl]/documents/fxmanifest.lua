fx_version   'cerulean'
lua54        'yes'
game         'gta5'

ui_page 'html/form.html'

files {
	'html/**',
	'html/**/**'
}

shared_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'locales/en.lua',
	'@ox_lib/init.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua',
}

client_script 'client.lua'