fx_version 'adamant'
game 'gta5'
lua54        'yes'

ui_page "html/index.html"

files ({
    "html/index.html",
    "html/script.js",
    "html/styles.css"
})

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
    'locales/en.lua',
    'config.lua'
}
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/server.lua',
    'server/server_command.lua'
}

client_scripts {
    'warmenu.lua',
    'client/client_command.lua',
    'client/client_menu.lua'
}