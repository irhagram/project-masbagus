fx_version 'adamant'
game 'gta5'
lua54 'yes'

ui_page 'html/index.html'

shared_scripts { 
	'@es_extended/imports.lua'
}

client_scripts {
    'client.lua',
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}

files {
    'html/index.html',
    'html/style.css',
}