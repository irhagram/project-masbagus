fx_version 'bodacious'
game 'gta5'
lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua'
}

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/logo.png',
	'html/cursor.png',
	'html/styles.css',
	'html/questions.js',
	'html/scripts.js',
	'html/debounce.min.js'
}

client_scripts {
	'client/*.lua',
	'config.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
	'config.lua'
}