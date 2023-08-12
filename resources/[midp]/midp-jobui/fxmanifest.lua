fx_version 'cerulean'
game 'gta5'

ui_page 'html/ui.html'
shared_script '@es_extended/imports.lua'
client_scripts {
	'client.lua',
}

files {
	'html/ui.html',
	'html/style.css',
	'html/grid.css',
	'html/main.js',
}

exports {
	'showIDEnable',
	'showIDDisable',
}
