fx_version 'adamant'
game 'gta5'
shared_script '@es_extended/imports.lua'
client_scripts {
	'config.lua',
	'client.lua',
	'json.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua',
	'json.lua',
	'config.lua',
}

ui_page('web/index.html')

files {
    'config.json',
    'web/index.html',
    'web/script.js',
    'web/style.css'
}