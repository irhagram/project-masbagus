fx_version 'cerulean'
game 'gta5'

author 'nightstudios'
version '1.3'

-- Leaked By: Leaking Hub | J. Snow | leakinghub.com

ui_page 'ui/ui.html'

client_scripts {
	'client/main.lua',
	'config.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua',
	'config.lua'
}

files {
	'ui/ui.html',
	'ui/css/style.css',
	'ui/js/script.js',
	'ui/js/scripts.js',
	'ui/js/bundle.js',
	'ui/css/theme.css',
	'ui/css/dashlite.css',
	'ui/lapd_logo.png'
}
