fx_version 'cerulean'
game 'gta5'

ui_page 'html/index.html'

shared_scripts {
	'@es_extended/shared/locale.lua',
	'@es_extended/imports.lua',
	'config.lua',
	'locales/en.lua'
}

client_scripts {
	'client/main.lua',
	'client/decorate.lua',
	'client/TV.lua',
	'client/interior/main.lua',
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/CircleZone.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua',
	'server/TV.lua'
}

files {
	'html/index.html',
	'html/reset.css',
	'html/style.css',
	'html/script.js',
	'html/img/dynasty8-logo.png'
}

lua54 'yes'